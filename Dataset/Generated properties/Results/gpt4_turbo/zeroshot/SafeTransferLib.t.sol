// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {SafeTransferLib} from "../src/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    address constant token = address(0x1);
    address constant from = address(0x2);
    address constant to = address(0x3);
    uint256 constant amount = 1000;

    function setUp() public {
        vm.deal(address(this), 10 ether);
        vm.deal(from, 10 ether);
    }

    function testSafeTransferETH() public {
        vm.prank(from);
        SafeTransferLib.safeTransferETH(to, 1 ether);
        assertEq(address(to).balance, 1 ether);
    }

    // function testSafeTransferETHFail() public {
    //     vm.prank(from);
    //     vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
    //     SafeTransferLib.safeTransferETH(to, 11 ether);
    // }

    function testSafeTransferAllETH() public {
        uint256 balance = address(this).balance;
        SafeTransferLib.safeTransferAllETH(to);
        assertEq(address(to).balance, balance);
    }

    function testForceSafeTransferETH() public {
        SafeTransferLib.forceSafeTransferETH(to, 1 ether);
        assertEq(address(to).balance, 1 ether);
    }

    function testForceSafeTransferETHFail() public {
        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
        SafeTransferLib.forceSafeTransferETH(to, 11 ether);
    }

    function testTrySafeTransferETH() public {
        bool success = SafeTransferLib.trySafeTransferETH(to, 1 ether, 2300);
        assertTrue(success);
        assertEq(address(to).balance, 1 ether);
    }

    function testTrySafeTransferETHFail() public {
        bool success = SafeTransferLib.trySafeTransferETH(to, 11 ether, 2300);
        assertFalse(success);
    }

    function testSafeTransferFrom() public {
        vm.mockCall(
            token,
            abi.encodeWithSelector(0x23b872dd, from, to, amount),
            abi.encode(true)
        );
        SafeTransferLib.safeTransferFrom(token, from, to, amount);
    }

    // function testSafeTransferFromFail() public {
    //     vm.mockCall(token, abi.encodeWithSelector(0x23b872dd, from, to, amount), abi.encode(false));
    //     vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
    //     SafeTransferLib.safeTransferFrom(token, from, to, amount);
    // }

    function testSafeTransfer() public {
        vm.mockCall(
            token,
            abi.encodeWithSelector(0xa9059cbb, to, amount),
            abi.encode(true)
        );
        SafeTransferLib.safeTransfer(token, to, amount);
    }

    // function testSafeTransferFail() public {
    //     vm.mockCall(token, abi.encodeWithSelector(0xa9059cbb, to, amount), abi.encode(false));
    //     vm.expectRevert(SafeTransferLib.TransferFailed.selector);
    //     SafeTransferLib.safeTransfer(token, to, amount);
    // }

    function testSafeApprove() public {
        vm.mockCall(
            token,
            abi.encodeWithSelector(0x095ea7b3, to, amount),
            abi.encode(true)
        );
        SafeTransferLib.safeApprove(token, to, amount);
    }

    // function testSafeApproveFail() public {
    //     vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, amount), abi.encode(false));
    //     vm.expectRevert(SafeTransferLib.ApproveFailed.selector);
    //     SafeTransferLib.safeApprove(token, to, amount);
    // }

    function testSafeApproveWithRetry() public {
        vm.mockCall(
            token,
            abi.encodeWithSelector(0x095ea7b3, to, amount),
            abi.encode(false)
        );
        vm.mockCall(
            token,
            abi.encodeWithSelector(0x095ea7b3, to, 0),
            abi.encode(true)
        );
        vm.mockCall(
            token,
            abi.encodeWithSelector(0x095ea7b3, to, amount),
            abi.encode(true)
        );
        SafeTransferLib.safeApproveWithRetry(token, to, amount);
    }

    // function testSafeApproveWithRetryFail() public {
    //     vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, amount), abi.encode(false));
    //     vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, 0), abi.encode(true));
    //     vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, amount), abi.encode(false));
    //     vm.expectRevert(SafeTransferLib.ApproveFailed.selector);
    //     SafeTransferLib.safeApproveWithRetry(token, to, amount);
    // }
}
