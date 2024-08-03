// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/LibSort.sol";

contract LibSortTest is Test {
    using LibSort for uint256[];
    using LibSort for int256[];
    using LibSort for address[];

    uint256[] private testArray;
    int256[] private testIntArray;
    address[] private testAddressArray;

    function setUp() public {
        testArray = [5, 3, 8, 1, 4];
        testIntArray = [int256(5), int256(3), int256(8), int256(1), int256(4)];
        testAddressArray = [address(5), address(3), address(8), address(1), address(4)];
    }

    function testInsertionSort() public {
        testArray.insertionSort();
        assertEq(testArray[0], 1);
        assertEq(testArray[1], 3);
        assertEq(testArray[2], 4);
        assertEq(testArray[3], 5);
        assertEq(testArray[4], 8);
    }

    function testInsertionSortInt() public {
        testIntArray.insertionSort();
        assertEq(testIntArray[0], int256(1));
        assertEq(testIntArray[1], int256(3));
        assertEq(testIntArray[2], int256(4));
        assertEq(testIntArray[3], int256(5));
        assertEq(testIntArray[4], int256(8));
    }

    function testInsertionSortAddress() public {
        testAddressArray.insertionSort();
        assertEq(testAddressArray[0], address(1));
        assertEq(testAddressArray[1], address(3));
        assertEq(testAddressArray[2], address(4));
        assertEq(testAddressArray[3], address(5));
        assertEq(testAddressArray[4], address(8));
    }

    function testSort() public {
        testArray.sort();
        assertEq(testArray[0], 1);
        assertEq(testArray[1], 3);
        assertEq(testArray[2], 4);
        assertEq(testArray[3], 5);
        assertEq(testArray[4], 8);
    }

    function testSortInt() public {
        testIntArray.sort();
        assertEq(testIntArray[0], int256(1));
        assertEq(testIntArray[1], int256(3));
        assertEq(testIntArray[2], int256(4));
        assertEq(testIntArray[3], int256(5));
        assertEq(testIntArray[4], int256(8));
    }

    function testSortAddress() public {
        testAddressArray.sort();
        assertEq(testAddressArray[0], address(1));
        assertEq(testAddressArray[1], address(3));
        assertEq(testAddressArray[2], address(4));
        assertEq(testAddressArray[3], address(5));
        assertEq(testAddressArray[4], address(8));
    }

    function testUniquifySorted() public {
        uint256[] memory uniqueArray = new uint256[](10);
        uniqueArray[0] = 1;
        uniqueArray[1] = 1;
        uniqueArray[2] = 2;
        uniqueArray[3] = 2;
        uniqueArray[4] = 3;
        uniqueArray[5] = 3;
        uniqueArray[6] = 4;
        uniqueArray[7] = 4;
        uniqueArray[8] = 5;
        uniqueArray[9] = 5;
        uniqueArray.uniquifySorted();
        assertEq(uniqueArray.length, 5);
        assertEq(uniqueArray[0], 1);
        assertEq(uniqueArray[1], 2);
        assertEq(uniqueArray[2], 3);
        assertEq(uniqueArray[3], 4);
        assertEq(uniqueArray[4], 5);
    }

    function testSearchSorted() public {
        bool found;
        uint256 index;
        (found, index) = testArray.searchSorted(3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = testArray.searchSorted(6);
        assertFalse(found);
    }

    function testReverse() public {
        testArray.reverse();
        assertEq(testArray[0], 4);
        assertEq(testArray[1], 1);
        assertEq(testArray[2], 8);
        assertEq(testArray[3], 3);
        assertEq(testArray[4], 5);
    }

    function testCopy() public {
        uint256[] memory copiedArray = testArray.copy();
        assertEq(copiedArray.length, testArray.length);
        for (uint256 i = 0; i < copiedArray.length; i++) {
            assertEq(copiedArray[i], testArray[i]);
        }
    }

    function testIsSorted() public {
        assertFalse(testArray.isSorted());
        testArray.sort();
        assertTrue(testArray.isSorted());
    }

    function testIsSortedAndUniquified() public {
        uint256[] memory sortedArray = new uint256[](6);
        sortedArray[0] = 1;
        sortedArray[1] = 2;
        sortedArray[2] = 2;
        sortedArray[3] = 3;
        sortedArray[4] = 4;
        sortedArray[5] = 5;
        assertFalse(sortedArray.isSortedAndUniquified());
        sortedArray.uniquifySorted();
        assertTrue(sortedArray.isSortedAndUniquified());
    }
}