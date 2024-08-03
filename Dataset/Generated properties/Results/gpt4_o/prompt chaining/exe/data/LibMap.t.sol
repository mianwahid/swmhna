// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibMap.sol";

contract LibMapTest is Test {
    using LibMap for LibMap.Uint8Map;
    using LibMap for LibMap.Uint16Map;
    using LibMap for LibMap.Uint32Map;
    using LibMap for LibMap.Uint40Map;
    using LibMap for LibMap.Uint64Map;
    using LibMap for LibMap.Uint128Map;

    LibMap.Uint8Map private uint8Map;
    LibMap.Uint16Map private uint16Map;
    LibMap.Uint32Map private uint32Map;
    LibMap.Uint40Map private uint40Map;
    LibMap.Uint64Map private uint64Map;
    LibMap.Uint128Map private uint128Map;

    // General Invariants
    function testInitialStateInvariant() public {
        assertEq(uint8Map.get(0), 0);
        assertEq(uint16Map.get(0), 0);
        assertEq(uint32Map.get(0), 0);
        assertEq(uint40Map.get(0), 0);
        assertEq(uint64Map.get(0), 0);
        assertEq(uint128Map.get(0), 0);
    }

    // Uint8Map Invariants
    function testUint8MapGetSetInvariant() public {
        uint8Map.set(0, 255);
        assertEq(uint8Map.get(0), 255);
        uint8Map.set(0, 0);
        assertEq(uint8Map.get(0), 0);
    }

    function testUint8MapOverwriteInvariant() public {
        uint8Map.set(0, 100);
        uint8Map.set(0, 200);
        assertEq(uint8Map.get(0), 200);
    }

    function testUint8MapBoundaryInvariant() public {
        uint8Map.set(0, 123);
        assertEq(uint8Map.get(0), 123);
        uint8Map.set(31, 234);
        assertEq(uint8Map.get(31), 234);
        uint8Map.set(32, 111);
        assertEq(uint8Map.get(32), 111);
        uint8Map.set(63, 222);
        assertEq(uint8Map.get(63), 222);
    }

    // Uint16Map Invariants
    function testUint16MapGetSetInvariant() public {
        uint16Map.set(0, 65535);
        assertEq(uint16Map.get(0), 65535);
        uint16Map.set(0, 0);
        assertEq(uint16Map.get(0), 0);
    }

    function testUint16MapOverwriteInvariant() public {
        uint16Map.set(0, 10000);
        uint16Map.set(0, 20000);
        assertEq(uint16Map.get(0), 20000);
    }

    function testUint16MapBoundaryInvariant() public {
        uint16Map.set(0, 12345);
        assertEq(uint16Map.get(0), 12345);
        uint16Map.set(15, 23456);
        assertEq(uint16Map.get(15), 23456);
        uint16Map.set(16, 11111);
        assertEq(uint16Map.get(16), 11111);
        uint16Map.set(31, 22222);
        assertEq(uint16Map.get(31), 22222);
    }

    // Uint32Map Invariants
    function testUint32MapGetSetInvariant() public {
        uint32Map.set(0, 4294967295);
        assertEq(uint32Map.get(0), 4294967295);
        uint32Map.set(0, 0);
        assertEq(uint32Map.get(0), 0);
    }

    function testUint32MapOverwriteInvariant() public {
        uint32Map.set(0, 1000000000);
        uint32Map.set(0, 2000000000);
        assertEq(uint32Map.get(0), 2000000000);
    }

    function testUint32MapBoundaryInvariant() public {
        uint32Map.set(0, 1234567890);
        assertEq(uint32Map.get(0), 1234567890);
        uint32Map.set(7, 2345678901);
        assertEq(uint32Map.get(7), 2345678901);
        uint32Map.set(8, 1111111111);
        assertEq(uint32Map.get(8), 1111111111);
        uint32Map.set(15, 2222222222);
        assertEq(uint32Map.get(15), 2222222222);
    }

    // Uint40Map Invariants
    function testUint40MapGetSetInvariant() public {
        uint40Map.set(0, 1099511627775);
        assertEq(uint40Map.get(0), 1099511627775);
        uint40Map.set(0, 0);
        assertEq(uint40Map.get(0), 0);
    }

    function testUint40MapOverwriteInvariant() public {
        uint40Map.set(0, 100000000000);
        uint40Map.set(0, 200000000000);
        assertEq(uint40Map.get(0), 200000000000);
    }

    function testUint40MapBoundaryInvariant() public {
        uint40Map.set(0, 123456789012);
        assertEq(uint40Map.get(0), 123456789012);
        uint40Map.set(5, 234567890123);
        assertEq(uint40Map.get(5), 234567890123);
        uint40Map.set(6, 111111111111);
        assertEq(uint40Map.get(6), 111111111111);
        uint40Map.set(11, 222222222222);
        assertEq(uint40Map.get(11), 222222222222);
    }

    // Uint64Map Invariants
    function testUint64MapGetSetInvariant() public {
        uint64Map.set(0, 18446744073709551615);
        assertEq(uint64Map.get(0), 18446744073709551615);
        uint64Map.set(0, 0);
        assertEq(uint64Map.get(0), 0);
    }

    function testUint64MapOverwriteInvariant() public {
        uint64Map.set(0, 1000000000000000000);
        uint64Map.set(0, 2000000000000000000);
        assertEq(uint64Map.get(0), 2000000000000000000);
    }

    function testUint64MapBoundaryInvariant() public {
        uint64Map.set(0, 1234567890123456789);
        assertEq(uint64Map.get(0), 1234567890123456789);
        uint64Map.set(3, 2345678901234567890);
        assertEq(uint64Map.get(3), 2345678901234567890);
        uint64Map.set(4, 1111111111111111111);
        assertEq(uint64Map.get(4), 1111111111111111111);
        uint64Map.set(7, 2222222222222222222);
        assertEq(uint64Map.get(7), 2222222222222222222);
    }

    // Uint128Map Invariants
    function testUint128MapGetSetInvariant() public {
        uint128Map.set(0, 340282366920938463463374607431768211455);
        assertEq(uint128Map.get(0), 340282366920938463463374607431768211455);
        uint128Map.set(0, 0);
        assertEq(uint128Map.get(0), 0);
    }

    function testUint128MapOverwriteInvariant() public {
        uint128Map.set(0, 100000000000000000000000000000000000000);
        uint128Map.set(0, 200000000000000000000000000000000000000);
        assertEq(uint128Map.get(0), 200000000000000000000000000000000000000);
    }

    function testUint128MapBoundaryInvariant() public {
        uint128Map.set(0, 123456789012345678901234567890123456789);
        assertEq(uint128Map.get(0), 123456789012345678901234567890123456789);
        uint128Map.set(1, 234567890123456789012345678901234567890);
        assertEq(uint128Map.get(1), 234567890123456789012345678901234567890);
        uint128Map.set(2, 111111111111111111111111111111111111111);
        assertEq(uint128Map.get(2), 111111111111111111111111111111111111111);
        uint128Map.set(3, 222222222222222222222222222222222222222);
        assertEq(uint128Map.get(3), 222222222222222222222222222222222222222);
    }

    // Generic Mapping Invariants
//    function testGenericGetSetInvariant() public {
//        mapping(uint256 => uint256) storage map;
//        LibMap.set(map, 0, 255, 8);
//        assertEq(LibMap.get(map, 0, 8), 255);
//        LibMap.set(map, 0, 0, 8);
//        assertEq(LibMap.get(map, 0, 8), 0);
//    }
//
//    function testGenericOverwriteInvariant() public {
//        mapping(uint256 => uint256) storage map;
//        LibMap.set(map, 0, 100, 8);
//        LibMap.set(map, 0, 200, 8);
//        assertEq(LibMap.get(map, 0, 8), 200);
//    }
//
//    function testGenericBoundaryInvariant() public {
//        mapping(uint256 => uint256) storage map;
//        LibMap.set(map, 0, 123, 8);
//        assertEq(LibMap.get(map, 0, 8), 123);
//        LibMap.set(map, 31, 234, 8);
//        assertEq(LibMap.get(map, 31, 8), 234);
//        LibMap.set(map, 32, 111, 8);
//        assertEq(LibMap.get(map, 32, 8), 111);
//        LibMap.set(map, 63, 222, 8);
//        assertEq(LibMap.get(map, 63, 8), 222);
//    }

    // Binary Search Invariants
    function testBinarySearchExistenceInvariant() public {
        uint8Map.set(0, 1);
        uint8Map.set(1, 2);
        uint8Map.set(2, 3);
        (bool found, uint256 index) = uint8Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    function testBinarySearchNonExistenceInvariant() public {
        uint8Map.set(0, 1);
        uint8Map.set(1, 2);
        uint8Map.set(2, 3);
        (bool found, uint256 index) = uint8Map.searchSorted(4, 0, 3);
        assertFalse(found);
        assertEq(index, 2);
    }

    function testBinarySearchBoundaryInvariant() public {
        uint8Map.set(0, 1);
        uint8Map.set(1, 2);
        uint8Map.set(2, 3);
        (bool found, uint256 index) = uint8Map.searchSorted(1, 0, 3);
        assertTrue(found);
        assertEq(index, 0);
    }

    function testBinarySearchEmptyRangeInvariant() public {
        (bool found, uint256 index) = uint8Map.searchSorted(1, 0, 0);
        assertFalse(found);
        assertEq(index, 0);
    }
}