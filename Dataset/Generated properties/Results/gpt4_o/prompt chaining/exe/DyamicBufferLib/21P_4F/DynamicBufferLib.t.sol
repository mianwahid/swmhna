// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    function testReserveInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(5);
        assertEq(buffer.data.length, 10);
    }

    function testReserveInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(20);
        assertTrue(buffer.data.length >= 20);
    }

    function testReserveInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(5);
        assertEq(buffer.data.length, 10);
    }

    function testReserveInvariant4() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(0);
        assertEq(buffer.data.length, 10);
    }

    function testReserveInvariant5() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(2**16- 1);
        assertTrue(buffer.data.length >= 10);
    }

    function testClearInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0);
    }

    function testClearInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.clear();
        buffer = buffer.reserve(5);
        assertTrue(buffer.data.length >= 5);
    }

    function testClearInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0);
    }

    function testSInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        string memory str = buffer.s();
        assertEq(str, "hello");
    }

    function testSInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "";
        string memory str = buffer.s();
        assertEq(str, "");
    }

    function testSInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(2**16);
        string memory str = buffer.s();
        assertEq(bytes(str).length, 2**16);
    }

    function testPInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("");
        assertEq(buffer.data, "hello");
    }

    function testPInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("world");
        assertEq(buffer.data.length, 10);
    }

    function testPInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("world");
        assertEq(buffer.data, "helloworld");
    }

    function testPInvariant4() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(2**16);
        buffer = buffer.p(new bytes(2**16));
        assertTrue(buffer.data.length >= 2**16);
    }

    function testPInvariant5() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("world").p("!");
        assertEq(buffer.data, "helloworld!");
    }

    function testPInvariant6() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "";
        buffer = buffer.p("hello");
        assertEq(buffer.data, "hello");
    }

    function testPOverloadedInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("", "", "");
        assertEq(buffer.data, "hello");
    }

    function testPOverloadedInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("world", "!", "!!");
        assertEq(buffer.data.length, 13);
    }

    function testPOverloadedInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "hello";
        buffer = buffer.p("world", "!", "!!");
        assertEq(buffer.data, "helloworld!!!");
    }

    function testPOverloadedInvariant4() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(2**16);
        buffer = buffer.p(new bytes(2**16), new bytes(2**16), new bytes(2**16));
        assertTrue(buffer.data.length >= 2**16);
    }

    function testPOverloadedInvariant5() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "";
        buffer = buffer.p("hello", "world", "!");
        assertEq(buffer.data, "helloworld!");
    }

//    function testDeallocateInvariant1() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer.data = new bytes(10);
//        DynamicBufferLib._deallocate(buffer);
//        assertEq(buffer.data.length, 10);
//    }
//
//    function testDeallocateInvariant2() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer.data = new bytes(0);
//        DynamicBufferLib._deallocate(buffer);
//        assertEq(buffer.data.length, 0);
//    }

    function testGeneralInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.reserve(2**16 - 1);
        assertTrue(buffer.data.length >= 0);
    }

    function testGeneralInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.p(new bytes(2**16));
        assertTrue(buffer.data.length >= 2**16);
    }

    function testGeneralInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.reserve(2**16);
        assertTrue(buffer.data.length >= 2**16);
    }
}