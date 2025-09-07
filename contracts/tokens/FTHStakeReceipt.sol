// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../access/AccessRoles.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title FTHStakeReceipt
 * @dev Non-transferable token representing staked claim during lock period
 * Automatically converts to FTH-G after 5-month lock expires
 */
contract FTHStakeReceipt is ERC20, AccessRoles {
    /// @notice Stake information for each user
    struct StakeInfo {
        uint256 kgAmount;        // Amount staked in kg
        uint256 usdtAmount;      // Original USDT amount staked
        uint256 startTime;       // When stake was created
        uint256 unlockTime;      // When stake can be converted
        bool converted;          // Whether already converted to FTH-G
    }

    /// @notice Mapping from user to their stake info
    mapping(address => StakeInfo) public stakes;
    
    /// @notice Whether transfers are globally disabled (default: true for soulbound behavior)
    bool public transfersDisabled = true;
    
    /// @notice Lock period (5 months = ~150 days)
    uint256 public constant LOCK_PERIOD = 150 days;
    
    /// @notice Total kg staked across all users
    uint256 public totalKgStaked;
    
    /// @notice Total USDT value staked
    uint256 public totalUsdtStaked;

    event StakeCreated(address indexed user, uint256 kgAmount, uint256 usdtAmount, uint256 unlockTime);
    event StakeConverted(address indexed user, uint256 kgAmount);
    event TransfersToggled(bool enabled);

    constructor(address admin) ERC20("FTH Stake Receipt", "FTH-STAKE") {
        _initializeRoles(admin);
    }

    /**
     * @dev Create stake receipt for user
     * @param user Address to create stake for
     * @param kgAmount Amount of gold in kg
     * @param usdtAmount Amount of USDT staked
     */
    function createStake(
        address user, 
        uint256 kgAmount, 
        uint256 usdtAmount
    ) external onlyIssuer {
        if (user == address(0)) revert Errors.InvalidAddress(user);
        if (kgAmount == 0) revert Errors.InvalidTokenAmount(kgAmount);
        if (stakes[user].kgAmount > 0) revert Errors.AlreadyStaked(user);

        uint256 unlockTime = block.timestamp + LOCK_PERIOD;
        
        stakes[user] = StakeInfo({
            kgAmount: kgAmount,
            usdtAmount: usdtAmount,
            startTime: block.timestamp,
            unlockTime: unlockTime,
            converted: false
        });

        // Mint receipt tokens (1:1 with kg)
        _mint(user, kgAmount * 1e18);
        
        // Update totals
        totalKgStaked += kgAmount;
        totalUsdtStaked += usdtAmount;

        emit StakeCreated(user, kgAmount, usdtAmount, unlockTime);
        emit Events.Staked(user, usdtAmount, kgAmount, unlockTime);
    }

    /**
     * @dev Convert stake to FTH-G (called by StakeLocker)
     * @param user Address to convert stake for
     */
    function convertStake(address user) external onlyIssuer returns (uint256 kgAmount) {
        StakeInfo storage stake = stakes[user];
        
        if (stake.kgAmount == 0) revert Errors.StakeNotFound(user);
        if (stake.converted) revert Errors.InvalidTokenAmount(0);
        if (block.timestamp < stake.unlockTime) {
            revert Errors.StillLocked(user, stake.unlockTime);
        }

        kgAmount = stake.kgAmount;
        stake.converted = true;

        // Burn receipt tokens
        _burn(user, kgAmount * 1e18);
        
        // Update totals
        totalKgStaked -= kgAmount;
        totalUsdtStaked -= stake.usdtAmount;

        emit StakeConverted(user, kgAmount);
        emit Events.StakeConverted(user, kgAmount * 1e18, kgAmount);
        
        return kgAmount;
    }

    /**
     * @dev Check if stake is ready for conversion
     * @param user Address to check
     * @return ready True if stake can be converted
     * @return timeRemaining Seconds until unlock (0 if ready)
     */
    function isStakeReady(address user) external view returns (bool ready, uint256 timeRemaining) {
        StakeInfo memory stake = stakes[user];
        
        if (stake.kgAmount == 0 || stake.converted) {
            return (false, 0);
        }
        
        if (block.timestamp >= stake.unlockTime) {
            return (true, 0);
        }
        
        return (false, stake.unlockTime - block.timestamp);
    }

    /**
     * @dev Get stake information for user
     */
    function getStakeInfo(address user) external view returns (StakeInfo memory) {
        return stakes[user];
    }

    /**
     * @dev Get balance in kg for display
     */
    function balanceOfKg(address user) external view returns (uint256) {
        return balanceOf(user) / 1e18;
    }

    /**
     * @dev Get time remaining until unlock
     */
    function timeUntilUnlock(address user) external view returns (uint256) {
        StakeInfo memory stake = stakes[user];
        if (stake.unlockTime <= block.timestamp) return 0;
        return stake.unlockTime - block.timestamp;
    }

    /**
     * @dev Emergency extend lock period (guardian only)
     */
    function extendLock(address user, uint256 additionalDays) external onlyGuardian {
        StakeInfo storage stake = stakes[user];
        if (stake.kgAmount == 0) revert Errors.StakeNotFound(user);
        
        uint256 extension = additionalDays * 1 days;
        stake.unlockTime += extension;
        
        emit Events.StakeLockExtended(user, stake.unlockTime);
    }

    /**
     * @dev Toggle transfer functionality (for emergency liquidity)
     */
    function setTransfersEnabled(bool enabled) external onlyGuardian {
        transfersDisabled = !enabled;
        emit TransfersToggled(enabled);
    }

    /**
     * @dev Override transfer to implement soulbound behavior
     */
    function _update(address from, address to, uint256 value) internal override {
        // Allow minting (from == address(0))
        // Allow burning (to == address(0))  
        // Block transfers if disabled
        if (from != address(0) && to != address(0) && transfersDisabled) {
            revert Errors.SoulboundToken();
        }
        
        super._update(from, to, value);
    }

    /**
     * @dev Get total number of active stakes
     */
    function getActiveStakesCount() external view returns (uint256 count) {
        // Note: This is a simple implementation. For production, consider using 
        // an EnumerableSet to track active stakers for efficient enumeration
        return totalSupply() > 0 ? 1 : 0; // Simplified for MVP
    }

    /**
     * @dev Emergency conversion bypass (guardian only, for emergencies)
     */
    function emergencyConvert(address user, string calldata reason) external onlyGuardian returns (uint256) {
        StakeInfo storage stake = stakes[user];
        
        if (stake.kgAmount == 0) revert Errors.StakeNotFound(user);
        if (stake.converted) revert Errors.InvalidTokenAmount(0);

        uint256 kgAmount = stake.kgAmount;
        stake.converted = true;

        // Burn receipt tokens
        _burn(user, kgAmount * 1e18);
        
        // Update totals
        totalKgStaked -= kgAmount;
        totalUsdtStaked -= stake.usdtAmount;

        emit StakeConverted(user, kgAmount);
        emit Events.EmergencyAction(msg.sender, "emergency_convert", abi.encode(user, kgAmount, reason));
        
        return kgAmount;
    }

    /**
     * @dev Override decimals to match FTH-G
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }
}