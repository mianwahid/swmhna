// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";
contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;
//    function testReserve(uint256 minimum) public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.reserve(minimum);
//        assertTrue(buffer.data.length >= minimum);
//    }
    function testClear() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.p("hello");
        buffer.clear();
        assertEq(buffer.data.length, 0);
    }
    function testP() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.p("hello");
        assertEq(buffer.data.length, 5);
        assertEq(buffer.s(), "hello");
    }
    function testPMultiple() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.p("hello", " ", "world");
        assertEq(buffer.data.length, 11);
        assertEq(buffer.s(), "hello world");
    }
    function testPReserve() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.reserve(100);
        buffer.p("hello");
        assertEq(buffer.data.length, 5);
        assertEq(buffer.s(), "hello");
    }
    function testPReserveClear() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.reserve(100);
        buffer.p("hello");
        buffer.clear();
        assertEq(buffer.data.length, 0);
    }
    function testPFuzz(bytes[8] memory data) public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        uint256 totalLength;
        for (uint256 i; i < data.length; ++i) {
            buffer.p(data[i]);
            totalLength += data[i].length;
        }
        assertEq(buffer.data.length, totalLength);
    }
} 
