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

    EnumerableSetLib.AddressSet private _addressSet;
    EnumerableSetLib.Bytes32Set private _bytes32Set;
    EnumerableSetLib.Uint256Set private _uint256Set;
    EnumerableSetLib.Int256Set private _int256Set;

    address private constant _A = address(0xA);
    address private constant _B = address(0xB);
    address private constant _C = address(0xC);
    address private constant _D = address(0xD);

    bytes32 private constant _BYTES_A = keccak256(abi.encode("A"));
    bytes32 private constant _BYTES_B = keccak256(abi.encode("B"));
    bytes32 private constant _BYTES_C = keccak256(abi.encode("C"));
    bytes32 private constant _BYTES_D = keccak256(abi.encode("D"));

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         ADDRESS SET                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testAddressSet_AddAndContains() public {
        assertTrue(_addressSet.add(_A), "Should add successfully.");
        assertTrue(_addressSet.contains(_A), "Should contain the added address.");
        assertEq(_addressSet.length(), 1, "Length should be 1.");
    }

    function testAddressSet_AddExisting() public {
        assertTrue(_addressSet.add(_A), "Should add successfully.");
        assertFalse(_addressSet.add(_A), "Should not add an existing address.");
        assertEq(_addressSet.length(), 1, "Length should remain 1.");
    }

    function testAddressSet_Remove() public {
        assertTrue(_addressSet.add(_A), "Should add successfully.");
        assertTrue(_addressSet.remove(_A), "Should remove successfully.");
        assertFalse(_addressSet.contains(_A), "Should not contain the removed address.");
        assertEq(_addressSet.length(), 0, "Length should be 0.");
    }

    function testAddressSet_RemoveNonExisting() public {
        assertFalse(_addressSet.remove(_A), "Should not remove a non-existing address.");
        assertEq(_addressSet.length(), 0, "Length should remain 0.");
    }

    function testAddressSet_AddMultiple() public {
        assertTrue(_addressSet.add(_A), "Should add A successfully.");
        assertTrue(_addressSet.add(_B), "Should add B successfully.");
        assertTrue(_addressSet.add(_C), "Should add C successfully.");
        assertEq(_addressSet.length(), 3, "Length should be 3.");
    }

    function testAddressSet_AddMultipleAndRemove() public {
        assertTrue(_addressSet.add(_A), "Should add A successfully.");
        assertTrue(_addressSet.add(_B), "Should add B successfully.");
        assertTrue(_addressSet.add(_C), "Should add C successfully.");
        assertTrue(_addressSet.remove(_B), "Should remove B successfully.");
        assertEq(_addressSet.length(), 2, "Length should be 2.");
        assertTrue(_addressSet.contains(_A), "Should still contain A.");
        assertTrue(_addressSet.contains(_C), "Should still contain C.");
    }

    function testAddressSet_Values() public {
        assertTrue(_addressSet.add(_A), "Should add A successfully.");
        assertTrue(_addressSet.add(_B), "Should add B successfully.");
        assertTrue(_addressSet.add(_C), "Should add C successfully.");
        address[] memory values = _addressSet.values();
        assertEq(values.length, 3, "Values length should be 3.");
        assertEq(values[0], _A, "First value should be A.");
        assertEq(values[1], _B, "Second value should be B.");
        assertEq(values[2], _C, "Third value should be C.");
    }

    function testAddressSet_At() public {
        assertTrue(_addressSet.add(_A), "Should add A successfully.");
        assertTrue(_addressSet.add(_B), "Should add B successfully.");
        assertTrue(_addressSet.add(_C), "Should add C successfully.");
        assertEq(_addressSet.at(0), _A, "Value at index 0 should be A.");
        assertEq(_addressSet.at(1), _B, "Value at index 1 should be B.");
        assertEq(_addressSet.at(2), _C, "Value at index 2 should be C.");
    }

    function testAddressSet_AtOutOfBounds() public {
        assertTrue(_addressSet.add(_A), "Should add A successfully.");
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        _addressSet.at(1);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         BYTES32 SET                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testBytes32Set_AddAndContains() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add successfully.");
        assertTrue(_bytes32Set.contains(_BYTES_A), "Should contain the added bytes32.");
        assertEq(_bytes32Set.length(), 1, "Length should be 1.");
    }

    function testBytes32Set_AddExisting() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add successfully.");
        assertFalse(_bytes32Set.add(_BYTES_A), "Should not add an existing bytes32.");
        assertEq(_bytes32Set.length(), 1, "Length should remain 1.");
    }

    function testBytes32Set_Remove() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add successfully.");
        assertTrue(_bytes32Set.remove(_BYTES_A), "Should remove successfully.");
        assertFalse(_bytes32Set.contains(_BYTES_A), "Should not contain the removed bytes32.");
        assertEq(_bytes32Set.length(), 0, "Length should be 0.");
    }

    function testBytes32Set_RemoveNonExisting() public {
        assertFalse(_bytes32Set.remove(_BYTES_A), "Should not remove a non-existing bytes32.");
        assertEq(_bytes32Set.length(), 0, "Length should remain 0.");
    }

    function testBytes32Set_AddMultiple() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add A successfully.");
        assertTrue(_bytes32Set.add(_BYTES_B), "Should add B successfully.");
        assertTrue(_bytes32Set.add(_BYTES_C), "Should add C successfully.");
        assertEq(_bytes32Set.length(), 3, "Length should be 3.");
    }

    function testBytes32Set_AddMultipleAndRemove() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add A successfully.");
        assertTrue(_bytes32Set.add(_BYTES_B), "Should add B successfully.");
        assertTrue(_bytes32Set.add(_BYTES_C), "Should add C successfully.");
        assertTrue(_bytes32Set.remove(_BYTES_B), "Should remove B successfully.");
        assertEq(_bytes32Set.length(), 2, "Length should be 2.");
        assertTrue(_bytes32Set.contains(_BYTES_A), "Should still contain A.");
        assertTrue(_bytes32Set.contains(_BYTES_C), "Should still contain C.");
    }

    function testBytes32Set_Values() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add A successfully.");
        assertTrue(_bytes32Set.add(_BYTES_B), "Should add B successfully.");
        assertTrue(_bytes32Set.add(_BYTES_C), "Should add C successfully.");
        bytes32[] memory values = _bytes32Set.values();
        assertEq(values.length, 3, "Values length should be 3.");
        assertEq(values[0], _BYTES_A, "First value should be A.");
        assertEq(values[1], _BYTES_B, "Second value should be B.");
        assertEq(values[2], _BYTES_C, "Third value should be C.");
    }

    function testBytes32Set_At() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add A successfully.");
        assertTrue(_bytes32Set.add(_BYTES_B), "Should add B successfully.");
        assertTrue(_bytes32Set.add(_BYTES_C), "Should add C successfully.");
        assertEq(_bytes32Set.at(0), _BYTES_A, "Value at index 0 should be A.");
        assertEq(_bytes32Set.at(1), _BYTES_B, "Value at index 1 should be B.");
        assertEq(_bytes32Set.at(2), _BYTES_C, "Value at index 2 should be C.");
    }

    function testBytes32Set_AtOutOfBounds() public {
        assertTrue(_bytes32Set.add(_BYTES_A), "Should add A successfully.");
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        _bytes32Set.at(1);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         UINT256 SET                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testUint256Set_AddAndContains() public {
        assertTrue(_uint256Set.add(1), "Should add successfully.");
        assertTrue(_uint256Set.contains(1), "Should contain the added uint256.");
        assertEq(_uint256Set.length(), 1, "Length should be 1.");
    }

    function testUint256Set_AddExisting() public {
        assertTrue(_uint256Set.add(1), "Should add successfully.");
        assertFalse(_uint256Set.add(1), "Should not add an existing uint256.");
        assertEq(_uint256Set.length(), 1, "Length should remain 1.");
    }

    function testUint256Set_Remove() public {
        assertTrue(_uint256Set.add(1), "Should add successfully.");
        assertTrue(_uint256Set.remove(1), "Should remove successfully.");
        assertFalse(_uint256Set.contains(1), "Should not contain the removed uint256.");
        assertEq(_uint256Set.length(), 0, "Length should be 0.");
    }

    function testUint256Set_RemoveNonExisting() public {
        assertFalse(_uint256Set.remove(1), "Should not remove a non-existing uint256.");
        assertEq(_uint256Set.length(), 0, "Length should remain 0.");
    }

    function testUint256Set_AddMultiple() public {
        assertTrue(_uint256Set.add(1), "Should add 1 successfully.");
        assertTrue(_uint256Set.add(2), "Should add 2 successfully.");
        assertTrue(_uint256Set.add(3), "Should add 3 successfully.");
        assertEq(_uint256Set.length(), 3, "Length should be 3.");
    }

    function testUint256Set_AddMultipleAndRemove() public {
        assertTrue(_uint256Set.add(1), "Should add 1 successfully.");
        assertTrue(_uint256Set.add(2), "Should add 2 successfully.");
        assertTrue(_uint256Set.add(3), "Should add 3 successfully.");
        assertTrue(_uint256Set.remove(2), "Should remove 2 successfully.");
        assertEq(_uint256Set.length(), 2, "Length should be 2.");
        assertTrue(_uint256Set.contains(1), "Should still contain 1.");
        assertTrue(_uint256Set.contains(3), "Should still contain 3.");
    }

    function testUint256Set_Values() public {
        assertTrue(_uint256Set.add(1), "Should add 1 successfully.");
        assertTrue(_uint256Set.add(2), "Should add 2 successfully.");
        assertTrue(_uint256Set.add(3), "Should add 3 successfully.");
        uint256[] memory values = _uint256Set.values();
        assertEq(values.length, 3, "Values length should be 3.");
        assertEq(values[0], 1, "First value should be 1.");
        assertEq(values[1], 2, "Second value should be 2.");
        assertEq(values[2], 3, "Third value should be 3.");
    }

    function testUint256Set_At() public {
        assertTrue(_uint256Set.add(1), "Should add 1 successfully.");
        assertTrue(_uint256Set.add(2), "Should add 2 successfully.");
        assertTrue(_uint256Set.add(3), "Should add 3 successfully.");
        assertEq(_uint256Set.at(0), 1, "Value at index 0 should be 1.");
        assertEq(_uint256Set.at(1), 2, "Value at index 1 should be 2.");
        assertEq(_uint256Set.at(2), 3, "Value at index 2 should be 3.");
    }

    function testUint256Set_AtOutOfBounds() public {
        assertTrue(_uint256Set.add(1), "Should add 1 successfully.");
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        _uint256Set.at(1);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         INT256 SET                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testInt256Set_AddAndContains() public {
        assertTrue(_int256Set.add(1), "Should add successfully.");
        assertTrue(_int256Set.contains(1), "Should contain the added int256.");
        assertEq(_int256Set.length(), 1, "Length should be 1.");
    }

    function testInt256Set_AddExisting() public {
        assertTrue(_int256Set.add(1), "Should add successfully.");
        assertFalse(_int256Set.add(1), "Should not add an existing int256.");
        assertEq(_int256Set.length(), 1, "Length should remain 1.");
    }

    function testInt256Set_Remove() public {
        assertTrue(_int256Set.add(1), "Should add successfully.");
        assertTrue(_int256Set.remove(1), "Should remove successfully.");
        assertFalse(_int256Set.contains(1), "Should not contain the removed int256.");
        assertEq(_int256Set.length(), 0, "Length should be 0.");
    }

    function testInt256Set_RemoveNonExisting() public {
        assertFalse(_int256Set.remove(1), "Should not remove a non-existing int256.");
        assertEq(_int256Set.length(), 0, "Length should remain 0.");
    }

    function testInt256Set_AddMultiple() public {
        assertTrue(_int256Set.add(1), "Should add 1 successfully.");
        assertTrue(_int256Set.add(2), "Should add 2 successfully.");
        assertTrue(_int256Set.add(3), "Should add 3 successfully.");
        assertEq(_int256Set.length(), 3, "Length should be 3.");
    }

    function testInt256Set_AddMultipleAndRemove() public {
        assertTrue(_int256Set.add(1), "Should add 1 successfully.");
        assertTrue(_int256Set.add(2), "Should add 2 successfully.");
        assertTrue(_int256Set.add(3), "Should add 3 successfully.");
        assertTrue(_int256Set.remove(2), "Should remove 2 successfully.");
        assertEq(_int256Set.length(), 2, "Length should be 2.");
        assertTrue(_int256Set.contains(1), "Should still contain 1.");
        assertTrue(_int256Set.contains(3), "Should still contain 3.");
    }

    function testInt256Set_Values() public {
        assertTrue(_int256Set.add(1), "Should add 1 successfully.");
        assertTrue(_int256Set.add(2), "Should add 2 successfully.");
        assertTrue(_int256Set.add(3), "Should add 3 successfully.");
        int256[] memory values = _int256Set.values();
        assertEq(values.length, 3, "Values length should be 3.");
        assertEq(values[0], 1, "First value should be 1.");
        assertEq(values[1], 2, "Second value should be 2.");
        assertEq(values[2], 3, "Third value should be 3.");
    }

    function testInt256Set_At() public {
        assertTrue(_int256Set.add(1), "Should add 1 successfully.");
        assertTrue(_int256Set.add(2), "Should add 2 successfully.");
        assertTrue(_int256Set.add(3), "Should add 3 successfully.");
        assertEq(_int256Set.at(0), 1, "Value at index 0 should be 1.");
        assertEq(_int256Set.at(1), 2, "Value at index 1 should be 2.");
        assertEq(_int256Set.at(2), 3, "Value at index 2 should be 3.");
    }

    function testInt256Set_AtOutOfBounds() public {
        assertTrue(_int256Set.add(1), "Should add 1 successfully.");
        vm.expectRevert(EnumerableSetLib.IndexOutOfBounds.selector);
        _int256Set.at(1);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           FUZZ TESTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

//    function testAddressSet_FuzzAddRemove(address[] memory addresses) public {
//        uint256 originalLength = addresses.length;
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _addressSet.add(addresses[i]);
//            assertTrue(_addressSet.contains(addresses[i]));
//        }
//        assertEq(_addressSet.length(), originalLength);
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _addressSet.remove(addresses[i]);
//            assertFalse(_addressSet.contains(addresses[i]));
//        }
//        assertEq(_addressSet.length(), 0);
//    }

//    function testBytes32Set_FuzzAddRemove(bytes32[] memory data) public {
//        uint256 originalLength = data.length;
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _bytes32Set.add(data[i]);
//            assertTrue(_bytes32Set.contains(data[i]));
//        }
//        assertEq(_bytes32Set.length(), originalLength);
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _bytes32Set.remove(data[i]);
//            assertFalse(_bytes32Set.contains(data[i]));
//        }
//        assertEq(_bytes32Set.length(), 0);
//    }

//    function testUint256Set_FuzzAddRemove(uint256[] memory data) public {
//        uint256 originalLength = data.length;
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _uint256Set.add(data[i]);
//            assertTrue(_uint256Set.contains(data[i]));
//        }
//        assertEq(_uint256Set.length(), originalLength);
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _uint256Set.remove(data[i]);
//            assertFalse(_uint256Set.contains(data[i]));
//        }
//        assertEq(_uint256Set.length(), 0);
//    }

//    function testInt256Set_FuzzAddRemove(int256[] memory data) public {
//        uint256 originalLength = data.length;
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _int256Set.add(data[i]);
//            assertTrue(_int256Set.contains(data[i]));
//        }
//        assertEq(_int256Set.length(), originalLength);
//        for (uint256 i = 0; i < originalLength; ++i) {
//            _int256Set.remove(data[i]);
//            assertFalse(_int256Set.contains(data[i]));
//        }
//        assertEq(_int256Set.length(), 0);
//    }
}
