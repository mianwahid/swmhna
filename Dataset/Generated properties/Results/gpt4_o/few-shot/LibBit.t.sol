// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    function testFls() public {
        assertEq(LibBit.fls(0), 256);
        assertEq(LibBit.fls(1), 0);
        assertEq(LibBit.fls(2), 1);
        assertEq(LibBit.fls(3), 1);
        assertEq(LibBit.fls(4), 2);
        assertEq(LibBit.fls(255), 7);
        assertEq(LibBit.fls(256), 8);
        assertEq(LibBit.fls(type(uint256).max), 255);
    }

    function testClz() public {
        assertEq(LibBit.clz(0), 256);
        assertEq(LibBit.clz(1), 255);
        assertEq(LibBit.clz(2), 254);
        assertEq(LibBit.clz(3), 254);
        assertEq(LibBit.clz(4), 253);
        assertEq(LibBit.clz(255), 248);
        assertEq(LibBit.clz(256), 247);
        assertEq(LibBit.clz(type(uint256).max), 0);
    }

    function testFfs() public {
        assertEq(LibBit.ffs(0), 256);
        assertEq(LibBit.ffs(1), 0);
        assertEq(LibBit.ffs(2), 1);
        assertEq(LibBit.ffs(3), 0);
        assertEq(LibBit.ffs(4), 2);
        assertEq(LibBit.ffs(255), 0);
        assertEq(LibBit.ffs(256), 8);
        assertEq(LibBit.ffs(type(uint256).max), 0);
    }

    function testPopCount() public {
        assertEq(LibBit.popCount(0), 0);
        assertEq(LibBit.popCount(1), 1);
        assertEq(LibBit.popCount(2), 1);
        assertEq(LibBit.popCount(3), 2);
        assertEq(LibBit.popCount(255), 8);
        assertEq(LibBit.popCount(256), 1);
        assertEq(LibBit.popCount(type(uint256).max), 256);
    }

    function testIsPo2() public {
        assertTrue(LibBit.isPo2(1));
        assertTrue(LibBit.isPo2(2));
        assertFalse(LibBit.isPo2(3));
        assertTrue(LibBit.isPo2(4));
        assertFalse(LibBit.isPo2(5));
        assertFalse(LibBit.isPo2(0));
        assertTrue(LibBit.isPo2(256));
        assertFalse(LibBit.isPo2(255));
    }

    function testReverseBits() public {
        assertEq(LibBit.reverseBits(0), 0);
        assertEq(LibBit.reverseBits(1), 2**255);
        assertEq(LibBit.reverseBits(2), 2**254);
        assertEq(LibBit.reverseBits(3), 2**255 + 2**254);
        assertEq(LibBit.reverseBits(255), 2**255 + 2**254 + 2**253 + 2**252 + 2**251 + 2**250 + 2**249 + 2**248);
    }

    function testReverseBytes() public {
        assertEq(LibBit.reverseBytes(0), 0);
        assertEq(LibBit.reverseBytes(1), 2**248);
        assertEq(LibBit.reverseBytes(2), 2**249);
    }

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
}