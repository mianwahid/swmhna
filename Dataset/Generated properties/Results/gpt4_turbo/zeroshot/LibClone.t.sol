// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {LibClone} from "../src/LibClone.sol";

contract LibCloneTest is Test {
    address constant implementation =
        address(0x1234567890123456789012345678901234567890);
    bytes32 constant salt = keccak256("test_salt");
    uint256 constant value = 1 ether;

    function setUp() public {
        // Setup code if needed
    }

    function testClone() public {
        address cloneAddress = LibClone.clone(implementation);
        assertTrue(cloneAddress != address(0), "Clone failed to deploy");
    }

    function testCloneWithValue() public {
        address cloneAddress = LibClone.clone(value, implementation);
        assertTrue(
            cloneAddress != address(0),
            "Clone with value failed to deploy"
        );
    }

    function testCloneDeterministic() public {
        address cloneAddress = LibClone.cloneDeterministic(
            implementation,
            salt
        );
        assertTrue(
            cloneAddress != address(0),
            "Deterministic clone failed to deploy"
        );
    }

    function testCloneDeterministicWithValue() public {
        address cloneAddress = LibClone.cloneDeterministic(
            value,
            implementation,
            salt
        );
        assertTrue(
            cloneAddress != address(0),
            "Deterministic clone with value failed to deploy"
        );
    }

    // function testClone_PUSH0() public {
    //     address cloneAddress = LibClone.clone_PUSH0(implementation);
    //     assertTrue(cloneAddress != address(0), "PUSH0 clone failed to deploy");
    // }

    // function testClone_PUSH0WithValue() public {
    //     address cloneAddress = LibClone.clone_PUSH0(value, implementation);
    //     assertTrue(cloneAddress != address(0), "PUSH0 clone with value failed to deploy");
    // }

    // function testCloneDeterministic_PUSH0() public {
    //     address cloneAddress = LibClone.cloneDeterministic_PUSH0(implementation, salt);
    //     assertTrue(cloneAddress != address(0), "Deterministic PUSH0 clone failed to deploy");
    // }

    // function testCloneDeterministic_PUSH0WithValue() public {
    //     address cloneAddress = LibClone.cloneDeterministic_PUSH0(value, implementation, salt);
    //     assertTrue(cloneAddress != address(0), "Deterministic PUSH0 clone with value failed to deploy");
    // }

    function testDeployERC1967() public {
        address proxyAddress = LibClone.deployERC1967(implementation);
        assertTrue(
            proxyAddress != address(0),
            "ERC1967 proxy failed to deploy"
        );
    }

    function testDeployERC1967WithValue() public {
        address proxyAddress = LibClone.deployERC1967(value, implementation);
        assertTrue(
            proxyAddress != address(0),
            "ERC1967 proxy with value failed to deploy"
        );
    }

    function testDeployDeterministicERC1967() public {
        address proxyAddress = LibClone.deployDeterministicERC1967(
            implementation,
            salt
        );
        assertTrue(
            proxyAddress != address(0),
            "Deterministic ERC1967 proxy failed to deploy"
        );
    }

    function testDeployDeterministicERC1967WithValue() public {
        address proxyAddress = LibClone.deployDeterministicERC1967(
            value,
            implementation,
            salt
        );
        assertTrue(
            proxyAddress != address(0),
            "Deterministic ERC1967 proxy with value failed to deploy"
        );
    }

    function testDeployERC1967I() public {
        address proxyAddress = LibClone.deployERC1967I(implementation);
        assertTrue(
            proxyAddress != address(0),
            "ERC1967I proxy failed to deploy"
        );
    }

    function testDeployERC1967IWithValue() public {
        address proxyAddress = LibClone.deployERC1967I(value, implementation);
        assertTrue(
            proxyAddress != address(0),
            "ERC1967I proxy with value failed to deploy"
        );
    }

    function testDeployDeterministicERC1967I() public {
        address proxyAddress = LibClone.deployDeterministicERC1967I(
            implementation,
            salt
        );
        assertTrue(
            proxyAddress != address(0),
            "Deterministic ERC1967I proxy failed to deploy"
        );
    }

    function testDeployDeterministicERC1967IWithValue() public {
        address proxyAddress = LibClone.deployDeterministicERC1967I(
            value,
            implementation,
            salt
        );
        assertTrue(
            proxyAddress != address(0),
            "Deterministic ERC1967I proxy with value failed to deploy"
        );
    }

    function testFailOnInvalidSalt() public {
        bytes32 invalidSalt = keccak256("invalid_salt");
        vm.expectRevert(LibClone.SaltDoesNotStartWith.selector);
        LibClone.cloneDeterministic(implementation, invalidSalt);
    }

    function testFailOnDeploymentFailure() public {
        address zeroImplementation = address(0);
        vm.expectRevert(LibClone.DeploymentFailed.selector);
        LibClone.clone(zeroImplementation);
    }
}
