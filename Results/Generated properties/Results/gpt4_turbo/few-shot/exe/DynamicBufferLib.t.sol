// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import {Test} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

//    function testReserve() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer.data = "initial data";
//        uint256 initialLength = bytes(buffer.data).length;
//        uint256 reserveLength = 64;
//
//        DynamicBufferLib.DynamicBuffer memory result = buffer.reserve(reserveLength);
//
//        assertEq(result.data.length, initialLength, "Length should not change after reserve");
//        assertTrue(bytes(result.data).length >= reserveLength, "Reserved length should be at least the minimum required");
//    }

    function testClear() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "initial data";
        DynamicBufferLib.DynamicBuffer memory result = buffer.clear();

        assertEq(result.data.length, 0, "Buffer should be cleared");
    }

    function testAppendData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "Hello";
        bytes memory data2 = " World";

        buffer = buffer.p(data);
        assertEq(string(buffer.data), "Hello", "Buffer should contain 'Hello'");

        buffer = buffer.p(data2);
        assertEq(string(buffer.data), "Hello World", "Buffer should contain 'Hello World'");
    }

    function testAppendMultipleData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data0 = "Hello";
        bytes memory data1 = ", ";
        bytes memory data2 = "World";
        bytes memory data3 = "!";
        
        buffer = buffer.p(data0, data1, data2, data3);
        assertEq(string(buffer.data), "Hello, World!", "Buffer should contain 'Hello, World!'");
    }

    function testStringConversion() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello World";

        string memory result = buffer.s();
        assertEq(result, "Hello World", "String conversion should match the original data");
    }

//    function testReserveAndAppend() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        bytes memory data = "Hello";
//        uint256 reserveLength = 64;
//
//        buffer = buffer.reserve(reserveLength);
//        buffer = buffer.p(data);
//
//        assertEq(string(buffer.data), "Hello", "Buffer should contain 'Hello'");
//        assertTrue(bytes(buffer.data).length >= reserveLength, "Reserved length should be at least the minimum required");
//    }

    function testClearAndAppend() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "initial data";
        bytes memory data = "new data";

        buffer = buffer.clear();
        buffer = buffer.p(data);

        assertEq(string(buffer.data), "new data", "Buffer should contain 'new data' after clear and append");
    }

    function testMultipleAppends() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data0 = "Hello";
        bytes memory data1 = ", ";
        bytes memory data2 = "World";
        bytes memory data3 = "!";
        bytes memory data4 = " Have";
        bytes memory data5 = " a";
        bytes memory data6 = " nice day.";

        buffer = buffer.p(data0, data1, data2, data3, data4, data5, data6);
        assertEq(string(buffer.data), "Hello, World! Have a nice day.", "Buffer should contain the concatenated string");
    }
}