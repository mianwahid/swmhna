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

    function setUp() public {
        // Setup code if needed
    }

    function testUint8Map() public {
        uint256 index = 0;
        uint8 value = 255;
        uint8Map.set(index, value);
        assertEq(uint8Map.get(index), value);

        // Edge cases
        index = type(uint256).max;
        value = 0;
        uint8Map.set(index, value);
        assertEq(uint8Map.get(index), value);
    }

    function testUint16Map() public {
        uint256 index = 0;
        uint16 value = 65535;
        uint16Map.set(index, value);
        assertEq(uint16Map.get(index), value);

        // Edge cases
        index = type(uint256).max;
        value = 0;
        uint16Map.set(index, value);
        assertEq(uint16Map.get(index), value);
    }

    function testUint32Map() public {
        uint256 index = 0;
        uint32 value = 4294967295;
        uint32Map.set(index, value);
        assertEq(uint32Map.get(index), value);

        // Edge cases
        index = type(uint256).max;
        value = 0;
        uint32Map.set(index, value);
        assertEq(uint32Map.get(index), value);
    }

    function testUint40Map() public {
        uint256 index = 0;
        uint40 value = 1099511627775;
        uint40Map.set(index, value);
        assertEq(uint40Map.get(index), value);

        // Edge cases
        index = type(uint256).max;
        value = 0;
        uint40Map.set(index, value);
        assertEq(uint40Map.get(index), value);
    }

    function testUint64Map() public {
        uint256 index = 0;
        uint64 value = 18446744073709551615;
        uint64Map.set(index, value);
        assertEq(uint64Map.get(index), value);

        // Edge cases
        index = type(uint256).max;
        value = 0;
        uint64Map.set(index, value);
        assertEq(uint64Map.get(index), value);
    }

    function testUint128Map() public {
        uint256 index = 0;
        uint128 value = 340282366920938463463374607431768211455;
        uint128Map.set(index, value);
        assertEq(uint128Map.get(index), value);

        // Edge cases
        index = type(uint256).max;
        value = 0;
        uint128Map.set(index, value);
        assertEq(uint128Map.get(index), value);
    }

    function testSearchSortedUint8Map() public {
        uint8Map.set(0, 1);
        uint8Map.set(1, 2);
        uint8Map.set(2, 3);

        (bool found, uint256 index) = uint8Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = uint8Map.searchSorted(4, 0, 3);
        assertFalse(found);
    }

    function testSearchSortedUint16Map() public {
        uint16Map.set(0, 1);
        uint16Map.set(1, 2);
        uint16Map.set(2, 3);

        (bool found, uint256 index) = uint16Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = uint16Map.searchSorted(4, 0, 3);
        assertFalse(found);
    }

    function testSearchSortedUint32Map() public {
        uint32Map.set(0, 1);
        uint32Map.set(1, 2);
        uint32Map.set(2, 3);

        (bool found, uint256 index) = uint32Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = uint32Map.searchSorted(4, 0, 3);
        assertFalse(found);
    }

    function testSearchSortedUint40Map() public {
        uint40Map.set(0, 1);
        uint40Map.set(1, 2);
        uint40Map.set(2, 3);

        (bool found, uint256 index) = uint40Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = uint40Map.searchSorted(4, 0, 3);
        assertFalse(found);
    }

    function testSearchSortedUint64Map() public {
        uint64Map.set(0, 1);
        uint64Map.set(1, 2);
        uint64Map.set(2, 3);

        (bool found, uint256 index) = uint64Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = uint64Map.searchSorted(4, 0, 3);
        assertFalse(found);
    }

    function testSearchSortedUint128Map() public {
        uint128Map.set(0, 1);
        uint128Map.set(1, 2);
        uint128Map.set(2, 3);

        (bool found, uint256 index) = uint128Map.searchSorted(2, 0, 3);
        assertTrue(found);
        assertEq(index, 1);

        (found, index) = uint128Map.searchSorted(4, 0, 3);
        assertFalse(found);
    }
}