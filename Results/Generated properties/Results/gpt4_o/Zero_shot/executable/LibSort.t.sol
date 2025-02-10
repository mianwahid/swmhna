// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibSort.sol";

contract LibSortTest is Test {
    using LibSort for uint256[];
    using LibSort for int256[];
    using LibSort for address[];

    function testInsertionSortUint256() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 5;
        arr[1] = 3;
        arr[2] = 4;
        arr[3] = 1;
        arr[4] = 2;
        arr.insertionSort();
        assertTrue(arr.isSorted());
    }

    function testInsertionSortInt256() public {
        int256[] memory arr = new int256[](5);
        arr[0] = 5;
        arr[1] = 3;
        arr[2] = 4;
        arr[3] = 1;
        arr[4] = 2;
        arr.insertionSort();
        assertTrue(arr.isSorted());
    }

    function testInsertionSortAddress() public {
        address[] memory arr = new address[](5);
        arr[0] = address(5);
        arr[1] = address(3);
        arr[2] = address(4);
        arr[3] = address(1);
        arr[4] = address(2);
        arr.insertionSort();
        assertTrue(arr.isSorted());
    }

    function testSortUint256() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 5;
        arr[1] = 3;
        arr[2] = 4;
        arr[3] = 1;
        arr[4] = 2;
        arr.sort();
        assertTrue(arr.isSorted());
    }

    function testSortInt256() public {
        int256[] memory arr = new int256[](5);
        arr[0] = 5;
        arr[1] = 3;
        arr[2] = 4;
        arr[3] = 1;
        arr[4] = 2;
        arr.sort();
        assertTrue(arr.isSorted());
    }

    function testSortAddress() public {
        address[] memory arr = new address[](5);
        arr[0] = address(5);
        arr[1] = address(3);
        arr[2] = address(4);
        arr[3] = address(1);
        arr[4] = address(2);
        arr.sort();
        assertTrue(arr.isSorted());
    }

    function testUniquifySortedUint256() public {
        uint256[] memory arr = new uint256[](6);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 2;
        arr[3] = 3;
        arr[4] = 4;
        arr[5] = 4;
        arr.uniquifySorted();
        assertTrue(arr.isSortedAndUniquified());
    }

    function testUniquifySortedInt256() public {
        int256[] memory arr = new int256[](6);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 2;
        arr[3] = 3;
        arr[4] = 4;
        arr[5] = 4;
        arr.uniquifySorted();
        assertTrue(arr.isSortedAndUniquified());
    }

    function testUniquifySortedAddress() public {
        address[] memory arr = new address[](6);
        arr[0] = address(1);
        arr[1] = address(2);
        arr[2] = address(2);
        arr[3] = address(3);
        arr[4] = address(4);
        arr[5] = address(4);
        arr.uniquifySorted();
        assertTrue(arr.isSortedAndUniquified());
    }

    function testSearchSortedUint256() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        (bool found, uint256 index) = arr.searchSorted(3);
        assertTrue(found);
        assertEq(index, 2);
    }

    function testSearchSortedInt256() public {
        int256[] memory arr = new int256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        (bool found, uint256 index) = arr.searchSorted(3);
        assertTrue(found);
        assertEq(index, 2);
    }

    function testSearchSortedAddress() public {
        address[] memory arr = new address[](5);
        arr[0] = address(1);
        arr[1] = address(2);
        arr[2] = address(3);
        arr[3] = address(4);
        arr[4] = address(5);
        (bool found, uint256 index) = arr.searchSorted(address(3));
        assertTrue(found);
        assertEq(index, 2);
    }

    function testReverseUint256() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        arr.reverse();
        assertEq(arr[0], 5);
        assertEq(arr[1], 4);
        assertEq(arr[2], 3);
        assertEq(arr[3], 2);
        assertEq(arr[4], 1);
    }

    function testReverseInt256() public {
        int256[] memory arr = new int256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        arr.reverse();
        assertEq(arr[0], 5);
        assertEq(arr[1], 4);
        assertEq(arr[2], 3);
        assertEq(arr[3], 2);
        assertEq(arr[4], 1);
    }

    function testReverseAddress() public {
        address[] memory arr = new address[](5);
        arr[0] = address(1);
        arr[1] = address(2);
        arr[2] = address(3);
        arr[3] = address(4);
        arr[4] = address(5);
        arr.reverse();
        assertEq(arr[0], address(5));
        assertEq(arr[1], address(4));
        assertEq(arr[2], address(3));
        assertEq(arr[3], address(2));
        assertEq(arr[4], address(1));
    }

    function testCopyUint256() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        uint256[] memory copyArr = arr.copy();
        assertEq(copyArr[0], 1);
        assertEq(copyArr[1], 2);
        assertEq(copyArr[2], 3);
        assertEq(copyArr[3], 4);
        assertEq(copyArr[4], 5);
    }

    function testCopyInt256() public {
        int256[] memory arr = new int256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        int256[] memory copyArr = arr.copy();
        assertEq(copyArr[0], 1);
        assertEq(copyArr[1], 2);
        assertEq(copyArr[2], 3);
        assertEq(copyArr[3], 4);
        assertEq(copyArr[4], 5);
    }

    function testCopyAddress() public {
        address[] memory arr = new address[](5);
        arr[0] = address(1);
        arr[1] = address(2);
        arr[2] = address(3);
        arr[3] = address(4);
        arr[4] = address(5);
        address[] memory copyArr = arr.copy();
        assertEq(copyArr[0], address(1));
        assertEq(copyArr[1], address(2));
        assertEq(copyArr[2], address(3));
        assertEq(copyArr[3], address(4));
        assertEq(copyArr[4], address(5));
    }

    function testDifferenceUint256() public {
        uint256[] memory arr1 = new uint256[](5);
        arr1[0] = 1;
        arr1[1] = 2;
        arr1[2] = 3;
        arr1[3] = 4;
        arr1[4] = 5;
        uint256[] memory arr2 = new uint256[](3);
        arr2[0] = 2;
        arr2[1] = 4;
        arr2[2] = 5;
        uint256[] memory diff = arr1.difference(arr2);
        assertEq(diff.length, 2);
        assertEq(diff[0], 1);
        assertEq(diff[1], 3);
    }

    function testDifferenceInt256() public {
        int256[] memory arr1 = new int256[](5);
        arr1[0] = 1;
        arr1[1] = 2;
        arr1[2] = 3;
        arr1[3] = 4;
        arr1[4] = 5;
        int256[] memory arr2 = new int256[](3);
        arr2[0] = 2;
        arr2[1] = 4;
        arr2[2] = 5;
        int256[] memory diff = arr1.difference(arr2);
        assertEq(diff.length, 2);
        assertEq(diff[0], 1);
        assertEq(diff[1], 3);
    }

    function testDifferenceAddress() public {
        address[] memory arr1 = new address[](5);
        arr1[0] = address(1);
        arr1[1] = address(2);
        arr1[2] = address(3);
        arr1[3] = address(4);
        arr1[4] = address(5);
        address[] memory arr2 = new address[](3);
        arr2[0] = address(2);
        arr2[1] = address(4);
        arr2[2] = address(5);
        address[] memory diff = arr1.difference(arr2);
        assertEq(diff.length, 2);
        assertEq(diff[0], address(1));
        assertEq(diff[1], address(3));
    }

    function testIntersectionUint256() public {
        uint256[] memory arr1 = new uint256[](5);
        arr1[0] = 1;
        arr1[1] = 2;
        arr1[2] = 3;
        arr1[3] = 4;
        arr1[4] = 5;
        uint256[] memory arr2 = new uint256[](3);
        arr2[0] = 2;
        arr2[1] = 4;
        arr2[2] = 5;
        uint256[] memory inter = arr1.intersection(arr2);
        assertEq(inter.length, 3);
        assertEq(inter[0], 2);
        assertEq(inter[1], 4);
        assertEq(inter[2], 5);
    }

    function testIntersectionInt256() public {
        int256[] memory arr1 = new int256[](5);
        arr1[0] = 1;
        arr1[1] = 2;
        arr1[2] = 3;
        arr1[3] = 4;
        arr1[4] = 5;
        int256[] memory arr2 = new int256[](3);
        arr2[0] = 2;
        arr2[1] = 4;
        arr2[2] = 5;
        int256[] memory inter = arr1.intersection(arr2);
        assertEq(inter.length, 3);
        assertEq(inter[0], 2);
        assertEq(inter[1], 4);
        assertEq(inter[2], 5);
    }

    function testIntersectionAddress() public {
        address[] memory arr1 = new address[](5);
        arr1[0] = address(1);
        arr1[1] = address(2);
        arr1[2] = address(3);
        arr1[3] = address(4);
        arr1[4] = address(5);
        address[] memory arr2 = new address[](3);
        arr2[0] = address(2);
        arr2[1] = address(4);
        arr2[2] = address(5);
        address[] memory inter = arr1.intersection(arr2);
        assertEq(inter.length, 3);
        assertEq(inter[0], address(2));
        assertEq(inter[1], address(4));
        assertEq(inter[2], address(5));
    }

    function testUnionUint256() public {
        uint256[] memory arr1 = new uint256[](3);
        arr1[0] = 1;
        arr1[1] = 3;
        arr1[2] = 5;
        uint256[] memory arr2 = new uint256[](3);
        arr2[0] = 2;
        arr2[1] = 4;
        arr2[2] = 6;
        uint256[] memory unionArr = arr1.union(arr2);
        assertEq(unionArr.length, 6);
        assertEq(unionArr[0], 1);
        assertEq(unionArr[1], 2);
        assertEq(unionArr[2], 3);
        assertEq(unionArr[3], 4);
        assertEq(unionArr[4], 5);
        assertEq(unionArr[5], 6);
    }

    function testUnionInt256() public {
        int256[] memory arr1 = new int256[](3);
        arr1[0] = 1;
        arr1[1] = 3;
        arr1[2] = 5;
        int256[] memory arr2 = new int256[](3);
        arr2[0] = 2;
        arr2[1] = 4;
        arr2[2] = 6;
        int256[] memory unionArr = arr1.union(arr2);
        assertEq(unionArr.length, 6);
        assertEq(unionArr[0], 1);
        assertEq(unionArr[1], 2);
        assertEq(unionArr[2], 3);
        assertEq(unionArr[3], 4);
        assertEq(unionArr[4], 5);
        assertEq(unionArr[5], 6);
    }

    function testUnionAddress() public {
        address[] memory arr1 = new address[](3);
        arr1[0] = address(1);
        arr1[1] = address(3);
        arr1[2] = address(5);
        address[] memory arr2 = new address[](3);
        arr2[0] = address(2);
        arr2[1] = address(4);
        arr2[2] = address(6);
        address[] memory unionArr = arr1.union(arr2);
        assertEq(unionArr.length, 6);
        assertEq(unionArr[0], address(1));
        assertEq(unionArr[1], address(2));
        assertEq(unionArr[2], address(3));
        assertEq(unionArr[3], address(4));
        assertEq(unionArr[4], address(5));
        assertEq(unionArr[5], address(6));
    }
}