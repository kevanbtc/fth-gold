// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/tokens/FTHGold.sol";

contract FTHGoldTest is Test {
    FTHGold public fthGold;
    
    address public admin = makeAddr("admin");
    address public issuer = makeAddr("issuer");
    address public guardian = makeAddr("guardian");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");

    bytes32 public constant BATCH_ID = keccak256("batch001");

    function setUp() public {
        fthGold = new FTHGold(admin);
        
        vm.startPrank(admin);
        fthGold.grantRole(fthGold.ISSUER_ROLE(), issuer);
        fthGold.grantRole(fthGold.GUARDIAN_ROLE(), guardian);
        vm.stopPrank();
    }

    function test_Mint() public {
        vm.prank(issuer);
        fthGold.mint(user1, 5, BATCH_ID); // 5 kg

        assertEq(fthGold.balanceOf(user1), 5e18);
        assertEq(fthGold.balanceOfKg(user1), 5);
        assertEq(fthGold.totalSupplyKg(), 5);
    }

    function test_Burn() public {
        // Mint first
        vm.prank(issuer);
        fthGold.mint(user1, 5, BATCH_ID);

        // Burn
        vm.prank(issuer);
        fthGold.burn(user1, 2, "Redemption");

        assertEq(fthGold.balanceOf(user1), 3e18);
        assertEq(fthGold.balanceOfKg(user1), 3);
        assertEq(fthGold.totalSupplyKg(), 3);
    }

    function test_Transfer() public {
        vm.prank(issuer);
        fthGold.mint(user1, 10, BATCH_ID);

        vm.prank(user1);
        fthGold.transfer(user2, 3e18); // Transfer 3 kg

        assertEq(fthGold.balanceOfKg(user1), 7);
        assertEq(fthGold.balanceOfKg(user2), 3);
    }

    function test_MintLimits() public {
        // Set custom mint limit for user1
        vm.prank(admin);
        fthGold.setMintLimit(user1, 50); // 50 kg limit

        // Should be able to mint up to limit
        vm.prank(issuer);
        fthGold.mint(user1, 50, BATCH_ID);

        // Should fail to mint more
        vm.prank(issuer);
        vm.expectRevert();
        fthGold.mint(user1, 1, BATCH_ID);
    }

    function test_DailyMintCap() public {
        // Set low daily cap for testing
        vm.prank(admin);
        fthGold.setDailyMintCap(100); // 100 kg per day

        // Should be able to mint up to daily cap
        vm.prank(issuer);
        fthGold.mint(user1, 100, BATCH_ID);

        // Should fail to mint more same day
        vm.prank(issuer);
        vm.expectRevert();
        fthGold.mint(user2, 1, BATCH_ID);

        // Should work again next day
        vm.warp(block.timestamp + 1 days);
        vm.prank(issuer);
        fthGold.mint(user2, 50, BATCH_ID);

        assertEq(fthGold.balanceOfKg(user2), 50);
    }

    function test_MaxSupplyCap() public {
        // This would take too long to test with real max supply
        // So we'll test the logic by setting limit to current + small amount
        vm.prank(issuer);
        fthGold.mint(user1, 999999, BATCH_ID); // Close to max

        // Try to exceed max supply
        vm.prank(issuer);
        vm.expectRevert();
        fthGold.mint(user2, 2, BATCH_ID); // This should exceed MAX_SUPPLY
    }

    function test_PauseUnpause() public {
        vm.prank(issuer);
        fthGold.mint(user1, 10, BATCH_ID);

        // Pause transfers
        vm.prank(guardian);
        fthGold.pause();

        // Transfers should fail
        vm.prank(user1);
        vm.expectRevert();
        fthGold.transfer(user2, 1e18);

        // Unpause
        vm.prank(guardian);
        fthGold.unpause();

        // Transfers should work again
        vm.prank(user1);
        fthGold.transfer(user2, 1e18);

        assertEq(fthGold.balanceOfKg(user2), 1);
    }

    function test_Permit() public {
        vm.prank(issuer);
        fthGold.mint(user1, 10, BATCH_ID);

        // Create permit signature
        uint256 privateKey = 0x12345;
        address owner = vm.addr(privateKey);
        
        vm.prank(issuer);
        fthGold.mint(owner, 5, BATCH_ID);

        uint256 value = 2e18; // 2 kg
        uint256 deadline = block.timestamp + 1 hours;
        
        // Create permit
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                owner,
                user2,
                value,
                fthGold.nonces(owner),
                deadline
            )
        );
        
        bytes32 hash = keccak256(
            abi.encodePacked("\x19\x01", fthGold.DOMAIN_SEPARATOR(), structHash)
        );
        
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hash);

        // Execute permit
        fthGold.permit(owner, user2, value, deadline, v, r, s);

        // Verify allowance was set
        assertEq(fthGold.allowance(owner, user2), value);
    }

    function test_Snapshot() public {
        vm.prank(issuer);
        fthGold.mint(user1, 10, BATCH_ID);

        // Take snapshot
        vm.prank(admin);
        uint256 snapId = fthGold.snapshot();

        // Change balances
        vm.prank(user1);
        fthGold.transfer(user2, 3e18);

        // Check snapshot balances
        assertEq(fthGold.balanceOfAt(user1, snapId), 10e18);
        assertEq(fthGold.balanceOfAt(user2, snapId), 0);
        
        // Check current balances
        assertEq(fthGold.balanceOf(user1), 7e18);
        assertEq(fthGold.balanceOf(user2), 3e18);
    }

    function test_EmergencyBurn() public {
        vm.prank(issuer);
        fthGold.mint(user1, 10, BATCH_ID);

        // Emergency burn by guardian
        vm.prank(guardian);
        fthGold.emergencyBurn(user1, 3, "Emergency protocol");

        assertEq(fthGold.balanceOfKg(user1), 7);
    }

    function test_OnlyIssuerCanMint() public {
        vm.prank(user1);
        vm.expectRevert();
        fthGold.mint(user2, 1, BATCH_ID);
    }

    function test_OnlyIssuerCanBurn() public {
        vm.prank(issuer);
        fthGold.mint(user1, 5, BATCH_ID);

        vm.prank(user1);
        vm.expectRevert();
        fthGold.burn(user1, 1, "Test");
    }

    function test_OnlyGuardianCanPause() public {
        vm.prank(user1);
        vm.expectRevert();
        fthGold.pause();
    }

    function test_GetRemainingDailyMintCap() public {
        uint256 remaining = fthGold.getRemainingDailyMintCap();
        assertEq(remaining, 10000e18); // Default daily cap

        // Mint some
        vm.prank(issuer);
        fthGold.mint(user1, 100, BATCH_ID);

        remaining = fthGold.getRemainingDailyMintCap();
        assertEq(remaining, (10000 - 100) * 1e18);
    }
}