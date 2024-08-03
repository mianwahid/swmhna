// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    function testMulWad() public {
        assertEq(FixedPointMathLib.mulWad(2e18, 3e18), 6e18);
        assertEq(FixedPointMathLib.mulWad(1e18, 1e18), 1e18);
    }

    function testSMulWad() public {
        assertEq(FixedPointMathLib.sMulWad(2e18, 3e18), 6e18);
        assertEq(FixedPointMathLib.sMulWad(-2e18, 3e18), -6e18);
    }

    function testDivWad() public {
        assertEq(FixedPointMathLib.divWad(6e18, 3e18), 2e18);
        assertEq(FixedPointMathLib.divWad(1e18, 1e18), 1e18);
    }

    function testSDivWad() public {
        assertEq(FixedPointMathLib.sDivWad(6e18, 3e18), 2e18);
        assertEq(FixedPointMathLib.sDivWad(-6e18, 3e18), -2e18);
    }

    function testPowWad() public {
        assertEq(FixedPointMathLib.powWad(2e18, 3e18), 8e18);
    }

    function testExpWad() public {
        assertEq(FixedPointMathLib.expWad(0), 1e18);
        assertEq(FixedPointMathLib.expWad(1e18), 2718281828459045235); // Approximation of e
    }

    function testLnWad() public {
        assertEq(FixedPointMathLib.lnWad(1e18), 0);
        assertEq(FixedPointMathLib.lnWad(2718281828459045235), 1e18); // Approximation of ln(e)
    }

    function testLambertW0Wad() public {
        assertEq(FixedPointMathLib.lambertW0Wad(1e18), 567143290409784109); // Approximation of W(1)
    }

    function testFullMulDiv() public {
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 1), 6);
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 2), 3);
    }

    function testFullMulDivUp() public {
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 1), 6);
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 2), 4);
    }

    function testMulDiv() public {
        assertEq(FixedPointMathLib.mulDiv(2, 3, 1), 6);
        assertEq(FixedPointMathLib.mulDiv(2, 3, 2), 3);
    }

    function testMulDivUp() public {
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 1), 6);
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 2), 4);
    }

    function testDivUp() public {
        assertEq(FixedPointMathLib.divUp(5, 2), 3);
        assertEq(FixedPointMathLib.divUp(4, 2), 2);
    }

    function testZeroFloorSub() public {
        assertEq(FixedPointMathLib.zeroFloorSub(5, 3), 2);
        assertEq(FixedPointMathLib.zeroFloorSub(3, 5), 0);
    }

    function testRPow() public {
        assertEq(FixedPointMathLib.rpow(2, 3, 1), 8);
    }

    function testSqrt() public {
        assertEq(FixedPointMathLib.sqrt(4), 2);
        assertEq(FixedPointMathLib.sqrt(9), 3);
    }

    function testCbrt() public {
        assertEq(FixedPointMathLib.cbrt(8), 2);
        assertEq(FixedPointMathLib.cbrt(27), 3);
    }

    function testSqrtWad() public {
        assertEq(FixedPointMathLib.sqrtWad(4e18), 2e18);
        assertEq(FixedPointMathLib.sqrtWad(9e18), 3e18);
    }

    function testCbrtWad() public {
        assertEq(FixedPointMathLib.cbrtWad(8e18), 2e18);
        assertEq(FixedPointMathLib.cbrtWad(27e18), 3e18);
    }

    function testFactorial() public {
        assertEq(FixedPointMathLib.factorial(5), 120);
        assertEq(FixedPointMathLib.factorial(0), 1);
    }

    function testLog2() public {
        assertEq(FixedPointMathLib.log2(8), 3);
        assertEq(FixedPointMathLib.log2(16), 4);
    }

    function testLog2Up() public {
        assertEq(FixedPointMathLib.log2Up(8), 3);
        assertEq(FixedPointMathLib.log2Up(9), 4);
    }

    function testLog10() public {
        assertEq(FixedPointMathLib.log10(100), 2);
        assertEq(FixedPointMathLib.log10(1000), 3);
    }

    function testLog10Up() public {
        assertEq(FixedPointMathLib.log10Up(100), 2);
        assertEq(FixedPointMathLib.log10Up(101), 3);
    }

    function testLog256() public {
        assertEq(FixedPointMathLib.log256(256), 1);
        assertEq(FixedPointMathLib.log256(65536), 2);
    }

    function testLog256Up() public {
        assertEq(FixedPointMathLib.log256Up(256), 1);
        assertEq(FixedPointMathLib.log256Up(257), 2);
    }

    function testSci() public {
        (uint256 mantissa, uint256 exponent) = FixedPointMathLib.sci(1234567890);
        assertEq(mantissa, 123456789);
        assertEq(exponent, 1);
    }

    function testPackSci() public {
        uint256 packed = FixedPointMathLib.packSci(1234567890);
        assertEq(packed, 123456789 << 7 | 1);
    }

    function testUnpackSci() public {
        uint256 unpacked = FixedPointMathLib.unpackSci(123456789 << 7 | 1);
        assertEq(unpacked, 1234567890);
    }

    function testAvg() public {
        assertEq(FixedPointMathLib.avg(4, 6), 5);
        assertEq(FixedPointMathLib.avg(-4, 6), 1);
    }

    function testAbs() public {
        assertEq(FixedPointMathLib.abs(-5), 5);
        assertEq(FixedPointMathLib.abs(5), 5);
    }

    function testDist() public {
        assertEq(FixedPointMathLib.dist(5, 3), 2);
        assertEq(FixedPointMathLib.dist(-5, 3), 8);
    }

    function testMin() public {
        assertEq(FixedPointMathLib.min(5, 3), 3);
        assertEq(FixedPointMathLib.min(-5, 3), -5);
    }

    function testMax() public {
        assertEq(FixedPointMathLib.max(5, 3), 5);
        assertEq(FixedPointMathLib.max(-5, 3), 3);
    }

    function testClamp() public {
        assertEq(FixedPointMathLib.clamp(5, 3, 7), 5);
        assertEq(FixedPointMathLib.clamp(2, 3, 7), 3);
        assertEq(FixedPointMathLib.clamp(8, 3, 7), 7);
    }

    function testGcd() public {
        assertEq(FixedPointMathLib.gcd(12, 8), 4);
        assertEq(FixedPointMathLib.gcd(12, 5), 1);
    }

    function testRawAdd() public {
        assertEq(FixedPointMathLib.rawAdd(5, 3), 8);
    }

    function testRawSub() public {
        assertEq(FixedPointMathLib.rawSub(5, 3), 2);
    }

    function testRawMul() public {
        assertEq(FixedPointMathLib.rawMul(5, 3), 15);
    }

    function testRawDiv() public {
        assertEq(FixedPointMathLib.rawDiv(6, 3), 2);
    }

    function testRawMod() public {
        assertEq(FixedPointMathLib.rawMod(5, 3), 2);
    }

    function testRawAddMod() public {
        assertEq(FixedPointMathLib.rawAddMod(5, 3, 4), 0);
    }

    function testRawMulMod() public {
        assertEq(FixedPointMathLib.rawMulMod(5, 3, 4), 3);
    }
}