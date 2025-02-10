// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    function testReserve() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Initial data";
        uint256 initialLength = bytes(buffer.data).length;
        uint256 reserveLength = 64;

        DynamicBufferLib.DynamicBuffer memory result = buffer.reserve(reserveLength);
        assertEq(bytes(result.data).length, initialLength, "Length should remain the same after reserve");
        assertTrue(bytes(result.data).length >= reserveLength, "Buffer should have reserved space");
    }

    function testClear() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Initial data";
        DynamicBufferLib.DynamicBuffer memory result = buffer.clear();
        assertEq(bytes(result.data).length, 0, "Buffer should be cleared");
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

    function testChainedAppends() public {
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
        bytes memory data = "Hello World";
        buffer = buffer.p(data);
        string memory result = buffer.s();
        assertEq(result, "Hello World", "String conversion should match 'Hello World'");
    }

    function testReserveAndAppend() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "Hello";
        uint256 reserveLength = 64;

        buffer = buffer.reserve(reserveLength);
        buffer = buffer.p(data);
        assertEq(string(buffer.data), "Hello", "Buffer should contain 'Hello' after reserve and append");
        assertTrue(bytes(buffer.data).length >= reserveLength, "Buffer should still respect reserved space");
    }

    function testClearAndAppend() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "Hello";
        bytes memory data2 = " World";

        buffer = buffer.p(data);
        buffer = buffer.clear();
        buffer = buffer.p(data2);
        assertEq(string(buffer.data), " World", "Buffer should only contain ' World' after clear and append");
    }
}