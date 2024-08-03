//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/RedBlackTreeLib.sol";
//contract RedBlackTreeLibTest is Test {
//    using RedBlackTreeLib for RedBlackTreeLib.Tree;
//    using RedBlackTreeLib for bytes32;
//
//    RedBlackTreeLib.Tree tree;
//
//    function testSize() public {
//        assertEq(tree.size(), 0);
//        tree.insert(1);
//        assertEq(tree.size(), 1);
//        tree.insert(2);
//        assertEq(tree.size(), 2);
//        tree.remove(1);
//        assertEq(tree.size(), 1);
//        tree.remove(2);
//        assertEq(tree.size(), 0);
//    }
//
//
//    function testFind() public {
//        assertTrue(tree.find(1).isEmpty());
//        tree.insert(1);
//        assertFalse(tree.find(1).isEmpty());
//        tree.insert(2);
//        assertFalse(tree.find(2).isEmpty());
//        tree.remove(1);
//        assertTrue(tree.find(1).isEmpty());
//        tree.remove(2);
//        assertTrue(tree.find(2).isEmpty());
//    }
//
//    function testNearest() public {
//        assertTrue(tree.nearest(1).isEmpty());
//        tree.insert(1);
//        assertEq(tree.nearest(1).value(), 1);
//        tree.insert(2);
//        assertEq(tree.nearest(1).value(), 1);
//        assertEq(tree.nearest(2).value(), 2);
//        assertEq(tree.nearest(100).value(), 2);
//        tree.insert(3);
//        assertEq(tree.nearest(1).value(), 1);
//        assertEq(tree.nearest(2).value(), 2);
//        assertEq(tree.nearest(3).value(), 3);
//        assertEq(tree.nearest(100).value(), 3);
//        tree.remove(2);
//        assertEq(tree.nearest(2).value(), 1);
//    }
//
//    function testNearestBefore() public {
//        assertTrue(tree.nearestBefore(1).isEmpty());
//        tree.insert(1);
//        assertEq(tree.nearestBefore(1).value(), 1);
//        tree.insert(2);
//        assertEq(tree.nearestBefore(1).value(), 1);
//        assertEq(tree.nearestBefore(2).value(), 2);
//        assertEq(tree.nearestBefore(100).value(), 2);
//        tree.insert(3);
//        assertEq(tree.nearestBefore(1).value(), 1);
//        assertEq(tree.nearestBefore(2).value(), 2);
//        assertEq(tree.nearestBefore(3).value(), 3);
//        assertEq(tree.nearestBefore(100).value(), 3);
//        tree.remove(2);
//        assertEq(tree.nearestBefore(2).value(), 1);
//    }
//
//    function testNearestAfter() public {
//        tree.insert(1);
//        assertEq(tree.nearestAfter(1).value(), 1);
//        tree.insert(2);
//        assertEq(tree.nearestAfter(1).value(), 1);
//        assertEq(tree.nearestAfter(2).value(), 2);
//        tree.insert(3);
//        assertEq(tree.nearestAfter(1).value(), 1);
//        assertEq(tree.nearestAfter(2).value(), 2);
//        assertEq(tree.nearestAfter(3).value(), 3);
//
//        tree.remove(2);
//        assertEq(tree.nearestAfter(2).value(), 3);
//    }
//
//    function testExists() public {
//        assertFalse(tree.exists(1));
//        tree.insert(1);
//        assertTrue(tree.exists(1));
//        tree.insert(2);
//        assertTrue(tree.exists(2));
//        tree.remove(1);
//        assertFalse(tree.exists(1));
//        tree.remove(2);
//        assertFalse(tree.exists(2));
//    }
//
//    function testInsert() public {
//        tree.insert(1);
//        vm.expectRevert(RedBlackTreeLib.ValueAlreadyExists.selector);
//        tree.insert(1);
//    }
//
//    function testTryInsert() public {
//        assertEq(tree.tryInsert(1), 0);
//        assertEq(tree.tryInsert(1), RedBlackTreeLib.ERROR_VALUE_ALREADY_EXISTS);
//    }
//
//    function testRemove() public {
//        tree.insert(1);
//        tree.remove(1);
//        vm.expectRevert(RedBlackTreeLib.ValueDoesNotExist.selector);
//        tree.remove(1);
//    }
//
//    function testTryRemove() public {
//        assertEq(tree.tryRemove(1), RedBlackTreeLib.ERROR_VALUE_DOES_NOT_EXISTS);
//        tree.insert(1);
//        assertEq(tree.tryRemove(1), 0);
//        assertEq(tree.tryRemove(1), RedBlackTreeLib.ERROR_VALUE_DOES_NOT_EXISTS);
//    }
//
//    function testRemovePtr() public {
//        bytes32 ptr = tree.find(1);
//
//        tree.insert(1);
//        ptr = tree.find(1);
//        ptr.remove();
//        assertTrue(tree.find(1).isEmpty());
//    }
//
//    function testTryRemovePtr() public {
//        bytes32 ptr = tree.find(1);
//        tree.insert(1);
//        ptr = tree.find(1);
//        assertEq(ptr.tryRemove(), 0);
//
//    }
//
//    function testValue() public {
//        bytes32 ptr = tree.find(1);
//        assertEq(ptr.value(), 0);
//        tree.insert(1);
//        ptr = tree.find(1);
//        assertEq(ptr.value(), 1);
//        tree.remove(1);
//        assertEq(ptr.value(), 0);
//    }
//
//    function testFirst() public {
//        assertTrue(tree.first().isEmpty());
//        tree.insert(2);
//        assertEq(tree.first().value(), 2);
//        tree.insert(1);
//        assertEq(tree.first().value(), 1);
//        tree.remove(1);
//        assertEq(tree.first().value(), 2);
//        tree.remove(2);
//        assertTrue(tree.first().isEmpty());
//    }
//
//    function testLast() public {
//        assertTrue(tree.last().isEmpty());
//        tree.insert(1);
//        assertEq(tree.last().value(), 1);
//        tree.insert(2);
//        assertEq(tree.last().value(), 2);
//        tree.remove(2);
//        assertEq(tree.last().value(), 1);
//        tree.remove(1);
//        assertTrue(tree.last().isEmpty());
//    }
//
//    function testNext() public {
//        bytes32 ptr = tree.find(1);
//        assertTrue(ptr.next().isEmpty());
//        tree.insert(1);
//        ptr = tree.find(1);
//        assertTrue(ptr.next().isEmpty());
//        tree.insert(2);
//        ptr = tree.find(1);
//        assertEq(ptr.next().value(), 2);
//        ptr = tree.find(2);
//        assertTrue(ptr.next().isEmpty());
//        tree.insert(3);
//        ptr = tree.find(2);
//        assertEq(ptr.next().value(), 3);
//        tree.remove(2);
//        ptr = tree.find(1);
//        assertEq(ptr.next().value(), 3);
//    }
//
//    function testPrev() public {
//        bytes32 ptr = tree.find(1);
//        assertTrue(ptr.prev().isEmpty());
//        tree.insert(1);
//        ptr = tree.find(1);
//        assertTrue(ptr.prev().isEmpty());
//        tree.insert(2);
//        ptr = tree.find(2);
//        assertEq(ptr.prev().value(), 1);
//        ptr = tree.find(1);
//        assertTrue(ptr.prev().isEmpty());
//        tree.insert(3);
//        ptr = tree.find(3);
//        assertEq(ptr.prev().value(), 2);
//        tree.remove(2);
//        ptr = tree.find(3);
//        assertEq(ptr.prev().value(), 1);
//    }
//
//    function testIsEmpty() public {
//        bytes32 ptr = tree.find(1);
//        assertTrue(ptr.isEmpty());
//        tree.insert(1);
//        ptr = tree.find(1);
//        assertFalse(ptr.isEmpty());
//    }
//
//    function testFuzzInsertRemove(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//                assertFalse(tree.exists(x));
//            } else {
//                tree.insert(x);
//                assertTrue(tree.exists(x));
//            }
//        }
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            }
//        }
//        assertEq(tree.size(), 0);
//    }
//
//    function testFuzzInsertRemovePtr(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                bytes32 ptr = tree.find(x);
//                ptr.remove();
//                assertFalse(tree.exists(x));
//            } else {
//                tree.insert(x);
//                assertTrue(tree.exists(x));
//            }
//        }
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                bytes32 ptr = tree.find(x);
//                ptr.remove();
//            }
//        }
//        assertEq(tree.size(), 0);
//    }
//
//    function testFuzzInsertRemoveRandom(uint256 n) public {
//        n = bound(n, 1, 256);
//        for (uint256 i = 0; i < n; ++i) {
//            uint256 x = uint256(keccak256(abi.encode(i)));
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                if (uint256(keccak256(abi.encode(x))) & 1 == 0) {
//                    tree.remove(x);
//                    assertFalse(tree.exists(x));
//                } else {
//                    bytes32 ptr = tree.find(x);
//                    ptr.remove();
//                    assertFalse(tree.exists(x));
//                }
//            } else {
//                tree.insert(x);
//                assertTrue(tree.exists(x));
//            }
//        }
//        uint256 size = tree.size();
//        uint256[] memory values = tree.values();
//        assertEq(values.length, size);
//        for (uint256 i = 0; i < size; ++i) {
//            tree.remove(values[i]);
//        }
//        assertEq(tree.size(), 0);
//    }
//
//    function testInvariantValuesSorted(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        uint256[] memory values = tree.values();
//        for (uint256 i = 1; i < values.length; ++i) {
//            assertTrue(values[i - 1] < values[i]);
//        }
//    }
//
//    function testInvariantSize(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        uint256 size = tree.size();
//        uint256[] memory values = tree.values();
//        assertEq(values.length, size);
//    }
//
//    function testInvariantFirstLast(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        if (tree.size() == 0) {
//            assertTrue(tree.first().isEmpty());
//            assertTrue(tree.last().isEmpty());
//        } else {
//            uint256[] memory values = tree.values();
//            assertEq(tree.first().value(), values[0]);
//            assertEq(tree.last().value(), values[values.length - 1]);
//        }
//    }
//
//    function testInvariantNextPrev(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        uint256[] memory values = tree.values();
//        if (values.length == 0) return;
//        bytes32 ptr = tree.first();
//        for (uint256 i = 1; i < values.length; ++i) {
//            assertEq(ptr.next().value(), values[i]);
//            ptr = ptr.next();
//        }
//        assertTrue(ptr.next().isEmpty());
//        ptr = tree.last();
//        for (uint256 i = values.length - 1; i > 0; --i) {
//            assertEq(ptr.prev().value(), values[i - 1]);
//            ptr = ptr.prev();
//        }
//        assertTrue(ptr.prev().isEmpty());
//    }
//
//    function testInvariantNearest(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        uint256[] memory values = tree.values();
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            uint256 nearest = tree.nearest(x).value();
//            uint256 bestDist = type(uint256).max;
//            for (uint256 j = 0; j < values.length; ++j) {
//                uint256 dist = values[j] < x ? x - values[j] : values[j] - x;
//                if (dist < bestDist) {
//                    bestDist = dist;
//                    nearest = values[j];
//                }
//            }
//            assertEq(tree.nearest(x).value(), nearest);
//        }
//    }
//
//    function testInvariantNearestBefore(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        uint256[] memory values = tree.values();
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            uint256 nearestBefore = tree.nearestBefore(x).value();
//            for (uint256 j = 0; j < values.length; ++j) {
//                if (values[j] <= x && values[j] > nearestBefore) {
//                    nearestBefore = values[j];
//                }
//            }
//            assertEq(tree.nearestBefore(x).value(), nearestBefore);
//        }
//    }
//
//    function testInvariantNearestAfter(uint256[] memory a) public {
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            if (tree.exists(x)) {
//                tree.remove(x);
//            } else {
//                tree.insert(x);
//            }
//        }
//        uint256[] memory values = tree.values();
//        for (uint256 i = 0; i < a.length; ++i) {
//            uint256 x = a[i];
//            if (x == 0) continue;
//            uint256 nearestAfter = tree.nearestAfter(x).value();
//            for (uint256 j = 0; j < values.length; ++j) {
//                if (values[j] >= x && values[j] < nearestAfter) {
//                    nearestAfter = values[j];
//                }
//            }
//            assertEq(tree.nearestAfter(x).value(), nearestAfter);
//        }
//    }
//
//    function testInsertZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.insert(0);
//    }
//
//    function testTryInsertZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.tryInsert(0);
//    }
//
//    function testRemoveZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.remove(0);
//    }
//
//    function testTryRemoveZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.tryRemove(0);
//    }
//
//    function testFindZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.find(0);
//    }
//
//    function testNearestZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.nearest(0);
//    }
//
//    function testNearestBeforeZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.nearestBefore(0);
//    }
//
//    function testNearestAfterZeroValueReverts() public {
//        vm.expectRevert(RedBlackTreeLib.ValueIsEmpty.selector);
//        tree.nearestAfter(0);
//    }
//
//
//}
