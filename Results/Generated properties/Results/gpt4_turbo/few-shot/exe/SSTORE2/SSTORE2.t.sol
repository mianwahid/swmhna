// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import {Test} from "forge-std/Test.sol";
import {SSTORE2} from "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    // Test writing and reading back data
    function testWriteAndRead() public {
        bytes memory testData = "Hello, world!";
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData, "The read data should match the written data.");
    }

    // Test writing and reading back data with deterministic deployment
    function testWriteDeterministicAndRead() public {
        bytes memory testData = "Hello, deterministic world!";
        bytes32 salt = keccak256("deterministicSalt");
        address pointer = SSTORE2.writeDeterministic(testData, salt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData, "The read data should match the written deterministic data.");
    }

    // Test reading data from specific start to end
    function testReadWithBounds() public {
        bytes memory testData = "Hello, bounded world!";
        address pointer = SSTORE2.write(testData);
        // Read "bounded"
        bytes memory readData = SSTORE2.read(pointer, 7, 14);
        assertEq(readData, bytes("bounded"), "The read data should match the expected slice.");
    }

    // Test failure on reading out of bounds
    function testReadOutOfBounds() public {
        bytes memory testData = "Short data";
        address pointer = SSTORE2.write(testData);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 0, 100); // Attempt to read beyond the data length
    }

    // Test failure on invalid pointer
    function testInvalidPointer() public {
        address invalidPointer = address(0xdead);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer);
    }

    // Test the predictDeterministicAddress function
    function testPredictDeterministicAddress() public {
        bytes memory testData = "Predictable data";
        bytes32 salt = keccak256("predictableSalt");
        address deployer = address(this);
        address predictedAddress = SSTORE2.predictDeterministicAddress(testData, salt, deployer);
        address actualAddress = SSTORE2.writeDeterministic(testData, salt);
        assertEq(predictedAddress, actualAddress, "The predicted address should match the actual address.");
    }

    // Test deployment failure handling
    function testDeploymentFailure() public {
        bytes memory largeData = new bytes(24577); // Larger than the EVM contract size limit
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.write(largeData);
    }
}