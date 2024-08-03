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
        heap = MinHeapLib.Heap(new uint256[](0));
        memHeap = MinHeapLib.MemHeap(new uint256[](0));
    }

    // Invariants for `root` Function
    function testRootEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    function testRootNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.root(), 5);
    }


    // Invariants for `reserve` Function
//    function testReserveZeroSlots() public {
//        uint256[] memory originalData = heap.data;
//        heap.reserve(0);
//        assertEq(heap.data, originalData);
//    }

//    function testReserveLessThanCurrentCapacity() public {
//        heap.reserve(10);
//        uint256[] memory originalData = heap.data;
//        heap.reserve(5);
//        assertEq(heap.data, originalData);
//    }
//
//    function testReserveMoreThanCurrentCapacity() public {
//        heap.reserve(10);
//        uint256[] memory originalData = heap.data;
//        heap.reserve(20);
//        assertEq(heap.data.length, 20);
//        for (uint256 i = 0; i < originalData.length; i++) {
//            assertEq(heap.data[i], originalData[i]);
//        }
//    }

    // Invariants for `smallest` Function
    function testSmallestEmptyHeap() public {
        uint256[] memory result = heap.smallest(5);
        assertEq(result.length, 0);
    }

    function testSmallestKGreaterThanHeapSize() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        uint256[] memory result = heap.smallest(5);
        assertEq(result.length, 3);
        assertEq(result[0], 5);
        assertEq(result[1], 10);
        assertEq(result[2], 20);
    }

    function testSmallestKLessThanOrEqualToHeapSize() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        uint256[] memory result = heap.smallest(2);
        assertEq(result.length, 2);
        assertEq(result[0], 5);
        assertEq(result[1], 10);
    }

    // Invariants for `length` Function
    function testInitialLength() public {
        assertEq(heap.length(), 0);
    }

    function testLengthAfterPush() public {
        heap.push(10);
        assertEq(heap.length(), 1);
    }

    function testLengthAfterPop() public {
        heap.push(10);
        heap.pop();
        assertEq(heap.length(), 0);
    }

    // Invariants for `push` Function
    function testPushToEmptyHeap() public {
        heap.push(10);
        assertEq(heap.root(), 10);
    }

    function testPushToNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.root(), 5);
    }

    // Invariants for `pop` Function
    function testPopEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

    function testPopNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.pop(), 5);
        assertEq(heap.root(), 10);
    }

    // Invariants for `pushPop` Function
    function testPushPopEmptyHeap() public {
        assertEq(heap.pushPop(10), 10);
        assertEq(heap.root(), 10);
    }

    function testPushPopNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.pushPop(20), 5);
        assertEq(heap.root(), 10);
    }

    // Invariants for `replace` Function
    function testReplaceEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.replace(10);
    }

    function testReplaceNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.replace(20), 5);
        assertEq(heap.root(), 10);
    }

    // Invariants for `enqueue` Function
    function testEnqueueEmptyHeap() public {
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(10, 1);
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
        assertEq(heap.root(), 10);
    }

    function testEnqueueNonEmptyNotFullHeap() public {
        heap.push(10);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(5, 2);
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
        assertEq(heap.root(), 5);
    }

    function testEnqueueFullHeapValueLessThanOrEqualToRoot() public {
        heap.push(10);
        heap.push(5);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(3, 2);
        assertFalse(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
        assertEq(heap.root(), 5);
    }

    function testEnqueueFullHeapValueGreaterThanRoot() public {
        heap.push(10);
        heap.push(5);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(20, 2);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
        assertEq(heap.root(), 10);
    }

    // Edge Cases
    function testLargeHeap() public {
        for (uint256 i = 0; i < 1000; i++) {
            heap.push(i);
        }
        assertEq(heap.length(), 1000);
        assertEq(heap.root(), 0);
    }

    function testDuplicateElements() public {
        heap.push(10);
        heap.push(10);
        heap.push(5);
        assertEq(heap.root(), 5);
        heap.pop();
        assertEq(heap.root(), 10);
    }

    function testBoundaryValues() public {
        heap.push(0);
        heap.push(type(uint256).max);
        assertEq(heap.root(), 0);
        heap.pop();
        assertEq(heap.root(), type(uint256).max);
    }
}