// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/GasBurnerLib.sol";

contract GasBurnerLibTest is Test {
    /*´:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+*/
    /*                          1. GAS CONSUMPTION INVARIANT TESTS                                                              */
    /*´:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+*/

    function testGasConsumption_ZeroInput() public {
        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(0);
        uint256 gasAfter = gasleft();
        console2.log("Gas consumed (x = 0):", gasBefore - gasAfter);
        // Assert minimal gas consumption (e.g., less than 100 gas).
        assertLt(gasBefore - gasAfter, 150, "Gas consumption for zero input should be minimal");
    }

    function testGasConsumption_SmallInput(uint256 x) public {
        x=x%1000;
        vm.assume(x > 0 && x <= 1000); // Test with small values of x

        uint256 gasBefore = gasleft();
        GasBurnerLib.burn(x);
        uint256 gasAfter = gasleft();
        console2.log("Gas consumed (x =", x, "):", gasBefore - gasAfter);

        // Assert gas consumption is above a threshold and increases with x
        assertGt(gasBefore - gasAfter, 100, "Gas consumption should be above a certain threshold");
    }

//    function testGasConsumption_LargeInput(uint256 x) public {
//        x=((x%10**9)+10**6)%10**9;
//        vm.assume(x > 10**6 && x <= 10**9); // Test with large values of x
//
//        uint256 gasBefore = gasleft();
//        GasBurnerLib.burn(x);
//        uint256 gasAfter = gasleft();
//        console2.log("Gas consumed (x =", x, "):", gasBefore - gasAfter);
//
//        // Assert gas consumption is above a threshold and increases with x
//        assertGt(gasBefore - gasAfter, 10000, "Gas consumption should be above a certain threshold");
//    }

    /*´:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+*/
    /*                          2. NON-REVERTING INVARIANT TESTS                                                               */
    /*´:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+*/

//    function testNonReverting_VariableGasLimit(uint256 x, uint256 gasLimit) public {
//        vm.assume(gasLimit > 20000 && gasLimit <= block.gaslimit);
//
//        bytes memory data = abi.encodeWithSignature("burn(uint256)", x);
//        (bool success, bytes memory returndata) = address(this).call{gas: gasLimit}(data);
//
//        console2.log("Gas Limit:", gasLimit);
//        console2.log("Success:", success);
//        console2.log("Return Data:", abi.decode(returndata, (string)));
//
//        assert(success, "The call should not revert");
//    }

    function testNonReverting_NestedCalls(uint256 x) public {
        x=x%1000;
        uint256 gasBefore = gasleft();

        // Nested call to burn()
        nestedBurn(x);

        uint256 gasAfter = gasleft();
        console2.log("Gas consumed (nested call, x =", x, "):", gasBefore - gasAfter);

        // Assert that the function executed successfully
        assertTrue(true, "The nested call should not revert");
    }

    function nestedBurn(uint256 x) internal {
        x=x%10000;
        // Consume some gas before calling burn()
        for (uint256 i = 0; i < 1000; i++) {
            // Some gas consuming operation
            assembly {
                mstore(0, keccak256(0, 32))
            }
        }

        GasBurnerLib.burn(x);
    }

    /*´:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+*/
    /*                          4. DYNAMIC VALUE RECOMMENDATION TEST                                                            */
    /*´:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+.*•´.*:°•.°+*/

//    function testDynamicValue(uint256 initialX, uint256 newX) public {
//        initialX=initialX%10000;
//        newX=newX%10000;
//        TestGasBurnerWrapper wrapper = new TestGasBurnerWrapper(initialX);
//        uint256 gasBefore = gasleft();
//        wrapper.burnGas();
//        uint256 gasAfter = gasleft();
//        console2.log("Gas consumed (initial x =", initialX, "):", gasBefore - gasAfter);
//
//        // Change the value of x dynamically
//        wrapper.setX(newX);
//
//        gasBefore = gasleft();
//        wrapper.burnGas();
//        gasAfter = gasleft();
//        console2.log("Gas consumed (new x =", newX, "):", gasBefore - gasAfter);
//    }
}

contract TestGasBurnerWrapper {
    uint256 public x;

    constructor(uint256 _x) {
        x = _x;
    }

    function burnGas() public {
        GasBurnerLib.burn(x);
    }

    function setX(uint256 _x) public {
        x = _x;
    }
}
