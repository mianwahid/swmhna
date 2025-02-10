// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    MulticallableTestContract multicallable;

    function setUp() public {
        multicallable = new MulticallableTestContract();
    }

    function testMulticallSingleFunction() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("testFunction(uint256)", 42);

        bytes[] memory results = multicallable.multicall(data);

        uint256 result = abi.decode(results[0], (uint256));
        assertEq(result, 42);
    }

    function testMulticallMultipleFunctions() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("testFunction(uint256)", 42);
        data[1] = abi.encodeWithSignature("testFunction(uint256)", 84);

        bytes[] memory results = multicallable.multicall(data);

        uint256 result1 = abi.decode(results[0], (uint256));
        uint256 result2 = abi.decode(results[1], (uint256));
        assertEq(result1, 42);
        assertEq(result2, 84);
    }

    function testMulticallReverts() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("testFunction(uint256)", 42);
        data[1] = abi.encodeWithSignature("revertingFunction()");

        vm.expectRevert();
        multicallable.multicall(data);
    }

    function testMulticallEmpty() public {
        bytes[] memory data = new bytes[](0);

        bytes[] memory results = multicallable.multicall(data);

        assertEq(results.length, 0);
    }

//    function testMulticallWithPayableFunction() public {
//        bytes[] memory data = new bytes[](1);
//        data[0] = abi.encodeWithSignature("payableFunction()");
//
//        vm.expectRevert();
//        multicallable.multicall(data);
//    }
}

contract MulticallableTestContract is Multicallable {
    function testFunction(uint256 value) public pure returns (uint256) {
        return value;
    }

    function revertingFunction() public pure {
        revert("This function always reverts");
    }

    function payableFunction() public payable returns (uint256) {
        return msg.value;
    }
}