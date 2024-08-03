// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import {Test} from "forge-std/Test.sol";
import {RedBlackTreeLib} from "../src/utils/RedBlackTreeLib.sol";

contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree private tree;

    function setUp() public {
        // Initial setup can be done here if needed
    }

    function testInsertAndSize() public {
        uint256[] memory values = new uint256[](5);
        values[0] = 10;
        values[1] = 20;
        values[2] = 30;
        values[3] = 40;
        values[4] = 50;

        for (uint i = 0; i < values.length; i++) {
            tree.insert(values[i]);
            assertEq(tree.size(), i + 1);
        }
    }

    function testInsertDuplicateReverts() public {
        tree.insert(100);
        vm.expectRevert(RedBlackTreeLib.ValueAlreadyExists.selector);
        tree.insert(100);
    }

    function testRemoveAndSize() public {
        uint256[] memory values = new uint256[](3);
        values[0] = 15;
        values[1] = 25;
        values[2] = 35;

        for (uint i = 0; i < values.length; i++) {
            tree.insert(values[i]);
        }

        for (uint i = 0; i < values.length; i++) {
            tree.remove(values[i]);
            assertEq(tree.size(), values.length - i - 1);
        }
    }

    function testRemoveNonExistentReverts() public {
        vm.expectRevert(RedBlackTreeLib.ValueDoesNotExist.selector);
        tree.remove(999);
    }

//    function testFindExistingValue() public {
//        tree.insert(123);
//        bytes32 ptr = tree.find(123);
//        assertEq(tree.value(ptr), 123);
//    }

    function testFindNonExistingValue() public {
        bytes32 ptr = tree.find(321);
        assertTrue(RedBlackTreeLib.isEmpty(ptr));
    }

//    function testFirstAndLast() public {
//        tree.insert(10);
//        tree.insert(20);
//        tree.insert(30);
//
//        assertEq(tree.value(tree.first()), 10);
//        assertEq(tree.value(tree.last()), 30);
//    }

//    function testNextAndPrev() public {
//        tree.insert(10);
//        tree.insert(20);
//        tree.insert(30);
//
//        bytes32 firstPtr = tree.first();
//        bytes32 lastPtr = tree.last();
//
////        assertEq(tree.value(tree.next(firstPtr)), 20);
//        assertEq(tree.value(tree.prev(lastPtr)), 20);
//    }

//    function testNearest() public {
//        tree.insert(10);
//        tree.insert(20);
//        tree.insert(30);
//        tree.insert(40);
//
//        assertEq(tree.value(tree.nearest(25)), 20);
//        assertEq(tree.value(tree.nearest(35)), 30);
//    }

//    function testNearestBeforeAfter() public {
//        tree.insert(10);
//        tree.insert(20);
//        tree.insert(30);
//        tree.insert(40);
//
//        assertEq(tree.value(tree.nearestBefore(25)), 20);
//        assertEq(tree.value(tree.nearestAfter(25)), 30);
//    }

    function testValues() public {
        tree.insert(10);
        tree.insert(20);
        tree.insert(30);

        uint256[] memory vals = tree.values();
        assertEq(vals.length, 3);
        assertEq(vals[0], 10);
        assertEq(vals[1], 20);
        assertEq(vals[2], 30);
    }
}