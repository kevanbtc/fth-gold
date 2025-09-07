// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../script/Deploy.s.sol";

/**
 * @title EndToEndTest
 * @dev Complete end-to-end testing of FTH Gold system
 */
contract EndToEndTest is Test {
    Deploy.DeployedContracts public contracts;
    Deploy public deployer;
    
    address public admin = makeAddr("admin");
    address public treasury = makeAddr("treasury");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public guardian = makeAddr("guardian");
    
    uint256 constant USDT_PER_KG = 20000e6;
    uint256 constant LOCK_PERIOD = 150 days;

    function setUp() public {
        // Deploy entire system
        deployer = new Deploy();
        
        vm.setEnv("ADMIN_MULTISIG", vm.toString(admin));
        vm.setEnv("TREASURY_ADDRESS", vm.toString(treasury));
        vm.setEnv("USDT_PER_KG", vm.toString(USDT_PER_KG));
        
        contracts = deployer.run();
        
        // Grant guardian role
        vm.prank(admin);
        KYCSoulbound(contracts.kyc).grantRole(
            KYCSoulbound(contracts.kyc).GUARDIAN_ROLE(),
            guardian
        );
    }

    function test_complete_user_journey() public {
        // 1. Issue KYC for user
        vm.prank(admin);
        KYCSoulbound(contracts.kyc).issueKYC(
            user1,
            KYCSoulbound.KYCData({
                idHash: keccak256(abi.encodePacked(user1, "id")),
                passportHash: keccak256(abi.encodePacked(user1, "passport")),
                expiry: uint48(block.timestamp + 365 days),
                jurisdiction: 840, // US
                accredited: true,
                riskScore: 200
            })
        );
        
        // Verify KYC issued
        assertTrue(KYCSoulbound(contracts.kyc).isKYCValid(user1));
        assertTrue(KYCSoulbound(contracts.kyc).isAccredited(user1));
        
        // 2. User stakes USDT
        MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
        usdt.mint(user1, 100000e6); // 100K USDT
        
        vm.startPrank(user1);
        usdt.approve(contracts.stakeLocker, USDT_PER_KG);
        StakeLocker(contracts.stakeLocker).stake(1); // 1 kg
        vm.stopPrank();
        
        // Verify stake created
        assertEq(FTHStakeReceipt(contracts.stakeReceipt).balanceOf(user1), 1e18);
        assertEq(usdt.balanceOf(treasury), USDT_PER_KG);
        
        // 3. Wait for lock period
        (bool ready, uint256 timeRemaining) = FTHStakeReceipt(contracts.stakeReceipt).isStakeReady(user1);
        assertFalse(ready);
        assertGt(timeRemaining, 0);
        
        // Fast forward past lock period
        vm.warp(block.timestamp + LOCK_PERIOD + 1);
        
        // 4. Convert stake to FTH-G
        (ready,) = FTHStakeReceipt(contracts.stakeReceipt).isStakeReady(user1);
        assertTrue(ready);
        
        vm.prank(user1);
        StakeLocker(contracts.stakeLocker).convert();
        
        // Verify conversion
        assertEq(FTHGold(contracts.fthGold).balanceOf(user1), 1e18); // 1 FTH-G
        assertEq(FTHStakeReceipt(contracts.stakeReceipt).balanceOf(user1), 0); // Receipt burned
        
        // 5. Test system metrics
        (
            uint256 totalStakedKg,
            uint256 availableCapacity,
            uint256 currentCoverageRatio,
            bool porHealthy,
            uint256 currentPrice
        ) = StakeLocker(contracts.stakeLocker).getSystemMetrics();
        
        assertEq(totalStakedKg, 0); // Stake was converted
        assertGt(availableCapacity, 0);
        assertTrue(porHealthy);
    }

    function test_multiple_users_concurrent_operations() public {
        address[] memory users = new address[](5);
        for (uint256 i = 0; i < 5; i++) {
            users[i] = makeAddr(string(abi.encodePacked("user_", vm.toString(i))));
            
            // Issue KYC
            vm.prank(admin);
            KYCSoulbound(contracts.kyc).issueKYC(
                users[i],
                KYCSoulbound.KYCData({
                    idHash: keccak256(abi.encodePacked(users[i], "id")),
                    passportHash: keccak256(abi.encodePacked(users[i], "passport")),
                    expiry: uint48(block.timestamp + 365 days),
                    jurisdiction: 840,
                    accredited: true,
                    riskScore: 150
                })
            );
            
            // Give USDT and stake
            MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
            usdt.mint(users[i], 50000e6); // 50K USDT
            
            vm.startPrank(users[i]);
            usdt.approve(contracts.stakeLocker, USDT_PER_KG * 2);
            StakeLocker(contracts.stakeLocker).stake(2); // 2 kg each
            vm.stopPrank();
        }
        
        // Verify all stakes
        for (uint256 i = 0; i < 5; i++) {
            assertEq(FTHStakeReceipt(contracts.stakeReceipt).balanceOf(users[i]), 2e18);
        }
        
        // Fast forward and batch convert
        vm.warp(block.timestamp + LOCK_PERIOD + 1);
        
        vm.prank(admin);
        StakeLocker(contracts.stakeLocker).batchConvert(users);
        
        // Verify all conversions
        for (uint256 i = 0; i < 5; i++) {
            assertEq(FTHGold(contracts.fthGold).balanceOf(users[i]), 2e18);
            assertEq(FTHStakeReceipt(contracts.stakeReceipt).balanceOf(users[i]), 0);
        }
        
        // Total FTH-G should be 10 kg
        assertEq(FTHGold(contracts.fthGold).totalSupplyKg(), 10);
    }

    function test_emergency_pause_and_resume() public {
        // Issue KYC and give USDT
        _setupUser(user1);
        
        MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
        
        // Pause system
        vm.prank(guardian);
        StakeLocker(contracts.stakeLocker).pause();
        
        // Staking should fail
        vm.startPrank(user1);
        usdt.approve(contracts.stakeLocker, USDT_PER_KG);
        vm.expectRevert();
        StakeLocker(contracts.stakeLocker).stake(1);
        vm.stopPrank();
        
        // Unpause system
        vm.prank(guardian);
        StakeLocker(contracts.stakeLocker).unpause();
        
        // Staking should work now
        vm.startPrank(user1);
        StakeLocker(contracts.stakeLocker).stake(1);
        vm.stopPrank();
        
        assertEq(FTHStakeReceipt(contracts.stakeReceipt).balanceOf(user1), 1e18);
    }

    function test_coverage_ratio_enforcement() public {
        _setupUser(user1);
        
        MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
        
        // Stake successfully (coverage should be sufficient)
        vm.startPrank(user1);
        usdt.approve(contracts.stakeLocker, USDT_PER_KG);
        StakeLocker(contracts.stakeLocker).stake(1);
        vm.stopPrank();
        
        // Fast forward and convert
        vm.warp(block.timestamp + LOCK_PERIOD + 1);
        vm.prank(user1);
        StakeLocker(contracts.stakeLocker).convert();
        
        // Now reduce vault holdings to trigger coverage failure
        vm.prank(admin);
        ChainlinkPoRAdapter(contracts.porAdapter).setEmergencyOverride(true, 100); // Only 100 kg
        
        // Setup second user
        _setupUser(user2);
        usdt.mint(user2, 50000e6);
        
        // Second user's stake should fail due to insufficient coverage
        vm.startPrank(user2);
        usdt.approve(contracts.stakeLocker, USDT_PER_KG);
        vm.expectRevert();
        StakeLocker(contracts.stakeLocker).stake(1);
        vm.stopPrank();
    }

    function test_kyc_expiry_and_renewal() public {
        // Issue short-term KYC
        vm.prank(admin);
        KYCSoulbound(contracts.kyc).issueKYC(
            user1,
            KYCSoulbound.KYCData({
                idHash: keccak256(abi.encodePacked(user1, "id")),
                passportHash: keccak256(abi.encodePacked(user1, "passport")),
                expiry: uint48(block.timestamp + 1 days),
                jurisdiction: 840,
                accredited: true,
                riskScore: 100
            })
        );
        
        MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
        usdt.mint(user1, 50000e6);
        
        // Should be able to stake initially
        vm.startPrank(user1);
        usdt.approve(contracts.stakeLocker, USDT_PER_KG);
        StakeLocker(contracts.stakeLocker).stake(1);
        vm.stopPrank();
        
        // Fast forward past KYC expiry but before lock expiry
        vm.warp(block.timestamp + 2 days);
        
        assertFalse(KYCSoulbound(contracts.kyc).isKYCValid(user1));
        
        // Fast forward past lock period
        vm.warp(block.timestamp + LOCK_PERIOD);
        
        // Conversion should fail due to expired KYC
        vm.prank(user1);
        vm.expectRevert();
        StakeLocker(contracts.stakeLocker).convert();
        
        // Renew KYC
        vm.prank(admin);
        KYCSoulbound(contracts.kyc).updateKYC(
            user1,
            KYCSoulbound.KYCData({
                idHash: keccak256(abi.encodePacked(user1, "id")),
                passportHash: keccak256(abi.encodePacked(user1, "passport")),
                expiry: uint48(block.timestamp + 365 days),
                jurisdiction: 840,
                accredited: true,
                riskScore: 100
            })
        );
        
        // Conversion should work now
        vm.prank(user1);
        StakeLocker(contracts.stakeLocker).convert();
        
        assertEq(FTHGold(contracts.fthGold).balanceOf(user1), 1e18);
    }

    function test_gas_optimization() public {
        _setupUser(user1);
        
        MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
        
        // Measure gas for staking
        vm.startPrank(user1);
        usdt.approve(contracts.stakeLocker, USDT_PER_KG);
        
        uint256 gasStart = gasleft();
        StakeLocker(contracts.stakeLocker).stake(1);
        uint256 gasUsed = gasStart - gasleft();
        vm.stopPrank();
        
        // Should be under 200k gas
        assertLt(gasUsed, 200_000, "Staking uses too much gas");
        
        // Measure gas for conversion
        vm.warp(block.timestamp + LOCK_PERIOD + 1);
        
        vm.prank(user1);
        gasStart = gasleft();
        StakeLocker(contracts.stakeLocker).convert();
        gasUsed = gasStart - gasleft();
        
        // Should be under 150k gas
        assertLt(gasUsed, 150_000, "Conversion uses too much gas");
    }

    function _setupUser(address user) internal {
        vm.prank(admin);
        KYCSoulbound(contracts.kyc).issueKYC(
            user,
            KYCSoulbound.KYCData({
                idHash: keccak256(abi.encodePacked(user, "id")),
                passportHash: keccak256(abi.encodePacked(user, "passport")),
                expiry: uint48(block.timestamp + 365 days),
                jurisdiction: 840,
                accredited: true,
                riskScore: 100
            })
        );
        
        MockUSDT usdt = MockUSDT(StakeLocker(contracts.stakeLocker).USDT());
        usdt.mint(user, 100000e6);
    }
}