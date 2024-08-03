// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/LibBit.sol";

contract LibBitTest is Test {
    using LibBit for uint256;

    function testFLSInvariant(uint256 x) public {
        if (x == 0) {
            assertEq(LibBit.fls(x), 256);
        } else {
            uint256 result = LibBit.fls(x);
            assertTrue(result >= 0 && result <= 255);
        }
    }

    function testCLZInvariant(uint256 x) public {
        if (x == 0) {
            assertEq(LibBit.clz(x), 256);
        } else {
            uint256 result = LibBit.clz(x);
            assertTrue(result >= 0 && result <= 255);
        }
    }

    function testFFSInvariant(uint256 x) public {
        if (x == 0) {
            assertEq(LibBit.ffs(x), 256);
        } else {
            uint256 result = LibBit.ffs(x);
            assertTrue(result >= 0 && result <= 255);
        }
    }

    function testPopCountInvariant(uint256 x) public {
        uint256 result = LibBit.popCount(x);
        assertTrue(result >= 0 && result <= 256);
    }

    function testIsPo2Invariant(uint256 x) public {
        bool result = LibBit.isPo2(x);
        if (x != 0 && (x & (x - 1)) == 0) {
            assertTrue(result);
        } else {
            assertFalse(result);
        }
    }

    function testReverseBitsInvariant(uint256 x) public {
        uint256 reversed = LibBit.reverseBits(x);
        uint256 doubleReversed = LibBit.reverseBits(reversed);
        assertEq(doubleReversed, x);
    }

    function testReverseBytesInvariant(uint256 x) public {
        uint256 reversed = LibBit.reverseBytes(x);
        uint256 doubleReversed = LibBit.reverseBytes(reversed);
        assertEq(doubleReversed, x);
    }

    function testRawAnd(bool x, bool y) public {
        bool result = LibBit.rawAnd(x, y);
        assertEq(result, x && y);
    }

    function testAnd(bool x, bool y) public {
        bool result = LibBit.and(x, y);
        assertEq(result, x && y);
    }

    function testRawOr(bool x, bool y) public {
        bool result = LibBit.rawOr(x, y);
        assertEq(result, x || y);
    }

    function testOr(bool x, bool y) public {
        bool result = LibBit.or(x, y);
        assertEq(result, x || y);
    }

    function testRawToUint(bool b) public {
        uint256 result = LibBit.rawToUint(b);
        assertEq(result, b ? 1 : 0);
    }

    function testToUint(bool b) public {
        uint256 result = LibBit.toUint(b);
        assertEq(result, b ? 1 : 0);
    }
}
