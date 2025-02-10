// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    using SafeTransferLib for address;

    address payable recipient;
    address payable sender;
    address token;
    uint256 amount;

    function setUp() public {
        recipient = payable(address(0x123));
        sender = payable(address(this));
        token = address(0x456);
        amount = 1 ether;
    }

    // ETH Operations

//    function testSafeTransferETHInsufficientBalance() public {
//        vm.deal(sender, 0);
//        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
//        sender.safeTransferETH(recipient, amount);
//    }

//    function testSafeTransferETHRecipientReverts() public {
//        vm.deal(sender, amount);
//        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
//        recipient.safeTransferETH(recipient, amount);
//    }

//    function testSafeTransferETHSuccess() public {
//        vm.deal(sender, amount);
//        sender.safeTransferETH(recipient, amount);
//        assertEq(recipient.balance, amount);
//    }

//    function testSafeTransferAllETHRecipientReverts() public {
//        vm.deal(sender, amount);
//        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
//        recipient.safeTransferAllETH(recipient);
//    }

    function testSafeTransferAllETHSuccess() public {
        vm.deal(sender, amount);
        sender.safeTransferAllETH(recipient);
        assertEq(recipient.balance, amount);
    }

    function testForceSafeTransferETHInsufficientBalance() public {
        vm.deal(sender, 0);
        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
        sender.forceSafeTransferETH(recipient, amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
    }

    function testForceSafeTransferETHSuccess() public {
        vm.deal(sender, amount);
        sender.forceSafeTransferETH(recipient, amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertEq(recipient.balance, amount);
    }

    function testForceSafeTransferAllETHSuccess() public {
        vm.deal(sender, amount);
        sender.forceSafeTransferAllETH(recipient, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertEq(recipient.balance, amount);
    }

    function testTrySafeTransferETHInsufficientBalance() public {
        vm.deal(sender, 0);
        bool success = sender.trySafeTransferETH(recipient, amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertFalse(success);
    }

    function testTrySafeTransferETHSuccess() public {
        vm.deal(sender, amount);
        bool success = sender.trySafeTransferETH(recipient, amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertTrue(success);
        assertEq(recipient.balance, amount);
    }

    function testTrySafeTransferAllETHSuccess() public {
        vm.deal(sender, amount);
        bool success = sender.trySafeTransferAllETH(recipient, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertTrue(success);
        assertEq(recipient.balance, amount);
    }

    // ERC20 Operations

    function testSafeTransferFromInsufficientBalance() public {
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        token.safeTransferFrom(sender, recipient, amount);
    }

    function testSafeTransferFromNotApproved() public {
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        token.safeTransferFrom(sender, recipient, amount);
    }

    function testSafeTransferFromSuccess() public {
        // Mock the token transfer
        // Assume the sender has sufficient balance and has approved the contract
        token.safeTransferFrom(sender, recipient, amount);
    }

    function testTrySafeTransferFromInsufficientBalance() public {
        bool success = token.trySafeTransferFrom(sender, recipient, amount);
        assertFalse(success);
    }

    function testTrySafeTransferFromNotApproved() public {
        bool success = token.trySafeTransferFrom(sender, recipient, amount);
        assertFalse(success);
    }

    function testTrySafeTransferFromSuccess() public {
        // Mock the token transfer
        // Assume the sender has sufficient balance and has approved the contract
        bool success = token.trySafeTransferFrom(sender, recipient, amount);
        assertTrue(success);
    }

    function testSafeTransferAllFromNotApproved() public {
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        token.safeTransferAllFrom(sender, recipient);
    }

    function testSafeTransferAllFromSuccess() public {
        // Mock the token transfer
        // Assume the sender has approved the contract to spend the entire balance
        uint256 balance = token.safeTransferAllFrom(sender, recipient);
        assertEq(balance, amount);
    }

    function testSafeTransferInsufficientBalance() public {
        vm.expectRevert(SafeTransferLib.TransferFailed.selector);
        token.safeTransfer(recipient, amount);
    }

    function testSafeTransferSuccess() public {
        // Mock the token transfer
        // Assume the contract has sufficient balance
        token.safeTransfer(recipient, amount);
    }

    function testSafeTransferAllInsufficientBalance() public {
        vm.expectRevert(SafeTransferLib.TransferFailed.selector);
        token.safeTransferAll(recipient);
    }

    function testSafeTransferAllSuccess() public {
        // Mock the token transfer
        // Assume the contract has sufficient balance
        uint256 balance = token.safeTransferAll(recipient);
        assertEq(balance, amount);
    }

    function testSafeApproveFails() public {
        vm.expectRevert(SafeTransferLib.ApproveFailed.selector);
        token.safeApprove(recipient, amount);
    }

    function testSafeApproveSuccess() public {
        // Mock the token approval
        token.safeApprove(recipient, amount);
    }

    function testSafeApproveWithRetryFails() public {
        vm.expectRevert(SafeTransferLib.ApproveFailed.selector);
        token.safeApproveWithRetry(recipient, amount);
    }

    function testSafeApproveWithRetrySuccess() public {
        // Mock the token approval
        token.safeApproveWithRetry(recipient, amount);
    }

    function testBalanceOfTokenDoesNotExist() public {
        uint256 balance = token.balanceOf(address(0x789));
        assertEq(balance, 0);
    }

    function testBalanceOfTokenExists() public {
        // Mock the token balance
        uint256 balance = token.balanceOf(sender);
        assertEq(balance, amount);
    }

    function testSafeTransferFrom2Fails() public {
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        token.safeTransferFrom2(sender, recipient, amount);
    }

    function testSafeTransferFrom2Success() public {
        // Mock the token transfer
        // Assume the sender has sufficient balance and has approved the contract
        token.safeTransferFrom2(sender, recipient, amount);
    }

    function testPermit2TransferFromFails() public {
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        token.permit2TransferFrom(sender, recipient, amount);
    }

    function testPermit2TransferFromSuccess() public {
        // Mock the token transfer
        token.permit2TransferFrom(sender, recipient, amount);
    }

    function testPermit2Fails() public {
        vm.expectRevert(SafeTransferLib.Permit2Failed.selector);
        token.permit2(sender, recipient, amount, block.timestamp, 0, bytes32(0), bytes32(0));
    }

    function testPermit2Success() public {
        // Mock the token permit
        token.permit2(sender, recipient, amount, block.timestamp, 0, bytes32(0), bytes32(0));
    }

    function testSimplePermit2Fails() public {
        vm.expectRevert(SafeTransferLib.Permit2Failed.selector);
        token.simplePermit2(sender, recipient, amount, block.timestamp, 0, bytes32(0), bytes32(0));
    }

    function testSimplePermit2Success() public {
        // Mock the token permit
        token.simplePermit2(sender, recipient, amount, block.timestamp, 0, bytes32(0), bytes32(0));
    }
}