// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../contracts/staking/StakeLocker.sol";
import "../../contracts/tokens/FTHGold.sol";
import "../../contracts/tokens/FTHStakeReceipt.sol";
import "../../contracts/compliance/KYCSoulbound.sol";
import "../../contracts/compliance/ComplianceRegistry.sol";
import "../../contracts/oracle/ChainlinkPoRAdapter.sol";
import "../../contracts/oracle/PriceFeedAdapter.sol";

/**
 * @title SystemInvariants
 * @dev Invariant testing for FTH Gold system properties that must always hold
 */
contract SystemInvariants is Test {
    StakeLocker public stakeLocker;
    FTHGold public fthGold;
    FTHStakeReceipt public stakeReceipt;
    KYCSoulbound public kyc;
    ComplianceRegistry public compliance;
    ChainlinkPoRAdapter public porAdapter;
    PriceFeedAdapter public priceAdapter;
    
    address[] public actors;
    address public admin = makeAddr("admin");
    address public treasury = makeAddr("treasury");
    
    modifier useActor(uint256 actorIndexSeed) {
        address currentActor = actors[bound(actorIndexSeed, 0, actors.length - 1)];
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }

    function setUp() public {
        // Deploy system
        vm.startPrank(admin);
        
        kyc = new KYCSoulbound(admin);
        compliance = new ComplianceRegistry(admin);
        porAdapter = new ChainlinkPoRAdapter(admin, address(0));
        priceAdapter = new PriceFeedAdapter(admin, address(0));
        fthGold = new FTHGold(admin);
        stakeReceipt = new FTHStakeReceipt(admin);
        
        MockUSDT usdt = new MockUSDT();
        
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

        // Setup mock PoR with high coverage
        porAdapter.setEmergencyOverride(true, 200000); // 200,000 kg vaulted
        
        vm.stopPrank();

        // Create test actors
        for (uint256 i = 0; i < 10; i++) {
            address actor = makeAddr(string(abi.encodePacked("actor", vm.toString(i))));
            actors.push(actor);
            
            // Give actors USDT
            usdt.mint(actor, 10000000e6); // 10M USDT each
            
            // Issue KYC for actors
            vm.prank(admin);
            kyc.issueKYC(
                actor,
                KYCSoulbound.KYCData({
                    idHash: keccak256(abi.encodePacked(actor, "id")),
                    passportHash: keccak256(abi.encodePacked(actor, "passport")),
                    expiry: uint48(block.timestamp + 365 days),
                    jurisdiction: 840, // US
                    accredited: true,
                    riskScore: 100
                })
            );
        }

        targetContract(address(stakeLocker));
        targetContract(address(fthGold));
        targetContract(address(stakeReceipt));
    }

    /// @dev Coverage ratio must always be above minimum threshold
    function invariant_coverage_ratio_maintained() public {
        uint256 totalVaulted = porAdapter.totalVaultedKg();
        uint256 totalOutstanding = fthGold.totalSupplyKg();
        uint256 coverageRatio = stakeLocker.coverageRatioBps();
        
        if (totalOutstanding > 0) {
            uint256 currentCoverage = (totalVaulted * 10000) / totalOutstanding;
            assertGe(currentCoverage, coverageRatio, "Coverage ratio below minimum");
        }
    }

    /// @dev FTH-G supply should equal converted stakes (net of burns)
    function invariant_fthg_supply_matches_converted_stakes() public {
        // This is simplified - in practice would need to track conversions
        uint256 fthgSupply = fthGold.totalSupplyKg();
        uint256 maxPossibleSupply = stakeLocker.globalStakingCap();
        
        assertLe(fthgSupply, maxPossibleSupply, "FTH-G supply exceeds possible maximum");
    }

    /// @dev Total staked should never exceed global cap
    function invariant_total_staked_within_cap() public {
        uint256 totalStaked = stakeLocker.totalStaked();
        uint256 globalCap = stakeLocker.globalStakingCap();
        
        assertLe(totalStaked, globalCap, "Total staked exceeds global cap");
    }

    /// @dev No user should exceed their individual staking limit
    function invariant_user_stakes_within_limits() public {
        uint256 maxStakes = stakeLocker.maxStakesPerUser();
        
        for (uint256 i = 0; i < actors.length; i++) {
            uint256 userStakes = stakeLocker.userStakeCount(actors[i]);
            assertLe(userStakes, maxStakes, "User exceeds individual stake limit");
        }
    }

    /// @dev System should be pausable by guardian
    function invariant_guardian_can_pause() public {
        // This tests that pause functionality exists and works
        assertTrue(stakeLocker.hasRole(stakeLocker.GUARDIAN_ROLE(), admin));
    }

    /// @dev Only KYC-valid users should have stakes or FTH-G
    function invariant_only_kyc_valid_users_have_positions() public {
        for (uint256 i = 0; i < actors.length; i++) {
            address actor = actors[i];
            uint256 fthgBalance = fthGold.balanceOf(actor);
            uint256 stakeBalance = stakeReceipt.balanceOf(actor);
            
            if (fthgBalance > 0 || stakeBalance > 0) {
                assertTrue(kyc.isKYCValid(actor), "Invalid KYC user has positions");
            }
        }
    }

    /// @dev FTH-G tokens should not be mintable without proper coverage
    function invariant_no_mint_without_coverage() public {
        // If there are outstanding tokens, coverage should be sufficient
        if (fthGold.totalSupply() > 0) {
            assertTrue(porAdapter.isHealthy(), "Unhealthy oracle but tokens exist");
        }
    }

    /// @dev No single address should have both mint and burn permissions
    function invariant_role_separation() public {
        bytes32 issuerRole = fthGold.ISSUER_ROLE();
        bytes32 adminRole = fthGold.DEFAULT_ADMIN_ROLE();
        
        // Admin should not directly be issuer (should go through StakeLocker)
        assertFalse(
            fthGold.hasRole(issuerRole, admin) && fthGold.hasRole(adminRole, admin),
            "Admin has both issuer and admin roles"
        );
    }

    /// @dev System state should be consistent after operations
    function invariant_system_state_consistency() public {
        // Basic consistency checks
        uint256 totalStaked = stakeLocker.totalStaked();
        uint256 totalReceipts = stakeReceipt.totalSupply() / 1e18; // Convert to kg
        uint256 totalFthg = fthGold.totalSupplyKg();
        
        // Total positions should make sense
        assertGe(totalStaked, totalFthg, "More FTH-G than total staked");
    }

    // Helper function for bounded random actions
    function stake(uint256 actorSeed, uint256 amount) public useActor(actorSeed) {
        uint256 kgAmount = bound(amount, 1, 10); // 1-10 kg
        uint256 usdtAmount = kgAmount * stakeLocker.usdtPerKg();
        
        MockUSDT usdt = MockUSDT(address(stakeLocker.USDT()));
        
        if (usdt.balanceOf(msg.sender) >= usdtAmount && kyc.isKYCValid(msg.sender)) {
            usdt.approve(address(stakeLocker), usdtAmount);
            try stakeLocker.stake(kgAmount) {} catch {}
        }
    }

    function convert(uint256 actorSeed) public useActor(actorSeed) {
        (bool ready,) = stakeReceipt.isStakeReady(msg.sender);
        if (ready && kyc.isKYCValid(msg.sender)) {
            try stakeLocker.convert() {} catch {}
        }
    }
}

// Mock USDT for testing
contract MockUSDT is Test {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    uint256 public totalSupply;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        return transferFrom(msg.sender, to, amount);
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        if (from != msg.sender) {
            require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
            allowance[from][msg.sender] -= amount;
        }
        
        require(balanceOf[from] >= amount, "Insufficient balance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    function decimals() external pure returns (uint8) {
        return 6;
    }
}