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

    address private constant TEST_ADDRESS = address(0x123);
    bytes32 private constant TEST_BYTES32 = keccak256("test");
    uint256 private constant TEST_UINT256 = 123;
    int256 private constant TEST_INT256 = -123;

    function setUp() public {
        // Initial setup if needed
    }

    function testAddAddress() public {
        bool added = addressSet.add(TEST_ADDRESS);
        assertTrue(added, "Address should be added");
        assertTrue(addressSet.contains(TEST_ADDRESS), "Address should be contained");
    }

    function testAddBytes32() public {
        bool added = bytes32Set.add(TEST_BYTES32);
        assertTrue(added, "Bytes32 should be added");
        assertTrue(bytes32Set.contains(TEST_BYTES32), "Bytes32 should be contained");
    }

    function testAddUint256() public {
        bool added = uint256Set.add(TEST_UINT256);
        assertTrue(added, "Uint256 should be added");
        assertTrue(uint256Set.contains(TEST_UINT256), "Uint256 should be contained");
    }

    function testAddInt256() public {
        bool added = int256Set.add(TEST_INT256);
        assertTrue(added, "Int256 should be added");
        assertTrue(int256Set.contains(TEST_INT256), "Int256 should be contained");
    }

    function testRemoveAddress() public {
        addressSet.add(TEST_ADDRESS);
        bool removed = addressSet.remove(TEST_ADDRESS);
        assertTrue(removed, "Address should be removed");
        assertFalse(addressSet.contains(TEST_ADDRESS), "Address should not be contained");
    }

    function testRemoveBytes32() public {
        bytes32Set.add(TEST_BYTES32);
        bool removed = bytes32Set.remove(TEST_BYTES32);
        assertTrue(removed, "Bytes32 should be removed");
        assertFalse(bytes32Set.contains(TEST_BYTES32), "Bytes32 should not be contained");
    }

    function testRemoveUint256() public {
        uint256Set.add(TEST_UINT256);
        bool removed = uint256Set.remove(TEST_UINT256);
        assertTrue(removed, "Uint256 should be removed");
        assertFalse(uint256Set.contains(TEST_UINT256), "Uint256 should not be contained");
    }

    function testRemoveInt256() public {
        int256Set.add(TEST_INT256);
        bool removed = int256Set.remove(TEST_INT256);
        assertTrue(removed, "Int256 should be removed");
        assertFalse(int256Set.contains(TEST_INT256), "Int256 should not be contained");
    }

    function testLengthAddress() public {
        addressSet.add(TEST_ADDRESS);
        assertEq(addressSet.length(), 1, "Length should be 1");
    }

    function testLengthBytes32() public {
        bytes32Set.add(TEST_BYTES32);
        assertEq(bytes32Set.length(), 1, "Length should be 1");
    }

    function testLengthUint256() public {
        uint256Set.add(TEST_UINT256);
        assertEq(uint256Set.length(), 1, "Length should be 1");
    }

    function testLengthInt256() public {
        int256Set.add(TEST_INT256);
        assertEq(int256Set.length(), 1, "Length should be 1");
    }

    function testValuesAddress() public {
        addressSet.add(TEST_ADDRESS);
        address[] memory values = addressSet.values();
        assertEq(values.length, 1, "Values length should be 1");
        assertEq(values[0], TEST_ADDRESS, "Values should contain the test address");
    }

    function testValuesBytes32() public {
        bytes32Set.add(TEST_BYTES32);
        bytes32[] memory values = bytes32Set.values();
        assertEq(values.length, 1, "Values length should be 1");
        assertEq(values[0], TEST_BYTES32, "Values should contain the test bytes32");
    }

    function testValuesUint256() public {
        uint256Set.add(TEST_UINT256);
        uint256[] memory values = uint256Set.values();
        assertEq(values.length, 1, "Values length should be 1");
        assertEq(values[0], TEST_UINT256, "Values should contain the test uint256");
    }

    function testValuesInt256() public {
        int256Set.add(TEST_INT256);
        int256[] memory values = int256Set.values();
        assertEq(values.length, 1, "Values length should be 1");
        assertEq(values[0], TEST_INT256, "Values should contain the test int256");
    }

    function testAtAddress() public {
        addressSet.add(TEST_ADDRESS);
        address value = addressSet.at(0);
        assertEq(value, TEST_ADDRESS, "Value at index 0 should be the test address");
    }

    function testAtBytes32() public {
        bytes32Set.add(TEST_BYTES32);
        bytes32 value = bytes32Set.at(0);
        assertEq(value, TEST_BYTES32, "Value at index 0 should be the test bytes32");
    }

    function testAtUint256() public {
        uint256Set.add(TEST_UINT256);
        uint256 value = uint256Set.at(0);
        assertEq(value, TEST_UINT256, "Value at index 0 should be the test uint256");
    }

    function testAtInt256() public {
        int256Set.add(TEST_INT256);
        int256 value = int256Set.at(0);
        assertEq(value, TEST_INT256, "Value at index 0 should be the test int256");
    }

//    function testZeroSentinelAddress() public {
//        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
//        addressSet.add(address(0));
//    }
//
//    function testZeroSentinelBytes32() public {
//        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
//        bytes32Set.add(bytes32(0));
//    }
//
//    function testZeroSentinelUint256() public {
//        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
//        uint256Set.add(0);
//    }
//
//    function testZeroSentinelInt256() public {
//        vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
//        int256Set.add(0);
//    }

    function testIndexOutOfBoundsAddress() public {
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        addressSet.at(1);
    }

    function testIndexOutOfBoundsBytes32() public {
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        bytes32Set.at(1);
    }

    function testIndexOutOfBoundsUint256() public {
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        uint256Set.at(1);
    }

    function testIndexOutOfBoundsInt256() public {
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        int256Set.at(1);
    }
}