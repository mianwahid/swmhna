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

    function testInitialStateInvariant() public {
        for (uint256 i = 0; i < 100; i++) {
            assertEq(uint8Map.get(i), 0);
            assertEq(uint16Map.get(i), 0);
            assertEq(uint32Map.get(i), 0);
            assertEq(uint40Map.get(i), 0);
            assertEq(uint64Map.get(i), 0);
            assertEq(uint128Map.get(i), 0);
        }
    }

    function testSetAndGetConsistency() public {
        uint8Map.set(1, 255);
        assertEq(uint8Map.get(1), 255);

        uint16Map.set(1, 65535);
        assertEq(uint16Map.get(1), 65535);

        uint32Map.set(1, 4294967295);
        assertEq(uint32Map.get(1), 4294967295);

        uint40Map.set(1, 1099511627775);
        assertEq(uint40Map.get(1), 1099511627775);

        uint64Map.set(1, 18446744073709551615);
        assertEq(uint64Map.get(1), 18446744073709551615);

        uint128Map.set(1, 340282366920938463463374607431768211455);
        assertEq(uint128Map.get(1), 340282366920938463463374607431768211455);
    }

    function testBoundaryConditions() public {
        uint8Map.set(31, 255);
        assertEq(uint8Map.get(31), 255);
        uint8Map.set(32, 255);
        assertEq(uint8Map.get(32), 255);

        uint16Map.set(15, 65535);
        assertEq(uint16Map.get(15), 65535);
        uint16Map.set(16, 65535);
        assertEq(uint16Map.get(16), 65535);

        uint32Map.set(7, 4294967295);
        assertEq(uint32Map.get(7), 4294967295);
        uint32Map.set(8, 4294967295);
        assertEq(uint32Map.get(8), 4294967295);

        uint40Map.set(5, 1099511627775);
        assertEq(uint40Map.get(5), 1099511627775);
        uint40Map.set(6, 1099511627775);
        assertEq(uint40Map.get(6), 1099511627775);

        uint64Map.set(3, 18446744073709551615);
        assertEq(uint64Map.get(3), 18446744073709551615);
        uint64Map.set(4, 18446744073709551615);
        assertEq(uint64Map.get(4), 18446744073709551615);

        uint128Map.set(1, 340282366920938463463374607431768211455);
        assertEq(uint128Map.get(1), 340282366920938463463374607431768211455);
        uint128Map.set(2, 340282366920938463463374607431768211455);
        assertEq(uint128Map.get(2), 340282366920938463463374607431768211455);
    }

    function testUint8Overflow() public {
        uint8Map.set(1, 25);
        assertEq(uint8Map.get(1), 0); // Overflow should wrap around
    }

    function testUint16Overflow() public {
        uint16Map.set(1, 655);
        assertEq(uint16Map.get(1), 0); // Overflow should wrap around
    }

    function testUint32Overflow() public {
        uint32Map.set(1, 4294967);
        assertEq(uint32Map.get(1), 0); // Overflow should wrap around
    }

    function testUint40Overflow() public {
        uint40Map.set(1, 109951162);
        assertEq(uint40Map.get(1), 0); // Overflow should wrap around
    }

    function testUint64Overflow() public {
        uint64Map.set(1, 18446744073709);
        assertEq(uint64Map.get(1), 0); // Overflow should wrap around
    }

    function testUint128Overflow() public {
        uint128Map.set(1, 3402823669209384634633746);
        assertEq(uint128Map.get(1), 0); // Overflow should wrap around
    }

    function testSortedSearch() public {
        for (uint256 i = 0; i < 10; i++) {
            uint8Map.set(i, uint8(i));
        }
        (bool found, uint256 index) = uint8Map.searchSorted(5, 0, 10);
        assertTrue(found);
        assertEq(index, 5);

        (found, index) = uint8Map.searchSorted(11, 0, 10);
        assertFalse(found);
    }

    function testSearchRange() public {
        for (uint256 i = 0; i < 10; i++) {
            uint8Map.set(i, uint8(i));
        }
        (bool found, uint256 index) = uint8Map.searchSorted(5, 3, 7);
        assertTrue(found);
        assertEq(index, 5);

        (found, index) = uint8Map.searchSorted(2, 3, 7);
        assertFalse(found);
    }

    function testEmptyRange() public {
        (bool found, uint256 index) = uint8Map.searchSorted(1, 5, 5);
        assertFalse(found);
        assertEq(index, 5);
    }

//    function testGenericSetAndGetConsistency() public {
//        mapping(uint256 => uint256) storage genericMap;
//        LibMap.set(genericMap, 1, 255, 8);
//        assertEq(LibMap.get(genericMap, 1, 8), 255);
//
//        LibMap.set(genericMap, 1, 65535, 16);
//        assertEq(LibMap.get(genericMap, 1, 16), 65535);
//
//        LibMap.set(genericMap, 1, 4294967295, 32);
//        assertEq(LibMap.get(genericMap, 1, 32), 4294967295);
//    }
//
//    function testGenericBoundaryConditions() public {
//        mapping(uint256 => uint256) storage genericMap;
//        LibMap.set(genericMap, 31, 255, 8);
//        assertEq(LibMap.get(genericMap, 31, 8), 255);
//        LibMap.set(genericMap, 32, 255, 8);
//        assertEq(LibMap.get(genericMap, 32, 8), 255);
//
//        LibMap.set(genericMap, 15, 65535, 16);
//        assertEq(LibMap.get(genericMap, 15, 16), 65535);
//        LibMap.set(genericMap, 16, 65535, 16);
//        assertEq(LibMap.get(genericMap, 16, 16), 65535);
//
//        LibMap.set(genericMap, 7, 4294967295, 32);
//        assertEq(LibMap.get(genericMap, 7, 32), 4294967295);
//        LibMap.set(genericMap, 8, 4294967295, 32);
//        assertEq(LibMap.get(genericMap, 8, 32), 4294967295);
//    }
}