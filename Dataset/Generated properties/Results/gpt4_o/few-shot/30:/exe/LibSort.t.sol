//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/LibSort.sol";
//
//contract LibSortTest is Test {
//    using LibSort for *;
//
//    function testInsertionSortUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 5;
//        arr[1] = 3;
//        arr[2] = 4;
//        arr[3] = 1;
//        arr[4] = 2;
//        arr.insertionSort();
//        assertEq(arr[0], 1);
//        assertEq(arr[1], 2);
//        assertEq(arr[2], 3);
//        assertEq(arr[3], 4);
//        assertEq(arr[4], 5);
//    }
//
//    function testInsertionSortInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = 5;
//        arr[1] = -3;
//        arr[2] = 4;
//        arr[3] = 1;
//        arr[4] = -2;
//        arr.insertionSort();
//        assertEq(arr[0], -3);
//        assertEq(arr[1], -2);
//        assertEq(arr[2], 1);
//        assertEq(arr[3], 4);
//        assertEq(arr[4], 5);
//    }
//
//    function testInsertionSortAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x3);
//        arr[1] = address(0x1);
//        arr[2] = address(0x2);
//        arr.insertionSort();
//        assertEq(arr[0], address(0x1));
//        assertEq(arr[1], address(0x2));
//        assertEq(arr[2], address(0x3));
//    }
//
//    function testSortUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 5;
//        arr[1] = 3;
//        arr[2] = 4;
//        arr[3] = 1;
//        arr[4] = 2;
//        arr.sort();
//        assertEq(arr[0], 1);
//        assertEq(arr[1], 2);
//        assertEq(arr[2], 3);
//        assertEq(arr[3], 4);
//        assertEq(arr[4], 5);
//    }
//
//    function testSortInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = 5;
//        arr[1] = -3;
//        arr[2] = 4;
//        arr[3] = 1;
//        arr[4] = -2;
//        arr.sort();
//        assertEq(arr[0], -3);
//        assertEq(arr[1], -2);
//        assertEq(arr[2], 1);
//        assertEq(arr[3], 4);
//        assertEq(arr[4], 5);
//    }
//
//    function testSortAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x3);
//        arr[1] = address(0x1);
//        arr[2] = address(0x2);
//        arr.sort();
//        assertEq(arr[0], address(0x1));
//        assertEq(arr[1], address(0x2));
//        assertEq(arr[2], address(0x3));
//    }
//
//    function testUniquifySortedUint256() public {
//        uint256[] memory arr = new uint256[](6);
//        arr[0] = 1;
//        arr[1] = 2;
//        arr[2] = 2;
//        arr[3] = 3;
//        arr[4] = 4;
//        arr[5] = 4;
//        arr.uniquifySorted();
//        assertEq(arr.length, 4);
//        assertEq(arr[0], 1);
//        assertEq(arr[1], 2);
//        assertEq(arr[2], 3);
//        assertEq(arr[3], 4);
//    }
//
//    function testUniquifySortedInt256() public {
//        int256[] memory arr = new int256[](6);
//        arr[0] = -3;
//        arr[1] = -2;
//        arr[2] = -2;
//        arr[3] = 1;
//        arr[4] = 4;
//        arr[5] = 4;
//        arr.uniquifySorted();
//        assertEq(arr.length, 4);
//        assertEq(arr[0], -3);
//        assertEq(arr[1], -2);
//        assertEq(arr[2], 1);
//        assertEq(arr[3], 4);
//    }
//
//    function testUniquifySortedAddress() public {
//        address[] memory arr = new address[](4);
//        arr[0] = address(0x1);
//        arr[1] = address(0x2);
//        arr[2] = address(0x2);
//        arr[3] = address(0x3);
//        arr.uniquifySorted();
//        assertEq(arr.length, 3);
//        assertEq(arr[0], address(0x1));
//        assertEq(arr[1], address(0x2));
//        assertEq(arr[2], address(0x3));
//    }
//
//    function testSearchSortedUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 1;
//        arr[1] = 2;
//        arr[2] = 3;
//        arr[3] = 4;
//        arr[4] = 5;
//        (bool found, uint256 index) = arr.searchSorted(3);
//        assertTrue(found);
//        assertEq(index, 2);
//    }
//
//    function testSearchSortedInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = -3;
//        arr[1] = -2;
//        arr[2] = 1;
//        arr[3] = 4;
//        arr[4] = 5;
//        (bool found, uint256 index) = arr.searchSorted(1);
//        assertTrue(found);
//        assertEq(index, 2);
//    }
//
//    function testSearchSortedAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x1);
//        arr[1] = address(0x2);
//        arr[2] = address(0x3);
//        (bool found, uint256 index) = arr.searchSorted(address(0x2));
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testReverseUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 1;
//        arr[1] = 2;
//        arr[2] = 3;
//        arr[3] = 4;
//        arr[4] = 5;
//        arr.reverse();
//        assertEq(arr[0], 5);
//        assertEq(arr[1], 4);
//        assertEq(arr[2], 3);
//        assertEq(arr[3], 2);
//        assertEq(arr[4], 1);
//    }
//
//    function testReverseInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = -3;
//        arr[1] = -2;
//        arr[2] = 1;
//        arr[3] = 4;
//        arr[4] = 5;
//        arr.reverse();
//        assertEq(arr[0], 5);
//        assertEq(arr[1], 4);
//        assertEq(arr[2], 1);
//        assertEq(arr[3], -2);
//        assertEq(arr[4], -3);
//    }
//
//    function testReverseAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x1);
//        arr[1] = address(0x2);
//        arr[2] = address(0x3);
//        arr.reverse();
//        assertEq(arr[0], address(0x3));
//        assertEq(arr[1], address(0x2));
//        assertEq(arr[2], address(0x1));
//    }
//
//    function testCopyUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 1;
//        arr[1] = 2;
//        arr[2] = 3;
//        arr[3] = 4;
//        arr[4] = 5;
//        uint256[] memory copyArr = arr.copy();
//        assertEq(copyArr[0], 1);
//        assertEq(copyArr[1], 2);
//        assertEq(copyArr[2], 3);
//        assertEq(copyArr[3], 4);
//        assertEq(copyArr[4], 5);
//    }
//
//    function testCopyInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = -3;
//        arr[1] = -2;
//        arr[2] = 1;
//        arr[3] = 4;
//        arr[4] = 5;
//        int256[] memory copyArr = arr.copy();
//        assertEq(copyArr[0], -3);
//        assertEq(copyArr[1], -2);
//        assertEq(copyArr[2], 1);
//        assertEq(copyArr[3], 4);
//        assertEq(copyArr[4], 5);
//    }
//
//    function testCopyAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x1);
//        arr[1] = address(0x2);
//        arr[2] = address(0x3);
//        address[] memory copyArr = arr.copy();
//        assertEq(copyArr[0], address(0x1));
//        assertEq(copyArr[1], address(0x2));
//        assertEq(copyArr[2], address(0x3));
//    }
//
//    function testIsSortedUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 1;
//        arr[1] = 2;
//        arr[2] = 3;
//        arr[3] = 4;
//        arr[4] = 5;
//        assertTrue(arr.isSorted());
//    }
//
//    function testIsSortedInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = -3;
//        arr[1] = -2;
//        arr[2] = 1;
//        arr[3] = 4;
//        arr[4] = 5;
//        assertTrue(arr.isSorted());
//    }
//
//    function testIsSortedAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x1);
//        arr[1] = address(0x2);
//        arr[2] = address(0x3);
//        assertTrue(arr.isSorted());
//    }
//
//    function testIsSortedAndUniquifiedUint256() public {
//        uint256[] memory arr = new uint256[](5);
//        arr[0] = 1;
//        arr[1] = 2;
//        arr[2] = 3;
//        arr[3] = 4;
//        arr[4] = 5;
//        assertTrue(arr.isSortedAndUniquified());
//    }
//
//    function testIsSortedAndUniquifiedInt256() public {
//        int256[] memory arr = new int256[](5);
//        arr[0] = -3;
//        arr[1] = -2;
//        arr[2] = 1;
//        arr[3] = 4;
//        arr[4] = 5;
//        assertTrue(arr.isSortedAndUniquified());
//    }
//
//    function testIsSortedAndUniquifiedAddress() public {
//        address[] memory arr = new address[](3);
//        arr[0] = address(0x1);
//        arr[1] = address(0x2);
//        arr[2] = address(0x3);
//        assertTrue(arr.isSortedAndUniquified());
//    }
//
//    function testDifferenceUint256() public {
//        uint256[] memory a = new uint256[](5);
//        a[0] = 1;
//        a[1] = 2;
//        a[2] = 3;
//        a[3] = 4;
//        a[4] = 5;
//        uint256[] memory b = new uint256[](3);
//        b[0] = 2;
//        b[1] = 4;
//        b[2] = 5;
//        uint256[] memory c = a.difference(b);
//        assertEq(c.length, 2);
//        assertEq(c[0], 1);
//        assertEq(c[1], 3);
//    }
//
//    function testDifferenceInt256() public {
//        int256[] memory a = new int256[](5);
//        a[0] = -3;
//        a[1] = -2;
//        a[2] = 1;
//        a[3] = 4;
//        a[4] = 5;
//        int256[] memory b = new int256[](3);
//        b[0] = -2;
//        b[1] = 4;
//        b[2] = 5;
//        int256[] memory c = a.difference(b);
//        assertEq(c.length, 2);
//        assertEq(c[0], -3);
//        assertEq(c[1], 1);
//    }
//
//    function testDifferenceAddress() public {
//        address[] memory a = new address[](3);
//        a[0] = address(0x1);
//        a[1] = address(0x2);
//        a[2] = address(0x3);
//        address[] memory b = new address[](2);
//        b[0] = address(0x2);
//        b[1] = address(0x3);
//        address[] memory c = a.difference(b);
//        assertEq(c.length, 1);
//        assertEq(c[0], address(0x1));
//    }
//
//    function testIntersectionUint256() public {
//        uint256[] memory a = new uint256[](5);
//        a[0] = 1;
//        a[1] = 2;
//        a[2] = 3;
//        a[3] = 4;
//        a[4] = 5;
//        uint256[] memory b = new uint256[](3);
//        b[0] = 2;
//        b[1] = 4;
//        b[2] = 5;
//        uint256[] memory c = a.intersection(b);
//        assertEq(c.length, 3);
//        assertEq(c[0], 2);
//        assertEq(c[1], 4);
//        assertEq(c[2], 5);
//    }
//
//    function testIntersectionInt256() public {
//        int256[] memory a = new int256[](5);
//        a[0] = -3;
//        a[1] = -2;
//        a[2] = 1;
//        a[3] = 4;
//        a[4] = 5;
//        int256[] memory b = new int256[](3);
//        b[0] = -2;
//        b[1] = 4;
//        b[2] = 5;
//        int256[] memory c = a.intersection(b);
//        assertEq(c.length, 3);
//        assertEq(c[0], -2);
//        assertEq(c[1], 4);
//        assertEq(c[2], 5);
//    }
//
//    function testIntersectionAddress() public {
//        address[] memory a = new address[](3);
//        a[0] = address(0x1);
//        a[1] = address(0x2);
//        a[2] = address(0x3);
//        address[] memory b = new address[](2);
//        b[0] = address(0x2);
//        b[1] = address(0x3);
//        address[] memory c = a.intersection(b);
//        assertEq(c.length, 2);
//        assertEq(c[0], address(0x2));
//        assertEq(c[1], address(0x3));
//    }
//
//    function testUnionUint256() public {
//        uint256[] memory a = new uint256[](3);
//        a[0] = 1;
//        a[1] = 3;
//        a[2] = 5;
//        uint256[] memory b = new uint256[](3);
//        b[0] = 2;
//        b[1] = 4;
//        b[2] = 6;
//        uint256[] memory c = a.union(b);
//        assertEq(c.length, 6);
//        assertEq(c[0], 1);
//        assertEq(c[1], 2);
//        assertEq(c[2], 3);
//        assertEq(c[3], 4);
//        assertEq(c[4], 5);
//        assertEq(c[5], 6);
//    }
//
//    function testUnionInt256() public {
//        int256[] memory a = new int256[](3);
//        a[0] = -3;
//        a[1] = 1;
//        a[2] = 5;
//        int256[] memory b = new int256[](3);
//        b[0] = -2;
//        b[1] = 4;
//        b[2] = 6;
//        int256[] memory c = a.union(b);
//        assertEq(c.length, 6);
//        assertEq(c[0], -3);
//        assertEq(c[1], -2);
//        assertEq(c[2], 1);
//        assertEq(c[3], 4);
//        assertEq(c[4], 5);
//        assertEq(c[5], 6);
//    }
//
//    function testUnionAddress() public {
//        address[] memory a = new address[](2);
//        a[0] = address(0x1);
//        a[1] = address(0x3);
//        address[] memory b = new address[](2);
//        b[0] = address(0x2);
//        b[1] = address(0x4);
//        address[] memory c = a.union(b);
//        assertEq(c.length, 4);
//        assertEq(c[0], address(0x1));
//        assertEq(c[1], address(0x2));
//        assertEq(c[2], address(0x3));
//        assertEq(c[3], address(0x4));
//    }
//}