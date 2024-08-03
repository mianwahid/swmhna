// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/FixedPointMathLib.sol";
contract FixedPointMathLibTest is Test {
//    function testMulWad() public {
//        assertEq(FixedPointMathLib.mulWad(1e18, 1e18), 1e18);
//        assertEq(FixedPointMathLib.mulWad(2e18, 1e18), 2e18);
//        assertEq(FixedPointMathLib.mulWad(1e18, 2e18), 2e18);
//        assertEq(FixedPointMathLib.mulWad(2e18, 2e18), 4e18);
//        assertEq(FixedPointMathLib.mulWad(0, 1e18), 0);
//        assertEq(FixedPointMathLib.mulWad(1e18, 0), 0);
//        assertEq(FixedPointMathLib.mulWad(type(uint256).max, 1e18), type(uint256).max);
//    }

    function testMulWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.MulWadFailed.selector);
        FixedPointMathLib.mulWad(type(uint256).max, 2e18);
    }

    function testSMulWad() public {
        assertEq(FixedPointMathLib.sMulWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.sMulWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.sMulWad(1e18, 2e18), 2e18);
        assertEq(FixedPointMathLib.sMulWad(2e18, 2e18), 4e18);
        assertEq(FixedPointMathLib.sMulWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.sMulWad(1e18, 0), 0);
        assertEq(FixedPointMathLib.sMulWad(-1e18, -1e18), 1e18);
        assertEq(FixedPointMathLib.sMulWad(-2e18, -1e18), 2e18);
        assertEq(FixedPointMathLib.sMulWad(-1e18, -2e18), 2e18);
        assertEq(FixedPointMathLib.sMulWad(-2e18, -2e18), 4e18);
        assertEq(FixedPointMathLib.sMulWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.sMulWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.sMulWad(-1e18, 2e18), -2e18);
        assertEq(FixedPointMathLib.sMulWad(2e18, -1e18), -2e18);
    }

    function testSMulWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.SMulWadFailed.selector);
        FixedPointMathLib.sMulWad(type(int256).max, 2e18);
    }

    function testSMulWadOverflow2() public {
        vm.expectRevert(FixedPointMathLib.SMulWadFailed.selector);
        FixedPointMathLib.sMulWad(-1e18, type(int256).min);
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
        assertEq(FixedPointMathLib.rawSMulWad(-1e18, -1e18), 1e18);
        assertEq(FixedPointMathLib.rawSMulWad(-2e18, -1e18), 2e18);
        assertEq(FixedPointMathLib.rawSMulWad(-1e18, -2e18), 2e18);
        assertEq(FixedPointMathLib.rawSMulWad(-2e18, -2e18), 4e18);
        assertEq(FixedPointMathLib.rawSMulWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.rawSMulWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.rawSMulWad(-1e18, 2e18), -2e18);
        assertEq(FixedPointMathLib.rawSMulWad(2e18, -1e18), -2e18);
    }

