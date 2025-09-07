// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/compliance/KYCSoulbound.sol";
import "../contracts/libs/Errors.sol";

contract KYCTest is Test {
    KYCSoulbound public kyc;
    
    address public admin = makeAddr("admin");
    address public issuer = makeAddr("issuer");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");

    function setUp() public {
        kyc = new KYCSoulbound(admin);
        
        vm.prank(admin);
        kyc.grantRole(kyc.KYC_ISSUER_ROLE(), issuer);
    }

    function test_IssueKYC() public {
        KYCSoulbound.KYCData memory data = KYCSoulbound.KYCData({
            idHash: keccak256("id123"),
            passportHash: keccak256("passport456"),
            expiry: uint48(block.timestamp + 365 days),
            jurisdiction: 840, // US
            accredited: true,
            riskScore: 250
        });

        vm.prank(issuer);
        kyc.issueKYC(user1, data);

        // Verify KYC was issued
        assertTrue(kyc.isKYCValid(user1));
        assertTrue(kyc.isAccredited(user1));
        assertEq(kyc.getJurisdiction(user1), 840);
        assertEq(kyc.getRiskScore(user1), 250);
        assertEq(kyc.ownerOf(uint160(user1)), user1);
    }

    function test_KYCExpiry() public {
        KYCSoulbound.KYCData memory data = KYCSoulbound.KYCData({
            idHash: keccak256("id123"),
            passportHash: keccak256("passport456"),
            expiry: uint48(block.timestamp + 1 days),
            jurisdiction: 840,
            accredited: true,
            riskScore: 100
        });

        vm.prank(issuer);
        kyc.issueKYC(user1, data);
        
        assertTrue(kyc.isKYCValid(user1));

        // Fast forward past expiry
        vm.warp(block.timestamp + 2 days);
        
        assertFalse(kyc.isKYCValid(user1));
    }

    function test_RevokeKYC() public {
        // Issue KYC first
        test_IssueKYC();
        
        vm.prank(issuer);
        kyc.revokeKYC(user1, "Compliance violation");

        assertFalse(kyc.isKYCValid(user1));
        assertFalse(kyc.locked(user1));
        assertEq(kyc.revocationReason(user1), "Compliance violation");
    }

    function test_UpdateKYC() public {
        // Issue initial KYC
        test_IssueKYC();

        // Update with new data
        KYCSoulbound.KYCData memory newData = KYCSoulbound.KYCData({
            idHash: keccak256("newid789"),
            passportHash: keccak256("newpassport123"),
            expiry: uint48(block.timestamp + 730 days), // 2 years
            jurisdiction: 756, // Switzerland
            accredited: false,
            riskScore: 500
        });

        vm.prank(issuer);
        kyc.updateKYC(user1, newData);

        // Verify update
        assertEq(kyc.getJurisdiction(user1), 756);
        assertFalse(kyc.isAccredited(user1));
        assertEq(kyc.getRiskScore(user1), 500);
    }

    function test_SoulboundTransferFails() public {
        test_IssueKYC();
        
        vm.prank(user1);
        vm.expectRevert(Errors.SoulboundToken.selector);
        kyc.transferFrom(user1, user2, uint160(user1));
    }

    function test_OnlyIssuerCanIssue() public {
        KYCSoulbound.KYCData memory data = KYCSoulbound.KYCData({
            idHash: keccak256("id123"),
            passportHash: keccak256("passport456"),
            expiry: uint48(block.timestamp + 365 days),
            jurisdiction: 840,
            accredited: true,
            riskScore: 100
        });

        vm.prank(user1);
        vm.expectRevert();
        kyc.issueKYC(user2, data);
    }

    function test_CannotIssueExpiredKYC() public {
        KYCSoulbound.KYCData memory data = KYCSoulbound.KYCData({
            idHash: keccak256("id123"),
            passportHash: keccak256("passport456"),
            expiry: uint48(block.timestamp - 1 days), // Expired
            jurisdiction: 840,
            accredited: true,
            riskScore: 100
        });

        vm.prank(issuer);
        vm.expectRevert();
        kyc.issueKYC(user1, data);
    }

    function test_CannotIssueHighRiskScore() public {
        KYCSoulbound.KYCData memory data = KYCSoulbound.KYCData({
            idHash: keccak256("id123"),
            passportHash: keccak256("passport456"),
            expiry: uint48(block.timestamp + 365 days),
            jurisdiction: 840,
            accredited: true,
            riskScore: 1001 // Above maximum
        });

        vm.prank(issuer);
        vm.expectRevert();
        kyc.issueKYC(user1, data);
    }

    function test_CannotIssueDuplicate() public {
        test_IssueKYC();
        
        KYCSoulbound.KYCData memory data = KYCSoulbound.KYCData({
            idHash: keccak256("id456"),
            passportHash: keccak256("passport789"),
            expiry: uint48(block.timestamp + 365 days),
            jurisdiction: 840,
            accredited: true,
            riskScore: 100
        });

        vm.prank(issuer);
        vm.expectRevert();
        kyc.issueKYC(user1, data); // Already has KYC
    }
}