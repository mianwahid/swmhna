// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    using LibBit for uint256;

    /// @dev Test for `fls` function to ensure it returns the correct index of the most significant bit.
    function testFLS() public {
        assertEq(LibBit.fls(0x0), 256, "fls(0) should be 256");
        assertEq(LibBit.fls(0x1), 0, "fls(1) should be 0");
        assertEq(LibBit.fls(0x8000000000000000), 63, "fls(0x8000000000000000) should be 63");
        assertEq(LibBit.fls(0x80000000000000000000000000000000), 127, "fls(0x80000000000000000000000000000000) should be 127");
    }

    /// @dev Test for `clz` function to ensure it counts leading zeros correctly.
    function testCLZ() public {
        assertEq(LibBit.clz(0x0), 256, "clz(0) should be 256");
        assertEq(LibBit.clz(0x1), 255, "clz(1) should be 255");
        assertEq(LibBit.clz(0x8000000000000000), 192, "clz(0x8000000000000000) should be 192");
        assertEq(LibBit.clz(0x80000000000000000000000000000000), 128, "clz(0x80000000000000000000000000000000) should be 128");
    }

    /// @dev Test for `ffs` function to ensure it returns the correct index of the least significant bit.
    function testFFS() public {
        assertEq(LibBit.ffs(0x0), 256, "ffs(0) should be 256");
        assertEq(LibBit.ffs(0x1), 0, "ffs(1) should be 0");
        assertEq(LibBit.ffs(0x8000000000000000), 63, "ffs(0x8000000000000000) should be 63");
        assertEq(LibBit.ffs(0x80000000000000000000000000000000), 127, "ffs(0x80000000000000000000000000000000) should be 127");
    }

    /// @dev Test for `popCount` function to ensure it counts the number of set bits correctly.
    function testPopCount() public {
        assertEq(LibBit.popCount(0x0), 0, "popCount(0) should be 0");
        assertEq(LibBit.popCount(0x1), 1, "popCount(1) should be 1");
        assertEq(LibBit.popCount(0xF0F0F0F0F0F0F0F0), 32, "popCount(0xF0F0F0F0F0F0F0F0) should be 32");
        assertEq(LibBit.popCount(0xFFFFFFFFFFFFFFFF), 64, "popCount(0xFFFFFFFFFFFFFFFF) should be 64");
    }

    /// @dev Test for `isPo2` function to check if a number is a power of 2.
    function testIsPo2() public {
        assertTrue(LibBit.isPo2(0x1), "1 is a power of 2");
        assertTrue(LibBit.isPo2(0x8000000000000000), "0x8000000000000000 is a power of 2");
        assertFalse(LibBit.isPo2(0x3), "3 is not a power of 2");
        assertFalse(LibBit.isPo2(0x0), "0 is not a power of 2");
    }

    /// @dev Test for `reverseBits` function to ensure it reverses bits correctly.
    function testReverseBits() public {
        assertEq(LibBit.reverseBits(0x0), 0x0, "reverseBits(0) should be 0");
        assertEq(LibBit.reverseBits(0x1), 0x80000000000000000000000000000000, "reverseBits(1) should be 0x80000000000000000000000000000000");
        assertEq(LibBit.reverseBits(0x8000000000000000), 0x1, "reverseBits(0x8000000000000000) should be 0x1");
        assertEq(LibBit.reverseBits(0x123456789ABCDEF0), 0x0F7B3D591E6A2C48, "reverseBits(0x123456789ABCDEF0) should be 0x0F7B3D591E6A2C48");
    }

    /// @dev Test for boolean operations to ensure they work correctly.
    function testBooleanOperations() public {
        assertTrue(LibBit.and(true, true), "and(true, true) should be true");
        assertFalse(LibBit.and(true, false), "and(true, false) should be false");
        assertTrue(LibBit.or(true, false), "or(true, false) should be true");
        assertFalse(LibBit.or(false, false), "or(false, false) should be false");
        assertEq(LibBit.toUint(true), 1, "toUint(true) should be 1");
        assertEq(LibBit.toUint(false), 0, "toUint(false) should be 0");
    }
}