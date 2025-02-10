// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    using LibBit for uint256;

    /// @dev Test for `fls` function to ensure it returns the correct index of the most significant bit.
    function testFLS() public {
        assertEq(LibBit.fls(0x1), 0);
        assertEq(LibBit.fls(0x2), 1);
        assertEq(LibBit.fls(0x8000000000000000), 63);
        assertEq(LibBit.fls(0), 256);
    }

    /// @dev Test for `clz` function to ensure it counts leading zeros correctly.
    function testCLZ() public {
        assertEq(LibBit.clz(0x1), 255);
        assertEq(LibBit.clz(0x1000), 243);
        assertEq(LibBit.clz(0x8000000000000000), 192);
        assertEq(LibBit.clz(0), 256);
    }

    /// @dev Test for `ffs` function to ensure it returns the correct index of the least significant bit.
    function testFFS() public {
        assertEq(LibBit.ffs(0x1), 0);
        assertEq(LibBit.ffs(0x10), 4);
        assertEq(LibBit.ffs(0x8000000000000000), 63);
        assertEq(LibBit.ffs(0), 256);
    }

    /// @dev Test for `popCount` function to ensure it returns the correct number of set bits.
    function testPopCount() public {
        assertEq(LibBit.popCount(0x1), 1);
        assertEq(LibBit.popCount(0xF0F0F0F0F0F0F0F0), 32);
        assertEq(LibBit.popCount(0xFFFFFFFFFFFFFFFF), 64);
        assertEq(LibBit.popCount(0), 0);
    }

    /// @dev Test for `isPo2` function to ensure it correctly identifies powers of two.
    function testIsPo2() public {
        assertTrue(LibBit.isPo2(0x1));
        assertTrue(LibBit.isPo2(0x8000000000000000));
        assertFalse(LibBit.isPo2(0x3));
        assertFalse(LibBit.isPo2(0));
    }

    /// @dev Test for `reverseBits` function to ensure it reverses bits correctly.
    function testReverseBits() public {
        assertEq(LibBit.reverseBits(0x1), 0x8000000000000000000000000000000000000000000000000000000000000000);
        assertEq(LibBit.reverseBits(0x2), 0x4000000000000000000000000000000000000000000000000000000000000000);
        assertEq(LibBit.reverseBits(0x8000000000000000), 0x1);
    }

    /// @dev Test for `reverseBytes` function to ensure it reverses bytes correctly.
    function testReverseBytes() public {
        assertEq(LibBit.reverseBytes(0x0102030405060708), 0x0807060504030201);
        assertEq(LibBit.reverseBytes(0x123456789ABCDEF0), 0xF0DEBC9A78563412);
    }

    /// @dev Test for boolean operations to ensure they work correctly.
    function testBooleanOperations() public {
        assertTrue(LibBit.and(true, true));
        assertFalse(LibBit.and(true, false));
        assertTrue(LibBit.or(true, false));
        assertFalse(LibBit.or(false, false));
        assertEq(LibBit.toUint(true), 1);
        assertEq(LibBit.toUint(false), 0);
    }

    /// @dev Fuzz test for `fls` to ensure it behaves correctly across a range of inputs.
    function testFLSFuzz(uint256 x) public {
        uint256 result = LibBit.fls(x);
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertTrue(x & (1 << result) != 0);
            if (result < 255) {
                assertTrue(x & (1 << (result + 1)) == 0);
            }
        }
    }

    /// @dev Fuzz test for `clz` to ensure it behaves correctly across a range of inputs.
    function testCLZFuzz(uint256 x) public {
        uint256 result = LibBit.clz(x);
        if (x == 0) {
            assertEq(result, 256);
        } else {
            uint256 shifted = x << result;
            assertTrue(shifted >= 0x8000000000000000000000000000000000000000000000000000000000000000);
            if (result > 0) {
                assertTrue((x << (result - 1)) < 0x8000000000000000000000000000000000000000000000000000000000000000);
            }
        }
    }

    /// @dev Fuzz test for `ffs` to ensure it behaves correctly across a range of inputs.
    function testFFSFuzz(uint256 x) public {
        uint256 result = LibBit.ffs(x);
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertTrue(x & (1 << result) != 0);
            if (result > 0) {
                assertTrue((x & ((1 << result) - 1)) == 0);
            }
        }
    }
}