//    function testMulWadUp() public {
//        assertEq(FixedPointMathLib.mulWadUp(1e18, 1e18), 1e18);
//        assertEq(FixedPointMathLib.mulWadUp(2e18, 1e18), 2e18);
//        assertEq(FixedPointMathLib.mulWadUp(1e18, 2e18), 2e18);
//        assertEq(FixedPointMathLib.mulWadUp(2e18, 2e18), 4e18);
//        assertEq(FixedPointMathLib.mulWadUp(0, 1e18), 0);
//        assertEq(FixedPointMathLib.mulWadUp(1e18, 0), 0);
//        assertEq(FixedPointMathLib.mulWadUp(type(uint256).max, 1e18), type(uint256).max);
//        assertEq(FixedPointMathLib.mulWadUp(11e17, 1e18), 2e18);
//    }

    function testMulWadUpOverflow() public {
        vm.expectRevert(FixedPointMathLib.MulWadFailed.selector);
        FixedPointMathLib.mulWadUp(type(uint256).max, 2e18);
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
        assertEq(FixedPointMathLib.divWad(2e18, 2e18), 1e18);
        assertEq(FixedPointMathLib.divWad(0, 1e18), 0);
    }

    function testDivWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        FixedPointMathLib.divWad(type(uint256).max, 0);
    }

    function testDivWadOverflow2() public {
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        FixedPointMathLib.divWad(type(uint256).max, 1);
    }

    function testSDivWad() public {
        assertEq(FixedPointMathLib.sDivWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.sDivWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.sDivWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.sDivWad(2e18, 2e18), 1e18);
        assertEq(FixedPointMathLib.sDivWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.sDivWad(-1e18, -1e18), 1e18);
        assertEq(FixedPointMathLib.sDivWad(-2e18, -1e18), 2e18);
        assertEq(FixedPointMathLib.sDivWad(-1e18, -2e18), 5e17);
        assertEq(FixedPointMathLib.sDivWad(-2e18, -2e18), 1e18);
        assertEq(FixedPointMathLib.sDivWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.sDivWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.sDivWad(-1e18, 2e18), -5e17);
        assertEq(FixedPointMathLib.sDivWad(2e18, -1e18), -2e18);
    }

    function testSDivWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.SDivWadFailed.selector);
        FixedPointMathLib.sDivWad(type(int256).max, 0);
    }

    function testRawDivWad() public {
        assertEq(FixedPointMathLib.rawDivWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawDivWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawDivWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.rawDivWad(2e18, 2e18), 1e18);
        assertEq(FixedPointMathLib.rawDivWad(0, 1e18), 0);
    }

    function testRawSDivWad() public {
        assertEq(FixedPointMathLib.rawSDivWad(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawSDivWad(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawSDivWad(1e18, 2e18), 5e17);
        assertEq(FixedPointMathLib.rawSDivWad(2e18, 2e18), 1e18);
        assertEq(FixedPointMathLib.rawSDivWad(0, 1e18), 0);
        assertEq(FixedPointMathLib.rawSDivWad(-1e18, -1e18), 1e18);
        assertEq(FixedPointMathLib.rawSDivWad(-2e18, -1e18), 2e18);
        assertEq(FixedPointMathLib.rawSDivWad(-1e18, -2e18), 5e17);
        assertEq(FixedPointMathLib.rawSDivWad(-2e18, -2e18), 1e18);
        assertEq(FixedPointMathLib.rawSDivWad(-1e18, 1e18), -1e18);
        assertEq(FixedPointMathLib.rawSDivWad(1e18, -1e18), -1e18);
        assertEq(FixedPointMathLib.rawSDivWad(-1e18, 2e18), -5e17);
        assertEq(FixedPointMathLib.rawSDivWad(2e18, -1e18), -2e18);
    }

    function testDivWadUp() public {
        assertEq(FixedPointMathLib.divWadUp(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.divWadUp(2e18, 1e18), 2e18);

        assertEq(FixedPointMathLib.divWadUp(2e18, 2e18), 1e18);
        assertEq(FixedPointMathLib.divWadUp(0, 1e18), 0);

    }

    function testDivWadUpOverflow() public {
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        FixedPointMathLib.divWadUp(type(uint256).max, 0);
    }

    function testDivWadUpOverflow2() public {
        vm.expectRevert(FixedPointMathLib.DivWadFailed.selector);
        FixedPointMathLib.divWadUp(type(uint256).max, 1);
    }

    function testRawDivWadUp() public {
        assertEq(FixedPointMathLib.rawDivWadUp(1e18, 1e18), 1e18);
        assertEq(FixedPointMathLib.rawDivWadUp(2e18, 1e18), 2e18);
        assertEq(FixedPointMathLib.rawDivWadUp(2e18, 2e18), 1e18);
        assertEq(FixedPointMathLib.rawDivWadUp(0, 1e18), 0);

    }

//    function testPowWad() public {
//        assertEq(FixedPointMathLib.powWad(2e18, 0), 1e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 1), 2e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 2), 4e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 3), 8e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 4), 16e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 5), 32e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 10), 1024e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 20), 1048576e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 30), 1073741824e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 40), 1099511627776e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 50), 1125899906842624e18);
//        assertEq(FixedPointMathLib.powWad(2e18, 100), 1267650600228229401496703205376e18);
//        assertEq(FixedPointMathLib.powWad(1e18, 100), 1e18);
//        assertEq(FixedPointMathLib.powWad(0, 100), 0);
//    }

//    function testPowWadFractional() public {
//        assertApproxEqAbs(
//            FixedPointMathLib.powWad(2e18, 5e17),
//            28284271247461900976e12,
//            1e12
//        );
//        assertApproxEqAbs(
//            FixedPointMathLib.powWad(2e18, -5e17),
//            35355339059327376221e12,
//            1e12
//        );
//    }

//    function testPowWadOverflow() public {
//        vm.expectRevert(FixedPointMathLib.RPowOverflow.selector);
//        FixedPointMathLib.powWad(2e18, type(int256).max);
//    }

//    function testExpWad() public {
//        assertEq(FixedPointMathLib.expWad(0), 1e18);
//        assertApproxEqAbs(FixedPointMathLib.expWad(1e18), 27182818284590452354, 1);
//        assertApproxEqAbs(FixedPointMathLib.expWad(-1e18), 36787944117144232159, 1);
//    }

    function testExpWadOverflow() public {
        vm.expectRevert(FixedPointMathLib.ExpOverflow.selector);
        FixedPointMathLib.expWad(136e18);
    }

//    function testLnWad() public {
//        assertEq(FixedPointMathLib.lnWad(1e18), 0);
////        assertApproxEqAbs(FixedPointMathLib.lnWad(27182818284590452354), 1e18, 1);
//        assertApproxEqAbs(FixedPointMathLib.lnWad(36787944117144232159), -1e18, 1);
//    }

    function testLnWadUndefined() public {
        vm.expectRevert(FixedPointMathLib.LnWadUndefined.selector);
        FixedPointMathLib.lnWad(0);
    }

    function testLnWadUndefined2() public {
        vm.expectRevert(FixedPointMathLib.LnWadUndefined.selector);
        FixedPointMathLib.lnWad(-1e18);
    }

//    function testLambertW0Wad() public {
//        assertEq(FixedPointMathLib.lambertW0Wad(0), 0);
//        assertApproxEqAbs(
//            FixedPointMathLib.lambertW0Wad(1e18),
//            56714329040978387299,
//            1
//        );
//
//    }

    function testLambertW0WadOutOfBounds() public {
        vm.expectRevert(FixedPointMathLib.OutOfDomain.selector);
        FixedPointMathLib.lambertW0Wad(-36787944117144232200);
    }

    function testFullMulDiv() public {
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 4), 1);
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 3), 2);
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 2), 3);
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 1), 6);
        assertEq(FixedPointMathLib.fullMulDiv(2, 4, 3), 2);
        assertEq(FixedPointMathLib.fullMulDiv(2, 5, 3), 3);
        assertEq(FixedPointMathLib.fullMulDiv(1, type(uint256).max, 2), type(uint256).max / 2);
    }

    function testFullMulDivRounding() public {
        assertEq(FixedPointMathLib.fullMulDiv(2, 3, 5), 1);
        assertEq(FixedPointMathLib.fullMulDiv(3, 2, 5), 1);
        assertEq(FixedPointMathLib.fullMulDiv(4, 5, 6), 3);
        assertEq(FixedPointMathLib.fullMulDiv(5, 4, 6), 3);
    }

    function testFullMulDivOverflow() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDiv(type(uint256).max, 2, 1);
    }

    function testFullMulDivOverflow2() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDiv(type(uint256).max, type(uint256).max, type(uint256).max - 1);
    }

    function testFullMulDivByZero() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDiv(1, 1, 0);
    }

    function testFullMulDivUp() public {
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 4), 2);
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 3), 2);
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 2), 3);
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 1), 6);
        assertEq(FixedPointMathLib.fullMulDivUp(2, 4, 3), 3);
        assertEq(FixedPointMathLib.fullMulDivUp(2, 5, 3), 4);
        assertEq(FixedPointMathLib.fullMulDivUp(1, type(uint256).max, 2), (type(uint256).max / 2) + 1);
    }

    function testFullMulDivUpRounding() public {
        assertEq(FixedPointMathLib.fullMulDivUp(2, 3, 5), 2);
        assertEq(FixedPointMathLib.fullMulDivUp(3, 2, 5), 2);
        assertEq(FixedPointMathLib.fullMulDivUp(4, 5, 6), 4);
        assertEq(FixedPointMathLib.fullMulDivUp(5, 4, 6), 4);
    }

    function testFullMulDivUpOverflow() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDivUp(type(uint256).max, 2, 1);
    }

    function testFullMulDivUpOverflow2() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDivUp(type(uint256).max, type(uint256).max, type(uint256).max - 1);
    }

    function testFullMulDivUpByZero() public {
        vm.expectRevert(FixedPointMathLib.FullMulDivFailed.selector);
        FixedPointMathLib.fullMulDivUp(1, 1, 0);
    }

    function testMulDiv() public {
        assertEq(FixedPointMathLib.mulDiv(2, 3, 4), 1);
        assertEq(FixedPointMathLib.mulDiv(2, 3, 3), 2);
        assertEq(FixedPointMathLib.mulDiv(2, 3, 2), 3);
        assertEq(FixedPointMathLib.mulDiv(2, 3, 1), 6);
        assertEq(FixedPointMathLib.mulDiv(2, 4, 3), 2);
        assertEq(FixedPointMathLib.mulDiv(2, 5, 3), 3);
        assertEq(FixedPointMathLib.mulDiv(1, type(uint256).max, 2), type(uint256).max / 2);
    }

    function testMulDivRounding() public {
        assertEq(FixedPointMathLib.mulDiv(2, 3, 5), 1);
        assertEq(FixedPointMathLib.mulDiv(3, 2, 5), 1);
        assertEq(FixedPointMathLib.mulDiv(4, 5, 6), 3);
        assertEq(FixedPointMathLib.mulDiv(5, 4, 6), 3);
    }

    function testMulDivOverflow() public {
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        FixedPointMathLib.mulDiv(type(uint256).max, 2, 1);
    }

    function testMulDivByZero() public {
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        FixedPointMathLib.mulDiv(1, 1, 0);
    }

    function testMulDivUp() public {
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 4), 2);
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 3), 2);
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 2), 3);
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 1), 6);
        assertEq(FixedPointMathLib.mulDivUp(2, 4, 3), 3);
        assertEq(FixedPointMathLib.mulDivUp(2, 5, 3), 4);
        assertEq(FixedPointMathLib.mulDivUp(1, type(uint256).max, 2), (type(uint256).max / 2) + 1);
    }

    function testMulDivUpRounding() public {
        assertEq(FixedPointMathLib.mulDivUp(2, 3, 5), 2);
        assertEq(FixedPointMathLib.mulDivUp(3, 2, 5), 2);
        assertEq(FixedPointMathLib.mulDivUp(4, 5, 6), 4);
        assertEq(FixedPointMathLib.mulDivUp(5, 4, 6), 4);
    }

    function testMulDivUpOverflow() public {
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        FixedPointMathLib.mulDivUp(type(uint256).max, 2, 1);
    }

    function testMulDivUpByZero() public {
        vm.expectRevert(FixedPointMathLib.MulDivFailed.selector);
        FixedPointMathLib.mulDivUp(1, 1, 0);
    }

    function testDivUp() public {
        assertEq(FixedPointMathLib.divUp(2, 4), 1);
        assertEq(FixedPointMathLib.divUp(3, 4), 1);
        assertEq(FixedPointMathLib.divUp(4, 4), 1);
        assertEq(FixedPointMathLib.divUp(5, 4), 2);
        assertEq(FixedPointMathLib.divUp(6, 4), 2);
        assertEq(FixedPointMathLib.divUp(7, 4), 2);
        assertEq(FixedPointMathLib.divUp(8, 4), 2);
        assertEq(FixedPointMathLib.divUp(9, 4), 3);
        assertEq(FixedPointMathLib.divUp(type(uint256).max, 2), (type(uint256).max / 2) + 1);
    }

    function testDivUpByZero() public {
        vm.expectRevert(FixedPointMathLib.DivFailed.selector);
        FixedPointMathLib.divUp(1, 0);
    }

    function testZeroFloorSub() public {
        assertEq(FixedPointMathLib.zeroFloorSub(2, 1), 1);
        assertEq(FixedPointMathLib.zeroFloorSub(2, 2), 0);
        assertEq(FixedPointMathLib.zeroFloorSub(2, 3), 0);
    }

