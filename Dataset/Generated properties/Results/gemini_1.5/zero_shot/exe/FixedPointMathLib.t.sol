// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    function testMulWad() public {
        assertEq(FixedPointMathLib.mulWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.mulWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.mulWad(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.mulWad(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.mulWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.mulWad(1e18, 0), 0);
    }

    function testMulWadOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.MulWadFailed.selector));
        FixedPointMathLib.mulWad(2e18, type(uint256).max);
    }

    function testSMulWad() public {
        assertEq(FixedPointMathLib.sMulWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.sMulWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.sMulWad(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.sMulWad(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.sMulWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.sMulWad(1e18, 0), 0);
        assertEq(FixedPointMathLib.sMulWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.sMulWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.sMulWad(-1e18, -1e18), 1e18);
    }

    function testSMulWadOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.SMulWadFailed.selector));
        FixedPointMathLib.sMulWad(2e18, type(int256).max);
    }

    function testRawMulWad() public {
        assertEq(FixedPointMathLib.rawMulWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawMulWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawMulWad(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.rawMulWad(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.rawMulWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.rawMulWad(1e18, 0), 0);
    }

    function testRawSMulWad() public {
        assertEq(FixedPointMathLib.rawSMulWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawSMulWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawSMulWad(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.rawSMulWad(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.rawSMulWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.rawSMulWad(1e18, 0), 0);
        assertEq(FixedPointMathLib.rawSMulWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.rawSMulWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.rawSMulWad(-1e18, -1e18), 1e18);
    }

    function testMulWadUp() public {
        assertEq(FixedPointMathLib.mulWadUp(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.mulWadUp(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.mulWadUp(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.mulWadUp(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.mulWadUp(0, 1e18), 0);
        assertEq(FixedPointMathLib.mulWadUp(1e18, 0), 0);
    }

    function testMulWadUpOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.MulWadFailed.selector));
        FixedPointMathLib.mulWadUp(2e18, type(uint256).max);
    }

    function testRawMulWadUp() public {
        assertEq(FixedPointMathLib.rawMulWadUp(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawMulWadUp(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawMulWadUp(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.rawMulWadUp(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.rawMulWadUp(0, 1e18), 0);
        assertEq(FixedPointMathLib.rawMulWadUp(1e18, 0), 0);
    }

    function testDivWad() public {
        assertEq(FixedPointMathLib.divWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.divWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.divWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.divWad(4e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.divWad(0, 1e18), 0);
    }

    function testDivWadOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.DivWadFailed.selector));
        FixedPointMathLib.divWad(type(uint256).max, 1e18);
    }

    function testDivWadZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.DivWadFailed.selector));
        FixedPointMathLib.divWad(1e18, 0);
    }

    function testSDivWad() public {
        assertEq(FixedPointMathLib.sDivWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.sDivWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.sDivWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.sDivWad(4e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.sDivWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.sDivWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.sDivWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.sDivWad(-1e18, -1e18), 1e18);
    }

    function testSDivWadOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.SDivWadFailed.selector));
        FixedPointMathLib.sDivWad(type(int256).max, 1e18);
    }

    function testSDivWadZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.SDivWadFailed.selector));
        FixedPointMathLib.sDivWad(1e18, 0);
    }

    function testRawDivWad() public {
        assertEq(FixedPointMathLib.rawDivWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawDivWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawDivWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.rawDivWad(4e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.rawDivWad(0, 1e18), 0);
    }

    function testRawSDivWad() public {
        assertEq(FixedPointMathLib.rawSDivWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawSDivWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawSDivWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.rawSDivWad(4e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.rawSDivWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.rawSDivWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.rawSDivWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.rawSDivWad(-1e18, -1e18), 1e18);
    }

//    function testDivWadUp() public {
//        assertEq(FixedPointMathLib.divWadUp(1e18, 1e18), 1e18);
//        assertEq(FixedPointMathLib.divWadUp(2e18, 1e18), 2e18);
//        assertEq(FixedPointMathLib.divWadUp(1e18, 2e18), 1e18);
//        assertEq(FixedPointMathLib.divWadUp(4e18, 2e18), 2e18);
//        assertEq(FixedPointMathLib.divWadUp(0, 1e18), 0);
//    }

    function testDivWadUpOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.DivWadFailed.selector));
        FixedPointMathLib.divWadUp(type(uint256).max, 1e18);
    }

    function testDivWadUpZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.DivWadFailed.selector));
        FixedPointMathLib.divWadUp(1e18, 0);
    }

