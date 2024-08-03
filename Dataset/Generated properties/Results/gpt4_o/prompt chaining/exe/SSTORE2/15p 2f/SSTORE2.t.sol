// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    using SSTORE2 for bytes;

    // Edge Case: Empty Data
    function testWriteEmptyData() public {
        bytes memory data = "";
        address pointer = SSTORE2.write(data);
        assert(pointer != address(0));
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData.length, 0);
    }

    // Edge Case: Maximum Data Size
    function testWriteMaxDataSize() public {
        bytes memory data = new bytes(24575);
        for (uint256 i = 0; i < 24575; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        address pointer = SSTORE2.write(data);
        assert(pointer != address(0));
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData, data);
    }

    // Edge Case: Deployment Failure
    function testWriteExceedMaxDataSize() public {
        bytes memory data = new bytes(24576);
        for (uint256 i = 0; i < 24576; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.write(data);
    }

    // Edge Case: Empty Data with Salt
    function testWriteDeterministicEmptyData() public {
        bytes memory data = "";
        bytes32 salt = keccak256("salt");
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assert(pointer != address(0));
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData.length, 0);
    }

    // Edge Case: Maximum Data Size with Salt
    function testWriteDeterministicMaxDataSize() public {
        bytes memory data = new bytes(24575);
        for (uint256 i = 0; i < 24575; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        bytes32 salt = keccak256("salt");
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assert(pointer != address(0));
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData, data);
    }

    // Edge Case: Deployment Failure with Salt
    function testWriteDeterministicExceedMaxDataSize() public {
        bytes memory data = new bytes(24576);
        for (uint256 i = 0; i < 24576; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        bytes32 salt = keccak256("salt");
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.writeDeterministic(data, salt);
    }

    // Edge Case: Empty Data
    function testInitCodeHashEmptyData() public {
        bytes memory data = "";
        bytes32 hash = SSTORE2.initCodeHash(data);
        assert(hash != bytes32(0));
    }

    // Edge Case: Maximum Data Size
    function testInitCodeHashMaxDataSize() public {
        bytes memory data = new bytes(24575);
        for (uint256 i = 0; i < 24575; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        bytes32 hash = SSTORE2.initCodeHash(data);
        assert(hash != bytes32(0));
    }

    // Edge Case: Empty Data with Salt and Deployer
    function testPredictDeterministicAddressEmptyData() public {
        bytes memory data = "";
        bytes32 salt = keccak256("salt");
        address deployer = address(this);
        address predicted = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        assert(predicted != address(0));
    }

    // Edge Case: Maximum Data Size with Salt and Deployer
    function testPredictDeterministicAddressMaxDataSize() public {
        bytes memory data = new bytes(24575);
        for (uint256 i = 0; i < 24575; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        bytes32 salt = keccak256("salt");
        address deployer = address(this);
        address predicted = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        assert(predicted != address(0));
    }

    // Edge Case: Valid Pointer
    function testReadValidPointer() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData, data);
    }

    // Edge Case: Invalid Pointer
    function testReadInvalidPointer() public {
        address invalidPointer = address(0x123456);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer);
    }

    // Edge Case: Valid Pointer with Start
    function testReadValidPointerWithStart() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        bytes memory storedData = SSTORE2.read(pointer, 7);
        assertEq(storedData, "world!");
    }

    // Edge Case: Start Out of Bounds
    function testReadStartOutOfBounds() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 20);
    }

    // Edge Case: Valid Pointer with Start and End
    function testReadValidPointerWithStartAndEnd() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        bytes memory storedData = SSTORE2.read(pointer, 7, 12);
        assertEq(storedData, "world");
    }

    // Edge Case: Start or End Out of Bounds
    function testReadStartOrEndOutOfBounds() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 7, 20);
    }

    // Edge Case: Start Greater than End
    function testReadStartGreaterThanEnd() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 12, 7);
    }
}