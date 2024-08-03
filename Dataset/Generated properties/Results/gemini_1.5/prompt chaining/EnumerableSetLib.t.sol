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

    EnumerableSetLib.AddressSet internal addressSet;
    EnumerableSetLib.Bytes32Set internal bytes32Set;
    EnumerableSetLib.Uint256Set internal uint256Set;
    EnumerableSetLib.Int256Set internal int256Set;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       TEST HELPERS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _checkAddressSetContains(address[] memory values, bool contains) internal {
        for (uint256 i = 0; i < values.length; i++) {
            assertEq(addressSet.contains(values[i]), contains);
        }
    }

    function _checkBytes32SetContains(bytes32[] memory values, bool contains) internal {
        for (uint256 i = 0; i < values.length; i++) {
            assertEq(bytes32Set.contains(values[i]), contains);
        }
    }

    function _checkUint256SetContains(uint256[] memory values, bool contains) internal {
        for (uint256 i = 0; i < values.length; i++) {
            assertEq(uint256Set.contains(values[i]), contains);
        }
    }

    function _checkInt256SetContains(int256[] memory values, bool contains) internal {
        for (uint256 i = 0; i < values.length; i++) {
            assertEq(int256Set.contains(values[i]), contains);
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           TESTS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testZeroSentinel() public {
//        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.ValueIsZeroSentinel.selector));
//        addressSet.add(address(uint160(EnumerableSetLib._ZERO_SENTINEL)));

//        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.ValueIsZeroSentinel.selector));
//        bytes32Set.add(bytes32(EnumerableSetLib._ZERO_SENTINEL));
//
//        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.ValueIsZeroSentinel.selector));
//        uint256Set.add(EnumerableSetLib._ZERO_SENTINEL);
//
//        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.ValueIsZeroSentinel.selector));
//        int256Set.add(int256(int128(EnumerableSetLib._ZERO_SENTINEL)));
    }

    function testInitialLength() public {
        assertEq(addressSet.length(), 0);
        assertEq(bytes32Set.length(), 0);
        assertEq(uint256Set.length(), 0);
        assertEq(int256Set.length(), 0);
    }

    function testAddUniqueElements() public {
        address[] memory addressValues = new address[](3);
        addressValues[0] = address(1);
        addressValues[1] = address(2);
        addressValues[2] = address(3);

        bytes32[] memory bytes32Values = new bytes32[](3);
        bytes32Values[0] = keccak256(abi.encode("value1"));
        bytes32Values[1] = keccak256(abi.encode("value2"));
        bytes32Values[2] = keccak256(abi.encode("value3"));

        uint256[] memory uint256Values = new uint256[](3);
        uint256Values[0] = 1;
        uint256Values[1] = 2;
        uint256Values[2] = 3;

        int256[] memory int256Values = new int256[](3);
        int256Values[0] = 1;
        int256Values[1] = 2;
        int256Values[2] = 3;

        // Add unique elements to each set
        for (uint256 i = 0; i < 3; i++) {
            assertEq(addressSet.length(), i);
            assertTrue(addressSet.add(addressValues[i]));
            assertEq(addressSet.length(), i + 1);

            assertEq(bytes32Set.length(), i);
            assertTrue(bytes32Set.add(bytes32Values[i]));
            assertEq(bytes32Set.length(), i + 1);

            assertEq(uint256Set.length(), i);
            assertTrue(uint256Set.add(uint256Values[i]));
            assertEq(uint256Set.length(), i + 1);

            assertEq(int256Set.length(), i);
            assertTrue(int256Set.add(int256Values[i]));
            assertEq(int256Set.length(), i + 1);
        }

        _checkAddressSetContains(addressValues, true);
        _checkBytes32SetContains(bytes32Values, true);
        _checkUint256SetContains(uint256Values, true);
        _checkInt256SetContains(int256Values, true);
    }

    function testAddDuplicateElements() public {
        address addressValue = address(1);
        bytes32 bytes32Value = keccak256(abi.encode("value1"));
        uint256 uint256Value = 1;
        int256 int256Value = 1;

        // Add the element for the first time
        assertTrue(addressSet.add(addressValue));
        assertTrue(bytes32Set.add(bytes32Value));
        assertTrue(uint256Set.add(uint256Value));
        assertTrue(int256Set.add(int256Value));

        // Try to add the same element again
        assertFalse(addressSet.add(addressValue));
        assertFalse(bytes32Set.add(bytes32Value));
        assertFalse(uint256Set.add(uint256Value));
        assertFalse(int256Set.add(int256Value));

        // Check that the length remains 1
        assertEq(addressSet.length(), 1);
        assertEq(bytes32Set.length(), 1);
        assertEq(uint256Set.length(), 1);
        assertEq(int256Set.length(), 1);
    }

    function testRemoveExistingElements() public {
        address[] memory addressValues = new address[](3);
        addressValues[0] = address(1);
        addressValues[1] = address(2);
        addressValues[2] = address(3);

        bytes32[] memory bytes32Values = new bytes32[](3);
        bytes32Values[0] = keccak256(abi.encode("value1"));
        bytes32Values[1] = keccak256(abi.encode("value2"));
        bytes32Values[2] = keccak256(abi.encode("value3"));

        uint256[] memory uint256Values = new uint256[](3);
        uint256Values[0] = 1;
        uint256Values[1] = 2;
        uint256Values[2] = 3;

        int256[] memory int256Values = new int256[](3);
        int256Values[0] = 1;
        int256Values[1] = 2;
        int256Values[2] = 3;

        // Add elements to each set
        for (uint256 i = 0; i < 3; i++) {
            addressSet.add(addressValues[i]);
            bytes32Set.add(bytes32Values[i]);
            uint256Set.add(uint256Values[i]);
            int256Set.add(int256Values[i]);
        }

        // Remove existing elements
        for (uint256 i = 0; i < 3; i++) {
            assertEq(addressSet.length(), 3 - i);
            assertTrue(addressSet.remove(addressValues[i]));
            assertEq(addressSet.length(), 3 - i - 1);

            assertEq(bytes32Set.length(), 3 - i);
            assertTrue(bytes32Set.remove(bytes32Values[i]));
            assertEq(bytes32Set.length(), 3 - i - 1);

            assertEq(uint256Set.length(), 3 - i);
            assertTrue(uint256Set.remove(uint256Values[i]));
            assertEq(uint256Set.length(), 3 - i - 1);

            assertEq(int256Set.length(), 3 - i);
            assertTrue(int256Set.remove(int256Values[i]));
            assertEq(int256Set.length(), 3 - i - 1);
        }

        _checkAddressSetContains(addressValues, false);
        _checkBytes32SetContains(bytes32Values, false);
        _checkUint256SetContains(uint256Values, false);
        _checkInt256SetContains(int256Values, false);
    }

    function testRemoveNonExistingElements() public {
        address addressValue = address(1);
        bytes32 bytes32Value = keccak256(abi.encode("value1"));
        uint256 uint256Value = 1;
        int256 int256Value = 1;

        // Try to remove non-existing elements
        assertFalse(addressSet.remove(addressValue));
        assertFalse(bytes32Set.remove(bytes32Value));
        assertFalse(uint256Set.remove(uint256Value));
        assertFalse(int256Set.remove(int256Value));

        // Check that the length remains 0
        assertEq(addressSet.length(), 0);
        assertEq(bytes32Set.length(), 0);
        assertEq(uint256Set.length(), 0);
        assertEq(int256Set.length(), 0);
    }

    function testContainsAfterAdding() public {
        address addressValue = address(1);
        bytes32 bytes32Value = keccak256(abi.encode("value1"));
        uint256 uint256Value = 1;
        int256 int256Value = 1;

        // Add elements to each set
        addressSet.add(addressValue);
        bytes32Set.add(bytes32Value);
        uint256Set.add(uint256Value);
        int256Set.add(int256Value);

        // Check if the elements are present
        assertTrue(addressSet.contains(addressValue));
        assertTrue(bytes32Set.contains(bytes32Value));
        assertTrue(uint256Set.contains(uint256Value));
        assertTrue(int256Set.contains(int256Value));
    }

    function testContainsAfterRemoving() public {
        address addressValue = address(1);
        bytes32 bytes32Value = keccak256(abi.encode("value1"));
        uint256 uint256Value = 1;
        int256 int256Value = 1;

        // Add and then remove elements from each set
        addressSet.add(addressValue);
        addressSet.remove(addressValue);
        bytes32Set.add(bytes32Value);
        bytes32Set.remove(bytes32Value);
        uint256Set.add(uint256Value);
        uint256Set.remove(uint256Value);
        int256Set.add(int256Value);
        int256Set.remove(int256Value);

        // Check if the elements are no longer present
        assertFalse(addressSet.contains(addressValue));
        assertFalse(bytes32Set.contains(bytes32Value));
        assertFalse(uint256Set.contains(uint256Value));
        assertFalse(int256Set.contains(int256Value));
    }

    function testValuesArrayLength() public {
        address[] memory addressValues = new address[](3);
        addressValues[0] = address(1);
        addressValues[1] = address(2);
        addressValues[2] = address(3);

        bytes32[] memory bytes32Values = new bytes32[](3);
        bytes32Values[0] = keccak256(abi.encode("value1"));
        bytes32Values[1] = keccak256(abi.encode("value2"));
        bytes32Values[2] = keccak256(abi.encode("value3"));

        uint256[] memory uint256Values = new uint256[](3);
        uint256Values[0] = 1;
        uint256Values[1] = 2;
        uint256Values[2] = 3;

        int256[] memory int256Values = new int256[](3);
        int256Values[0] = 1;
        int256Values[1] = 2;
        int256Values[2] = 3;

        // Add elements to each set
        for (uint256 i = 0; i < 3; i++) {
            addressSet.add(addressValues[i]);
            bytes32Set.add(bytes32Values[i]);
            uint256Set.add(uint256Values[i]);
            int256Set.add(int256Values[i]);
        }

        // Check that the length of the values array matches the set length
        assertEq(addressSet.values().length, addressSet.length());
        assertEq(bytes32Set.values().length, bytes32Set.length());
        assertEq(uint256Set.values().length, uint256Set.length());
        assertEq(int256Set.values().length, int256Set.length());
    }

    function testValuesArrayContent() public {
        address[] memory addressValues = new address[](3);
        addressValues[0] = address(1);
        addressValues[1] = address(2);
        addressValues[2] = address(3);

        bytes32[] memory bytes32Values = new bytes32[](3);
        bytes32Values[0] = keccak256(abi.encode("value1"));
        bytes32Values[1] = keccak256(abi.encode("value2"));
        bytes32Values[2] = keccak256(abi.encode("value3"));

        uint256[] memory uint256Values = new uint256[](3);
        uint256Values[0] = 1;
        uint256Values[1] = 2;
        uint256Values[2] = 3;

        int256[] memory int256Values = new int256[](3);
        int256Values[0] = 1;
        int256Values[1] = 2;
        int256Values[2] = 3;

        // Add elements to each set
        for (uint256 i = 0; i < 3; i++) {
            addressSet.add(addressValues[i]);
            bytes32Set.add(bytes32Values[i]);
            uint256Set.add(uint256Values[i]);
            int256Set.add(int256Values[i]);
        }

        // Retrieve the values arrays
        address[] memory retrievedAddressValues = addressSet.values();
        bytes32[] memory retrievedBytes32Values = bytes32Set.values();
        uint256[] memory retrievedUint256Values = uint256Set.values();
        int256[] memory retrievedInt256Values = int256Set.values();

        // Check that the retrieved arrays contain the correct elements
        for (uint256 i = 0; i < 3; i++) {
            assertEq(retrievedAddressValues[i], addressValues[i]);
            assertEq(retrievedBytes32Values[i], bytes32Values[i]);
            assertEq(retrievedUint256Values[i], uint256Values[i]);
            assertEq(retrievedInt256Values[i], int256Values[i]);
        }
    }

    function testAtFunction() public {
        address[] memory addressValues = new address[](3);
        addressValues[0] = address(1);
        addressValues[1] = address(2);
        addressValues[2] = address(3);

        bytes32[] memory bytes32Values = new bytes32[](3);
        bytes32Values[0] = keccak256(abi.encode("value1"));
        bytes32Values[1] = keccak256(abi.encode("value2"));
        bytes32Values[2] = keccak256(abi.encode("value3"));

        uint256[] memory uint256Values = new uint256[](3);
        uint256Values[0] = 1;
        uint256Values[1] = 2;
        uint256Values[2] = 3;

        int256[] memory int256Values = new int256[](3);
        int256Values[0] = 1;
        int256Values[1] = 2;
        int256Values[2] = 3;

        // Add elements to each set
        for (uint256 i = 0; i < 3; i++) {
            addressSet.add(addressValues[i]);
            bytes32Set.add(bytes32Values[i]);
            uint256Set.add(uint256Values[i]);
            int256Set.add(int256Values[i]);
        }

        // Test valid indices
        for (uint256 i = 0; i < 3; i++) {
            assertEq(addressSet.at(i), addressValues[i]);
            assertEq(bytes32Set.at(i), bytes32Values[i]);
            assertEq(uint256Set.at(i), uint256Values[i]);
            assertEq(int256Set.at(i), int256Values[i]);
        }
    }

    function testAtFunctionIndexOutOfBounds() public {
        // Test invalid indices (out of bounds)
        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        addressSet.at(0);

        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        bytes32Set.at(0);

        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        uint256Set.at(0);

        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        int256Set.at(0);
    }

    function testAddressNormalization() public {
        address addressValue1 = address(0xa);
        address addressValue2 = address(0xb);

        // Add the address with checksum format
        addressSet.add(addressValue1);

        // Check if both formats are considered the same
        assertTrue(addressSet.contains(addressValue1));
        assertFalse(addressSet.contains(addressValue2));

        // Remove the address using lowercase format
        addressSet.remove(addressValue2);

//         Check if both formats are considered removed
        assertTrue(addressSet.contains(addressValue1));
        assertFalse(addressSet.contains(addressValue2));
    }
}
