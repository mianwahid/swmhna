// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {MinHeapLib} from "../src/MinHeapLib.sol";

contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap heapStorage;
    MinHeapLib.MemHeap heapMemory;

    function setUp() public {
        // Initialize memory heap with an empty array
        heapMemory.data = new uint256[](0);
    }

    function testRootEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.root();
    }

    function testRootEmptyMemHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapMemory.root();
    }

    function testPushAndRoot() public {
        uint256 value = 42;
        heapStorage.push(value);
        assertEq(heapStorage.root(), value);
    }

    // function testPushAndRootMemHeap() public {
    //     uint256 value = 42;
    //     heapMemory.push(value);
    //     assertEq(heapMemory.root(), value);
    // }

    function testPopEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.pop();
    }

    function testPopEmptyMemHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapMemory.pop();
    }

    function testPushPop() public {
        uint256 value = 42;
        heapStorage.push(value);
        assertEq(heapStorage.pop(), value);
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.root();
    }

    // function testPushPopMemHeap() public {
    //     uint256 value = 42;
    //     heapMemory.push(value);
    //     assertEq(heapMemory.pop(), value);
    //     vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
    //     heapMemory.root();
    // }

    function testReplaceEmptyHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.replace(42);
    }

    function testReplaceEmptyMemHeap() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapMemory.replace(42);
    }

    function testPushReplace() public {
        uint256 oldValue = 42;
        uint256 newValue = 24;
        heapStorage.push(oldValue);
        assertEq(heapStorage.replace(newValue), oldValue);
        assertEq(heapStorage.root(), newValue);
    }

    // function testPushReplaceMemHeap() public {
    //     uint256 oldValue = 42;
    //     uint256 newValue = 24;
    //     heapMemory.push(oldValue);
    //     assertEq(heapMemory.replace(newValue), oldValue);
    //     assertEq(heapMemory.root(), newValue);
    // }

    function testEnqueueMaxLengthZero() public {
        vm.expectRevert();
        heapStorage.enqueue(42, 0);
    }

    function testEnqueueMaxLengthZeroMemHeap() public {
        vm.expectRevert();
        heapMemory.enqueue(42, 0);
    }

    function testEnqueueNotFull() public {
        (bool success, bool hasPopped, uint256 popped) = heapStorage.enqueue(
            42,
            10
        );
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
    }

    function testEnqueueNotFullMemHeap() public {
        (bool success, bool hasPopped, uint256 popped) = heapMemory.enqueue(
            42,
            10
        );
        assertTrue(success);
        assertFalse(hasPopped);
        assertEq(popped, 0);
    }

    function testEnqueueFull() public {
        for (uint256 i = 0; i < 10; i++) {
            heapStorage.push(i);
        }
        (bool success, bool hasPopped, uint256 popped) = heapStorage.enqueue(
            11,
            10
        );
        assertTrue(success);
        assertTrue(hasPopped);
        assertEq(popped, 0); // The smallest element should be popped
    }

    // function testEnqueueFullMemHeap() public {
    //     for (uint256 i = 0; i < 10; i++) {
    //         heapMemory.push(i);
    //     }
    //     (bool success, bool hasPopped, uint256 popped) = heapMemory.enqueue(11, 10);
    //     assertTrue(success);
    //     assertTrue(hasPopped);
    //     assertEq(popped, 0); // The smallest element should be popped
    // }
}
