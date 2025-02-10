// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";
contract FixedPointMathLibTest is Test {

    function testMulWadZero() public {
        uint256 x = 0;
        uint256 y = 1e18;
        uint256 z = FixedPointMathLib.mulWad(x, y);
        assertEq(z, 0);
    }

    function testMulWadOne() public {
        uint256 x = 1e18;
        uint256 y = 1e18;
        uint256 z = FixedPointMathLib.mulWad(x, y);
        assertEq(z, 1e18);
    }

    function testMulWadLarge() public {
        uint256 x = type(uint256).max / 1e18;
        uint256 y = 1e18;
        uint256 z = FixedPointMathLib.mulWad(x, y);
        assertEq(z, x);
    }

    function testSMulWadZero() public {
        int256 x = 0;
        int256 y = 1e18;
        int256 z = FixedPointMathLib.sMulWad(x, y);
        assertEq(z, 0);
    }

    function testSMulWadOne() public {
        int256 x = 1e18;
        int256 y = 1e18;
        int256 z = FixedPointMathLib.sMulWad(x, y);
        assertEq(z, 1e18);
    }

    function testSMulWadNegative() public {
        int256 x = -1e18;
        int256 y = 1e18;
        int256 z = FixedPointMathLib.sMulWad(x, y);
        assertEq(z, -1e18);
    }

    function testRawMulWadZero() public {
        uint256 x = 0;
        uint256 y = 1e18;
        uint256 z = FixedPointMathLib.rawMulWad(x, y);
        assertEq(z, 0);
    }

    function testRawMulWadOne() public {
        uint256 x = 1e18;
        uint256 y = 1e18;
        uint256 z = FixedPointMathLib.rawMulWad(x, y);
        assertEq(z, 1e18);
    }

    function testRawSMulWadZero() public {
        int256 x = 0;
        int256 y = 1e18;
        int256 z = FixedPointMathLib.rawSMulWad(x, y);
        assertEq(z, 0);
    }

    function testRawSMulWadOne() public {
        int256 x = 1e18;
        int256 y = 1e18;
        int256 z = FixedPointMathLib.rawSMulWad(x, y);
        assertEq(z, 1e18);
    }

    function testRawSMulWadNegative() public {
        int256 x = -1e18;
        int256 y = 1e18;
        int256 z = FixedPointMathLib.rawSMulWad(x, y);
        assertEq(z, -1e18);
    }

    function testMulWadUpRounding() public {
        uint256 x = 3e18;
        uint256 y = 2e18;
        uint256 z = FixedPointMathLib.mulWadUp(x, y);
        assertEq(z, 6e18);
    }

    function testDivWadZeroX() public {
        uint256 x = 0;
        uint256 y = 2e18;
        uint256 z = FixedPointMathLib.divWad(x, y);
        assertEq(z, 0);
    }

//    function testDivWadZeroY() public {
//        uint256 x = 1e18;
//        uint256 y = 0;
//        vm.expectRevert(bytes("DivWadFailed()"));
//        FixedPointMathLib.divWad(x, y);
//    }

    function testDivWadSimple() public {
        uint256 x = 1e18;
        uint256 y = 2e18;
        uint256 z = FixedPointMathLib.divWad(x, y);
        assertEq(z, 5e17);
    }

    function testSDivWadZeroX() public {
        int256 x = 0;
        int256 y = 2e18;
        int256 z = FixedPointMathLib.sDivWad(x, y);
        assertEq(z, 0);
    }

//    function testSDivWadZeroY() public {
//        int256 x = 1e18;
//        int256 y = 0;
//        vm.expectRevert(bytes("SDivWadFailed()"));
//        FixedPointMathLib.sDivWad(x, y);
//    }

    function testSDivWadSimple() public {
        int256 x = 1e18;
        int256 y = 2e18;
        int256 z = FixedPointMathLib.sDivWad(x, y);
        assertEq(z, 5e17);
    }

    function testSDivWadNegative() public {
        int256 x = -1e18;
        int256 y = 2e18;
        int256 z = FixedPointMathLib.sDivWad(x, y);
        assertEq(z, -5e17);
    }

    function testRawDivWadZeroX() public {
        uint256 x = 0;
        uint256 y = 2e18;
        uint256 z = FixedPointMathLib.rawDivWad(x, y);
        assertEq(z, 0);
    }

    function testRawDivWadSimple() public {
        uint256 x = 1e18;
        uint256 y = 2e18;
        uint256 z = FixedPointMathLib.rawDivWad(x, y);
        assertEq(z, 5e17);
    }

    function testRawSDivWadZeroX() public {
        int256 x = 0;
        int256 y = 2e18;
        int256 z = FixedPointMathLib.rawSDivWad(x, y);
        assertEq(z, 0);
    }

    function testRawSDivWadSimple() public {
        int256 x = 1e18;
        int256 y = 2e18;
        int256 z = FixedPointMathLib.rawSDivWad(x, y);
        assertEq(z, 5e17);
    }

    function testRawSDivWadNegative() public {
        int256 x = -1e18;
        int256 y = 2e18;
        int256 z = FixedPointMathLib.rawSDivWad(x, y);
        assertEq(z, -5e17);
    }

//    function testDivWadUpRounding() public {
//        uint256 x = 5e18;
//        uint256 y = 2e18;
//        uint256 z = FixedPointMathLib.divWadUp(x, y);
//        assertEq(z, 2e18);
//    }

//    function testPowWadZeroXPositiveY() public {
//        int256 x = 0;
//        int256 y = 2;
//        int256 z = FixedPointMathLib.powWad(x, y);
//        assertEq(z, 0);
//    }

    function testPowWadPositiveXZeroY() public {
        int256 x = 2e18;
        int256 y = 0;
        int256 z = FixedPointMathLib.powWad(x, y);
        assertEq(z, 1e18);
    }

//    function testPowWadSimple() public {
//        int256 x = 1e18;
//        int256 y = 2;
//        int256 z = FixedPointMathLib.powWad(x, y);
//        assertEq(z, 1e36);
//    }

//    function testPowWadNegativeXEvenY() public {
//        int256 x = -2e18;
//        int256 y = 2;
//        int256 z = FixedPointMathLib.powWad(x, y);
//        assertEq(z, 4e36);
//    }

//    function testPowWadNegativeXOddY() public {
//        int256 x = -2e18;
//        int256 y = 3;
//        int256 z = FixedPointMathLib.powWad(x, y);
//        assertEq(z, -8e54);
//    }

    function testExpWadZero() public {
        int256 x = 0;
        int256 z = FixedPointMathLib.expWad(x);
        assertEq(z, 1e18);
    }

    function testExpWadPositive() public {
        int256 x = 1e18;
        int256 z = FixedPointMathLib.expWad(x);
        assertApproxEqRel(z, 2718281828459045235, 1e10);
    }

    function testExpWadNegative() public {
        int256 x = -1e18;
        int256 z = FixedPointMathLib.expWad(x);
        assertApproxEqRel(z, 367879441171442321, 1e10);
    }

//    function testLnWadZero() public {
//        int256 x = 0;
//        vm.expectRevert(bytes("LnWadUndefined()"));
//        FixedPointMathLib.lnWad(x);
//    }

    function testLnWadOne() public {
        int256 x = 1e18;
        int256 z = FixedPointMathLib.lnWad(x);
        assertEq(z, 0);
    }

    function testLnWadPositive() public {
        int256 x = 2e18;
        int256 z = FixedPointMathLib.lnWad(x);
        assertApproxEqRel(z, 693147180559945309, 1e10);
    }

//    function testLambertW0WadOutOfDomain() public {
//        int256 x = -4e18;
//        vm.expectRevert(bytes("OutOfDomain()"));
//        FixedPointMathLib.lambertW0Wad(x);
//    }

    function testLambertW0WadSimple() public {
        int256 x = 0;
        int256 z = FixedPointMathLib.lambertW0Wad(x);
        assertEq(z, 0);
    }

//    function testFullMulDivZeroD() public {
//        uint256 x = 2;
//        uint256 y = 3;
//        uint256 d = 0;
//        vm.expectRevert(bytes("FullMulDivFailed()"));
//        FixedPointMathLib.fullMulDiv(x, y, d);
//    }

    function testFullMulDivSimple() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 d = 2;
        uint256 z = FixedPointMathLib.fullMulDiv(x, y, d);
        assertEq(z, 3);
    }

