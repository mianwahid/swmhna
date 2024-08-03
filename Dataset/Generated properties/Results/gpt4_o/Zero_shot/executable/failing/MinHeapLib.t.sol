// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MinHeapLib.sol";

contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap private heap;
    MinHeapLib.MemHeap private memHeap;

    function setUp() public {
        // Initialize the heaps
        heap.data = new uint256[](0);
        memHeap.data = new uint256[](0);
    }

    function testRootEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    function testRootEmptyMemHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.root();
    }

    function testPushAndRoot() public {
        heap.push(10);
        assertEq(heap.root(), 10);

        heap.push(5);
        assertEq(heap.root(), 5);

        heap.push(20);
        assertEq(heap.root(), 5);
    }

    function testPushAndRootMemHeap() public {
        memHeap.push(10);
        assertEq(memHeap.root(), 10);

        memHeap.push(5);
        assertEq(memHeap.root(), 5);

        memHeap.push(20);
        assertEq(memHeap.root(), 5);
    }

    function testPopEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

    function testPopEmptyMemHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.pop();
    }

    function testPushAndPop() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);

        assertEq(heap.pop(), 5);
        assertEq(heap.pop(), 10);
        assertEq(heap.pop(), 20);
    }

    function testPushAndPopMemHeap() public {
        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);

        assertEq(memHeap.pop(), 5);
        assertEq(memHeap.pop(), 10);
        assertEq(memHeap.pop(), 20);
    }

    function testPushPop() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);

        assertEq(heap.pushPop(15), 5);
        assertEq(heap.root(), 10);
    }

    function testPushPopMemHeap() public {
        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);

        assertEq(memHeap.pushPop(15), 5);
        assertEq(memHeap.root(), 10);
    }

    function testReplace() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);

        assertEq(heap.replace(15), 5);
        assertEq(heap.root(), 10);
    }

    function testReplaceMemHeap() public {
        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);

        assertEq(memHeap.replace(15), 5);
        assertEq(memHeap.root(), 10);
    }

    function testEnqueue() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);

        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(15, 3);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
        assertEq(heap.root(), 10);
    }

    function testEnqueueMemHeap() public {
        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);

        (bool success, bool hasPopped, uint256 popped) = memHeap.enqueue(15, 3);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
        assertEq(memHeap.root(), 10);
    }

    function testSmallest() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);

        uint256[] memory smallestItems = heap.smallest(2);
        assertEq(smallestItems.length, 2);
        assertEq(smallestItems[0], 5);
        assertEq(smallestItems[1], 10);
    }

//    function testSmallestMemHeap() public {
//        memHeap.push(10);
//        memHeap.push(5);
//        memHeap.push(20);
//
//        uint256[] memory smallestItems = memHeap.smallest(2);
//        console2.log(memHeap.smallest(2));
//        assertEq(smallestItems.length, 2);
//        assertEq(smallestItems[0], 5);
//        assertEq(smallestItems[1], 10);
//    }

    function testReserve() public {
        memHeap.reserve(10);
        assertEq(memHeap.data.length, 0);
    }

    function testLength() public {
        assertEq(heap.length(), 0);
        heap.push(10);
        assertEq(heap.length(), 1);
    }

//    function testLengthMemHeap() public {
//        assertEq(memHeap.length(), 0);
//        memHeap.push(10);
//        assertEq(memHeap.length(), 1);
//    }

    function testFuzzPush(uint256 value) public {
        heap.push(value);
        assertEq(heap.root(), value);
    }

    function testFuzzPushMemHeap(uint256 value) public {
        memHeap.push(value);
        assertEq(memHeap.root(), value);
    }

    function testFuzzPushPop(uint256 value) public {
        heap.push(value);
        assertEq(heap.pushPop(value), value);
    }

    function testFuzzPushPopMemHeap(uint256 value) public {
        memHeap.push(value);
        assertEq(memHeap.pushPop(value), value);
    }

    function testFuzzReplace(uint256 value) public {
        heap.push(value);
        assertEq(heap.replace(value), value);
    }

    function testFuzzReplaceMemHeap(uint256 value) public {
        memHeap.push(value);
        assertEq(memHeap.replace(value), value);
    }

    function testFuzzEnqueue(uint256 value, uint256 maxLength) public {
        if (maxLength == 0) return;
        heap.push(value);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(value, maxLength);
        assertTrue(success);
    }

    function testFuzzEnqueueMemHeap(uint256 value, uint256 maxLength) public {
        if (maxLength == 0) return;
        memHeap.push(value);
        (bool success, bool hasPopped, uint256 popped) = memHeap.enqueue(value, maxLength);
        assertTrue(success);
    }
}