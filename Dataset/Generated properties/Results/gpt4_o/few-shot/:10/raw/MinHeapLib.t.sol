// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MinHeapLib.sol";

contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap heap;
    MinHeapLib.MemHeap memHeap;

    function setUp() public {
        // Initialize the memory heap with some values
        memHeap.data = new uint256[](0);
    }

    function testRoot() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.root(), 5);

        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);
        assertEq(memHeap.root(), 5);
    }

    function testPushAndPop() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.pop(), 5);
        assertEq(heap.pop(), 10);
        assertEq(heap.pop(), 20);

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
        assertEq(heap.pop(), 10);
        assertEq(heap.pop(), 15);
        assertEq(heap.pop(), 20);

        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);
        assertEq(memHeap.pushPop(15), 5);
        assertEq(memHeap.pop(), 10);
        assertEq(memHeap.pop(), 15);
        assertEq(memHeap.pop(), 20);
    }

    function testReplace() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.replace(15), 5);
        assertEq(heap.pop(), 10);
        assertEq(heap.pop(), 15);
        assertEq(heap.pop(), 20);

        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);
        assertEq(memHeap.replace(15), 5);
        assertEq(memHeap.pop(), 10);
        assertEq(memHeap.pop(), 15);
        assertEq(memHeap.pop(), 20);
    }

    function testEnqueue() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(15, 3);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
        assertEq(heap.pop(), 10);
        assertEq(heap.pop(), 15);
        assertEq(heap.pop(), 20);

        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);
        (success, hasPopped, popped) = memHeap.enqueue(15, 3);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
        assertEq(memHeap.pop(), 10);
        assertEq(memHeap.pop(), 15);
        assertEq(memHeap.pop(), 20);
    }

    function testSmallest() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        heap.push(1);
        uint256[] memory smallest = heap.smallest(3);
        assertEq(smallest.length, 3);
        assertEq(smallest[0], 1);
        assertEq(smallest[1], 5);
        assertEq(smallest[2], 10);

        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);
        memHeap.push(1);
        smallest = memHeap.smallest(3);
        assertEq(smallest.length, 3);
        assertEq(smallest[0], 1);
        assertEq(smallest[1], 5);
        assertEq(smallest[2], 10);
    }

    function testLength() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.length(), 3);

        memHeap.push(10);
        memHeap.push(5);
        memHeap.push(20);
        assertEq(memHeap.length(), 3);
    }

    function testReserve() public {
        memHeap.reserve(10);
        assertEq(memHeap.data.length, 0);
        memHeap.push(1);
        memHeap.push(2);
        memHeap.push(3);
        assertEq(memHeap.data.length, 3);
    }
}