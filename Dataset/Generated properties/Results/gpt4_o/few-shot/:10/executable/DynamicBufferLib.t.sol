//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/DynamicBufferLib.sol";
//
//contract DynamicBufferLibTest is Test {
//    using DynamicBufferLib for *;
//
//
//
//    function testClear() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, World!");
//        buffer = buffer.clear();
//        assertEq(buffer.data.length, 0);
//    }
//
//    function testStringConversion() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, World!");
//        string memory str = buffer.s();
//        assertEq(str, "Hello, World!");
//    }
//
//    function testAppendSingle() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ");
//        buffer = buffer.p("World!");
//        assertEq(buffer.s(), "Hello, World!");
//    }
//
//    function testAppendMultiple() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ", "World!");
//        assertEq(buffer.s(), "Hello, World!");
//    }
//
//    function testAppendThree() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ", "World", "!");
//        assertEq(buffer.s(), "Hello, World!");
//    }
//
//    function testAppendFour() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ", "World", " from ", "Solidity!");
//        assertEq(buffer.s(), "Hello, World from Solidity!");
//    }
//
//    function testAppendFive() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ", "World", " from ", "Solidity", "!");
//        assertEq(buffer.s(), "Hello, World from Solidity!");
//    }
//
//    function testAppendSix() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ", "World", " from ", "Solidity", " and ", "Foundry!");
//        assertEq(buffer.s(), "Hello, World from Solidity and Foundry!");
//    }
//
//    function testAppendSeven() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, ", "World", " from ", "Solidity", " and ", "Foundry", "!");
//        assertEq(buffer.s(), "Hello, World from Solidity and Foundry!");
//    }
//
//    function testReserveAndAppend() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.reserve(128);
//        buffer = buffer.p("Hello, World!");
//        assertEq(buffer.s(), "Hello, World!");
//    }
//
//    function testClearAndAppend() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.p("Hello, World!");
//        buffer = buffer.clear();
//        buffer = buffer.p("New Data");
//        assertEq(buffer.s(), "New Data");
//    }
//
//    function testReserveClearAndAppend() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer = buffer.reserve(128);
//        buffer = buffer.clear();
//        buffer = buffer.p("New Data");
//        assertEq(buffer.s(), "New Data");
//    }
//}