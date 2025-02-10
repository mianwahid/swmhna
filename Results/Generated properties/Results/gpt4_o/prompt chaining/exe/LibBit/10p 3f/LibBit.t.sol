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
        assertEq(LibBit.fls(0x80000000000000000000000000000000), 127);
        assertEq(LibBit.fls(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 255);
    }

    function testClz() public {
        assertEq(LibBit.clz(0), 256);
        assertEq(LibBit.clz(1), 255);
        assertEq(LibBit.clz(2), 254);
        assertEq(LibBit.clz(0x80000000000000000000000000000000), 127);
        assertEq(LibBit.clz(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0);
    }

    function testFfs() public {
        assertEq(LibBit.ffs(0), 256);
        assertEq(LibBit.ffs(1), 0);
        assertEq(LibBit.ffs(2), 1);
        assertEq(LibBit.ffs(0x80000000000000000000000000000000), 127);
        assertEq(LibBit.ffs(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0);
    }

    function testPopCount() public {
        assertEq(LibBit.popCount(0), 0);
        assertEq(LibBit.popCount(1), 1);
        assertEq(LibBit.popCount(2), 1);
        assertEq(LibBit.popCount(3), 2);
        assertEq(LibBit.popCount(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 256);
    }

    function testIsPo2() public {
        assertEq(LibBit.isPo2(0), false);
        assertEq(LibBit.isPo2(1), true);
        assertEq(LibBit.isPo2(2), true);
        assertEq(LibBit.isPo2(3), false);
        assertEq(LibBit.isPo2(0x80000000000000000000000000000000), true);
    }

    function testReverseBits() public {
        assertEq(LibBit.reverseBits(0), 0);
        assertEq(LibBit.reverseBits(1), 0x80000000000000000000000000000000);
        assertEq(LibBit.reverseBits(0x80000000000000000000000000000000), 1);
        assertEq(LibBit.reverseBits(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        assertEq(LibBit.reverseBits(0x123456789ABCDEF0), 0x0F7B3D591E6A2C48);
    }

    function testReverseBytes() public {
        assertEq(LibBit.reverseBytes(0), 0);
        assertEq(LibBit.reverseBytes(0x0102030405060708), 0x0807060504030201);
        assertEq(LibBit.reverseBytes(0x123456789ABCDEF0), 0xF0DEBC9A78563412);
        assertEq(LibBit.reverseBytes(0xFFFFFFFFFFFFFFFF), 0xFFFFFFFFFFFFFFFF);
        assertEq(LibBit.reverseBytes(0x0000000000000001), 0x0100000000000000);
    }

    function testRawAnd() public {
        assertEq(LibBit.rawAnd(false, false), false);
        assertEq(LibBit.rawAnd(false, true), false);
        assertEq(LibBit.rawAnd(true, false), false);
        assertEq(LibBit.rawAnd(true, true), true);
    }

    function testAnd() public {
        assertEq(LibBit.and(false, false), false);
        assertEq(LibBit.and(false, true), false);
        assertEq(LibBit.and(true, false), false);
        assertEq(LibBit.and(true, true), true);
    }

    function testRawOr() public {
        assertEq(LibBit.rawOr(false, false), false);
        assertEq(LibBit.rawOr(false, true), true);
        assertEq(LibBit.rawOr(true, false), true);
        assertEq(LibBit.rawOr(true, true), true);
    }

    function testOr() public {
        assertEq(LibBit.or(false, false), false);
        assertEq(LibBit.or(false, true), true);
        assertEq(LibBit.or(true, false), true);
        assertEq(LibBit.or(true, true), true);
    }

    function testRawToUint() public {
        assertEq(LibBit.rawToUint(false), 0);
        assertEq(LibBit.rawToUint(true), 1);
    }

    function testToUint() public {
        assertEq(LibBit.toUint(false), 0);
        assertEq(LibBit.toUint(true), 1);
    }
}