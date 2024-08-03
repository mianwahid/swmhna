// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/LibBit.sol";

contract LibBitTest is Test {
    /// @dev Test the `fls` function with various edge cases.
    function testFLS() public {
        assertEq(LibBit.fls(0), 256, "fls(0) should return 256");
        assertEq(LibBit.fls(1), 0, "fls(1) should return 0");
        assertEq(LibBit.fls(2), 1, "fls(2) should return 1");
        assertEq(LibBit.fls(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), 255, "fls(max uint) should return 255");
    }

    /// @dev Test the `clz` function with various edge cases.
    function testCLZ() public {
        assertEq(LibBit.clz(0), 256, "clz(0) should return 256");
        assertEq(LibBit.clz(1), 255, "clz(1) should return 255");
        assertEq(LibBit.clz(0x8000000000000000000000000000000000000000000000000000000000000000), 0, "clz(high bit) should return 0");
        assertEq(LibBit.clz(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), 0, "clz(max uint) should return 0");
    }

    /// @dev Test the `ffs` function with various edge cases.
    function testFFS() public {
        assertEq(LibBit.ffs(0), 256, "ffs(0) should return 256");
        assertEq(LibBit.ffs(1), 0, "ffs(1) should return 0");
        assertEq(LibBit.ffs(2), 1, "ffs(2) should return 1");
        assertEq(LibBit.ffs(0x8000000000000000000000000000000000000000000000000000000000000000), 255, "ffs(high bit) should return 255");
    }

    /// @dev Test the `popCount` function with various edge cases.
    function testPopCount() public {
        assertEq(LibBit.popCount(0), 0, "popCount(0) should return 0");
        assertEq(LibBit.popCount(1), 1, "popCount(1) should return 1");
        assertEq(LibBit.popCount(0xf), 4, "popCount(0xf) should return 4");
        assertEq(LibBit.popCount(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), 256, "popCount(max uint) should return 256");
    }

    /// @dev Test the `isPo2` function with various edge cases.
    function testIsPo2() public {
        assertTrue(LibBit.isPo2(1), "isPo2(1) should return true");
        assertTrue(LibBit.isPo2(2), "isPo2(2) should return true");
        assertTrue(LibBit.isPo2(0x8000000000000000), "isPo2(2^63) should return true");
        assertFalse(LibBit.isPo2(0), "isPo2(0) should return false");
        assertFalse(LibBit.isPo2(3), "isPo2(3) should return false");
    }

    /// @dev Test the `reverseBits` function with various edge cases.
    function testReverseBits() public {
        assertEq(LibBit.reverseBits(0), 0, "reverseBits(0) should return 0");
        assertEq(LibBit.reverseBits(1), 0x8000000000000000000000000000000000000000000000000000000000000000, "reverseBits(1) should return high bit");
        assertEq(LibBit.reverseBits(0x8000000000000000000000000000000000000000000000000000000000000000), 1, "reverseBits(high bit) should return 1");
    }

    /// @dev Test the boolean operations with various edge cases.
    function testBooleanOperations() public {
        assertTrue(LibBit.and(true, true), "and(true, true) should return true");
        assertFalse(LibBit.and(true, false), "and(true, false) should return false");
        assertFalse(LibBit.and(false, true), "and(false, true) should return false");
        assertFalse(LibBit.and(false, false), "and(false, false) should return false");

        assertTrue(LibBit.or(true, true), "or(true, true) should return true");
        assertTrue(LibBit.or(true, false), "or(true, false) should return true");
        assertTrue(LibBit.or(false, true), "or(false, true) should return true");
        assertFalse(LibBit.or(false, false), "or(false, false) should return false");

        assertEq(LibBit.toUint(true), 1, "toUint(true) should return 1");
        assertEq(LibBit.toUint(false), 0, "toUint(false) should return 0");
    }
}
