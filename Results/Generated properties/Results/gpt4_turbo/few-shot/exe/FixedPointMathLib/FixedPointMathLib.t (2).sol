// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

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
//        if (x > -41446531673892822313 && x < 135305999368893231589) {
//            int256 result = FixedPointMathLib.expWad(x);
//            int256 expected = int256(1e18 * exp(x / 1e18));
//            assertApproxEqRel(result, expected, 1e-4, "expWad does not match expected value");
//        }
//    }

//    function testLnWad(int256 x) public {
//        vm.assume(x > 0);
//        int256 result = FixedPointMathLib.lnWad(x);
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
        vm.assume(x < 21); // Factorial grows very fast, limit to reasonable numbers
        uint256 result = FixedPointMathLib.factorial(x);
        uint256 expected = factorial(x);
        assertEq(result, expected, "factorial does not match expected value");
    }

    function factorial(uint256 n) internal pure returns (uint256) {
        uint256 result = 1;
        for (uint256 i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }

    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function cbrt(uint256 x) internal pure returns (uint256) {
        uint256 s = x;
        uint256 n = 0;
        uint256 b = 0;
        for (uint256 a = 1; a <= s; a *= 8) {
            b = 3 * n * (n + 1) + 1;
            if (s - a < b) break;
            s -= a;
            n++;
        }
        return n;
    }
}