// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {SSTORE2} from "../src/SSTORE2.sol";

contract SSTORE2Test is Test {
    function testWriteAndRead() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(readData, data, "Data read does not match data written");
    }

    function testWriteAndReadEmptyData() public {
        bytes memory data = "";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(
            readData,
            data,
            "Data read does not match data written (empty data)"
        );
    }

    function testWriteAndReadOutOfBounds() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 100);
    }

    function testWriteAndReadWithStartAndEnd() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 0, 5);
        assertEq(
            readData,
            bytes("Hello"),
            "Data read does not match expected slice"
        );
    }

    function testWriteAndReadWithInvalidPointer() public {
        address invalidPointer = address(0xdead);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer);
    }

    function testWriteDeterministicAndRead() public {
        bytes memory data = "Hello, deterministic world!";
        bytes32 salt = keccak256("salt");
        address pointer = SSTORE2.writeDeterministic(data, salt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(
            readData,
            data,
            "Data read does not match data written deterministically"
        );
    }

    function testPredictDeterministicAddress() public {
        bytes memory data = "Hello, deterministic world!";
        bytes32 salt = keccak256("salt");
        address deployer = address(this);
        address predicted = SSTORE2.predictDeterministicAddress(
            data,
            salt,
            deployer
        );
        address actual = SSTORE2.writeDeterministic(data, salt);
        assertEq(
            predicted,
            actual,
            "Predicted address does not match actual address"
        );
    }

    // function testInitCodeHash() public {
    //     bytes memory data = "Hello, world!";
    //     bytes32 hash = SSTORE2.initCodeHash(data);
    //     bytes32 expectedHash = keccak256(abi.encodePacked(
    //         bytes1(0x00), // STOP opcode
    //         data
    //     ));
    //     assertEq(hash, expectedHash, "Init code hash does not match expected hash");
    // }

    // function testDeploymentFailure() public {
    //     bytes memory data = new bytes(24577); // Exceeds max contract size
    //     vm.expectRevert(SSTORE2.DeploymentFailed.selector);
    //     SSTORE2.write(data);
    // }

    function testReadWithStartEndOutOfBounds() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 0, 100);
    }

    function testReadWithEndLessThanStart() public {
        bytes memory data = "Hello, world!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 5, 3);
    }
}
