// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    using SSTORE2 for bytes;

    // Test data
    bytes testData = "Hello, SSTORE2!";
    bytes32 testSalt = keccak256("testSalt");
    address deployer = address(this);

    function testWriteDeploymentSuccess() public {
        address pointer = SSTORE2.write(testData);
        assert(pointer != address(0));
    }

    function testWriteDataIntegrity() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData);
    }

//    function testWriteGasLimit() public {
//        bytes memory largeData = new bytes(24577); // 24,577 bytes
//        vm.expectRevert();
//        SSTORE2.write(largeData);
//    }

//    function testWriteDeploymentFailure() public {
//        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
//        vm.etch(address(0x123), ""); // Simulate deployment failure
//        SSTORE2.write(testData);
//    }

    function testWriteDeterministicAddress() public {
        address pointer = SSTORE2.writeDeterministic(testData, testSalt);
        assert(pointer != address(0));
    }

    function testWriteDeterministicDataIntegrity() public {
        address pointer = SSTORE2.writeDeterministic(testData, testSalt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData);
    }

//    function testWriteDeterministicGasLimit() public {
//        bytes memory largeData = new bytes(24577); // 24,577 bytes
//        vm.expectRevert();
//        SSTORE2.writeDeterministic(largeData, testSalt);
//    }

//    function testWriteDeterministicDeploymentFailure() public {
//        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
//        vm.etch(address(0x123), ""); // Simulate deployment failure
//        SSTORE2.writeDeterministic(testData, testSalt);
//    }

//    function testInitCodeHashCorrectness() public {
//        bytes32 hash = SSTORE2.initCodeHash(testData);
//        bytes32 expectedHash = keccak256(abi.encodePacked(hex"61000080600a3d393df300", testData));
//        assertEq(hash, expectedHash);
//    }

    function testPredictDeterministicAddressCorrectness() public {
        address predicted = SSTORE2.predictDeterministicAddress(testData, testSalt, deployer);
        address actual = SSTORE2.writeDeterministic(testData, testSalt);
        assertEq(predicted, actual);
    }

    function testReadValidPointer() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData);
    }

    function testReadInvalidPointer() public {
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(address(0x123));
    }

    function testReadDataIntegrity() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(testData, readData);
    }

    function testReadEmptyData() public {
        address pointer = SSTORE2.write("");
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(readData.length, 0);
    }

    function testReadWithStartIndex() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer, 7);
        bytes memory expectedData = "SSTORE2!";
        assertEq(readData, expectedData);
    }

    function testReadWithStartIndexInvalidPointer() public {
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(address(0x123), 7);
    }

    function testReadWithStartIndexOutOfBounds() public {
        address pointer = SSTORE2.write(testData);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 20);
    }

    function testReadWithStartIndexDataIntegrity() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer, 7);
        bytes memory expectedData = "SSTORE2!";
        assertEq(readData, expectedData);
    }

    function testReadWithStartEndIndices() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer, 7, 14);
        bytes memory expectedData = "SSTORE2";
        assertEq(readData, expectedData);
    }

    function testReadWithStartEndIndicesInvalidPointer() public {
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(address(0x123), 7, 14);
    }

    function testReadWithStartEndIndicesOutOfBounds() public {
        address pointer = SSTORE2.write(testData);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 7, 20);
    }

    function testReadWithStartEndIndicesInvalidRange() public {
        address pointer = SSTORE2.write(testData);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 14, 7);
    }

    function testReadWithStartEndIndicesDataIntegrity() public {
        address pointer = SSTORE2.write(testData);
        bytes memory readData = SSTORE2.read(pointer, 7, 14);
        bytes memory expectedData = "SSTORE2";
        assertEq(readData, expectedData);
    }
}