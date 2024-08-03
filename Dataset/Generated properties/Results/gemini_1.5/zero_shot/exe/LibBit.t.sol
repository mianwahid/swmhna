// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    function testFfs() public {
        assertEq(LibBit.ffs(0), 256);
        assertEq(LibBit.ffs(1), 0);
        assertEq(LibBit.ffs(2), 1);
        assertEq(LibBit.ffs(3), 0);
        assertEq(LibBit.ffs(uint256(1) << 255), 255);
    }

    function testFls() public {
        assertEq(LibBit.fls(0), 256);
        assertEq(LibBit.fls(1), 0);
        assertEq(LibBit.fls(2), 1);
        assertEq(LibBit.fls(3), 1);
        assertEq(LibBit.fls(uint256(1) << 255), 255);
    }

    function testClz() public {
        assertEq(LibBit.clz(0), 256);
        assertEq(LibBit.clz(1), 255);
        assertEq(LibBit.clz(2), 254);
        assertEq(LibBit.clz(uint256(1) << 255), 0);
    }

    function testPopCount() public {
        assertEq(LibBit.popCount(0), 0);
        assertEq(LibBit.popCount(1), 1);
        assertEq(LibBit.popCount(2), 1);
        assertEq(LibBit.popCount(3), 2);
        assertEq(LibBit.popCount(type(uint256).max), 256);
    }

    function testIsPo2() public {
        assertTrue(LibBit.isPo2(1));
        assertTrue(LibBit.isPo2(2));
        assertTrue(LibBit.isPo2(4));
        assertTrue(LibBit.isPo2(uint256(1) << 255));
        assertFalse(LibBit.isPo2(0));
        assertFalse(LibBit.isPo2(3));
        assertFalse(LibBit.isPo2(5));
        assertFalse(LibBit.isPo2(type(uint256).max));
    }

    function testReverseBits() public {
        assertEq(LibBit.reverseBits(0), 0);
        assertEq(LibBit.reverseBits(1), uint256(1) << 255);
        assertEq(LibBit.reverseBits(2), uint256(1) << 254);
        assertEq(LibBit.reverseBits(3), (uint256(1) << 255) | (uint256(1) << 254));
        assertEq(LibBit.reverseBits(type(uint256).max), type(uint256).max);
    }

//    function testReverseBytes() public {
//        assertEq(LibBit.reverseBytes(0), 0);
//        assertEq(LibBit.reverseBytes(1), uint256(1) << 248);
//        assertEq(LibBit.reverseBytes(0x0102030405060708090a0b0c0d0e0f10), 0x100f0e0d0c0b0a090807060504030201);
//        assertEq(LibBit.reverseBytes(type(uint256).max), type(uint256).max);
//    }

    function testRawAnd() public {
        assertTrue(LibBit.rawAnd(true, true));
        assertFalse(LibBit.rawAnd(true, false));
        assertFalse(LibBit.rawAnd(false, true));
        assertFalse(LibBit.rawAnd(false, false));
    }

    function testAnd() public {
        assertTrue(LibBit.and(true, true));
        assertFalse(LibBit.and(true, false));
        assertFalse(LibBit.and(false, true));
        assertFalse(LibBit.and(false, false));
    }

    function testRawOr() public {
        assertTrue(LibBit.rawOr(true, true));
        assertTrue(LibBit.rawOr(true, false));
        assertTrue(LibBit.rawOr(false, true));
        assertFalse(LibBit.rawOr(false, false));
    }

    function testOr() public {
        assertTrue(LibBit.or(true, true));
        assertTrue(LibBit.or(true, false));
        assertTrue(LibBit.or(false, true));
        assertFalse(LibBit.or(false, false));
    }

    function testRawToUint() public {
        assertEq(LibBit.rawToUint(true), 1);
        assertEq(LibBit.rawToUint(false), 0);
    }

    function testToUint() public {
        assertEq(LibBit.toUint(true), 1);
        assertEq(LibBit.toUint(false), 0);
    }

    function testFuzzFfs(uint256 x) public {
        uint256 result = LibBit.ffs(x);
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertGe(result, 0);
            assertLt(result, 256);
            assertEq(x & (uint256(1) << result), uint256(1) << result);
        }
    }

//    function testFuzzFls(uint256 x) public {
//        uint256 result = LibBit.fls(x);
//        if (x == 0) {
//            assertEq(result, 256);
//        } else {
//            assertGe(result, 0);
//            assertLt(result, 256);
//            assertTrue((x >> result) == 0);
//        }
//    }

    function testFuzzClz(uint256 x) public {
        uint256 result = LibBit.clz(x);
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertGe(result, 0);
            assertLt(result, 256);
            assertEq(255 - result, LibBit.fls(x));
        }
    }

    function testFuzzPopCount(uint256 x) public {
        uint256 result = LibBit.popCount(x);
        assertGe(result, 0);
        assertLe(result, 256);
    }

    function testFuzzReverseBits(uint256 x) public {
        uint256 result = LibBit.reverseBits(x);
        if (x == 0) {
            assertEq(result, 0);
        } else {
            assertEq(result, LibBit.reverseBits(x));
        }
    }

    function testFuzzReverseBytes(uint256 x) public {
        uint256 result = LibBit.reverseBytes(x);
        if (x == 0) {
            assertEq(result, 0);
        } else {
            assertEq(result, LibBit.reverseBytes(x));
        }
    }
}
