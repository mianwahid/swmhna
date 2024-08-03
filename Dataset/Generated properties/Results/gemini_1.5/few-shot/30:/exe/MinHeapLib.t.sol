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

    function testRootEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.root();
    }

    function testMemRootEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.root();
    }

    function testPushPop() public {
        heap.push(3);
        assertEq(heap.length(), 1);
        assertEq(heap.root(), 3);
        assertEq(heap.pop(), 3);
        assertEq(heap.length(), 0);
    }

//    function testMemPushPop() public {
//        memHeap.push(3);
////        assertEq(memHeap.length(), 1);
//        assertEq(memHeap.root(), 3);
//        assertEq(memHeap.pop(), 3);
////        assertEq(memHeap.length(), 0);
//    }

    function testPushPopMultiple() public {
        heap.push(3);
        heap.push(1);
        heap.push(4);
        heap.push(2);
        assertEq(heap.length(), 4);
        assertEq(heap.root(), 1);
        assertEq(heap.pop(), 1);
        assertEq(heap.length(), 3);
        assertEq(heap.root(), 2);
        assertEq(heap.pop(), 2);
        assertEq(heap.length(), 2);
        assertEq(heap.root(), 3);
        assertEq(heap.pop(), 3);
        assertEq(heap.length(), 1);
        assertEq(heap.root(), 4);
        assertEq(heap.pop(), 4);
        assertEq(heap.length(), 0);
    }

//    function testMemPushPopMultiple() public {
//        memHeap.push(3);
//        memHeap.push(1);
//        memHeap.push(4);
//        memHeap.push(2);
////        assertEq(memHeap.length(), 4);
//        assertEq(memHeap.root(), 1);
//        assertEq(memHeap.pop(), 1);
////        assertEq(memHeap.length(), 3);
//        assertEq(memHeap.root(), 2);
//        assertEq(memHeap.pop(), 2);
////        assertEq(memHeap.length(), 2);
//        assertEq(memHeap.root(), 3);
//        assertEq(memHeap.pop(), 3);
////        assertEq(memHeap.length(), 1);
//        assertEq(memHeap.root(), 4);
//        assertEq(memHeap.pop(), 4);
////        assertEq(memHeap.length(), 0);
//    }

    function testPushPopRandom(uint256 n) public {
        n = bound(n, 1, 256);
        uint256[] memory values = new uint256[](n);
        for (uint256 i; i < n; ++i) {
            uint256 value = uint256(keccak256(abi.encode(i, n)));
            heap.push(value);
            values[i] = value;
        }
        MinHeapLib.MemHeap memory tempHeap;
        tempHeap.reserve(n);
        for (uint256 i; i < n; ++i) {
            tempHeap.push(values[i]);
        }
        sort(values);
        for (uint256 i; i < n; ++i) {
            assertEq(heap.root(), values[i]);
            assertEq(heap.pop(), values[i]);
            assertEq(tempHeap.root(), values[i]);
            assertEq(tempHeap.pop(), values[i]);
        }
    }

//    function testMemPushPopRandom(uint256 n) public {
//        n = bound(n, 1, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            memHeap.push(value);
//            values[i] = value;
//        }
//        sort(values);
//        for (uint256 i; i < n; ++i) {
//            assertEq(memHeap.root(), values[i]);
//            assertEq(memHeap.pop(), values[i]);
//        }
//    }

    function testReplace() public {
        heap.push(3);
        assertEq(heap.replace(1), 3);
        assertEq(heap.root(), 1);
    }

//    function testMemReplace() public {
//        memHeap.push(3);
//        assertEq(memHeap.replace(1), 3);
//        assertEq(memHeap.root(), 1);
//    }

    function testReplaceEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.replace(1);
    }

    function testMemReplaceEmpty() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.replace(1);
    }

//    function testPushPopReplaceRandom(uint256 n) public {
//        n = bound(n, 1, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            if (i == 0) {
//                heap.push(value);
//            } else {
//                heap.replace(value);
//            }
//            values[i] = value;
//        }
//        sort(values);
//        for (uint256 i; i < n; ++i) {
//            assertEq(heap.root(), values[i]);
//            assertEq(heap.pop(), values[i]);
//        }
//    }

//    function testMemPushPopReplaceRandom(uint256 n) public {
//        n = bound(n, 1, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            if (i == 0) {
//                memHeap.push(value);
//            } else {
//                memHeap.replace(value);
//            }
//            values[i] = value;
//        }
//        sort(values);
//        for (uint256 i; i < n; ++i) {
//            assertEq(memHeap.root(), values[i]);
//            assertEq(memHeap.pop(), values[i]);
//        }
//    }

//    function testPushPopPushPopRandom(uint256 n) public {
//        n = bound(n, 1, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            heap.push(value);
//            heap.pop();
//            heap.push(value);
//            values[i] = value;
//        }
//        sort(values);
//        for (uint256 i; i < n; ++i) {
//            assertEq(heap.root(), values[i]);
//            assertEq(heap.pop(), values[i]);
//        }
//    }

