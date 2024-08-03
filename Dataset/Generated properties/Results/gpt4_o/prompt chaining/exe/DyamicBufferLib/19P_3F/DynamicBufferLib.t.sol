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
        buffer = buffer.reserve(2**16 - 1);
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
        buffer.data = "Hello";
        string memory str = buffer.s();
        assertEq(str, "Hello");
    }

    function testSInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        string memory str = buffer.s();
        buffer = buffer.p(" World");
        assertEq(buffer.s(), "Hello World");
    }

    function testSInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "";
        string memory str = buffer.s();
        assertEq(str, "");
    }

    function testPInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p("");
        assertEq(buffer.s(), "Hello");
    }

    function testPInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p(" World");
        assertEq(buffer.s(), "Hello World");
    }

    function testPInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.p(new bytes(20));
        assertTrue(buffer.data.length >= 30);
    }

    function testPInvariant4() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.p(new bytes(2**16 - 1));
        assertTrue(buffer.data.length >= 10);
    }

    function testPInvariant5() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.p("Hello");
        assertEq(buffer.s(), "Hello");
    }

    function testPMultipleInvariant1() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p("", "", "");
        assertEq(buffer.s(), "Hello");
    }

    function testPMultipleInvariant2() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p(" ", "World", "!");
        assertEq(buffer.s(), "Hello World!");
    }

    function testPMultipleInvariant3() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.p(new bytes(10), new bytes(10), new bytes(10));
        assertTrue(buffer.data.length >= 40);
    }

    function testPMultipleInvariant4() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.p(new bytes(2**16 - 1), new bytes(2**16 - 1), new bytes(2**16 - 1));
        assertTrue(buffer.data.length >= 10);
    }

    function testPMultipleInvariant5() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.p("Hello", " ", "World");
        assertEq(buffer.s(), "Hello World");
    }

    function testPMultipleInvariant6() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(0);
        buffer = buffer.p("Hello", "", "World");
        assertEq(buffer.s(), "HelloWorld");
    }

//    function testDeallocateInvariant1() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer.data = new bytes(10);
//        DynamicBufferLib._deallocate(buffer);
//        /// @solidity memory-safe-assembly
//        assembly {
//            let freeMemPtr := mload(0x40)
//            assert(freeMemPtr == buffer)
//        }
//    }

//    function testDeallocateInvariant2() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer.data = new bytes(0);
//        DynamicBufferLib._deallocate(buffer);
//        /// @solidity memory-safe-assembly
//        assembly {
//            let freeMemPtr := mload(0x40)
//            assert(freeMemPtr == buffer)
//        }
//    }
}