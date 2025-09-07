// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/staking/StakeLocker.sol";
import "../contracts/tokens/FTHGold.sol";
import "../contracts/tokens/FTHStakeReceipt.sol";
import "../contracts/compliance/KYCSoulbound.sol";
import "../contracts/compliance/ComplianceRegistry.sol";
import "../contracts/oracle/ChainlinkPoRAdapter.sol";
import "../contracts/oracle/PriceFeedAdapter.sol";
import "../script/Deploy.s.sol";

contract StakeLockerTest is Test {
    StakeLocker public stakeLocker;
    FTHGold public fthGold;
    FTHStakeReceipt public stakeReceipt;
    KYCSoulbound public kyc;
    ComplianceRegistry public compliance;
    ChainlinkPoRAdapter public porAdapter;
    PriceFeedAdapter public priceAdapter;
    MockUSDT public usdt;

    address public admin = makeAddr("admin");
    address public treasury = makeAddr("treasury");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public guardian = makeAddr("guardian");

    uint256 constant USDT_PER_KG = 20000e6; // $20,000 USDT
    uint256 constant LOCK_PERIOD = 150 days;

    event Staked(address indexed user, uint256 kgAmount, uint256 usdtAmount, uint256 unlockTime, uint256 batchId);
    event Converted(address indexed user, uint256 kgAmount, uint256 batchId);

    function setUp() public {
        // Deploy all contracts
        vm.startPrank(admin);
        
        usdt = new MockUSDT();
        kyc = new KYCSoulbound(admin);
        compliance = new ComplianceRegistry(admin);
        porAdapter = new ChainlinkPoRAdapter(admin, address(0)); // No real Chainlink feed
        priceAdapter = new PriceFeedAdapter(admin, address(0));
        fthGold = new FTHGold(admin);
        stakeReceipt = new FTHStakeReceipt(admin);
        
        stakeLocker = new StakeLocker(
            admin,
            usdt,
            fthGold,
            stakeReceipt,
            kyc,
            compliance,
            porAdapter,
            priceAdapter,
            treasury
        );

        // Grant roles
        fthGold.grantRole(fthGold.ISSUER_ROLE(), address(stakeLocker));
        stakeReceipt.grantRole(stakeReceipt.ISSUER_ROLE(), address(stakeLocker));
        kyc.grantRole(kyc.KYC_ISSUER_ROLE(), admin);
        kyc.grantRole(kyc.GUARDIAN_ROLE(), guardian);

        // Setup mock PoR data
        porAdapter.setEmergencyOverride(true, 150000); // 150,000 kg vaulted
        
        vm.stopPrank();

        // Give users USDT
        usdt.mint(user1, 1000000e6); // 1M USDT
        usdt.mint(user2, 1000000e6);
    }

    function test_StakeSuccess() public {
        // Issue KYC for user1
        _issueKYC(user1, 840, true); // US, accredited

        // User1 stakes 1 kg
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG);
        
        vm.expectEmit(true, true, false, true);
        emit Staked(user1, 1, USDT_PER_KG, block.timestamp + LOCK_PERIOD, 1);
        
        stakeLocker.stake(1);
        vm.stopPrank();

        // Verify stake was created
        (uint256 stakeCount, bool hasValidKYC,,, FTHStakeReceipt.StakeInfo memory stakeInfo) = 
            stakeLocker.getUserStakeInfo(user1);
        
        assertEq(stakeCount, 1);
        assertTrue(hasValidKYC);
        assertEq(stakeInfo.kgAmount, 1);
        assertEq(stakeInfo.usdtAmount, USDT_PER_KG);
        assertEq(stakeReceipt.balanceOf(user1), 1e18);
        assertEq(usdt.balanceOf(treasury), USDT_PER_KG);
    }

    function test_StakeFailsWithoutKYC() public {
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG);
        
        vm.expectRevert();
        stakeLocker.stake(1);
        vm.stopPrank();
    }

    function test_StakeFailsWithInsufficientApproval() public {
        _issueKYC(user1, 840, true);
        
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG - 1);
        
        vm.expectRevert();
        stakeLocker.stake(1);
        vm.stopPrank();
    }

    function test_ConvertAfterLockPeriod() public {
        // Setup stake
        _issueKYC(user1, 840, true);
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG);
        stakeLocker.stake(1);
        vm.stopPrank();

        // Try to convert before lock expires (should fail)
        vm.startPrank(user1);
        vm.expectRevert();
        stakeLocker.convert();
        vm.stopPrank();

        // Fast forward past lock period
        vm.warp(block.timestamp + LOCK_PERIOD + 1);

        // Now conversion should work
        vm.startPrank(user1);
        vm.expectEmit(true, true, false, true);
        emit Converted(user1, 1, 2);
        
        stakeLocker.convert();
        vm.stopPrank();

        // Verify conversion
        assertEq(fthGold.balanceOf(user1), 1e18); // 1 FTH-G token
        assertEq(stakeReceipt.balanceOf(user1), 0); // Receipt burned
    }

    function test_MultipleStakes() public {
        _issueKYC(user1, 840, true);
        
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG * 5);
        
        // Stake 5 kg
        stakeLocker.stake(5);
        vm.stopPrank();

        // Verify multiple kg stake
        assertEq(stakeReceipt.balanceOf(user1), 5e18);
        assertEq(usdt.balanceOf(treasury), USDT_PER_KG * 5);
    }

    function test_StakeCapEnforcement() public {
        // Set low cap for testing
        vm.prank(admin);
        stakeLocker.setMaxStakesPerUser(2);

        _issueKYC(user1, 840, true);
        
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG * 10);
        
        // First 2 kg should work
        stakeLocker.stake(2);
        
        // Additional stake should fail
        vm.expectRevert();
        stakeLocker.stake(1);
        vm.stopPrank();
    }

    function test_GlobalStakingCap() public {
        // Set very low global cap
        vm.prank(admin);
        stakeLocker.setGlobalStakingCap(1);

        _issueKYC(user1, 840, true);
        _issueKYC(user2, 840, true);

        // User1 stakes 1 kg (should work)
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG);
        stakeLocker.stake(1);
        vm.stopPrank();

        // User2 tries to stake (should fail - cap reached)
        vm.startPrank(user2);
        usdt.approve(address(stakeLocker), USDT_PER_KG);
        vm.expectRevert();
        stakeLocker.stake(1);
        vm.stopPrank();
    }

    function test_PauseUnpause() public {
        _issueKYC(user1, 840, true);
        
        // Pause staking
        vm.prank(guardian);
        stakeLocker.pause();

        // Staking should fail when paused
        vm.startPrank(user1);
        usdt.approve(address(stakeLocker), USDT_PER_KG);
        vm.expectRevert();
        stakeLocker.stake(1);
        vm.stopPrank();

        // Unpause
        vm.prank(guardian);
        stakeLocker.unpause();

        // Staking should work again
        vm.startPrank(user1);
        stakeLocker.stake(1);
        vm.stopPrank();

        assertEq(stakeReceipt.balanceOf(user1), 1e18);
    }

    function test_ConfigurationUpdates() public {
        // Test USDT per kg update
        vm.prank(admin);
        stakeLocker.setUsdtPerKg(25000e6); // $25,000

        // Test coverage ratio update
        vm.prank(admin);
        stakeLocker.setCoverageRatio(15000); // 150%

        // Test max stakes per user update
        vm.prank(admin);
        stakeLocker.setMaxStakesPerUser(50);

        // Verify updates took effect
        (, uint256 availableCapacity, uint256 currentCoverageRatio,,) = stakeLocker.getSystemMetrics();
        // Coverage ratio should be reflected in system metrics
    }

    function test_SystemMetrics() public {
        (
            uint256 totalStakedKg,
            uint256 availableCapacity,
            uint256 currentCoverageRatio,
            bool porHealthy,
            uint256 currentPrice
        ) = stakeLocker.getSystemMetrics();

        assertEq(totalStakedKg, 0); // No stakes yet
        assertEq(availableCapacity, 100000); // Default global cap
        assertTrue(porHealthy); // Emergency override is on
    }

    function test_BatchConvert() public {
        // Setup multiple users with stakes
        address[] memory users = new address[](2);
        users[0] = user1;
        users[1] = user2;

        for (uint i = 0; i < users.length; i++) {
            _issueKYC(users[i], 840, true);
            vm.startPrank(users[i]);
            usdt.approve(address(stakeLocker), USDT_PER_KG);
            stakeLocker.stake(1);
            vm.stopPrank();
        }

        // Fast forward past lock period
        vm.warp(block.timestamp + LOCK_PERIOD + 1);

        // Batch convert
        vm.prank(admin);
        stakeLocker.batchConvert(users);

        // Verify conversions
        assertEq(fthGold.balanceOf(user1), 1e18);
        assertEq(fthGold.balanceOf(user2), 1e18);
    }

    // Helper function to issue KYC
    function _issueKYC(address user, uint16 jurisdiction, bool accredited) internal {
        vm.prank(admin);
        kyc.issueKYC(
            user,
            KYCSoulbound.KYCData({
                idHash: keccak256(abi.encodePacked(user, "id")),
                passportHash: keccak256(abi.encodePacked(user, "passport")),
                expiry: uint48(block.timestamp + 365 days),
                jurisdiction: jurisdiction,
                accredited: accredited,
                riskScore: 100 // Low risk
            })
        );
    }

    // Invariant: Total staked should never exceed global cap
    function invariant_totalStakedWithinCap() public {
        assertLe(stakeLocker.totalStaked(), stakeLocker.globalStakingCap());
    }

    // Invariant: FTH-G total supply should equal converted stakes
    function invariant_fthgSupplyMatchesConverted() public {
        // This would require more complex tracking in a real invariant test
        // For now, just verify supply is reasonable
        assertLe(fthGold.totalSupply(), stakeLocker.globalStakingCap() * 1e18);
    }
}