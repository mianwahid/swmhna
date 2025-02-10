// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/RedBlackTreeLib.sol";

contract RedBlackTreeLibTest is Test {
    using RedBlackTreeLib for RedBlackTreeLib.Tree;

    RedBlackTreeLib.Tree private tree;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The value cannot be zero.
    error ValueIsEmpty();

    /// @dev Cannot insert a value that already exists.
    error ValueAlreadyExists();

    /// @dev Cannot remove a value that does not exist.
    error ValueDoesNotExist();

    /// @dev The pointer is out of bounds.
    error PointerOutOfBounds();

    /// @dev The tree is full.
    error TreeIsFull();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TEST HELPERS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _insert(uint256 x) internal {
        tree.insert(x);
    }

    function _remove(uint256 x) internal {
        tree.remove(x);
    }

    function _checkNearest(uint256 x, bytes32 expected) internal {
        assertEq(tree.nearest(x), expected);
    }

    function _checkNearestBefore(uint256 x, bytes32 expected) internal {
        assertEq(tree.nearestBefore(x), expected);
    }

    function _checkNearestAfter(uint256 x, bytes32 expected) internal {
        assertEq(tree.nearestAfter(x), expected);
    }

    function _checkFirst(bytes32 expected) internal {
        assertEq(tree.first(), expected);
    }

    function _checkLast(bytes32 expected) internal {
        assertEq(tree.last(), expected);
    }

//    function _checkNext(bytes32 ptr, bytes32 expected) internal {
//        assertEq(tree.next(ptr), expected);
//    }

    function _checkPrev(bytes32 ptr, bytes32 expected) internal {
        assertEq(tree.prev(ptr), expected);
    }

    function _checkValues(uint256[] memory expected) internal {
        assertEq(tree.values(), expected);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           TESTS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public virtual {
        tree = RedBlackTreeLib.Tree({ _spacer: 0 });
    }

    function testSizeEmpty() public {
        assertEq(tree.size(), 0);
    }

    function testSizeAfterInsert() public {
        _insert(1);
        assertEq(tree.size(), 1);
        _insert(2);
        assertEq(tree.size(), 2);
    }

    function testSizeAfterRemove() public {
        _insert(1);
        _insert(2);
        _remove(1);
        assertEq(tree.size(), 1);
        _remove(2);
        assertEq(tree.size(), 0);
    }

    function testValuesEmpty() public {
        _checkValues([]);
    }

    function testValuesSortedOrder() public {
        _insert(3);
        _insert(1);
        _insert(4);
        _insert(2);
        _checkValues([1, 2, 3, 4]);
    }

    function testValuesComplete() public {
        _insert(3);
        _insert(1);
        _insert(4);
        _insert(2);
        uint256[] memory values = tree.values();
        assertEq(values.length, tree.size());
        for (uint256 i = 0; i < values.length; i++) {
            assertTrue(tree.exists(values[i]));
        }
    }

    function testFindNonExisting() public {
        assertEq(tree.find(1), bytes32(0));
    }

    function testFindExisting() public {
        _insert(1);
        bytes32 ptr = tree.find(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestEmpty() public {
        assertEq(tree.nearest(1), bytes32(0));
    }

    function testNearestExactMatch() public {
        _insert(1);
        bytes32 ptr = tree.nearest(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestTieBreaker() public {
        _insert(1);
        _insert(3);
        bytes32 ptr = tree.nearest(2);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1); // Should prioritize the smaller value (1).
    }

    function testNearestBeforeEmpty() public {
        assertEq(tree.nearestBefore(1), bytes32(0));
    }

    function testNearestBeforeExactMatch() public {
        _insert(1);
        bytes32 ptr = tree.nearestBefore(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestBeforeNonExisting() public {
        _insert(1);
        _insert(3);
        bytes32 ptr = tree.nearestBefore(2);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestAfterEmpty() public {
        assertEq(tree.nearestAfter(1), bytes32(0));
    }

    function testNearestAfterExactMatch() public {
        _insert(1);
        bytes32 ptr = tree.nearestAfter(1);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 1);
    }

    function testNearestAfterNonExisting() public {
        _insert(1);
        _insert(3);
        bytes32 ptr = tree.nearestAfter(2);
        assertTrue(ptr != bytes32(0));
        assertEq(tree.value(ptr), 3);
    }

    function testExistsNonExisting() public {
        assertFalse(tree.exists(1));
    }

    function testExistsExisting() public {
        _insert(1);
        assertTrue(tree.exists(1));
    }

    function testInsertDuplicate() public {
        _insert(1);
        vm.expectRevert(abi.encodeWithSelector(ValueAlreadyExists.selector));
        _insert(1);
    }

    function testInsertSuccessful() public {
        _insert(1);
        assertTrue(tree.exists(1));
    }

    function testRemoveNonExisting() public {
        vm.expectRevert(abi.encodeWithSelector(ValueDoesNotExist.selector));
        _remove(1);
    }

    function testRemoveSuccessful() public {
        _insert(1);
        _remove(1);
        assertFalse(tree.exists(1));
    }

    function testRemovePointerInvalidation() public {
        _insert(1);
        _insert(2);
        bytes32 ptr = tree.find(1);
        _remove(ptr);
        vm.expectRevert(abi.encodeWithSelector(ValueDoesNotExist.selector));
        tree.remove(ptr); // Should revert since the pointer might be invalid now.
    }

    function testValueEmptyPointer() public {
        assertEq(tree.value(bytes32(0)), 0);
    }

    function testValueValidPointer() public {
        _insert(1);
        bytes32 ptr = tree.find(1);
        assertEq(tree.value(ptr), 1);
    }

    function testFirstEmpty() public {
        assertEq(tree.first(), bytes32(0));
    }

    function testFirstSmallestValue() public {
        _insert(3);
        _insert(1);
        _insert(2);
        bytes32 ptr = tree.first();
        assertEq(tree.value(ptr), 1);
    }

    function testLastEmpty() public {
        assertEq(tree.last(), bytes32(0));
    }

    function testLastLargestValue() public {
        _insert(1);
        _insert(3);
        _insert(2);
        bytes32 ptr = tree.last();
        assertEq(tree.value(ptr), 3);
    }

    function testNextEmptyPointer() public {
        assertEq(tree.next(bytes32(0)), bytes32(0));
    }

    function testNextLastNode() public {
        _insert(1);
        _insert(2);
        bytes32 last = tree.last();
        assertEq(tree.next(last), bytes32(0));
    }

    function testNextCorrectNavigation() public {
        _insert(1);
        _insert(3);
        _insert(2);
        bytes32 ptr = tree.first();
        ptr = tree.next(ptr);
        assertEq(tree.value(ptr), 2);
        ptr = tree.next(ptr);
        assertEq(tree.value(ptr), 3);
    }

    function testPrevEmptyPointer() public {
        assertEq(tree.prev(bytes32(0)), bytes32(0));
    }

    function testPrevFirstNode() public {
        _insert(2);
        _insert(1);
        bytes32 first = tree.first();
        assertEq(tree.prev(first), bytes32(0));
    }

    function testPrevCorrectNavigation() public {
        _insert(3);
        _insert(1);
        _insert(2);
        bytes32 ptr = tree.last();
        ptr = tree.prev(ptr);
        assertEq(tree.value(ptr), 2);
        ptr = tree.prev(ptr);
        assertEq(tree.value(ptr), 1);
    }

    function testIsEmptyEmptyPointer() public {
        assertTrue(tree.isEmpty(bytes32(0)));
    }

    function testIsEmptyNonEmptyPointer() public {
        _insert(1);
        bytes32 ptr = tree.find(1);
        assertFalse(tree.isEmpty(ptr));
    }

    function testTryInsertFullTree() public {
        uint256 maxNodes = (1 << 31) - 1;
        vm.assume(maxNodes > 10);
        for (uint256 i = 1; i <= maxNodes; ++i) {
            tree.tryInsert(i);
        }
        assertEq(tree.tryInsert(0), RedBlackTreeLib.ERROR_TREE_IS_FULL);
    }

    function testInsertZeroValue() public {
        vm.expectRevert(abi.encodeWithSelector(ValueIsEmpty.selector));
        _insert(0);
    }

    function testRemoveZeroValue() public {
        vm.expectRevert(abi.encodeWithSelector(ValueIsEmpty.selector));
        _remove(0);
    }

    function testInsertMaxMinValue() public {
        tree.insert(type(uint256).max);
        tree.insert(1);
        tree.insert(type(uint256).min);
        assertEq(tree.size(), 3);
    }

    function testRemoveMaxMinValue() public {
        tree.insert(type(uint256).max);
        tree.insert(1);
        tree.insert(type(uint256).min);
        tree.remove(type(uint256).max);
        tree.remove(1);
        tree.remove(type(uint256).min);
        assertEq(tree.size(), 0);
    }

    function testInsertMultipleValues() public {
        uint256[] memory values = new uint256[](100);
        for (uint256 i = 0; i < values.length; ++i) {
            values[i] = i + 1;
            tree.insert(values[i]);
        }
        assertEq(tree.size(), values.length);
        _checkValues(values);
    }

    function testRemoveMultipleValues() public {
        uint256[] memory values = new uint256[](100);
        for (uint256 i = 0; i < values.length; ++i) {
            values[i] = i + 1;
            tree.insert(values[i]);
        }
        for (uint256 i = 0; i < values.length; ++i) {
            tree.remove(values[i]);
        }
        assertEq(tree.size(), 0);
    }

    function testInsertRemoveRandomValues() public {
        uint256[] memory values = new uint256[](100);
        for (uint256 i = 0; i < values.length; ++i) {
            uint256 value = uint256(keccak256(abi.encode(i))) % 1000;
            values[i] = value;
            tree.tryInsert(value);
        }
        for (uint256 i = 0; i < values.length; ++i) {
            tree.tryRemove(values[i]);
        }
        assertEq(tree.size(), 0);
    }

    function testNearestEdgeCases() public {
        _insert(1);
        _insert(5);
        _insert(10);
        _checkNearest(3, tree.find(5));
        _checkNearest(6, tree.find(5));
        _checkNearest(1, tree.find(1));
        _checkNearest(10, tree.find(10));
    }

    function testNearestBeforeEdgeCases() public {
        _insert(1);
        _insert(5);
        _insert(10);
        _checkNearestBefore(3, tree.find(1));
        _checkNearestBefore(6, tree.find(5));
        _checkNearestBefore(1, tree.find(1));
        _checkNearestBefore(10, tree.find(5));
    }

    function testNearestAfterEdgeCases() public {
        _insert(1);
        _insert(5);
        _insert(10);
        _checkNearestAfter(3, tree.find(5));
        _checkNearestAfter(6, tree.find(10));
        _checkNearestAfter(1, tree.find(1));
        _checkNearestAfter(10, tree.find(10));
    }

    function testNavigationEdgeCases() public {
        _insert(1);
        _insert(5);
        _insert(10);
        _checkFirst(tree.find(1));
        _checkLast(tree.find(10));
//        _checkNext(tree.find(1), tree.find(5));
//        _checkNext(tree.find(5), tree.find(10));
        _checkPrev(tree.find(10), tree.find(5));
        _checkPrev(tree.find(5), tree.find(1));
    }
}
