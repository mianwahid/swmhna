// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeCastLib.sol";
contract SafeCastLibTest is Test {
    function testToUint8() public {
        assertEq(SafeCastLib.toUint8(0), 0);
        assertEq(SafeCastLib.toUint8(1), 1);
        assertEq(SafeCastLib.toUint8(255), 255);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint8(256);
    }

    function testToUint16() public {
        assertEq(SafeCastLib.toUint16(0), 0);
        assertEq(SafeCastLib.toUint16(1), 1);
        assertEq(SafeCastLib.toUint16(2**16 - 1), 2**16 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint16(2**16);
    }

    function testToUint24() public {
        assertEq(SafeCastLib.toUint24(0), 0);
        assertEq(SafeCastLib.toUint24(1), 1);
        assertEq(SafeCastLib.toUint24(2**24 - 1), 2**24 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint24(2**24);
    }

    function testToUint32() public {
        assertEq(SafeCastLib.toUint32(0), 0);
        assertEq(SafeCastLib.toUint32(1), 1);
        assertEq(SafeCastLib.toUint32(2**32 - 1), 2**32 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint32(2**32);
    }

    function testToUint40() public {
        assertEq(SafeCastLib.toUint40(0), 0);
        assertEq(SafeCastLib.toUint40(1), 1);
        assertEq(SafeCastLib.toUint40(2**40 - 1), 2**40 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint40(2**40);
    }

    function testToUint48() public {
        assertEq(SafeCastLib.toUint48(0), 0);
        assertEq(SafeCastLib.toUint48(1), 1);
        assertEq(SafeCastLib.toUint48(2**48 - 1), 2**48 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint48(2**48);
    }

    function testToUint56() public {
        assertEq(SafeCastLib.toUint56(0), 0);
        assertEq(SafeCastLib.toUint56(1), 1);
        assertEq(SafeCastLib.toUint56(2**56 - 1), 2**56 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint56(2**56);
    }

    function testToUint64() public {
        assertEq(SafeCastLib.toUint64(0), 0);
        assertEq(SafeCastLib.toUint64(1), 1);
        assertEq(SafeCastLib.toUint64(2**64 - 1), 2**64 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint64(2**64);
    }

    function testToUint72() public {
        assertEq(SafeCastLib.toUint72(0), 0);
        assertEq(SafeCastLib.toUint72(1), 1);
        assertEq(SafeCastLib.toUint72(2**72 - 1), 2**72 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint72(2**72);
    }

    function testToUint80() public {
        assertEq(SafeCastLib.toUint80(0), 0);
        assertEq(SafeCastLib.toUint80(1), 1);
        assertEq(SafeCastLib.toUint80(2**80 - 1), 2**80 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint80(2**80);
    }

    function testToUint88() public {
        assertEq(SafeCastLib.toUint88(0), 0);
        assertEq(SafeCastLib.toUint88(1), 1);
        assertEq(SafeCastLib.toUint88(2**88 - 1), 2**88 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint88(2**88);
    }

    function testToUint96() public {
        assertEq(SafeCastLib.toUint96(0), 0);
        assertEq(SafeCastLib.toUint96(1), 1);
        assertEq(SafeCastLib.toUint96(2**96 - 1), 2**96 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint96(2**96);
    }

    function testToUint104() public {
        assertEq(SafeCastLib.toUint104(0), 0);
        assertEq(SafeCastLib.toUint104(1), 1);
        assertEq(SafeCastLib.toUint104(2**104 - 1), 2**104 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint104(2**104);
    }

    function testToUint112() public {
        assertEq(SafeCastLib.toUint112(0), 0);
        assertEq(SafeCastLib.toUint112(1), 1);
        assertEq(SafeCastLib.toUint112(2**112 - 1), 2**112 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint112(2**112);
    }

    function testToUint120() public {
        assertEq(SafeCastLib.toUint120(0), 0);
        assertEq(SafeCastLib.toUint120(1), 1);
        assertEq(SafeCastLib.toUint120(2**120 - 1), 2**120 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint120(2**120);
    }

    function testToUint128() public {
        assertEq(SafeCastLib.toUint128(0), 0);
        assertEq(SafeCastLib.toUint128(1), 1);
        assertEq(SafeCastLib.toUint128(2**128 - 1), 2**128 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint128(2**128);
    }

    function testToUint136() public {
        assertEq(SafeCastLib.toUint136(0), 0);
        assertEq(SafeCastLib.toUint136(1), 1);
        assertEq(SafeCastLib.toUint136(2**136 - 1), 2**136 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint136(2**136);
    }

    function testToUint144() public {
        assertEq(SafeCastLib.toUint144(0), 0);
        assertEq(SafeCastLib.toUint144(1), 1);
        assertEq(SafeCastLib.toUint144(2**144 - 1), 2**144 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint144(2**144);
    }

    function testToUint152() public {
        assertEq(SafeCastLib.toUint152(0), 0);
        assertEq(SafeCastLib.toUint152(1), 1);
        assertEq(SafeCastLib.toUint152(2**152 - 1), 2**152 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint152(2**152);
    }

    function testToUint160() public {
        assertEq(SafeCastLib.toUint160(0), 0);
        assertEq(SafeCastLib.toUint160(1), 1);
        assertEq(SafeCastLib.toUint160(2**160 - 1), 2**160 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint160(2**160);
    }

    function testToUint168() public {
        assertEq(SafeCastLib.toUint168(0), 0);
        assertEq(SafeCastLib.toUint168(1), 1);
        assertEq(SafeCastLib.toUint168(2**168 - 1), 2**168 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint168(2**168);
    }

    function testToUint176() public {
        assertEq(SafeCastLib.toUint176(0), 0);
        assertEq(SafeCastLib.toUint176(1), 1);
        assertEq(SafeCastLib.toUint176(2**176 - 1), 2**176 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint176(2**176);
    }

    function testToUint184() public {
        assertEq(SafeCastLib.toUint184(0), 0);
        assertEq(SafeCastLib.toUint184(1), 1);
        assertEq(SafeCastLib.toUint184(2**184 - 1), 2**184 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint184(2**184);
    }

    function testToUint192() public {
        assertEq(SafeCastLib.toUint192(0), 0);
        assertEq(SafeCastLib.toUint192(1), 1);
        assertEq(SafeCastLib.toUint192(2**192 - 1), 2**192 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint192(2**192);
    }

    function testToUint200() public {
        assertEq(SafeCastLib.toUint200(0), 0);
        assertEq(SafeCastLib.toUint200(1), 1);
        assertEq(SafeCastLib.toUint200(2**200 - 1), 2**200 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint200(2**200);
    }

    function testToUint208() public {
        assertEq(SafeCastLib.toUint208(0), 0);
        assertEq(SafeCastLib.toUint208(1), 1);
        assertEq(SafeCastLib.toUint208(2**208 - 1), 2**208 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint208(2**208);
    }

    function testToUint216() public {
        assertEq(SafeCastLib.toUint216(0), 0);
        assertEq(SafeCastLib.toUint216(1), 1);
        assertEq(SafeCastLib.toUint216(2**216 - 1), 2**216 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint216(2**216);
    }

    function testToUint224() public {
        assertEq(SafeCastLib.toUint224(0), 0);
        assertEq(SafeCastLib.toUint224(1), 1);
        assertEq(SafeCastLib.toUint224(2**224 - 1), 2**224 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint224(2**224);
    }

    function testToUint232() public {
        assertEq(SafeCastLib.toUint232(0), 0);
        assertEq(SafeCastLib.toUint232(1), 1);
        assertEq(SafeCastLib.toUint232(2**232 - 1), 2**232 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint232(2**232);
    }

    function testToUint240() public {
        assertEq(SafeCastLib.toUint240(0), 0);
        assertEq(SafeCastLib.toUint240(1), 1);
        assertEq(SafeCastLib.toUint240(2**240 - 1), 2**240 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint240(2**240);
    }

    function testToUint248() public {
        assertEq(SafeCastLib.toUint248(0), 0);
        assertEq(SafeCastLib.toUint248(1), 1);
        assertEq(SafeCastLib.toUint248(2**248 - 1), 2**248 - 1);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toUint248(2**248);
    }

    function testToInt8() public {
        assertEq(SafeCastLib.toInt8(0), 0);
        assertEq(SafeCastLib.toInt8(1), 1);
        assertEq(SafeCastLib.toInt8(-1), -1);
        assertEq(SafeCastLib.toInt8(2**7 - 1), 2**7 - 1);
        assertEq(SafeCastLib.toInt8(-2**7), -2**7);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt8(2**7);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt8(-2**7 - 1);
    }

    function testToInt16() public {
        assertEq(SafeCastLib.toInt16(0), 0);
        assertEq(SafeCastLib.toInt16(1), 1);
        assertEq(SafeCastLib.toInt16(-1), -1);
        assertEq(SafeCastLib.toInt16(2**15 - 1), 2**15 - 1);
        assertEq(SafeCastLib.toInt16(-2**15), -2**15);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt16(2**15);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt16(-2**15 - 1);
    }

    function testToInt24() public {
        assertEq(SafeCastLib.toInt24(0), 0);
        assertEq(SafeCastLib.toInt24(1), 1);
        assertEq(SafeCastLib.toInt24(-1), -1);
        assertEq(SafeCastLib.toInt24(2**23 - 1), 2**23 - 1);
        assertEq(SafeCastLib.toInt24(-2**23), -2**23);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt24(2**23);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt24(-2**23 - 1);
    }

    function testToInt32() public {
        assertEq(SafeCastLib.toInt32(0), 0);
        assertEq(SafeCastLib.toInt32(1), 1);
        assertEq(SafeCastLib.toInt32(-1), -1);
        assertEq(SafeCastLib.toInt32(2**31 - 1), 2**31 - 1);
        assertEq(SafeCastLib.toInt32(-2**31), -2**31);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt32(2**31);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt32(-2**31 - 1);
    }

    function testToInt40() public {
        assertEq(SafeCastLib.toInt40(0), 0);
        assertEq(SafeCastLib.toInt40(1), 1);
        assertEq(SafeCastLib.toInt40(-1), -1);
        assertEq(SafeCastLib.toInt40(2**39 - 1), 2**39 - 1);
        assertEq(SafeCastLib.toInt40(-2**39), -2**39);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt40(2**39);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt40(-2**39 - 1);
    }

    function testToInt48() public {
        assertEq(SafeCastLib.toInt48(0), 0);
        assertEq(SafeCastLib.toInt48(1), 1);
        assertEq(SafeCastLib.toInt48(-1), -1);
        assertEq(SafeCastLib.toInt48(2**47 - 1), 2**47 - 1);
        assertEq(SafeCastLib.toInt48(-2**47), -2**47);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt48(2**47);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt48(-2**47 - 1);
    }

    function testToInt56() public {
        assertEq(SafeCastLib.toInt56(0), 0);
        assertEq(SafeCastLib.toInt56(1), 1);
        assertEq(SafeCastLib.toInt56(-1), -1);
        assertEq(SafeCastLib.toInt56(2**55 - 1), 2**55 - 1);
        assertEq(SafeCastLib.toInt56(-2**55), -2**55);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt56(2**55);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt56(-2**55 - 1);
    }

    function testToInt64() public {
        assertEq(SafeCastLib.toInt64(0), 0);
        assertEq(SafeCastLib.toInt64(1), 1);
        assertEq(SafeCastLib.toInt64(-1), -1);
        assertEq(SafeCastLib.toInt64(2**63 - 1), 2**63 - 1);
        assertEq(SafeCastLib.toInt64(-2**63), -2**63);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt64(2**63);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt64(-2**63 - 1);
    }

    function testToInt72() public {
        assertEq(SafeCastLib.toInt72(0), 0);
        assertEq(SafeCastLib.toInt72(1), 1);
        assertEq(SafeCastLib.toInt72(-1), -1);
        assertEq(SafeCastLib.toInt72(2**71 - 1), 2**71 - 1);
        assertEq(SafeCastLib.toInt72(-2**71), -2**71);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt72(2**71);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt72(-2**71 - 1);
    }

    function testToInt80() public {
        assertEq(SafeCastLib.toInt80(0), 0);
        assertEq(SafeCastLib.toInt80(1), 1);
        assertEq(SafeCastLib.toInt80(-1), -1);
        assertEq(SafeCastLib.toInt80(2**79 - 1), 2**79 - 1);
        assertEq(SafeCastLib.toInt80(-2**79), -2**79);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt80(2**79);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt80(-2**79 - 1);
    }

    function testToInt88() public {
        assertEq(SafeCastLib.toInt88(0), 0);
        assertEq(SafeCastLib.toInt88(1), 1);
        assertEq(SafeCastLib.toInt88(-1), -1);
        assertEq(SafeCastLib.toInt88(2**87 - 1), 2**87 - 1);
        assertEq(SafeCastLib.toInt88(-2**87), -2**87);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt88(2**87);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt88(-2**87 - 1);
    }

    function testToInt96() public {
        assertEq(SafeCastLib.toInt96(0), 0);
        assertEq(SafeCastLib.toInt96(1), 1);
        assertEq(SafeCastLib.toInt96(-1), -1);
        assertEq(SafeCastLib.toInt96(2**95 - 1), 2**95 - 1);
        assertEq(SafeCastLib.toInt96(-2**95), -2**95);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt96(2**95);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt96(-2**95 - 1);
    }

    function testToInt104() public {
        assertEq(SafeCastLib.toInt104(0), 0);
        assertEq(SafeCastLib.toInt104(1), 1);
        assertEq(SafeCastLib.toInt104(-1), -1);
        assertEq(SafeCastLib.toInt104(2**103 - 1), 2**103 - 1);
        assertEq(SafeCastLib.toInt104(-2**103), -2**103);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt104(2**103);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt104(-2**103 - 1);
    }

    function testToInt112() public {
        assertEq(SafeCastLib.toInt112(0), 0);
        assertEq(SafeCastLib.toInt112(1), 1);
        assertEq(SafeCastLib.toInt112(-1), -1);
        assertEq(SafeCastLib.toInt112(2**111 - 1), 2**111 - 1);
        assertEq(SafeCastLib.toInt112(-2**111), -2**111);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt112(2**111);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt112(-2**111 - 1);
    }

    function testToInt120() public {
        assertEq(SafeCastLib.toInt120(0), 0);
        assertEq(SafeCastLib.toInt120(1), 1);
        assertEq(SafeCastLib.toInt120(-1), -1);
        assertEq(SafeCastLib.toInt120(2**119 - 1), 2**119 - 1);
        assertEq(SafeCastLib.toInt120(-2**119), -2**119);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt120(2**119);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt120(-2**119 - 1);
    }

    function testToInt128() public {
        assertEq(SafeCastLib.toInt128(0), 0);
        assertEq(SafeCastLib.toInt128(1), 1);
        assertEq(SafeCastLib.toInt128(-1), -1);
        assertEq(SafeCastLib.toInt128(2**127 - 1), 2**127 - 1);
        assertEq(SafeCastLib.toInt128(-2**127), -2**127);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt128(2**127);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt128(-2**127 - 1);
    }

    function testToInt136() public {
        assertEq(SafeCastLib.toInt136(0), 0);
        assertEq(SafeCastLib.toInt136(1), 1);
        assertEq(SafeCastLib.toInt136(-1), -1);
        assertEq(SafeCastLib.toInt136(2**135 - 1), 2**135 - 1);
        assertEq(SafeCastLib.toInt136(-2**135), -2**135);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt136(2**135);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt136(-2**135 - 1);
    }

    function testToInt144() public {
        assertEq(SafeCastLib.toInt144(0), 0);
        assertEq(SafeCastLib.toInt144(1), 1);
        assertEq(SafeCastLib.toInt144(-1), -1);
        assertEq(SafeCastLib.toInt144(2**143 - 1), 2**143 - 1);
        assertEq(SafeCastLib.toInt144(-2**143), -2**143);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt144(2**143);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt144(-2**143 - 1);
    }

    function testToInt152() public {
        assertEq(SafeCastLib.toInt152(0), 0);
        assertEq(SafeCastLib.toInt152(1), 1);
        assertEq(SafeCastLib.toInt152(-1), -1);
        assertEq(SafeCastLib.toInt152(2**151 - 1), 2**151 - 1);
        assertEq(SafeCastLib.toInt152(-2**151), -2**151);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt152(2**151);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt152(-2**151 - 1);
    }

    function testToInt160() public {
        assertEq(SafeCastLib.toInt160(0), 0);
        assertEq(SafeCastLib.toInt160(1), 1);
        assertEq(SafeCastLib.toInt160(-1), -1);
        assertEq(SafeCastLib.toInt160(2**159 - 1), 2**159 - 1);
        assertEq(SafeCastLib.toInt160(-2**159), -2**159);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt160(2**159);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt160(-2**159 - 1);
    }

    function testToInt168() public {
        assertEq(SafeCastLib.toInt168(0), 0);
        assertEq(SafeCastLib.toInt168(1), 1);
        assertEq(SafeCastLib.toInt168(-1), -1);
        assertEq(SafeCastLib.toInt168(2**167 - 1), 2**167 - 1);
        assertEq(SafeCastLib.toInt168(-2**167), -2**167);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt168(2**167);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt168(-2**167 - 1);
    }

    function testToInt176() public {
        assertEq(SafeCastLib.toInt176(0), 0);
        assertEq(SafeCastLib.toInt176(1), 1);
        assertEq(SafeCastLib.toInt176(-1), -1);
        assertEq(SafeCastLib.toInt176(2**175 - 1), 2**175 - 1);
        assertEq(SafeCastLib.toInt176(-2**175), -2**175);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt176(2**175);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt176(-2**175 - 1);
    }

    function testToInt184() public {
        assertEq(SafeCastLib.toInt184(0), 0);
        assertEq(SafeCastLib.toInt184(1), 1);
        assertEq(SafeCastLib.toInt184(-1), -1);
        assertEq(SafeCastLib.toInt184(2**183 - 1), 2**183 - 1);
        assertEq(SafeCastLib.toInt184(-2**183), -2**183);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt184(2**183);
        vm.expectRevert(SafeCastLib.Overflow.selector);
        SafeCastLib.toInt184(-2**183 - 1);
    }

    function testToInt192() public {
        assertEq(SafeCastLib.toInt192(0), 0);
        assertEq(SafeCastLib.toInt192(1), 1);
        assertEq(SafeCastLib.toInt192(-1), -1);
    }
}