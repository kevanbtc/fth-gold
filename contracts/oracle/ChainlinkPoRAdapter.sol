// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../access/AccessRoles.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title ChainlinkPoRAdapter
 * @dev Adapter for Chainlink Proof of Reserve feeds and vault verification
 */
contract ChainlinkPoRAdapter is AccessRoles {
    /// @notice Chainlink PoR aggregator interface
    AggregatorV3Interface public porFeed;
    
    /// @notice Maximum age for PoR data (1 hour)
    uint256 public constant MAX_POR_AGE = 3600;
    
    /// @notice Minimum number of oracle nodes required
    uint8 public constant MIN_ORACLE_NODES = 3;
    
    /// @notice Last known vault total in kg
    uint256 public lastVaultTotalKg;
    
    /// @notice Last update timestamp
    uint256 public lastUpdate;
    
    /// @notice Manual override for emergencies
    bool public emergencyOverride;
    
    /// @notice Emergency vault total (when override is active)
    uint256 public emergencyVaultTotal;
    
    /// @notice Mapping of batch ID to verified kg amounts
    mapping(uint256 => uint256) public batchKgVerified;
    
    /// @notice Mapping of batch ID to IPFS attestation hashes
    mapping(uint256 => bytes32) public batchAttestations;
    
    /// @notice Total number of verified batches
    uint256 public totalBatches;

    event PoRFeedUpdated(address indexed newFeed);
    event EmergencyOverrideToggled(bool enabled, uint256 overrideAmount);
    event BatchVerified(uint256 indexed batchId, uint256 kgAmount, bytes32 attestationHash);

    constructor(address admin, address _porFeed) {
        _initializeRoles(admin);
        if (_porFeed != address(0)) {
            porFeed = AggregatorV3Interface(_porFeed);
        }
    }

    /**
     * @dev Update PoR feed address
     */
    function setPoRFeed(address _porFeed) external onlyOracle {
        if (_porFeed == address(0)) revert Errors.InvalidAddress(_porFeed);
        porFeed = AggregatorV3Interface(_porFeed);
        emit PoRFeedUpdated(_porFeed);
    }

    /**
     * @dev Get total vaulted kg from Chainlink PoR
     */
    function totalVaultedKg() external view returns (uint256) {
        if (emergencyOverride) {
            return emergencyVaultTotal;
        }

        if (address(porFeed) == address(0)) {
            revert Errors.InvalidConfiguration();
        }

        try porFeed.latestRoundData() returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) {
            // Check data freshness
            if (block.timestamp - updatedAt > MAX_POR_AGE) {
                revert Errors.OracleStale(updatedAt, MAX_POR_AGE);
            }

            // Ensure we have a valid answer
            if (answer <= 0) {
                revert Errors.InvalidPoRData();
            }

            // Convert to kg (assuming Chainlink reports in grams)
            return uint256(answer) / 1000;
        } catch {
            revert Errors.OracleUnhealthy();
        }
    }

    /**
     * @dev Get kg amount for specific batch
     */
    function batchKg(uint256 batchId) external view returns (uint256) {
        return batchKgVerified[batchId];
    }

    /**
     * @dev Check if oracle is healthy
     */
    function isHealthy() external view returns (bool) {
        if (emergencyOverride) {
            return true; // Admin override
        }

        if (address(porFeed) == address(0)) {
            return false;
        }

        try porFeed.latestRoundData() returns (
            uint80,
            int256 answer,
            uint256,
            uint256 updatedAt,
            uint80
        ) {
            return (
                answer > 0 && 
                block.timestamp - updatedAt <= MAX_POR_AGE
            );
        } catch {
            return false;
        }
    }

    /**
     * @dev Verify a vault batch with attestation
     */
    function verifyBatch(
        uint256 batchId,
        uint256 kgAmount,
        bytes32 attestationHash
    ) external onlyOracle {
        if (kgAmount == 0) revert Errors.InvalidTokenAmount(kgAmount);
        if (attestationHash == bytes32(0)) revert Errors.InvalidPoRData();

        batchKgVerified[batchId] = kgAmount;
        batchAttestations[batchId] = attestationHash;
        
        if (batchId >= totalBatches) {
            totalBatches = batchId + 1;
        }

        emit Events.PoRUpdated(this.totalVaultedKg(), block.timestamp, attestationHash);
        emit BatchVerified(batchId, kgAmount, attestationHash);
    }

    /**
     * @dev Get batch attestation hash
     */
    function getBatchAttestation(uint256 batchId) external view returns (bytes32) {
        return batchAttestations[batchId];
    }

    /**
     * @dev Emergency override for vault total (guardian only)
     */
    function setEmergencyOverride(bool enabled, uint256 overrideAmount) external onlyGuardian {
        emergencyOverride = enabled;
        if (enabled) {
            emergencyVaultTotal = overrideAmount;
        }
        emit EmergencyOverrideToggled(enabled, overrideAmount);
    }

    /**
     * @dev Update internal cache (can be called by anyone to refresh)
     */
    function updateCache() external {
        if (emergencyOverride) return;
        
        lastVaultTotalKg = this.totalVaultedKg();
        lastUpdate = block.timestamp;
        
        emit Events.PoRUpdated(lastVaultTotalKg, lastUpdate, bytes32(0));
    }

    /**
     * @dev Get the latest PoR data with metadata
     */
    function getPoRData() external view returns (
        uint256 vaultTotalKg,
        uint256 updateTime,
        bool healthy,
        bool override
    ) {
        return (
            emergencyOverride ? emergencyVaultTotal : this.totalVaultedKg(),
            block.timestamp,
            this.isHealthy(),
            emergencyOverride
        );
    }

    /**
     * @dev Calculate total verified kg across all batches
     */
    function totalVerifiedKg() external view returns (uint256 total) {
        for (uint256 i = 0; i < totalBatches; i++) {
            total += batchKgVerified[i];
        }
    }
}