//    function testMemPushPopPushPopRandom(uint256 n) public {
//        n = bound(n, 1, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            memHeap.push(value);
//            memHeap.pop();
//            memHeap.push(value);
//            values[i] = value;
//        }
//        sort(values);
//        for (uint256 i; i < n; ++i) {
//            assertEq(memHeap.root(), values[i]);
//            assertEq(memHeap.pop(), values[i]);
//        }
//    }

    function testEnqueue(uint256 maxLength, uint256 a, uint256 b) public {
        maxLength = bound(maxLength, 1, 16);
        heap = MinHeapLib.Heap(new uint256[](0));
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heap.enqueue(a, 0);
        for (uint256 i = 0; i < maxLength; ++i) {
            (bool success, bool hasPopped, uint256 popped) = heap.enqueue(i, maxLength);
            assertTrue(success);
            assertFalse(hasPopped);
            assertEq(popped, 0);
        }
        (bool success, bool hasPopped, uint256 popped) = heap.enqueue(a, maxLength);
        if (a < maxLength) {
            assertFalse(success);
            assertFalse(hasPopped);
            assertEq(popped, 0);
        } else {
            assertTrue(success);
            assertTrue(hasPopped);
            assertEq(popped, 0);
        }
        (success, hasPopped, popped) = heap.enqueue(b, maxLength);
        if (b < maxLength || (a >= maxLength && b <= a)) {
            assertFalse(success);
            assertFalse(hasPopped);
            assertEq(popped, 0);
        } else {
            assertTrue(success);
            assertTrue(hasPopped);
            if (a >= maxLength) {
                assertEq(popped, 1);
            } else {
                assertEq(popped, 0);
            }
        }
    }

    function testMemEnqueue(uint256 maxLength, uint256 a, uint256 b) public {
        maxLength = bound(maxLength, 1, 16);
        memHeap = MinHeapLib.MemHeap(new uint256[](0));
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        memHeap.enqueue(a, 0);
        for (uint256 i = 0; i < maxLength; ++i) {
            (bool success, bool hasPopped, uint256 popped) = memHeap.enqueue(i, maxLength);
            assertTrue(success);
            assertFalse(hasPopped);
            assertEq(popped, 0);
        }
        (bool success, bool hasPopped, uint256 popped) = memHeap.enqueue(a, maxLength);
        if (a < maxLength) {
            assertFalse(success);
            assertFalse(hasPopped);
            assertEq(popped, 0);
        } else {
            assertTrue(success);
            assertTrue(hasPopped);
            assertEq(popped, 0);
        }
        (success, hasPopped, popped) = memHeap.enqueue(b, maxLength);
        if (b < maxLength || (a >= maxLength && b <= a)) {
            assertFalse(success);
            assertFalse(hasPopped);
            assertEq(popped, 0);
        } else {
            assertTrue(success);
            assertTrue(hasPopped);
            if (a >= maxLength) {
                assertEq(popped, 1);
            } else {
                assertEq(popped, 0);
            }
        }
    }

//    function testSmallest(uint256 n, uint256 k) public {
//        n = bound(n, 0, 256);
//        k = bound(k, 0, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            heap.push(value);
//            values[i] = value;
//        }
//        uint256[] memory smallest = heap.smallest(k);
//        sort(values);
//        uint256 m = Math.min(n, k);
//        assertEq(smallest.length, m);
//        for (uint256 i; i < m; ++i) {
//            assertEq(smallest[i], values[i]);
//        }
//    }

//    function testMemSmallest(uint256 n, uint256 k) public {
//        n = bound(n, 0, 256);
//        k = bound(k, 0, 256);
//        uint256[] memory values = new uint256[](n);
//        for (uint256 i; i < n; ++i) {
//            uint256 value = uint256(keccak256(abi.encode(i, n)));
//            memHeap.push(value);
//            values[i] = value;
//        }
//        uint256[] memory smallest = memHeap.smallest(k);
//        sort(values);
//        uint256 m = Math.min(n, k);
//        assertEq(smallest.length, m);
//        for (uint256 i; i < m; ++i) {
//            assertEq(smallest[i], values[i]);
//        }
//    }

    function sort(uint256[] memory a) private pure {
        _sort(a, int256(0), int256(a.length - 1));
    }

    function _sort(uint256[] memory arr, int256 left, int256 right) private pure {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        uint256 pivot = arr[uint256(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint256(i)] < pivot) i++;
            while (pivot < arr[uint256(j)]) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (arr[uint256(j)], arr[uint256(i)]);
                i++;
                j--;
            }
        }
        if (left < j) _sort(arr, left, j);
        if (i < right) _sort(arr, i, right);
    }
}
library Math {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}