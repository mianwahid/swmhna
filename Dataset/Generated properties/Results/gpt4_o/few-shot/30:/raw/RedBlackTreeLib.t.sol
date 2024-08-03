// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/RedBlackTreeLib.sol";

contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree tree;

    function testInsertAndExists(uint256 x) public {
        if (x == 0) return; // Skip zero value as it is not supported
        assertFalse(tree.exists(x));
        tree.insert(x);
        assertTrue(tree.exists(x));
    }

    function testInsertDuplicate(uint256 x) public {
        if (x == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        vm.expectRevert(RedBlackTreeLib.ValueAlreadyExists.selector);
        tree.insert(x);
    }

    function testRemove(uint256 x) public {
        if (x == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        assertTrue(tree.exists(x));
        tree.remove(x);
        assertFalse(tree.exists(x));
    }

    function testRemoveNonExistent(uint256 x) public {
        if (x == 0) return; // Skip zero value as it is not supported
        vm.expectRevert(RedBlackTreeLib.ValueDoesNotExist.selector);
        tree.remove(x);
    }

    function testFind(uint256 x) public {
        if (x == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        bytes32 ptr = tree.find(x);
        assertEq(tree.value(ptr), x);
    }

    function testNearest(uint256 x, uint256 y) public {
        if (x == 0 || y == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        bytes32 ptr = tree.nearest((x + y) / 2);
        uint256 nearestValue = tree.value(ptr);
        assertTrue(nearestValue == x || nearestValue == y);
    }

    function testNearestBefore(uint256 x, uint256 y) public {
        if (x == 0 || y == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        bytes32 ptr = tree.nearestBefore((x + y) / 2);
        uint256 nearestValue = tree.value(ptr);
        assertTrue(nearestValue == x || nearestValue == y);
    }

    function testNearestAfter(uint256 x, uint256 y) public {
        if (x == 0 || y == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        bytes32 ptr = tree.nearestAfter((x + y) / 2);
        uint256 nearestValue = tree.value(ptr);
        assertTrue(nearestValue == x || nearestValue == y);
    }

    function testFirstAndLast(uint256 x, uint256 y) public {
        if (x == 0 || y == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        bytes32 firstPtr = tree.first();
        bytes32 lastPtr = tree.last();
        assertEq(tree.value(firstPtr), x < y ? x : y);
        assertEq(tree.value(lastPtr), x > y ? x : y);
    }

    function testNextAndPrev(uint256 x, uint256 y) public {
        if (x == 0 || y == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        bytes32 firstPtr = tree.first();
        bytes32 lastPtr = tree.last();
        if (x < y) {
            assertEq(tree.value(tree.next(firstPtr)), y);
            assertEq(tree.value(tree.prev(lastPtr)), x);
        } else {
            assertEq(tree.value(tree.next(firstPtr)), x);
            assertEq(tree.value(tree.prev(lastPtr)), y);
        }
    }

    function testValues(uint256 x, uint256 y, uint256 z) public {
        if (x == 0 || y == 0 || z == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        tree.insert(z);
        uint256[] memory vals = tree.values();
        assertEq(vals.length, 3);
        assertTrue(vals[0] < vals[1] && vals[1] < vals[2]);
    }

    function testSize(uint256 x, uint256 y, uint256 z) public {
        if (x == 0 || y == 0 || z == 0) return; // Skip zero value as it is not supported
        tree.insert(x);
        tree.insert(y);
        tree.insert(z);
        assertEq(tree.size(), 3);
    }
}