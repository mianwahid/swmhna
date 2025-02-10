// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EnumerableSetLib.sol";

contract EnumerableSetLibTest is Test {
    using EnumerableSetLib for EnumerableSetLib.AddressSet;
    EnumerableSetLib.AddressSet private addressSet;

    address private constant ZERO_SENTINEL = address(uint160(uint256(0xfbb67fda52d4bfb8bf)));

    function setUp() public {
        // Initial setup if needed
    }

    // Length Function Invariants
    function testInitialLength() public {
        assertEq(addressSet.length(), 0);
    }

    function testLengthAfterAdditions() public {
        addressSet.add(address(1));
        assertEq(addressSet.length(), 1);
        addressSet.add(address(2));
        assertEq(addressSet.length(), 2);
    }

    function testLengthAfterRemovals() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        addressSet.remove(address(1));
        assertEq(addressSet.length(), 1);
        addressSet.remove(address(2));
        assertEq(addressSet.length(), 0);
    }

    function testLengthWithDuplicates() public {
        addressSet.add(address(1));
        addressSet.add(address(1));
        assertEq(addressSet.length(), 1);
    }

    function testLengthWithZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.add(ZERO_SENTINEL);
    }

    // Contains Function Invariants
    function testContainsInEmptySet() public {
        assertFalse(addressSet.contains(address(1)));
    }

    function testContainsAfterAddition() public {
        addressSet.add(address(1));
        assertTrue(addressSet.contains(address(1)));
    }

    function testContainsAfterRemoval() public {
        addressSet.add(address(1));
        addressSet.remove(address(1));
        assertFalse(addressSet.contains(address(1)));
    }

    function testContainsWithZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.contains(ZERO_SENTINEL);
    }

    // Add Function Invariants
    function testAddToEmptySet() public {
        assertTrue(addressSet.add(address(1)));
        assertEq(addressSet.length(), 1);
    }

    function testAddDuplicate() public {
        addressSet.add(address(1));
        assertFalse(addressSet.add(address(1)));
    }

    function testAddZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.add(ZERO_SENTINEL);
    }

    function testAddMultipleValues() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        assertEq(addressSet.length(), 2);
    }

    // Remove Function Invariants
    function testRemoveFromEmptySet() public {
        assertFalse(addressSet.remove(address(1)));
    }

    function testRemoveExistingValue() public {
        addressSet.add(address(1));
        assertTrue(addressSet.remove(address(1)));
        assertEq(addressSet.length(), 0);
    }

    function testRemoveNonExistingValue() public {
        addressSet.add(address(1));
        assertFalse(addressSet.remove(address(2)));
    }

    function testRemoveZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.remove(ZERO_SENTINEL);
    }

    // Values Function Invariants
    function testValuesInEmptySet() public {
        address[] memory values = addressSet.values();
        assertEq(values.length, 0);
    }

    function testValuesAfterAdditions() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        address[] memory values = addressSet.values();
        assertEq(values.length, 2);
        assertTrue(values[0] == address(1) || values[1] == address(1));
        assertTrue(values[0] == address(2) || values[1] == address(2));
    }

    function testValuesAfterRemovals() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        addressSet.remove(address(1));
        address[] memory values = addressSet.values();
        assertEq(values.length, 1);
        assertEq(values[0], address(2));
    }

    function testValuesWithZeroSentinel() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        address[] memory values = addressSet.values();
        for (uint256 i = 0; i < values.length; i++) {
            assertFalse(values[i] == ZERO_SENTINEL);
        }
    }

    // At Function Invariants
    function testAtInEmptySet() public {
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        addressSet.at(0);
    }

    function testAtWithValidIndex() public {
        addressSet.add(address(1));
        assertEq(addressSet.at(0), address(1));
    }

    function testAtWithInvalidIndex() public {
        addressSet.add(address(1));
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        addressSet.at(1);
    }

    function testAtWithZeroSentinel() public {
        addressSet.add(address(1));
        assertFalse(addressSet.at(0) == ZERO_SENTINEL);
    }

    // General Invariants
    function testIdempotencyOfAdd() public {
        addressSet.add(address(1));
        addressSet.add(address(1));
        assertEq(addressSet.length(), 1);
    }

    function testIdempotencyOfRemove() public {
        addressSet.add(address(1));
        addressSet.remove(address(1));
        addressSet.remove(address(1));
        assertEq(addressSet.length(), 0);
    }

    function testConsistencyBetweenLengthAndValues() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        assertEq(addressSet.length(), addressSet.values().length);
    }

    function testConsistencyBetweenContainsAndValues() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        address[] memory values = addressSet.values();
        for (uint256 i = 0; i < values.length; i++) {
            assertTrue(addressSet.contains(values[i]));
        }
    }

    // Specific Edge Cases
    function testBoundaryConditions() public {
        addressSet.add(address(1));
        addressSet.add(address(2));
        addressSet.add(address(3));
        assertEq(addressSet.length(), 3);
        addressSet.add(address(4));
        assertEq(addressSet.length(), 4);
    }

    function testZeroValueHandling() public {
        addressSet.add(address(0));
        assertTrue(addressSet.contains(address(0)));
        addressSet.remove(address(0));
        assertFalse(addressSet.contains(address(0)));
    }

//    function testLargeSets() public {
//        for (uint256 i = 1; i <= 100; i++) {
//            addressSet.add(address(i));
//        }
//        assertEq(addressSet.length(), 100);
//        for (uint256 i = 1; i <= 100; i++) {
//            assertTrue(addressSet.contains(address(i)));
//        }
//    }
}