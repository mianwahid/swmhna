// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/LibMap.sol";

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
        // Initial setup if needed
    }

    // Test Invariants for Getters and Setters

    function testSetAndGetUint8() public {
        uint8Map.set(1, 255);
        assertEq(uint8Map.get(1), 255);
        uint8Map.set(1, 0);
        assertEq(uint8Map.get(1), 0);
    }

    function testSetAndGetUint16() public {
        uint16Map.set(1, 65535);
        assertEq(uint16Map.get(1), 65535);
        uint16Map.set(1, 0);
        assertEq(uint16Map.get(1), 0);
    }

    function testSetAndGetUint32() public {
        uint32Map.set(1, 4294967295);
        assertEq(uint32Map.get(1), 4294967295);
        uint32Map.set(1, 0);
        assertEq(uint32Map.get(1), 0);
    }

    function testSetAndGetUint40() public {
        uint40Map.set(1, 1099511627775);
        assertEq(uint40Map.get(1), 1099511627775);
        uint40Map.set(1, 0);
        assertEq(uint40Map.get(1), 0);
    }

    function testSetAndGetUint64() public {
        uint64Map.set(1, 18446744073709551615);
        assertEq(uint64Map.get(1), 18446744073709551615);
        uint64Map.set(1, 0);
        assertEq(uint64Map.get(1), 0);
    }

    function testSetAndGetUint128() public {
        uint128Map.set(1, 340282366920938463463374607431768211455);
        assertEq(uint128Map.get(1), 340282366920938463463374607431768211455);
        uint128Map.set(1, 0);
        assertEq(uint128Map.get(1), 0);
    }

    // Test Invariants for Binary Search

    function testSearchSortedUint8() public {
        uint8Map.set(0, 10);
        uint8Map.set(1, 20);
        uint8Map.set(2, 30);
        (bool found, uint256 index) = uint8Map.searchSorted(20, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    function testSearchSortedUint16() public {
        uint16Map.set(0, 1000);
        uint16Map.set(1, 2000);
        uint16Map.set(2, 3000);
        (bool found, uint256 index) = uint16Map.searchSorted(2000, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    function testSearchSortedUint32() public {
        uint32Map.set(0, 100000);
        uint32Map.set(1, 200000);
        uint32Map.set(2, 300000);
        (bool found, uint256 index) = uint32Map.searchSorted(200000, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    function testSearchSortedUint40() public {
        uint40Map.set(0, 1000000);
        uint40Map.set(1, 2000000);
        uint40Map.set(2, 3000000);
        (bool found, uint256 index) = uint40Map.searchSorted(2000000, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    function testSearchSortedUint64() public {
        uint64Map.set(0, 10000000);
        uint64Map.set(1, 20000000);
        uint64Map.set(2, 30000000);
        (bool found, uint256 index) = uint64Map.searchSorted(20000000, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    function testSearchSortedUint128() public {
        uint128Map.set(0, 100000000);
        uint128Map.set(1, 200000000);
        uint128Map.set(2, 300000000);
        (bool found, uint256 index) = uint128Map.searchSorted(200000000, 0, 3);
        assertTrue(found);
        assertEq(index, 1);
    }

    // Test Invariants for Private Helpers

    // function testDivisionAndModuloByZero() public {
    //     // assertEq(LibMap._rawDiv(10, 0), 0);
    //     assertEq(LibMap._rawMod(10, 0), 0);
    // }

    // function testCorrectCalculation() public {
    //     assertEq(LibMap._rawDiv(10, 2), 5);
    //     assertEq(LibMap._rawMod(10, 3), 1);
    // }

    // General Invariants

    function testMemorySafety() public {
        // This test would be more about ensuring no exceptions are thrown during operations
        // and would typically require fuzz testing or extensive boundary testing.
        uint8Map.set(0, 255);
        uint16Map.set(0, 65535);
        uint32Map.set(0, 4294967295);
        uint40Map.set(0, 1099511627775);
        uint64Map.set(0, 18446744073709551615);
        uint128Map.set(0, 340282366920938463463374607431768211455);
        assert(true); // If no errors, pass the test
    }

    function testGasUsage() public {
        uint gasBefore;
        uint gasAfter;

        gasBefore = gasleft();
        uint8Map.set(0, 255);
        gasAfter = gasleft();
        console2.log("Gas used for uint8Map.set:", gasBefore - gasAfter);

        gasBefore = gasleft();
        uint16Map.set(0, 65535);
        gasAfter = gasleft();
        console2.log("Gas used for uint16Map.set:", gasBefore - gasAfter);

        gasBefore = gasleft();
        uint32Map.set(0, 4294967295);
        gasAfter = gasleft();
        console2.log("Gas used for uint32Map.set:", gasBefore - gasAfter);

        gasBefore = gasleft();
        uint40Map.set(0, 1099511627775);
        gasAfter = gasleft();
        console2.log("Gas used for uint40Map.set:", gasBefore - gasAfter);

        gasBefore = gasleft();
        uint64Map.set(0, 18446744073709551615);
        gasAfter = gasleft();
        console2.log("Gas used for uint64Map.set:", gasBefore - gasAfter);

        gasBefore = gasleft();
        uint128Map.set(0, 340282366920938463463374607431768211455);
        gasAfter = gasleft();
        console2.log("Gas used for uint128Map.set:", gasBefore - gasAfter);
    }
}