//    function testRpow() public {
//        assertEq(FixedPointMathLib.rpow(2, 0, 10), 1);
//        assertEq(FixedPointMathLib.rpow(2, 1, 10), 2);
//        assertEq(FixedPointMathLib.rpow(2, 2, 10), 4);
//        assertEq(FixedPointMathLib.rpow(2, 3, 10), 8);
//        assertEq(FixedPointMathLib.rpow(2, 4, 10), 6);
//        assertEq(FixedPointMathLib.rpow(2, 5, 10), 2);
//        assertEq(FixedPointMathLib.rpow(2, 6, 10), 4);
//        assertEq(FixedPointMathLib.rpow(2, 7, 10), 8);
//        assertEq(FixedPointMathLib.rpow(2, 8, 10), 6);
//        assertEq(FixedPointMathLib.rpow(2, 9, 10), 2);
//        assertEq(FixedPointMathLib.rpow(2, 10, 10), 4);
//        assertEq(FixedPointMathLib.rpow(2, 18, 10), 4);
//        assertEq(FixedPointMathLib.rpow(2, 19, 10), 8);
//        assertEq(FixedPointMathLib.rpow(2, 20, 10), 6);
//        assertEq(FixedPointMathLib.rpow(0, 0, 10), 1);
//        assertEq(FixedPointMathLib.rpow(0, 1, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 2, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 3, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 4, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 5, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 6, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 7, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 8, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 9, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 10, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 18, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 19, 10), 0);
//        assertEq(FixedPointMathLib.rpow(0, 20, 10), 0);
//    }

//    function testRpowOverflow() public {
//        vm.expectRevert(FixedPointMathLib.RPowOverflow.selector);
//        FixedPointMathLib.rpow(2, 256, 10);
//    }

}