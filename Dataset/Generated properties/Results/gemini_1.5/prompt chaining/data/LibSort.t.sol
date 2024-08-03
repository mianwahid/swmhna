// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibSort.sol";

contract LibSortTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       INSERTION SORT                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testInsertionSortEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        LibSort.insertionSort(a);
        assertEq(a.length, 0);
    }

    function testInsertionSortSingleElementArray() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        LibSort.insertionSort(a);
        assertEq(a.length, 1);
        assertEq(a[0], 1);
    }

    function testInsertionSortAlreadySortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        LibSort.insertionSort(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
        assertEq(a[3], 4);
        assertEq(a[4], 5);
    }

    function testInsertionSortReverseSortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 5;
        a[1] = 4;
        a[2] = 3;
        a[3] = 2;
        a[4] = 1;
        LibSort.insertionSort(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
        assertEq(a[3], 4);
        assertEq(a[4], 5);
    }

    function testInsertionSortArrayWithDuplicateElements() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 3;
        a[1] = 2;
        a[2] = 1;
        a[3] = 2;
        a[4] = 3;
        LibSort.insertionSort(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 2);
        assertEq(a[3], 3);
        assertEq(a[4], 3);
    }

    function testInsertionSortWithMinMaxValues() public {
        uint256[] memory a = new uint256[](3);
        a[0] = 0;
        a[1] = 2 ** 256 - 1;
        a[2] = 1;
        LibSort.insertionSort(a);
        assertEq(a.length, 3);
        assertEq(a[0], 0);
        assertEq(a[1], 1);
        assertEq(a[2], 2 ** 256 - 1);
    }

    function testInsertionSortInt256WithMinMaxValues() public {
        int256[] memory a = new int256[](3);
        a[0] = -2 ** 255;
        a[1] = 2 ** 255 - 1;
        a[2] = -1;
        LibSort.insertionSort(a);
        assertEq(a.length, 3);
        assertEq(a[0], -2 ** 255);
        assertEq(a[1], -1);
        assertEq(a[2], 2 ** 255 - 1);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      INTRO-QUICKSORT                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSortEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        LibSort.sort(a);
        assertEq(a.length, 0);
    }

    function testSortSingleElementArray() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        LibSort.sort(a);
        assertEq(a.length, 1);
        assertEq(a[0], 1);
    }

    function testSortAlreadySortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        LibSort.sort(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
        assertEq(a[3], 4);
        assertEq(a[4], 5);
    }

    function testSortReverseSortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 5;
        a[1] = 4;
        a[2] = 3;
        a[3] = 2;
        a[4] = 1;
        LibSort.sort(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
        assertEq(a[3], 4);
        assertEq(a[4], 5);
    }

    function testSortArrayWithDuplicateElements() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 3;
        a[1] = 2;
        a[2] = 1;
        a[3] = 2;
        a[4] = 3;
        LibSort.sort(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 2);
        assertEq(a[3], 3);
        assertEq(a[4], 3);
    }

    function testSortWithMinMaxValues() public {
        uint256[] memory a = new uint256[](3);
        a[0] = 0;
        a[1] = 2 ** 256 - 1;
        a[2] = 1;
        LibSort.sort(a);
        assertEq(a.length, 3);
        assertEq(a[0], 0);
        assertEq(a[1], 1);
        assertEq(a[2], 2 ** 256 - 1);
    }

    function testSortInt256WithMinMaxValues() public {
        int256[] memory a = new int256[](3);
        a[0] = -2 ** 255;
        a[1] = 2 ** 255 - 1;
        a[2] = -1;
        LibSort.sort(a);
        assertEq(a.length, 3);
        assertEq(a[0], -2 ** 255);
        assertEq(a[1], -1);
        assertEq(a[2], 2 ** 255 - 1);
    }

    function testSortLargeArray() public {
        uint256[] memory a = new uint256[](1000);
        for (uint256 i = 0; i < a.length; i++) {
            a[i] = uint256(keccak256(abi.encode(i)));
        }
        LibSort.sort(a);
        for (uint256 i = 1; i < a.length; i++) {
            assertTrue(a[i - 1] <= a[i]);
        }
    }

    function testSortRandomArray() public {
        uint256[] memory a = new uint256[](100);
        for (uint256 i = 0; i < a.length; i++) {
            a[i] = uint256(keccak256(abi.encode(i, block.timestamp, msg.sender)));
        }
        LibSort.sort(a);
        for (uint256 i = 1; i < a.length; i++) {
            assertTrue(a[i - 1] <= a[i]);
        }
    }

    function testSortAlmostSortedArray() public {
        uint256[] memory a = new uint256[](100);
        for (uint256 i = 0; i < a.length; i++) {
            a[i] = i;
        }
        a[50] = 10;
        LibSort.sort(a);
        for (uint256 i = 1; i < a.length; i++) {
            assertTrue(a[i - 1] <= a[i]);
        }
    }

    function testSortFewUniqueElementsArray() public {
        uint256[] memory a = new uint256[](100);
        for (uint256 i = 0; i < a.length; i++) {
            a[i] = i % 10;
        }
        LibSort.sort(a);
        for (uint256 i = 1; i < a.length; i++) {
            assertTrue(a[i - 1] <= a[i]);
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  OTHER USEFUL OPERATIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testUniquifySortedEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        LibSort.uniquifySorted(a);
        assertEq(a.length, 0);
    }

    function testUniquifySortedSingleElementArray() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        LibSort.uniquifySorted(a);
        assertEq(a.length, 1);
        assertEq(a[0], 1);
    }

    function testUniquifySortedArrayWithAllUniqueElements() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        LibSort.uniquifySorted(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
        assertEq(a[3], 4);
        assertEq(a[4], 5);
    }

    function testUniquifySortedArrayWithConsecutiveDuplicateElements() public {
        uint256[] memory a = new uint256[](6);
        a[0] = 1;
        a[1] = 1;
        a[2] = 2;
        a[3] = 2;
        a[4] = 3;
        a[5] = 3;
        LibSort.uniquifySorted(a);
        assertEq(a.length, 3);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
    }

    function testUniquifySortedArrayWithNonConsecutiveDuplicateElements() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 1;
        a[3] = 2;
        a[4] = 1;
        LibSort.uniquifySorted(a);
        assertEq(a.length, 5);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 1);
        assertEq(a[3], 2);
        assertEq(a[4], 1);
    }

    function testSearchSortedEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        (bool found, uint256 index) = LibSort.searchSorted(a, 1);
        assertFalse(found);
        assertEq(index, 0);
    }

    function testSearchSortedSingleElementArrayFound() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        (bool found, uint256 index) = LibSort.searchSorted(a, 1);
        assertTrue(found);
        assertEq(index, 0);
    }

    function testSearchSortedSingleElementArrayNotFound() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        (bool found, uint256 index) = LibSort.searchSorted(a, 2);
        assertFalse(found);
        assertEq(index, 0);
    }

    function testSearchSortedNeedlePresent() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 3;
        a[2] = 5;
        a[3] = 7;
        a[4] = 9;
        (bool found, uint256 index) = LibSort.searchSorted(a, 5);
        assertTrue(found);
        assertEq(index, 2);
    }

    function testSearchSortedNeedleNotPresentSmaller() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 3;
        a[2] = 5;
        a[3] = 7;
        a[4] = 9;
        (bool found, uint256 index) = LibSort.searchSorted(a, 0);
        assertFalse(found);
        assertEq(index, 0);
    }

    function testSearchSortedNeedleNotPresentLarger() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 3;
        a[2] = 5;
        a[3] = 7;
        a[4] = 9;
        (bool found, uint256 index) = LibSort.searchSorted(a, 10);
        assertFalse(found);
        assertEq(index, 4);
    }

    function testSearchSortedNeedleNotPresentMiddle() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 3;
        a[2] = 5;
        a[3] = 7;
        a[4] = 9;
        (bool found, uint256 index) = LibSort.searchSorted(a, 4);
        assertFalse(found);
        assertEq(index, 1);
    }

    function testReverseEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        LibSort.reverse(a);
        assertEq(a.length, 0);
    }

    function testReverseSingleElementArray() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        LibSort.reverse(a);
        assertEq(a.length, 1);
        assertEq(a[0], 1);
    }

    function testReverseMultipleElementsArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        LibSort.reverse(a);
        assertEq(a.length, 5);
        assertEq(a[0], 5);
        assertEq(a[1], 4);
        assertEq(a[2], 3);
        assertEq(a[3], 2);
        assertEq(a[4], 1);
    }

    function testCopyEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        uint256[] memory b = LibSort.copy(a);
        assertEq(b.length, 0);
    }

    function testCopyNonEmptyArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = LibSort.copy(a);
        assertEq(b.length, 5);
        assertEq(b[0], 1);
        assertEq(b[1], 2);
        assertEq(b[2], 3);
        assertEq(b[3], 4);
        assertEq(b[4], 5);
    }

    function testCopyModifiedArrays() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = LibSort.copy(a);
        a[0] = 10;
        b[0] = 20;
        assertEq(a[0], 10);
        assertEq(b[0], 20);
    }

    function testIsSortedEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        assertTrue(LibSort.isSorted(a));
    }

    function testIsSortedSingleElementArray() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        assertTrue(LibSort.isSorted(a));
    }

    function testIsSortedSortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        assertTrue(LibSort.isSorted(a));
    }

    function testIsSortedUnsortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 5;
        a[1] = 3;
        a[2] = 1;
        a[3] = 4;
        a[4] = 2;
        assertFalse(LibSort.isSorted(a));
    }

    function testIsSortedAndUniquifiedEmptyArray() public {
        uint256[] memory a = new uint256[](0);
        assertTrue(LibSort.isSortedAndUniquified(a));
    }

    function testIsSortedAndUniquifiedSingleElementArray() public {
        uint256[] memory a = new uint256[](1);
        a[0] = 1;
        assertTrue(LibSort.isSortedAndUniquified(a));
    }

    function testIsSortedAndUniquifiedSortedAndUniquifiedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        assertTrue(LibSort.isSortedAndUniquified(a));
    }

    function testIsSortedAndUniquifiedSortedButNotUniquifiedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 2;
        a[3] = 4;
        a[4] = 5;
        assertFalse(LibSort.isSortedAndUniquified(a));
    }

    function testIsSortedAndUniquifiedUnsortedArray() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 5;
        a[1] = 3;
        a[2] = 1;
        a[3] = 4;
        a[4] = 2;
        assertFalse(LibSort.isSortedAndUniquified(a));
    }

    function testDifference() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = new uint256[](3);
        b[0] = 2;
        b[1] = 4;
        b[2] = 6;
        uint256[] memory c = LibSort.difference(a, b);
        assertEq(c.length, 3);
        assertEq(c[0], 1);
        assertEq(c[1], 3);
        assertEq(c[2], 5);
    }

    function testIntersection() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = new uint256[](3);
        b[0] = 2;
        b[1] = 4;
        b[2] = 6;
        uint256[] memory c = LibSort.intersection(a, b);
        assertEq(c.length, 2);
        assertEq(c[0], 2);
        assertEq(c[1], 4);
    }

    function testUnion() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = new uint256[](3);
        b[0] = 2;
        b[1] = 4;
        b[2] = 6;
        uint256[] memory c = LibSort.union(a, b);
        assertEq(c.length, 6);
        assertEq(c[0], 1);
        assertEq(c[1], 2);
        assertEq(c[2], 3);
        assertEq(c[3], 4);
        assertEq(c[4], 5);
        assertEq(c[5], 6);
    }
}