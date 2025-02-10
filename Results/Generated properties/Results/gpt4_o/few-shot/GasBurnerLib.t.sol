// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    function testBurnGas() public {
        uint256 initialGas = gasleft();
        GasBurnerLib.burn(1000);
        uint256 gasUsed = initialGas - gasleft();
        console2.log("Gas used:", gasUsed);
        assertTrue(gasUsed > 0, "Gas was not burned");
    }

    function testBurnGasWithZero() public {
        uint256 initialGas = gasleft();
        GasBurnerLib.burn(0);
        uint256 gasUsed = initialGas - gasleft();
        console2.log("Gas used:", gasUsed);
        assertTrue(gasUsed > 0, "Gas was not burned");
    }

    function testBurnGasWithLargeValue() public {
        uint256 initialGas = gasleft();
        GasBurnerLib.burn(1000000);
        uint256 gasUsed = initialGas - gasleft();
        console2.log("Gas used:", gasUsed);
        assertTrue(gasUsed > 0, "Gas was not burned");
    }

//    function testBurnGasFuzz(uint256 x) public {
//        uint256 initialGas = gasleft();
//        GasBurnerLib.burn(x);
//        uint256 gasUsed = initialGas - gasleft();
//        console2.log("Gas used:", gasUsed);
//        assertTrue(gasUsed > 0, "Gas was not burned");
//    }
}