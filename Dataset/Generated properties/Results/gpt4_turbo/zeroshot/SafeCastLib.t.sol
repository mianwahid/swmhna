// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/SafeCastLib.sol";

contract SafeCastLibTest is Test {
    function testToUint8(uint256 x) public {
        if (x < 256) {
            assertEq(SafeCastLib.toUint8(x), uint8(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint8(x);
        }
    }

    function testToUint16(uint256 x) public {
        if (x < 65536) {
            assertEq(SafeCastLib.toUint16(x), uint16(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint16(x);
        }
    }

    function testToUint32(uint256 x) public {
        if (x < 2**32) {
            assertEq(SafeCastLib.toUint32(x), uint32(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint32(x);
        }
    }

    function testToUint64(uint256 x) public {
        if (x < 2**64) {
            assertEq(SafeCastLib.toUint64(x), uint64(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint64(x);
        }
    }

    function testToInt8(int256 x) public {
        if (x >= -128 && x <= 127) {
            assertEq(SafeCastLib.toInt8(x), int8(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt8(x);
        }
    }

    function testToInt16(int256 x) public {
        if (x >= -32768 && x <= 32767) {
            assertEq(SafeCastLib.toInt16(x), int16(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt16(x);
        }
    }

    function testToInt32(int256 x) public {
        if (x >= -2**31 && x <= 2**31 - 1) {
            assertEq(SafeCastLib.toInt32(x), int32(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt32(x);
        }
    }

    function testToInt64(int256 x) public {
        if (x >= -2**63 && x <= 2**63 - 1) {
            assertEq(SafeCastLib.toInt64(x), int64(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt64(x);
        }
    }

    function testToInt256(uint256 x) public {
        if (x < 2**255) {
            assertEq(SafeCastLib.toInt256(x), int256(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt256(x);
        }
    }

    function testToUint256(int256 x) public {
        if (x >= 0) {
            assertEq(SafeCastLib.toUint256(x), uint256(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint256(x);
        }
    }

    function testEdgeCases() public {
        // Test edge cases for unsigned to signed conversion
        testToInt8(127);
        testToInt8(-128);
        testToInt16(32767);
        testToInt16(-32768);
        testToInt32(2147483647);
        testToInt32(-2147483648);
        testToInt64(9223372036854775807);
        testToInt64(-9223372036854775808);

        // Test edge cases for signed to unsigned conversion
        testToUint8(255);
        testToUint16(65535);
        testToUint32(4294967295);
        testToUint64(18446744073709551615);
    }
}
