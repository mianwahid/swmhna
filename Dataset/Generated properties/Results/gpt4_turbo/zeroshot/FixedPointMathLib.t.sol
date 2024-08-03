// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    uint256 constant WAD = 1e18;

    // Test mulWad with edge cases
    function testMulWad() public {
        assertEq(FixedPointMathLib.mulWad(0, 0), 0);
        assertEq(FixedPointMathLib.mulWad(1 * WAD, 1 * WAD), 1 * WAD);
        assertEq(FixedPointMathLib.mulWad(2 * WAD, 5 * WAD), 10 * WAD);
        assertEq(FixedPointMathLib.mulWad(type(uint256).max, 0), 0);
        vm.expectRevert(FixedPointMathLib.MulWadFailed.selector);
        FixedPointMathLib.mulWad(type(uint256).max, 2);
    }

    // Test sMulWad with edge cases
    function testSMulWad() public {
        assertEq(FixedPointMathLib.sMulWad(0, 0), 0);
        assertEq(FixedPointMathLib.sMulWad(1 * int256(WAD), -1 * int256(WAD)), -1 * int256(WAD));
        assertEq(FixedPointMathLib.sMulWad(-1 * int256(WAD), -1 * int256(WAD)), 1 * int256(WAD));
        vm.expectRevert(FixedPointMathLib.SMulWadFailed.selector);
        FixedPointMathLib.sMulWad(type(int256).min, -1);
    }

    // // Test divWad with edge cases
    // function testDivWad() public {
    //     assertEq(FixedPointMathLib.divWad(10 * WAD, 2), 5 * WAD);
    //     assertEq(FixedPointMathLib.divWad(0, 1), 0);
    //     vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
    //     FixedPointMathLib.divWad(1, 0);
    // }

    // // Test sDivWad with edge cases
    // function testSDivWad() public {
    //     assertEq(FixedPointMathLib.sDivWad(-10 * int256(WAD), 2), -5 * int256(WAD));
    //     assertEq(FixedPointMathLib.sDivWad(10 * int256(WAD), -2), -5 * int256(WAD));
    //     vm.expectRevert(FixedPointMathLib.SDivWadFailed.selector);
    //     FixedPointMathLib.sDivWad(1, 0);
    // }

    // Test expWad with edge cases
    function testExpWad() public {
        assertEq(FixedPointMathLib.expWad(0), int256(WAD));
        vm.expectRevert(FixedPointMathLib.ExpOverflow.selector);
        FixedPointMathLib.expWad(136 * int256(WAD));
    }

    // // Test lnWad with edge cases
    // function testLnWad() public {
    //     assertEq(FixedPointMathLib.lnWad(WAD), 0);
    //     vm.expectRevert(FixedPointMathLib.LnWadUndefined.selector);
    //     FixedPointMathLib.lnWad(0);
    // }

    // Test sqrtWad with edge cases
    function testSqrtWad() public {
        assertEq(FixedPointMathLib.sqrtWad(4 * WAD), 2 * WAD);
        assertEq(FixedPointMathLib.sqrtWad(0), 0);
    }

    // Test factorial with edge cases
    function testFactorial() public {
        assertEq(FixedPointMathLib.factorial(5), 120);
        vm.expectRevert(FixedPointMathLib.FactorialOverflow.selector);
        FixedPointMathLib.factorial(58);
    }

    // Test rpow with edge cases
    function testRPow() public {
        assertEq(FixedPointMathLib.rpow(2, 3, 1), 8);
        vm.expectRevert(FixedPointMathLib.RPowOverflow.selector);
        FixedPointMathLib.rpow(2, 256, 1);
    }

    // Test fullMulDiv with edge cases
    function testFullMulDiv() public {
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 1), 6);
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDiv(type(uint256).max, type(uint256).max, 1);
    }

    // Test mulDiv with edge cases
    function testMulDiv() public {
        assertEq(FixedPointMathLib.mulDiv(6, 2, 3), 4);
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        FixedPointMathLib.mulDiv(type(uint256).max, 2, 0);
    }
}
