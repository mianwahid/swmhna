// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/MinHeapLib.sol";

contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap heapStorage;
    MinHeapLib.MemHeap heapMemory;

    function setUp() public {
        // Initialize memory heap with some values
        heapMemory.data = new uint256[](0);
        // Initialize storage heap with some values
        heapStorage.data.push(5);
        heapStorage.data.push(3);
        heapStorage.data.push(8);
        heapStorage.data.push(1);
        heapStorage.data.push(4);
    }

    function testRoot() public {
        // Test root function for storage heap
        uint256 rootValue = heapStorage.root();
        assertEq(rootValue, 1, "Root value should be the smallest element");

        // Test root function for memory heap
        heapMemory.data.push(1);
        uint256 rootValueMem = heapMemory.root();
        assertEq(rootValueMem, 1, "Root value in memory should be the smallest element");
    }

    function testPush() public {
        // Test push function for storage heap
        heapStorage.push(2);
        assertEq(heapStorage.data[0], 1, "Root should still be the smallest element after push");
        assertEq(heapStorage.data.length, 6, "Heap size should increase by 1");

        // Test push function for memory heap
        heapMemory.push(2);
        assertEq(heapMemory.data[0], 1, "Root in memory should still be the smallest element after push");
        assertEq(heapMemory.data.length, 2, "Heap size in memory should increase by 1");
    }

    function testPop() public {
        // Test pop function for storage heap
        uint256 poppedValue = heapStorage.pop();
        assertEq(poppedValue, 1, "Popped value should be the smallest element");
        assertEq(heapStorage.data[0], 3, "New root should be the next smallest element");

        // Test pop function for memory heap
        heapMemory.push(1); // Ensure there's something to pop
        uint256 poppedValueMem = heapMemory.pop();
        assertEq(poppedValueMem, 1, "Popped value in memory should be the smallest element");
    }

    function testPushPop() public {
        // Test pushPop function for storage heap
        uint256 oldRoot = heapStorage.root();
        uint256 poppedValue = heapStorage.pushPop(0);
        assertEq(poppedValue, oldRoot, "pushPop should pop the old root");
        assertEq(heapStorage.root(), 0, "New root should be the pushed value");

        // Test pushPop function for memory heap
        heapMemory.push(1); // Ensure there's something to pop
        uint256 oldRootMem = heapMemory.root();
        uint256 poppedValueMem = heapMemory.pushPop(0);
        assertEq(poppedValueMem, oldRootMem, "pushPop in memory should pop the old root");
        assertEq(heapMemory.root(), 0, "New root in memory should be the pushed value");
    }

    function testReplace() public {
        // Test replace function for storage heap
        uint256 oldRoot = heapStorage.root();
        uint256 poppedValue = heapStorage.replace(0);
        assertEq(poppedValue, oldRoot, "replace should pop the old root");
        assertEq(heapStorage.root(), 0, "New root should be the replaced value");

        // Test replace function for memory heap
        heapMemory.push(1); // Ensure there's something to pop
        uint256 oldRootMem = heapMemory.root();
        uint256 poppedValueMem = heapMemory.replace(0);
        assertEq(poppedValueMem, oldRootMem, "replace in memory should pop the old root");
        assertEq(heapMemory.root(), 0, "New root in memory should be the replaced value");
    }

    function testEnqueue() public {
        // Test enqueue function for storage heap
        (bool success, bool hasPopped, uint256 popped) = heapStorage.enqueue(0, 5);
        assertTrue(success, "enqueue should succeed if not exceeding maxLength");
        assertTrue(hasPopped, "enqueue should pop when maxLength is reached");
        assertEq(popped, 1, "enqueue should pop the smallest element");

        // Test enqueue function for memory heap
        heapMemory.push(1); // Ensure there's something to pop
        (bool successMem, bool hasPoppedMem, uint256 poppedMem) = heapMemory.enqueue(0, 2);
        assertTrue(successMem, "enqueue in memory should succeed if not exceeding maxLength");
        assertTrue(hasPoppedMem, "enqueue in memory should pop when maxLength is reached");
        assertEq(poppedMem, 1, "enqueue in memory should pop the smallest element");
    }
}