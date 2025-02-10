// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    using SafeTransferLib for address;

    address payable internal testAddress;
    address internal testToken;
    address internal testFrom;
    address internal testTo;

    function setUp() public {
        testAddress = payable(address(0x123));
        testToken = address(0x456);
        testFrom = address(0x789);
        testTo = address(0xabc);
    }

    function testSafeTransferETH() public {
        vm.deal(address(this), 1 ether);
        SafeTransferLib.safeTransferETH(testAddress, 1 ether);
        assertEq(testAddress.balance, 1 ether);
    }

//    function testSafeTransferETHInsufficientBalance() public {
//        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
//        SafeTransferLib.safeTransferETH(testAddress, 1 ether);
//    }

    function testSafeTransferAllETH() public {
        vm.deal(address(this), 1 ether);
        SafeTransferLib.safeTransferAllETH(testAddress);
        assertEq(testAddress.balance, 1 ether);
    }

    function testForceSafeTransferETH() public {
        vm.deal(address(this), 1 ether);
        SafeTransferLib.forceSafeTransferETH(testAddress, 1 ether, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertEq(testAddress.balance, 1 ether);
    }

    function testForceSafeTransferETHInsufficientBalance() public {
        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
        SafeTransferLib.forceSafeTransferETH(testAddress, 1 ether, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
    }

    function testTrySafeTransferETH() public {
        vm.deal(address(this), 1 ether);
        bool success = SafeTransferLib.trySafeTransferETH(testAddress, 1 ether, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
        assertTrue(success);
        assertEq(testAddress.balance, 1 ether);
    }

//    function testTrySafeTransferETHInsufficientBalance() public {
//        bool success = SafeTransferLib.trySafeTransferETH(testAddress, 1 ether, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
//        assertFalse(success);
//    }

    function testSafeTransferFrom() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x23b872dd, testFrom, testTo, 100), abi.encode(true));
        SafeTransferLib.safeTransferFrom(testToken, testFrom, testTo, 100);
    }

//    function testSafeTransferFromFail() public {
//        vm.mockCall(testToken, abi.encodeWithSelector(0x23b872dd, testFrom, testTo, 100), abi.encode(false));
//        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
//        SafeTransferLib.safeTransferFrom(testToken, testFrom, testTo, 100);
//    }

    function testTrySafeTransferFrom() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x23b872dd, testFrom, testTo, 100), abi.encode(true));
        bool success = SafeTransferLib.trySafeTransferFrom(testToken, testFrom, testTo, 100);
        assertTrue(success);
    }

    function testTrySafeTransferFromFail() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x23b872dd, testFrom, testTo, 100), abi.encode(false));
        bool success = SafeTransferLib.trySafeTransferFrom(testToken, testFrom, testTo, 100);
        assertFalse(success);
    }

    function testSafeTransfer() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0xa9059cbb, testTo, 100), abi.encode(true));
        SafeTransferLib.safeTransfer(testToken, testTo, 100);
    }

//    function testSafeTransferFail() public {
//        vm.mockCall(testToken, abi.encodeWithSelector(0xa9059cbb, testTo, 100), abi.encode(false));
//        vm.expectRevert(SafeTransferLib.TransferFailed.selector);
//        SafeTransferLib.safeTransfer(testToken, testTo, 100);
//    }

    function testSafeApprove() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 100), abi.encode(true));
        SafeTransferLib.safeApprove(testToken, testTo, 100);
    }

//    function testSafeApproveFail() public {
//        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 100), abi.encode(false));
//        vm.expectRevert(SafeTransferLib.ApproveFailed.selector);
//        SafeTransferLib.safeApprove(testToken, testTo, 100);
//    }

    function testSafeApproveWithRetry() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 100), abi.encode(false));
        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 0), abi.encode(true));
        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 100), abi.encode(true));
        SafeTransferLib.safeApproveWithRetry(testToken, testTo, 100);
    }

//    function testSafeApproveWithRetryFail() public {
//        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 100), abi.encode(false));
//        vm.mockCall(testToken, abi.encodeWithSelector(0x095ea7b3, testTo, 0), abi.encode(false));
//        vm.expectRevert(SafeTransferLib.ApproveFailed.selector);
//        SafeTransferLib.safeApproveWithRetry(testToken, testTo, 100);
//    }

    function testBalanceOf() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x70a08231, address(this)), abi.encode(100));
        uint256 balance = SafeTransferLib.balanceOf(testToken, address(this));
        assertEq(balance, 100);
    }

    function testBalanceOfNonExistentToken() public {
        vm.mockCall(testToken, abi.encodeWithSelector(0x70a08231, address(this)), abi.encode(0));
        uint256 balance = SafeTransferLib.balanceOf(testToken, address(this));
        assertEq(balance, 0);
    }
}