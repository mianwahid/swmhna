// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
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
        // Initialize maps with some values for testing
        uint8Map.set(0, 255);
        uint16Map.set(1, 65535);
        uint32Map.set(2, 4294967295);
        uint40Map.set(3, 1099511627775);
        uint64Map.set(4, 18446744073709551615);
        uint128Map.set(5, 340282366920938463463374607431768211455);
    }

    function testGetUint8() public {
        uint8 result = uint8Map.get(0);
        assertEq(result, 255, "Uint8 value mismatch");
    }

    function testSetUint8() public {
        uint8Map.set(0, 100);
        assertEq(uint8Map.get(0), 100, "Uint8 value not updated correctly");
    }

    function testGetUint16() public {
        uint16 result = uint16Map.get(1);
        assertEq(result, 65535, "Uint16 value mismatch");
    }

    function testSetUint16() public {
        uint16Map.set(1, 12345);
        assertEq(uint16Map.get(1), 12345, "Uint16 value not updated correctly");
    }

    function testGetUint32() public {
        uint32 result = uint32Map.get(2);
        assertEq(result, 4294967295, "Uint32 value mismatch");
    }

    function testSetUint32() public {
        uint32Map.set(2, 1234567890);
        assertEq(uint32Map.get(2), 1234567890, "Uint32 value not updated correctly");
    }

    function testGetUint40() public {
        uint40 result = uint40Map.get(3);
        assertEq(result, 1099511627775, "Uint40 value mismatch");
    }

    function testSetUint40() public {
//        uint40Map.set(3, 1234567890123);
        assertEq(uint40Map.get(3), 1234567890123, "Uint40 value not updated correctly");
    }

    function testGetUint64() public {
        uint64 result = uint64Map.get(4);
        assertEq(result, 18446744073709551615, "Uint64 value mismatch");
    }

    function testSetUint64() public {
        uint64Map.set(4, 1234567890123456789);
        assertEq(uint64Map.get(4), 1234567890123456789, "Uint64 value not updated correctly");
    }

    function testGetUint128() public {
        uint128 result = uint128Map.get(5);
        assertEq(result, 340282366920938463463374607431768211455, "Uint128 value mismatch");
    }

    function testSetUint128() public {
        uint128Map.set(5, 123456789012345678901234567890123456789);
        assertEq(uint128Map.get(5), 123456789012345678901234567890123456789, "Uint128 value not updated correctly");
    }

    function testSearchSortedUint8() public {
        // Assuming the map is sorted and has multiple entries
        uint8Map.set(0, 10);
        uint8Map.set(1, 20);
        uint8Map.set(2, 30);
        (bool found, uint256 index) = uint8Map.searchSorted(20, 0, 3);
        assertTrue(found, "Uint8 value should be found");
        assertEq(index, 1, "Uint8 index mismatch");
    }

    // Additional tests for other types and edge cases can be added similarly
}