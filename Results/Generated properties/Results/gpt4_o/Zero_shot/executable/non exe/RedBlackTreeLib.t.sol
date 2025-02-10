// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/RedBlackTreeLib.sol";

contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree private tree;

    function setUp() public {
        // Initialize the tree if needed
    }

    function testInsertAndExists() public {
        uint256 value = 42;
        tree.insert(value);
        assertTrue(tree.exists(value), "Value should exist after insertion");
    }

//    function testInsertDuplicate() public {
//        uint256 value = 42;
//        tree.insert(value);
//        vm.expectRevert(RedBlackTreeLib.ERROR_VALUE_ALREADY_EXISTS);
//        tree.insert(value);
//    }

    function testRemoveAndExists() public {
        uint256 value = 42;
        tree.insert(value);
        tree.remove(value);
        assertFalse(tree.exists(value), "Value should not exist after removal");
    }

//    function testRemoveNonExistent() public {
//        uint256 value = 42;
//        vm.expectRevert(RedBlackTreeLib.ERROR_VALUE_DOES_NOT_EXISTS);
//        tree.remove(value);
//    }

    function testInsertZero() public {
        uint256 value = 0;
        vm.expectRevert(0xc94f1877); // ValueIsEmpty()
        tree.insert(value);
    }

    function testRemoveZero() public {
        uint256 value = 0;
        vm.expectRevert(0xc94f1877); // ValueIsEmpty()
        tree.remove(value);
    }

//    function testFind() public {
//        uint256 value = 42;
//        tree.insert(value);
//        bytes32 ptr = tree.find(value);
//        assertEq(tree.value(ptr), value, "Find should return correct pointer");
//    }

    function testFindNonExistent() public {
        uint256 value = 42;
        bytes32 ptr = tree.find(value);
        assertTrue(tree.isEmpty(ptr), "Find should return empty pointer for non-existent value");
    }

    function testNearest() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        bytes32 ptr = tree.nearest(45);
        assertEq(tree.value(ptr), value1, "Nearest should return the closest value");
    }

    function testNearestBefore() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        bytes32 ptr = tree.nearestBefore(45);
        assertEq(tree.value(ptr), value1, "NearestBefore should return the closest lesser or equal value");
    }

    function testNearestAfter() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        bytes32 ptr = tree.nearestAfter(45);
        assertEq(tree.value(ptr), value2, "NearestAfter should return the closest greater or equal value");
    }

    function testFirstAndLast() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        assertEq(tree.value(tree.first()), value1, "First should return the smallest value");
        assertEq(tree.value(tree.last()), value2, "Last should return the largest value");
    }

    function testNextAndPrev() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        bytes32 ptr1 = tree.find(value1);
        bytes32 ptr2 = tree.find(value2);
        assertEq(tree.value(tree.next(ptr1)), value2, "Next should return the next largest value");
        assertEq(tree.value(tree.prev(ptr2)), value1, "Prev should return the next smallest value");
    }

    function testTreeSize() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        assertEq(tree.size(), 2, "Tree size should be correct");
    }

    function testTreeValues() public {
        uint256 value1 = 40;
        uint256 value2 = 50;
        tree.insert(value1);
        tree.insert(value2);
        uint256[] memory values = tree.values();
        assertEq(values.length, 2, "Tree values length should be correct");
        assertEq(values[0], value1, "Tree values should be in ascending order");
        assertEq(values[1], value2, "Tree values should be in ascending order");
    }

    function testTreeIsFull() public {
        for (uint256 i = 1; i <= 2147483647; i++) {
            tree.insert(i);
        }
        vm.expectRevert(RedBlackTreeLib.ERROR_TREE_IS_FULL);
        tree.insert(2147483648);
    }
}