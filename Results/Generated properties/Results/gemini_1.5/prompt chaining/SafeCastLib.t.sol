// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeCastLib.sol";
contract SafeCastLibTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    error Overflow();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  TEST FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testToUint8_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint8(type(uint256).max);
    }

    function testToUint8_Success(uint256 x) public {
        x = bound(x, 0, type(uint8).max);
        assertEq(SafeCastLib.toUint8(x), uint8(x));
    }

    function testToUint16_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint16(type(uint256).max);
    }

    function testToUint16_Success(uint256 x) public {
        x = bound(x, 0, type(uint16).max);
        assertEq(SafeCastLib.toUint16(x), uint16(x));
    }

    function testToUint24_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint24(type(uint256).max);
    }

    function testToUint24_Success(uint256 x) public {
        x = bound(x, 0, type(uint24).max);
        assertEq(SafeCastLib.toUint24(x), uint24(x));
    }

    function testToUint32_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint32(type(uint256).max);
    }

    function testToUint32_Success(uint256 x) public {
        x = bound(x, 0, type(uint32).max);
        assertEq(SafeCastLib.toUint32(x), uint32(x));
    }

    function testToUint40_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint40(type(uint256).max);
    }

    function testToUint40_Success(uint256 x) public {
        x = bound(x, 0, type(uint40).max);
        assertEq(SafeCastLib.toUint40(x), uint40(x));
    }

    function testToUint48_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint48(type(uint256).max);
    }

    function testToUint48_Success(uint256 x) public {
        x = bound(x, 0, type(uint48).max);
        assertEq(SafeCastLib.toUint48(x), uint48(x));
    }

    function testToUint56_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint56(type(uint256).max);
    }

    function testToUint56_Success(uint256 x) public {
        x = bound(x, 0, type(uint56).max);
        assertEq(SafeCastLib.toUint56(x), uint56(x));
    }

    function testToUint64_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint64(type(uint256).max);
    }

    function testToUint64_Success(uint256 x) public {
        x = bound(x, 0, type(uint64).max);
        assertEq(SafeCastLib.toUint64(x), uint64(x));
    }

    function testToUint72_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint72(type(uint256).max);
    }

    function testToUint72_Success(uint256 x) public {
        x = bound(x, 0, type(uint72).max);
        assertEq(SafeCastLib.toUint72(x), uint72(x));
    }

    function testToUint80_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint80(type(uint256).max);
    }

    function testToUint80_Success(uint256 x) public {
        x = bound(x, 0, type(uint80).max);
        assertEq(SafeCastLib.toUint80(x), uint80(x));
    }

    function testToUint88_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint88(type(uint256).max);
    }

    function testToUint88_Success(uint256 x) public {
        x = bound(x, 0, type(uint88).max);
        assertEq(SafeCastLib.toUint88(x), uint88(x));
    }

    function testToUint96_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint96(type(uint256).max);
    }

    function testToUint96_Success(uint256 x) public {
        x = bound(x, 0, type(uint96).max);
        assertEq(SafeCastLib.toUint96(x), uint96(x));
    }

    function testToUint104_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint104(type(uint256).max);
    }

    function testToUint104_Success(uint256 x) public {
        x = bound(x, 0, type(uint104).max);
        assertEq(SafeCastLib.toUint104(x), uint104(x));
    }

    function testToUint112_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint112(type(uint256).max);
    }

    function testToUint112_Success(uint256 x) public {
        x = bound(x, 0, type(uint112).max);
        assertEq(SafeCastLib.toUint112(x), uint112(x));
    }

    function testToUint120_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint120(type(uint256).max);
    }

    function testToUint120_Success(uint256 x) public {
        x = bound(x, 0, type(uint120).max);
        assertEq(SafeCastLib.toUint120(x), uint120(x));
    }

    function testToUint128_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint128(type(uint256).max);
    }

    function testToUint128_Success(uint256 x) public {
        x = bound(x, 0, type(uint128).max);
        assertEq(SafeCastLib.toUint128(x), uint128(x));
    }

    function testToUint136_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint136(type(uint256).max);
    }

    function testToUint136_Success(uint256 x) public {
        x = bound(x, 0, type(uint136).max);
        assertEq(SafeCastLib.toUint136(x), uint136(x));
    }

    function testToUint144_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint144(type(uint256).max);
    }

    function testToUint144_Success(uint256 x) public {
        x = bound(x, 0, type(uint144).max);
        assertEq(SafeCastLib.toUint144(x), uint144(x));
    }

    function testToUint152_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint152(type(uint256).max);
    }

    function testToUint152_Success(uint256 x) public {
        x = bound(x, 0, type(uint152).max);
        assertEq(SafeCastLib.toUint152(x), uint152(x));
    }

    function testToUint160_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint160(type(uint256).max);
    }

    function testToUint160_Success(uint256 x) public {
        x = bound(x, 0, type(uint160).max);
        assertEq(SafeCastLib.toUint160(x), uint160(x));
    }

    function testToUint168_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint168(type(uint256).max);
    }

    function testToUint168_Success(uint256 x) public {
        x = bound(x, 0, type(uint168).max);
        assertEq(SafeCastLib.toUint168(x), uint168(x));
    }

    function testToUint176_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint176(type(uint256).max);
    }

    function testToUint176_Success(uint256 x) public {
        x = bound(x, 0, type(uint176).max);
        assertEq(SafeCastLib.toUint176(x), uint176(x));
    }

    function testToUint184_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint184(type(uint256).max);
    }

    function testToUint184_Success(uint256 x) public {
        x = bound(x, 0, type(uint184).max);
        assertEq(SafeCastLib.toUint184(x), uint184(x));
    }

    function testToUint192_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint192(type(uint256).max);
    }

    function testToUint192_Success(uint256 x) public {
        x = bound(x, 0, type(uint192).max);
        assertEq(SafeCastLib.toUint192(x), uint192(x));
    }

    function testToUint200_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint200(type(uint256).max);
    }

    function testToUint200_Success(uint256 x) public {
        x = bound(x, 0, type(uint200).max);
        assertEq(SafeCastLib.toUint200(x), uint200(x));
    }

    function testToUint208_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint208(type(uint256).max);
    }

    function testToUint208_Success(uint256 x) public {
        x = bound(x, 0, type(uint208).max);
        assertEq(SafeCastLib.toUint208(x), uint208(x));
    }

    function testToUint216_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint216(type(uint256).max);
    }

    function testToUint216_Success(uint256 x) public {
        x = bound(x, 0, type(uint216).max);
        assertEq(SafeCastLib.toUint216(x), uint216(x));
    }

    function testToUint224_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint224(type(uint256).max);
    }

    function testToUint224_Success(uint256 x) public {
        x = bound(x, 0, type(uint224).max);
        assertEq(SafeCastLib.toUint224(x), uint224(x));
    }

    function testToUint232_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint232(type(uint256).max);
    }

    function testToUint232_Success(uint256 x) public {
        x = bound(x, 0, type(uint232).max);
        assertEq(SafeCastLib.toUint232(x), uint232(x));
    }

    function testToUint240_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint240(type(uint256).max);
    }

    function testToUint240_Success(uint256 x) public {
        x = bound(x, 0, type(uint240).max);
        assertEq(SafeCastLib.toUint240(x), uint240(x));
    }

    function testToUint248_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toUint248(type(uint256).max);
    }

    function testToUint248_Success(uint256 x) public {
        x = bound(x, 0, type(uint248).max);
        assertEq(SafeCastLib.toUint248(x), uint248(x));
    }

    function testToInt8_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt8(type(int256).max);
    }

    function testToInt8_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt8(type(int256).min);
    }

    function testToInt8_Success(int256 x) public {
        x = bound(x, type(int8).min, type(int8).max);
        assertEq(SafeCastLib.toInt8(x), int8(x));
    }

    function testToInt16_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt16(type(int256).max);
    }

    function testToInt16_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt16(type(int256).min);
    }

    function testToInt16_Success(int256 x) public {
        x = bound(x, type(int16).min, type(int16).max);
        assertEq(SafeCastLib.toInt16(x), int16(x));
    }

    function testToInt24_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt24(type(int256).max);
    }

    function testToInt24_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt24(type(int256).min);
    }

    function testToInt24_Success(int256 x) public {
        x = bound(x, type(int24).min, type(int24).max);
        assertEq(SafeCastLib.toInt24(x), int24(x));
    }

    function testToInt32_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt32(type(int256).max);
    }

    function testToInt32_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt32(type(int256).min);
    }

    function testToInt32_Success(int256 x) public {
        x = bound(x, type(int32).min, type(int32).max);
        assertEq(SafeCastLib.toInt32(x), int32(x));
    }

    function testToInt40_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt40(type(int256).max);
    }

    function testToInt40_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt40(type(int256).min);
    }

    function testToInt40_Success(int256 x) public {
        x = bound(x, type(int40).min, type(int40).max);
        assertEq(SafeCastLib.toInt40(x), int40(x));
    }

    function testToInt48_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt48(type(int256).max);
    }

    function testToInt48_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt48(type(int256).min);
    }

    function testToInt48_Success(int256 x) public {
        x = bound(x, type(int48).min, type(int48).max);
        assertEq(SafeCastLib.toInt48(x), int48(x));
    }

    function testToInt56_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt56(type(int256).max);
    }

    function testToInt56_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt56(type(int256).min);
    }

    function testToInt56_Success(int256 x) public {
        x = bound(x, type(int56).min, type(int56).max);
        assertEq(SafeCastLib.toInt56(x), int56(x));
    }

    function testToInt64_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt64(type(int256).max);
    }

    function testToInt64_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt64(type(int256).min);
    }

    function testToInt64_Success(int256 x) public {
        x = bound(x, type(int64).min, type(int64).max);
        assertEq(SafeCastLib.toInt64(x), int64(x));
    }

    function testToInt72_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt72(type(int256).max);
    }

    function testToInt72_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt72(type(int256).min);
    }

    function testToInt72_Success(int256 x) public {
        x = bound(x, type(int72).min, type(int72).max);
        assertEq(SafeCastLib.toInt72(x), int72(x));
    }

    function testToInt80_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt80(type(int256).max);
    }

    function testToInt80_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt80(type(int256).min);
    }

    function testToInt80_Success(int256 x) public {
        x = bound(x, type(int80).min, type(int80).max);
        assertEq(SafeCastLib.toInt80(x), int80(x));
    }

    function testToInt88_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt88(type(int256).max);
    }

    function testToInt88_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt88(type(int256).min);
    }

    function testToInt88_Success(int256 x) public {
        x = bound(x, type(int88).min, type(int88).max);
        assertEq(SafeCastLib.toInt88(x), int88(x));
    }

    function testToInt96_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt96(type(int256).max);
    }

    function testToInt96_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt96(type(int256).min);
    }

    function testToInt96_Success(int256 x) public {
        x = bound(x, type(int96).min, type(int96).max);
        assertEq(SafeCastLib.toInt96(x), int96(x));
    }

    function testToInt104_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt104(type(int256).max);
    }

    function testToInt104_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt104(type(int256).min);
    }

    function testToInt104_Success(int256 x) public {
        x = bound(x, type(int104).min, type(int104).max);
        assertEq(SafeCastLib.toInt104(x), int104(x));
    }

    function testToInt112_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt112(type(int256).max);
    }

    function testToInt112_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt112(type(int256).min);
    }

    function testToInt112_Success(int256 x) public {
        x = bound(x, type(int112).min, type(int112).max);
        assertEq(SafeCastLib.toInt112(x), int112(x));
    }

    function testToInt120_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt120(type(int256).max);
    }

    function testToInt120_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt120(type(int256).min);
    }

    function testToInt120_Success(int256 x) public {
        x = bound(x, type(int120).min, type(int120).max);
        assertEq(SafeCastLib.toInt120(x), int120(x));
    }

    function testToInt128_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt128(type(int256).max);
    }

    function testToInt128_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt128(type(int256).min);
    }

    function testToInt128_Success(int256 x) public {
        x = bound(x, type(int128).min, type(int128).max);
        assertEq(SafeCastLib.toInt128(x), int128(x));
    }

    function testToInt136_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt136(type(int256).max);
    }

    function testToInt136_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt136(type(int256).min);
    }

    function testToInt136_Success(int256 x) public {
        x = bound(x, type(int136).min, type(int136).max);
        assertEq(SafeCastLib.toInt136(x), int136(x));
    }

    function testToInt144_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt144(type(int256).max);
    }

    function testToInt144_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt144(type(int256).min);
    }

    function testToInt144_Success(int256 x) public {
        x = bound(x, type(int144).min, type(int144).max);
        assertEq(SafeCastLib.toInt144(x), int144(x));
    }

    function testToInt152_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt152(type(int256).max);
    }

    function testToInt152_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt152(type(int256).min);
    }

    function testToInt152_Success(int256 x) public {
        x = bound(x, type(int152).min, type(int152).max);
        assertEq(SafeCastLib.toInt152(x), int152(x));
    }

    function testToInt160_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt160(type(int256).max);
    }

    function testToInt160_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt160(type(int256).min);
    }

    function testToInt160_Success(int256 x) public {
        x = bound(x, type(int160).min, type(int160).max);
        assertEq(SafeCastLib.toInt160(x), int160(x));
    }

    function testToInt168_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt168(type(int256).max);
    }

    function testToInt168_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt168(type(int256).min);
    }

    function testToInt168_Success(int256 x) public {
        x = bound(x, type(int168).min, type(int168).max);
        assertEq(SafeCastLib.toInt168(x), int168(x));
    }

    function testToInt176_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt176(type(int256).max);
    }

    function testToInt176_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt176(type(int256).min);
    }

    function testToInt176_Success(int256 x) public {
        x = bound(x, type(int176).min, type(int176).max);
        assertEq(SafeCastLib.toInt176(x), int176(x));
    }

    function testToInt184_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt184(type(int256).max);
    }

    function testToInt184_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt184(type(int256).min);
    }

    function testToInt184_Success(int256 x) public {
        x = bound(x, type(int184).min, type(int184).max);
        assertEq(SafeCastLib.toInt184(x), int184(x));
    }

    function testToInt192_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt192(type(int256).max);
    }

    function testToInt192_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt192(type(int256).min);
    }

    function testToInt192_Success(int256 x) public {
        x = bound(x, type(int192).min, type(int192).max);
        assertEq(SafeCastLib.toInt192(x), int192(x));
    }

    function testToInt200_Overflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt200(type(int256).max);
    }

    function testToInt200_Underflow() public {
        vm.expectRevert(abi.encodeWithSelector(Overflow.selector));
        SafeCastLib.toInt200(type(int256).min);
    }

}