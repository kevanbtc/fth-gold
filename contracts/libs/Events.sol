// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library Events {
    // KYC & Compliance
    event KYCIssued(address indexed user, bytes32 idHash, uint16 jurisdiction, bool accredited, uint48 expiry);
    event KYCRevoked(address indexed user, string reason);
    event ComplianceViolation(address indexed user, string violation);
    
    // Staking
    event Staked(address indexed user, uint256 usdtAmount, uint256 kgAmount, uint256 unlockTime);
    event StakeConverted(address indexed user, uint256 stakeAmount, uint256 fthgAmount);
    event StakeLockExtended(address indexed user, uint256 newUnlockTime);
    
    // Token Operations
    event FTHGMinted(address indexed to, uint256 kgAmount, bytes32 indexed batchId);
    event FTHGBurned(address indexed from, uint256 kgAmount, string reason);
    event TokensPaused(address indexed guardian);
    event TokensUnpaused(address indexed guardian);
    
    // Oracle & PoR
    event PoRUpdated(uint256 totalVaultedKg, uint256 timestamp, bytes32 indexed attestationHash);
    event CoverageRatioUpdated(uint256 oldRatio, uint256 newRatio);
    event OracleHealthCheck(bool isHealthy, uint256 lastUpdate);
    event PriceFeedUpdated(uint256 xauPrice, uint256 timestamp);
    
    // Distributions
    event DistributionScheduled(address indexed user, uint256 amount, uint256 scheduledTime, uint8 distributionType);
    event DistributionClaimed(address indexed user, uint256 amount, uint8 distributionType);
    event DistributionRateChanged(uint256 oldRate, uint256 newRate);
    event TreasuryFunded(uint256 amount, string source);
    
    // Redemption
    event RedemptionRequested(address indexed user, uint256 fthgAmount, uint8 redemptionType, uint256 queuePosition);
    event RedemptionProcessed(address indexed user, uint256 fthgAmount, uint256 usdtAmount, uint8 redemptionType);
    event PhysicalGoldDelivery(address indexed user, uint256 kgAmount, string trackingInfo);
    event RedemptionQueueUpdated(uint256 queueLength, uint256 totalPending);
    
    // Vault & Batch Management
    event VaultBatchCreated(uint256 indexed batchId, uint256 kgAmount, string ipfsHash);
    event VaultBatchVerified(uint256 indexed batchId, bytes32 attestationHash);
    event VaultCertificateUpdated(uint256 indexed batchId, string certificateHash);
    
    // System Management
    event SystemPaused(address indexed guardian, string reason);
    event SystemUnpaused(address indexed guardian);
    event EmergencyAction(address indexed guardian, string action, bytes data);
    event ConfigurationUpdated(string parameter, uint256 oldValue, uint256 newValue);
    
    // Registry
    event AddressRegistered(string indexed name, address indexed addr);
    event PolicyUpdated(string indexed policy, string ipfsHash);
    event FeeScheduleUpdated(string feeType, uint256 oldFee, uint256 newFee);
    
    // Access Control
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event AdminChanged(address previousAdmin, address newAdmin);
    
    // Upgrades
    event UpgradeProposed(address indexed implementation, uint256 timelock);
    event UpgradeExecuted(address indexed oldImplementation, address indexed newImplementation);
    event UpgradeCancelled(address indexed implementation, string reason);
}