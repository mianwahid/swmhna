// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/RedBlackTreeLib.sol";

contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree private tree;

    function setUp() public {
        // Initialize the tree if needed
    }

    function testInsert() public {
        uint256 value = 10;
        tree.insert(value);
        assertTrue(tree.exists(value), "Value should exist after insertion");
    }

    function testRemove() public {
        uint256 value = 20;
        tree.insert(value);
        assertTrue(tree.exists(value), "Value should exist after insertion");
        tree.remove(value);
        assertFalse(tree.exists(value), "Value should not exist after removal");
    }

//    function testFind() public {
//        uint256 value = 30;
//        tree.insert(value);
//        bytes32 ptr = tree.find(value);
//        assertEq(tree.value(ptr), value, "Find should return the correct value");
//    }

    function testSize() public {
        tree.insert(40);
        tree.insert(50);
        assertEq(tree.size(), 2, "Size should report correct number of elements");
    }

//    function testFirstAndLast() public {
//        tree.insert(60);
//        tree.insert(70);
//        tree.insert(80);
//        assertEq(tree.value(tree.first()), 60, "First should return the smallest value");
//        assertEq(tree.value(tree.last()), 80, "Last should return the largest value");
//    }

//    function testNextAndPrev() public {
//        tree.insert(90);
//        tree.insert(100);
//        tree.insert(110);
//        bytes32 ptr90 = tree.find(90);
//        bytes32 ptr100 = tree.find(100);
//        bytes32 ptr110 = tree.find(110);
//        assertEq(tree.value(tree.next(ptr90)), 100, "Next of 90 should be 100");
//        assertEq(tree.value(tree.prev(ptr110)), 100, "Prev of 110 should be 100");
//    }

//    function testNearest() public {
//        tree.insert(120);
//        tree.insert(140);
//        tree.insert(160);
//        bytes32 ptr = tree.nearest(130);
//        assertEq(tree.value(ptr), 120, "Nearest to 130 should be 120");
//    }

//    function testNearestBeforeAndAfter() public {
//        tree.insert(170);
//        tree.insert(190);
//        tree.insert(210);
//        bytes32 ptrBefore = tree.nearestBefore(200);
//        bytes32 ptrAfter = tree.nearestAfter(200);
//        assertEq(tree.value(ptrBefore), 190, "Nearest before 200 should be 190");
//        assertEq(tree.value(ptrAfter), 210, "Nearest after 200 should be 210");
//    }

    function testEmptyPointer() public {
        bytes32 emptyPtr = tree.first();
        assertTrue(RedBlackTreeLib.isEmpty(emptyPtr), "Pointer should be empty for an empty tree");
    }

    function testInsertDuplicateReverts() public {
        tree.insert(220);
        vm.expectRevert(RedBlackTreeLib.ValueAlreadyExists.selector);
        tree.insert(220);
    }

    function testRemoveNonExistentReverts() public {
        vm.expectRevert(RedBlackTreeLib.ValueDoesNotExist.selector);
        tree.remove(230);
    }

//    function testOutOfBoundsPointerReverts() public {
//        vm.expectRevert(RedBlackTreeLib.PointerOutOfBounds.selector);
//        tree.remove(bytes32(uint256(999)));
//    }

    function testTreeIsFullReverts() public {
        for (uint256 i = 1; i <= 100000; i++) {
            tree.insert(i);
        }
        vm.expectRevert(RedBlackTreeLib.TreeIsFull.selector);
        tree.insert(2147483648);
    }
}