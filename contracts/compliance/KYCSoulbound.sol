// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../access/AccessRoles.sol";
import "../libs/Errors.sol";
import "../libs/Events.sol";

/**
 * @title KYCSoulbound
 * @dev ERC-5192 style soulbound token for KYC/AML compliance
 * Each token represents a verified investor identity
 */
contract KYCSoulbound is ERC721, ERC721Enumerable, AccessRoles {
    struct KYCData {
        bytes32 idHash;           // Hash of government ID
        bytes32 passportHash;     // Hash of passport (optional)
        uint48 expiry;           // KYC expiration timestamp
        uint16 jurisdiction;     // ISO 3166-1 numeric country code
        bool accredited;         // Accredited investor status
        uint32 riskScore;        // Risk assessment score (0-1000)
    }

    /// @notice Mapping from address to KYC data
    mapping(address => KYCData) public kycOf;
    
    /// @notice Mapping to track if token is locked (soulbound)
    mapping(address => bool) public locked;
    
    /// @notice Mapping to track reason for revocation
    mapping(address => string) public revocationReason;
    
    /// @notice Maximum allowed risk score
    uint32 public constant MAX_RISK_SCORE = 1000;
    
    /// @notice KYC validity period (1 year)
    uint256 public constant KYC_VALIDITY_PERIOD = 365 days;

    constructor(address admin) ERC721("FTH KYC Pass", "KYC-PASS") {
        _initializeRoles(admin);
    }

    /**
     * @dev Issue KYC soulbound token to verified user
     * @param to Address to issue KYC token to
     * @param data KYC verification data
     */
    function issueKYC(address to, KYCData calldata data) external onlyKYCIssuer {
        if (to == address(0)) revert Errors.InvalidAddress(to);
        if (_exists(uint160(to))) revert Errors.AlreadyStaked(to);
        if (data.expiry <= block.timestamp) revert Errors.KYCExpired(to, data.expiry);
        if (data.riskScore > MAX_RISK_SCORE) revert Errors.InvalidConfiguration();
        
        // Mint soulbound token (tokenId = address as uint160)
        _safeMint(to, uint160(to));
        
        // Store KYC data
        kycOf[to] = data;
        locked[to] = true;
        
        emit Events.KYCIssued(to, data.idHash, data.jurisdiction, data.accredited, data.expiry);
    }

    /**
     * @dev Revoke KYC token for compliance reasons
     * @param user Address to revoke KYC for
     * @param reason Reason for revocation
     */
    function revokeKYC(address user, string calldata reason) external onlyKYCIssuer {
        if (!_exists(uint160(user))) revert Errors.KYCRequired(user);
        
        _burn(uint160(user));
        delete kycOf[user];
        locked[user] = false;
        revocationReason[user] = reason;
        
        emit Events.KYCRevoked(user, reason);
    }

    /**
     * @dev Update KYC data for existing user
     * @param user Address to update
     * @param data New KYC data
     */
    function updateKYC(address user, KYCData calldata data) external onlyKYCIssuer {
        if (!_exists(uint160(user))) revert Errors.KYCRequired(user);
        if (data.expiry <= block.timestamp) revert Errors.KYCExpired(user, data.expiry);
        if (data.riskScore > MAX_RISK_SCORE) revert Errors.InvalidConfiguration();
        
        kycOf[user] = data;
        
        emit Events.KYCIssued(user, data.idHash, data.jurisdiction, data.accredited, data.expiry);
    }

    /**
     * @dev Check if user has valid KYC
     * @param user Address to check
     * @return valid True if KYC is valid and not expired
     */
    function isKYCValid(address user) external view returns (bool valid) {
        if (!locked[user]) return false;
        
        KYCData memory data = kycOf[user];
        return data.expiry > block.timestamp;
    }

    /**
     * @dev Check if user is accredited investor
     * @param user Address to check
     * @return accredited True if user is accredited
     */
    function isAccredited(address user) external view returns (bool accredited) {
        if (!locked[user]) return false;
        return kycOf[user].accredited;
    }

    /**
     * @dev Get user's jurisdiction
     * @param user Address to check
     * @return jurisdiction ISO 3166-1 numeric country code
     */
    function getJurisdiction(address user) external view returns (uint16 jurisdiction) {
        return kycOf[user].jurisdiction;
    }

    /**
     * @dev Get user's risk score
     * @param user Address to check
     * @return riskScore Risk assessment score (0-1000)
     */
    function getRiskScore(address user) external view returns (uint32 riskScore) {
        return kycOf[user].riskScore;
    }

    /**
     * @dev Override transfer to make tokens soulbound
     */
    function _update(address to, uint256 tokenId, address auth) 
        internal 
        override(ERC721, ERC721Enumerable) 
        returns (address) 
    {
        address previousOwner = _ownerOf(tokenId);
        
        // Allow minting (previousOwner == address(0))
        // Allow burning (to == address(0))
        // Block transfers (previousOwner != address(0) && to != address(0))
        if (previousOwner != address(0) && to != address(0)) {
            revert Errors.SoulboundToken();
        }
        
        return super._update(to, tokenId, auth);
    }

    /**
     * @dev Override supportsInterface
     */
    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        override(ERC721, ERC721Enumerable, AccessControl) 
        returns (bool) 
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Check if token exists for address
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
}