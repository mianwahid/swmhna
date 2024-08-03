//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/LibSort.sol";
//contract LibSortTest is Test {
//    using LibSort for *;
//
//    function testInsertionSortUint(uint256[] memory a) public {
//        uint256[] memory b = a.copy();
//        a.insertionSort();
//        b.sort();
//        assertEq(a, b);
//    }
//
//    function testInsertionSortInt(int256[] memory a) public {
//        int256[] memory b = a.copy();
//        a.insertionSort();
//        b.sort();
//        assertEq(a, b);
//    }
//
//    function testInsertionSortAddress(address[] memory a) public {
//        address[] memory b = a.copy();
//        a.insertionSort();
//        b.sort();
//        assertEq(a, b);
//    }
//
//    function testSortUint(uint256[] memory a) public {
//        uint256[] memory b = a.copy();
//        a.sort();
//        b.sort();
//        assertEq(a, b);
//    }
//
//    function testSortInt(int256[] memory a) public {
//        int256[] memory b = a.copy();
//        a.sort();
//        b.sort();
//        assertEq(a, b);
//    }
//
//    function testSortAddress(address[] memory a) public {
//        address[] memory b = a.copy();
//        a.sort();
//        b.sort();
//        assertEq(a, b);
//    }
//
//    function testUniquifySortedUint(uint256[] memory a) public {
//        a.sort();
//        uint256 originalLength = a.length;
//        a.uniquifySorted();
//        uint256 newLength = a.length;
//        assertGe(originalLength, newLength);
//        assertTrue(a.isSortedAndUniquified());
//    }
//
//    function testUniquifySortedInt(int256[] memory a) public {
//        a.sort();
//        uint256 originalLength = a.length;
//        a.uniquifySorted();
//        uint256 newLength = a.length;
//        assertGe(originalLength, newLength);
//        assertTrue(a.isSortedAndUniquified());
//    }
//
//    function testUniquifySortedAddress(address[] memory a) public {
//        a.sort();
//        uint256 originalLength = a.length;
//        a.uniquifySorted();
//        uint256 newLength = a.length;
//        assertGe(originalLength, newLength);
//        assertTrue(a.isSortedAndUniquified());
//    }
//
////    function testSearchSortedUint(uint256[] memory a, uint256 needle) public {
////        a.sort();
////        (bool found, uint256 index) = a.searchSorted(needle);
////        if (found) {
////            assertEq(a[index], needle);
////        } else {
////            if (a.length == 0) {
////                assertEq(index, 0);
////            } else if (needle < a[0]) {
////                assertEq(index, 0);
////            } else if (needle > a[a.length - 1]) {
////                assertEq(index, 0);
////            } else {
////                assertLt(a[index], needle);
////                assertGt(a[index + 1], needle);
////            }
////        }
////    }
//
////    function testSearchSortedInt(int256[] memory a, int256 needle) public {
////        a.sort();
////        (bool found, uint256 index) = a.searchSorted(needle);
////        if (found) {
////            assertEq(a[index], needle);
////        } else {
////            if (a.length == 0) {
////                assertEq(index, 0);
////            } else if (needle < a[0]) {
////                assertEq(index, 0);
////            } else if (needle > a[a.length - 1]) {
////                assertEq(index, a.length);
////            } else {
////                assertTrue(a[index]< needle);
////                assertTrue(a[index + 1]> needle);
////            }
////        }
////    }
//
////    function testSearchSortedAddress(address[] memory a, address needle) public {
////        a.sort();
////        (bool found, uint256 index) = a.searchSorted(needle);
////        if (found) {
////            assertEq(a[index], needle);
////        } else {
////            if (a.length == 0) {
////                assertEq(index, 0);
////            } else if (needle < a[0]) {
////                assertEq(index, 0);
////            } else if (needle > a[a.length - 1]) {
////                assertEq(index, a.length);
////            } else {
////                assertTrue(a[index]< needle);
////                assertTrue(a[index + 1]>needle);
////            }
////        }
////    }
//
//    function testReverseUint(uint256[] memory a) public {
//        uint256 n = a.length;
//        uint256[] memory original = new uint256[](a.length);
//        for (uint256 i = 0; i < a.length; ++i) {
//        original[i] = a[i];
//        }
//        a.reverse();
//        for (uint256 i; i < n / 2; ++i) {
//            uint256 j = n - i - 1;
//            (original[i], original[j]) = (original[j], original[i]);
//        }
//        for (uint256 i = 0; i < a.length; ++i) {
//        assertEq(original[i] , a[i]);
//        }
//    }
//
//    function testReverseInt(int256[] memory a) public {
//        uint256 n = a.length;
//        int256[] memory original = new int256[](a.length);
//        for (uint256 i = 0; i < a.length; ++i) {
//        original[i] = a[i];
//        }
//        a.reverse();
//        for (uint256 i; i < n / 2; ++i) {
//            uint256 j = n - i - 1;
//            (original[i], original[j]) = (original[j], original[i]);
//        }
//        for (uint256 i = 0; i < a.length; ++i) {
//        assertEq(original[i] , a[i]);
//        }
//    }
//
//    function testReverseAddress(address[] memory a) public {
//        uint256 n = a.length;
//        address[] memory original = new address[](a.length);
//        for (uint256 i = 0; i < a.length; ++i) {
//        original[i] = a[i];
//        }
//        a.reverse();
//        for (uint256 i; i < n / 2; ++i) {
//            uint256 j = n - i - 1;
//            (original[i], original[j]) = (original[j], original[i]);
//        }
//        for (uint256 i = 0; i < a.length; ++i) {
//        assertEq(original[i] , a[i]);
//        }
//    }
//
//    function testIsSortedUint(uint256[] memory a) public {
//        bool isSorted = a.isSorted();
//        a.sort();
//        assertTrue(a.isSorted());
//    }
//
//    function testIsSortedInt(int256[] memory a) public {
//        bool isSorted = a.isSorted();
//        a.sort();
//        assertTrue(a.isSorted());
//    }
//
//    function testIsSortedAddress(address[] memory a) public {
//        bool isSorted = a.isSorted();
//        a.sort();
//        assertTrue(a.isSorted());
//    }
//
//    function testIsSortedAndUniquifiedUint(uint256[] memory a) public {
//        a.sort();
//        bool isSortedAndUniquified = a.isSortedAndUniquified();
//        a.uniquifySorted();
//        assertTrue(a.isSortedAndUniquified());
//    }
//
//    function testIsSortedAndUniquifiedInt(int256[] memory a) public {
//        a.sort();
//        bool isSortedAndUniquified = a.isSortedAndUniquified();
//        a.uniquifySorted();
//        assertTrue(a.isSortedAndUniquified());
//    }
//
//    function testIsSortedAndUniquifiedAddress(address[] memory a) public {
//        a.sort();
//        bool isSortedAndUniquified = a.isSortedAndUniquified();
//        a.uniquifySorted();
//        assertTrue(a.isSortedAndUniquified());
//    }
//
//    function testDifferenceUint(uint256[] memory a, uint256[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        uint256[] memory c = a.difference(b);
//        assertTrue(c.isSortedAndUniquified());
//        for (uint256 i; i < c.length; ++i) {
//            (bool found,) = b.searchSorted(c[i]);
//            assertFalse(found);
//        }
//    }
//
//    function testDifferenceInt(int256[] memory a, int256[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        int256[] memory c = a.difference(b);
//        assertTrue(c.isSortedAndUniquified());
//        for (uint256 i; i < c.length; ++i) {
//            (bool found,) = b.searchSorted(c[i]);
//            assertFalse(found);
//        }
//    }
//
//    function testDifferenceAddress(address[] memory a, address[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        address[] memory c = a.difference(b);
//        assertTrue(c.isSortedAndUniquified());
//        for (uint256 i; i < c.length; ++i) {
//            (bool found,) = b.searchSorted(c[i]);
//            assertFalse(found);
//        }
//    }
//
//    function testIntersectionUint(uint256[] memory a, uint256[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        uint256[] memory c = a.intersection(b);
//        assertTrue(c.isSortedAndUniquified());
//        for (uint256 i; i < c.length; ++i) {
//            (bool foundA,) = a.searchSorted(c[i]);
//            (bool foundB,) = b.searchSorted(c[i]);
//            assertTrue(foundA);
//            assertTrue(foundB);
//        }
//    }
//
//    function testIntersectionInt(int256[] memory a, int256[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        int256[] memory c = a.intersection(b);
//        assertTrue(c.isSortedAndUniquified());
//        for (uint256 i; i < c.length; ++i) {
//            (bool foundA,) = a.searchSorted(c[i]);
//            (bool foundB,) = b.searchSorted(c[i]);
//            assertTrue(foundA);
//            assertTrue(foundB);
//        }
//    }
//
//    function testIntersectionAddress(address[] memory a, address[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        address[] memory c = a.intersection(b);
//        assertTrue(c.isSortedAndUniquified());
//        for (uint256 i; i < c.length; ++i) {
//            (bool foundA,) = a.searchSorted(c[i]);
//            (bool foundB,) = b.searchSorted(c[i]);
//            assertTrue(foundA);
//            assertTrue(foundB);
//        }
//    }
//
//    function testUnionUint(uint256[] memory a, uint256[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        uint256[] memory c = a.union(b);
//        assertTrue(c.isSortedAndUniquified());
//        uint256 i;
//        uint256 j;
//        uint256 k;
//        while (i < a.length || j < b.length) {
//            if (i == a.length) {
//                assertEq(c[k++], b[j++]);
//            } else if (j == b.length) {
//                assertEq(c[k++], a[i++]);
//            } else if (a[i] < b[j]) {
//                assertEq(c[k++], a[i++]);
//            } else if (a[i] > b[j]) {
//                assertEq(c[k++], b[j++]);
//            } else {
//                assertEq(c[k++], a[i++]);
//                ++j;
//            }
//        }
//        assertEq(c.length, k);
//    }
//
//    function testUnionInt(int256[] memory a, int256[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        int256[] memory c = a.union(b);
//        assertTrue(c.isSortedAndUniquified());
//        uint256 i;
//        uint256 j;
//        uint256 k;
//        while (i < a.length || j < b.length) {
//            if (i == a.length) {
//                assertEq(c[k++], b[j++]);
//            } else if (j == b.length) {
//                assertEq(c[k++], a[i++]);
//            } else if (a[i] < b[j]) {
//                assertEq(c[k++], a[i++]);
//            } else if (a[i] > b[j]) {
//                assertEq(c[k++], b[j++]);
//            } else {
//                assertEq(c[k++], a[i++]);
//                ++j;
//            }
//        }
//        assertEq(c.length, k);
//    }
//
//    function testUnionAddress(address[] memory a, address[] memory b) public {
//        a.sort();
//        a.uniquifySorted();
//        b.sort();
//        b.uniquifySorted();
//        address[] memory c = a.union(b);
//        assertTrue(c.isSortedAndUniquified());
//        uint256 i;
//        uint256 j;
//        uint256 k;
//        while (i < a.length || j < b.length) {
//            if (i == a.length) {
//                assertEq(c[k++], b[j++]);
//            } else if (j == b.length) {
//                assertEq(c[k++], a[i++]);
//            } else if (a[i] < b[j]) {
//                assertEq(c[k++], a[i++]);
//            } else if (a[i] > b[j]) {
//                assertEq(c[k++], b[j++]);
//            } else {
//                assertEq(c[k++], a[i++]);
//                ++j;
//            }
//        }
//        assertEq(c.length, k);
//    }
//
//    function testFuzzUint(uint256[] memory a) public {
//        testInsertionSortUint(a);
//        testSortUint(a);
//        testUniquifySortedUint(a);
//        testReverseUint(a);
//        testIsSortedUint(a);
//        testIsSortedAndUniquifiedUint(a);
//    }
//
//    function testFuzzInt(int256[] memory a) public {
//        testInsertionSortInt(a);
//        testSortInt(a);
//        testUniquifySortedInt(a);
//        testReverseInt(a);
//        testIsSortedInt(a);
//        testIsSortedAndUniquifiedInt(a);
//    }
//
//    function testFuzzAddress(address[] memory a) public {
//        testInsertionSortAddress(a);
//        testSortAddress(a);
//        testUniquifySortedAddress(a);
//        testReverseAddress(a);
//        testIsSortedAddress(a);
//        testIsSortedAndUniquifiedAddress(a);
//    }
//}
