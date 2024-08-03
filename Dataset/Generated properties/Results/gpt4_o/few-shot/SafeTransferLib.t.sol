// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    using SafeTransferLib for address;

    address payable internal recipient;
    address internal token;
    address internal from;
    address internal to;

    function setUp() public {
        recipient = payable(address(0xBEEF));
        token = address(0xDEAD);
        from = address(0xABCD);
        to = address(0xCAFE);
    }

//    function testSafeTransferETH() public {
//        uint256 amount = 1 ether;
//        vm.deal(address(this), amount);
//        recipient.safeTransferETH(amount);
//        assertEq(recipient.balance, amount);
//    }
//
//    function testSafeTransferAllETH() public {
//        uint256 amount = 1 ether;
//        vm.deal(address(this), amount);
//        recipient.safeTransferAllETH();
//        assertEq(recipient.balance, amount);
//    }

//    function testForceSafeTransferETH() public {
//        uint256 amount = 1 ether;
//        vm.deal(address(this), amount);
//        recipient.forceSafeTransferETH(amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
//        assertEq(recipient.balance, amount);
//    }
//
//    function testForceSafeTransferAllETH() public {
//        uint256 amount = 1 ether;
//        vm.deal(address(this), amount);
//        recipient.forceSafeTransferAllETH(SafeTransferLib.GAS_STIPEND_NO_GRIEF);
//        assertEq(recipient.balance, amount);
//    }
//
//    function testTrySafeTransferETH() public {
//        uint256 amount = 1 ether;
//        vm.deal(address(this), amount);
//        bool success = recipient.trySafeTransferETH(amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF);
//        assertTrue(success);
//        assertEq(recipient.balance, amount);
//    }
//
//    function testTrySafeTransferAllETH() public {
//        uint256 amount = 1 ether;
//        vm.deal(address(this), amount);
//        bool success = recipient.trySafeTransferAllETH(SafeTransferLib.GAS_STIPEND_NO_GRIEF);
//        assertTrue(success);
//        assertEq(recipient.balance, amount);
//    }

    function testSafeTransferFrom() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x23b872dd, from, to, amount), abi.encode(true));
        token.safeTransferFrom(from, to, amount);
    }

    function testTrySafeTransferFrom() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x23b872dd, from, to, amount), abi.encode(true));
        bool success = token.trySafeTransferFrom(from, to, amount);
        assertTrue(success);
    }

    function testSafeTransferAllFrom() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x70a08231, from), abi.encode(amount));
        vm.mockCall(token, abi.encodeWithSelector(0x23b872dd, from, to, amount), abi.encode(true));
        uint256 transferredAmount = token.safeTransferAllFrom(from, to);
        assertEq(transferredAmount, amount);
    }

    function testSafeTransfer() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0xa9059cbb, to, amount), abi.encode(true));
        token.safeTransfer(to, amount);
    }

    function testSafeTransferAll() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x70a08231, address(this)), abi.encode(amount));
        vm.mockCall(token, abi.encodeWithSelector(0xa9059cbb, to, amount), abi.encode(true));
        uint256 transferredAmount = token.safeTransferAll(to);
        assertEq(transferredAmount, amount);
    }

    function testSafeApprove() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, amount), abi.encode(true));
        token.safeApprove(to, amount);
    }

    function testSafeApproveWithRetry() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, amount), abi.encode(false));
        vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, 0), abi.encode(true));
        vm.mockCall(token, abi.encodeWithSelector(0x095ea7b3, to, amount), abi.encode(true));
        token.safeApproveWithRetry(to, amount);
    }

    function testBalanceOf() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x70a08231, address(this)), abi.encode(amount));
        uint256 balance = token.balanceOf(address(this));
        assertEq(balance, amount);
    }

    function testSafeTransferFrom2() public {
        uint256 amount = 1000;
        vm.mockCall(token, abi.encodeWithSelector(0x23b872dd, from, to, amount), abi.encode(false));
        vm.mockCall(SafeTransferLib.PERMIT2, abi.encodeWithSelector(0x36c78516, from, to, amount, token), abi.encode(true));
        token.safeTransferFrom2(from, to, amount);
    }

    function testPermit2TransferFrom() public {
        uint256 amount = 1000;
        vm.mockCall(SafeTransferLib.PERMIT2, abi.encodeWithSelector(0x36c78516, from, to, amount, token), abi.encode(true));
        token.permit2TransferFrom(from, to, amount);
    }

//    function testPermit2() public {
//        uint256 amount = 1000;
//        uint256 deadline = block.timestamp + 1 days;
//        uint8 v = 27;
//        bytes32 r = keccak256("r");
//        bytes32 s = keccak256("s");
//        vm.mockCall(token, abi.encodeWithSelector(0xd505accf, from, to, amount, deadline, v, r, s), abi.encode(true));
//        token.permit2(token, from, to, amount, deadline, v, r, s);
//    }
//
//    function testSimplePermit2() public {
//        uint256 amount = 1000;
//        uint256 deadline = block.timestamp + 1 days;
//        uint8 v = 27;
//        bytes32 r = keccak256("r");
//        bytes32 s = keccak256("s");
//        vm.mockCall(SafeTransferLib.PERMIT2, abi.encodeWithSelector(0x2b67b570, from, to, amount, deadline, v, r, s), abi.encode(true));
//        token.simplePermit2(token, from, to, amount, deadline, v, r, s);
//    }
}