// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    address implementation;

    function setUp() public {
        implementation = address(new TestContract());
    }

    function testClone() public {
        address clone = LibClone.clone(implementation);
        assertTrue(clone != address(0));
        assertTrue(clone != implementation);
    }

    function testCloneWithValue() public {
        uint256 valueToSend = 1 ether;
        address clone = LibClone.clone(valueToSend, implementation);
        assertTrue(clone != address(0));
        assertTrue(clone != implementation);
        assertEq(address(clone).balance, valueToSend);
    }

    function testCloneDeterministic() public {
        bytes32 salt = keccak256("deterministic");
        address clone = LibClone.cloneDeterministic(implementation, salt);
        assertTrue(clone != address(0));
        assertTrue(clone != implementation);
    }

    function testCloneDeterministicWithValue() public {
        bytes32 salt = keccak256("deterministic");
        uint256 valueToSend = 1 ether;
        address clone = LibClone.cloneDeterministic(valueToSend, implementation, salt);
        assertTrue(clone != address(0));
        assertTrue(clone != implementation);
        assertEq(address(clone).balance, valueToSend);
    }

    function testPredictDeterministicAddress() public {
        bytes32 salt = keccak256("predict");
        address predicted = LibClone.predictDeterministicAddress(implementation, salt, address(this));
        address clone = LibClone.cloneDeterministic(implementation, salt);
        assertEq(predicted, clone);
    }

    function testFailCloneWithZeroImplementation() public {
        LibClone.clone(address(0));
    }

    function testFailCloneDeterministicWithZeroImplementation() public {
        bytes32 salt = keccak256("zero");
        LibClone.cloneDeterministic(address(0), salt);
    }

    function testRevertOnFailedDeployment() public {
        // Simulate a condition that causes deployment to fail (e.g., out of gas, invalid opcode, etc.)
        vm.expectRevert(LibClone.DeploymentFailed.selector);
        vm.prank(address(0xdead));
        LibClone.clone(implementation);
    }

    function testRevertOnFailedDeterministicDeployment() public {
        bytes32 salt = keccak256("fail");
        vm.expectRevert(LibClone.DeploymentFailed.selector);
        vm.prank(address(0xdead));
        LibClone.cloneDeterministic(implementation, salt);
    }

    function testInitCodeHashConsistency() public {
        bytes memory initCode = LibClone.initCode(implementation);
        bytes32 computedHash = keccak256(initCode);
        bytes32 expectedHash = LibClone.initCodeHash(implementation);
        assertEq(computedHash, expectedHash);
    }

    function testInitCodeHashConsistencyWithSalt() public {
        bytes32 salt = keccak256("salted");
        bytes memory initCode = LibClone.initCode(implementation);
        bytes32 computedHash = keccak256(abi.encodePacked(initCode, salt));
        bytes32 expectedHash = LibClone.initCodeHash(implementation);
        assertEq(computedHash, expectedHash);
    }

    function testCloneFunctionality() public {
        address clone = LibClone.clone(implementation);
        TestContract(clone).setValue(42);
        assertEq(TestContract(clone).getValue(), 42);
    }

    function testCloneDeterministicFunctionality() public {
        bytes32 salt = keccak256("functional");
        address clone = LibClone.cloneDeterministic(implementation, salt);
        TestContract(clone).setValue(42);
        assertEq(TestContract(clone).getValue(), 42);
    }
}

contract TestContract {
    uint256 private value;

    function setValue(uint256 _value) public {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}