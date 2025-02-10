// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    function testZeroInput() public {
        vm.startPrank(address(0x1));
        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(0);
        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;
        assertLt(gasUsed, 30000); // Check if minimal gas is used
        vm.stopPrank();
    }

    function testBoundaryCondition() public {
        vm.startPrank(address(0x1));
        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(120);
        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;
        assertLt(gasUsed, 30000); // Check if minimal gas is used
        vm.stopPrank();
    }

    // function testJustAboveBoundary() public {
    //     vm.startPrank(address(0x1));
    //     uint256 gasBefore = gasleft();
    //     GasBurnerLib.burn(121);
    //     uint256 gasAfter = gasleft();
    //     uint256 gasUsed = gasBefore - gasAfter;
    //     assertTrue(gasUsed > 30000); // Check if more gas is used due to loop execution
    //     vm.stopPrank();
    // }

    // function testHighInput() public {
    //     vm.startPrank(address(0x1));
    //     uint256 gasBefore = gasleft();
    //     GasBurnerLib.burn(10000);
    //     uint256 gasAfter = gasleft();
    //     uint256 gasUsed = gasBefore - gasAfter;
    //     assertTrue(gasUsed > 100000); // Check if significant gas is used
    //     vm.stopPrank();
    // }

    function testEffectOfLoopExecution() public {
        vm.startPrank(address(0x1));
        GasBurnerLib.burn(121);
        uint256 memoryValue;
        assembly {
            memoryValue := mload(0x10)
        }
        assertNotEq(memoryValue, 0); // Memory at position 0x10 should not be zero
        vm.stopPrank();
    }

    function testGasConsumptionScaling() public {
        vm.startPrank(address(0x1));
        uint256 gasUsedLast = 0;
        for (uint256 x = 121; x <= 1000; x += 100) {
            uint256 gasBefore = gasleft();
            GasBurnerLib.burn(x);
            uint256 gasAfter = gasleft();
            uint256 gasUsed = gasBefore - gasAfter;
            if (gasUsedLast != 0) {
                assertTrue(gasUsed > gasUsedLast); // Gas used should scale with x
            }
            gasUsedLast = gasUsed;
        }
        vm.stopPrank();
    }

    // function testInvalidOperationExecution() public {
    //     vm.startPrank(address(0x1));
    //     vm.expectRevert();
    //     GasBurnerLib.burn(0); // Should not revert as memory at 0x10 should not be zero
    //     vm.stopPrank();
    // }

    function testDynamicInput() public {
        vm.startPrank(address(0x1));
        for (uint256 x = 0; x <= 1000; x += 50) {
            uint256 gasBefore = gasleft();
            GasBurnerLib.burn(x);
            uint256 gasAfter = gasleft();
            assertTrue(gasAfter < gasBefore); // Gas should be consumed
        }
        vm.stopPrank();
    }
}
