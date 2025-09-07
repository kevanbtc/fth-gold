// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControl} from "openzeppelin/contracts/access/AccessControl.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title AccessRoles
 * @dev Defines and manages all system roles with proper access control
 */
abstract contract AccessRoles is AccessControl {
    /// @notice Role for emergency pausing and system protection
    bytes32 public constant GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");
    
    /// @notice Role for issuing and revoking KYC soulbound tokens
    bytes32 public constant KYC_ISSUER_ROLE = keccak256("KYC_ISSUER_ROLE");
    
    /// @notice Role for minting and burning FTH-G tokens
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    
    /// @notice Role for treasury operations and distribution management
    bytes32 public constant TREASURER_ROLE = keccak256("TREASURER_ROLE");
    
    /// @notice Role for updating oracle configurations
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
    
    /// @notice Role for executing upgrades (should be timelock + multisig)
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    
    /// @notice Role for compliance operations
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");

    modifier onlyGuardian() {
        if (!hasRole(GUARDIAN_ROLE, msg.sender)) {
            revert Errors.UnauthorizedAccess(msg.sender, GUARDIAN_ROLE);
        }
        _;
    }

    modifier onlyKYCIssuer() {
        if (!hasRole(KYC_ISSUER_ROLE, msg.sender)) {
            revert Errors.UnauthorizedAccess(msg.sender, KYC_ISSUER_ROLE);
        }
        _;
    }

    modifier onlyIssuer() {
        if (!hasRole(ISSUER_ROLE, msg.sender)) {
            revert Errors.UnauthorizedAccess(msg.sender, ISSUER_ROLE);
        }
        _;
    }

    modifier onlyTreasurer() {
        if (!hasRole(TREASURER_ROLE, msg.sender)) {
            revert Errors.UnauthorizedAccess(msg.sender, TREASURER_ROLE);
        }
        _;
    }

    modifier onlyCompliance() {
        if (!hasRole(COMPLIANCE_ROLE, msg.sender)) {
            revert Errors.UnauthorizedAccess(msg.sender, COMPLIANCE_ROLE);
        }
        _;
    }

    /**
     * @dev Initialize roles with proper admin setup
     * @param admin The admin address (should be multisig)
     */
    function _initializeRoles(address admin) internal {
        if (admin == address(0)) revert Errors.InvalidAdmin(admin);
        
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(GUARDIAN_ROLE, admin);
        _grantRole(KYC_ISSUER_ROLE, admin);
        _grantRole(ISSUER_ROLE, admin);
        _grantRole(TREASURER_ROLE, admin);
        _grantRole(ORACLE_ROLE, admin);
        _grantRole(UPGRADER_ROLE, admin);
        _grantRole(COMPLIANCE_ROLE, admin);
        
        // Set role admin relationships for better security
        _setRoleAdmin(GUARDIAN_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(ISSUER_ROLE, GUARDIAN_ROLE);
        _setRoleAdmin(TREASURER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    /**
     * @dev Emergency role transfer for guardian
     */
    function emergencyTransferGuardian(address newGuardian) external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (newGuardian == address(0)) revert Errors.InvalidAddress(newGuardian);
        
        _grantRole(GUARDIAN_ROLE, newGuardian);
        _revokeRole(GUARDIAN_ROLE, msg.sender);
        
        emit Events.AdminChanged(msg.sender, newGuardian);
    }
}