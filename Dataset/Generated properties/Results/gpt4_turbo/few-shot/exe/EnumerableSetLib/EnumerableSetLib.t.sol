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

    function testAddRemoveAddress() public {
        assertTrue(addressSet.add(testAddress1));
        assertTrue(addressSet.contains(testAddress1));
        assertEq(addressSet.length(), 1);

        assertTrue(addressSet.add(testAddress2));
        assertTrue(addressSet.contains(testAddress2));
        assertEq(addressSet.length(), 2);

        assertTrue(addressSet.remove(testAddress1));
        assertFalse(addressSet.contains(testAddress1));
        assertEq(addressSet.length(), 1);

        assertTrue(addressSet.remove(testAddress2));
        assertFalse(addressSet.contains(testAddress2));
        assertEq(addressSet.length(), 0);
    }

    function testAddRemoveBytes32() public {
        assertTrue(bytes32Set.add(testBytes1));
        assertTrue(bytes32Set.contains(testBytes1));
        assertEq(bytes32Set.length(), 1);

        assertTrue(bytes32Set.add(testBytes2));
        assertTrue(bytes32Set.contains(testBytes2));
        assertEq(bytes32Set.length(), 2);

        assertTrue(bytes32Set.remove(testBytes1));
        assertFalse(bytes32Set.contains(testBytes1));
        assertEq(bytes32Set.length(), 1);

        assertTrue(bytes32Set.remove(testBytes2));
        assertFalse(bytes32Set.contains(testBytes2));
        assertEq(bytes32Set.length(), 0);
    }

    function testAddRemoveUint256() public {
        assertTrue(uint256Set.add(testUint1));
        assertTrue(uint256Set.contains(testUint1));
        assertEq(uint256Set.length(), 1);

        assertTrue(uint256Set.add(testUint2));
        assertTrue(uint256Set.contains(testUint2));
        assertEq(uint256Set.length(), 2);

        assertTrue(uint256Set.remove(testUint1));
        assertFalse(uint256Set.contains(testUint1));
        assertEq(uint256Set.length(), 1);

        assertTrue(uint256Set.remove(testUint2));
        assertFalse(uint256Set.contains(testUint2));
        assertEq(uint256Set.length(), 0);
    }

    function testAddRemoveInt256() public {
        assertTrue(int256Set.add(testInt1));
        assertTrue(int256Set.contains(testInt1));
        assertEq(int256Set.length(), 1);

        assertTrue(int256Set.add(testInt2));
        assertTrue(int256Set.contains(testInt2));
        assertEq(int256Set.length(), 2);

        assertTrue(int256Set.remove(testInt1));
        assertFalse(int256Set.contains(testInt1));
        assertEq(int256Set.length(), 1);

        assertTrue(int256Set.remove(testInt2));
        assertFalse(int256Set.contains(testInt2));
        assertEq(int256Set.length(), 0);
    }

    function testFailAddZeroAddress() public {
        addressSet.add(address(0));
    }

    function testFailRemoveNonexistentAddress() public {
        addressSet.remove(testAddress1);
    }

    function testFailAddZeroBytes32() public {
        bytes32Set.add(bytes32(0));
    }

    function testFailRemoveNonexistentBytes32() public {
        bytes32Set.remove(testBytes1);
    }

    function testFailAddZeroUint256() public {
        uint256Set.add(0);
    }

    function testFailRemoveNonexistentUint256() public {
        uint256Set.remove(testUint1);
    }

    function testFailAddZeroInt256() public {
        int256Set.add(0);
    }

    function testFailRemoveNonexistentInt256() public {
        int256Set.remove(testInt1);
    }
}