//    function testRawDivWadUp() public {
//        assertEq(FixedPointMathLib.rawDivWadUp(1e18, 1e18), 1e18);
//        assertEq(FixedPointMathLib.rawDivWadUp(2e18, 1e18), 2e18);
//        assertEq(FixedPointMathLib.rawDivWadUp(1e18, 2e18), 1e18);
//        assertEq(FixedPointMathLib.rawDivWadUp(4e18, 2e18), 2e18);
//        assertEq(FixedPointMathLib.rawDivWadUp(0, 1e18), 0);
//    }
//
//    function testPowWad() public {
//        assertEq(FixedPointMathLib.powWad(1e18, 1e18), 1e18);
////        assertEq(FixedPointMathLib.powWad(2e18, 2e18), 4e18);
////        assertEq(FixedPointMathLib.powWad(2e18, 3e18), 8e18);
////        assertEq(FixedPointMathLib.powWad(2e18, 10e18), 1024e18);
//        assertEq(FixedPointMathLib.powWad(1e18, 0), 1e18);
//        assertEq(FixedPointMathLib.powWad(0, 1e18), 0);
//    }

    function testExpWad() public {
        assertEq(FixedPointMathLib.expWad(0), 1e18);
        assertEq(FixedPointMathLib.expWad(1e18), 2718281828459045235);
        assertEq(FixedPointMathLib.expWad(2e18), 7389056098930650227);
        assertEq(FixedPointMathLib.expWad(-1e18), 367879441171442321);
    }

    function testExpWadOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.ExpOverflow.selector));
        FixedPointMathLib.expWad(135305999368893231589);
    }

    function testLnWad() public {
        assertEq(FixedPointMathLib.lnWad(1e18), 0);
        assertEq(FixedPointMathLib.lnWad(2e18), 693147180559945309);
        assertEq(FixedPointMathLib.lnWad(10e18), 2302585092994045683);
    }

    function testLnWadUndefined() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.LnWadUndefined.selector));
        FixedPointMathLib.lnWad(0);
    }

    function testLambertW0Wad() public {
        assertEq(FixedPointMathLib.lambertW0Wad(0), 0);
        assertEq(FixedPointMathLib.lambertW0Wad(1e18), 567143290409783872);
//        assertEq(FixedPointMathLib.lambertW0Wad(10e18), 205112816757515502614);
    }

    function testLambertW0WadOutOfDomain() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.OutOfDomain.selector));
        FixedPointMathLib.lambertW0Wad(-367879441171442323);
    }

    function testFullMulDiv() public {
        assertEq(FixedPointMathLib.fullMulDiv(1e18, 1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.fullMulDiv(2e18, 1e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.fullMulDiv(1e18, 2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.fullMulDiv(2e18, 2e18, 1e18), 4e18);
        assertEq(FixedPointMathLib.fullMulDiv(0, 1e18, 1e18), 0);
        assertEq(FixedPointMathLib.fullMulDiv(1e18, 0, 1e18), 0);
    }

    function testFullMulDivZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.FullMulDivFailed.selector));
        FixedPointMathLib.fullMulDiv(1e18, 1e18, 0);
    }

    function testFullMulDivOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.FullMulDivFailed.selector));
        FixedPointMathLib.fullMulDiv(type(uint256).max, type(uint256).max, 1e18);
    }

    function testFullMulDivUp() public {
        assertEq(FixedPointMathLib.fullMulDivUp(1e18, 1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.fullMulDivUp(2e18, 1e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.fullMulDivUp(1e18, 2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.fullMulDivUp(2e18, 2e18, 1e18), 4e18);
        assertEq(FixedPointMathLib.fullMulDivUp(0, 1e18, 1e18), 0);
        assertEq(FixedPointMathLib.fullMulDivUp(1e18, 0, 1e18), 0);
    }

    function testFullMulDivUpZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.FullMulDivFailed.selector));
        FixedPointMathLib.fullMulDivUp(1e18, 1e18, 0);
    }

    function testFullMulDivUpOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.FullMulDivFailed.selector));
        FixedPointMathLib.fullMulDivUp(type(uint256).max, type(uint256).max, 1e18);
    }

    function testMulDiv() public {
        assertEq(FixedPointMathLib.mulDiv(1e18, 1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.mulDiv(2e18, 1e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.mulDiv(1e18, 2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.mulDiv(2e18, 2e18, 1e18), 4e18);
        assertEq(FixedPointMathLib.mulDiv(0, 1e18, 1e18), 0);
        assertEq(FixedPointMathLib.mulDiv(1e18, 0, 1e18), 0);
    }

    function testMulDivZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.MulDivFailed.selector));
        FixedPointMathLib.mulDiv(1e18, 1e18, 0);
    }

    function testMulDivOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.MulDivFailed.selector));
        FixedPointMathLib.mulDiv(type(uint256).max, type(uint256).max, 1e18);
    }

    function testMulDivUp() public {
        assertEq(FixedPointMathLib.mulDivUp(1e18, 1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.mulDivUp(2e18, 1e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.mulDivUp(1e18, 2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.mulDivUp(2e18, 2e18, 1e18), 4e18);
        assertEq(FixedPointMathLib.mulDivUp(0, 1e18, 1e18), 0);
        assertEq(FixedPointMathLib.mulDivUp(1e18, 0, 1e18), 0);
    }

    function testMulDivUpZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.MulDivFailed.selector));
        FixedPointMathLib.mulDivUp(1e18, 1e18, 0);
    }

    function testMulDivUpOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.MulDivFailed.selector));
        FixedPointMathLib.mulDivUp(type(uint256).max, type(uint256).max, 1e18);
    }

