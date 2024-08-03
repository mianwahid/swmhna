// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/EnumerableSetLib.sol";

contract EnumerableSetLibTest is Test {
    using EnumerableSetLib for EnumerableSetLib.AddressSet;
    EnumerableSetLib.AddressSet private addressSet;

    function setUp() public {
        // Initial setup can be done here if needed
    }

    function testLengthEmptySet() public {
        assertEq(addressSet.length(), 0, "Length of an empty set should be 0");
    }

    function testLengthAfterAddingElements() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        assertEq(addressSet.length(), 2, "Length should match the number of unique elements");
    }

    function testContains() public {
        addressSet.add(address(1));
        assertTrue(addressSet.contains(address(1)), "Set should contain the added element");
        assertFalse(addressSet.contains(address(2)), "Set should not contain non-added elements");
    }

    function testFailContainsZeroSentinel() public {
        addressSet.contains(address(0xfbb67fda52d4bfb8bf));
    }

    function testAdd() public {
        assertTrue(addressSet.add(address(1)), "Adding a new element should return true");
        assertFalse(addressSet.add(address(1)), "Adding a duplicate element should return false");
    }

    function testFailAddZeroSentinel() public {
        addressSet.add(address(0xfbb67fda52d4bfb8bf));
    }

    function testRemove() public {
        addressSet.add(address(1));
        assertTrue(addressSet.remove(address(1)), "Removing an existing element should return true");
        assertFalse(addressSet.remove(address(1)), "Removing a non-existent element should return false");
    }

    function testFailRemoveZeroSentinel() public {
        addressSet.remove(address(0xfbb67fda52d4bfb8bf));
    }

    function testValues() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        address[] memory values = addressSet.values();
        assertEq(values.length, 2, "Values array should contain all elements");
        assertTrue(values[0] == address(1) || values[1] == address(1), "Values array should contain the first element");
        assertTrue(values[0] == address(2) || values[1] == address(2), "Values array should contain the second element");
    }

    function testAt() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        assertEq(addressSet.at(0), address(1), "Element at index 0 should be the first added element");
        assertEq(addressSet.at(1), address(2), "Element at index 1 should be the second added element");
    }

    function testFailAtOutOfBounds() public {
        addressSet.at(0); // Should fail as the set is empty
    }

    function testGasUsage() public {
        // This test can be used to measure gas usage of operations
        uint256 gasBefore;
        uint256 gasAfter;

        gasBefore = gasleft();
        addressSet.add(address(1));
        gasAfter = gasleft();
        console2.log("Gas used for adding first element:", gasBefore - gasAfter);

        gasBefore = gasleft();
        addressSet.add(address(2));
        gasAfter = gasleft();
        console2.log("Gas used for adding second element:", gasBefore - gasAfter);

        gasBefore = gasleft();
        addressSet.remove(address(1));
        gasAfter = gasleft();
        console2.log("Gas used for removing element:", gasBefore - gasAfter);
    }
}
