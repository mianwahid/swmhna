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

    function testMulticallSingleCall() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("testFunction()");
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 1);
    }

    function testMulticallMultipleCalls() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("testFunction()");
        data[1] = abi.encodeWithSignature("testFunction()");
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 2);
    }

    function testMulticallEmptyData() public {
        bytes[] memory data = new bytes[](0);
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 0);
    }

    function testMulticallRevert() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertFunction()");
        vm.expectRevert();
        multicallable.multicall(data);
    }

    function testMulticallWithDifferentFunctions() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("testFunction()");
        data[1] = abi.encodeWithSignature("anotherTestFunction()");
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 2);
    }

    function testMulticallWithLargeData() public {
        bytes[] memory data = new bytes[](10);
        for (uint256 i = 0; i < 10; i++) {
            data[i] = abi.encodeWithSignature("testFunction()");
        }
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 10);
    }

    function testMulticallGasUsage() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("testFunction()");
        uint256 gasStart = gasleft();
        multicallable.multicall(data);
        uint256 gasUsed = gasStart - gasleft();
        console2.log("Gas used for single call:", gasUsed);
    }

    function testMulticallDelegateCall() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("delegateCallFunction()");
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 1);
    }
}

contract MulticallableTestContract is Multicallable {
    function testFunction() public pure returns (string memory) {
        return "testFunction called";
    }

    function anotherTestFunction() public pure returns (string memory) {
        return "anotherTestFunction called";
    }

    function revertFunction() public pure {
        require(false, "revertFunction called");
    }

    function delegateCallFunction() public pure returns (string memory) {
        return "delegateCallFunction called";
    }
}