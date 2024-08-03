// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DynamicBufferLib.sol";

contract DynamicBufferLibTest is Test {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;

    function testReserve() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.reserve(100);
        assertEq(buffer.data.length, 0);
    }

    function testClear() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.reserve(100);
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0);
    }

    function testStringConversion() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.reserve(100);
        string memory str = buffer.s();
        assertEq(bytes(str).length, 0);
    }

    function testAppendSingleData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data = "Hello, World!";
        buffer = buffer.p(data);
        assertEq(buffer.data.length, data.length);
        assertEq(keccak256(buffer.data), keccak256(data));
    }

    function testAppendMultipleData() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "Hello, ";
        bytes memory data2 = "World!";
        buffer = buffer.p(data1, data2);
        assertEq(buffer.data.length, data1.length + data2.length);
        assertEq(keccak256(buffer.data), keccak256(abi.encodePacked(data1, data2)));
    }

    function testAppendMultipleDataChaining() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "Hello, ";
        bytes memory data2 = "World!";
        bytes memory data3 = " How are you?";
        buffer = buffer.p(data1, data2, data3);
        assertEq(buffer.data.length, data1.length + data2.length + data3.length);
        assertEq(keccak256(buffer.data), keccak256(abi.encodePacked(data1, data2, data3)));
    }

    function testAppendMultipleDataChainingExtended() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "Hello, ";
        bytes memory data2 = "World!";
        bytes memory data3 = " How are you?";
        bytes memory data4 = " I am fine.";
        bytes memory data5 = " Thank you.";
        buffer = buffer.p(data1, data2, data3, data4, data5);
        assertEq(buffer.data.length, data1.length + data2.length + data3.length + data4.length + data5.length);
        assertEq(keccak256(buffer.data), keccak256(abi.encodePacked(data1, data2, data3, data4, data5)));
    }

    function testAppendMultipleDataChainingExtendedMore() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory data1 = "Hello, ";
        bytes memory data2 = "World!";
        bytes memory data3 = " How are you?";
        bytes memory data4 = " I am fine.";
        bytes memory data5 = " Thank you.";
        bytes memory data6 = " Goodbye.";
        buffer = buffer.p(data1, data2, data3, data4, data5, data6);
        assertEq(buffer.data.length, data1.length + data2.length + data3.length + data4.length + data5.length + data6.length);
        assertEq(keccak256(buffer.data), keccak256(abi.encodePacked(data1, data2, data3, data4, data5, data6)));
    }

    function testReserveEdgeCases() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.reserve(0);
        assertEq(buffer.data.length, 0);

        buffer = buffer.reserve(type(uint256).max%10000);
        assertEq(buffer.data.length, 0);
    }

    function testClearEdgeCases() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0);

        buffer = buffer.reserve(100);
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0);
    }

    function testAppendEdgeCases() public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        bytes memory emptyData = "";
        buffer = buffer.p(emptyData);
        assertEq(buffer.data.length, 0);

        bytes memory largeData = new bytes(type(uint256).max%10000);
        buffer = buffer.p(largeData);
        assertEq(buffer.data.length, type(uint256).max%10000);
    }



    function testFuzzClear(uint256 initialSize) public {
        initialSize=initialSize%10000;
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.reserve(initialSize);
        buffer = buffer.clear();
        assertEq(buffer.data.length, 0);
    }

    function testFuzzAppend(bytes memory data) public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.p(data);
        assertEq(buffer.data.length, data.length);
        assertEq(keccak256(buffer.data), keccak256(data));
    }

    function testFuzzAppendMultiple(bytes memory data1, bytes memory data2) public {
        DynamicBufferLib.DynamicBuffer memory buffer;
        buffer = buffer.p(data1, data2);
        assertEq(buffer.data.length, data1.length + data2.length);
        assertEq(keccak256(buffer.data), keccak256(abi.encodePacked(data1, data2)));
    }
}