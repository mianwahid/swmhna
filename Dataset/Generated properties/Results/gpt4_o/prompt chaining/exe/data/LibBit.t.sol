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
        for (uint256 i = 1; i < 256; i++) {
            assertTrue(LibBit.fls(1 << i) >= 0 && LibBit.fls(1 << i) <= 255);
        }
        // Invariant 3
        for (uint256 i = 0; i < 256; i++) {
            assertEq(LibBit.fls(1 << i), i);
        }
        // Invariant 4
        for (uint256 i = 1; i < 256; i++) {
            assertEq(LibBit.fls((1 << i) - 1), i - 1);
        }
    }

    function testClz() public {
        // Invariant 1
        assertEq(LibBit.clz(0), 256);
        // Invariant 2
        for (uint256 i = 1; i < 256; i++) {
            assertTrue(LibBit.clz(1 << i) >= 0 && LibBit.clz(1 << i) <= 255);
        }
        // Invariant 3
        for (uint256 i = 0; i < 256; i++) {
            assertEq(LibBit.clz(1 << i), 255 - i);
        }
        // Invariant 4
        for (uint256 i = 1; i < 256; i++) {
            assertEq(LibBit.clz((1 << i) - 1), 256 - i);
        }
    }

    function testFfs() public {
        // Invariant 1
        assertEq(LibBit.ffs(0), 256);
        // Invariant 2
        for (uint256 i = 1; i < 256; i++) {
            assertTrue(LibBit.ffs(1 << i) >= 0 && LibBit.ffs(1 << i) <= 255);
        }
        // Invariant 3
        for (uint256 i = 0; i < 256; i++) {
            assertEq(LibBit.ffs(1 << i), i);
        }
        // Invariant 4
        for (uint256 i = 1; i < 256; i++) {
            assertEq(LibBit.ffs((1 << i) - 1), 0);
        }
    }

    function testPopCount() public {
        // Invariant 1
        assertEq(LibBit.popCount(0), 0);
        // Invariant 2
        for (uint256 i = 0; i < 256; i++) {
            assertEq(LibBit.popCount(1 << i), 1);
        }
        // Invariant 3
        for (uint256 i = 1; i < 256; i++) {
            assertEq(LibBit.popCount((1 << i) - 1), i);
        }
        // Invariant 4
        assertEq(LibBit.popCount(1 << 255), 1);
    }

//    function testIsPo2() public {
//        // Invariant 1
//        assertFalse(LibBit.isPo2(0));
//        // Invariant 2
//        for (uint256 i = 0; i < 256; i++) {
//            assertTrue(LibBit.isPo2(1 << i));
//        }
//        // Invariant 3
//        for (uint256 i = 1; i < 256; i++) {
//            assertFalse(LibBit.isPo2((1 << i) - 1));
//        }
//        // Invariant 4
//        for (uint256 i = 0; i < 255; i++) {
//            assertFalse(LibBit.isPo2((1 << i) + 1));
//        }
//    }

    function testReverseBits() public {
        // Invariant 1
        assertEq(LibBit.reverseBits(0), 0);
        // Invariant 2
        for (uint256 i = 0; i < 256; i++) {
            assertEq(LibBit.reverseBits(1 << i), 1 << (255 - i));
        }
        // Invariant 3
        assertEq(LibBit.reverseBits(1 << 255), 1);
        // Invariant 4
        assertEq(LibBit.reverseBits((1 << 255) + 1), (1 << 255) + 1);
    }

//    function testReverseBytes() public {
//        // Invariant 1
//        assertEq(LibBit.reverseBytes(0), 0);
//        // Invariant 2
//        assertEq(LibBit.reverseBytes(0x0102030405060708), 0x0807060504030201);
//        // Invariant 3
//        assertEq(LibBit.reverseBytes(0xFFFFFFFFFFFFFFFF), 0xFFFFFFFFFFFFFFFF);
//        // Invariant 4
//        assertEq(LibBit.reverseBytes(0x0000000000000001), 0x0100000000000000);
//    }

    function testRawAnd() public {
        // Invariant 1
        assertTrue(LibBit.rawAnd(true, true));
        // Invariant 2
        assertFalse(LibBit.rawAnd(true, false));
        assertFalse(LibBit.rawAnd(false, true));
        // Invariant 3
        assertFalse(LibBit.rawAnd(false, false));
    }

    function testAnd() public {
        // Invariant 1
        assertTrue(LibBit.and(true, true));
        // Invariant 2
        assertFalse(LibBit.and(true, false));
        assertFalse(LibBit.and(false, true));
        // Invariant 3
        assertFalse(LibBit.and(false, false));
    }

    function testRawOr() public {
        // Invariant 1
        assertTrue(LibBit.rawOr(true, true));
        // Invariant 2
        assertTrue(LibBit.rawOr(true, false));
        assertTrue(LibBit.rawOr(false, true));
        // Invariant 3
        assertFalse(LibBit.rawOr(false, false));
    }

    function testOr() public {
        // Invariant 1
        assertTrue(LibBit.or(true, true));
        // Invariant 2
        assertTrue(LibBit.or(true, false));
        assertTrue(LibBit.or(false, true));
        // Invariant 3
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