// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../access/AccessRoles.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title ComplianceRegistry
 * @dev Manages global compliance rules, jurisdiction permissions, and sanctions
 */
contract ComplianceRegistry is AccessRoles {
    /// @notice Jurisdiction configuration
    struct JurisdictionConfig {
        bool enabled;           // Whether jurisdiction is enabled
        bool requiresAccredited; // Requires accredited investor status
        uint256 maxInvestment;  // Maximum investment amount (0 = unlimited)
        uint256 minInvestment;  // Minimum investment amount
        string regulatoryFramework; // e.g., "Reg D", "MiCA", "FINMA"
    }

    /// @notice Mapping from ISO 3166-1 numeric code to jurisdiction config
    mapping(uint16 => JurisdictionConfig) public jurisdictions;
    
    /// @notice Global sanctions list
    mapping(address => bool) public sanctioned;
    
    /// @notice Global allowlist (if enabled, only these addresses can participate)
    mapping(address => bool) public allowlisted;
    
    /// @notice Whether allowlist is enabled (default: false = permissionless with KYC)
    bool public allowlistEnabled;
    
    /// @notice Maximum risk score allowed for participation
    uint32 public maxAllowedRiskScore = 500; // Out of 1000
    
    /// @notice Whether new registrations are paused
    bool public registrationsPaused;

    event JurisdictionConfigured(uint16 indexed jurisdiction, bool enabled, string framework);
    event AddressSanctioned(address indexed user, string reason);
    event AddressUnsanctioned(address indexed user);
    event AllowlistStatusChanged(bool enabled);
    event AllowlistUpdated(address indexed user, bool allowed);

    constructor(address admin) {
        _initializeRoles(admin);
        _configureDefaultJurisdictions();
    }

    /**
     * @dev Configure jurisdiction settings
     */
    function configureJurisdiction(
        uint16 jurisdiction,
        JurisdictionConfig calldata config
    ) external onlyCompliance {
        jurisdictions[jurisdiction] = config;
        emit JurisdictionConfigured(jurisdiction, config.enabled, config.regulatoryFramework);
    }

    /**
     * @dev Batch configure multiple jurisdictions
     */
    function configureJurisdictions(
        uint16[] calldata jurisdictionCodes,
        JurisdictionConfig[] calldata configs
    ) external onlyCompliance {
        if (jurisdictionCodes.length != configs.length) revert Errors.InvalidConfiguration();
        
        for (uint256 i = 0; i < jurisdictionCodes.length; i++) {
            jurisdictions[jurisdictionCodes[i]] = configs[i];
            emit JurisdictionConfigured(jurisdictionCodes[i], configs[i].enabled, configs[i].regulatoryFramework);
        }
    }

    /**
     * @dev Add address to sanctions list
     */
    function addToSanctionsList(address user, string calldata reason) external onlyCompliance {
        sanctioned[user] = true;
        emit AddressSanctioned(user, reason);
    }

    /**
     * @dev Remove address from sanctions list
     */
    function removeFromSanctionsList(address user) external onlyCompliance {
        sanctioned[user] = false;
        emit AddressUnsanctioned(user);
    }

    /**
     * @dev Add address to allowlist
     */
    function addToAllowlist(address user) external onlyCompliance {
        allowlisted[user] = true;
        emit AllowlistUpdated(user, true);
    }

    /**
     * @dev Remove address from allowlist
     */
    function removeFromAllowlist(address user) external onlyCompliance {
        allowlisted[user] = false;
        emit AllowlistUpdated(user, false);
    }

    /**
     * @dev Toggle allowlist requirement
     */
    function setAllowlistEnabled(bool enabled) external onlyCompliance {
        allowlistEnabled = enabled;
        emit AllowlistStatusChanged(enabled);
    }

    /**
     * @dev Set maximum allowed risk score
     */
    function setMaxRiskScore(uint32 maxScore) external onlyCompliance {
        if (maxScore > 1000) revert Errors.InvalidConfiguration();
        maxAllowedRiskScore = maxScore;
    }

    /**
     * @dev Pause/unpause new registrations
     */
    function setRegistrationsPaused(bool paused) external onlyGuardian {
        registrationsPaused = paused;
    }

    /**
     * @dev Check if user can participate based on all compliance rules
     */
    function canParticipate(
        address user,
        uint16 jurisdiction,
        bool isAccredited,
        uint32 riskScore,
        uint256 investmentAmount
    ) external view returns (bool allowed, string memory reason) {
        // Check if registrations are paused
        if (registrationsPaused) {
            return (false, "Registrations paused");
        }

        // Check sanctions
        if (sanctioned[user]) {
            return (false, "Sanctioned address");
        }

        // Check allowlist if enabled
        if (allowlistEnabled && !allowlisted[user]) {
            return (false, "Not allowlisted");
        }

        // Check jurisdiction
        JurisdictionConfig memory config = jurisdictions[jurisdiction];
        if (!config.enabled) {
            return (false, "Jurisdiction not supported");
        }

        // Check accreditation requirement
        if (config.requiresAccredited && !isAccredited) {
            return (false, "Accredited investor required");
        }

        // Check investment limits
        if (config.minInvestment > 0 && investmentAmount < config.minInvestment) {
            return (false, "Investment below minimum");
        }

        if (config.maxInvestment > 0 && investmentAmount > config.maxInvestment) {
            return (false, "Investment above maximum");
        }

        // Check risk score
        if (riskScore > maxAllowedRiskScore) {
            return (false, "Risk score too high");
        }

        return (true, "");
    }

    /**
     * @dev Get jurisdiction configuration
     */
    function getJurisdictionConfig(uint16 jurisdiction) 
        external 
        view 
        returns (JurisdictionConfig memory) 
    {
        return jurisdictions[jurisdiction];
    }

    /**
     * @dev Configure default jurisdictions (UAE, US, EU, CH, SG)
     */
    function _configureDefaultJurisdictions() private {
        // UAE (Dubai DMCC hub)
        jurisdictions[784] = JurisdictionConfig({
            enabled: true,
            requiresAccredited: true,
            maxInvestment: 0, // Unlimited
            minInvestment: 20000e6, // $20K USDT (6 decimals)
            regulatoryFramework: "DMCC/VARA"
        });

        // United States
        jurisdictions[840] = JurisdictionConfig({
            enabled: true,
            requiresAccredited: true,
            maxInvestment: 0,
            minInvestment: 20000e6,
            regulatoryFramework: "Reg D/S"
        });

        // Switzerland
        jurisdictions[756] = JurisdictionConfig({
            enabled: true,
            requiresAccredited: false,
            maxInvestment: 0,
            minInvestment: 20000e6,
            regulatoryFramework: "FINMA"
        });

        // Singapore
        jurisdictions[702] = JurisdictionConfig({
            enabled: true,
            requiresAccredited: true,
            maxInvestment: 0,
            minInvestment: 20000e6,
            regulatoryFramework: "MAS"
        });
    }
}