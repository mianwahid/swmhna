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
        uint8 value = uint8Map.get(0);
        assertEq(uint8(255), value);
    }

    function testSetUint8() public {
        uint8Map.set(0, 100);
        assertEq(uint8(100), uint8Map.get(0));
    }

    function testGetUint16() public {
        uint16 value = uint16Map.get(1);
        assertEq(uint16(65535), value);
    }

    function testSetUint16() public {
        uint16Map.set(1, 12345);
        assertEq(uint16(12345), uint16Map.get(1));
    }

    function testGetUint32() public {
        uint32 value = uint32Map.get(2);
        assertEq(uint32(4294967295), value);
    }

    function testSetUint32() public {
        uint32Map.set(2, 1234567890);
        assertEq(uint32(1234567890), uint32Map.get(2));
    }

    function testGetUint40() public {
        uint40 value = uint40Map.get(3);
        assertEq(uint40(1099511627775), value);
    }

    function testSetUint40() public {
        uint40Map.set(3, 9876543210);
        assertEq(uint40(9876543210), uint40Map.get(3));
    }

    function testGetUint64() public {
        uint64 value = uint64Map.get(4);
        assertEq(uint64(18446744073709551615), value);
    }

    function testSetUint64() public {
        uint64Map.set(4, 12345678901234567890);
        assertEq(uint64(12345678901234567890), uint64Map.get(4));
    }

    function testGetUint128() public {
        uint128 value = uint128Map.get(5);
        assertEq(uint128(340282366920938463463374607431768211455), value);
    }

    function testSetUint128() public {
        uint128Map.set(5, 123456789012345678901234567890123456789);
        assertEq(uint128(123456789012345678901234567890123456789), uint128Map.get(5));
    }

    function testSearchSortedUint8() public {
        // Assuming the map is sorted and contains the value
        uint8Map.set(0, 10);
        uint8Map.set(1, 20);
        uint8Map.set(2, 30);
        (bool found, uint256 index) = uint8Map.searchSorted(20, 0, 3);
        assertTrue(found);
        assertEq(1, index);
    }

    function testSearchSortedUint16() public {
        // Assuming the map is sorted and contains the value
        uint16Map.set(0, 1000);
        uint16Map.set(1, 2000);
        uint16Map.set(2, 3000);
        (bool found, uint256 index) = uint16Map.searchSorted(2000, 0, 3);
        assertTrue(found);
        assertEq(1, index);
    }

    function testSearchSortedUint32() public {
        // Assuming the map is sorted and contains the value
        uint32Map.set(0, 100000);
        uint32Map.set(1, 200000);
        uint32Map.set(2, 300000);
        (bool found, uint256 index) = uint32Map.searchSorted(200000, 0, 3);
        assertTrue(found);
        assertEq(1, index);
    }

    function testSearchSortedUint40() public {
        // Assuming the map is sorted and contains the value
        uint40Map.set(0, 1000000);
        uint40Map.set(1, 2000000);
        uint40Map.set(2, 3000000);
        (bool found, uint256 index) = uint40Map.searchSorted(2000000, 0, 3);
        assertTrue(found);
        assertEq(1, index);
    }

    function testSearchSortedUint64() public {
        // Assuming the map is sorted and contains the value
        uint64Map.set(0, 10000000);
        uint64Map.set(1, 20000000);
        uint64Map.set(2, 30000000);
        (bool found, uint256 index) = uint64Map.searchSorted(20000000, 0, 3);
        assertTrue(found);
        assertEq(1, index);
    }

    function testSearchSortedUint128() public {
        // Assuming the map is sorted and contains the value
        uint128Map.set(0, 100000000);
        uint128Map.set(1, 200000000);
        uint128Map.set(2, 300000000);
        (bool found, uint256 index) = uint128Map.searchSorted(200000000, 0, 3);
        assertTrue(found);
        assertEq(1, index);
    }
}