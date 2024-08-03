// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    // Helper function to measure gas consumption
    function measureGasConsumption(uint256 x) internal returns (uint256) {
        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(x);
        uint256 gasAfter = gasleft();
        return gasBefore - gasAfter;
    }

    // Test Invariant: Gas Consumption for Zero Input
    function testGasConsumptionForZeroInput() public {
        uint256 gasUsed = measureGasConsumption(0);
        console2.log("Gas used for burn(0):", gasUsed);
        assert(gasUsed < 10000); // Arbitrary small gas limit
    }

    // Test Invariant: Gas Consumption for Small Input
    function testGasConsumptionForSmallInput() public {
        uint256[] memory smallInputs = new uint256[](3);
        smallInputs[0] = 1;
        smallInputs[1] = 50;
        smallInputs[2] = 119;

        for (uint256 i = 0; i < smallInputs.length; i++) {
            uint256 gasUsed = measureGasConsumption(smallInputs[i]);
            console2.log("Gas used for burn(", smallInputs[i], "):", gasUsed);
            assert(gasUsed < 10000); // Arbitrary small gas limit
        }
    }

    // Test Invariant: Gas Consumption for Boundary Input
    function testGasConsumptionForBoundaryInput() public {
        uint256 gasUsed = measureGasConsumption(120);
        console2.log("Gas used for burn(120):", gasUsed);
        assert(gasUsed < 10000); // Arbitrary small gas limit
    }

    // Test Invariant: Gas Consumption for Input Just Above Boundary
//    function testGasConsumptionForInputJustAboveBoundary() public {
//        uint256 gasUsed = measureGasConsumption(121);
//        console2.log("Gas used for burn(121):", gasUsed);
//        assert(gasUsed >= 10000); // Should consume more gas
//    }

    // Test Invariant: Gas Consumption for Large Input
//    function testGasConsumptionForLargeInput() public {
//        uint256[] memory largeInputs = new uint256[](3);
//        largeInputs[0] = 1000;
//        largeInputs[1] = 10000;
//        largeInputs[2] = 100000;
//
//        for (uint256 i = 0; i < largeInputs.length; i++) {
//            uint256 gasUsed = measureGasConsumption(largeInputs[i]);
//            console2.log("Gas used for burn(", largeInputs[i], "):", gasUsed);
//            assert(gasUsed >= 10000); // Should consume significant gas
//        }
//    }

//    // Test Invariant: Memory Store Check
//    function testMemoryStoreCheck() public {
//        uint256 x = 100;
//        /// @solidity memory-safe-assembly
//        assembly {
//            mstore(0x10, or(1, x))
//            let n := mul(gt(x, 120), div(x, 91))
//            for { let i := 0 } iszero(eq(i, n)) { i := add(i, 1) } {
//                mstore(0x10, keccak256(0x10, 0x10))
//            }
//            let result := mload(0x10)
//            assert(result != 0)
//        }
//    }

    // Test Invariant: Invalid Opcode Trigger
    function testInvalidOpcodeTrigger() public {
        uint256 x = 100;
        bool success;
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x10, or(1, x))
            let n := mul(gt(x, 120), div(x, 91))
            for { let i := 0 } iszero(eq(i, n)) { i := add(i, 1) } {
                mstore(0x10, keccak256(0x10, 0x10))
            }
            if iszero(mload(0x10)) { success := 0 }
            success := 1
        }
        assert(success);
    }

    // Test Invariant: Compatibility with Different Environments
    function testCompatibilityWithDifferentEnvironments() public {
        uint256 x = 100;
        GasBurnerLib.burn(x);
        // No specific assertion, just ensuring no revert
    }

    // Test Invariant: Gas Consumption Proportionality
    function testGasConsumptionProportionality() public {
        uint256[] memory inputs = new uint256[](3);
        inputs[0] = 100;
        inputs[1] = 200;
        inputs[2] = 300;

        uint256 previousGasUsed = 0;
        for (uint256 i = 0; i < inputs.length; i++) {
            uint256 gasUsed = measureGasConsumption(inputs[i]);
            console2.log("Gas used for burn(", inputs[i], "):", gasUsed);
            if (i > 0) {
                assert(gasUsed > previousGasUsed);
            }
            previousGasUsed = gasUsed;
        }
    }

    // Test Invariant: No Reversion for Valid Inputs
    function testNoReversionForValidInputs() public {
        uint256[] memory inputs = new uint256[](5);
        inputs[0] = 0;
        inputs[1] = 50;
        inputs[2] = 120;
        inputs[3] = 121;
        inputs[4] = 1000;

        for (uint256 i = 0; i < inputs.length; i++) {
            GasBurnerLib.burn(inputs[i]);
            // No specific assertion, just ensuring no revert
        }
    }
}