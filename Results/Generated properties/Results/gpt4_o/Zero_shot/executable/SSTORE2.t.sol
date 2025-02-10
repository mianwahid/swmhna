// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    using SSTORE2 for bytes;

    function testWriteAndRead() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData, "Data read should match data written");
    }

    function testWriteDeterministicAndRead() public {
        bytes memory data = "Hello, deterministic world!";
        bytes32 salt = keccak256("salt");
        address pointer = SSTORE2.writeDeterministic(data, salt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData, "Data read should match data written deterministically");
    }

    function testPredictDeterministicAddress() public {
        bytes memory data = "Predictable data";
        bytes32 salt = keccak256("salt");
        address deployer = address(this);
        address predicted = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assertEq(predicted, pointer, "Predicted address should match actual address");
    }

    function testReadOutOfBounds() public {
        bytes memory data = "Out of bounds data";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, data.length + 1);
    }

    function testInvalidPointer() public {
        address invalidPointer = address(0x123);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer);
    }

    function testReadPartialData() public {
        bytes memory data = "Partial data read";
        address pointer = SSTORE2.write(data);
        bytes memory partialData = SSTORE2.read(pointer, 8, 12);
        assertEq(partialData, "data", "Partial data read should match expected substring");
    }

    function testWriteLargeData() public {
        bytes memory data = new bytes(24576); // Max contract size
        for (uint256 i = 0; i < data.length; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData, "Large data read should match large data written");
    }

    function testWriteEmptyData() public {
        bytes memory data = "";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData, "Empty data read should match empty data written");
    }

    function testWriteAndReadWithFuzzing(bytes memory data) public {
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData, "Fuzzed data read should match fuzzed data written");
    }

    function testWriteDeterministicWithFuzzing(bytes memory data, bytes32 salt) public {
        address pointer = SSTORE2.writeDeterministic(data, salt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData, "Fuzzed deterministic data read should match fuzzed deterministic data written");
    }

    function testPredictDeterministicAddressWithFuzzing(bytes memory data, bytes32 salt) public {
        address deployer = address(this);
        address predicted = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assertEq(predicted, pointer, "Fuzzed predicted address should match fuzzed actual address");
    }
}