// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Pausable} from "openzeppelin/contracts/utils/Pausable.sol";
import "../access/AccessRoles.sol";
import "../tokens/FTHGold.sol";
import "../tokens/FTHStakeReceipt.sol";
import "../compliance/KYCSoulbound.sol";
import "../compliance/ComplianceRegistry.sol";
import "../oracle/ChainlinkPoRAdapter.sol";
import "../oracle/PriceFeedAdapter.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title StakeLocker
 * @dev Core contract for USDT staking → 5-month lock → FTH-G conversion
 * Implements all safety checks, compliance gates, and PoR verification
 */
contract StakeLocker is ReentrancyGuard, Pausable, AccessRoles {
    using SafeERC20 for IERC20;

    /// @notice USDT token contract
    IERC20 public immutable USDT;
    
    /// @notice FTH-G token contract
    FTHGold public immutable FTHG;
    
    /// @notice Stake receipt token contract
    FTHStakeReceipt public immutable RECEIPT;
    
    /// @notice KYC soulbound token contract
    KYCSoulbound public immutable KYC;
    
    /// @notice Compliance registry contract
    ComplianceRegistry public immutable COMPLIANCE;
    
    /// @notice Proof of Reserve adapter
    ChainlinkPoRAdapter public immutable POR;
    
    /// @notice Price feed adapter
    PriceFeedAdapter public immutable PRICE_FEED;
    
    /// @notice Lock period (5 months ≈ 150 days)
    uint256 public constant LOCK_PERIOD = 150 days;
    
    /// @notice Standard kg per stake (1 kg)
    uint256 public constant KG_PER_STAKE = 1;
    
    /// @notice USDT amount per kg (configurable, ~$20,000 with 6 decimals)
    uint256 public usdtPerKg = 20000e6; // $20,000 USDT
    
    /// @notice Required PoR coverage ratio (125% = 12500 basis points)
    uint256 public coverageRatioBps = 12500;
    
    /// @notice Maximum stakes per user
    uint256 public maxStakesPerUser = 100; // 100 kg max per user
    
    /// @notice Global staking cap (total kg that can be staked)
    uint256 public globalStakingCap = 100000; // 100,000 kg total
    
    /// @notice Total kg staked across all users
    uint256 public totalStaked;
    
    /// @notice Treasury address for USDT collection
    address public treasury;
    
    /// @notice Per-user stake counts
    mapping(address => uint256) public userStakeCount;
    
    /// @notice Batch counter for tracking
    uint256 public nextBatchId = 1;

    event Staked(
        address indexed user, 
        uint256 kgAmount, 
        uint256 usdtAmount, 
        uint256 unlockTime,
        uint256 batchId
    );
    
    event Converted(
        address indexed user, 
        uint256 kgAmount, 
        uint256 batchId
    );
    
    event ConfigUpdated(string parameter, uint256 oldValue, uint256 newValue);
    event TreasuryUpdated(address oldTreasury, address newTreasury);

    constructor(
        address admin,
        IERC20 _usdt,
        FTHGold _fthg,
        FTHStakeReceipt _receipt,
        KYCSoulbound _kyc,
        ComplianceRegistry _compliance,
        ChainlinkPoRAdapter _por,
        PriceFeedAdapter _priceFeed,
        address _treasury
    ) {
        _initializeRoles(admin);
        
        USDT = _usdt;
        FTHG = _fthg;
        RECEIPT = _receipt;
        KYC = _kyc;
        COMPLIANCE = _compliance;
        POR = _por;
        PRICE_FEED = _priceFeed;
        treasury = _treasury;
    }

    /**
     * @dev Stake USDT for gold claim (1 kg minimum)
     * @param kgAmount Amount of kg to stake for (must be >= 1)
     */
    function stake(uint256 kgAmount) external nonReentrant whenNotPaused {
        if (kgAmount == 0) revert Errors.InvalidTokenAmount(kgAmount);
        
        // Verify KYC compliance
        _verifyCompliance(msg.sender);
        
        // Check user limits
        if (userStakeCount[msg.sender] + kgAmount > maxStakesPerUser) {
            revert Errors.MintCapExceeded(kgAmount, maxStakesPerUser - userStakeCount[msg.sender]);
        }
        
        // Check global cap
        if (totalStaked + kgAmount > globalStakingCap) {
            revert Errors.MintCapExceeded(kgAmount, globalStakingCap - totalStaked);
        }
        
        // Verify PoR coverage before accepting stake
        _verifyPoRCoverage(kgAmount);
        
        // Calculate USDT amount required
        uint256 usdtAmount = kgAmount * usdtPerKg;
        
        // Transfer USDT from user
        USDT.safeTransferFrom(msg.sender, treasury, usdtAmount);
        
        // Create stake receipt
        RECEIPT.createStake(msg.sender, kgAmount, usdtAmount);
        
        // Update counters
        userStakeCount[msg.sender] += kgAmount;
        totalStaked += kgAmount;
        
        uint256 unlockTime = block.timestamp + LOCK_PERIOD;
        uint256 batchId = nextBatchId++;
        
        emit Staked(msg.sender, kgAmount, usdtAmount, unlockTime, batchId);
        emit Events.Staked(msg.sender, usdtAmount, kgAmount, unlockTime);
    }

    /**
     * @dev Convert stake receipt to FTH-G tokens after lock period
     */
    function convert() external nonReentrant whenNotPaused {
        // Verify KYC is still valid
        _verifyCompliance(msg.sender);
        
        // Check if stake is ready for conversion
        (bool ready, uint256 timeRemaining) = RECEIPT.isStakeReady(msg.sender);
        if (!ready) {
            if (timeRemaining > 0) {
                revert Errors.StillLocked(msg.sender, block.timestamp + timeRemaining);
            } else {
                revert Errors.StakeNotFound(msg.sender);
            }
        }
        
        // Verify PoR coverage before minting
        _verifyPoRCoverageForMinting();
        
        // Convert stake to FTH-G
        uint256 kgAmount = RECEIPT.convertStake(msg.sender);
        
        // Mint FTH-G tokens
        bytes32 batchId = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        FTHG.mint(msg.sender, kgAmount, batchId);
        
        emit Converted(msg.sender, kgAmount, nextBatchId);
        emit Events.StakeConverted(msg.sender, kgAmount * 1e18, kgAmount);
    }

    /**
     * @dev Batch convert multiple users (admin operation)
     */
    function batchConvert(address[] calldata users) external nonReentrant onlyIssuer {
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            
            // Skip if user doesn't have valid KYC
            if (!KYC.isKYCValid(user)) continue;
            
            // Check if stake is ready
            (bool ready,) = RECEIPT.isStakeReady(user);
            if (!ready) continue;
            
            // Convert stake
            uint256 kgAmount = RECEIPT.convertStake(user);
            
            // Mint FTH-G
            bytes32 batchId = keccak256(abi.encodePacked(user, block.timestamp, i));
            FTHG.mint(user, kgAmount, batchId);
            
            emit Converted(user, kgAmount, nextBatchId);
        }
    }

    /**
     * @dev Emergency pause staking
     */
    function pause() external onlyGuardian {
        _pause();
    }

    /**
     * @dev Unpause staking
     */
    function unpause() external onlyGuardian {
        _unpause();
    }

    /**
     * @dev Update USDT per kg rate
     */
    function setUsdtPerKg(uint256 newRate) external onlyTreasurer {
        uint256 oldRate = usdtPerKg;
        usdtPerKg = newRate;
        emit ConfigUpdated("usdtPerKg", oldRate, newRate);
    }

    /**
     * @dev Update coverage ratio requirement
     */
    function setCoverageRatio(uint256 bps) external onlyTreasurer {
        if (bps < 10000) revert Errors.InvalidConfiguration(); // Minimum 100%
        uint256 oldRatio = coverageRatioBps;
        coverageRatioBps = bps;
        emit ConfigUpdated("coverageRatio", oldRatio, bps);
    }

    /**
     * @dev Update max stakes per user
     */
    function setMaxStakesPerUser(uint256 maxStakes) external onlyTreasurer {
        uint256 oldMax = maxStakesPerUser;
        maxStakesPerUser = maxStakes;
        emit ConfigUpdated("maxStakesPerUser", oldMax, maxStakes);
    }

    /**
     * @dev Update global staking cap
     */
    function setGlobalStakingCap(uint256 cap) external onlyTreasurer {
        uint256 oldCap = globalStakingCap;
        globalStakingCap = cap;
        emit ConfigUpdated("globalStakingCap", oldCap, cap);
    }

    /**
     * @dev Update treasury address
     */
    function setTreasury(address newTreasury) external onlyTreasurer {
        if (newTreasury == address(0)) revert Errors.InvalidAddress(newTreasury);
        address oldTreasury = treasury;
        treasury = newTreasury;
        emit TreasuryUpdated(oldTreasury, newTreasury);
    }

    /**
     * @dev Get user's staking information
     */
    function getUserStakeInfo(address user) external view returns (
        uint256 stakeCount,
        bool hasValidKYC,
        bool canStakeMore,
        uint256 maxAdditionalStakes,
        FTHStakeReceipt.StakeInfo memory currentStake
    ) {
        stakeCount = userStakeCount[user];
        hasValidKYC = KYC.isKYCValid(user);
        maxAdditionalStakes = maxStakesPerUser > stakeCount ? maxStakesPerUser - stakeCount : 0;
        canStakeMore = hasValidKYC && maxAdditionalStakes > 0 && totalStaked < globalStakingCap;
        currentStake = RECEIPT.getStakeInfo(user);
    }

    /**
     * @dev Get current system metrics
     */
    function getSystemMetrics() external view returns (
        uint256 totalStakedKg,
        uint256 availableCapacity,
        uint256 currentCoverageRatio,
        bool porHealthy,
        uint256 currentPrice
    ) {
        totalStakedKg = totalStaked;
        availableCapacity = globalStakingCap > totalStaked ? globalStakingCap - totalStaked : 0;
        
        // Calculate current coverage ratio
        uint256 outstandingFTHG = FTHG.totalSupplyKg();
        uint256 vaultedKg = POR.totalVaultedKg();
        currentCoverageRatio = outstandingFTHG > 0 ? (vaultedKg * 10000) / outstandingFTHG : 0;
        
        porHealthy = POR.isHealthy();
        currentPrice = PRICE_FEED.getXAUPricePerKg();
    }

    /**
     * @dev Verify user compliance (internal)
     */
    function _verifyCompliance(address user) internal view {
        // Check KYC validity
        if (!KYC.isKYCValid(user)) {
            revert Errors.KYCRequired(user);
        }

        // Get user data
        uint16 jurisdiction = KYC.getJurisdiction(user);
        bool isAccredited = KYC.isAccredited(user);
        uint32 riskScore = KYC.getRiskScore(user);

        // Check compliance rules
        (bool allowed, string memory reason) = COMPLIANCE.canParticipate(
            user,
            jurisdiction,
            isAccredited,
            riskScore,
            usdtPerKg // Investment amount for 1 kg
        );

        if (!allowed) {
            revert Errors.ComplianceViolation(user, reason);
        }
    }

    /**
     * @dev Verify PoR coverage before accepting stakes
     */
    function _verifyPoRCoverage(uint256 additionalKg) internal view {
        if (!POR.isHealthy()) {
            revert Errors.OracleUnhealthy();
        }

        uint256 totalVaultedKg = POR.totalVaultedKg();
        uint256 projectedOutstandingKg = FTHG.totalSupplyKg() + additionalKg;

        if (projectedOutstandingKg > 0) {
            uint256 projectedCoverage = (totalVaultedKg * 10000) / projectedOutstandingKg;
            if (projectedCoverage < coverageRatioBps) {
                revert Errors.InsufficientCoverage(projectedCoverage, coverageRatioBps);
            }
        }
    }

    /**
     * @dev Verify PoR coverage before minting (conversion)
     */
    function _verifyPoRCoverageForMinting() internal view {
        if (!POR.isHealthy()) {
            revert Errors.OracleUnhealthy();
        }

        uint256 totalVaultedKg = POR.totalVaultedKg();
        uint256 outstandingKg = FTHG.totalSupplyKg();

        if (outstandingKg > 0) {
            uint256 currentCoverage = (totalVaultedKg * 10000) / outstandingKg;
            if (currentCoverage < coverageRatioBps) {
                revert Errors.InsufficientCoverage(currentCoverage, coverageRatioBps);
            }
        }
    }
}