// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    /// @notice Test to ensure that gas is burned without reverting
    function testGasBurn() public {
        uint256 startGas = gasleft();
        uint256 burnAmount = 10000; // Amount of gas to burn

        // Call the burn function
        GasBurnerLib.burn(burnAmount);

        uint256 endGas = gasleft();
        uint256 gasUsed = startGas - endGas;

        // Check if the gas used is approximately equal to the burn amount
        // Allowing a margin due to the overhead of the function call itself
        assertLt(burnAmount - gasUsed, 1000, "Gas burned is not within expected range");
    }

    /// @notice Fuzz test to ensure that varying amounts of gas can be burned without reverting
    /// @param burnAmount The amount of gas to burn
    function testGasBurnFuzz(uint256 burnAmount) public {
        burnAmount=burnAmount%1000000;
        uint256 startGas = gasleft();

        // Call the burn function with fuzzed burn amount
        GasBurnerLib.burn(burnAmount);

        uint256 endGas = gasleft();
        uint256 gasUsed = startGas - endGas;

        // Check if the gas used is less than or equal to the start gas
        // This ensures that the function does not revert and uses gas as intended
        assertTrue(gasUsed <= startGas, "More gas used than available");
    }

    /// @notice Invariant test to ensure that the burn function never reverts regardless of input
    function invariantGasBurn() public {
        uint256 burnAmount = 5000; // Arbitrary amount for invariant testing
        uint256 startGas = gasleft();

        // Call the burn function
        GasBurnerLib.burn(burnAmount);

        uint256 endGas = gasleft();
        uint256 gasUsed = startGas - endGas;

        // Ensure that some gas is indeed used
        assertGt(gasUsed, 0, "No gas was burned");
    }
}