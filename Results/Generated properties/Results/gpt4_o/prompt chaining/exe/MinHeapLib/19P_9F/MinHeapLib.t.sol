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
        // Initialize the heaps
        heap.data = new uint256[](0);
        memHeap.data = new uint256[](0);
    }

    // Custom Errors
    function testHeapIsEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    // Structs
    function testHeapInvariant() public {
        heap.push(3);
        heap.push(1);
        heap.push(2);
        assertTrue(isMinHeap(heap.data));
    }

    function testMemHeapInvariant() public {
        memHeap.push(3);
        memHeap.push(1);
        memHeap.push(2);
        assertTrue(isMinHeap(memHeap.data));
    }

    // Operations
    function testRootHeap() public {
        heap.push(3);
        heap.push(1);
        heap.push(2);
        assertEq(heap.root(), 1);
    }

    function testRootHeapEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    function testRootMemHeap() public {
        memHeap.push(3);
        memHeap.push(1);
        memHeap.push(2);
        assertEq(memHeap.root(), 1);
    }

    function testRootMemHeapEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.root();
    }

    function testReserveMemHeap() public {
        memHeap.reserve(10);
        assertTrue(memHeap.data.length >= 10);
    }

    function testSmallestHeap() public {
        heap.push(3);
        heap.push(1);
        heap.push(2);
        uint256[] memory smallest = heap.smallest(2);
        assertEq(smallest.length, 2);
        assertEq(smallest[0], 1);
        assertEq(smallest[1], 2);
    }

    function testSmallestMemHeap() public {
        memHeap.push(3);
        memHeap.push(1);
        memHeap.push(2);
        uint256[] memory smallest = memHeap.smallest(2);
        assertEq(smallest.length, 2);
        assertEq(smallest[0], 1);
        assertEq(smallest[1], 2);
    }

    function testLengthHeap() public {
        heap.push(1);
        heap.push(2);
        assertEq(heap.length(), 2);
    }

    function testLengthMemHeap() public {
        memHeap.push(1);
        memHeap.push(2);
        assertEq(memHeap.length(), 2);
    }

    function testPushHeap() public {
        heap.push(1);
        assertEq(heap.root(), 1);
    }

    function testPushMemHeap() public {
        memHeap.push(1);
        assertEq(memHeap.root(), 1);
    }

    function testPopHeap() public {
        heap.push(1);
        heap.push(2);
        assertEq(heap.pop(), 1);
        assertEq(heap.length(), 1);
    }

    function testPopHeapEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

    function testPopMemHeap() public {
        memHeap.push(1);
        memHeap.push(2);
        assertEq(memHeap.pop(), 1);
        assertEq(memHeap.length(), 1);
    }

    function testPopMemHeapEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.pop();
    }

    function testPushPopHeap() public {
        heap.push(2);
        assertEq(heap.pushPop(1), 1);
        assertEq(heap.root(), 2);
    }

    function testPushPopMemHeap() public {
        memHeap.push(2);
        assertEq(memHeap.pushPop(1), 1);
        assertEq(memHeap.root(), 2);
    }

    function testReplaceHeap() public {
        heap.push(1);
        heap.push(2);
        assertEq(heap.replace(3), 1);
        assertEq(heap.root(), 2);
    }

    function testReplaceHeapEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.replace(1);
    }

    function testReplaceMemHeap() public {
        memHeap.push(1);
        memHeap.push(2);
        assertEq(memHeap.replace(3), 1);
        assertEq(memHeap.root(), 2);
    }

    function testReplaceMemHeapEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.replace(1);
    }

    function testEnqueueHeap() public {
        heap.push(1);
        heap.push(2);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(3, 2);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 1);
    }

    function testEnqueueHeapZeroMaxLength() public {
        vm.expectRevert();
        heap.enqueue(1, 0);
    }

    function testEnqueueMemHeap() public {
        memHeap.push(1);
        memHeap.push(2);
        (bool success, bool hasPopped, uint256 popped) = memHeap.enqueue(3, 2);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 1);
    }

    function testEnqueueMemHeapZeroMaxLength() public {
        vm.expectRevert();
        memHeap.enqueue(1, 0);
    }

//    // Private Helpers
//    function testSetHeap() public {
//        (uint256 status, uint256 popped) = MinHeapLib._set(heap, 1, 0, 3);
//        assertEq(status, 0);
//        assertEq(popped, 0);
//    }

//    function testSetMemHeap() public {
//        (uint256 status, uint256 popped) = MinHeapLib._set(memHeap, 1, 0, 3);
//        assertEq(status, 0);
//        assertEq(popped, 0);
//    }

    // Helper function to check if an array represents a valid min-heap
    function isMinHeap(uint256[] memory data) internal pure returns (bool) {
        uint256 n = data.length;
        for (uint256 i = 0; i < n / 2; i++) {
            if (2 * i + 1 < n && data[i] > data[2 * i + 1]) return false;
            if (2 * i + 2 < n && data[i] > data[2 * i + 2]) return false;
        }
        return true;
    }
}