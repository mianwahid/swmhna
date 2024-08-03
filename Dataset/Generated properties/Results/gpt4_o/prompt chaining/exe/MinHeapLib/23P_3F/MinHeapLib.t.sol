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
        // Initialize the heap and memHeap
        heap = MinHeapLib.Heap(new uint256[](0));
        memHeap = MinHeapLib.MemHeap(new uint256[](0));
    }

    // 1. HeapIsEmpty Error
    function testHeapIsEmptyError() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    // 2. Root of Non-Empty Heap
    function testRootOfNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.root(), 5);
    }

    function testRootOfEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    // 3. Reserve Memory
    function testReserveMemory() public {
        memHeap.reserve(10);
        assertEq(memHeap.data.length, 0);
    }

    function testReserveMemoryNoReallocation() public {
        memHeap.reserve(10);
        memHeap.reserve(5);
        assertEq(memHeap.data.length, 0);
    }

    // 4. Smallest Elements in Non-Empty Heap
    function testSmallestElementsInNonEmptyHeap() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        uint256[] memory smallest = heap.smallest(2);
        assertEq(smallest.length, 2);
        assertEq(smallest[0], 5);
        assertEq(smallest[1], 10);
    }

    function testSmallestElementsFewerThanK() public {
        heap.push(10);
        heap.push(5);
        uint256[] memory smallest = heap.smallest(3);
        assertEq(smallest.length, 2);
        assertEq(smallest[0], 5);
        assertEq(smallest[1], 10);
    }

    // 5. Heap Length
    function testHeapLength() public {
        assertEq(heap.length(), 0);
        heap.push(10);
        assertEq(heap.length(), 1);
    }

    // 6. Push Value onto Heap
    function testPushValueOntoHeap() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.root(), 5);
    }

    function testPushValueOntoEmptyHeap() public {
        heap.push(10);
        assertEq(heap.root(), 10);
    }

    // 7. Pop Minimum Value from Heap
    function testPopMinimumValueFromHeap() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.pop(), 5);
        assertEq(heap.root(), 10);
    }

    function testPopMinimumValueFromEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

    // 8. Push and Pop Value
    function testPushPopValue() public {
        heap.push(10);
        assertEq(heap.pushPop(5), 5);
        assertEq(heap.root(), 10);
    }

//    function testPushPopValueEmptyHeap() public {
//        assertEq(heap.pushPop(10), 10);
//        assertEq(heap.root(), 10);
//    }

    // 9. Replace Minimum Value
    function testReplaceMinimumValue() public {
        heap.push(10);
        heap.push(5);
        assertEq(heap.replace(20), 5);
        assertEq(heap.root(), 10);
    }

    function testReplaceMinimumValueEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.replace(10);
    }

    // 10. Enqueue Value with Bounded Length
    function testEnqueueValueWithBoundedLength() public {
        heap.push(10);
        heap.push(5);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(20, 2);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
    }

    function testEnqueueValueWithZeroMaxLength() public {
        vm.expectRevert();
        heap.enqueue(10, 0);
    }

    function testEnqueueValueHeapNotFull() public {
        heap.push(10);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(5, 2);
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
    }

    function testEnqueueValueHeapFullNotGreater() public {
        heap.push(10);
        heap.push(5);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(3, 2);
        assertFalse(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
    }

    function testEnqueueValueHeapFullGreater() public {
        heap.push(10);
        heap.push(5);
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(20, 2);
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 5);
    }

    // 11. Heap Property Maintenance
    function testHeapPropertyMaintenance() public {
        heap.push(10);
        heap.push(5);
        heap.push(20);
        assertEq(heap.root(), 5);
        heap.pop();
        assertEq(heap.root(), 10);
    }

    function testHeapPropertyEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

    function testHeapPropertyFullHeap() public {
        for (uint256 i = 0; i < 100; i++) {
            heap.push(i);
        }
        assertEq(heap.length(), 100);
    }

    // 12. Max-Heap Conversion
//    function testMaxHeapConversion() public {
//        heap.push(~10);
//        heap.push(~5);
//        heap.push(~20);
//        assertEq(~heap.root(), 20);
//    }

    // 13. Tuple Packing
//    function testTuplePacking() public {
//        uint256 packed1 = uint256(keccak256(abi.encode(1, 2)));
//        uint256 packed2 = uint256(keccak256(abi.encode(3, 4)));
//        heap.push(packed1);
//        heap.push(packed2);
//        assertEq(heap.root(), packed1);
//    }

    // 14. Signed Integer Conversion
//    function testSignedIntegerConversion() public {
//        int256 signedValue1 = -10;
//        int256 signedValue2 = 5;
//        heap.push(uint256(signedValue1) + (1 << 255));
//        heap.push(uint256(signedValue2) + (1 << 255));
//        assertEq(int256(heap.root() - (1 << 255)), signedValue1);
//    }
}