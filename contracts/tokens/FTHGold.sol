// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Pausable} from "openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "../access/AccessRoles.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title FTHGold
 * @dev ERC20 token representing ownership of vaulted gold (1 token = 1 kg)
 * Features: Pausable, Permit (gasless approvals), Controlled supply
 */
contract FTHGold is ERC20, ERC20Permit, ERC20Pausable, AccessRoles {
    /// @notice Maximum total supply (safety cap: 1M kg = $65B at $2000/oz)
    uint256 public constant MAX_SUPPLY = 1_000_000 * 1e18;
    
    /// @notice Per-user mint limits (can be adjusted by admin)
    mapping(address => uint256) public mintLimits;
    
    /// @notice Default mint limit per user (100 kg = $6.5M)
    uint256 public defaultMintLimit = 100 * 1e18;
    
    /// @notice Global daily mint cap to prevent flash attacks
    uint256 public dailyMintCap = 10_000 * 1e18; // 10,000 kg per day
    uint256 public dailyMinted;
    uint256 public lastMintDay;

    event MintLimitUpdated(address indexed user, uint256 newLimit);
    event DailyMintCapUpdated(uint256 newCap);
    event TokensBurned(address indexed from, uint256 amount, string reason);

    constructor(address admin) 
        ERC20("FTH Gold", "FTH-G") 
        ERC20Permit("FTH Gold") 
    {
        _initializeRoles(admin);
    }

    /**
     * @dev Pause all token transfers (emergency only)
     */
    function pause() external onlyGuardian {
        _pause();
        emit Events.TokensPaused(msg.sender);
    }

    /**
     * @dev Unpause token transfers
     */
    function unpause() external onlyGuardian {
        _unpause();
        emit Events.TokensUnpaused(msg.sender);
    }

    /**
     * @dev Create snapshot for dividends/governance
     * Note: Temporarily disabled - can be re-enabled when OpenZeppelin updates include ERC20Snapshot
     */
    function snapshot() external onlyTreasurer returns (uint256) {
        // return _snapshot();
        revert("Snapshot functionality temporarily disabled");
    }

    /**
     * @dev Mint tokens to address (1 token = 1 kg gold)
     * @param to Recipient address
     * @param kgAmount Amount in kg (will be converted to wei)
     * @param batchId Associated vault batch ID
     */
    function mint(address to, uint256 kgAmount, bytes32 batchId) external onlyIssuer {
        if (to == address(0)) revert Errors.InvalidAddress(to);
        if (kgAmount == 0) revert Errors.InvalidTokenAmount(kgAmount);
        
        uint256 weiAmount = kgAmount * 1e18;
        
        // Check maximum supply
        if (totalSupply() + weiAmount > MAX_SUPPLY) {
            revert Errors.MintCapExceeded(weiAmount, MAX_SUPPLY - totalSupply());
        }
        
        // Check user mint limit
        uint256 userLimit = mintLimits[to] > 0 ? mintLimits[to] : defaultMintLimit;
        if (balanceOf(to) + weiAmount > userLimit) {
            revert Errors.MintCapExceeded(weiAmount, userLimit - balanceOf(to));
        }
        
        // Check daily mint cap
        uint256 currentDay = block.timestamp / 1 days;
        if (currentDay != lastMintDay) {
            dailyMinted = 0;
            lastMintDay = currentDay;
        }
        
        if (dailyMinted + weiAmount > dailyMintCap) {
            revert Errors.MintCapExceeded(weiAmount, dailyMintCap - dailyMinted);
        }
        
        // Update counters
        dailyMinted += weiAmount;
        
        // Mint tokens
        _mint(to, weiAmount);
        
        emit Events.FTHGMinted(to, kgAmount, batchId);
    }

    /**
     * @dev Burn tokens from address
     * @param from Address to burn from
     * @param kgAmount Amount in kg to burn
     * @param reason Reason for burning
     */
    function burn(address from, uint256 kgAmount, string calldata reason) external onlyIssuer {
        if (from == address(0)) revert Errors.InvalidAddress(from);
        if (kgAmount == 0) revert Errors.InvalidTokenAmount(kgAmount);
        
        uint256 weiAmount = kgAmount * 1e18;
        
        if (balanceOf(from) < weiAmount) {
            revert Errors.InsufficientBalance(from, balanceOf(from), weiAmount);
        }
        
        _burn(from, weiAmount);
        
        emit Events.FTHGBurned(from, kgAmount, reason);
        emit TokensBurned(from, weiAmount, reason);
    }

    /**
     * @dev Set mint limit for specific user
     */
    function setMintLimit(address user, uint256 limitKg) external onlyTreasurer {
        mintLimits[user] = limitKg * 1e18;
        emit MintLimitUpdated(user, limitKg);
    }

    /**
     * @dev Set default mint limit for new users
     */
    function setDefaultMintLimit(uint256 limitKg) external onlyTreasurer {
        defaultMintLimit = limitKg * 1e18;
    }

    /**
     * @dev Set daily mint cap
     */
    function setDailyMintCap(uint256 capKg) external onlyTreasurer {
        dailyMintCap = capKg * 1e18;
        emit DailyMintCapUpdated(capKg);
    }

    /**
     * @dev Get balance in kg (for display)
     */
    function balanceOfKg(address account) external view returns (uint256) {
        return balanceOf(account) / 1e18;
    }

    /**
     * @dev Get total supply in kg
     */
    function totalSupplyKg() external view returns (uint256) {
        return totalSupply() / 1e18;
    }

    /**
     * @dev Get user's mint limit in kg
     */
    function getMintLimitKg(address user) external view returns (uint256) {
        uint256 limit = mintLimits[user] > 0 ? mintLimits[user] : defaultMintLimit;
        return limit / 1e18;
    }

    /**
     * @dev Get remaining daily mint capacity
     */
    function getRemainingDailyMintCap() external view returns (uint256) {
        uint256 currentDay = block.timestamp / 1 days;
        if (currentDay != lastMintDay) {
            return dailyMintCap;
        }
        return dailyMintCap > dailyMinted ? dailyMintCap - dailyMinted : 0;
    }

    /**
     * @dev Override _update to include pausable functionality
     */
    function _update(address from, address to, uint256 value) 
        internal 
        override(ERC20, ERC20Pausable) 
    {
        super._update(from, to, value);
    }

    /**
     * @dev Override decimals to return 18 (standard)
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    /**
     * @dev Emergency burn (guardian only)
     */
    function emergencyBurn(address from, uint256 kgAmount, string calldata reason) external onlyGuardian {
        if (from == address(0)) revert Errors.InvalidAddress(from);
        if (kgAmount == 0) revert Errors.InvalidTokenAmount(kgAmount);
        
        uint256 weiAmount = kgAmount * 1e18;
        
        if (balanceOf(from) < weiAmount) {
            revert Errors.InsufficientBalance(from, balanceOf(from), weiAmount);
        }
        
        _burn(from, weiAmount);
        
        emit Events.FTHGBurned(from, kgAmount, reason);
        emit TokensBurned(from, weiAmount, string.concat("EMERGENCY: ", reason));
    }
}