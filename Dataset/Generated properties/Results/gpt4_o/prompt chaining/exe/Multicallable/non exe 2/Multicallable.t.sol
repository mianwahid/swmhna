// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    Multicallable multicallable;

    function setUp() public {
        multicallable = new Multicallable();
    }

    // 1. Empty Data Array
    function testEmptyDataArray() public {
        bytes[] memory data = new bytes[](0);
        bytes[] memory result = multicallable.multicall(data);
        assertEq(result.length, 0);
    }

    // 2. Single Call Success
    function testSingleCallSuccess() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("someFunction()");
        bytes[] memory result = multicallable.multicall(data);
        assertEq(result.length, 1);
    }

    // 3. Multiple Calls Success
    function testMultipleCallsSuccess() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("someFunction()");
        data[1] = abi.encodeWithSignature("anotherFunction()");
        bytes[] memory result = multicallable.multicall(data);
        assertEq(result.length, 2);
    }

    // 4. Call Reversion
    function testCallReversion() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("someFunction()");
        data[1] = abi.encodeWithSignature("revertingFunction()");
        vm.expectRevert();
        multicallable.multicall(data);
    }

    // 5. Non-Payable Guard
//    function testNonPayableGuard() public {
//        bytes[] memory data = new bytes[](1);
//        data[0] = abi.encodeWithSignature("someFunction()");
//        vm.expectRevert();
//        multicallable.multicall{value: 1 ether}(data);
//    }

    // 6. Gas Limit Handling
    function testGasLimitHandling() public {
        bytes[] memory data = new bytes[](1000);
        for (uint i = 0; i < 1000; i++) {
            data[i] = abi.encodeWithSignature("someFunction()");
        }
        vm.expectRevert();
        multicallable.multicall(data);
    }

    // 7. Return Data Size Handling
    function testReturnDataSizeHandling() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("functionWithSmallReturn()");
        data[1] = abi.encodeWithSignature("functionWithLargeReturn()");
        bytes[] memory result = multicallable.multicall(data);
        assertEq(result.length, 2);
    }

    // 8. Delegate Call Context
//    function testDelegateCallContext() public {
//        bytes[] memory data = new bytes[](1);
//        data[0] = abi.encodeWithSignature("stateChangingFunction()");
//        multicallable.multicall(data);
//        // Check state change
//        assertEq(multicallable.someStateVariable(), expectedValue);
//    }

    // 9. Reentrancy Protection
    function testReentrancyProtection() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("reentrantFunction()");
        vm.expectRevert();
        multicallable.multicall(data);
    }

    // 10. Calldata Manipulation
    function testCalldataManipulation() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("complexCalldataFunction(bytes)", abi.encode("someData"));
        bytes[] memory result = multicallable.multicall(data);
        assertEq(result.length, 1);
    }
}