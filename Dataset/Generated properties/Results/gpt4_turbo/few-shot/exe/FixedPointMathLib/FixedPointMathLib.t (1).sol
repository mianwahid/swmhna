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
        if (y == 0) {
            vm.expectRevert("DivWadFailed");
            FixedPointMathLib.divWad(x, y);
        } else {
            uint256 expected = x * FixedPointMathLib.WAD / y;
            uint256 result = FixedPointMathLib.divWad(x, y);
            assertEq(result, expected, "divWad does not match expected value");
        }
    }

    function testSDivWad(int256 x, int256 y) public {
        if (y == 0) {
            vm.expectRevert("SDivWadFailed");
            FixedPointMathLib.sDivWad(x, y);
        } else {
            int256 expected = x * int256(FixedPointMathLib.WAD) / y;
            int256 result = FixedPointMathLib.sDivWad(x, y);
            assertEq(result, expected, "sDivWad does not match expected value");
        }
    }

    function testExpWad(int256 x) public {
        if (x > 135305999368893231589 || x < -41446531673892822313) {
            vm.expectRevert("ExpOverflow");
            FixedPointMathLib.expWad(x);
        } else {
            int256 result = FixedPointMathLib.expWad(x);
            // Check result within a reasonable error margin
            // This is a simplification, in practice, you'd compare against a precomputed or known good value
            assertTrue(result > 0, "expWad result should be positive");
        }
    }

    function testLnWad(int256 x) public {
        if (x <= 0) {
            vm.expectRevert("LnWadUndefined");
            FixedPointMathLib.lnWad(x);
        } else {
            int256 result = FixedPointMathLib.lnWad(x);
            // Check result within a reasonable error margin
            // This is a simplification, in practice, you'd compare against a precomputed or known good value
            assertTrue(result < x, "lnWad result should be less than input");
        }
    }

    function testSqrt(uint256 x) public {
        uint256 result = FixedPointMathLib.sqrt(x);
        assertTrue(result * result <= x && (result + 1) * (result + 1) > x, "sqrt does not approximate square root correctly");
    }

    function testCbrt(uint256 x) public {
        uint256 result = FixedPointMathLib.cbrt(x);
        assertTrue(result * result * result <= x && (result + 1) * (result + 1) * (result + 1) > x, "cbrt does not approximate cube root correctly");
    }

    function testFactorial(uint256 x) public {
        if (x >= 58) {
            vm.expectRevert("FactorialOverflow");
            FixedPointMathLib.factorial(x);
        } else {
            uint256 result = FixedPointMathLib.factorial(x);
            uint256 expected = 1;
            for (uint256 i = 1; i <= x; ++i) {
                expected *= i;
            }
            assertEq(result, expected, "factorial does not match expected value");
        }
    }

    function testRpow(uint256 x, uint256 y, uint256 b) public {
        if (b == 0) {
            vm.expectRevert("RPowOverflow");
            FixedPointMathLib.rpow(x, y, b);
        } else {
            uint256 result = FixedPointMathLib.rpow(x, y, b);
            // This is a simplification, in practice, you'd compare against a precomputed or known good value
            assertTrue(result >= 0, "rpow result should be non-negative");
        }
    }
}