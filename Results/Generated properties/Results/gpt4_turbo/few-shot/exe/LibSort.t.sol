// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/LibSort.sol";

contract LibSortTest is Test {
    using LibSort for uint256[];
    using LibSort for int256[];
    using LibSort for address[];

    uint256[] private testArray;
    int256[] private testIntArray;
    address[] private testAddressArray;

    function setUp() public {
        testArray = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
    testIntArray = [int256(3), int256(1), int256(-4), int256(1), int256(-5), int256(9), int256(2), int256(-6), int256(5), int256(3), int256(-5)];

        testAddressArray = [
            address(0x1),
            address(0x3),
            address(0x2),
            address(0x5),
            address(0x4)
        ];
    }

//    function testInsertionSort() public {
//        testArray.insertionSort();
//        assertTrue(_isSorted(testArray));
//
//        testIntArray.insertionSort();
//        assertTrue(_isSorted(testIntArray));
////
////        testAddressArray.insertionSort();
////        assertTrue(_isSorted(testAddressArray));
//    }

//    function testIntroQuickSort() public {
//        testArray.sort();
//        assertTrue(_isSorted(testArray));
//
//        testIntArray.sort();
//        assertTrue(_isSorted(testIntArray));
//
//        testAddressArray.sort();
//        assertTrue(_isSorted(testAddressArray));
//    }

//    function testUniquifySorted() public {
//        testArray.sort();
//        testArray.uniquifySorted();
//        assertTrue(_isSortedAndUniquified(testArray));
////
////        testIntArray.sort();
////        testIntArray.uniquifySorted();
////        assertTrue(_isSortedAndUniquified(testIntArray));
////
////        testAddressArray.sort();
////        testAddressArray.uniquifySorted();
////        assertTrue(_isSortedAndUniquified(testAddressArray));
//    }

    function testReverse() public {
        testArray.reverse();
        assertTrue(_isReversed(testArray));

        testIntArray.reverse();
        assertTrue(_isReversed(testIntArray));

        testAddressArray.reverse();
        assertTrue(_isReversed(testAddressArray));
    }

    function testCopy() public {
        uint256[] memory copiedArray = testArray.copy();
        assertEq(copiedArray.length, testArray.length);
        for (uint i = 0; i < copiedArray.length; i++) {
            assertEq(copiedArray[i], testArray[i]);
        }

        int256[] memory copiedIntArray = testIntArray.copy();
        assertEq(copiedIntArray.length, testIntArray.length);
        for (uint i = 0; i < copiedIntArray.length; i++) {
            assertEq(copiedIntArray[i], testIntArray[i]);
        }

        address[] memory copiedAddressArray = testAddressArray.copy();
        assertEq(copiedAddressArray.length, testAddressArray.length);
        for (uint i = 0; i < copiedAddressArray.length; i++) {
            assertEq(copiedAddressArray[i], testAddressArray[i]);
        }
    }

//    function testIsSorted() public {
//        testArray.sort();
//        assertTrue(testArray.isSorted());
//
//        testIntArray.sort();
//        assertTrue(testIntArray.isSorted());
//
//        testAddressArray.sort();
//        assertTrue(testAddressArray.isSorted());
//    }

//    function testIsSortedAndUniquified() public {
//        testArray.sort();
//        testArray.uniquifySorted();
//        assertTrue(testArray.isSortedAndUniquified());
//
//        testIntArray.sort();
//        testIntArray.uniquifySorted();
//        assertTrue(testIntArray.isSortedAndUniquified());
//
//        testAddressArray.sort();
//        testAddressArray.uniquifySorted();
//        assertTrue(testAddressArray.isSortedAndUniquified());
//    }

    function _isSorted(uint256[] memory array) private pure returns (bool) {
        for (uint i = 1; i < array.length; i++) {
            if (array[i - 1] > array[i]) {
                return false;
            }
        }
        return true;
    }

    function _isSorted(int256[] memory array) private pure returns (bool) {
        for (uint i = 1; i < array.length; i++) {
            if (array[i - 1] > array[i]) {
                return false;
            }
        }
        return true;
    }

    function _isSorted(address[] memory array) private pure returns (bool) {
        for (uint i = 1; i < array.length; i++) {
            if (uint160(array[i - 1]) > uint160(array[i])) {
                return false;
            }
        }
        return true;
    }

    function _isSortedAndUniquified(uint256[] memory array) private pure returns (bool) {
        if (array.length <= 1) {
            return true;
        }
        for (uint i = 1; i < array.length; i++) {
            if (array[i - 1] >= array[i]) {
                return false;
            }
        }
        return true;
    }

    function _isReversed(uint256[] memory array) private pure returns (bool) {
        uint256[] memory original = array.copy();
        array.reverse();
        array.reverse();
        for (uint i = 0; i < array.length; i++) {
            if (array[i] != original[i]) {
                return false;
            }
        }
        return true;
    }

    function _isReversed(int256[] memory array) private pure returns (bool) {
        int256[] memory original = array.copy();
        array.reverse();
        array.reverse();
        for (uint i = 0; i < array.length; i++) {
            if (array[i] != original[i]) {
                return false;
            }
        }
        return true;
    }

    function _isReversed(address[] memory array) private pure returns (bool) {
        address[] memory original = array.copy();
        array.reverse();
        array.reverse();
        for (uint i = 0; i < array.length; i++) {
            if (array[i] != original[i]) {
                return false;
            }
        }
        return true;
    }
}