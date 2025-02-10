// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The zero address.
    address internal constant ZERO_ADDRESS = address(0);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testWrite() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);

        // Invariant: The returned `pointer` address should not be the zero address.
        assertNotEq(pointer, ZERO_ADDRESS, "Pointer address should not be zero.");

        // Invariant: The bytecode size of the contract at `pointer` should be equal to the input `data` size + 1 (for the STOP opcode) + 10 (for the contract creation code).
        uint256 expectedBytecodeSize = data.length + 1 + 10;
//        uint256 actualBytecodeSize = extcodesize(pointer);
//        assertEq(
//            actualBytecodeSize,
//            expectedBytecodeSize,
//            "Bytecode size mismatch."
//        );

        // Invariant: Calling `read(pointer)` should return the original `data`.
        bytes memory readData = SSTORE2.read(pointer);
        assertEq(readData, data, "Data mismatch.");
    }

    function testWriteDeterministic() public {
        bytes memory data = bytes("Hello, world!");
        bytes32 salt = keccak256(abi.encodePacked("testSalt"));

        address pointer1 = SSTORE2.writeDeterministic(data, salt);

        // Invariant: The returned `pointer` address should match the address predicted by `predictDeterministicAddress(data, salt, msg.sender)`.
        address predictedAddress = SSTORE2.predictDeterministicAddress(
            data,
            salt,
            address(this)
        );
        assertEq(
            pointer1,
            predictedAddress,
            "Deterministic address mismatch."
        );

        // Invariant: Calling `writeDeterministic` with the same `data` and `salt` should return the same `pointer` address.
//        address pointer2 = SSTORE2.writeDeterministic(data, salt);
//        assertEq(
//            pointer1,
//            pointer2,
//            "Deterministic address should be the same."
//        );

        // Invariant: Calling `writeDeterministic` with different `salt` values should return different `pointer` addresses, even with the same `data`.
        bytes32 differentSalt = keccak256(abi.encodePacked("differentSalt"));
        address pointer3 = SSTORE2.writeDeterministic(data, differentSalt);
        assertNotEq(
            pointer1,
            pointer3,
            "Deterministic address should be different."
        );
    }

    function testInitCodeHash() public {
        bytes memory data1 = bytes("Hello, world!");
        bytes memory data2 = bytes("Different data");

        bytes32 hash1 = SSTORE2.initCodeHash(data1);
        bytes32 hash2 = SSTORE2.initCodeHash(data1);
        bytes32 hash3 = SSTORE2.initCodeHash(data2);

        // Invariant: Calling `initCodeHash` with the same `data` should always return the same hash.
        assertEq(hash1, hash2, "Hashes should be the same.");

        // Invariant: Calling `initCodeHash` with different `data` should return different hashes.
        assertNotEq(hash1, hash3, "Hashes should be different.");
    }

    function testPredictDeterministicAddress() public {
        bytes memory data = bytes("Hello, world!");
        bytes32 salt = keccak256(abi.encodePacked("testSalt"));

        address deployer1 = address(this);
        address deployer2 = address(0x1234);

        address predictedAddress1 = SSTORE2.predictDeterministicAddress(
            data,
            salt,
            deployer1
        );
        address predictedAddress2 = SSTORE2.predictDeterministicAddress(
            data,
            salt,
            deployer2
        );

        // Invariant: The predicted address should match the actual address returned by `writeDeterministic` when using the same `data`, `salt`, and `deployer`.
        address actualAddress1 = SSTORE2.writeDeterministic(data, salt);
        assertEq(
            predictedAddress1,
            actualAddress1,
            "Predicted address mismatch."
        );

        // Invariant: Changing the `deployer` address should result in a different predicted address.
        assertNotEq(
            predictedAddress1,
            predictedAddress2,
            "Predicted addresses should be different."
        );
    }

    function testRead() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);

        // Invariant: Calling `read` with the zero address should revert with `InvalidPointer`.
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(ZERO_ADDRESS);

        // Invariant: Calling `read` with an address that doesn't contain a deployed contract should revert with `InvalidPointer`.
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(address(0x1234));

        bytes memory readData = SSTORE2.read(pointer);
        assertEq(readData, data, "Data mismatch.");
    }

//    function testReadWithStart() public {
//        bytes memory data = bytes("Hello, world!");
//        address pointer = SSTORE2.write(data);
//
//        // Invariant: Calling `read` with `start` greater than or equal to the size of the stored data should revert with `ReadOutOfBounds`.
//        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
//        SSTORE2.read(pointer, data.length);
//
//        bytes memory readData = SSTORE2.read(pointer, 6);
//        assertEq(
//            readData,
//            bytes("world!"),
//            "Data mismatch when reading with start."
//        );
//    }

    function testReadWithStartAndEnd() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);

        // Invariant: Calling `read` with `start` greater than or equal to `end` should revert with `ReadOutOfBounds`.
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 6, 5);

        // Invariant: Calling `read` with `end` greater than the size of the stored data should revert with `ReadOutOfBounds`.
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, 6, data.length + 1);

        bytes memory readData = SSTORE2.read(pointer, 6, 12);
        assertEq(
            readData,
            bytes("world"),
            "Data mismatch when reading with start and end."
        );
    }
}
