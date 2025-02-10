// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
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

    function testAddAddress() public {
        address addr = address(0x123);
        bool added = addressSet.add(addr);
        assertTrue(added);
        assertTrue(addressSet.contains(addr));
    }

    function testAddBytes32() public {
        bytes32 value = keccak256("test");
        bool added = bytes32Set.add(value);
        assertTrue(added);
        assertTrue(bytes32Set.contains(value));
    }

    function testAddUint256() public {
        uint256 value = 123;
        bool added = uint256Set.add(value);
        assertTrue(added);
        assertTrue(uint256Set.contains(value));
    }

    function testAddInt256() public {
        int256 value = -123;
        bool added = int256Set.add(value);
        assertTrue(added);
        assertTrue(int256Set.contains(value));
    }

    function testRemoveAddress() public {
        address addr = address(0x123);
        addressSet.add(addr);
        bool removed = addressSet.remove(addr);
        assertTrue(removed);
        assertFalse(addressSet.contains(addr));
    }

    function testRemoveBytes32() public {
        bytes32 value = keccak256("test");
        bytes32Set.add(value);
        bool removed = bytes32Set.remove(value);
        assertTrue(removed);
        assertFalse(bytes32Set.contains(value));
    }

    function testRemoveUint256() public {
        uint256 value = 123;
        uint256Set.add(value);
        bool removed = uint256Set.remove(value);
        assertTrue(removed);
        assertFalse(uint256Set.contains(value));
    }

    function testRemoveInt256() public {
        int256 value = -123;
        int256Set.add(value);
        bool removed = int256Set.remove(value);
        assertTrue(removed);
        assertFalse(int256Set.contains(value));
    }

    function testLengthAddress() public {
        addressSet.add(address(0x123));
        addressSet.add(address(0x456));
        assertEq(addressSet.length(), 2);
    }

    function testLengthBytes32() public {
        bytes32Set.add(keccak256("test1"));
        bytes32Set.add(keccak256("test2"));
        assertEq(bytes32Set.length(), 2);
    }

    function testLengthUint256() public {
        uint256Set.add(123);
        uint256Set.add(456);
        assertEq(uint256Set.length(), 2);
    }

    function testLengthInt256() public {
        int256Set.add(-123);
        int256Set.add(456);
        assertEq(int256Set.length(), 2);
    }

    function testValuesAddress() public {
        addressSet.add(address(0x123));
        addressSet.add(address(0x456));
        address[] memory values = addressSet.values();
        assertEq(values.length, 2);
        assertTrue(values[0] == address(0x123) || values[1] == address(0x123));
        assertTrue(values[0] == address(0x456) || values[1] == address(0x456));
    }

    function testValuesBytes32() public {
        bytes32 value1 = keccak256("test1");
        bytes32 value2 = keccak256("test2");
        bytes32Set.add(value1);
        bytes32Set.add(value2);
        bytes32[] memory values = bytes32Set.values();
        assertEq(values.length, 2);
        assertTrue(values[0] == value1 || values[1] == value1);
        assertTrue(values[0] == value2 || values[1] == value2);
    }

    function testValuesUint256() public {
        uint256 value1 = 123;
        uint256 value2 = 456;
        uint256Set.add(value1);
        uint256Set.add(value2);
        uint256[] memory values = uint256Set.values();
        assertEq(values.length, 2);
        assertTrue(values[0] == value1 || values[1] == value1);
        assertTrue(values[0] == value2 || values[1] == value2);
    }

    function testValuesInt256() public {
        int256 value1 = -123;
        int256 value2 = 456;
        int256Set.add(value1);
        int256Set.add(value2);
        int256[] memory values = int256Set.values();
        assertEq(values.length, 2);
        assertTrue(values[0] == value1 || values[1] == value1);
        assertTrue(values[0] == value2 || values[1] == value2);
    }

    function testAtAddress() public {
        addressSet.add(address(0x123));
        addressSet.add(address(0x456));
        assertEq(addressSet.at(0), address(0x123));
        assertEq(addressSet.at(1), address(0x456));
    }

    function testAtBytes32() public {
        bytes32 value1 = keccak256("test1");
        bytes32 value2 = keccak256("test2");
        bytes32Set.add(value1);
        bytes32Set.add(value2);
        assertEq(bytes32Set.at(0), value1);
        assertEq(bytes32Set.at(1), value2);
    }

    function testAtUint256() public {
        uint256 value1 = 123;
        uint256 value2 = 456;
        uint256Set.add(value1);
        uint256Set.add(value2);
        assertEq(uint256Set.at(0), value1);
        assertEq(uint256Set.at(1), value2);
    }

    function testAtInt256() public {
        int256 value1 = -123;
        int256 value2 = 456;
        int256Set.add(value1);
        int256Set.add(value2);
        assertEq(int256Set.at(0), value1);
        assertEq(int256Set.at(1), value2);
    }
}