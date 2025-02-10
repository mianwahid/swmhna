// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    Multicallable multicallable;

    function setUp() public {
        multicallable = new MulticallableMock();
    }

    function testMulticallNoCalls() public {
        bytes[] memory calls = new bytes[](0);
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 0, "Should return an empty array for no calls");
    }

    function testMulticallSingleCall() public {
        bytes[] memory calls = new bytes[](1);
        calls[0] = abi.encodeWithSignature("testFunction(uint256)", 123);
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 1, "Should return results for one call");
        uint256 result = abi.decode(results[0], (uint256));
        assertEq(result, 123, "Result of testFunction should be the input value");
    }

    function testMulticallMultipleCalls() public {
        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSignature("testFunction(uint256)", 123);
        calls[1] = abi.encodeWithSignature("testFunction(uint256)", 456);
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 2, "Should return results for two calls");
        uint256 result1 = abi.decode(results[0], (uint256));
        uint256 result2 = abi.decode(results[1], (uint256));
        assertEq(result1, 123, "Result of first call should be 123");
        assertEq(result2, 456, "Result of second call should be 456");
    }

    function testMulticallReverts() public {
        bytes[] memory calls = new bytes[](1);
        calls[0] = abi.encodeWithSignature("revertingFunction()");
        vm.expectRevert("Intentional revert");
        multicallable.multicall(calls);
    }

    function testMulticallWithDifferentReturnSizes() public {
        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSignature("testFunction(uint256)", 123);
        calls[1] = abi.encodeWithSignature("testFunctionReturnsTwo(uint256,uint256)", 123, 456);
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 2, "Should handle different return sizes");
        uint256 result1 = abi.decode(results[0], (uint256));
        (uint256 result2a, uint256 result2b) = abi.decode(results[1], (uint256, uint256));
        assertEq(result1, 123, "Result of first call should be 123");
        assertEq(result2a, 123, "First result of second call should be 123");
        assertEq(result2b, 456, "Second result of second call should be 456");
    }
}

// Mock contract to simulate the Multicallable behavior
contract MulticallableMock is Multicallable {
    function testFunction(uint256 x) external pure returns (uint256) {
        return x;
    }

    function testFunctionReturnsTwo(uint256 x, uint256 y) external pure returns (uint256, uint256) {
        return (x, y);
    }

    function revertingFunction() external pure {
        revert("Intentional revert");
    }
}