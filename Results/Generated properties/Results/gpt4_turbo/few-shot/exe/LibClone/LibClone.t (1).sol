// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    address constant implementation = address(0x1234567890123456789012345678901234567890);
    bytes32 constant salt = keccak256("test_salt");
    uint256 constant value = 1 ether;

    function setUp() public {
        vm.deal(address(this), 10 ether);
    }

    function testClone() public {
        address cloneAddress = LibClone.clone(implementation);
        assertEq(cloneAddress.code.length, implementation.code.length, "Cloned code should match implementation code length");
    }

    function testCloneWithValue() public {
        address cloneAddress = LibClone.clone(value, implementation);
        assertEq(cloneAddress.balance, value, "Cloned contract should have correct balance");
        assertEq(cloneAddress.code.length, implementation.code.length, "Cloned code should match implementation code length");
    }

    function testCloneDeterministic() public {
        address cloneAddress = LibClone.cloneDeterministic(implementation, salt);
        assertEq(cloneAddress.code.length, implementation.code.length, "Cloned code should match implementation code length");
    }

    function testCloneDeterministicWithValue() public {
        address cloneAddress = LibClone.cloneDeterministic(value, implementation, salt);
        assertEq(cloneAddress.balance, value, "Cloned contract should have correct balance");
        assertEq(cloneAddress.code.length, implementation.code.length, "Cloned code should match implementation code length");
    }

    function testPredictDeterministicAddress() public {
        address predictedAddress = LibClone.predictDeterministicAddress(implementation, salt, address(this));
        address cloneAddress = LibClone.cloneDeterministic(implementation, salt);
        assertEq(predictedAddress, cloneAddress, "Predicted address should match the actual cloned address");
    }

    function testFailCloneWithZeroImplementation() public {
        LibClone.clone(address(0));
    }

    function testFailCloneDeterministicWithZeroImplementation() public {
        LibClone.cloneDeterministic(address(0), salt);
    }

    function testInitCode() public {
        bytes memory initCode = LibClone.initCode(implementation);
        assertEq(initCode.length > 0, true, "Init code should not be empty");
    }

    function testInitCodeHash() public {
        bytes32 initCodeHash = LibClone.initCodeHash(implementation);
        assertEq(uint256(initCodeHash) != 0, true, "Init code hash should not be zero");
    }

    function testCheckStartsWithValidSalt() public {
        bytes32 validSalt = bytes32(uint256(uint160(address(this))) << 96);
        LibClone.checkStartsWith(validSalt, address(this));
    }

    function testFailCheckStartsWithInvalidSalt() public {
        bytes32 invalidSalt = bytes32(uint256(uint160(address(0xBEEF))) << 96);
        LibClone.checkStartsWith(invalidSalt, address(this));
    }
}