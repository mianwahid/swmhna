// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/SafeCastLib.sol";

contract SafeCastLibTest is Test {
    using SafeCastLib for uint256;
    using SafeCastLib for int256;

    function testToUint8(uint256 x) public {
        uint8 maxUint8 = type(uint8).max;
        if (x < (1 << 8)) {
            assertEq(uint8(x), x.toUint8());
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toUint8();
        }
        if (x == maxUint8) {
            assertEq(uint8(x), x.toUint8());
        }
        if (x == (1 << 8)) {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toUint8();
        }
    }

    function testToUint16(uint256 x) public {
        uint16 maxUint16 = type(uint16).max;
        if (x < (1 << 16)) {
            assertEq(uint16(x), x.toUint16());
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toUint16();
        }
        if (x == maxUint16) {
            assertEq(uint16(x), x.toUint16());
        }
        if (x == (1 << 16)) {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toUint16();
        }
    }

    // Repeat similar tests for other toUintX functions...

    function testToInt8(int256 x) public {
        int8 minInt8 = type(int8).min;
        int8 maxInt8 = type(int8).max;
        if (x >= -128 && x <= 127) {
            assertEq(int8(x), x.toInt8());
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toInt8();
        }
        if (x == minInt8 || x == maxInt8) {
            assertEq(int8(x), x.toInt8());
        }
        if (x == -129 || x == 128) {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toInt8();
        }
    }

    function testToInt16(int256 x) public {
        int16 minInt16 = type(int16).min;
        int16 maxInt16 = type(int16).max;
        if (x >= -32768 && x <= 32767) {
            assertEq(int16(x), x.toInt16());
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toInt16();
        }
        if (x == minInt16 || x == maxInt16) {
            assertEq(int16(x), x.toInt16());
        }
        if (x == -32769 || x == 32768) {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toInt16();
        }
    }

    // Repeat similar tests for other toIntX functions...

    function testToInt256(uint256 x) public {
        if (x < (1 << 255)) {
            assertEq(int256(x), x.toInt256());
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toInt256();
        }
    }

    function testToUint256(int256 x) public {
        if (x >= 0) {
            assertEq(uint256(x), x.toUint256());
        } else {
            vm.expectRevert(SafeCastLib.Overflow.selector);
            x.toUint256();
        }
    }

    function testZeroValues() public {
        assertEq(uint256(0).toUint8(), 0);
        assertEq(int256(0).toInt8(), 0);
        // assertEq(uint256(0).toUint256(), 0);
        assertEq(int256(0).toUint256(), 0);
    }

    // function testNegativeValues() public {
    //     vm.expectRevert(SafeCastLib.Overflow.selector);
    //     // (-1).toUint256();
    // }

    // function testInlineAssemblyRevert() public {
    //     vm.expectRevert(SafeCastLib.Overflow.selector);
    //     // SafeCastLib._revertOverflow();
    // }
}
