//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/LibMap.sol";
//
//contract LibMapTest is Test {
//    using LibMap for LibMap.Uint8Map;
//    using LibMap for LibMap.Uint16Map;
//    using LibMap for LibMap.Uint32Map;
//    using LibMap for LibMap.Uint40Map;
//    using LibMap for LibMap.Uint64Map;
//    using LibMap for LibMap.Uint128Map;
//
//    LibMap.Uint8Map private uint8Map;
//    LibMap.Uint16Map private uint16Map;
//    LibMap.Uint32Map private uint32Map;
//    LibMap.Uint40Map private uint40Map;
//    LibMap.Uint64Map private uint64Map;
//    LibMap.Uint128Map private uint128Map;
//
//    function testUint8MapSetAndGet() public {
//        uint8Map.set(0, 255);
//        assertEq(uint8Map.get(0), 255);
//        uint8Map.set(1, 128);
//        assertEq(uint8Map.get(1), 128);
//    }
//
//    function testUint16MapSetAndGet() public {
//        uint16Map.set(0, 65535);
//        assertEq(uint16Map.get(0), 65535);
//        uint16Map.set(1, 32768);
//        assertEq(uint16Map.get(1), 32768);
//    }
//
//    function testUint32MapSetAndGet() public {
//        uint32Map.set(0, 4294967295);
//        assertEq(uint32Map.get(0), 4294967295);
//        uint32Map.set(1, 2147483648);
//        assertEq(uint32Map.get(1), 2147483648);
//    }
//
//    function testUint40MapSetAndGet() public {
//        uint40Map.set(0, 1099511627775);
//        assertEq(uint40Map.get(0), 1099511627775);
//        uint40Map.set(1, 549755813888);
//        assertEq(uint40Map.get(1), 549755813888);
//    }
//
//    function testUint64MapSetAndGet() public {
//        uint64Map.set(0, 18446744073709551615);
//        assertEq(uint64Map.get(0), 18446744073709551615);
//        uint64Map.set(1, 9223372036854775808);
//        assertEq(uint64Map.get(1), 9223372036854775808);
//    }
//
//    function testUint128MapSetAndGet() public {
//        uint128Map.set(0, type(uint128).max);
//        assertEq(uint128Map.get(0), type(uint128).max);
//        uint128Map.set(1, type(uint128).max / 2);
//        assertEq(uint128Map.get(1), type(uint128).max / 2);
//    }
//
//    function testSearchSortedUint8Map() public {
//        uint8Map.set(0, 10);
//        uint8Map.set(1, 20);
//        uint8Map.set(2, 30);
//        (bool found, uint256 index) = uint8Map.searchSorted(20, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testSearchSortedUint16Map() public {
//        uint16Map.set(0, 100);
//        uint16Map.set(1, 200);
//        uint16Map.set(2, 300);
//        (bool found, uint256 index) = uint16Map.searchSorted(200, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testSearchSortedUint32Map() public {
//        uint32Map.set(0, 1000);
//        uint32Map.set(1, 2000);
//        uint32Map.set(2, 3000);
//        (bool found, uint256 index) = uint32Map.searchSorted(2000, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testSearchSortedUint40Map() public {
//        uint40Map.set(0, 10000);
//        uint40Map.set(1, 20000);
//        uint40Map.set(2, 30000);
//        (bool found, uint256 index) = uint40Map.searchSorted(20000, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testSearchSortedUint64Map() public {
//        uint64Map.set(0, 100000);
//        uint64Map.set(1, 200000);
//        uint64Map.set(2, 300000);
//        (bool found, uint256 index) = uint64Map.searchSorted(200000, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testSearchSortedUint128Map() public {
//        uint128Map.set(0, 1000000);
//        uint128Map.set(1, 2000000);
//        uint128Map.set(2, 3000000);
//        (bool found, uint256 index) = uint128Map.searchSorted(2000000, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//}