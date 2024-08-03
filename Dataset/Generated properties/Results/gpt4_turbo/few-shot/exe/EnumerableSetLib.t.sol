// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/EnumerableSetLib.sol";

contract EnumerableSetLibTest is Test {
    using EnumerableSetLib for EnumerableSetLib.AddressSet;
    using EnumerableSetLib for EnumerableSetLib.Bytes32Set;
    using EnumerableSetLib for EnumerableSetLib.Uint256Set;
    using EnumerableSetLib for EnumerableSetLib.Int256Set;

    EnumerableSetLib.AddressSet private addressSet;
    EnumerableSetLib.Bytes32Set private bytes32Set;
    EnumerableSetLib.Uint256Set private uint256Set;
    EnumerableSetLib.Int256Set private int256Set;

    address constant testAddress1 = address(0x123);
    address constant testAddress2 = address(0x456);
    bytes32 constant testBytes1 = bytes32(uint256(0x01));
    bytes32 constant testBytes2 = bytes32(uint256(0x02));
    uint256 constant testUint1 = 1;
    uint256 constant testUint2 = 2;
    int256 constant testInt1 = -1;
    int256 constant testInt2 = -2;

    function setUp() public {
        // Initialize sets if needed
    }

    function testAddAddress() public {
        assertTrue(addressSet.add(testAddress1));
        assertTrue(addressSet.contains(testAddress1));
        assertFalse(addressSet.add(testAddress1)); // Should return false if added again
    }

    function testRemoveAddress() public {
        addressSet.add(testAddress1);
        assertTrue(addressSet.remove(testAddress1));
        assertFalse(addressSet.contains(testAddress1));
        assertFalse(addressSet.remove(testAddress1)); // Should return false if removed again
    }

    function testLengthAddress() public {
        addressSet.add(testAddress1);
        addressSet.add(testAddress2);
        assertEq(addressSet.length(), 2);
        addressSet.remove(testAddress1);
        assertEq(addressSet.length(), 1);
    }

    function testAddBytes32() public {
        assertTrue(bytes32Set.add(testBytes1));
        assertTrue(bytes32Set.contains(testBytes1));
        assertFalse(bytes32Set.add(testBytes1)); // Should return false if added again
    }

    function testRemoveBytes32() public {
        bytes32Set.add(testBytes1);
        assertTrue(bytes32Set.remove(testBytes1));
        assertFalse(bytes32Set.contains(testBytes1));
        assertFalse(bytes32Set.remove(testBytes1)); // Should return false if removed again
    }

    function testLengthBytes32() public {
        bytes32Set.add(testBytes1);
        bytes32Set.add(testBytes2);
        assertEq(bytes32Set.length(), 2);
        bytes32Set.remove(testBytes1);
        assertEq(bytes32Set.length(), 1);
    }

    function testAddUint256() public {
        assertTrue(uint256Set.add(testUint1));
        assertTrue(uint256Set.contains(testUint1));
        assertFalse(uint256Set.add(testUint1)); // Should return false if added again
    }

    function testRemoveUint256() public {
        uint256Set.add(testUint1);
        assertTrue(uint256Set.remove(testUint1));
        assertFalse(uint256Set.contains(testUint1));
        assertFalse(uint256Set.remove(testUint1)); // Should return false if removed again
    }

    function testLengthUint256() public {
        uint256Set.add(testUint1);
        uint256Set.add(testUint2);
        assertEq(uint256Set.length(), 2);
        uint256Set.remove(testUint1);
        assertEq(uint256Set.length(), 1);
    }

    function testAddInt256() public {
        assertTrue(int256Set.add(testInt1));
        assertTrue(int256Set.contains(testInt1));
        assertFalse(int256Set.add(testInt1)); // Should return false if added again
    }

    function testRemoveInt256() public {
        int256Set.add(testInt1);
        assertTrue(int256Set.remove(testInt1));
        assertFalse(int256Set.contains(testInt1));
        assertFalse(int256Set.remove(testInt1)); // Should return false if removed again
    }

    function testLengthInt256() public {
        int256Set.add(testInt1);
        int256Set.add(testInt2);
        assertEq(int256Set.length(), 2);
        int256Set.remove(testInt1);
        assertEq(int256Set.length(), 1);
    }
}