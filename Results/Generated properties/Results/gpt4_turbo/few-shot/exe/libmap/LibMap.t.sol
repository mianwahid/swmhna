// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import {Test} from "forge-std/Test.sol";
import {LibMap} from "../src/utils/LibMap.sol";

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
        // Initialize maps with some values for testing
        uint8Map.set(0, 255);
        uint16Map.set(1, 65535);
        uint32Map.set(2, 4294967295);
        uint40Map.set(3, 1099511627775);
        uint64Map.set(4, 18446744073709551615);
        uint128Map.set(5, 340282366920938463463374607431768211455);
    }

    function testGetUint8() public {
        uint8 value = uint8Map.get(0);
        assertEq(value, 255, "Uint8 value mismatch");
    }

    function testSetUint8() public {
        uint8Map.set(0, 100);
        assertEq(uint8Map.get(0), 100, "Uint8 set failed");
    }

    function testGetUint16() public {
        uint16 value = uint16Map.get(1);
        assertEq(value, 65535, "Uint16 value mismatch");
    }

    function testSetUint16() public {
        uint16Map.set(1, 12345);
        assertEq(uint16Map.get(1), 12345, "Uint16 set failed");
    }

    function testGetUint32() public {
        uint32 value = uint32Map.get(2);
        assertEq(value, 4294967295, "Uint32 value mismatch");
    }

    function testSetUint32() public {
        uint32Map.set(2, 1234567890);
        assertEq(uint32Map.get(2), 1234567890, "Uint32 set failed");
    }

    function testGetUint40() public {
        uint40 value = uint40Map.get(3);
        assertEq(value, 1099511627775, "Uint40 value mismatch");
    }

    function testSetUint40() public {
        uint40Map.set(3, 9876543210);
        assertEq(uint40Map.get(3), 9876543210, "Uint40 set failed");
    }

    function testGetUint64() public {
        uint64 value = uint64Map.get(4);
        assertEq(value, 18446744073709551615, "Uint64 value mismatch");
    }

    function testSetUint64() public {
        uint64Map.set(4, 12345678901234567890);
        assertEq(uint64Map.get(4), 12345678901234567890, "Uint64 set failed");
    }

    function testGetUint128() public {
        uint128 value = uint128Map.get(5);
        assertEq(value, 340282366920938463463374607431768211455, "Uint128 value mismatch");
    }

    function testSetUint128() public {
        uint128Map.set(5, 123456789012345678901234567890123456789);
        assertEq(uint128Map.get(5), 123456789012345678901234567890123456789, "Uint128 set failed");
    }

    function testSearchSortedUint8() public {
        bool found;
        uint256 index;
        (found, index) = uint8Map.searchSorted(255, 0, 1);
        assertTrue(found, "Uint8 search failed");
        assertEq(index, 0, "Uint8 search index mismatch");
    }

    function testSearchSortedUint16() public {
        bool found;
        uint256 index;
        (found, index) = uint16Map.searchSorted(65535, 0, 2);
        assertTrue(found, "Uint16 search failed");
        assertEq(index, 1, "Uint16 search index mismatch");
    }

    function testSearchSortedUint32() public {
        bool found;
        uint256 index;
        (found, index) = uint32Map.searchSorted(4294967295, 0, 3);
        assertTrue(found, "Uint32 search failed");
        assertEq(index, 2, "Uint32 search index mismatch");
    }

    function testSearchSortedUint40() public {
        bool found;
        uint256 index;
        (found, index) = uint40Map.searchSorted(1099511627775, 0, 4);
        assertTrue(found, "Uint40 search failed");
        assertEq(index, 3, "Uint40 search index mismatch");
    }

    function testSearchSortedUint64() public {
        bool found;
        uint256 index;
        (found, index) = uint64Map.searchSorted(18446744073709551615, 0, 5);
        assertTrue(found, "Uint64 search failed");
        assertEq(index, 4, "Uint64 search index mismatch");
    }

    function testSearchSortedUint128() public {
        bool found;
        uint256 index;
        (found, index) = uint128Map.searchSorted(340282366920938463463374607431768211455, 0, 6);
        assertTrue(found, "Uint128 search failed");
        assertEq(index, 5, "Uint128 search index mismatch");
    }
}