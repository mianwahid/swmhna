// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/FixedPointMathLib.sol";

contract FixedPointMathLibTest is Test {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;

    uint256 constant MAX_UINT = type(uint256).max;
    int256 constant MAX_INT = type(int256).max;
    int256 constant MIN_INT = type(int256).min;

    function testMulWadOverflow() public {
        uint256 x = MAX_UINT / FixedPointMathLib.WAD + 1;
        uint256 y = FixedPointMathLib.WAD;
        vm.expectRevert(FixedPointMathLib.MulWadFailed.selector);
        x.mulWad(y);
    }

    function testSMulWadOverflow() public {
        int256 x = MAX_INT;
        int256 y = 2;
        vm.expectRevert(FixedPointMathLib.SMulWadFailed.selector);
        x.sMulWad(y);
    }

    function testDivWadZeroDenominator() public {
        uint256 x = 123;
        uint256 y = 0;
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        x.divWad(y);
    }

    function testSDivWadZeroDenominator() public {
        int256 x = -123;
        int256 y = 0;
        vm.expectRevert(FixedPointMathLib.SDivWadFailed.selector);
        x.sDivWad(y);
    }

    function testMulWadUpRounding() public {
        uint256 x = 1;
        uint256 y = FixedPointMathLib.WAD / 2 + 1;
        uint256 result = x.mulWadUp(y);
        assertEq(result, 1);
    }

    // function testDivWadUpRounding() public {
    //     uint256 x = FixedPointMathLib.WAD / 2 + 1;
    //     uint256 y = 1;
    //     uint256 result = x.divWadUp(y);
    //     assertEq(result, FixedPointMathLib.WAD);
    // }

    function testFullMulDivOverflow() public {
        uint256 x = MAX_UINT;
        uint256 y = 2;
        uint256 d = 1;
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        x.fullMulDiv(y, d);
    }

    function testMulDivOverflow() public {
        uint256 x = MAX_UINT;
        uint256 y = 2;
        uint256 d = 1;
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        x.mulDiv(y, d);
    }

    function testDivUpZeroDenominator() public {
        uint256 x = 123;
        uint256 y = 0;
        vm.expectRevert(FixedPointMathLib.DivFailed.selector);
        x.divUp(y);
    }

    function testZeroFloorSubNegativeResult() public {
        uint256 x = 10;
        uint256 y = 20;
        uint256 result = x.zeroFloorSub(y);
        assertEq(result, 0);
    }

    // function testRPowOverflow() public {
    //     uint256 x = 2;
    //     uint256 y = 256;
    //     uint256 b = 10;
    //     vm.expectRevert(FixedPointMathLib.RPowOverflow.selector);
    //     x.rpow(y, b);
    // }

    function testSqrtCorrectness() public {
        uint256 x = 16;
        uint256 result = x.sqrt();
        assertEq(result, 4);
    }

    function testCbrtCorrectness() public {
        uint256 x = 27;
        uint256 result = x.cbrt();
        assertEq(result, 3);
    }

    function testFactorialOverflow() public {
        uint256 x = 58;
        vm.expectRevert(FixedPointMathLib.FactorialOverflow.selector);
        x.factorial();
    }

    function testLog2Correctness() public {
        uint256 x = 16;
        uint256 result = x.log2();
        assertEq(result, 4);
    }

    function testSciPackUnpack() public {
        uint256 x = 123456789012345678901234567890;
        uint256 packed = x.packSci();
        uint256 unpacked = packed.unpackSci();
        assertEq(unpacked, x);
    }

    function testAvgCorrectness() public {
        uint256 x = 10;
        uint256 y = 20;
        uint256 result = x.avg(y);
        assertEq(result, 15);
    }

    function testMinCorrectness() public {
        uint256 x = 10;
        uint256 y = 20;
        uint256 result = x.min(y);
        assertEq(result, 10);
    }

    function testMaxCorrectness() public {
        uint256 x = 10;
        uint256 y = 20;
        uint256 result = x.max(y);
        assertEq(result, 20);
    }

    function testClampCorrectness() public {
        uint256 x = 15;
        uint256 minValue = 10;
        uint256 maxValue = 20;
        uint256 result = x.clamp(minValue, maxValue);
        assertEq(result, 15);
    }

    function testRawDivZeroDenominator() public {
        uint256 x = 123;
        uint256 y = 0;
        uint256 result = x.rawDiv(y);
        assertEq(result, 0);
    }
}
