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
        // Setup if needed
    }

    // // Test for Minimal Proxy Operations
    // function testClone() public {
    //     address cloneAddr = LibClone.clone(implementation);
    //     assertEq(address(this).balance, 0);
    //     // assertTrue(isContract(cloneAddr));
    // }

    function testCloneWithValue() public {
        address cloneAddr = LibClone.clone(value, implementation);
        assertEq(cloneAddr.balance, value);
        // assertTrue(isContract(cloneAddr));
    }

    function testCloneDeterministic() public {
        address predicted = LibClone.predictDeterministicAddress(
            implementation,
            salt,
            address(this)
        );
        address cloneAddr = LibClone.cloneDeterministic(implementation, salt);
        assertEq(cloneAddr, predicted);
        // assertTrue(isContract(cloneAddr));
    }

    function testCloneDeterministicWithValue() public {
        address predicted = LibClone.predictDeterministicAddress(
            implementation,
            salt,
            address(this)
        );
        address cloneAddr = LibClone.cloneDeterministic(
            value,
            implementation,
            salt
        );
        assertEq(cloneAddr, predicted);
        assertEq(cloneAddr.balance, value);
        // assertTrue(isContract(cloneAddr));
    }

    // // Test for Minimal Proxy Operations (PUSH0 Variant)
    // function testClone_PUSH0() public {
    //     address cloneAddr = LibClone.clone_PUSH0(implementation);
    //     // assertTrue(isContract(cloneAddr));
    // }

    // function testClone_PUSH0WithValue() public {
    //     address cloneAddr = LibClone.clone_PUSH0(value, implementation);
    //     assertEq(cloneAddr.balance, value);
    //     // assertTrue(isContract(cloneAddr));
    // }

    // Test for Clones with Immutable Args Operations (CWIA)
    function testCloneWithImmutableArgs() public {
        bytes memory data = abi.encodePacked(uint256(42));
        address cloneAddr = LibClone.clone(implementation, data);
        // assertTrue(isContract(cloneAddr));
    }

    function testCloneWithImmutableArgsDeterministic() public {
        bytes memory data = abi.encodePacked(uint256(42));
        address predicted = LibClone.predictDeterministicAddress(
            implementation,
            data,
            salt,
            address(this)
        );
        address cloneAddr = LibClone.cloneDeterministic(
            implementation,
            data,
            salt
        );
        assertEq(cloneAddr, predicted);
        // assertTrue(isContract(cloneAddr));
    }

    // Test for Minimal ERC1967 Proxy Operations
    function testDeployERC1967() public {
        address proxyAddr = LibClone.deployERC1967(implementation);
        // assertTrue(isContract(proxyAddr));
    }

    function testDeployDeterministicERC1967() public {
        address predicted = LibClone.predictDeterministicAddressERC1967(
            implementation,
            salt,
            address(this)
        );
        address proxyAddr = LibClone.deployDeterministicERC1967(
            implementation,
            salt
        );
        assertEq(proxyAddr, predicted);
        // assertTrue(isContract(proxyAddr));
    }

    // Test for ERC1967I Proxy Operations
    function testDeployERC1967I() public {
        address proxyAddr = LibClone.deployERC1967I(implementation);
        // assertTrue(isContract(proxyAddr));
    }

    function testDeployDeterministicERC1967I() public {
        address predicted = LibClone.predictDeterministicAddressERC1967I(
            implementation,
            salt,
            address(this)
        );
        address proxyAddr = LibClone.deployDeterministicERC1967I(
            implementation,
            salt
        );
        assertEq(proxyAddr, predicted);
        // assertTrue(isContract(proxyAddr));
    }

    // Test for Constant ERC1967 Bootstrap Operations
    function testConstantERC1967Bootstrap() public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        // assertTrue(isContract(bootstrap));
        address bootstrapAgain = LibClone.constantERC1967Bootstrap();
        assertEq(bootstrap, bootstrapAgain);
    }

    // Test for Other Operations
    function testPredictDeterministicAddress() public {
        bytes32 hash = keccak256("test");
        address predicted = LibClone.predictDeterministicAddress(
            hash,
            salt,
            address(this)
        );
        assertTrue(predicted != address(0));
    }

    // function testCheckStartsWith() public {
    //     LibClone.checkStartsWith(bytes32(uint256(uint160(address(this)))), address(this));
    // }

    // function testFailCheckStartsWith() public {
    //     bytes32 wrongSalt = bytes32(uint256(uint160(address(0x1))));
    //     LibClone.checkStartsWith(wrongSalt, address(this));
    // }
}
