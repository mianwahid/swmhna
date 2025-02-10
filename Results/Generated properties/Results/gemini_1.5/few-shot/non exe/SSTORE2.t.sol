// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    function testWriteAndRead(bytes calldata data) public {
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData);
    }

    function testWriteAndReadDeterministic(bytes calldata data, bytes32 salt) public {
        address pointer = SSTORE2.writeDeterministic(data, salt);
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(data, readData);
    }

    function testWriteAndReadWithStart(bytes calldata data, uint256 start) public {
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, start);
        assertEq(data[start:], readData);
    }

    function testWriteAndReadWithStartAndEnd(
        bytes calldata data,
        uint256 start,
        uint256 end
    ) public {
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, start, end);
        assertEq(data[start:end], readData);
    }

    function testReadOutOfBoundsReverts(address pointer, uint256 start, uint256 end) public {
        vm.assume(start > end || end > SSTORE2.read(pointer).length);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, start, end);
    }

    function testInitCodeHash(bytes calldata data) public {
        bytes32 hash = SSTORE2.initCodeHash(data);
        address pointer = SSTORE2.writeDeterministic(data, bytes32(0));
        bytes32 bytecodeHash = keccak256(pointer.code);
        assertEq(hash, bytecodeHash);
    }

    function testPredictDeterministicAddress(bytes calldata data, bytes32 salt) public {
        address predicted = SSTORE2.predictDeterministicAddress(data, salt, address(this));
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assertEq(predicted, pointer);
    }

    function testDeploymentFailedReverts(bytes calldata data) public {
        // Data size is limited to less than 2**16.
        vm.assume(data.length >= 2**16 - 1);
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.write(data);
    }

    function testInvalidPointerReverts(address pointer) public {
        vm.assume(pointer.code.length == 0);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(pointer);
    }
}