// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    using SSTORE2 for bytes;

    address deployer;

    function setUp() public {
        deployer = address(this);
    }

    // Invariants for write Function

    function testWriteSuccessfulDeployment() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        assert(pointer != address(0));

        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData, data);
    }

    function testWriteDeploymentFailure() public {
        bytes memory data = new bytes(24577); // Exceeds maximum contract size
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.write(data);
    }

    // Invariants for writeDeterministic Function

    function testWriteDeterministicSuccessfulDeployment() public {
        bytes memory data = "Hello, World!";
        bytes32 salt = keccak256("salt");
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assert(pointer != address(0));

        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData, data);

        address predictedAddress = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        assertEq(pointer, predictedAddress);
    }

    function testWriteDeterministicDeploymentFailure() public {
        bytes memory data = new bytes(24577); // Exceeds maximum contract size
        bytes32 salt = keccak256("salt");
        vm.expectRevert(SSTORE2.DeploymentFailed.selector);
        SSTORE2.writeDeterministic(data, salt);
    }

    // Invariants for initCodeHash Function

    function testInitCodeHashCorrectCalculation() public {
        bytes memory data = "Hello, World!";
        bytes32 hash1 = SSTORE2.initCodeHash(data);
        bytes32 hash2 = SSTORE2.initCodeHash(data);
        assertEq(hash1, hash2);
    }

    // Invariants for predictDeterministicAddress Function

    function testPredictDeterministicAddressCorrectPrediction() public {
        bytes memory data = "Hello, World!";
        bytes32 salt = keccak256("salt");
        address predictedAddress = SSTORE2.predictDeterministicAddress(data, salt, deployer);
        address pointer = SSTORE2.writeDeterministic(data, salt);
        assertEq(pointer, predictedAddress);
    }

    // Invariants for read Function

    function testReadValidPointer() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(storedData, data);
    }

    function testReadInvalidPointer() public {
        address invalidPointer = address(0x123456);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer);
    }

    // Invariants for read Function (with start)

    function testReadWithStartValidPointerAndStart() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        bytes memory storedData = SSTORE2.read(pointer, 7);
        assertEq(storedData, "World!");
    }

    function testReadWithStartInvalidPointer() public {
        address invalidPointer = address(0x123456);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer, 0);
    }

    function testReadWithStartOutOfBoundsStart() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 20);
    }

    // Invariants for read Function (with start and end)

    function testReadWithStartAndEndValidPointerStartAndEnd() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        bytes memory storedData = SSTORE2.read(pointer, 7, 12);
        assertEq(storedData, "World");
    }

    function testReadWithStartAndEndInvalidPointer() public {
        address invalidPointer = address(0x123456);
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(invalidPointer, 0, 5);
    }

    function testReadWithStartAndEndOutOfBoundsStartOrEnd() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 7, 20);
    }

    function testReadWithStartAndEndStartGreaterThanEnd() public {
        bytes memory data = "Hello, World!";
        address pointer = SSTORE2.write(data);
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 12, 7);
    }
}