//    function testFullMulDivLarge() public {
//        uint256 x = type(uint256).max / 2;
//        uint256 y = 2;
//        uint256 d = 1;
//        uint256 z = FixedPointMathLib.fullMulDiv(x, y, d);
//        assertEq(z, type(uint256).max);
//    }

    function testFullMulDivUpRounding() public {
        uint256 x = 5;
        uint256 y = 3;
        uint256 d = 2;
        uint256 z = FixedPointMathLib.fullMulDivUp(x, y, d);
        assertEq(z, 8);
    }

//    function testMulDivZeroD() public {
//        uint256 x = 2;
//        uint256 y = 3;
//        uint256 d = 0;
//        vm.expectRevert(bytes("MulDivFailed()"));
//        FixedPointMathLib.mulDiv(x, y, d);
//    }

    function testMulDivSimple() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 d = 2;
        uint256 z = FixedPointMathLib.mulDiv(x, y, d);
        assertEq(z, 3);
    }

    function testMulDivUpRounding() public {
        uint256 x = 5;
        uint256 y = 3;
        uint256 d = 2;
        uint256 z = FixedPointMathLib.mulDivUp(x, y, d);
        assertEq(z, 8);
    }

//    function testDivUpZeroD() public {
//        uint256 x = 2;
//        uint256 d = 0;
//        vm.expectRevert(bytes("DivFailed()"));
//        FixedPointMathLib.divUp(x, d);
//    }

    function testDivUpRounding() public {
        uint256 x = 5;
        uint256 d = 2;
        uint256 z = FixedPointMathLib.divUp(x, d);
        assertEq(z, 3);
    }

    function testZeroFloorSubXGreaterThanY() public {
        uint256 x = 5;
        uint256 y = 3;
        uint256 z = FixedPointMathLib.zeroFloorSub(x, y);
        assertEq(z, 2);
    }

    function testZeroFloorSubXLessThanY() public {
        uint256 x = 3;
        uint256 y = 5;
        uint256 z = FixedPointMathLib.zeroFloorSub(x, y);
        assertEq(z, 0);
    }

    function testRPowZeroXPositiveY() public {
        uint256 x = 0;
        uint256 y = 2;
        uint256 b = 2;
        uint256 z = FixedPointMathLib.rpow(x, y, b);
        assertEq(z, 0);
    }

    function testRPowPositiveXZeroY() public {
        uint256 x = 2;
        uint256 y = 0;
        uint256 b = 2;
        uint256 z = FixedPointMathLib.rpow(x, y, b);
        assertEq(z, b);
    }

    function testRPowSimple() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 b = 2;
        uint256 z = FixedPointMathLib.rpow(x, y, b);
        assertEq(z, 2);
    }

    function testSqrtPerfectSquare() public {
        uint256 x = 16;
        uint256 z = FixedPointMathLib.sqrt(x);
        assertEq(z, 4);
    }

    function testSqrtNonPerfectSquare() public {
        uint256 x = 17;
        uint256 z = FixedPointMathLib.sqrt(x);
        assertEq(z, 4);
    }

    function testCbrtPerfectCube() public {
        uint256 x = 27;
        uint256 z = FixedPointMathLib.cbrt(x);
        assertEq(z, 3);
    }

    function testCbrtNonPerfectCube() public {
        uint256 x = 28;
        uint256 z = FixedPointMathLib.cbrt(x);
        assertEq(z, 3);
    }

    function testSqrtWadSimple() public {
        uint256 x = 16e18;
        uint256 z = FixedPointMathLib.sqrtWad(x);
        assertEq(z, 4e18);
    }

    function testCbrtWadSimple() public {
        uint256 x = 27e36;
        uint256 z = FixedPointMathLib.cbrtWad(x);
        assertEq(z, 3e24);
    }

    function testFactorialSimple() public {
        uint256 x = 5;
        uint256 z = FixedPointMathLib.factorial(x);
        assertEq(z, 120);
    }

