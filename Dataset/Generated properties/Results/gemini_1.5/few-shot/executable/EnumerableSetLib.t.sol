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

    address private constant _A = address(0xA0);
    address private constant _B = address(0xB0);
    address private constant _C = address(0xC0);
    address private constant _D = address(0xD0);

    bytes32 private constant _A_BYTES32 = keccak256(abi.encode(_A));
    bytes32 private constant _B_BYTES32 = keccak256(abi.encode(_B));
    bytes32 private constant _C_BYTES32 = keccak256(abi.encode(_C));
    bytes32 private constant _D_BYTES32 = keccak256(abi.encode(_D));

    uint256 private constant _A_UINT256 = uint256(uint160(_A));
    uint256 private constant _B_UINT256 = uint256(uint160(_B));
    uint256 private constant _C_UINT256 = uint256(uint160(_C));
    uint256 private constant _D_UINT256 = uint256(uint160(_D));

    int256 private constant _A_INT256 = int256(_A_UINT256);
    int256 private constant _B_INT256 = int256(_B_UINT256);
    int256 private constant _C_INT256 = int256(_C_UINT256);
    int256 private constant _D_INT256 = int256(_D_UINT256);

    function testAddressSet() public {
        // Should be empty initially.
        assertEq(_addressSet.length(), 0);

        // Add one element.
        assertTrue(_addressSet.add(_A));
        assertEq(_addressSet.length(), 1);
        assertTrue(_addressSet.contains(_A));
        assertEq(_addressSet.at(0), _A);

        // Add existing element.
        assertFalse(_addressSet.add(_A));
        assertEq(_addressSet.length(), 1);
        assertTrue(_addressSet.contains(_A));
        assertEq(_addressSet.at(0), _A);

        // Add more elements.
        assertTrue(_addressSet.add(_B));
        assertEq(_addressSet.length(), 2);
        assertTrue(_addressSet.contains(_B));
        assertEq(_addressSet.at(1), _B);

        assertTrue(_addressSet.add(_C));
        assertEq(_addressSet.length(), 3);
        assertTrue(_addressSet.contains(_C));
        assertEq(_addressSet.at(2), _C);

        // Remove elements.
        assertTrue(_addressSet.remove(_B));
        assertEq(_addressSet.length(), 2);
        assertFalse(_addressSet.contains(_B));
        assertEq(_addressSet.at(1), _C);

        assertTrue(_addressSet.remove(_A));
        assertEq(_addressSet.length(), 1);
        assertFalse(_addressSet.contains(_A));
        assertEq(_addressSet.at(0), _C);

        assertFalse(_addressSet.remove(_B));
        assertEq(_addressSet.length(), 1);
        assertFalse(_addressSet.contains(_B));
        assertEq(_addressSet.at(0), _C);

        assertTrue(_addressSet.remove(_C));
        assertEq(_addressSet.length(), 0);
        assertFalse(_addressSet.contains(_C));

        // Add more elements after removing all.
        assertTrue(_addressSet.add(_D));
        assertEq(_addressSet.length(), 1);
        assertTrue(_addressSet.contains(_D));
        assertEq(_addressSet.at(0), _D);
    }

    function testAddressSetOutOfBounds() public {
        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        _addressSet.at(0);
    }



    function testAddressSetValues() public {
        _addressSet.add(_A);
        _addressSet.add(_C);
        _addressSet.add(_B);

        address[] memory values = _addressSet.values();
        assertEq(values.length, 3);
        assertEq(values[0], _A);
        assertEq(values[1], _C);
        assertEq(values[2], _B);
    }

    function testBytes32Set() public {
        // Should be empty initially.
        assertEq(_bytes32Set.length(), 0);

        // Add one element.
        assertTrue(_bytes32Set.add(_A_BYTES32));
        assertEq(_bytes32Set.length(), 1);
        assertTrue(_bytes32Set.contains(_A_BYTES32));
        assertEq(_bytes32Set.at(0), _A_BYTES32);

        // Add existing element.
        assertFalse(_bytes32Set.add(_A_BYTES32));
        assertEq(_bytes32Set.length(), 1);
        assertTrue(_bytes32Set.contains(_A_BYTES32));
        assertEq(_bytes32Set.at(0), _A_BYTES32);

        // Add more elements.
        assertTrue(_bytes32Set.add(_B_BYTES32));
        assertEq(_bytes32Set.length(), 2);
        assertTrue(_bytes32Set.contains(_B_BYTES32));
        assertEq(_bytes32Set.at(1), _B_BYTES32);

        assertTrue(_bytes32Set.add(_C_BYTES32));
        assertEq(_bytes32Set.length(), 3);
        assertTrue(_bytes32Set.contains(_C_BYTES32));
        assertEq(_bytes32Set.at(2), _C_BYTES32);

        // Remove elements.
        assertTrue(_bytes32Set.remove(_B_BYTES32));
        assertEq(_bytes32Set.length(), 2);
        assertFalse(_bytes32Set.contains(_B_BYTES32));
        assertEq(_bytes32Set.at(1), _C_BYTES32);

        assertTrue(_bytes32Set.remove(_A_BYTES32));
        assertEq(_bytes32Set.length(), 1);
        assertFalse(_bytes32Set.contains(_A_BYTES32));
        assertEq(_bytes32Set.at(0), _C_BYTES32);

        assertFalse(_bytes32Set.remove(_B_BYTES32));
        assertEq(_bytes32Set.length(), 1);
        assertFalse(_bytes32Set.contains(_B_BYTES32));
        assertEq(_bytes32Set.at(0), _C_BYTES32);

        assertTrue(_bytes32Set.remove(_C_BYTES32));
        assertEq(_bytes32Set.length(), 0);
        assertFalse(_bytes32Set.contains(_C_BYTES32));

        // Add more elements after removing all.
        assertTrue(_bytes32Set.add(_D_BYTES32));
        assertEq(_bytes32Set.length(), 1);
        assertTrue(_bytes32Set.contains(_D_BYTES32));
        assertEq(_bytes32Set.at(0), _D_BYTES32);
    }

    function testBytes32SetOutOfBounds() public {
        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        _bytes32Set.at(0);
    }



    function testBytes32SetValues() public {
        _bytes32Set.add(_A_BYTES32);
        _bytes32Set.add(_C_BYTES32);
        _bytes32Set.add(_B_BYTES32);

        bytes32[] memory values = _bytes32Set.values();
        assertEq(values.length, 3);
        assertEq(values[0], _A_BYTES32);
        assertEq(values[1], _C_BYTES32);
        assertEq(values[2], _B_BYTES32);
    }

    function testUint256Set() public {
        // Should be empty initially.
        assertEq(_uint256Set.length(), 0);

        // Add one element.
        assertTrue(_uint256Set.add(_A_UINT256));
        assertEq(_uint256Set.length(), 1);
        assertTrue(_uint256Set.contains(_A_UINT256));
        assertEq(_uint256Set.at(0), _A_UINT256);

        // Add existing element.
        assertFalse(_uint256Set.add(_A_UINT256));
        assertEq(_uint256Set.length(), 1);
        assertTrue(_uint256Set.contains(_A_UINT256));
        assertEq(_uint256Set.at(0), _A_UINT256);

        // Add more elements.
        assertTrue(_uint256Set.add(_B_UINT256));
        assertEq(_uint256Set.length(), 2);
        assertTrue(_uint256Set.contains(_B_UINT256));
        assertEq(_uint256Set.at(1), _B_UINT256);

        assertTrue(_uint256Set.add(_C_UINT256));
        assertEq(_uint256Set.length(), 3);
        assertTrue(_uint256Set.contains(_C_UINT256));
        assertEq(_uint256Set.at(2), _C_UINT256);

        // Remove elements.
        assertTrue(_uint256Set.remove(_B_UINT256));
        assertEq(_uint256Set.length(), 2);
        assertFalse(_uint256Set.contains(_B_UINT256));
        assertEq(_uint256Set.at(1), _C_UINT256);

        assertTrue(_uint256Set.remove(_A_UINT256));
        assertEq(_uint256Set.length(), 1);
        assertFalse(_uint256Set.contains(_A_UINT256));
        assertEq(_uint256Set.at(0), _C_UINT256);

        assertFalse(_uint256Set.remove(_B_UINT256));
        assertEq(_uint256Set.length(), 1);
        assertFalse(_uint256Set.contains(_B_UINT256));
        assertEq(_uint256Set.at(0), _C_UINT256);

        assertTrue(_uint256Set.remove(_C_UINT256));
        assertEq(_uint256Set.length(), 0);
        assertFalse(_uint256Set.contains(_C_UINT256));

        // Add more elements after removing all.
        assertTrue(_uint256Set.add(_D_UINT256));
        assertEq(_uint256Set.length(), 1);
        assertTrue(_uint256Set.contains(_D_UINT256));
        assertEq(_uint256Set.at(0), _D_UINT256);
    }

    function testUint256SetOutOfBounds() public {
        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        _uint256Set.at(0);
    }



    function testUint256SetValues() public {
        _uint256Set.add(_A_UINT256);
        _uint256Set.add(_C_UINT256);
        _uint256Set.add(_B_UINT256);

        uint256[] memory values = _uint256Set.values();
        assertEq(values.length, 3);
        assertEq(values[0], _A_UINT256);
        assertEq(values[1], _C_UINT256);
        assertEq(values[2], _B_UINT256);
    }

    function testInt256Set() public {
        // Should be empty initially.
        assertEq(_int256Set.length(), 0);

        // Add one element.
        assertTrue(_int256Set.add(_A_INT256));
        assertEq(_int256Set.length(), 1);
        assertTrue(_int256Set.contains(_A_INT256));
        assertEq(_int256Set.at(0), _A_INT256);

        // Add existing element.
        assertFalse(_int256Set.add(_A_INT256));
        assertEq(_int256Set.length(), 1);
        assertTrue(_int256Set.contains(_A_INT256));
        assertEq(_int256Set.at(0), _A_INT256);

        // Add more elements.
        assertTrue(_int256Set.add(_B_INT256));
        assertEq(_int256Set.length(), 2);
        assertTrue(_int256Set.contains(_B_INT256));
        assertEq(_int256Set.at(1), _B_INT256);

        assertTrue(_int256Set.add(_C_INT256));
        assertEq(_int256Set.length(), 3);
        assertTrue(_int256Set.contains(_C_INT256));
        assertEq(_int256Set.at(2), _C_INT256);

        // Remove elements.
        assertTrue(_int256Set.remove(_B_INT256));
        assertEq(_int256Set.length(), 2);
        assertFalse(_int256Set.contains(_B_INT256));
        assertEq(_int256Set.at(1), _C_INT256);

        assertTrue(_int256Set.remove(_A_INT256));
        assertEq(_int256Set.length(), 1);
        assertFalse(_int256Set.contains(_A_INT256));
        assertEq(_int256Set.at(0), _C_INT256);

        assertFalse(_int256Set.remove(_B_INT256));
        assertEq(_int256Set.length(), 1);
        assertFalse(_int256Set.contains(_B_INT256));
        assertEq(_int256Set.at(0), _C_INT256);

        assertTrue(_int256Set.remove(_C_INT256));
        assertEq(_int256Set.length(), 0);
        assertFalse(_int256Set.contains(_C_INT256));

        // Add more elements after removing all.
        assertTrue(_int256Set.add(_D_INT256));
        assertEq(_int256Set.length(), 1);
        assertTrue(_int256Set.contains(_D_INT256));
        assertEq(_int256Set.at(0), _D_INT256);
    }

    function testInt256SetOutOfBounds() public {
        vm.expectRevert(abi.encodeWithSelector(EnumerableSetLib.IndexOutOfBounds.selector));
        _int256Set.at(0);
    }



    function testInt256SetValues() public {
        _int256Set.add(_A_INT256);
        _int256Set.add(_C_INT256);
        _int256Set.add(_B_INT256);

        int256[] memory values = _int256Set.values();
        assertEq(values.length, 3);
        assertEq(values[0], _A_INT256);
        assertEq(values[1], _C_INT256);
        assertEq(values[2], _B_INT256);
    }
}

