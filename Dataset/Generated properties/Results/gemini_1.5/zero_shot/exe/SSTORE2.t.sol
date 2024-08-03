// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SSTORE2.sol";

contract SSTORE2Test is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The data read from the storage contract doesn't match the data written.
    error DataMismatch();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev A random salt to be used for testing.
    bytes32 internal constant SALT = bytes32("salt");

    /// @dev A random address to be used for testing.
    address internal constant USER = address(0x1337);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testWriteAndRead() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        if (keccak256(data) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadEmpty() public {
        bytes memory data = "";
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        if (keccak256(data) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadDeterministic() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.writeDeterministic(data, SALT);
        bytes memory readData = SSTORE2.read(pointer);
        if (keccak256(data) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadDeterministicEmpty() public {
        bytes memory data = "";
        address pointer = SSTORE2.writeDeterministic(data, SALT);
        bytes memory readData = SSTORE2.read(pointer);
        if (keccak256(data) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadWithStart() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 7);
        bytes memory expectedData = bytes("world!");
        if (keccak256(expectedData) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadWithStartEmpty() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 13);
        bytes memory expectedData = bytes("");
        if (keccak256(expectedData) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadWithStartAndEnd() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 7, 12);
        bytes memory expectedData = bytes("world");
        if (keccak256(expectedData) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testWriteAndReadWithStartAndEndEmpty() public {
        bytes memory data = bytes("Hello, world!");
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, 7, 7);
        bytes memory expectedData = bytes("");
        if (keccak256(expectedData) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    function testPredictDeterministicAddress() public {
        bytes memory data = bytes("Hello, world!");
        address predicted = SSTORE2.predictDeterministicAddress(data, SALT, address(this));
        address pointer = SSTORE2.writeDeterministic(data, SALT);
        assertEq(predicted, pointer);
    }

//    function testInitCodeHash() public {
//        bytes memory data = bytes("Hello, world!");
//        bytes32 hash = SSTORE2.initCodeHash(data);
//        bytes32 expectedHash = keccak256(
//            abi.encodePacked(
//                // Left shift `data.length + 1` by 64 so that it lines up with the 0000 after PUSH2.
//                // Add 1 to data size since we are prefixing it with a STOP opcode.
//                or(0xfd61000080600a3d393df300, shl(0x40, data.length + 1)),
//                // Add a STOP opcode as the first byte.
//                // Also PUSH2 is used since max contract size cap is 24,576 bytes which is less than 2 ** 16.
//                bytes1(0x00),
//                data
//            )
//        );
//        assertEq(hash, expectedHash);
//    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       FUZZ FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Tests that `write` and `read` work correctly for random data.
    function testFuzzWriteAndRead(bytes memory data) public {
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer);
        if (keccak256(data) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    /// @dev Tests that `writeDeterministic` and `read` work correctly for random data and salt.
    function testFuzzWriteAndReadDeterministic(bytes memory data, bytes32 salt) public {
        address pointer = SSTORE2.writeDeterministic(data, salt);
        bytes memory readData = SSTORE2.read(pointer);
        if (keccak256(data) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    /// @dev Tests that `write` and `read` with `start` work correctly for random data and start.
    function testFuzzWriteAndReadWithStart(bytes memory data, uint256 start) public {
        vm.assume(start < data.length);
        address pointer = SSTORE2.write(data);
        bytes memory readData = SSTORE2.read(pointer, start);
        bytes memory expectedData = new bytes(data.length - start);
        for (uint256 i = start; i < data.length; i++) {
            expectedData[i - start] = data[i];
        }
        if (keccak256(expectedData) != keccak256(readData)) {
            revert DataMismatch();
        }
    }

    /// @dev Tests that `write` and `read` with `start` and `end` work correctly for random data, start, and end.
//    function testFuzzWriteAndReadWithStartAndEnd(
//        bytes memory data,
//        uint256 start,
//        uint256 end
//    ) public {
//        vm.assume(start <= end && end < data.length);
//        address pointer = SSTORE2.write(data);
//        bytes memory readData = SSTORE2.read(pointer, start, end);
//        bytes memory expectedData = new bytes(end - start);
//        for (uint256 i = start; i < end; i++) {
//            expectedData[i - start] = data[i];
//        }
//        if (keccak256(expectedData) != keccak256(readData)) {
//            revert DataMismatch();
//        }
//    }
}