//    function testFactorialOverflow() public {
//        uint256 x = 59;
//        vm.expectRevert(bytes("FactorialOverflow()"));
//        FixedPointMathLib.factorial(x);
//    }

    function testLog2Zero() public {
        uint256 x = 0;
        uint256 z = FixedPointMathLib.log2(x);
        assertEq(z, 0);
    }

    function testLog2PowerOfTwo() public {
        uint256 x = 8;
        uint256 z = FixedPointMathLib.log2(x);
        assertEq(z, 3);
    }

    function testLog2UpZero() public {
        uint256 x = 0;
        uint256 z = FixedPointMathLib.log2Up(x);
        assertEq(z, 0);
    }

    function testLog2UpPowerOfTwo() public {
        uint256 x = 8;
        uint256 z = FixedPointMathLib.log2Up(x);
        assertEq(z, 3);
    }

    function testLog2UpNonPowerOfTwo() public {
        uint256 x = 9;
        uint256 z = FixedPointMathLib.log2Up(x);
        assertEq(z, 4);
    }

    function testLog10Zero() public {
        uint256 x = 0;
        uint256 z = FixedPointMathLib.log10(x);
        assertEq(z, 0);
    }

    function testLog10PowerOfTen() public {
        uint256 x = 1000;
        uint256 z = FixedPointMathLib.log10(x);
        assertEq(z, 3);
    }

    function testLog10UpZero() public {
        uint256 x = 0;
        uint256 z = FixedPointMathLib.log10Up(x);
        assertEq(z, 0);
    }

    function testLog10UpPowerOfTen() public {
        uint256 x = 1000;
        uint256 z = FixedPointMathLib.log10Up(x);
        assertEq(z, 3);
    }

    function testLog10UpNonPowerOfTen() public {
        uint256 x = 1001;
        uint256 z = FixedPointMathLib.log10Up(x);
        assertEq(z, 4);
    }

    function testLog256Zero() public {
        uint256 x = 0;
        uint256 z = FixedPointMathLib.log256(x);
        assertEq(z, 0);
    }

    function testLog256PowerOf256() public {
        uint256 x = 256;
        uint256 z = FixedPointMathLib.log256(x);
        assertEq(z, 1);
    }

    function testLog256UpZero() public {
        uint256 x = 0;
        uint256 z = FixedPointMathLib.log256Up(x);
        assertEq(z, 0);
    }

    function testLog256UpPowerOf256() public {
        uint256 x = 256;
        uint256 z = FixedPointMathLib.log256Up(x);
        assertEq(z, 1);
    }

    function testLog256UpNonPowerOf256() public {
        uint256 x = 257;
        uint256 z = FixedPointMathLib.log256Up(x);
        assertEq(z, 2);
    }

    function testSciSimple() public {
        uint256 x = 123456789e18;
        (uint256 mantissa, uint256 exponent) = FixedPointMathLib.sci(x);
        assertEq(mantissa, 123456789);
        assertEq(exponent, 18);
    }

    function testPackSciSimple() public {
        uint256 x = 123456789e18;
        uint256 packed = FixedPointMathLib.packSci(x);
        assertEq(packed, (123456789 << 7) | 18);
    }

    function testUnpackSciSimple() public {
        uint256 packed = (123456789 << 7) | 18;
        uint256 unpacked = FixedPointMathLib.unpackSci(packed);
        assertEq(unpacked, 123456789e18);
    }

    function testAvgUint() public {
        uint256 x = 3;
        uint256 y = 5;
        uint256 z = FixedPointMathLib.avg(x, y);
        assertEq(z, 4);
    }

    function testAvgInt() public {
        int256 x = -3;
        int256 y = 5;
        int256 z = FixedPointMathLib.avg(x, y);
        assertEq(z, 1);
    }

    function testAbsPositive() public {
        int256 x = 5;
        uint256 z = FixedPointMathLib.abs(x);
        assertEq(z, 5);
    }

    function testAbsNegative() public {
        int256 x = -5;
        uint256 z = FixedPointMathLib.abs(x);
        assertEq(z, 5);
    }

    function testDistPositive() public {
        int256 x = 3;
        int256 y = 5;
        uint256 z = FixedPointMathLib.dist(x, y);
        assertEq(z, 2);
    }

    function testDistNegative() public {
        int256 x = -3;
        int256 y = -5;
        uint256 z = FixedPointMathLib.dist(x, y);
        assertEq(z, 2);
    }

    function testMinUint() public {
        uint256 x = 3;
        uint256 y = 5;
        uint256 z = FixedPointMathLib.min(x, y);
        assertEq(z, 3);
    }

    function testMinInt() public {
        int256 x = -3;
        int256 y = 5;
        int256 z = FixedPointMathLib.min(x, y);
        assertEq(z, -3);
    }

    function testMaxUint() public {
        uint256 x = 3;
        uint256 y = 5;
        uint256 z = FixedPointMathLib.max(x, y);
        assertEq(z, 5);
    }

    function testMaxInt() public {
        int256 x = -3;
        int256 y = 5;
        int256 z = FixedPointMathLib.max(x, y);
        assertEq(z, 5);
    }

    function testClampUint() public {
        uint256 x = 4;
        uint256 minValue = 2;
        uint256 maxValue = 5;
        uint256 z = FixedPointMathLib.clamp(x, minValue, maxValue);
        assertEq(z, 4);
    }

    function testClampInt() public {
        int256 x = -4;
        int256 minValue = -2;
        int256 maxValue = 5;
        int256 z = FixedPointMathLib.clamp(x, minValue, maxValue);
        assertEq(z, -2);
    }

    function testGcdSimple() public {
        uint256 x = 12;
        uint256 y = 18;
        uint256 z = FixedPointMathLib.gcd(x, y);
        assertEq(z, 6);
    }

    function testRawAddUint() public {
        uint256 x = 1;
        uint256 y = 2;
        uint256 z = FixedPointMathLib.rawAdd(x, y);
        assertEq(z, 3);
    }

    function testRawAddInt() public {
        int256 x = -1;
        int256 y = 2;
        int256 z = FixedPointMathLib.rawAdd(x, y);
        assertEq(z, 1);
    }

    function testRawSubUint() public {
        uint256 x = 2;
        uint256 y = 1;
        uint256 z = FixedPointMathLib.rawSub(x, y);
        assertEq(z, 1);
    }

    function testRawSubInt() public {
        int256 x = -1;
        int256 y = 2;
        int256 z = FixedPointMathLib.rawSub(x, y);
        assertEq(z, -3);
    }

    function testRawMulUint() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 z = FixedPointMathLib.rawMul(x, y);
        assertEq(z, 6);
    }

    function testRawMulInt() public {
        int256 x = -2;
        int256 y = 3;
        int256 z = FixedPointMathLib.rawMul(x, y);
        assertEq(z, -6);
    }

    function testRawDivUintZeroY() public {
        uint256 x = 2;
        uint256 y = 0;
        uint256 z = FixedPointMathLib.rawDiv(x, y);
        assertEq(z, 0);
    }

    function testRawDivUintSimple() public {
        uint256 x = 6;
        uint256 y = 2;
        uint256 z = FixedPointMathLib.rawDiv(x, y);
        assertEq(z, 3);
    }

    function testRawSDivZeroY() public {
        int256 x = 2;
        int256 y = 0;
        int256 z = FixedPointMathLib.rawSDiv(x, y);
        assertEq(z, 0);
    }

    function testRawSDivSimple() public {
        int256 x = 6;
        int256 y = 2;
        int256 z = FixedPointMathLib.rawSDiv(x, y);
        assertEq(z, 3);
    }

    function testRawSDivNegative() public {
        int256 x = -6;
        int256 y = 2;
        int256 z = FixedPointMathLib.rawSDiv(x, y);
        assertEq(z, -3);
    }

    function testRawModUintZeroY() public {
        uint256 x = 7;
        uint256 y = 0;
        uint256 z = FixedPointMathLib.rawMod(x, y);
        assertEq(z, 0);
    }

    function testRawModUintSimple() public {
        uint256 x = 7;
        uint256 y = 2;
        uint256 z = FixedPointMathLib.rawMod(x, y);
        assertEq(z, 1);
    }

    function testRawSModZeroY() public {
        int256 x = 7;
        int256 y = 0;
        int256 z = FixedPointMathLib.rawSMod(x, y);
        assertEq(z, 0);
    }

    function testRawSModSimple() public {
        int256 x = 7;
        int256 y = 2;
        int256 z = FixedPointMathLib.rawSMod(x, y);
        assertEq(z, 1);
    }

    function testRawSModNegative() public {
        int256 x = -7;
        int256 y = 2;
        int256 z = FixedPointMathLib.rawSMod(x, y);
        assertEq(z, -1);
    }

    function testRawAddModZeroD() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 d = 0;
        uint256 z = FixedPointMathLib.rawAddMod(x, y, d);
        assertEq(z, 0);
    }

    function testRawAddModSimple() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 d = 2;
        uint256 z = FixedPointMathLib.rawAddMod(x, y, d);
        assertEq(z, 1);
    }

    function testRawMulModZeroD() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 d = 0;
        uint256 z = FixedPointMathLib.rawMulMod(x, y, d);
        assertEq(z, 0);
    }

    function testRawMulModSimple() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 d = 7;
        uint256 z = FixedPointMathLib.rawMulMod(x, y, d);
        assertEq(z, 6);
    }
}