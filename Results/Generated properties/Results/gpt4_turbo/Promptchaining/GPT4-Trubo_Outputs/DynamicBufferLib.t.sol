// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    // function testReserve() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     buffer.data = "initial data";
    //     uint256 originalLength = buffer.data.length;
    //     uint256 minimum = 20;

    //     buffer.reserve(minimum);

    //     // Invariant 1
    //     assertGe(buffer.data.length, minimum, "Buffer length should be at least 'minimum' after reserve");

    //     // Invariant 2
    //     minimum = 5;
    //     buffer.reserve(minimum);
    //     assertEq(buffer.data.length, originalLength, "Buffer length should remain unchanged if minimum <= current length");

    //     // Invariant 3
    //     assertEq(bytes("initial data"), buffer.data, "Content should remain unchanged after reserve");
    // }

    // function testClear() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     buffer.data = "data to clear";
    //     uint256 originalCapacity = buffer.data.capacity();

    //     buffer.clear();

    //     // Invariant 1
    //     assertEq(buffer.data.length, 0, "Buffer length should be zero after clear");

    //     // Invariant 2
    //     assertGe(buffer.data.capacity(), originalCapacity, "Buffer capacity should not decrease after clear");
    // }

    function testStringConversion() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "test string";

        string memory result = buffer.s();

        // Invariant 1
        assertEq(
            result,
            string(buffer.data),
            "String conversion should match buffer data"
        );

        // Invariant 2
        buffer.data = "modified";
        assertEq(
            buffer.s(),
            "modified",
            "Modifications should reflect in the string conversion"
        );
    }

    // function testAppendData() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     bytes memory data = " appended";
    //     buffer.data = "initial";

    //     uint256 originalLength = buffer.data.length;

    //     buffer.p(data);

    //     // Invariant 1
    //     assertEq(buffer.data.length, originalLength + data.length, "Buffer length should be sum of original and appended data lengths");

    //     // Invariant 2
    //     assertEq(buffer.data, bytes("initial appended"), "Appended data should appear at the end of the buffer");

    //     // Invariant 3
    //     buffer.p("");
    //     assertEq(buffer.data, bytes("initial appended"), "Buffer should remain unchanged if empty data is appended");
    // }

    function testMultipleAppends() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data0 = "Hello";
        bytes memory data1 = ", ";
        bytes memory data2 = "World!";
        buffer.p(data0, data1, data2);

        // Invariant 1
        assertEq(
            buffer.data.length,
            data0.length + data1.length + data2.length,
            "Buffer length should reflect total appended data lengths"
        );

        // Invariant 2
        assertEq(
            buffer.data,
            bytes("Hello, World!"),
            "Data segments should appear in correct order in the buffer"
        );

        // Invariant 3
        buffer.p(" More data");
        assertEq(
            buffer.data,
            bytes("Hello, World! More data"),
            "Consecutive appends should be handled correctly"
        );
    }

    // function testDeallocate() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     buffer.data = "data before deallocation";

    //     DynamicBufferLib._deallocate(buffer);

    //     // Invariant 1
    //     try this.testAppendData() {
    //         // Should not revert
    //     } catch {
    //         revert("Subsequent operations after deallocation should not fail");
    //     }

    //     // Invariant 2
    //     assertEq(buffer.data.length, 0, "Buffer should be empty after deallocation");
    // }
}
