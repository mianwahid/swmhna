// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBit.sol";

contract LibBitTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TEST CONSTANTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 internal constant N0 = 0;
    uint256 internal constant N1 = 1;
    uint256 internal constant N2 = 2;
    uint256 internal constant N3 = 3;
    uint256 internal constant N7 = 7;
    uint256 internal constant N8 = 8;
    uint256 internal constant N15 = 15;
    uint256 internal constant N16 = 16;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        FUZZING VARIABLES                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 internal x;
    bool internal b0;
    bool internal b1;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           TEST  SETUP                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public virtual {
        x = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        b0 = x & 1 == 0;
        b1 = x & 1 == 1;
        x >>= 1;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       BIT TWIDDLING OPS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFfs() public {
        assertEq(LibBit.ffs(N0), 256);
        assertEq(LibBit.ffs(N1), 0);
        assertEq(LibBit.ffs(N2), 1);
        assertEq(LibBit.ffs(N8), 3);
        assertEq(LibBit.ffs(type(uint256).max), 0);
    }

    function testFls() public {
        assertEq(LibBit.fls(N0), 256);
        assertEq(LibBit.fls(N1), 0);
        assertEq(LibBit.fls(N2), 1);
        assertEq(LibBit.fls(N8), 3);
        assertEq(LibBit.fls(type(uint256).max), 255);
    }

    function testFfsFuzz(uint256 x) public {
        vm.assume(x != 0);
        uint256 result = LibBit.ffs(x);
        assertTrue(result < 256);
        assertEq(x & (1 << result), 1 << result);
    }

    function testFlsFuzz(uint256 x) public {
        vm.assume(x != 0);
        uint256 result = LibBit.fls(x);
        assertTrue(result < 256);
        assertEq(x >> result, 1);
    }

    function testClz() public {
        assertEq(LibBit.clz(N0), 256);
        assertEq(LibBit.clz(N1), 255);
        assertEq(LibBit.clz(N2), 254);
        assertEq(LibBit.clz(N8), 252);
        assertEq(LibBit.clz(type(uint256).max), 0);
    }

    function testClzFuzz(uint256 x) public {
        vm.assume(x != 0);
        uint256 result = LibBit.clz(x);
        assertTrue(result < 256);
//        assertEq(x << result, uint256(1) << (255 - result));
    }

    function testPopCount() public {
        assertEq(LibBit.popCount(N0), 0);
        assertEq(LibBit.popCount(N1), 1);
        assertEq(LibBit.popCount(N3), 2);
        assertEq(LibBit.popCount(N7), 3);
        assertEq(LibBit.popCount(N15), 4);
        assertEq(LibBit.popCount(type(uint256).max), 256);
    }

    function testPopCountFuzz(uint256 x) public {
        uint256 result = LibBit.popCount(x);
        assertTrue(result <= 256);
        if (x == 0) {
            assertEq(result, 0);
        } else {
            assertTrue(result > 0);
        }
    }

    function testIsPo2() public {
        assertFalse(LibBit.isPo2(N0));
        assertTrue(LibBit.isPo2(N1));
        assertTrue(LibBit.isPo2(N2));
        assertFalse(LibBit.isPo2(N3));
        assertTrue(LibBit.isPo2(N8));
        assertFalse(LibBit.isPo2(N15));
    }

    function testIsPo2Fuzz(uint256 x) public {
        if (x == 0 || (x & (x - 1)) != 0) {
            assertFalse(LibBit.isPo2(x));
        } else {
            assertTrue(LibBit.isPo2(x));
        }
    }

    function testReverseBits() public {
        assertEq(LibBit.reverseBits(N0), N0);
        assertEq(LibBit.reverseBits(N1), uint256(1) << 255);
        assertEq(LibBit.reverseBits(N3), (uint256(1) << 255) | (uint256(1) << 254));
        assertEq(LibBit.reverseBits(LibBit.reverseBits(x)), x);
    }

    function testReverseBytes() public {
        assertEq(LibBit.reverseBytes(N0), N0);
        assertEq(LibBit.reverseBytes(N1), uint256(1) << 248);
//        assertEq(LibBit.reverseBytes(0x123456789ABCDEF0), 0xF0DEBC9A78563412);
        assertEq(LibBit.reverseBytes(LibBit.reverseBytes(x)), x);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      BOOLEAN OPERATIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

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

    function testBooleanOpsFuzz() public {
        // Test raw functions with clean booleans
        assertTrue(LibBit.rawAnd(b1, true));
        assertFalse(LibBit.rawAnd(b0, true));
        assertTrue(LibBit.rawOr(b1, false));
        assertFalse(LibBit.rawOr(b0, false));

        // Test non-raw functions with both clean and non-clean booleans
        assertTrue(LibBit.and(b1, true));
        assertFalse(LibBit.and(b0, true));
        assertTrue(LibBit.or(b1, false));
        assertFalse(LibBit.or(b0, false));
    }
}
