// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    using LibBit for uint256;

//    function testFfs() public {
//        assertEq(0x00.ffs(), 256);
//        assertEq(0x01.ffs(), 0);
//        assertEq(0x02.ffs(), 1);
//        assertEq(0x03.ffs(), 0);
//        assertEq(0x04.ffs(), 2);
//        assertEq(0x08.ffs(), 3);
//        assertEq(0x10.ffs(), 4);
//        assertEq(0x80.ffs(), 7);
//        assertEq(type(uint256).max.ffs(), 0);
//    }
//
//    function testFls() public {
//        assertEq(0x00.fls(), 256);
//        assertEq(0x01.fls(), 0);
//        assertEq(0x02.fls(), 1);
//        assertEq(0x03.fls(), 1);
//        assertEq(0x04.fls(), 2);
//        assertEq(0x08.fls(), 3);
//        assertEq(0x10.fls(), 4);
//        assertEq(0x80.fls(), 7);
//        assertEq(type(uint256).max.fls(), 255);
//    }
//
//    function testClz() public {
//        assertEq(0x00.clz(), 256);
//        assertEq(0x01.clz(), 255);
//        assertEq(0x02.clz(), 254);
//        assertEq(0x03.clz(), 254);
//        assertEq(0x04.clz(), 253);
//        assertEq(0x08.clz(), 252);
//        assertEq(0x10.clz(), 251);
//        assertEq(0x80.clz(), 248);
//        assertEq(type(uint256).max.clz(), 0);
//    }

//    function testPopCount() public {
//        assertEq(0x00.popCount(), 0);
//        assertEq(0x01.popCount(), 1);
//        assertEq(0x02.popCount(), 1);
//        assertEq(0x03.popCount(), 2);
//        assertEq(0x04.popCount(), 1);
//        assertEq(0x08.popCount(), 1);
//        assertEq(0x10.popCount(), 1);
//        assertEq(0x80.popCount(), 1);
//        assertEq(type(uint256).max.popCount(), 256);
//    }
//
//    function testIsPo2() public {
//        assertFalse(0x00.isPo2());
//        assertTrue(0x01.isPo2());
//        assertTrue(0x02.isPo2());
//        assertFalse(0x03.isPo2());
//        assertTrue(0x04.isPo2());
//        assertTrue(0x08.isPo2());
//        assertTrue(0x10.isPo2());
//        assertTrue(0x80.isPo2());
//        assertFalse(type(uint256).max.isPo2());
//    }

//    function testReverseBits() public {
//        assertEq(0x00.reverseBits(), 0x00);
//        assertEq(0x01.reverseBits(), 0x80000000000000000000000000000000);
//        assertEq(0x02.reverseBits(), 0x40000000000000000000000000000000);
//        assertEq(0x03.reverseBits(), 0xC0000000000000000000000000000000);
//        assertEq(0x04.reverseBits(), 0x20000000000000000000000000000000);
//        assertEq(0x08.reverseBits(), 0x10000000000000000000000000000000);
//        assertEq(0x10.reverseBits(), 0x08000000000000000000000000000000);
//        assertEq(0x80.reverseBits(), 0x01000000000000000000000000000000);
//        assertEq(type(uint256).max.reverseBits(), type(uint256).max);
//    }
//
//    function testReverseBytes() public {
//        assertEq(0x00.reverseBytes(), 0x00);
//        assertEq(0x01.reverseBytes(), 0x01000000000000000000000000000000);
//        assertEq(0x02.reverseBytes(), 0x02000000000000000000000000000000);
//        assertEq(0x03.reverseBytes(), 0x03000000000000000000000000000000);
//        assertEq(0x04.reverseBytes(), 0x04000000000000000000000000000000);
//        assertEq(0x08.reverseBytes(), 0x08000000000000000000000000000000);
//        assertEq(0x10.reverseBytes(), 0x10000000000000000000000000000000);
//        assertEq(0x80.reverseBytes(), 0x80000000000000000000000000000000);
//        assertEq(type(uint256).max.reverseBytes(), type(uint256).max);
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
        uint256 result = x.ffs();
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertEq(x & (uint256(1) << result), uint256(1) << result);
            assertLt(result, 256);
        }
    }

    function testFuzzFls(uint256 x) public {
        uint256 result = x.fls();
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertEq(x >> result, 1);
            assertLt(result, 256);
        }
    }

    function testFuzzClz(uint256 x) public {
        uint256 result = x.clz();
        if (x == 0) {
            assertEq(result, 256);
        } else {
            assertEq(result, 255 - x.fls());
            assertLt(result, 256);
        }
    }
}