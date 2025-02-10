// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {SafeCastLib} from "../src/utils/SafeCastLib.sol";

contract SafeCastLibTest is Test {
    function testSafeCastToUint8(uint256 x) public {
        if (x < 256) {
            assertEq(uint8(x), SafeCastLib.toUint8(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint8(x);
        }
    }

    function testSafeCastToUint16(uint256 x) public {
        if (x < 65536) {
            assertEq(uint16(x), SafeCastLib.toUint16(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint16(x);
        }
    }

    function testSafeCastToUint32(uint256 x) public {
        if (x < 2**32) {
            assertEq(uint32(x), SafeCastLib.toUint32(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint32(x);
        }
    }

    function testSafeCastToUint64(uint256 x) public {
        if (x < 2**64) {
            assertEq(uint64(x), SafeCastLib.toUint64(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint64(x);
        }
    }

    function testSafeCastToUint128(uint256 x) public {
        if (x < 2**128) {
            assertEq(uint128(x), SafeCastLib.toUint128(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint128(x);
        }
    }

    function testSafeCastToInt8(int256 x) public {
        if (x >= -128 && x <= 127) {
            assertEq(int8(x), SafeCastLib.toInt8(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt8(x);
        }
    }

    function testSafeCastToInt16(int256 x) public {
        if (x >= -32768 && x <= 32767) {
            assertEq(int16(x), SafeCastLib.toInt16(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt16(x);
        }
    }

    function testSafeCastToInt32(int256 x) public {
        if (x >= -2**31 && x <= 2**31 - 1) {
            assertEq(int32(x), SafeCastLib.toInt32(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt32(x);
        }
    }

    function testSafeCastToInt64(int256 x) public {
        if (x >= -2**63 && x <= 2**63 - 1) {
            assertEq(int64(x), SafeCastLib.toInt64(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt64(x);
        }
    }

    function testSafeCastToInt128(int256 x) public {
        if (x >= -2**127 && x <= 2**127 - 1) {
            assertEq(int128(x), SafeCastLib.toInt128(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt128(x);
        }
    }

    function testSafeCastToInt256(uint256 x) public {
        if (x < 2**255) {
            assertEq(int256(x), SafeCastLib.toInt256(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toInt256(x);
        }
    }

    function testSafeCastToUint256(int256 x) public {
        if (x >= 0) {
            assertEq(uint256(x), SafeCastLib.toUint256(x));
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            SafeCastLib.toUint256(x);
        }
    }
}