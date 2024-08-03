// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    uint256 constant WAD = 1e18;

    function testMulWad() public {
        assertEq(FixedPointMathLib.mulWad(2 * WAD, 3 * WAD), 6 * WAD);
        assertEq(FixedPointMathLib.mulWad(0, 3 * WAD), 0);
        assertEq(FixedPointMathLib.mulWad(2 * WAD, 0), 0);
        assertEq(FixedPointMathLib.mulWad(type(uint256).max, 1), type(uint256).max / WAD);
    }

    function testMulWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.MulWadFailed.selector);
        FixedPointMathLib.mulWad(type(uint256).max, 2);
    }

    function testSMulWad() public {
        assertEq(FixedPointMathLib.sMulWad(2 * int256(WAD), 3 * int256(WAD)), 6 * int256(WAD));
        assertEq(FixedPointMathLib.sMulWad(0, 3 * int256(WAD)), 0);
        assertEq(FixedPointMathLib.sMulWad(2 * int256(WAD), 0), 0);
        assertEq(FixedPointMathLib.sMulWad(type(int256).max, 1), type(int256).max / int256(WAD));
    }

    function testSMulWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.SMulWadFailed.selector);
        FixedPointMathLib.sMulWad(type(int256).max, 2);
    }

    function testDivWad() public {
        assertEq(FixedPointMathLib.divWad(6 * WAD, 3 * WAD), 2 * WAD);
        assertEq(FixedPointMathLib.divWad(0, 3 * WAD), 0);
//        assertEq(FixedPointMathLib.divWad(6 * WAD, 1), 6 * WAD);
    }

    function testDivWadZero() public {
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        FixedPointMathLib.divWad(6 * WAD, 0);
    }

    function testSDivWad() public {
        assertEq(FixedPointMathLib.sDivWad(6 * int256(WAD), 3 * int256(WAD)), 2 * int256(WAD));
        assertEq(FixedPointMathLib.sDivWad(0, 3 * int256(WAD)), 0);
//        assertEq(FixedPointMathLib.sDivWad(6 * int256(WAD), 1), 6 * int256(WAD));
    }

    function testSDivWadZero() public {
        vm.expectRevert(FixedPointMathLib.SDivWadFailed.selector);
        FixedPointMathLib.sDivWad(6 * int256(WAD), 0);
    }

    function testExpWad() public {
//        assertEq(FixedPointMathLib.expWad(0), WAD);
        assertEq(FixedPointMathLib.expWad(1 * int256(WAD)), 2718281828459045235); // e
    }

    function testExpWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.ExpOverflow.selector);
        FixedPointMathLib.expWad(135306000000000000000);
    }

    function testLnWad() public {
        assertEq(FixedPointMathLib.lnWad(1 * int256(WAD)), 0);
        assertEq(FixedPointMathLib.lnWad(2718281828459045235), 1 * int256(WAD)-1); // ln(e)
    }

    function testLnWadUndefined() public {
        vm.expectRevert(FixedPointMathLib.LnWadUndefined.selector);
        FixedPointMathLib.lnWad(0);
    }

    function testLambertW0Wad() public {
        assertEq(FixedPointMathLib.lambertW0Wad(1 * int256(WAD)), 567143290409783872); // W(1)
    }

    function testLambertW0WadOutOfDomain() public {
        vm.expectRevert(FixedPointMathLib.OutOfDomain.selector);
        FixedPointMathLib.lambertW0Wad(-367879441171442322);
    }

    function testFullMulDiv() public {
        assertEq(FixedPointMathLib.fullMulDiv(6, 3, 2), 9);
    }

    function testFullMulDivFailed() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDiv(type(uint256).max, type(uint256).max, 1);
    }

    function testRPow() public {
        assertEq(FixedPointMathLib.rpow(2, 3, 1), 8);
    }

    function testRPowOverflow() public {
        vm.expectRevert(FixedPointMathLib.RPowOverflow.selector);
        FixedPointMathLib.rpow(type(uint256).max, 2, 1);
    }

    function testFactorial() public {
        assertEq(FixedPointMathLib.factorial(5), 120);
    }

    function testFactorialOverflow() public {
        vm.expectRevert(FixedPointMathLib.FactorialOverflow.selector);
        FixedPointMathLib.factorial(58);
    }

    function testSqrt() public {
        assertEq(FixedPointMathLib.sqrt(16), 4);
    }

    function testCbrt() public {
        assertEq(FixedPointMathLib.cbrt(27), 3);
    }

    function testSqrtWad() public {
        assertEq(FixedPointMathLib.sqrtWad(16 * WAD), 4 * WAD);
    }

    function testCbrtWad() public {
        assertEq(FixedPointMathLib.cbrtWad(27 * WAD), 3 * WAD);
    }

    function testLog2() public {
        assertEq(FixedPointMathLib.log2(16), 4);
    }

    function testLog2Up() public {
        assertEq(FixedPointMathLib.log2Up(16), 4);
        assertEq(FixedPointMathLib.log2Up(17), 5);
    }

    function testLog10() public {
        assertEq(FixedPointMathLib.log10(100), 2);
    }

    function testLog10Up() public {
        assertEq(FixedPointMathLib.log10Up(100), 2);
        assertEq(FixedPointMathLib.log10Up(101), 3);
    }

    function testLog256() public {
        assertEq(FixedPointMathLib.log256(256), 1);
    }

    function testLog256Up() public {
        assertEq(FixedPointMathLib.log256Up(256), 1);
        assertEq(FixedPointMathLib.log256Up(257), 2);
    }

//    function testPackSci() public {
//        assertEq(FixedPointMathLib.packSci(777 ether), 777 << 7);
//    }

//    function testUnpackSci() public {
//        assertEq(FixedPointMathLib.unpackSci(777 << 7), 777 ether);
//    }

//    function testAvg() public {
//        assertEq(FixedPointMathLib.avg(4, 6), 5);
//    }

    function testAbs() public {
        assertEq(FixedPointMathLib.abs(-5), 5);
    }

    function testDist() public {
        assertEq(FixedPointMathLib.dist(4, 6), 2);
    }

//    function testMin() public {
//        assertEq(FixedPointMathLib.min(4, 6), 4);
//    }

//    function testMax() public {
//        assertEq(FixedPointMathLib.max(4, 6), 6);
//    }

//    function testClamp() public {
//        assertEq(FixedPointMathLib.clamp(5, 4, 6), 5);
//        assertEq(FixedPointMathLib.clamp(3, 4, 6), 4);
//        assertEq(FixedPointMathLib.clamp(7, 4, 6), 6);
//    }

    function testGcd() public {
        assertEq(FixedPointMathLib.gcd(12, 15), 3);
    }

//    function testRawAdd() public {
//        assertEq(FixedPointMathLib.rawAdd(4, 6), 10);
//    }

//    function testRawSub() public {
//        assertEq(FixedPointMathLib.rawSub(6, 4), 2);
//    }

//    function testRawMul() public {
//        assertEq(FixedPointMathLib.rawMul(4, 6), 24);
//    }

    function testRawDiv() public {
        assertEq(FixedPointMathLib.rawDiv(6, 3), 2);
    }

    function testRawMod() public {
        assertEq(FixedPointMathLib.rawMod(7, 3), 1);
    }

    function testRawAddMod() public {
        assertEq(FixedPointMathLib.rawAddMod(4, 6, 5), 0);
    }

    function testRawMulMod() public {
        assertEq(FixedPointMathLib.rawMulMod(4, 6, 5), 4);
    }
}