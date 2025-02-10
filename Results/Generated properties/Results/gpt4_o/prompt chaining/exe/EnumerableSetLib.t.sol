// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EnumerableSetLib.sol";

contract EnumerableSetLibTest is Test {
    using EnumerableSetLib for EnumerableSetLib.AddressSet;
    EnumerableSetLib.AddressSet private addressSet;

    address private constant ADDR1 = address(0x1);
    address private constant ADDR2 = address(0x2);
    address private constant ADDR3 = address(0x3);
    address private constant ADDR4 = address(0x4);
    address private constant ZERO_SENTINEL = address(0xfbb67fda52d4bfb8bf);

    function setUp() public {
        // Initial setup if needed
    }

    // Length Function Invariants
    function testInitialLength() public {
        assertEq(addressSet.length(), 0);
    }

    function testLengthAfterAdditions() public {
        addressSet.add(ADDR1);
        assertEq(addressSet.length(), 1);
        addressSet.add(ADDR2);
        assertEq(addressSet.length(), 2);
    }

    function testLengthAfterRemovals() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        addressSet.remove(ADDR1);
        assertEq(addressSet.length(), 1);
        addressSet.remove(ADDR2);
        assertEq(addressSet.length(), 0);
    }

    function testLengthWithDuplicates() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR1);
        assertEq(addressSet.length(), 1);
    }

    function testLengthWithZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.add(ZERO_SENTINEL);
        assertEq(addressSet.length(), 0);
    }

    // Contains Function Invariants
    function testContainsInEmptySet() public {
        assertFalse(addressSet.contains(ADDR1));
    }

    function testContainsAfterAddition() public {
        addressSet.add(ADDR1);
        assertTrue(addressSet.contains(ADDR1));
    }

    function testContainsAfterRemoval() public {
        addressSet.add(ADDR1);
        addressSet.remove(ADDR1);
        assertFalse(addressSet.contains(ADDR1));
    }

    function testContainsWithZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.contains(ZERO_SENTINEL);
    }

    // Add Function Invariants
    function testAddToEmptySet() public {
        assertTrue(addressSet.add(ADDR1));
    }

    function testAddDuplicate() public {
        addressSet.add(ADDR1);
        assertFalse(addressSet.add(ADDR1));
    }

    function testAddZeroSentinel() public {
        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
        addressSet.add(ZERO_SENTINEL);
    }

    function testAddMultipleValues() public {
        assertTrue(addressSet.add(ADDR1));
        assertTrue(addressSet.add(ADDR2));
        assertTrue(addressSet.add(ADDR3));
    }

    // Remove Function Invariants
    function testRemoveFromEmptySet() public {
        assertFalse(addressSet.remove(ADDR1));
    }

    function testRemoveExistingValue() public {
        addressSet.add(ADDR1);
        assertTrue(addressSet.remove(ADDR1));
    }

    function testRemoveNonExistingValue() public {
        addressSet.add(ADDR1);
        assertFalse(addressSet.remove(ADDR2));
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
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        address[] memory values = addressSet.values();
        assertEq(values.length, 2);
        assertEq(values[0], ADDR1);
        assertEq(values[1], ADDR2);
    }

    function testValuesAfterRemovals() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        addressSet.remove(ADDR1);
        address[] memory values = addressSet.values();
        assertEq(values.length, 1);
        assertEq(values[0], ADDR2);
    }

    function testValuesWithZeroSentinel() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
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

    function testAtValidIndex() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        assertEq(addressSet.at(0), ADDR1);
        assertEq(addressSet.at(1), ADDR2);
    }

    function testAtInvalidIndex() public {
        addressSet.add(ADDR1);
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        addressSet.at(1);
    }

    function testAtWithZeroSentinel() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        for (uint256 i = 0; i < addressSet.length(); i++) {
            assertFalse(addressSet.at(i) == ZERO_SENTINEL);
        }
    }

    // General Invariants
    function testIdempotencyOfAdd() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR1);
        assertEq(addressSet.length(), 1);
    }

    function testIdempotencyOfRemove() public {
        addressSet.add(ADDR1);
        addressSet.remove(ADDR1);
        addressSet.remove(ADDR1);
        assertEq(addressSet.length(), 0);
    }

    function testConsistencyBetweenLengthAndValues() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        assertEq(addressSet.length(), addressSet.values().length);
    }

    function testConsistencyBetweenContainsAndValues() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        address[] memory values = addressSet.values();
        for (uint256 i = 0; i < values.length; i++) {
            assertTrue(addressSet.contains(values[i]));
        }
    }

    // Specific Edge Cases
    function testBoundaryConditionsForLength() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        addressSet.add(ADDR3);
        assertEq(addressSet.length(), 3);
        addressSet.add(ADDR4);
        assertEq(addressSet.length(), 4);
    }

    function testBoundaryConditionsForAddRemove() public {
        addressSet.add(ADDR1);
        addressSet.add(ADDR2);
        addressSet.remove(ADDR1);
        addressSet.add(ADDR3);
        assertEq(addressSet.length(), 2);
    }

    function testLargeSets() public {
        for (uint256 i = 1; i <= 1000; i++) {
            addressSet.add(address(uint160(i)));
        }
        assertEq(addressSet.length(), 1000);
    }
}