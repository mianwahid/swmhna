// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/RedBlackTreeLib.sol";

contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree private tree;

    function setUp() public {
        tree = RedBlackTreeLib.Tree(0);
    }

    function testInsertAndSize() public {
        uint256[] memory values = new uint256[](5);
        values[0] = 10;
        values[1] = 20;
        values[2] = 30;
        values[3] = 40;
        values[4] = 50;

        for (uint256 i = 0; i < values.length; i++) {
            tree.insert(values[i]);
            assertEq(tree.size(), i + 1);
        }
    }

    function testInsertDuplicateReverts() public {
        tree.insert(100);
        vm.expectRevert(RedBlackTreeLib.ValueAlreadyExists.selector);
        tree.insert(100);
    }

    function testRemove() public {
        uint256[] memory values = new uint256[](3);
        values[0] = 15;
        values[1] = 25;
        values[2] = 35;

        for (uint256 i = 0; i < values.length; i++) {
            tree.insert(values[i]);
        }

        assertEq(tree.size(), 3);
        tree.remove(25);
        assertEq(tree.size(), 2);
        assertFalse(tree.exists(25));
    }

    function testRemoveNonExistentReverts() public {
        vm.expectRevert(RedBlackTreeLib.ValueDoesNotExist.selector);
        tree.remove(999);
    }

//    function testFind() public {
//        tree.insert(60);
//        tree.insert(70);
//        tree.insert(80);
//
//        bytes32 ptr = tree.find(70);
//        assertEq(tree.value(ptr), 70);
//    }

//    function testFindNonExistent() public {
//        bytes32 ptr = tree.find(999);
//        assertTrue(tree.isEmpty(ptr));
//    }

//    function testFirstAndLast() public {
//        tree.insert(5);
//        tree.insert(15);
//        tree.insert(25);
//
////        assertEq(tree.value(tree.first()), 5);
//        assertEq(tree.value(tree.last()), 25);
//    }

//    function testNextAndPrev() public {
//        tree.insert(10);
//        tree.insert(20);
//        tree.insert(30);
//
//        bytes32 firstPtr = tree.first();
//        bytes32 lastPtr = tree.last();
//
//        assertEq(tree.value(tree.next(firstPtr)), 20);
//        assertEq(tree.value(tree.prev(lastPtr)), 20);
//    }

//    function testEmptyNextAndPrev() public {
//        bytes32 ptr = bytes32(0);
//        assertTrue(tree.isEmpty(tree.next(ptr)));
//        assertTrue(tree.isEmpty(tree.prev(ptr)));
//    }

//    function testNearest() public {
//        tree.insert(100);
//        tree.insert(200);
//        tree.insert(300);
//
//        assertEq(tree.value(tree.nearest(250)), 200);
//        assertEq(tree.value(tree.nearest(350)), 300);
//        assertEq(tree.value(tree.nearest(50)), 100);
//    }

//    function testNearestBeforeAfter() public {
//        tree.insert(100);
//        tree.insert(300);
//        tree.insert(500);
//
//        assertEq(tree.value(tree.nearestBefore(400)), 300);
//        assertEq(tree.value(tree.nearestAfter(400)), 500);
//        assertTrue(tree.isEmpty(tree.nearestBefore(50)));
//        assertTrue(tree.isEmpty(tree.nearestAfter(600)));
//    }
}