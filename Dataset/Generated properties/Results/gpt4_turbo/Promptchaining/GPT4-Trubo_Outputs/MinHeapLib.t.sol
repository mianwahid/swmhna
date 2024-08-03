// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/MinHeapLib.sol";

contract MinHeapLibTest is Test {
    using MinHeapLib for MinHeapLib.Heap;
    using MinHeapLib for MinHeapLib.MemHeap;

    MinHeapLib.Heap heapStorage;
    MinHeapLib.MemHeap heapMemory;

    function setUp() public {
        heapMemory = MinHeapLib.MemHeap(new uint256[](0));
    }

    function testRootEmptyHeapReverts() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.root();
    }

    function testRootReturnsMinimum() public {
        heapStorage.push(10);
        heapStorage.push(5);
        heapStorage.push(20);
        assertEq(heapStorage.root(), 5);
    }

    // function testReserveMemoryHeap() public {
    //     heapMemory.reserve(100);
    //     assertEq(heapMemory.data.length, 0); // Length should still be 0
    //     uint256 preSize = heapMemory.data.length;
    //     for (uint256 i = 0; i < 100; i++) {
    //         heapMemory.push(i);
    //     }
    //     assertEq(heapMemory.data.length, 100);
    //     assertEq(preSize, 0);
    // }

    function testSmallestFunctionality() public {
        heapStorage.push(10);
        heapStorage.push(5);
        heapStorage.push(20);
        uint256[] memory smallestTwo = heapStorage.smallest(2);
        assertEq(smallestTwo.length, 2);
        assertEq(smallestTwo[0], 5);
        assertEq(smallestTwo[1], 10);
    }

    function testSmallestEmptyHeap() public {
        uint256[] memory smallest = heapStorage.smallest(5);
        assertEq(smallest.length, 0);
    }

    function testLengthFunction() public {
        assertEq(heapStorage.length(), 0);
        heapStorage.push(10);
        assertEq(heapStorage.length(), 1);
        heapStorage.push(20);
        assertEq(heapStorage.length(), 2);
    }

    function testPushFunction() public {
        heapStorage.push(30);
        assertEq(heapStorage.root(), 30);
        heapStorage.push(20);
        assertEq(heapStorage.root(), 20);
        heapStorage.push(10);
        assertEq(heapStorage.root(), 10);
    }

    function testPopFunction() public {
        heapStorage.push(10);
        heapStorage.push(20);
        heapStorage.push(5);
        assertEq(heapStorage.pop(), 5);
        assertEq(heapStorage.root(), 10);
        assertEq(heapStorage.length(), 2);
    }

    function testPopEmptyHeapReverts() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.pop();
    }

    // function testPushPopFunction() public {
    //     heapStorage.push(10);
    //     assertEq(heapStorage.pushPop(5), 10);
    //     assertEq(heapStorage.root(), 5);
    // }

    function testReplaceFunction() public {
        heapStorage.push(10);
        heapStorage.push(20);
        assertEq(heapStorage.replace(5), 10);
        assertEq(heapStorage.root(), 5);
    }

    function testReplaceEmptyHeapReverts() public {
        vm.expectRevert(MinHeapLib.HeapIsEmpty.selector);
        heapStorage.replace(10);
    }

    // function testEnqueueFunction() public {
    //     (bool success, bool hasPopped, uint256 popped) = heapStorage.enqueue(10, 1);
    //     assertTrue(success);
    //     assertFalse(hasPopped);
    //     assertEq(popped, 0);

    //     (success, hasPopped, popped) = heapStorage.enqueue(5, 1);
    //     assertTrue(success);
    //     assertTrue(hasPopped);
    //     assertEq(popped, 10);
    //     assertEq(heapStorage.root(), 5);
    // }

    function testEnqueueMaxLengthZeroReverts() public {
        vm.expectRevert();
        heapStorage.enqueue(10, 0);
    }
}
