// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    MulticallableImpl multicallable;

    function setUp() public {
        multicallable = new MulticallableImpl();
    }

    function testMulticallNoCalls() public {
        bytes[] memory calls = new bytes[](0);
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 0, "Should return an empty array for no calls");
    }

    function testMulticallSingleCall() public {
        bytes[] memory calls = new bytes[](1);
        calls[0] = abi.encodeWithSelector(MulticallableImpl.echo.selector, "Hello, world!");
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 1, "Should return one result");
        assertEq(string(abi.decode(results[0], (bytes))), "Hello, world!", "Echo function should return the input");
    }

    function testMulticallMultipleCalls() public {
        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(MulticallableImpl.echo.selector, "First call");
        calls[1] = abi.encodeWithSelector(MulticallableImpl.echo.selector, "Second call");
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 2, "Should return two results");
        assertEq(string(abi.decode(results[0], (bytes))), "First call", "First echo should return 'First call'");
        assertEq(string(abi.decode(results[1], (bytes))), "Second call", "Second echo should return 'Second call'");
    }

    function testMulticallRevert() public {
        bytes[] memory calls = new bytes[](1);
        calls[0] = abi.encodeWithSelector(MulticallableImpl.revertCall.selector);
        vm.expectRevert("Intentional revert");
        multicallable.multicall(calls);
    }

//    function testMulticallWithDifferentFunctions() public {
//        bytes[] memory calls = new bytes[](2);
//        calls[0] = abi.encodeWithSelector(MulticallableImpl.echo.selector, "Echo");
//        calls[1] = abi.encodeWithSelector(MulticallableImpl.count.selector);
//        bytes[] memory results = multicallable.multicall(calls);
//        assertEq(results.length, 2, "Should return two results");
//        assertEq(string(abi.decode(results[0], (bytes))), "Echo", "Echo function should return 'Echo'");
//        assertEq(uint256(abi.decode(results[1], (uint256))), 1, "Count function should return 1");
//    }

    function testMulticallWithStateChange() public {
        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(MulticallableImpl.increment.selector);
        calls[1] = abi.encodeWithSelector(MulticallableImpl.getCount.selector);
        bytes[] memory results = multicallable.multicall(calls);
        assertEq(results.length, 2, "Should return two results");
        assertEq(uint256(abi.decode(results[1], (uint256))), 1, "Count after increment should be 1");
    }
}

// Implementation of Multicallable for testing purposes
contract MulticallableImpl is Multicallable {
    uint256 private count;

    function echo(string calldata input) external pure returns (string memory) {
        return input;
    }

//    function count() external returns (uint256) {
//        return ++count;
//    }

    function getCount() external view returns (uint256) {
        return count;
    }

    function increment() external {
        count++;
    }

    function revertCall() external pure {
        revert("Intentional revert");
    }
}