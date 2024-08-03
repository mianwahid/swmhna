// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibSort.sol";
contract LibSortTest is Test {

    function testInsertionSortUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 4;
        a[1] = 2;
        a[2] = 5;
        a[3] = 1;
        a[4] = 3;
        LibSort.insertionSort(a);
        assert(LibSort.isSorted(a));
    }

    function testInsertionSortInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = 4;
        a[1] = -2;
        a[2] = 5;
        a[3] = -1;
        a[4] = 3;
        LibSort.insertionSort(a);
        assert(LibSort.isSorted(a));
    }

    function testInsertionSortAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x4);
        a[1] = address(0x2);
        a[2] = address(0x5);
        a[3] = address(0x1);
        a[4] = address(0x3);
        LibSort.insertionSort(a);
        assert(LibSort.isSorted(a));
    }

    function testSortUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 4;
        a[1] = 2;
        a[2] = 5;
        a[3] = 1;
        a[4] = 3;
        LibSort.sort(a);
        assert(LibSort.isSorted(a));
    }

    function testSortInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = 4;
        a[1] = -2;
        a[2] = 5;
        a[3] = -1;
        a[4] = 3;
        LibSort.sort(a);
        assert(LibSort.isSorted(a));
    }

    function testSortAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x4);
        a[1] = address(0x2);
        a[2] = address(0x5);
        a[3] = address(0x1);
        a[4] = address(0x3);
        LibSort.sort(a);
        assert(LibSort.isSorted(a));
    }

    function testUniquifySortedUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 2;
        a[3] = 3;
        a[4] = 4;
        LibSort.uniquifySorted(a);
        assertEq(a[0], 1);
        assertEq(a[1], 2);
        assertEq(a[2], 3);
        assertEq(a[3], 4);
        assertEq(a.length, 4);
    }

    function testUniquifySortedInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -2;
        a[2] = 1;
        a[3] = 3;
        a[4] = 3;
        LibSort.uniquifySorted(a);
        assertEq(a[0], -2);
        assertEq(a[1], 1);
        assertEq(a[2], 3);
        assertEq(a.length, 3);
    }

    function testUniquifySortedAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x2);
        a[3] = address(0x3);
        a[4] = address(0x4);
        LibSort.uniquifySorted(a);
        assertEq(a[0], address(0x1));
        assertEq(a[1], address(0x2));
        assertEq(a[2], address(0x3));
        assertEq(a[3], address(0x4));
        assertEq(a.length, 4);
    }

    function testSearchSortedUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        (bool found, uint256 index) = LibSort.searchSorted(a, 3);
        assert(found);
        assertEq(index, 2);
    }

    function testSearchSortedInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        (bool found, uint256 index) = LibSort.searchSorted(a, 3);
        assert(found);
        assertEq(index, 3);
    }

    function testSearchSortedAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        (bool found, uint256 index) = LibSort.searchSorted(a, address(0x3));
        assert(found);
        assertEq(index, 2);
    }

    function testReverseUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        LibSort.reverse(a);
        assertEq(a[0], 5);
        assertEq(a[1], 4);
        assertEq(a[2], 3);
        assertEq(a[3], 2);
        assertEq(a[4], 1);
    }

    function testReverseInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        LibSort.reverse(a);
        assertEq(a[0], 4);
        assertEq(a[1], 3);
        assertEq(a[2], 1);
        assertEq(a[3], -1);
        assertEq(a[4], -2);
    }

    function testReverseAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        LibSort.reverse(a);
        assertEq(a[0], address(0x5));
        assertEq(a[1], address(0x4));
        assertEq(a[2], address(0x3));
        assertEq(a[3], address(0x2));
        assertEq(a[4], address(0x1));
    }

    function testCopyUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = LibSort.copy(a);
        assertEq(a[0], b[0]);
        assertEq(a[1], b[1]);
        assertEq(a[2], b[2]);
        assertEq(a[3], b[3]);
        assertEq(a[4], b[4]);
    }

    function testCopyInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        int256[] memory b = LibSort.copy(a);
        assertEq(a[0], b[0]);
        assertEq(a[1], b[1]);
        assertEq(a[2], b[2]);
        assertEq(a[3], b[3]);
        assertEq(a[4], b[4]);
    }

    function testCopyAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        address[] memory b = LibSort.copy(a);
        assertEq(a[0], b[0]);
        assertEq(a[1], b[1]);
        assertEq(a[2], b[2]);
        assertEq(a[3], b[3]);
        assertEq(a[4], b[4]);
    }

    function testIsSortedUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        assert(LibSort.isSorted(a));
    }

    function testIsSortedInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        assert(LibSort.isSorted(a));
    }

    function testIsSortedAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        assert(LibSort.isSorted(a));
    }

    function testIsSortedAndUniquifiedUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        assert(LibSort.isSortedAndUniquified(a));
    }

    function testIsSortedAndUniquifiedInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        assert(LibSort.isSortedAndUniquified(a));
    }

    function testIsSortedAndUniquifiedAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        assert(LibSort.isSortedAndUniquified(a));
    }

    function testDifferenceUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = new uint256[](3);
        b[0] = 2;
        b[1] = 3;
        b[2] = 4;
        uint256[] memory c = LibSort.difference(a, b);
        assertEq(c.length, 2);
        assertEq(c[0], 1);
        assertEq(c[1], 5);
    }

    function testDifferenceInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        int256[] memory b = new int256[](3);
        b[0] = -1;
        b[1] = 1;
        b[2] = 4;
        int256[] memory c = LibSort.difference(a, b);
        assertEq(c.length, 2);
        assertEq(c[0], -2);
        assertEq(c[1], 3);
    }

    function testDifferenceAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        address[] memory b = new address[](3);
        b[0] = address(0x2);
        b[1] = address(0x3);
        b[2] = address(0x4);
        address[] memory c = LibSort.difference(a, b);
        assertEq(c.length, 2);
        assertEq(c[0], address(0x1));
        assertEq(c[1], address(0x5));
    }

    function testIntersectionUint256() public {
        uint256[] memory a = new uint256[](5);
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;
        uint256[] memory b = new uint256[](3);
        b[0] = 2;
        b[1] = 3;
        b[2] = 4;
        uint256[] memory c = LibSort.intersection(a, b);
        assertEq(c.length, 3);
        assertEq(c[0], 2);
        assertEq(c[1], 3);
        assertEq(c[2], 4);
    }

    function testIntersectionInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        int256[] memory b = new int256[](3);
        b[0] = -1;
        b[1] = 1;
        b[2] = 4;
        int256[] memory c = LibSort.intersection(a, b);
        assertEq(c.length, 3);
        assertEq(c[0], -1);
        assertEq(c[1], 1);
        assertEq(c[2], 4);
    }

    function testIntersectionAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        address[] memory b = new address[](3);
        b[0] = address(0x2);
        b[1] = address(0x3);
        b[2] = address(0x4);
        address[] memory c = LibSort.intersection(a, b);
        assertEq(c.length, 3);
        assertEq(c[0], address(0x2));
        assertEq(c[1], address(0x3));
        assertEq(c[2], address(0x4));
    }

    function testUnionUint256() public {
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

    function testUnionInt256() public {
        int256[] memory a = new int256[](5);
        a[0] = -2;
        a[1] = -1;
        a[2] = 1;
        a[3] = 3;
        a[4] = 4;
        int256[] memory b = new int256[](3);
        b[0] = -1;
        b[1] = 1;
        b[2] = 5;
        int256[] memory c = LibSort.union(a, b);
        assertEq(c.length, 6);
        assertEq(c[0], -2);
        assertEq(c[1], -1);
        assertEq(c[2], 1);
        assertEq(c[3], 3);
        assertEq(c[4], 4);
        assertEq(c[5], 5);
    }

    function testUnionAddress() public {
        address[] memory a = new address[](5);
        a[0] = address(0x1);
        a[1] = address(0x2);
        a[2] = address(0x3);
        a[3] = address(0x4);
        a[4] = address(0x5);
        address[] memory b = new address[](3);
        b[0] = address(0x2);
        b[1] = address(0x4);
        b[2] = address(0x6);
        address[] memory c = LibSort.union(a, b);
        assertEq(c.length, 6);
        assertEq(c[0], address(0x1));
        assertEq(c[1], address(0x2));
        assertEq(c[2], address(0x3));
        assertEq(c[3], address(0x4));
        assertEq(c[4], address(0x5));
        assertEq(c[5], address(0x6));
    }

    function testFuzzInsertionSortUint256(uint256[] memory a) public {
        vm.assume(a.length < 100);
        LibSort.insertionSort(a);
        assert(LibSort.isSorted(a));
    }

    function testFuzzSortUint256(uint256[] memory a) public {
        vm.assume(a.length < 100);
        LibSort.sort(a);
        assert(LibSort.isSorted(a));
    }

    function testFuzzUniquifySortedUint256(uint256[] memory a) public {
        vm.assume(a.length < 100);
        LibSort.sort(a);
        uint256 originalLength = a.length;
        LibSort.uniquifySorted(a);
        assert(a.length <= originalLength);
        assert(LibSort.isSortedAndUniquified(a));
    }

    function testFuzzSearchSortedUint256(uint256[] memory a, uint256 needle) public {
        vm.assume(a.length < 100);
        LibSort.sort(a);
        (bool found, uint256 index) = LibSort.searchSorted(a, needle);
        if (found) {
            assert(a[index] == needle);
        } else {
            for (uint256 i = 0; i < a.length; i++) {
                assert(a[i] != needle);
            }
        }
    }

//    function testFuzzDifferenceUint256(uint256[] memory a, uint256[] memory b) public {
//        vm.assume(a.length < 100 && b.length < 100);
//        LibSort.sort(a);
//        LibSort.sort(b);
//        uint256[] memory c = LibSort.difference(a, b);
//        assert(LibSort.isSortedAndUniquified(c));
//        for (uint256 i = 0; i < c.length; i++) {
//            assert(!contains(b, c[i]));
//        }
//    }

//    function testFuzzIntersectionUint256(uint256[] memory a, uint256[] memory b) public {
//        vm.assume(a.length < 100 && b.length < 100);
//        LibSort.sort(a);
//        LibSort.sort(b);
//        uint256[] memory c = LibSort.intersection(a, b);
//        assert(LibSort.isSortedAndUniquified(c));
//        for (uint256 i = 0; i < c.length; i++) {
//            assert(contains(a, c[i]));
//            assert(contains(b, c[i]));
//        }
//    }

//    function testFuzzUnionUint256(uint256[] memory a, uint256[] memory b) public {
//        vm.assume(a.length < 100 && b.length < 100);
//        LibSort.sort(a);
//        LibSort.sort(b);
//        uint256[] memory c = LibSort.union(a, b);
//        assert(LibSort.isSortedAndUniquified(c));
//        for (uint256 i = 0; i < a.length; i++) {
//            assert(contains(c, a[i]));
//        }
//        for (uint256 i = 0; i < b.length; i++) {
//            assert(contains(c, b[i]));
//        }
//    }

    function contains(uint256[] memory arr, uint256 value) private pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return true;
            }
        }
        return false;
    }

    function contains(int256[] memory arr, int256 value) private pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return true;
            }
        }
        return false;
    }

    function contains(address[] memory arr, address value) private pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return true;
            }
        }
        return false;
    }
}
