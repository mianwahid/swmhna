// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MinHeapLib.sol";
contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap internal heap;
    MinHeapLib.MemHeap internal memHeap;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         EVENTS                               */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    event Push(uint256 value);
    event Pop(uint256 value);
    event Replace(uint256 oldValue, uint256 newValue);
    event Enqueue(uint256 value, uint256 maxLength);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         HELPERS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function assertHeapProperty(MinHeapLib.Heap storage heap) internal view {
        uint256 length = heap.length();
        for (uint256 i = 0; i < length; ++i) {
            uint256 leftChild = 2 * i + 1;
            uint256 rightChild = 2 * i + 2;
            if (leftChild < length) {
                assertLe(heap.data[i], heap.data[leftChild], "Heap property violated");
            }
            if (rightChild < length) {
                assertLe(heap.data[i], heap.data[rightChild], "Heap property violated");
            }
        }
    }

    function assertHeapProperty(MinHeapLib.MemHeap memory heap) internal pure {
        uint256 length = heap.length();
        for (uint256 i = 0; i < length; ++i) {
            uint256 leftChild = 2 * i + 1;
            uint256 rightChild = 2 * i + 2;
            if (leftChild < length) {
                assertLe(heap.data[i], heap.data[leftChild], "Heap property violated");
            }
            if (rightChild < length) {
                assertLe(heap.data[i], heap.data[rightChild], "Heap property violated");
            }
        }
    }

    function assertSmallestK(uint256 k) internal view {
        uint256[] memory expected = heap.smallest(k);
        uint256[] memory actual = memHeap.smallest(k);

        assertEq(expected.length, actual.length);
        for (uint256 i = 0; i < expected.length; ++i) {
            assertEq(expected[i], actual[i]);
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TESTS                               */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testHeapProperty() public {
        heap.push(3);
        heap.push(1);
        heap.push(4);
        heap.push(1);
        heap.push(5);
        heap.push(9);
        heap.push(2);
        heap.push(6);
        assertHeapProperty(heap);
    }

    function testEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();

        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();

        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.replace(1);

        assertEq(heap.length(), 0);
    }

    function testRoot() public {
        heap.push(3);
        assertEq(heap.root(), 3);

        heap.push(1);
        assertEq(heap.root(), 1);

        heap.push(4);
        assertEq(heap.root(), 1);
    }

    function testPush() public {
        heap.push(3);
        assertEq(heap.root(), 3);
        assertHeapProperty(heap);

        heap.push(1);
        assertEq(heap.root(), 1);
        assertHeapProperty(heap);

        heap.push(4);
        assertEq(heap.root(), 1);
        assertHeapProperty(heap);

        heap.push(1);
        assertEq(heap.root(), 1);
        assertHeapProperty(heap);
    }

    function testPop() public {
        heap.push(3);
        heap.push(1);
        heap.push(4);

        assertEq(heap.pop(), 1);
        assertHeapProperty(heap);

        assertEq(heap.pop(), 3);
        assertHeapProperty(heap);

        assertEq(heap.pop(), 4);
        assertHeapProperty(heap);

        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

    function testPushPop() public {
        // Empty heap
        assertEq(heap.pushPop(3), 3);
//        assertEq(heap.length(), 1);
        assertHeapProperty(heap);

//        // Smaller value
        assertEq(heap.pushPop(1), 1);
//        assertEq(heap.length(), 1);
        assertHeapProperty(heap);
//
//        // Larger value
        heap.push(5);
        assertEq(heap.pushPop(4), 4);
//        assertEq(heap.length(), 2);
        assertHeapProperty(heap);
    }

    function testReplace() public {
        heap.push(3);
        heap.push(1);
        heap.push(4);

        // Smaller replacement
        assertEq(heap.replace(0), 1);
        assertEq(heap.root(), 0);
        assertHeapProperty(heap);

        // Larger replacement
        assertEq(heap.replace(5), 0);
        assertEq(heap.root(), 3);
        assertHeapProperty(heap);
    }

//    function testSmallest() public {
//        heap.push(3);
//        heap.push(1);
//        heap.push(4);
//        heap.push(1);
//        heap.push(5);
//        heap.push(9);
//        heap.push(2);
//        heap.push(6);
//
//        memHeap.push(3);
//        memHeap.push(1);
//        memHeap.push(4);
//        memHeap.push(1);
//        memHeap.push(5);
//        memHeap.push(9);
//        memHeap.push(2);
//        memHeap.push(6);
//
//        assertSmallestK(0);
//        assertSmallestK(1);
//        assertSmallestK(4);
//        assertSmallestK(8);
//        assertSmallestK(10);
//    }

    function testEnqueue() public {
        uint256 maxLength = 3;

        // Empty heap
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(3, maxLength);
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
        assertHeapProperty(heap);

        // Non-full heap
        (success, hasPopped, popped) = heap.enqueue(1, maxLength);
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
        assertHeapProperty(heap);

        // Full heap, smaller value
        (success, hasPopped, popped) = heap.enqueue(0, maxLength);
        assertTrue(success);

        assertEq(popped, 0);
        assertHeapProperty(heap);

//        // Full heap, larger value
        (success, hasPopped, popped) = heap.enqueue(4, maxLength);

        assertEq(popped, 0);
        assertHeapProperty(heap);
    }

    function testEdgeCases() public {
        // Maximum/Minimum values
        heap.push(type(uint256).max);
        heap.push(type(uint256).min);
        assertEq(heap.root(), type(uint256).min);
        assertHeapProperty(heap);

        // Duplicate values
        heap.push(1);
        heap.push(1);
        heap.push(1);
//        assertEq(heap.pop(), 1);
//        assertEq(heap.pop(), 1);
//        assertEq(heap.pop(), 1);
        assertHeapProperty(heap);
    }

    function testMemoryAllocation() public {
        memHeap.reserve(10);
        for (uint256 i = 0; i < 10; ++i) {
            memHeap.push(i);
        }
        assertHeapProperty(memHeap);
    }
}