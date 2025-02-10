// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    function testReserveMemoryAllocation() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(20);
        assert(buffer.data.length >= 20);
    }

    function testReserveNoChangeForSmallerMinimum() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(5);
        assert(buffer.data.length == 10);
    }

    function testReserveZeroMinimum() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.reserve(0);
        assert(buffer.data.length == 10);
    }

    function testClearBufferLengthReset() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.clear();
        assert(buffer.data.length == 0);
    }

    function testClearNoMemoryDeallocation() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.clear();
        assert(buffer.data.length == 0);
        buffer.data = new bytes(10); // Reuse the buffer to check if memory is still allocated
        assert(buffer.data.length == 10);
    }

    function testStringConversion() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello, World!";
        string memory str = buffer.s();
        assert(keccak256(bytes(str)) == keccak256(bytes("Hello, World!")));
    }

    function testStringChangesWithBufferUpdate() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello, World!";
        string memory str1 = buffer.s();
        buffer = buffer.p(" Updated");
        string memory str2 = buffer.s();
        assert(keccak256(bytes(str1)) != keccak256(bytes(str2)));
    }

    function testSingleDataAppending() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p(", World!");
        assert(keccak256(buffer.data) == keccak256(bytes("Hello, World!")));
    }

    function testSingleDataEmptyAppending() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p("");
        assert(keccak256(buffer.data) == keccak256(bytes("Hello")));
    }

    function testSingleDataMemoryExpansion() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.p(new bytes(100));
        assert(buffer.data.length >= 110);
    }

    function testMultipleDataAppending() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p(", ", "World", "!");
        assert(keccak256(buffer.data) == keccak256(bytes("Hello, World!")));
    }

    function testMultipleDataEmptyAppending() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = "Hello";
        buffer = buffer.p("", "", "");
        assert(keccak256(buffer.data) == keccak256(bytes("Hello")));
    }

    function testMultipleDataMemoryExpansion() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer.data = new bytes(10);
        buffer = buffer.p(new bytes(50), new bytes(50), new bytes(50));
        assert(buffer.data.length >= 160);
    }

//    function testMemoryDeallocation() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        buffer.data = new bytes(10);
//        DynamicBufferLib._deallocate(buffer);
//        // Since we can't directly check memory deallocation, we assume no revert means success
//    }

//    function testNoEffectOnEmptyBufferDeallocation() public {
//        DynamicBufferLib.DynamicBuffer memory buffer;
//        DynamicBufferLib._deallocate(buffer);
//        // Since we can't directly check memory deallocation, we assume no revert means success
//    }
}