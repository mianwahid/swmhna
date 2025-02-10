// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    // Test with a small value of x
    function testBurnSmallValue() public {
        uint256 x = 1;
        GasBurnerLib.burn(x);
        // No assertion needed as we are testing for non-reversion
    }

    // Test with a large value of x
    function testBurnLargeValue() public {
        uint256 x = type(uint256).max%10000;
        GasBurnerLib.burn(x);
        // No assertion needed as we are testing for non-reversion
    }

    // Test with zero value of x
    function testBurnZeroValue() public {
        uint256 x = 0;
        GasBurnerLib.burn(x);
        // No assertion needed as we are testing for non-reversion
    }

    // Fuzz test with random values of x
    function testBurnFuzz(uint256 x) public {
        GasBurnerLib.burn(x%100000);
        // No assertion needed as we are testing for non-reversion
    }

    // Test with boundary values around the threshold
    function testBurnBoundaryValues() public {
        uint256 x1 = 120;
        uint256 x2 = 121;
        uint256 x3 = 119;

        GasBurnerLib.burn(x1);
        GasBurnerLib.burn(x2);
        GasBurnerLib.burn(x3);
        // No assertion needed as we are testing for non-reversion
    }

    // Test with values that are multiples of 91
    function testBurnMultiplesOf91() public {
        uint256 x1 = 91;
        uint256 x2 = 182;
        uint256 x3 = 273;

        GasBurnerLib.burn(x1);
        GasBurnerLib.burn(x2);
        GasBurnerLib.burn(x3);
        // No assertion needed as we are testing for non-reversion
    }

    // Test with values that are just below multiples of 91
    function testBurnJustBelowMultiplesOf91() public {
        uint256 x1 = 90;
        uint256 x2 = 181;
        uint256 x3 = 272;

        GasBurnerLib.burn(x1);
        GasBurnerLib.burn(x2);
        GasBurnerLib.burn(x3);
        // No assertion needed as we are testing for non-reversion
    }

    // Test with values that are just above multiples of 91
    function testBurnJustAboveMultiplesOf91() public {
        uint256 x1 = 92;
        uint256 x2 = 183;
        uint256 x3 = 274;

        GasBurnerLib.burn(x1);
        GasBurnerLib.burn(x2);
        GasBurnerLib.burn(x3);
        // No assertion needed as we are testing for non-reversion
    }
}