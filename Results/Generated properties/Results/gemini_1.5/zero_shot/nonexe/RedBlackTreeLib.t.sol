// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/RedBlackTreeLib.sol";
contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree tree;

    function testSizeEmpty() public {
        assertEq(tree.size(), 0);
    }

    function testInsert() public {
        tree.insert(1);
        assertEq(tree.size(), 1);
        assertEq(tree.value(tree.first()), 1);
    }

    function testInsertMultiple() public {
        tree.insert(1);
        tree.insert(2);
        tree.insert(3);
        assertEq(tree.size(), 3);
        assertEq(tree.value(tree.first()), 1);
        assertEq(tree.value(tree.next(tree.first())), 2);
        assertEq(tree.value(tree.last()), 3);
    }

    function testInsertDuplicate() public {
        tree.insert(1);
        vm.expectRevert(bytes("ValueAlreadyExists()"));
        tree.insert(1);
    }

    function testRemove() public {
        tree.insert(1);
        tree.remove(1);
        assertEq(tree.size(), 0);
    }

    function testRemoveMultiple() public {
        tree.insert(1);
        tree.insert(2);
        tree.insert(3);
        tree.remove(2);
        assertEq(tree.size(), 2);
        assertEq(tree.value(tree.first()), 1);
        assertEq(tree.value(tree.last()), 3);
    }

    function testRemoveNonExisting() public {
        vm.expectRevert(bytes("ValueDoesNotExist()"));
        tree.remove(1);
    }

    function testFindExisting() public {
        tree.insert(1);
        bytes32 ptr = tree.find(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testFindNonExisting() public {
        bytes32 ptr = tree.find(1);
        assertTrue(ptr == bytes32(0));
    }

    function testFirstEmpty() public {
        bytes32 ptr = tree.first();
        assertTrue(ptr == bytes32(0));
    }

    function testLastEmpty() public {
        bytes32 ptr = tree.last();
        assertTrue(ptr == bytes32(0));
    }

    function testNext() public {
        tree.insert(1);
        tree.insert(2);
        bytes32 ptr = tree.first();
        ptr = tree.next(ptr);
        assertEq(tree.value(ptr), 2);
    }

    function testNextLast() public {
        tree.insert(1);
        tree.insert(2);
        bytes32 ptr = tree.last();
        ptr = tree.next(ptr);
        assertTrue(ptr == bytes32(0));
    }

    function testPrev() public {
        tree.insert(1);
        tree.insert(2);
        bytes32 ptr = tree.last();
        ptr = tree.prev(ptr);
        assertEq(tree.value(ptr), 1);
    }

    function testPrevFirst() public {
        tree.insert(1);
        tree.insert(2);
        bytes32 ptr = tree.first();
        ptr = tree.prev(ptr);
        assertTrue(ptr == bytes32(0));
    }

    function testNearestEmpty() public {
        bytes32 ptr = tree.nearest(1);
        assertTrue(ptr == bytes32(0));
    }

    function testNearestExisting() public {
        tree.insert(1);
        bytes32 ptr = tree.nearest(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestNonExisting() public {
        tree.insert(1);
        tree.insert(3);
        bytes32 ptr = tree.nearest(2);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestBeforeEmpty() public {
        bytes32 ptr = tree.nearestBefore(1);
        assertTrue(ptr == bytes32(0));
    }

    function testNearestBeforeExisting() public {
        tree.insert(1);
        bytes32 ptr = tree.nearestBefore(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestBeforeNonExisting() public {
        tree.insert(1);
        tree.insert(3);
        bytes32 ptr = tree.nearestBefore(2);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestAfterEmpty() public {
        bytes32 ptr = tree.nearestAfter(1);
        assertTrue(ptr == bytes32(0));
    }

    function testNearestAfterExisting() public {
        tree.insert(1);
        bytes32 ptr = tree.nearestAfter(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestAfterNonExisting() public {
        tree.insert(1);
        tree.insert(3);
        bytes32 ptr = tree.nearestAfter(2);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 3);
    }

    function testValuesEmpty() public {
        uint256[] memory values = tree.values();
        assertEq(values.length, 0);
    }

    function testValues() public {
        tree.insert(3);
        tree.insert(1);
        tree.insert(2);
        uint256[] memory values = tree.values();
        assertEq(values.length, 3);
        assertEq(values[0], 1);
        assertEq(values[1], 2);
        assertEq(values[2], 3);
    }

    function testInsertMaxValues() public {
        uint256 maxValue = type(uint31).max;
        for (uint256 i = 1; i <= maxValue; ++i) {
            tree.insert(i);
        }
        vm.expectRevert(bytes("TreeIsFull()"));
        tree.insert(maxValue + 1);
    }

    function testRemoveMaxValues() public {
        uint256 maxValue = type(uint31).max;
        for (uint256 i = 1; i <= maxValue; ++i) {
            tree.insert(i);
        }
        for (uint256 i = 1; i <= maxValue; ++i) {
            tree.remove(i);
        }
        assertEq(tree.size(), 0);
    }

    function testInsertRandomValues() public {
        uint256[] memory values = new uint256[](100);
        for (uint256 i = 0; i < 100; ++i) {
            uint256 value = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i)));
            values[i] = value;
            tree.insert(value);
        }
        for (uint256 i = 0; i < 100; ++i) {
            tree.remove(values[i]);
        }
        assertEq(tree.size(), 0);
    }
}