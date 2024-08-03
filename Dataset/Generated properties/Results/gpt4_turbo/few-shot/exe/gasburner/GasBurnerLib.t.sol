// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    /// @notice Test to ensure gas is burned without reverting
    function testGasBurn() public {
        uint256 startGas = gasleft();
        uint256 burnAmount = 10000; // Arbitrary burn amount for testing
        GasBurnerLib.burn(burnAmount);
        uint256 endGas = gasleft();
        uint256 gasUsed = startGas - endGas;
        // Check if gas used is within a reasonable range of the requested burn amount
        // This is a rough check due to the nature of gas estimation
        assertLt(gasUsed, burnAmount + 5000); // Allow some margin
        assertGt(gasUsed, burnAmount - 5000); // Allow some margin
    }

    /// @notice Fuzz test to ensure gas is burned without reverting for various inputs
    /// @param burnAmount The amount of gas to attempt to burn
    function testFuzzGasBurn(uint256 burnAmount) public {
        burnAmount=burnAmount%100000;
        uint256 startGas = gasleft();
        GasBurnerLib.burn(burnAmount);
        uint256 endGas = gasleft();
        uint256 gasUsed = startGas - endGas;
        // Check if gas used is within a reasonable range of the requested burn amount
        // This is a rough check due to the nature of gas estimation
        assertLt(gasUsed, burnAmount + 5000); // Allow some margin
        assertGt(gasUsed, burnAmount - 5000); // Allow some margin
    }

    /// @notice Invariant test to ensure that the function does not revert
    function invariantGasBurnDoesNotRevert() public {
        uint256 burnAmount = 5000; // Constant burn amount for invariant testing
        GasBurnerLib.burn(burnAmount);
    }
}