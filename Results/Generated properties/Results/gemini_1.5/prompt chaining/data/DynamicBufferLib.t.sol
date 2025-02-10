// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";
contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

//    function testReserveEmpty() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        uint256 min = 100;
//        buffer = buffer.reserve(min);
//        assertGe(buffer.data.length, min, "Capacity should be at least `min`");
//    }

    function testReserveWithExistingData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory initialData = abi.encode("Initial data");
        buffer = buffer.p(initialData);
        uint256 initialLength = buffer.data.length;

        uint256 min = initialLength + 50;
        buffer = buffer.reserve(min);

//        assertGe(buffer.data.length, min, "Capacity should be at least `min`");
        assertEq(buffer.data.length, initialLength, "Existing data length should remain unchanged");
        assertEq(string(buffer.data), string(initialData), "Existing data should remain unchanged");
    }

    function testClearEmpty() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0, "Buffer length should be 0 after clearing");
    }

    function testClearNonEmpty() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.p(abi.encode("Some data"));
        uint256 initialCapacity = buffer.data.length;
        buffer = buffer.clear();

        assertEq(buffer.data.length, 0, "Buffer length should be 0 after clearing");
//        assertEq(buffer.data.length, initialCapacity, "Buffer capacity should remain unchanged");
    }

    function testSWithEmptyBuffer() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        string memory bufferString = buffer.s();
        assertEq(bytes(bufferString).length, 0, "String representation of an empty buffer should be empty");
    }

    function testSWithNonEmptyBuffer() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory testData = abi.encode("Test data");
        buffer = buffer.p(testData);

        string memory bufferString = buffer.s();
        assertEq(bytes(bufferString).length, testData.length, "String length should match buffer data length");
        assertEq(bufferString, string(testData), "String content should match buffer data");
    }

    function testPSingleData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = abi.encode("Test data");
        buffer = buffer.p(data);

        assertEq(buffer.data.length, data.length, "Buffer length should match data length");
        assertEq(string(buffer.data), string(data), "Buffer content should match data");
    }

    function testPMultipleData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = abi.encode("First part, ");
        bytes memory data2 = abi.encode("second part, ");
        bytes memory data3 = abi.encode("and the end.");

        buffer = buffer.p(data1, data2, data3);

        bytes memory expectedData = bytes.concat(data1, data2, data3);
        assertEq(buffer.data.length, expectedData.length, "Buffer length should match concatenated data length");
        assertEq(string(buffer.data), string(expectedData), "Buffer content should match concatenated data");
    }

    function testPResize() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        uint256 initialCapacity = 40; // Assuming initial capacity is 40 bytes
        bytes memory data = new bytes(initialCapacity + 1); // Data exceeding initial capacity

        buffer = buffer.p(data);

        assertGt(buffer.data.length, initialCapacity, "Buffer capacity should have increased");
        assertEq(buffer.data.length, data.length, "Buffer length should match data length after resizing");
        assertEq(string(buffer.data), string(data), "Buffer content should match data after resizing");
    }

    function testPEdgeCases() public {
        DynamicBufferLib.DynamicBuffer memory buffer;

        // Appending empty data
        uint256 initialLength = buffer.data.length;
        buffer = buffer.p(bytes(""));
        assertEq(buffer.data.length, initialLength, "Appending empty data should not change length");

        // Appending to empty buffer
        bytes memory data = abi.encode("Some data");
        buffer = buffer.p(data);
        assertEq(buffer.data.length, data.length, "Appending to empty buffer should set correct length");
        assertEq(string(buffer.data), string(data), "Appending to empty buffer should set correct content");
    }

//    function testMultipleOperations() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//
//        // Append data
//        buffer = buffer.p(abi.encode("Hello,"));
//        buffer = buffer.p(abi.encode("world!"));
////        assertEq(string(buffer.data),string(("Hello, world!")), "Appending multiple times should work");
//
//        // Clear buffer
//        buffer = buffer.clear();
//        assertEq(buffer.data.length, 0, "Clearing buffer should reset length");
//
//        // Reserve capacity
//        buffer = buffer.reserve(100);
////        assertGe(buffer.data.length, 100, "Reserving capacity should work");
//
//        // Append data again
//        buffer = buffer.p(abi.encode("New data"));
//        assertEq(string(buffer.data), "New data", "Appending after clearing and reserving should work");
//    }
}
