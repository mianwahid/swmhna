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

    function setUp() public {
        // Initial setup can be done here if needed
    }

    function testAddRemoveAddress() public {
        address testAddress = address(0x123);
        assertTrue(!addressSet.contains(testAddress));
        assertTrue(addressSet.add(testAddress));
        assertTrue(addressSet.contains(testAddress));
        assertTrue(addressSet.remove(testAddress));
        assertTrue(!addressSet.contains(testAddress));
    }

    function testAddRemoveBytes32() public {
        bytes32 testValue = bytes32(uint(0xabcdef));
        assertTrue(!bytes32Set.contains(testValue));
        assertTrue(bytes32Set.add(testValue));
        assertTrue(bytes32Set.contains(testValue));
        assertTrue(bytes32Set.remove(testValue));
        assertTrue(!bytes32Set.contains(testValue));
    }

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

    function testLengthAfterMultipleAdds() public {
        addressSet.add(address(0x1));
        addressSet.add(address(0x2));
        addressSet.add(address(0x3));
        assertEq(addressSet.length(), 3);
    }

    function testFailAddZeroAddress() public {
        addressSet.add(address(0));
    }

    function testFailRemoveNonexistent() public {
        assertTrue(!addressSet.remove(address(0x1)));
    }

    function testEnumeration() public {
        addressSet.add(address(0x1));
        addressSet.add(address(0x2));
        addressSet.add(address(0x3));

        assertEq(addressSet.at(0), address(0x1));
        assertEq(addressSet.at(1), address(0x2));
        assertEq(addressSet.at(2), address(0x3));
    }

    function testFailAccessOutOfBounds() public {
        addressSet.add(address(0x1));
        addressSet.at(1); // Should fail
    }

    function testClearSet() public {
        addressSet.add(address(0x1));
        addressSet.add(address(0x2));
        addressSet.remove(address(0x1));
        addressSet.remove(address(0x2));
        assertEq(addressSet.length(), 0);
    }
}