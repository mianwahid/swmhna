// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {LibClone} from "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    address implementation;
    bytes32 salt = keccak256("example_salt");
    uint256 value = 1 ether;

    function setUp() public {
        implementation = address(new TestContract());
    }

    function testClone() public {
        address clone = LibClone.clone(implementation);
        assertTrue(clone != address(0));
        assertTrue(isContract(clone));
    }

    function testCloneWithValue() public {
        address clone = LibClone.clone(value, implementation);
        assertTrue(clone != address(0));
        assertTrue(isContract(clone));
        assertEq(address(clone).balance, value);
    }

    function testCloneDeterministic() public {
        address clone = LibClone.cloneDeterministic(implementation, salt);
        assertTrue(clone != address(0));
        assertTrue(isContract(clone));
    }

    function testCloneDeterministicWithValue() public {
        address clone = LibClone.cloneDeterministic(value, implementation, salt);
        assertTrue(clone != address(0));
        assertTrue(isContract(clone));
        assertEq(address(clone).balance, value);
    }

    function testPredictDeterministicAddress() public {
        address predicted = LibClone.predictDeterministicAddress(implementation, salt, address(this));
        address clone = LibClone.cloneDeterministic(implementation, salt);
        assertEq(predicted, clone);
    }

    function testInitCode() public {
        bytes memory code = LibClone.initCode(implementation);
        assertTrue(code.length > 0);
    }

    function testInitCodeHash() public {
        bytes32 hash = LibClone.initCodeHash(implementation);
        assertTrue(uint256(hash) != 0);
    }

    function testFailCloneWithZeroImplementation() public {
        LibClone.clone(address(0));
    }

    function testFailCloneDeterministicWithZeroImplementation() public {
        LibClone.cloneDeterministic(address(0), salt);
    }

    function testFailCloneDeterministicWithValueAndZeroImplementation() public {
        LibClone.cloneDeterministic(value, address(0), salt);
    }

    function testFailPredictDeterministicAddressWithZeroImplementation() public {
        LibClone.predictDeterministicAddress(address(0), salt, address(this));
    }

    function testFailInitCodeWithZeroImplementation() public {
        LibClone.initCode(address(0));
    }

    function testFailInitCodeHashWithZeroImplementation() public {
        LibClone.initCodeHash(address(0));
    }

    function isContract(address _addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}

contract TestContract {
    uint256 public data;

    function setData(uint256 _data) external {
        data = _data;
    }
}