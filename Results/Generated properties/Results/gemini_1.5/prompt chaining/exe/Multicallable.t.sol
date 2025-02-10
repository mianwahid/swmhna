// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTestContract is Multicallable {
    uint256 public number;
    string public text;

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function setText(string calldata _text) public {
        text = _text;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function getText() public view returns (string memory) {
        return text;
    }

    function revertWithError(string memory errorMessage) public pure {
        revert(errorMessage);
    }
}

contract MulticallableTest is Test {
    MulticallableTestContract testContract;

    function setUp() public {
        testContract = new MulticallableTestContract();
    }

//    function testNonPayable() public {
//        bytes[] memory data = new bytes[](1);
//        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);
//
//        vm.expectRevert();
//        vm.deal(address(this), 1 ether);
//        testContract.multicall{value: 1 wei}(data);
//    }

    function testEmptyDataArray() public {
        bytes[] memory data = new bytes[](0);
        bytes[] memory results = testContract.multicall(data);

        assertEq(results.length, 0);
    }

    function testSingleFunctionCall() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);

        bytes[] memory results = testContract.multicall(data);

        assertEq(results.length, 1);
        assertEq(testContract.number(), 100);
    }

    function testMultipleFunctionCalls() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);
        data[1] = abi.encodeWithSignature("setText(string)", "Hello");

        bytes[] memory results = testContract.multicall(data);

        assertEq(results.length, 2);
        assertEq(testContract.number(), 100);
        assertEq(testContract.getText(), "Hello");
    }

    function testFunctionCallsWithVaryingReturnDataSizes() public {
        bytes[] memory data = new bytes[](3);
        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);
        data[1] = abi.encodeWithSignature("setText(string)", "Hello");
        data[2] = abi.encodeWithSignature("getNumber()");

        bytes[] memory results = testContract.multicall(data);

        assertEq(results.length, 3);
        assertEq(results[2].length, 32);
        assertEq(uint256(bytes32(results[2])), 100);
    }

    function testSingleRevert() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);
        data[1] = abi.encodeWithSignature("revertWithError(string)", "Test Revert");

        vm.expectRevert("Test Revert");
        testContract.multicall(data);

        assertEq(testContract.number(), 0);
    }

    function testMultipleReverts() public {
        bytes[] memory data = new bytes[](3);
        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);
        data[1] = abi.encodeWithSignature("revertWithError(string)", "Test Revert 1");
        data[2] = abi.encodeWithSignature("revertWithError(string)", "Test Revert 2");

        vm.expectRevert("Test Revert 1");
        testContract.multicall(data);

        assertEq(testContract.number(), 0);
    }

    function testLargeDataArray() public {
        uint256 numCalls = 100;
        bytes[] memory data = new bytes[](numCalls);
        for (uint256 i = 0; i < numCalls; i++) {
            data[i] = abi.encodeWithSignature("setNumber(uint256)", i);
        }

        testContract.multicall(data);

        assertEq(testContract.number(), numCalls - 1);
    }

    function testFunctionCallsModifyingState() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("setNumber(uint256)", 100);
        data[1] = abi.encodeWithSignature("setNumber(uint256)", 200);

        testContract.multicall(data);

        assertEq(testContract.number(), 200);
    }
}
