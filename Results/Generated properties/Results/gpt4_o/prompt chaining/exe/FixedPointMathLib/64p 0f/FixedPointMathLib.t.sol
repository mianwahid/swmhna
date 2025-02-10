// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    // Custom Errors
    function testExpOverflow() public {
        int256 maxInput = 135305999368893231589;
        vm.expectRevert(FixedPointMathLib.ExpOverflow.selector);
        FixedPointMathLib.expWad(maxInput + 1);
    }

    function testFactorialOverflow() public {
        uint256 maxInput = 58;
        vm.expectRevert(FixedPointMathLib.FactorialOverflow.selector);
        FixedPointMathLib.factorial(maxInput);
    }

    function testRPowOverflow() public {
        uint256 x = 2**128;
        uint256 y = 2;
        uint256 b = 1;
        vm.expectRevert(FixedPointMathLib.RPowOverflow.selector);
        FixedPointMathLib.rpow(x, y, b);
    }

    function testMantissaOverflow() public {
        uint256 largeMantissa = 2**249;
        vm.expectRevert(FixedPointMathLib.MantissaOverflow.selector);
        FixedPointMathLib.packSci(largeMantissa);
    }

    function testMulWadFailed() public {
        uint256 x = type(uint256).max;
        uint256 y = 2;
        vm.expectRevert(FixedPointMathLib.MulWadFailed.selector);
        FixedPointMathLib.mulWad(x, y);
    }

    function testSMulWadFailed() public {
        int256 x = type(int256).min;
        int256 y = -1;
        vm.expectRevert(FixedPointMathLib.SMulWadFailed.selector);
        FixedPointMathLib.sMulWad(x, y);
    }

    function testDivWadFailed() public {
        uint256 x = 1;
        uint256 y = 0;
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        FixedPointMathLib.divWad(x, y);
    }

    function testSDivWadFailed() public {
        int256 x = 1;
        int256 y = 0;
        vm.expectRevert(FixedPointMathLib.SDivWadFailed.selector);
        FixedPointMathLib.sDivWad(x, y);
    }

    function testMulDivFailed() public {
        uint256 x = type(uint256).max;
        uint256 y = 2;
        uint256 d = 0;
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        FixedPointMathLib.mulDiv(x, y, d);
    }

    function testDivFailed() public {
        uint256 x = 1;
        uint256 d = 0;
        vm.expectRevert(FixedPointMathLib.DivFailed.selector);
        FixedPointMathLib.divUp(x, d);
    }

    function testFullMulDivFailed() public {
        uint256 x = type(uint256).max;
        uint256 y = 2;
        uint256 d = 0;
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDiv(x, y, d);
    }

    function testLnWadUndefined() public {
        int256 x = 0;
        vm.expectRevert(FixedPointMathLib.LnWadUndefined.selector);
        FixedPointMathLib.lnWad(x);
    }

    function testOutOfDomain() public {
        int256 x = -367879441171442322 - 1;
        vm.expectRevert(FixedPointMathLib.OutOfDomain.selector);
        FixedPointMathLib.lambertW0Wad(x);
    }

    // Simplified Fixed Point Operations
    function testMulWad() public {
        uint256 x = 2e18;
        uint256 y = 3e18;
        uint256 expected = 6e18;
        assertEq(FixedPointMathLib.mulWad(x, y), expected);
    }

    function testSMulWad() public {
        int256 x = 2e18;
        int256 y = 3e18;
        int256 expected = 6e18;
        assertEq(FixedPointMathLib.sMulWad(x, y), expected);
    }

    function testRawMulWad() public {
        uint256 x = 2e18;
        uint256 y = 3e18;
        uint256 expected = 6e18;
        assertEq(FixedPointMathLib.rawMulWad(x, y), expected);
    }

    function testRawSMulWad() public {
        int256 x = 2e18;
        int256 y = 3e18;
        int256 expected = 6e18;
        assertEq(FixedPointMathLib.rawSMulWad(x, y), expected);
    }

    function testMulWadUp() public {
        uint256 x = 2e18;
        uint256 y = 3e18;
        uint256 expected = 6e18;
        assertEq(FixedPointMathLib.mulWadUp(x, y), expected);
    }

    function testRawMulWadUp() public {
        uint256 x = 2e18;
        uint256 y = 3e18;
        uint256 expected = 6e18;
        assertEq(FixedPointMathLib.rawMulWadUp(x, y), expected);
    }

    function testDivWad() public {
        uint256 x = 6e18;
        uint256 y = 3e18;
        uint256 expected = 2e18;
        assertEq(FixedPointMathLib.divWad(x, y), expected);
    }

    function testSDivWad() public {
        int256 x = 6e18;
        int256 y = 3e18;
        int256 expected = 2e18;
        assertEq(FixedPointMathLib.sDivWad(x, y), expected);
    }

    function testRawDivWad() public {
        uint256 x = 6e18;
        uint256 y = 3e18;
        uint256 expected = 2e18;
        assertEq(FixedPointMathLib.rawDivWad(x, y), expected);
    }

    function testRawSDivWad() public {
        int256 x = 6e18;
        int256 y = 3e18;
        int256 expected = 2e18;
        assertEq(FixedPointMathLib.rawSDivWad(x, y), expected);
    }

    function testDivWadUp() public {
        uint256 x = 6e18;
        uint256 y = 3e18;
        uint256 expected = 2e18;
        assertEq(FixedPointMathLib.divWadUp(x, y), expected);
    }

    function testRawDivWadUp() public {
        uint256 x = 6e18;
        uint256 y = 3e18;
        uint256 expected = 2e18;
        assertEq(FixedPointMathLib.rawDivWadUp(x, y), expected);
    }

    function testPowWad() public {
        int256 x = 2e18;
        int256 y = 3e18;

        assertEq(FixedPointMathLib.powWad(x, y), 7999999999999999989);
    }

    function testExpWad() public {
        int256 x = 1e18;
        int256 expected = 2718281828459045235; // Approximation of e
        assertEq(FixedPointMathLib.expWad(x), expected);
    }

    function testLnWad() public {
        int256 x = 2718281828459045235; // Approximation of e
        int256 expected = 1e18-1;
        assertEq(FixedPointMathLib.lnWad(x), expected);
    }

    function testLambertW0Wad() public {
        int256 x = 1e18;
        int256 expected = 567143290409783872; // Approximation of W(1)
        assertEq(FixedPointMathLib.lambertW0Wad(x), expected);
    }

    // General Number Utilities
    function testFullMulDiv() public {
        uint256 x = 6;
        uint256 y = 3;
        uint256 d = 2;
        uint256 expected = 9;
        assertEq(FixedPointMathLib.fullMulDiv(x, y, d), expected);
    }

    function testFullMulDivUp() public {
        uint256 x = 6;
        uint256 y = 3;
        uint256 d = 2;
        uint256 expected = 9;
        assertEq(FixedPointMathLib.fullMulDivUp(x, y, d), expected);
    }

    function testMulDiv() public {
        uint256 x = 6;
        uint256 y = 3;
        uint256 d = 2;
        uint256 expected = 9;
        assertEq(FixedPointMathLib.mulDiv(x, y, d), expected);
    }

    function testMulDivUp() public {
        uint256 x = 6;
        uint256 y = 3;
        uint256 d = 2;
        uint256 expected = 9;
        assertEq(FixedPointMathLib.mulDivUp(x, y, d), expected);
    }

    function testDivUp() public {
        uint256 x = 6;
        uint256 d = 4;
        uint256 expected = 2;
        assertEq(FixedPointMathLib.divUp(x, d), expected);
    }

    function testZeroFloorSub() public {
        uint256 x = 6;
        uint256 y = 4;
        uint256 expected = 2;
        assertEq(FixedPointMathLib.zeroFloorSub(x, y), expected);
    }

    function testRpow() public {
        uint256 x = 2;
        uint256 y = 3;
        uint256 b = 1;
        uint256 expected = 8;
        assertEq(FixedPointMathLib.rpow(x, y, b), expected);
    }

    function testSqrt() public {
        uint256 x = 16;
        uint256 expected = 4;
        assertEq(FixedPointMathLib.sqrt(x), expected);
    }

    function testCbrt() public {
        uint256 x = 27;
        uint256 expected = 3;
        assertEq(FixedPointMathLib.cbrt(x), expected);
    }

    function testSqrtWad() public {
        uint256 x = 16e18;
        uint256 expected = 4e18;
        assertEq(FixedPointMathLib.sqrtWad(x), expected);
    }

    function testCbrtWad() public {
        uint256 x = 27e18;
        uint256 expected = 3e18;
        assertEq(FixedPointMathLib.cbrtWad(x), expected);
    }

    function testFactorial() public {
        uint256 x = 5;
        uint256 expected = 120;
        assertEq(FixedPointMathLib.factorial(x), expected);
    }

    function testLog2() public {
        uint256 x = 16;
        uint256 expected = 4;
        assertEq(FixedPointMathLib.log2(x), expected);
    }

    function testLog2Up() public {
        uint256 x = 16;
        uint256 expected = 4;
        assertEq(FixedPointMathLib.log2Up(x), expected);
    }

    function testLog10() public {
        uint256 x = 1000;
        uint256 expected = 3;
        assertEq(FixedPointMathLib.log10(x), expected);
    }

    function testLog10Up() public {
        uint256 x = 1000;
        uint256 expected = 3;
        assertEq(FixedPointMathLib.log10Up(x), expected);
    }

    function testLog256() public {
        uint256 x = 256;
        uint256 expected = 1;
        assertEq(FixedPointMathLib.log256(x), expected);
    }

    function testLog256Up() public {
        uint256 x = 256;
        uint256 expected = 1;
        assertEq(FixedPointMathLib.log256Up(x), expected);
    }

    function testSci() public {
        uint256 x = 1234567890;
        (uint256 mantissa, uint256 exponent) = FixedPointMathLib.sci(x);
        assertEq(mantissa, 123456789);
        assertEq(exponent, 1);
    }

    function testPackSci() public {
        uint256 x = 1234567890;
        uint256 packed = FixedPointMathLib.packSci(x);
        assertEq(packed, 15802468993);
    }

    function testUnpackSci() public {
        uint256 packed = 1234567890 << 7;
        uint256 unpacked = FixedPointMathLib.unpackSci(packed);
        assertEq(unpacked, 1234567890);
    }

    function testAvg() public {
        uint256 x = 4;
        uint256 y = 6;
        uint256 expected = 5;
        assertEq(FixedPointMathLib.avg(x, y), expected);
    }

    function testAbs() public {
        int256 x = -4;
        uint256 expected = 4;
        assertEq(FixedPointMathLib.abs(x), expected);
    }

    function testDist() public {
        int256 x = 4;
        int256 y = 6;
        uint256 expected = 2;
        assertEq(FixedPointMathLib.dist(x, y), expected);
    }

    function testMin() public {
        uint256 x = 4;
        uint256 y = 6;
        uint256 expected = 4;
        assertEq(FixedPointMathLib.min(x, y), expected);
    }

    function testMax() public {
        uint256 x = 4;
        uint256 y = 6;
        uint256 expected = 6;
        assertEq(FixedPointMathLib.max(x, y), expected);
    }

    function testClamp() public {
        uint256 x = 5;
        uint256 minValue = 4;
        uint256 maxValue = 6;
        uint256 expected = 5;
        assertEq(FixedPointMathLib.clamp(x, minValue, maxValue), expected);
    }

    function testGcd() public {
        uint256 x = 12;
        uint256 y = 15;
        uint256 expected = 3;
        assertEq(FixedPointMathLib.gcd(x, y), expected);
    }

    // Raw Number Operations
    function testRawAdd() public {
        uint256 x = 4;
        uint256 y = 6;
        uint256 expected = 10;
        assertEq(FixedPointMathLib.rawAdd(x, y), expected);
    }

    function testRawSub() public {
        uint256 x = 6;
        uint256 y = 4;
        uint256 expected = 2;
        assertEq(FixedPointMathLib.rawSub(x, y), expected);
    }

    function testRawMul() public {
        uint256 x = 4;
        uint256 y = 6;
        uint256 expected = 24;
        assertEq(FixedPointMathLib.rawMul(x, y), expected);
    }

    function testRawDiv() public {
        uint256 x = 6;
        uint256 y = 3;
        uint256 expected = 2;
        assertEq(FixedPointMathLib.rawDiv(x, y), expected);
    }

    function testRawMod() public {
        uint256 x = 7;
        uint256 y = 3;
        uint256 expected = 1;
        assertEq(FixedPointMathLib.rawMod(x, y), expected);
    }

    function testRawAddMod() public {
        uint256 x = 7;
        uint256 y = 3;
        uint256 d = 5;
        uint256 expected = 0;
        assertEq(FixedPointMathLib.rawAddMod(x, y, d), expected);
    }

    function testRawMulMod() public {
        uint256 x = 7;
        uint256 y = 3;
        uint256 d = 5;
        uint256 expected = 1;
        assertEq(FixedPointMathLib.rawMulMod(x, y, d), expected);
    }
}