// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {EnumerableSetLib} from "../src/EnumerableSetLib.sol";

contract EnumerableSetLibTest is Test {
    using EnumerableSetLib for EnumerableSetLib.AddressSet;
    using EnumerableSetLib for EnumerableSetLib.Bytes32Set;
    using EnumerableSetLib for EnumerableSetLib.Uint256Set;
    using EnumerableSetLib for EnumerableSetLib.Int256Set;

    EnumerableSetLib.AddressSet private addressSet;
    EnumerableSetLib.Bytes32Set private bytes32Set;
    EnumerableSetLib.Uint256Set private uint256Set;
    EnumerableSetLib.Int256Set private int256Set;

    address constant ZERO_ADDRESS = address(0);
    bytes32 constant ZERO_BYTES32 = bytes32(0);
    uint256 constant ZERO_UINT256 = 0;
    int256 constant ZERO_INT256 = 0;

    function setUp() public {
        // Initial setup can be done here if required
    }

    // Test adding and removing elements
    function testAddRemoveAddress() public {
        address testAddress = address(0x123);
        assertTrue(!addressSet.contains(testAddress));
        assertTrue(addressSet.add(testAddress));
        assertTrue(addressSet.contains(testAddress));
        assertTrue(addressSet.remove(testAddress));
        assertTrue(!addressSet.contains(testAddress));
    }

    // function testAddRemoveBytes32() public {
    //     bytes32 testValue = bytes32(0xabcdef);
    //     assertTrue(!bytes32Set.contains(testValue));
    //     assertTrue(bytes32Set.add(testValue));
    //     assertTrue(bytes32Set.contains(testValue));
    //     assertTrue(bytes32Set.remove(testValue));
    //     assertTrue(!bytes32Set.contains(testValue));
    // }

    function testAddRemoveUint256() public {
        uint256 testValue = 123456;
        assertTrue(!uint256Set.contains(testValue));
        assertTrue(uint256Set.add(testValue));
        assertTrue(uint256Set.contains(testValue));
        assertTrue(uint256Set.remove(testValue));
        assertTrue(!uint256Set.contains(testValue));
    }

    function testAddRemoveInt256() public {
        int256 testValue = -123456;
        assertTrue(!int256Set.contains(testValue));
        assertTrue(int256Set.add(testValue));
        assertTrue(int256Set.contains(testValue));
        assertTrue(int256Set.remove(testValue));
        assertTrue(!int256Set.contains(testValue));
    }

    // // Test edge cases
    // function testZeroSentinelAddress() public {
    //     vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
    //     addressSet.add(ZERO_ADDRESS);
    // }

    // function testZeroSentinelBytes32() public {
    //     vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
    //     bytes32Set.add(ZERO_BYTES32);
    // }

    // function testZeroSentinelUint256() public {
    //     vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
    //     uint256Set.add(ZERO_UINT256);
    // }

    // function testZeroSentinelInt256() public {
    //     vm.expectRevert(EnumerableSetLib.ValueIsZeroSentinel.selector);
    //     int256Set.add(ZERO_INT256);
    // }

    // Test length and at functions
    function testLengthAndAt() public {
        addressSet.add(address(0x1));
        addressSet.add(address(0x2));
        addressSet.add(address(0x3));

        assertEq(addressSet.length(), 3);
        assertEq(addressSet.at(0), address(0x1));
        assertEq(addressSet.at(1), address(0x2));
        assertEq(addressSet.at(2), address(0x3));

        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        addressSet.at(3); // Out of bounds
    }

    // Test values function
    function testValues() public {
        addressSet.add(address(0x1));
        addressSet.add(address(0x2));
        addressSet.add(address(0x3));

        address[] memory vals = addressSet.values();
        assertEq(vals.length, 3);
        assertEq(vals[0], address(0x1));
        assertEq(vals[1], address(0x2));
        assertEq(vals[2], address(0x3));
    }
}
