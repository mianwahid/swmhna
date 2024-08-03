//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/SafeCastLib.sol";
//contract SafeCastLibTest is Test {
//    using SafeCastLib for uint256;
//    using SafeCastLib for int256;
//
//    function testToUint8(uint256 x) public {
//        if (x >= 2 ** 8) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint8 y = x.toUint8();
//        assertEq(x, y);
//    }
//
//    function testToUint16(uint256 x) public {
//        if (x >= 2 ** 16) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint16 y = x.toUint16();
//        assertEq(x, y);
//    }
//
//    function testToUint24(uint256 x) public {
//        if (x >= 2 ** 24) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint24 y = x.toUint24();
//        assertEq(x, y);
//    }
//
//    function testToUint32(uint256 x) public {
//        if (x >= 2 ** 32) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint32 y = x.toUint32();
//        assertEq(x, y);
//    }
//
//    function testToUint40(uint256 x) public {
//        if (x >= 2 ** 40) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint40 y = x.toUint40();
//        assertEq(x, y);
//    }
//
//    function testToUint48(uint256 x) public {
//        if (x >= 2 ** 48) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint48 y = x.toUint48();
//        assertEq(x, y);
//    }
//
//    function testToUint56(uint256 x) public {
//        if (x >= 2 ** 56) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint56 y = x.toUint56();
//        assertEq(x, y);
//    }
//
//    function testToUint64(uint256 x) public {
//        if (x >= 2 ** 64) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint64 y = x.toUint64();
//        assertEq(x, y);
//    }
//
//    function testToUint72(uint256 x) public {
//        if (x >= 2 ** 72) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint72 y = x.toUint72();
//        assertEq(x, y);
//    }
//
//    function testToUint80(uint256 x) public {
//        if (x >= 2 ** 80) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint80 y = x.toUint80();
//        assertEq(x, y);
//    }
//
//    function testToUint88(uint256 x) public {
//        if (x >= 2 ** 88) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint88 y = x.toUint88();
//        assertEq(x, y);
//    }
//
//    function testToUint96(uint256 x) public {
//        if (x >= 2 ** 96) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint96 y = x.toUint96();
//        assertEq(x, y);
//    }
//
//    function testToUint104(uint256 x) public {
//        if (x >= 2 ** 104) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint104 y = x.toUint104();
//        assertEq(x, y);
//    }
//
//    function testToUint112(uint256 x) public {
//        if (x >= 2 ** 112) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint112 y = x.toUint112();
//        assertEq(x, y);
//    }
//
//    function testToUint120(uint256 x) public {
//        if (x >= 2 ** 120) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint120 y = x.toUint120();
//        assertEq(x, y);
//    }
//
//    function testToUint128(uint256 x) public {
//        if (x >= 2 ** 128) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint128 y = x.toUint128();
//        assertEq(x, y);
//    }
//
//    function testToUint136(uint256 x) public {
//        if (x >= 2 ** 136) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint136 y = x.toUint136();
//        assertEq(x, y);
//    }
//
//    function testToUint144(uint256 x) public {
//        if (x >= 2 ** 144) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint144 y = x.toUint144();
//        assertEq(x, y);
//    }
//
//    function testToUint152(uint256 x) public {
//        if (x >= 2 ** 152) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint152 y = x.toUint152();
//        assertEq(x, y);
//    }
//
//    function testToUint160(uint256 x) public {
//        if (x >= 2 ** 160) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint160 y = x.toUint160();
//        assertEq(x, y);
//    }
//
//    function testToUint168(uint256 x) public {
//        if (x >= 2 ** 168) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint168 y = x.toUint168();
//        assertEq(x, y);
//    }
//
//    function testToUint176(uint256 x) public {
//        if (x >= 2 ** 176) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint176 y = x.toUint176();
//        assertEq(x, y);
//    }
//
//    function testToUint184(uint256 x) public {
//        if (x >= 2 ** 184) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint184 y = x.toUint184();
//        assertEq(x, y);
//    }
//
//    function testToUint192(uint256 x) public {
//        if (x >= 2 ** 192) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint192 y = x.toUint192();
//        assertEq(x, y);
//    }
//
//    function testToUint200(uint256 x) public {
//        if (x >= 2 ** 200) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint200 y = x.toUint200();
//        assertEq(x, y);
//    }
//
//    function testToUint208(uint256 x) public {
//        if (x >= 2 ** 208) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint208 y = x.toUint208();
//        assertEq(x, y);
//    }
//
//    function testToUint216(uint256 x) public {
//        if (x >= 2 ** 216) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint216 y = x.toUint216();
//        assertEq(x, y);
//    }
//
//    function testToUint224(uint256 x) public {
//        if (x >= 2 ** 224) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint224 y = x.toUint224();
//        assertEq(x, y);
//    }
//
//    function testToUint232(uint256 x) public {
//        if (x >= 2 ** 232) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint232 y = x.toUint232();
//        assertEq(x, y);
//    }
//
//    function testToUint240(uint256 x) public {
//        if (x >= 2 ** 240) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint240 y = x.toUint240();
//        assertEq(x, y);
//    }
//
//    function testToUint248(uint256 x) public {
//        if (x >= 2 ** 248) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint248 y = x.toUint248();
//        assertEq(x, y);
//    }
//
//    function testToInt8(int256 x) public {
//        int8 y = int8(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int8 z = x.toInt8();
//        assertEq(y, z);
//    }
//
//    function testToInt16(int256 x) public {
//        int16 y = int16(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int16 z = x.toInt16();
//        assertEq(y, z);
//    }
//
//    function testToInt24(int256 x) public {
//        int24 y = int24(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int24 z = x.toInt24();
//        assertEq(y, z);
//    }
//
//    function testToInt32(int256 x) public {
//        int32 y = int32(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int32 z = x.toInt32();
//        assertEq(y, z);
//    }
//
//    function testToInt40(int256 x) public {
//        int40 y = int40(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int40 z = x.toInt40();
//        assertEq(y, z);
//    }
//
//    function testToInt48(int256 x) public {
//        int48 y = int48(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int48 z = x.toInt48();
//        assertEq(y, z);
//    }
//
//    function testToInt56(int256 x) public {
//        int56 y = int56(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int56 z = x.toInt56();
//        assertEq(y, z);
//    }
//
//    function testToInt64(int256 x) public {
//        int64 y = int64(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int64 z = x.toInt64();
//        assertEq(y, z);
//    }
//
//    function testToInt72(int256 x) public {
//        int72 y = int72(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int72 z = x.toInt72();
//        assertEq(y, z);
//    }
//
//    function testToInt80(int256 x) public {
//        int80 y = int80(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int80 z = x.toInt80();
//        assertEq(y, z);
//    }
//
//    function testToInt88(int256 x) public {
//        int88 y = int88(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int88 z = x.toInt88();
//        assertEq(y, z);
//    }
//
//    function testToInt96(int256 x) public {
//        int96 y = int96(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int96 z = x.toInt96();
//        assertEq(y, z);
//    }
//
//    function testToInt104(int256 x) public {
//        int104 y = int104(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int104 z = x.toInt104();
//        assertEq(y, z);
//    }
//
//    function testToInt112(int256 x) public {
//        int112 y = int112(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int112 z = x.toInt112();
//        assertEq(y, z);
//    }
//
//    function testToInt120(int256 x) public {
//        int120 y = int120(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int120 z = x.toInt120();
//        assertEq(y, z);
//    }
//
//    function testToInt128(int256 x) public {
//        int128 y = int128(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int128 z = x.toInt128();
//        assertEq(y, z);
//    }
//
//    function testToInt136(int256 x) public {
//        int136 y = int136(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int136 z = x.toInt136();
//        assertEq(y, z);
//    }
//
//    function testToInt144(int256 x) public {
//        int144 y = int144(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int144 z = x.toInt144();
//        assertEq(y, z);
//    }
//
//    function testToInt152(int256 x) public {
//        int152 y = int152(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int152 z = x.toInt152();
//        assertEq(y, z);
//    }
//
//    function testToInt160(int256 x) public {
//        int160 y = int160(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int160 z = x.toInt160();
//        assertEq(y, z);
//    }
//
//    function testToInt168(int256 x) public {
//        int168 y = int168(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int168 z = x.toInt168();
//        assertEq(y, z);
//    }
//
//    function testToInt176(int256 x) public {
//        int176 y = int176(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int176 z = x.toInt176();
//        assertEq(y, z);
//    }
//
//    function testToInt184(int256 x) public {
//        int184 y = int184(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int184 z = x.toInt184();
//        assertEq(y, z);
//    }
//
//    function testToInt192(int256 x) public {
//        int192 y = int192(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int192 z = x.toInt192();
//        assertEq(y, z);
//    }
//
//    function testToInt200(int256 x) public {
//        int200 y = int200(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int200 z = x.toInt200();
//        assertEq(y, z);
//    }
//
//    function testToInt208(int256 x) public {
//        int208 y = int208(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int208 z = x.toInt208();
//        assertEq(y, z);
//    }
//
//    function testToInt216(int256 x) public {
//        int216 y = int216(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int216 z = x.toInt216();
//        assertEq(y, z);
//    }
//
//    function testToInt224(int256 x) public {
//        int224 y = int224(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int224 z = x.toInt224();
//        assertEq(y, z);
//    }
//
//    function testToInt232(int256 x) public {
//        int232 y = int232(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int232 z = x.toInt232();
//        assertEq(y, z);
//    }
//
//    function testToInt240(int256 x) public {
//        int240 y = int240(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int240 z = x.toInt240();
//        assertEq(y, z);
//    }
//
//    function testToInt248(int256 x) public {
//        int248 y = int248(x);
//        if (x != y) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int248 z = x.toInt248();
//        assertEq(y, z);
//    }
//
//    function testToInt256(uint256 x) public {
//        if (x >= 2 ** 255) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        int256 y = x.toInt256();
//        assertEq(int256(x), y);
//    }
//
//    function testToUint256(int256 x) public {
//        if (x < 0) {
//            vm.expectRevert(SafeCastLib.Overflow.selector);
//        }
//        uint256 y = x.toUint256();
//        assertEq(uint256(x), y);
//    }
//}
