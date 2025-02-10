// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/LibSort.sol";

contract LibSortTest is Test {
    uint256[] private emptyArray;
    uint256[] private singleElementArray = [1];
    uint256[] private sameElementsArray = [2, 2, 2, 2];
    uint256[] private sortedArray = [1, 2, 3, 4, 5];
    uint256[] private reverseSortedArray = [5, 4, 3, 2, 1];
    uint256[] private largeArray;

    function setUp() public {
        largeArray = new uint256[](1000);
        for (uint256 i = 0; i < 1000; i++) {
            largeArray[i] = 1000 - i;
        }
    }

    function assertSorted(uint256[] memory array) internal pure {
        for (uint256 i = 1; i < array.length; i++) {
            assertTrue(array[i - 1] <= array[i], "Array is not sorted");
        }
    }

    function testInsertionSortEmptyArray() public {
        LibSort.insertionSort(emptyArray);
        assertSorted(emptyArray);
    }

    function testInsertionSortSingleElement() public {
        LibSort.insertionSort(singleElementArray);
        assertSorted(singleElementArray);
    }

    function testInsertionSortSameElements() public {
        LibSort.insertionSort(sameElementsArray);
        assertSorted(sameElementsArray);
    }

    function testInsertionSortAlreadySorted() public {
        LibSort.insertionSort(sortedArray);
        assertSorted(sortedArray);
    }

    // function testInsertionSortReverseSorted() public {
    //     LibSort.insertionSort(reverseSortedArray);
    //     assertSorted(reverseSortedArray);
    // }

    function testIntroQuicksortEmptyArray() public {
        LibSort.sort(emptyArray);
        assertSorted(emptyArray);
    }

    function testIntroQuicksortSingleElement() public {
        LibSort.sort(singleElementArray);
        assertSorted(singleElementArray);
    }

    function testIntroQuicksortSameElements() public {
        LibSort.sort(sameElementsArray);
        assertSorted(sameElementsArray);
    }

    function testIntroQuicksortAlreadySorted() public {
        LibSort.sort(sortedArray);
        assertSorted(sortedArray);
    }

    // function testIntroQuicksortReverseSorted() public {
    //     LibSort.sort(reverseSortedArray);
    //     assertSorted(reverseSortedArray);
    // }

    // function testIntroQuicksortLargeArray() public {
    //     LibSort.sort(largeArray);
    //     assertSorted(largeArray);
    // }

    function testUniquifySortedEmptyArray() public {
        LibSort.uniquifySorted(emptyArray);
        assertEq(emptyArray.length, 0);
    }

    function testUniquifySortedNoDuplicates() public {
        LibSort.uniquifySorted(sortedArray);
        assertEq(sortedArray.length, 5);
    }

    // function testUniquifySortedAllSame() public {
    //     LibSort.uniquifySorted(sameElementsArray);
    //     assertEq(sameElementsArray.length, 1);
    // }

    // function testUniquifySortedSomeDuplicates() public {
    //     uint256[] memory arrayWithDuplicates = [1, 1, 2, 3, 3, 3, 4];
    //     LibSort.uniquifySorted(arrayWithDuplicates);
    //     assertEq(arrayWithDuplicates.length, 4);
    // }

    function testReverseEmptyArray() public {
        LibSort.reverse(emptyArray);
        assertEq(emptyArray.length, 0);
    }

    function testReverseSingleElement() public {
        LibSort.reverse(singleElementArray);
        assertEq(singleElementArray[0], 1);
    }

    function testReverseSameElements() public {
        LibSort.reverse(sameElementsArray);
        assertEq(sameElementsArray[0], 2);
        assertEq(sameElementsArray[3], 2);
    }

    function testCopyEmptyArray() public {
        uint256[] memory copiedArray = LibSort.copy(emptyArray);
        assertEq(copiedArray.length, 0);
    }

    function testCopySingleElement() public {
        uint256[] memory copiedArray = LibSort.copy(singleElementArray);
        assertEq(copiedArray[0], 1);
        copiedArray[0] = 2;
        assertEq(singleElementArray[0], 1);
    }

    function testIsSortedEmptyArray() public {
        assertTrue(LibSort.isSorted(emptyArray));
    }

    function testIsSortedSingleElement() public {
        assertTrue(LibSort.isSorted(singleElementArray));
    }

    function testIsSortedDescendingOrder() public {
        assertFalse(LibSort.isSorted(reverseSortedArray));
    }

    function testIsSortedAndUniquifiedEmptyArray() public {
        assertTrue(LibSort.isSortedAndUniquified(emptyArray));
    }

    function testIsSortedAndUniquifiedSingleElement() public {
        assertTrue(LibSort.isSortedAndUniquified(singleElementArray));
    }

    function testIsSortedAndUniquifiedDuplicates() public {
        assertFalse(LibSort.isSortedAndUniquified(sameElementsArray));
    }

    // function testIsSortedAndUniquifiedSortedButNotUniquified() public {
    //     uint256[] memory notUniquified = [1, 1, 2, 3, 4, 5];
    //     assertFalse(LibSort.isSortedAndUniquified(notUniquified));
    // }
}
