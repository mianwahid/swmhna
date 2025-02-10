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

    function testGasConsumptionForZeroInput() public {
        uint256 gasUsed = measureGasConsumption(0);
        console2.log("Gas used for x = 0:", gasUsed);
        assert(gasUsed < 10000); // Arbitrary small gas limit for zero input
    }

    function testGasConsumptionForSmallInput() public {
        uint256 gasUsed1 = measureGasConsumption(1);
        uint256 gasUsed119 = measureGasConsumption(119);
        console2.log("Gas used for x = 1:", gasUsed1);
        console2.log("Gas used for x = 119:", gasUsed119);
        assert(gasUsed1 < 10000); // Arbitrary small gas limit for small input
        assert(gasUsed119 < 10000); // Arbitrary small gas limit for small input
    }

    function testGasConsumptionForBoundaryInput() public {
        uint256 gasUsed = measureGasConsumption(120);
        console2.log("Gas used for x = 120:", gasUsed);
        assert(gasUsed < 10000); // Arbitrary small gas limit for boundary input
    }

    function testGasConsumptionForInputJustAboveBoundary() public {
        uint256 gasUsed = measureGasConsumption(121);
        console2.log("Gas used for x = 121:", gasUsed);
        assert(gasUsed > 10000); // Arbitrary larger gas limit for input just above boundary
    }

    function testGasConsumptionForLargeInput() public {
        uint256 gasUsed1000 = measureGasConsumption(1000);
        uint256 gasUsed10000 = measureGasConsumption(10000);
        console2.log("Gas used for x = 1000:", gasUsed1000);
        console2.log("Gas used for x = 10000:", gasUsed10000);
        assert(gasUsed1000 > 10000); // Arbitrary larger gas limit for large input
        assert(gasUsed10000 > 100000); // Arbitrary larger gas limit for large input
    }

//    function testGasConsumptionForMaximumInput() public {
//        uint256 gasUsed = measureGasConsumption(type(uint256).max);
//        console2.log("Gas used for x = type(uint256).max:", gasUsed);
//        assert(gasUsed > 100000); // Arbitrary large gas limit for maximum input
//    }

    function testMemoryLocationCheck() public {
        uint256 x = 100;
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x10, 0)
        }
        GasBurnerLib.burn(x);
        uint256 value;
        /// @solidity memory-safe-assembly
        assembly {
            value := mload(0x10)
        }
        assert(value != 0);
    }

//    function testInvalidOpcodeTrigger() public {
//        uint256 x = 0;
//        /// @solidity memory-safe-assembly
//        assembly {
//            mstore(0x10, 0)
//        }
//        try GasBurnerLib.burn(x) {
//            assert(false); // Should not reach here
//        } catch {
//            // Expected to catch invalid opcode
//        }
//    }

    function testGasConsumptionConsistency() public {
        uint256 x = 500;
        uint256 gasUsed1 = measureGasConsumption(x);
        uint256 gasUsed2 = measureGasConsumption(x);
        console2.log("Gas used for x = 500 (first call):", gasUsed1);
        console2.log("Gas used for x = 500 (second call):", gasUsed2);
        assert(gasUsed1 == gasUsed2);
    }

    function testNoStateModification() public {
        uint256 x = 100;
        uint256 initialBalance = address(this).balance;
        GasBurnerLib.burn(x);
        uint256 finalBalance = address(this).balance;
        assert(initialBalance == finalBalance);
    }
}