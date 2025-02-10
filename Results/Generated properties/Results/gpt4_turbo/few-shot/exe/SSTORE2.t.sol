// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {SSTORE2} from "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    address public testAddress;

    function setUp() public {
        testAddress = address(new TestContract());
    }

    function testWriteAndRead() public {
        bytes memory testData = "Hello, world!";
        address pointer = SSTORE2.write(testData);

        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData, "The read data should match the written data.");
    }

    function testWriteDeterministicAndRead() public {
        bytes memory testData = "Hello, deterministic world!";
        bytes32 salt = keccak256("testSalt");
        address pointer = SSTORE2.writeDeterministic(testData, salt);

        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData, "The read data should match the written deterministic data.");
    }

    function testReadWithStart() public {
        bytes memory testData = "Hello, world!";
        address pointer = SSTORE2.write(testData);

        bytes memory readData = SSTORE2.read(pointer, 7); // Start reading from "world!"
        bytes memory expectedData = "world!";
        assertEq(readData, expectedData, "The read data should start from the specified byte.");
    }

    function testReadWithStartAndEnd() public {
        bytes memory testData = "Hello, world!";
        address pointer = SSTORE2.write(testData);

        bytes memory readData = SSTORE2.read(pointer, 7, 12); // Read "world"
        bytes memory expectedData = "world";
        assertEq(readData, expectedData, "The read data should be within the specified range.");
    }

    function testReadOutOfBounds() public {
        bytes memory testData = "Hello, world!";
        address pointer = SSTORE2.write(testData);

        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 0, 100); // Attempt to read beyond the data length
    }

//    function testInvalidPointer() public {
//        vm.expectRevert(SSTORE2.InvalidPointer.selector);
//        SSTORE2.read(testAddress); // Use an address that does not point to a storage contract
//    }

    function testPredictDeterministicAddress() public {
        bytes memory testData = "Predictable data";
        bytes32 salt = keccak256("predictableSalt");
        address deployer = address(this);

        address predictedAddress = SSTORE2.predictDeterministicAddress(testData, salt, deployer);
        address actualAddress = SSTORE2.writeDeterministic(testData, salt);

        assertEq(predictedAddress, actualAddress, "The predicted address should match the actual address.");
    }

//    function testDeploymentFailure() public {
//        bytes memory largeData = new bytes(24577); // Larger than the EVM contract size limit
//        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
//        SSTORE2.write(largeData);
//    }
}

contract TestContract {
    // This is a dummy contract used for testing invalid pointer reads.
}