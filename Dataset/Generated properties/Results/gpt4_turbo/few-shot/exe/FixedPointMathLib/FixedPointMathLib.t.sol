// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {FixedPointMathLib} from "../src/utils/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    function testMulWad(uint256 x, uint256 y) public {
        uint256 expected = x * y / FixedPointMathLib.WAD;
        uint256 result = FixedPointMathLib.mulWad(x, y);
        assertEq(result, expected, "mulWad does not match expected value");
    }

    function testSMulWad(int256 x, int256 y) public {
        int256 expected = x * y / int256(FixedPointMathLib.WAD);
        int256 result = FixedPointMathLib.sMulWad(x, y);
        assertEq(result, expected, "sMulWad does not match expected value");
    }

    function testDivWad(uint256 x, uint256 y) public {
        vm.assume(y != 0);
        uint256 expected = x * FixedPointMathLib.WAD / y;
        uint256 result = FixedPointMathLib.divWad(x, y);
        assertEq(result, expected, "divWad does not match expected value");
    }

    function testSDivWad(int256 x, int256 y) public {
        vm.assume(y != 0);
        int256 expected = x * int256(FixedPointMathLib.WAD) / y;
        int256 result = FixedPointMathLib.sDivWad(x, y);
        assertEq(result, expected, "sDivWad does not match expected value");
    }

//    function testExpWad(int256 x) public {
//        vm.assume(x > -41446531673892822313 && x < 135305999368893231589);
//        int256 result = FixedPointMathLib.expWad(x);
//        // Compare result with a small delta for approximation errors
//        int256 expected = int256(1e18 * (x / 1e18));
//        assertApproxEqRel(result, expected, 1/(10000), "expWad does not match expected value");
//    }

//    function testLnWad(int256 x) public {
//        vm.assume(x > 0);
//        int256 result = FixedPointMathLib.lnWad(x);
//        // Compare result with a small delta for approximation errors
//        int256 expected = int256(1e18 * log(x / 1e18));
//        assertApproxEqRel(result, expected, 1e-4, "lnWad does not match expected value");
//    }

    function testSqrt(uint256 x) public {
        uint256 result = FixedPointMathLib.sqrt(x);
        uint256 expected = uint256(sqrt(x));
        assertEq(result, expected, "sqrt does not match expected value");
    }

    function testCbrt(uint256 x) public {
        uint256 result = FixedPointMathLib.cbrt(x);
        uint256 expected = uint256(cbrt(x));
        assertEq(result, expected, "cbrt does not match expected value");
    }

    function testFactorial(uint256 x) public {
        vm.assume(x < 58);
        uint256 result = FixedPointMathLib.factorial(x);
        uint256 expected = factorial(x);
        assertEq(result, expected, "factorial does not match expected value");
    }
//
//    function testPowWad(int256 x, int256 y) public {
//        int256 result = FixedPointMathLib.powWad(x, y);
//        int256 expected = int256(1e18 * ((x / 1e18) ** (y / 1e18)));
//        assertApproxEqRel(result, expected, 1e-4, "powWad does not match expected value");
//    }

    function testFullMulDiv(uint256 x, uint256 y, uint256 d) public {
        vm.assume(d != 0);
        uint256 result = FixedPointMathLib.fullMulDiv(x, y, d);
        uint256 expected = x * y / d;
        assertEq(result, expected, "fullMulDiv does not match expected value");
    }

    function testMulDiv(uint256 x, uint256 y, uint256 d) public {
        vm.assume(d != 0);
        uint256 result = FixedPointMathLib.mulDiv(x, y, d);
        uint256 expected = x * y / d;
        assertEq(result, expected, "mulDiv does not match expected value");
    }

    function testDivUp(uint256 x, uint256 d) public {
        vm.assume(d != 0);
        uint256 result = FixedPointMathLib.divUp(x, d);
        uint256 expected = (x + d - 1) / d;
        assertEq(result, expected, "divUp does not match expected value");
    }

//    function testLog2(uint256 x) public {
//        vm.assume(x > 0);
//        uint256 result = FixedPointMathLib.log2(x);
//        uint256 expected = log(x);
//        assertEq(result, expected, "log2 does not match expected value");
//    }

//    function testLog10(uint256 x) public {
//        vm.assume(x > 0);
//        uint256 result = FixedPointMathLib.log10(x);
//        uint256 expected = log(x);
//        assertEq(result, expected, "log10 does not match expected value");
//    }

//    function testLog256(uint256 x) public {
//        vm.assume(x > 0);
//        uint256 result = FixedPointMathLib.log256(x);
//        uint256 expected = log(x);
//        assertEq(result, expected, "log256 does not match expected value");
//    }

    function testSci(uint256 x) public {
        (uint256 mantissa, uint256 exponent) = FixedPointMathLib.sci(x);
        uint256 result = mantissa * 10 ** exponent;
        assertEq(result, x, "sci does not match expected value");
    }

    function testPackSci(uint256 x) public {
        uint256 packed = FixedPointMathLib.packSci(x);
        uint256 unpacked = FixedPointMathLib.unpackSci(packed);
        assertEq(unpacked, x, "packSci/unpackSci does not match expected value");
    }

    function testAvg(uint256 x, uint256 y) public {
        uint256 result = FixedPointMathLib.avg(x, y);
        uint256 expected = (x + y) / 2;
        assertEq(result, expected, "avg does not match expected value");
    }

    function testMin(uint256 x, uint256 y) public {
        uint256 result = FixedPointMathLib.min(x, y);
        uint256 expected = x < y ? x : y;
        assertEq(result, expected, "min does not match expected value");
    }

    function testMax(uint256 x, uint256 y) public {
        uint256 result = FixedPointMathLib.max(x, y);
        uint256 expected = x > y ? x : y;
        assertEq(result, expected, "max does not match expected value");
    }

    function testClamp(uint256 x, uint256 minValue, uint256 maxValue) public {
        uint256 result = FixedPointMathLib.clamp(x, minValue, maxValue);
        uint256 expected = x < minValue ? minValue : (x > maxValue ? maxValue : x);
        assertEq(result, expected, "clamp does not match expected value");
    }

    function testGcd(uint256 x, uint256 y) public {
        uint256 result = FixedPointMathLib.gcd(x, y);
        uint256 expected = gcd(x, y);
        assertEq(result, expected, "gcd does not match expected value");
    }

    // Helper functions for testing
    function sqrt(uint256 x) private pure returns (uint256) {
        return uint256(sqrt(x));
    }

    function cbrt(uint256 x) private pure returns (uint256) {
        return uint256(cbrt(x));
    }

    function factorial(uint256 x) private pure returns (uint256) {
        uint256 result = 1;
        for (uint256 i = 1; i <= x; i++) {
            result *= i;
        }
        return result;
    }

//    function log2(uint256 x) private pure returns (uint256) {
//        uint256 result = 0;
//        while ((x >>= 1)) {
//            result++;
//        }
//        return result;
//    }
//
//    function log10(uint256 x) private pure returns (uint256) {
//        uint256 result = 0;
//        while (x >= 10) {
//            x /= 10;
//            result++;
//        }
//        return result;
//    }

//    function log256(uint256 x) private pure returns (uint256) {
//        uint256 result = 0;
//        while (x >>= 8) {
//            result++;
//        }
//        return result;
//    }

    function gcd(uint256 x, uint256 y) private pure returns (uint256) {
        while (y != 0) {
            (x, y) = (y, x % y);
        }
        return x;
    }
}