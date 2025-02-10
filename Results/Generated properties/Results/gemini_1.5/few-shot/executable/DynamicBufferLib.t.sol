// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";
contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    function testClear() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.data = "hello";
        buf.clear();
        assertEq(buf.data.length, 0);
    }
    function testS() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.data = "hello";
        assertEq(buf.s(), "hello");
    }
    function testP() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello");
        assertEq(buf.data, "hello");
        buf.p("world");
        assertEq(buf.data, "helloworld");
    }
    function testP2() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello", "world");
        assertEq(buf.data, "helloworld");
    }
    function testP3() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello", "world", "!");
        assertEq(buf.data, "helloworld!");
    }
    function testP4() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello", "world", "!", "!");
        assertEq(buf.data, "helloworld!!");
    }
    function testP5() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello", "world", "!", "!", "!");
        assertEq(buf.data, "helloworld!!!");
    }
    function testP6() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello", "world", "!", "!", "!", "!");
        assertEq(buf.data, "helloworld!!!!");
    }
    function testP7() public {
        DynamicBufferLib.DynamicBuffer memory buf;
        buf.p("hello", "world", "!", "!", "!", "!", "!");
        assertEq(buf.data, "helloworld!!!!!");
    }
}
