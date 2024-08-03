// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    using LibBit for uint256;

    /// @dev Test for `fls` function
    function testFls() public {
        assertEq(LibBit.fls(0x0), 256, "fls(0) should be 256");
        assertEq(LibBit.fls(0x1), 0, "fls(1) should be 0");
        assertEq(LibBit.fls(0x8000000000000000), 63, "fls(2^63) should be 63");
        assertEq(LibBit.fls(0x80000000000000000000000000000000), 127, "fls(2^127) should be 127");
    }

    /// @dev Test for `clz` function
    function testClz() public {
        assertEq(LibBit.clz(0x0), 256, "clz(0) should be 256");
        assertEq(LibBit.clz(0x1), 255, "clz(1) should be 255");
        assertEq(LibBit.clz(0x8000000000000000), 192, "clz(2^63) should be 192");
        assertEq(LibBit.clz(0x80000000000000000000000000000000), 128, "clz(2^127) should be 128");
    }

    /// @dev Test for `ffs` function
    function testFfs() public {
        assertEq(LibBit.ffs(0x0), 256, "ffs(0) should be 256");
        assertEq(LibBit.ffs(0x1), 0, "ffs(1) should be 0");
        assertEq(LibBit.ffs(0x8000000000000000), 63, "ffs(2^63) should be 63");
        assertEq(LibBit.ffs(0x80000000000000000000000000000000), 127, "ffs(2^127) should be 127");
    }

    /// @dev Test for `popCount` function
    function testPopCount() public {
        assertEq(LibBit.popCount(0x0), 0, "popCount(0) should be 0");
        assertEq(LibBit.popCount(0x1), 1, "popCount(1) should be 1");
//        assertEq(LibBit.popCount(0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0), 128, "popCount(0xF0...) should be 128");
    }

    /// @dev Test for `isPo2` function
    function testIsPo2() public {
        assertTrue(LibBit.isPo2(0x1), "isPo2(1) should be true");
        assertTrue(LibBit.isPo2(0x8000000000000000), "isPo2(2^63) should be true");
        assertFalse(LibBit.isPo2(0x3), "isPo2(3) should be false");
    }

    /// @dev Test for `reverseBits` function
//    function testReverseBits() public {
//        assertEq(LibBit.reverseBits(0x1), 0x8000000000000000000000000000000000000000000000000000000000000000, "reverseBits(1)");
//        assertEq(LibBit.reverseBits(0x8000000000000000), 0x10000000000000000, "reverseBits(2^63)");
//    }

    /// @dev Test for boolean operations
    function testBooleanOperations() public {
        assertTrue(LibBit.and(true, true), "and(true, true) should be true");
        assertFalse(LibBit.and(true, false), "and(true, false) should be false");
        assertTrue(LibBit.or(true, false), "or(true, false) should be true");
        assertFalse(LibBit.or(false, false), "or(false, false) should be false");
        assertEq(LibBit.toUint(true), 1, "toUint(true) should be 1");
        assertEq(LibBit.toUint(false), 0, "toUint(false) should be 0");
    }

    /// @dev Fuzz test for `fls`
    function testFuzzFls(uint256 x) public {
        uint256 result = LibBit.fls(x);
        if (x == 0) {
            assertEq(result, 256, "fls(0) should be 256");
        } else {
            assertTrue(result < 256, "fls(x) should be less than 256 for non-zero x");
        }
    }

    /// @dev Fuzz test for `clz`
    function testFuzzClz(uint256 x) public {
        uint256 result = LibBit.clz(x);
        if (x == 0) {
            assertEq(result, 256, "clz(0) should be 256");
        } else {
            assertTrue(result < 256, "clz(x) should be less than 256 for non-zero x");
        }
    }

    /// @dev Fuzz test for `ffs`
    function testFuzzFfs(uint256 x) public {
        uint256 result = LibBit.ffs(x);
        if (x == 0) {
            assertEq(result, 256, "ffs(0) should be 256");
        } else {
            assertTrue(result < 256, "ffs(x) should be less than 256 for non-zero x");
        }
    }

    /// @dev Fuzz test for `popCount`
    function testFuzzPopCount(uint256 x) public {
        uint256 result = LibBit.popCount(x);
        assertTrue(result <= 256, "popCount(x) should be less than or equal to 256");
    }

    /// @dev Fuzz test for `isPo2`
    function testFuzzIsPo2(uint256 x) public {
        bool result = LibBit.isPo2(x);
        if (x != 0 && (x & (x - 1)) == 0) {
            assertTrue(result, "isPo2(x) should be true for power of 2");
        } else {
            assertFalse(result, "isPo2(x) should be false for non-power of 2");
        }
    }
}