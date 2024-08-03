// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    function testFls() public {
        // Invariant 1
        assertEq(LibBit.fls(0), 256);
        // Invariant 2
        assertTrue(LibBit.fls(1) < 256);
        // Invariant 3
        assertEq(LibBit.fls(1), 0);
        // Invariant 4
        assertEq(LibBit.fls(2**255), 255);
        // Invariant 5
        for (uint256 n = 1; n <= 256; n++) {
            assertEq(LibBit.fls(2**n - 1), n - 1);
        }
    }

    function testClz() public {
        // Invariant 1
        assertEq(LibBit.clz(0), 256);
        // Invariant 2
        assertTrue(LibBit.clz(1) < 256);
        // Invariant 3
        assertEq(LibBit.clz(1), 255);
        // Invariant 4
        assertEq(LibBit.clz(2**255), 0);
        // Invariant 5
        for (uint256 n = 1; n <= 256; n++) {
            assertEq(LibBit.clz(2**n - 1), 256 - n);
        }
    }

    function testFfs() public {
        // Invariant 1
        assertEq(LibBit.ffs(0), 256);
        // Invariant 2
        assertTrue(LibBit.ffs(1) < 256);
        // Invariant 3
        assertEq(LibBit.ffs(1), 0);
        // Invariant 4
        assertEq(LibBit.ffs(2**255), 255);
        // Invariant 5
        for (uint256 n = 0; n < 256; n++) {
            assertEq(LibBit.ffs(2**n), n);
        }
    }

    function testPopCount() public {
        // Invariant 1
        assertEq(LibBit.popCount(0), 0);
        // Invariant 2
        for (uint256 n = 0; n < 256; n++) {
            assertEq(LibBit.popCount(2**n), 1);
        }
        // Invariant 3
        assertEq(LibBit.popCount(2**256 - 1), 256);
        // Invariant 4
        for (uint256 n = 1; n <= 256; n++) {
            assertEq(LibBit.popCount(2**n - 1), n);
        }
    }

    function testIsPo2() public {
        // Invariant 1
        assertFalse(LibBit.isPo2(0));
        // Invariant 2
        for (uint256 n = 0; n < 256; n++) {
            assertTrue(LibBit.isPo2(2**n));
        }
        // Invariant 3
        for (uint256 n = 2; n <= 256; n++) {
            assertFalse(LibBit.isPo2(2**n - 1));
        }
        // Invariant 4
        assertFalse(LibBit.isPo2(2**256 - 1));
    }

    function testReverseBits() public {
        // Invariant 1
        assertEq(LibBit.reverseBits(0), 0);
        // Invariant 2
        for (uint256 n = 0; n < 256; n++) {
            assertEq(LibBit.reverseBits(2**n), 2**(255 - n));
        }
        // Invariant 3
        assertEq(LibBit.reverseBits(2**256 - 1), 2**256 - 1);
        // Invariant 4
        assertEq(LibBit.reverseBits(0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0), 0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F);
    }

    function testReverseBytes() public {
        // Invariant 1
        assertEq(LibBit.reverseBytes(0), 0);
        // Invariant 2
        assertEq(LibBit.reverseBytes(0x0102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F20), 0x201F1E1D1C1B1A191817161514131211100F0E0D0C0B0A090807060504030201);
        // Invariant 3
        assertEq(LibBit.reverseBytes(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    }

    function testRawAnd() public {
        // Invariant 1
        assertTrue(LibBit.rawAnd(true, true));
        // Invariant 2
        assertFalse(LibBit.rawAnd(true, false));
        // Invariant 3
        assertFalse(LibBit.rawAnd(false, true));
        // Invariant 4
        assertFalse(LibBit.rawAnd(false, false));
    }

    function testAnd() public {
        // Invariant 1
        assertTrue(LibBit.and(true, true));
        // Invariant 2
        assertFalse(LibBit.and(true, false));
        // Invariant 3
        assertFalse(LibBit.and(false, true));
        // Invariant 4
        assertFalse(LibBit.and(false, false));
    }

    function testRawOr() public {
        // Invariant 1
        assertTrue(LibBit.rawOr(true, true));
        // Invariant 2
        assertTrue(LibBit.rawOr(true, false));
        // Invariant 3
        assertTrue(LibBit.rawOr(false, true));
        // Invariant 4
        assertFalse(LibBit.rawOr(false, false));
    }

    function testOr() public {
        // Invariant 1
        assertTrue(LibBit.or(true, true));
        // Invariant 2
        assertTrue(LibBit.or(true, false));
        // Invariant 3
        assertTrue(LibBit.or(false, true));
        // Invariant 4
        assertFalse(LibBit.or(false, false));
    }

    function testRawToUint() public {
        // Invariant 1
        assertEq(LibBit.rawToUint(true), 1);
        // Invariant 2
        assertEq(LibBit.rawToUint(false), 0);
    }

    function testToUint() public {
        // Invariant 1
        assertEq(LibBit.toUint(true), 1);
        // Invariant 2
        assertEq(LibBit.toUint(false), 0);
    }
}