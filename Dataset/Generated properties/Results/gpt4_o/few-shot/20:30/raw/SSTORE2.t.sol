// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    using SSTORE2 for *;

    function testWriteAndRead() public {
        bytes memory data = "Hello, SSTORE2!";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(readData, data);
    }

    function testWriteDeterministicAndRead() public {
        bytes memory data = "Hello, SSTORE2!";
        bytes32 salt = keccak256("testSalt");
        address pointer = SSTORE2.writeDeterministic(data, salt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(readData, data);
    }

    function testPredictDeterministicAddress() public {
        bytes memory data = "Hello, SSTORE2!";
        bytes32 salt = keccak256("testSalt");
        address deployer = address(this);
        address predicted = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assertEq(predicted, pointer);
    }

    function testReadOutOfBounds() public {
        bytes memory data = "Hello, SSTORE2!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 0, 100);
    }

    function testInvalidPointer() public {
        address invalidPointer = address(0x123);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer);
    }

    function testReadWithStart() public {
        bytes memory data = "Hello, SSTORE2!";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 7);
        assertEq(readData, "SSTORE2!");
    }

    function testReadWithStartAndEnd() public {
        bytes memory data = "Hello, SSTORE2!";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 7, 13);
        assertEq(readData, "SSTORE");
    }

    function testInitCodeHash() public {
        bytes memory data = "Hello, SSTORE2!";
        bytes32 hash = SSTORE2.initCodeHash(data);
        bytes32 expectedHash = keccak256(abi.encodePacked(
            hex"61000080600a3d393df300",
            data
        ));
        assertEq(hash, expectedHash);
    }
}