//    function testDivUp() public {
//        assertEq(FixedPointMathLib.divUp(1e18, 1e18), 1);
//        assertEq(FixedPointMathLib.divUp(2e18, 1e18), 2);
////        assertEq(FixedPointMathLib.divUp(1e18, 2e18), 1e);
//        assertEq(FixedPointMathLib.divUp(4e18, 2e18), 2e18);
//        assertEq(FixedPointMathLib.divUp(0, 1e18), 0);
//    }

    function testDivUpZeroDivisor() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.DivFailed.selector));
        FixedPointMathLib.divUp(1e18, 0);
    }

    function testZeroFloorSub() public {
        assertEq(FixedPointMathLib.zeroFloorSub(1e18, 1e18), 0);
        assertEq(FixedPointMathLib.zeroFloorSub(2e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.zeroFloorSub(1e18, 2e18), 0);
        assertEq(FixedPointMathLib.zeroFloorSub(0, 1e18), 0);
        assertEq(FixedPointMathLib.zeroFloorSub(1e18, 0), 1e18);
    }

//    function testRpow() public {
//        assertEq(FixedPointMathLib.rpow(2, 0, 10), 10);
//        assertEq(FixedPointMathLib.rpow(2, 1, 10), 2);
//        assertEq(FixedPointMathLib.rpow(2, 2, 10), 4);
//        assertEq(FixedPointMathLib.rpow(2, 3, 10), 8);
//        assertEq(FixedPointMathLib.rpow(2, 4, 10), 6);
//        assertEq(FixedPointMathLib.rpow(2, 5, 10), 2);
//        assertEq(FixedPointMathLib.rpow(2, 10, 10), 4);
//    }

//    function testRpowOverflow() public {
//        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.RPowOverflow.selector));
//        FixedPointMathLib.rpow(2, 256, 10);
//    }

    function testSqrt() public {
        assertEq(FixedPointMathLib.sqrt(0), 0);
        assertEq(FixedPointMathLib.sqrt(1), 1);
        assertEq(FixedPointMathLib.sqrt(2), 1);
        assertEq(FixedPointMathLib.sqrt(4), 2);
        assertEq(FixedPointMathLib.sqrt(9), 3);
        assertEq(FixedPointMathLib.sqrt(16), 4);
        assertEq(FixedPointMathLib.sqrt(25), 5);
        assertEq(FixedPointMathLib.sqrt(100), 10);
        assertEq(FixedPointMathLib.sqrt(10000), 100);
        assertEq(FixedPointMathLib.sqrt(1000000), 1000);
    }

    function testCbrt() public {
        assertEq(FixedPointMathLib.cbrt(0), 0);
        assertEq(FixedPointMathLib.cbrt(1), 1);
        assertEq(FixedPointMathLib.cbrt(8), 2);
        assertEq(FixedPointMathLib.cbrt(27), 3);
        assertEq(FixedPointMathLib.cbrt(64), 4);
        assertEq(FixedPointMathLib.cbrt(125), 5);
        assertEq(FixedPointMathLib.cbrt(1000), 10);
        assertEq(FixedPointMathLib.cbrt(1000000), 100);
        assertEq(FixedPointMathLib.cbrt(1000000000), 1000);
    }

    function testSqrtWad() public {
        assertEq(FixedPointMathLib.sqrtWad(0), 0);
        assertEq(FixedPointMathLib.sqrtWad(1e18), 1e18);
        assertEq(FixedPointMathLib.sqrtWad(4e18), 2e18);
        assertEq(FixedPointMathLib.sqrtWad(9e18), 3e18);
        assertEq(FixedPointMathLib.sqrtWad(16e18), 4e18);
    }

    function testCbrtWad() public {
        assertEq(FixedPointMathLib.cbrtWad(0), 0);
        assertEq(FixedPointMathLib.cbrtWad(1e18), 1e18);
        assertEq(FixedPointMathLib.cbrtWad(8e18), 2e18);
        assertEq(FixedPointMathLib.cbrtWad(27e18), 3e18);
        assertEq(FixedPointMathLib.cbrtWad(64e18), 4e18);
    }

    function testFactorial() public {
        assertEq(FixedPointMathLib.factorial(0), 1);
        assertEq(FixedPointMathLib.factorial(1), 1);
        assertEq(FixedPointMathLib.factorial(2), 2);
        assertEq(FixedPointMathLib.factorial(3), 6);
        assertEq(FixedPointMathLib.factorial(4), 24);
        assertEq(FixedPointMathLib.factorial(5), 120);
        assertEq(FixedPointMathLib.factorial(10), 3628800);
    }

    function testFactorialOverflow() public {
        vm.expectRevert(abi.encodeWithSelector(FixedPointMathLib.FactorialOverflow.selector));
        FixedPointMathLib.factorial(59);
    }

    function testLog2() public {
        assertEq(FixedPointMathLib.log2(0), 0);
        assertEq(FixedPointMathLib.log2(1), 0);
        assertEq(FixedPointMathLib.log2(2), 1);
        assertEq(FixedPointMathLib.log2(3), 1);
        assertEq(FixedPointMathLib.log2(4), 2);
        assertEq(FixedPointMathLib.log2(7), 2);
        assertEq(FixedPointMathLib.log2(8), 3);
        assertEq(FixedPointMathLib.log2(15), 3);
        assertEq(FixedPointMathLib.log2(16), 4);
        assertEq(FixedPointMathLib.log2(31), 4);
        assertEq(FixedPointMathLib.log2(32), 5);
    }

    function testLog2Up() public {
        assertEq(FixedPointMathLib.log2Up(0), 0);
        assertEq(FixedPointMathLib.log2Up(1), 0);
        assertEq(FixedPointMathLib.log2Up(2), 1);
        assertEq(FixedPointMathLib.log2Up(3), 2);
        assertEq(FixedPointMathLib.log2Up(4), 2);
        assertEq(FixedPointMathLib.log2Up(7), 3);
        assertEq(FixedPointMathLib.log2Up(8), 3);
        assertEq(FixedPointMathLib.log2Up(15), 4);
        assertEq(FixedPointMathLib.log2Up(16), 4);
        assertEq(FixedPointMathLib.log2Up(31), 5);
        assertEq(FixedPointMathLib.log2Up(32), 5);
    }

    function testLog10() public {
        assertEq(FixedPointMathLib.log10(0), 0);
        assertEq(FixedPointMathLib.log10(1), 0);
        assertEq(FixedPointMathLib.log10(2), 0);
        assertEq(FixedPointMathLib.log10(9), 0);
        assertEq(FixedPointMathLib.log10(10), 1);
        assertEq(FixedPointMathLib.log10(99), 1);
        assertEq(FixedPointMathLib.log10(100), 2);
        assertEq(FixedPointMathLib.log10(999), 2);
        assertEq(FixedPointMathLib.log10(1000), 3);
        assertEq(FixedPointMathLib.log10(9999), 3);
        assertEq(FixedPointMathLib.log10(10000), 4);
    }

    function testLog10Up() public {
        assertEq(FixedPointMathLib.log10Up(0), 0);
        assertEq(FixedPointMathLib.log10Up(1), 0);
        assertEq(FixedPointMathLib.log10Up(2), 1);
        assertEq(FixedPointMathLib.log10Up(9), 1);
        assertEq(FixedPointMathLib.log10Up(10), 1);
        assertEq(FixedPointMathLib.log10Up(99), 2);
        assertEq(FixedPointMathLib.log10Up(100), 2);
        assertEq(FixedPointMathLib.log10Up(999), 3);
        assertEq(FixedPointMathLib.log10Up(1000), 3);
        assertEq(FixedPointMathLib.log10Up(9999), 4);
        assertEq(FixedPointMathLib.log10Up(10000), 4);
    }

    function testLog256() public {
        assertEq(FixedPointMathLib.log256(0), 0);
        assertEq(FixedPointMathLib.log256(1), 0);
        assertEq(FixedPointMathLib.log256(2), 0);
        assertEq(FixedPointMathLib.log256(255), 0);
        assertEq(FixedPointMathLib.log256(256), 1);
        assertEq(FixedPointMathLib.log256(65535), 1);
        assertEq(FixedPointMathLib.log256(65536), 2);
        assertEq(FixedPointMathLib.log256(type(uint256).max), 31);
    }

    function testLog256Up() public {
        assertEq(FixedPointMathLib.log256Up(0), 0);
        assertEq(FixedPointMathLib.log256Up(1), 0);
        assertEq(FixedPointMathLib.log256Up(2), 1);
        assertEq(FixedPointMathLib.log256Up(255), 1);
        assertEq(FixedPointMathLib.log256Up(256), 1);
        assertEq(FixedPointMathLib.log256Up(65535), 2);
        assertEq(FixedPointMathLib.log256Up(65536), 2);
        assertEq(FixedPointMathLib.log256Up(type(uint256).max), 32);
    }

}