// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library Errors {
    // Access Control
    error UnauthorizedAccess(address caller, bytes32 role);
    error InvalidAdmin(address admin);
    
    // KYC & Compliance
    error KYCRequired(address user);
    error KYCExpired(address user, uint48 expiry);
    error SoulboundToken();
    error SanctionedAddress(address user);
    error JurisdictionNotAllowed(uint16 jurisdiction);
    error NotAccredited(address user);
    error ComplianceViolation(address user, string reason);
    
    // Staking & Lock
    error InsufficientAmount(uint256 provided, uint256 required);
    error StillLocked(address user, uint256 unlockTime);
    error AlreadyStaked(address user);
    error StakeNotFound(address user);
    error InvalidLockPeriod(uint256 period);
    
    // Oracle & PoR
    error OracleStale(uint256 lastUpdate, uint256 maxAge);
    error OracleUnhealthy();
    error InsufficientCoverage(uint256 current, uint256 required);
    error InvalidPoRData();
    error PriceFeedFailure();
    
    // Token Operations
    error InsufficientBalance(address user, uint256 balance, uint256 required);
    error InvalidTokenAmount(uint256 amount);
    error MintCapExceeded(uint256 requested, uint256 available);
    error BurnFailed(address user, uint256 amount);
    
    // Distributions
    error DistributionNotReady(address user, uint256 nextDistribution);
    error InsufficientTreasuryFunds(uint256 requested, uint256 available);
    error InvalidDistributionRate(uint256 rate);
    error DistributionPaused();
    
    // Redemption
    error RedemptionNotAllowed(address user);
    error InsufficientRedemptionBalance(uint256 requested, uint256 available);
    error RedemptionQueueFull();
    error InvalidRedemptionType(uint8 redemptionType);
    error NAVBelowFloor(uint256 currentNAV, uint256 floor);
    
    // System
    error SystemPaused();
    error InvalidConfiguration();
    error ContractNotInitialized();
    error ReentrancyGuardViolation();
    error InvalidAddress(address addr);
    error ZeroAmount();
    
    // Upgrade
    error UpgradeBlocked();
    error InvalidImplementation(address implementation);
    error TimelockNotExpired(uint256 timelock);
}