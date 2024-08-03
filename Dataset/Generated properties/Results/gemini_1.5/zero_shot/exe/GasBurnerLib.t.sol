// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";
contract GasBurnerLibTest is Test {
    function testBurnGas() public {
        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(100000);
        uint256 gasAfter = gasleft();
        assertLt(gasAfter, gasBefore, "Gas should be burned");
    }

    function testBurnMaxGas() public {
        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(type(uint256).max%100000);
        uint256 gasAfter = gasleft();
        assertLt(gasAfter, gasBefore, "Gas should be burned");
    }

}
