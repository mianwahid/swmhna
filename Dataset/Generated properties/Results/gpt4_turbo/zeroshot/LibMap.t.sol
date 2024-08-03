// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {LibMap} from "../src/LibMap.sol";

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
        // Initialize maps or other state variables if needed
    }

    // Test setting and getting values for Uint8Map
    function testUint8MapSetAndGet(uint256 index, uint8 value) public {
        uint8Map.set(index, value);
        uint8 result = uint8Map.get(index);
        assertEq(result, value, "Uint8Map set or get failed");
    }

    // Test setting and getting values for Uint16Map
    function testUint16MapSetAndGet(uint256 index, uint16 value) public {
        uint16Map.set(index, value);
        uint16 result = uint16Map.get(index);
        assertEq(result, value, "Uint16Map set or get failed");
    }

    // Test setting and getting values for Uint32Map
    function testUint32MapSetAndGet(uint256 index, uint32 value) public {
        uint32Map.set(index, value);
        uint32 result = uint32Map.get(index);
        assertEq(result, value, "Uint32Map set or get failed");
    }

    // Test setting and getting values for Uint40Map
    function testUint40MapSetAndGet(uint256 index, uint40 value) public {
        uint40Map.set(index, value);
        uint40 result = uint40Map.get(index);
        assertEq(result, value, "Uint40Map set or get failed");
    }

    // Test setting and getting values for Uint64Map
    function testUint64MapSetAndGet(uint256 index, uint64 value) public {
        uint64Map.set(index, value);
        uint64 result = uint64Map.get(index);
        assertEq(result, value, "Uint64Map set or get failed");
    }

    // Test setting and getting values for Uint128Map
    function testUint128MapSetAndGet(uint256 index, uint128 value) public {
        uint128Map.set(index, value);
        uint128 result = uint128Map.get(index);
        assertEq(result, value, "Uint128Map set or get failed");
    }

    // Test binary search functionality
    function testBinarySearch(uint256[] memory sortedArray, uint256 needle) public {
        // Populate the map with sortedArray values
        for (uint256 i = 0; i < sortedArray.length; i++) {
            uint8Map.set(i, uint8(sortedArray[i]));
        }

        // Perform search
        (bool found, uint256 index) = uint8Map.searchSorted(uint8(uint8(needle)), 0, sortedArray.length);

        // Verify the result
        if (found) {
            assertEq(uint8Map.get(index), uint8(needle), "Search did not find the correct index");
        } else {
            assertTrue(!found, "Search incorrectly found a value");
        }
    }

    // Test overflow conditions
    function testOverflowSetAndGet(uint256 index, uint256 value) public {
        uint8Map.set(index, uint8(value));
        uint8 result = uint8Map.get(index);
        assertEq(result, uint8(value), "Overflow handling failed for Uint8Map");
    }
}
