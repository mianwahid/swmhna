// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {DynamicBufferLib} from "../src/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    function testInitialBufferIsEmpty() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        assertEq(buffer.data.length, 0, "Initial buffer should be empty");
    }

    // function testReserveIncreasesCapacity() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     uint256 initialCapacity = 32;
    //     buffer = buffer.reserve(initialCapacity);
    //     assertTrue(
    //         buffer.data.length >= initialCapacity,
    //         "Buffer capacity should be at least the reserved amount"
    //     );
    // }

    // function testClearResetsBufferButNotCapacity() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     bytes memory data = "Hello, world!";
    //     buffer = buffer.p(data);
    //     uint256 oldCapacity = buffer.data.length;
    //     buffer = buffer.clear();
    //     assertEq(buffer.data.length, oldCapacity, "Capacity should remain unchanged after clear");
    //     assertEq(bytes(buffer.s()).length, 0, "Buffer should be empty after clear");
    // }

    function testAppendDataIncreasesLength() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "Hello, world!";
        uint256 oldLength = buffer.data.length;
        buffer = buffer.p(data);
        assertEq(
            buffer.data.length,
            oldLength + data.length,
            "Buffer length should increase by length of appended data"
        );
    }

    function testChainedAppends() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "Hello, ";
        bytes memory data2 = "world!";
        buffer = buffer.p(data1).p(data2);
        assertEq(
            bytes(buffer.s()).length,
            data1.length + data2.length,
            "Buffer should contain concatenated data lengths"
        );
        assertEq(
            string(buffer.s()),
            "Hello, world!",
            "Buffer should contain concatenated strings"
        );
    }

    function testMultipleAppends() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "This ";
        bytes memory data2 = "is ";
        bytes memory data3 = "a ";
        bytes memory data4 = "test.";
        buffer = buffer.p(data1, data2, data3, data4);
        assertEq(
            string(buffer.s()),
            "This is a test.",
            "Buffer should contain concatenated strings"
        );
    }

    // function testReserveWithExistingData() public {
    //     DynamicBufferLib.DynamicBuffer memory buffer;
    //     bytes memory data = "Initial data";
    //     buffer = buffer.p(data);
    //     uint256 newMin = 1024;
    //     buffer = buffer.reserve(newMin);
    //     assertEq(
    //         string(buffer.s()),
    //         "Initial data",
    //         "Data should remain intact after reserve"
    //     );
    //     assertTrue(
    //         buffer.data.length >= newMin,
    //         "Buffer capacity should be at least the reserved amount"
    //     );
    // }

    function testAppendAfterClear() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "Data before clear";
        buffer = buffer.p(data1);
        buffer = buffer.clear();
        bytes memory data2 = "Data after clear";
        buffer = buffer.p(data2);
        assertEq(
            string(buffer.s()),
            "Data after clear",
            "Buffer should only contain data after clear"
        );
    }

    function testAppendEmptyData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "";
        uint256 oldLength = buffer.data.length;
        buffer = buffer.p(data);
        assertEq(
            buffer.data.length,
            oldLength,
            "Appending empty data should not change buffer length"
        );
    }

    function testAppendLargeData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory largeData = new bytes(8192); // Large data block
        buffer = buffer.p(largeData);
        assertEq(
            buffer.data.length,
            largeData.length,
            "Buffer should accommodate large data"
        );
    }

    function testAppendDataBoundaryCases() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = new bytes(32); // Exactly one word
        buffer = buffer.p(data);
        assertEq(
            buffer.data.length,
            data.length,
            "Buffer should exactly fit one-word data"
        );

        bytes memory data2 = new bytes(33); // Just over one word
        buffer = buffer.p(data2);
        assertEq(
            buffer.data.length,
            data.length + data2.length,
            "Buffer should fit data just over one word"
        );
    }

    function testMemorySafety() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "Test data";
        buffer = buffer.p(data);
        bytes memory moreData = " more data";
        buffer = buffer.p(moreData);
        assertEq(
            string(buffer.s()),
            "Test data more data",
            "Buffer should safely handle multiple appends"
        );
    }
}
