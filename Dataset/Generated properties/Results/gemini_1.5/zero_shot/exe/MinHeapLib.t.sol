// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MinHeapLib.sol";
contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap internal heap;
    function testRootEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    function testPush() public {
        heap.push(3);
        assertEq(heap.root(), 3);
        heap.push(1);
        assertEq(heap.root(), 1);
        heap.push(2);
        assertEq(heap.root(), 1);
        heap.push(5);
        assertEq(heap.root(), 1);
        heap.push(4);
        assertEq(heap.root(), 1);
    }

    function testPop() public {
        heap.push(3);
        heap.push(1);
        heap.push(2);
        heap.push(5);
        heap.push(4);

        assertEq(heap.pop(), 1);
        assertEq(heap.root(), 2);

        assertEq(heap.pop(), 2);
        assertEq(heap.root(), 3);

        assertEq(heap.pop(), 3);
        assertEq(heap.root(), 4);
    }

    function testPopEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.pop();
    }

//    function testPushPop() public {
////        assertEq(heap.pushPop(3), 0);
////        assertEq(heap.root(), 3);
//
//        assertEq(heap.pushPop(1), 1);
//        assertEq(heap.root(), 3);
//
//        assertEq(heap.pushPop(4), 3);
//        assertEq(heap.root(), 4);
//    }

    function testReplace() public {
        heap.push(3);
        assertEq(heap.replace(1), 3);
        assertEq(heap.root(), 1);
    }

    function testReplaceEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.replace(1);
    }

    function testEnqueue() public {
        // Enqueue to an empty heap.
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(3, 2);
        assert(success);
        assertEq(hasPopped, false);
        assertEq(popped, 0);
        assertEq(heap.length(), 1);

        // Enqueue to a non-full heap.
        (success, hasPopped, popped) = heap.enqueue(1, 2);
        assert(success);
        assertEq(hasPopped, false);
        assertEq(popped, 0);
        assertEq(heap.length(), 2);

        // Enqueue a larger value to a full heap.
        (success, hasPopped, popped) = heap.enqueue(4, 2);
        assert(success);
        assert(hasPopped);
        assertEq(popped, 1);
        assertEq(heap.length(), 2);

        // Enqueue a smaller value to a full heap.
        (success, hasPopped, popped) = heap.enqueue(2, 2);
        assert(!success);
        assertEq(hasPopped, false);
        assertEq(popped, 0);
        assertEq(heap.length(), 2);
    }

    function testEnqueueZeroMaxLength() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.enqueue(1, 0);
    }

    function testSmallest() public {
        heap.push(3);
        heap.push(1);
        heap.push(2);
        heap.push(5);
        heap.push(4);

        uint256[] memory smallest3 = heap.smallest(3);
        assertEq(smallest3.length, 3);
        assertEq(smallest3[0], 1);
        assertEq(smallest3[1], 2);
        assertEq(smallest3[2], 3);

        uint256[] memory smallest5 = heap.smallest(5);
        assertEq(smallest5.length, 5);
        assertEq(smallest5[0], 1);
        assertEq(smallest5[1], 2);
        assertEq(smallest5[2], 3);
        assertEq(smallest5[3], 4);
        assertEq(smallest5[4], 5);

        uint256[] memory smallest10 = heap.smallest(10);
        assertEq(smallest10.length, 5);
        assertEq(smallest10[0], 1);
        assertEq(smallest10[1], 2);
        assertEq(smallest10[2], 3);
        assertEq(smallest10[3], 4);
        assertEq(smallest10[4], 5);
    }

    function testSmallestEmptyHeap() public {
        uint256[] memory smallest = heap.smallest(3);
        assertEq(smallest.length, 0);
    }

    function testMemHeap() public {
        MinHeapLib.MemHeap memory memHeap;
        memHeap.push(3);
        memHeap.push(1);
        memHeap.push(2);
        assertEq(memHeap.length(), 3);
        assertEq(memHeap.root(), 1);
        assertEq(memHeap.pop(), 1);
        assertEq(memHeap.length(), 2);
        memHeap.reserve(10);
        assertEq(memHeap.length(), 2);
        assertEq(memHeap.root(), 2);
        memHeap.push(4);
        uint256[] memory smallest = memHeap.smallest(2);
        assertEq(smallest.length, 2);
        assertEq(smallest[0], 2);
        assertEq(smallest[1], 3);
    }

    function testMemHeapEnqueue() public {
        MinHeapLib.MemHeap memory memHeap;
        // Enqueue to an empty heap.
        (bool success, bool hasPopped, uint256 popped) = memHeap.enqueue(3, 2);
        assert(success);
        assertEq(hasPopped, false);
        assertEq(popped, 0);
        assertEq(memHeap.length(), 1);

        // Enqueue to a non-full heap.
        (success, hasPopped, popped) = memHeap.enqueue(1, 2);
        assert(success);
        assertEq(hasPopped, false);
        assertEq(popped, 0);
        assertEq(memHeap.length(), 2);

        // Enqueue a larger value to a full heap.
        (success, hasPopped, popped) = memHeap.enqueue(4, 2);
        assert(success);
        assert(hasPopped);
        assertEq(popped, 1);
        assertEq(memHeap.length(), 2);

        // Enqueue a smaller value to a full heap.
        (success, hasPopped, popped) = memHeap.enqueue(2, 2);
        assert(!success);
        assertEq(hasPopped, false);
        assertEq(popped, 0);
        assertEq(memHeap.length(), 2);
    }

    function testMemHeapEnqueueZeroMaxLength() public {
        MinHeapLib.MemHeap memory memHeap;
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.enqueue(1, 0);
    }

    function testFuzzPushPop(uint256[] memory values) public {
        vm.assume(values.length > 0 && values.length <= 100);
        MinHeapLib.MemHeap memory memHeap;
        for (uint256 i = 0; i < values.length; i++) {
            memHeap.push(values[i]);
        }
        uint256[] memory sortedValues = _sort(values);
        for (uint256 i = 0; i < sortedValues.length; i++) {
            assertEq(memHeap.pop(), sortedValues[i]);
        }
    }

    function testFuzzPushPopStorage(uint256[] memory values) public {
        vm.assume(values.length > 0 && values.length <= 100);
        for (uint256 i = 0; i < values.length; i++) {
            heap.push(values[i]);
        }
        uint256[] memory sortedValues = _sort(values);
        for (uint256 i = 0; i < sortedValues.length; i++) {
            assertEq(heap.pop(), sortedValues[i]);
        }
    }

    function testFuzzEnqueue(uint256[] memory values, uint256 maxLength) public {
        vm.assume(values.length > 0 && values.length <= 100);
        vm.assume(maxLength > 0 && maxLength <= 100);
        MinHeapLib.MemHeap memory memHeap;
        for (uint256 i = 0; i < values.length; i++) {
            memHeap.enqueue(values[i], maxLength);
        }
        uint256 expectedLength = Math.min(values.length, maxLength);
        assertEq(memHeap.length(), expectedLength);
    }

    function testFuzzEnqueueStorage(uint256[] memory values, uint256 maxLength) public {
        vm.assume(values.length > 0 && values.length <= 100);
        vm.assume(maxLength > 0 && maxLength <= 100);
        for (uint256 i = 0; i < values.length; i++) {
            heap.enqueue(values[i], maxLength);
        }
        uint256 expectedLength = Math.min(values.length, maxLength);
        assertEq(heap.length(), expectedLength);
    }

    function _sort(uint256[] memory data) private pure returns (uint256[] memory) {
        if (data.length <= 1) {
            return data;
        }
        uint256 pivot = data[data.length / 2];
        uint256[] memory left;
        uint256[] memory right;
        uint256[] memory result = new uint256[](data.length);
        uint256 leftIndex;
        uint256 rightIndex;
        for (uint256 i = 0; i < data.length; i++) {
            if (i == data.length / 2) {
                continue;
            }
            if (data[i] < pivot) {
                left = _resizeArray(left, leftIndex + 1);
                left[leftIndex++] = data[i];
            } else {
                right = _resizeArray(right, rightIndex + 1);
                right[rightIndex++] = data[i];
            }
        }
        left = _sort(left);
        right = _sort(right);
        for (uint256 i = 0; i < left.length; i++) {
            result[i] = left[i];
        }
        result[left.length] = pivot;
        for (uint256 i = 0; i < right.length; i++) {
            result[left.length + 1 + i] = right[i];
        }
        return result;
    }

    function _resizeArray(uint256[] memory arr, uint256 newSize) private pure returns (uint256[] memory) {
        if (arr.length == newSize) {
            return arr;
        }
        uint256[] memory newArr = new uint256[](newSize);
        for (uint256 i = 0; i < Math.min(arr.length, newSize); i++) {
            newArr[i] = arr[i];
        }
        return newArr;
    }
}

library Math {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}