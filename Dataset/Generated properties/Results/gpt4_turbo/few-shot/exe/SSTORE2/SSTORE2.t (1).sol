// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {SSTORE2} from "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    function testWriteAndRead() public {
        // Test data to write
        bytes memory testData = "Hello, SSTORE2!";
        // Write data to a new storage contract
        address pointer = SSTORE2.write(testData);
        // Read data from the storage contract
        bytes memory result = SSTORE2.read(pointer);
        // Assert that the read data matches the written data
        assertEq(result, testData, "The read data should match the written data.");
    }

    function testWriteDeterministicAndRead() public {
        // Test data to write
        bytes memory testData = "Deterministic Hello, SSTORE2!";
        bytes32 salt = keccak256("deterministic_salt");
        // Write data to a new storage contract deterministically
        address pointer = SSTORE2.writeDeterministic(testData, salt);
        // Read data from the storage contract
        bytes memory result = SSTORE2.read(pointer);
        // Assert that the read data matches the written data
        assertEq(result, testData, "The read data should match the written data.");
    }

    function testReadWithStartAndEnd() public {
        // Test data to write
        bytes memory testData = "Hello, SSTORE2!";
        // Write data to a new storage contract
        address pointer = SSTORE2.write(testData);
        // Read a subset of the data from the storage contract
        bytes memory result = SSTORE2.read(pointer, 7, 14); // "SSTORE2!"
        // Assert that the read data matches the expected subset
        assertEq(result, "SSTORE2!", "The read data should match the expected subset.");
    }

    function testReadOutOfBounds() public {
        // Test data to write
        bytes memory testData = "Hello, SSTORE2!";
        // Write data to a new storage contract
        address pointer = SSTORE2.write(testData);
        // Attempt to read data beyond the bounds of the stored data
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 0, 100);
    }

    function testInvalidPointer() public {
        // Attempt to read from an invalid pointer
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(address(0));
    }

    function testWriteAndPredictAddress() public {
        // Test data to write
        bytes memory testData = "Predictable Hello, SSTORE2!";
        bytes32 salt = keccak256("predictable_salt");
        // Predict the address of the storage contract
        address predictedAddress = SSTORE2.predictDeterministicAddress(testData, salt, address(this));
        // Write data to a new storage contract deterministically
        address pointer = SSTORE2.writeDeterministic(testData, salt);
        // Assert that the predicted address matches the actual address
        assertEq(pointer, predictedAddress, "The predicted address should match the actual address.");
    }

    function testDeploymentFailure() public {
        // Test data to write
        bytes memory testData = new bytes(24577); // Exceeds max contract size
        // Attempt to write data that exceeds the max contract size
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.write(testData);
    }
}