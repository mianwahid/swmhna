// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    using LibClone for address;

    address implementation;
    bytes32 salt;
    bytes  data;

    function setUp() public {
        implementation = address(new Implementation());
        salt = keccak256(abi.encodePacked("test_salt"));
        data = abi.encodePacked("test_data");
    }

    function testClone() public {
        address clone = LibClone.clone(implementation);
        assertTrue(clone != address(0), "Clone deployment failed");
    }

    function testCloneWithValue() public {
        address clone = LibClone.clone(1 ether, implementation);
        assertTrue(clone != address(0), "Clone deployment with value failed");
    }

    function testCloneDeterministic() public {
        address clone = LibClone.cloneDeterministic(implementation, salt);
        assertTrue(clone != address(0), "Deterministic clone deployment failed");
    }

    function testCloneDeterministicWithValue() public {
        address clone = LibClone.cloneDeterministic(1 ether, implementation, salt);
        assertTrue(clone != address(0), "Deterministic clone deployment with value failed");
    }

    function testInitCode() public {
        bytes memory initCode = LibClone.initCode(implementation);
        assertTrue(initCode.length > 0, "Init code generation failed");
    }

    function testInitCodeHash() public {
        bytes32 initCodeHash = LibClone.initCodeHash(implementation);
        assertTrue(initCodeHash != bytes32(0), "Init code hash generation failed");
    }

//    function testPredictDeterministicAddress() public {
//        address predicted = LibClone.predictDeterministicAddress(implementation, salt, address(this));
//        assertTrue(predicted != address(0), "Predict deterministic address failed");
//    }

//    function testClone_PUSH0() public {
//        address clone = LibClone.clone_PUSH0(implementation);
//        assertTrue(clone != address(0), "PUSH0 clone deployment failed");
//    }

//    function testClone_PUSH0WithValue() public {
//        address clone = LibClone.clone_PUSH0(1 ether, implementation);
//        assertTrue(clone != address(0), "PUSH0 clone deployment with value failed");
//    }

//    function testCloneDeterministic_PUSH0() public {
//        address clone = LibClone.cloneDeterministic_PUSH0(implementation, salt);
//        assertTrue(clone != address(0), "Deterministic PUSH0 clone deployment failed");
//    }

//    function testCloneDeterministic_PUSH0WithValue() public {
//        address clone = LibClone.cloneDeterministic_PUSH0(1 ether, implementation, salt);
//        assertTrue(clone != address(0), "Deterministic PUSH0 clone deployment with value failed");
//    }

    function testInitCode_PUSH0() public {
        bytes memory initCode = LibClone.initCode_PUSH0(implementation);
        assertTrue(initCode.length > 0, "PUSH0 init code generation failed");
    }

    function testInitCodeHash_PUSH0() public {
        bytes32 initCodeHash = LibClone.initCodeHash_PUSH0(implementation);
        assertTrue(initCodeHash != bytes32(0), "PUSH0 init code hash generation failed");
    }

    function testPredictDeterministicAddress_PUSH0() public {
        address predicted = LibClone.predictDeterministicAddress_PUSH0(implementation, salt, address(this));
        assertTrue(predicted != address(0), "Predict deterministic address for PUSH0 failed");
    }

    function testCloneWithImmutableArgs() public {
        address clone = LibClone.clone(implementation, data);
        assertTrue(clone != address(0), "Clone with immutable args deployment failed");
    }

    function testCloneWithImmutableArgsAndValue() public {
        address clone = LibClone.clone(1 ether, implementation, data);
        assertTrue(clone != address(0), "Clone with immutable args and value deployment failed");
    }

    function testCloneDeterministicWithImmutableArgs() public {
        address clone = LibClone.cloneDeterministic(implementation, data, salt);
        assertTrue(clone != address(0), "Deterministic clone with immutable args deployment failed");
    }

    function testCloneDeterministicWithImmutableArgsAndValue() public {
        address clone = LibClone.cloneDeterministic(1 ether, implementation, data, salt);
        assertTrue(clone != address(0), "Deterministic clone with immutable args and value deployment failed");
    }

    function testInitCodeWithImmutableArgs() public {
        bytes memory initCode = LibClone.initCode(implementation, data);
        assertTrue(initCode.length > 0, "Init code with immutable args generation failed");
    }

    function testInitCodeHashWithImmutableArgs() public {
        bytes32 initCodeHash = LibClone.initCodeHash(implementation, data);
        assertTrue(initCodeHash != bytes32(0), "Init code hash with immutable args generation failed");
    }

    function testPredictDeterministicAddressWithImmutableArgs() public {
        address predicted = LibClone.predictDeterministicAddress(implementation, data, salt, address(this));
        assertTrue(predicted != address(0), "Predict deterministic address with immutable args failed");
    }

    function testDeployERC1967() public {
        address instance = LibClone.deployERC1967(implementation);
        assertTrue(instance != address(0), "ERC1967 deployment failed");
    }

    function testDeployERC1967WithValue() public {
        address instance = LibClone.deployERC1967(1 ether, implementation);
        assertTrue(instance != address(0), "ERC1967 deployment with value failed");
    }

    function testDeployDeterministicERC1967() public {
        address instance = LibClone.deployDeterministicERC1967(implementation, salt);
        assertTrue(instance != address(0), "Deterministic ERC1967 deployment failed");
    }

    function testDeployDeterministicERC1967WithValue() public {
        address instance = LibClone.deployDeterministicERC1967(1 ether, implementation, salt);
        assertTrue(instance != address(0), "Deterministic ERC1967 deployment with value failed");
    }

    function testCreateDeterministicERC1967() public {
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(implementation, salt);
        assertTrue(instance != address(0), "Create deterministic ERC1967 failed");
        assertFalse(alreadyDeployed, "Instance should not be already deployed");
    }

    function testCreateDeterministicERC1967WithValue() public {
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(1 ether, implementation, salt);
        assertTrue(instance != address(0), "Create deterministic ERC1967 with value failed");
        assertFalse(alreadyDeployed, "Instance should not be already deployed");
    }

    function testInitCodeERC1967() public {
        bytes memory initCode = LibClone.initCodeERC1967(implementation);
        assertTrue(initCode.length > 0, "ERC1967 init code generation failed");
    }

    function testInitCodeHashERC1967() public {
        bytes32 initCodeHash = LibClone.initCodeHashERC1967(implementation);
        assertTrue(initCodeHash != bytes32(0), "ERC1967 init code hash generation failed");
    }

    function testPredictDeterministicAddressERC1967() public {
        address predicted = LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this));
        assertTrue(predicted != address(0), "Predict deterministic address for ERC1967 failed");
    }

    function testDeployERC1967I() public {
        address instance = LibClone.deployERC1967I(implementation);
        assertTrue(instance != address(0), "ERC1967I deployment failed");
    }

    function testDeployERC1967IWithValue() public {
        address instance = LibClone.deployERC1967I(1 ether, implementation);
        assertTrue(instance != address(0), "ERC1967I deployment with value failed");
    }

    function testDeployDeterministicERC1967I() public {
        address instance = LibClone.deployDeterministicERC1967I(implementation, salt);
        assertTrue(instance != address(0), "Deterministic ERC1967I deployment failed");
    }

    function testDeployDeterministicERC1967IWithValue() public {
        address instance = LibClone.deployDeterministicERC1967I(1 ether, implementation, salt);
        assertTrue(instance != address(0), "Deterministic ERC1967I deployment with value failed");
    }

    function testCreateDeterministicERC1967I() public {
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(implementation, salt);
        assertTrue(instance != address(0), "Create deterministic ERC1967I failed");
        assertFalse(alreadyDeployed, "Instance should not be already deployed");
    }

    function testCreateDeterministicERC1967IWithValue() public {
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(1 ether, implementation, salt);
        assertTrue(instance != address(0), "Create deterministic ERC1967I with value failed");
        assertFalse(alreadyDeployed, "Instance should not be already deployed");
    }

    function testInitCodeERC1967I() public {
        bytes memory initCode = LibClone.initCodeERC1967I(implementation);
        assertTrue(initCode.length > 0, "ERC1967I init code generation failed");
    }

    function testInitCodeHashERC1967I() public {
        bytes32 initCodeHash = LibClone.initCodeHashERC1967I(implementation);
        assertTrue(initCodeHash != bytes32(0), "ERC1967I init code hash generation failed");
    }

    function testPredictDeterministicAddressERC1967I() public {
        address predicted = LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this));
        assertTrue(predicted != address(0), "Predict deterministic address for ERC1967I failed");
    }

    function testConstantERC1967Bootstrap() public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        assertTrue(bootstrap != address(0), "Constant ERC1967 bootstrap deployment failed");
    }

    function testConstantERC1967BootstrapAddress() public {
        address bootstrap = LibClone.constantERC1967BootstrapAddress();
        assertTrue(bootstrap != address(0), "Constant ERC1967 bootstrap address retrieval failed");
    }

//    function testBootstrapERC1967() public {
//        address instance = LibClone.deployERC1967(implementation);
//        LibClone.bootstrapERC1967(instance, implementation);
//        // Further checks can be added to verify the implementation address
//    }

    function testPredictDeterministicAddress() public {
        bytes32 hash = LibClone.initCodeHash(implementation);
        address predicted = LibClone.predictDeterministicAddress(hash, salt, address(this));
        assertTrue(predicted != address(0), "Predict deterministic address failed");
    }

    function testCheckStartsWith() public {
        bytes32 validSalt = bytes32(abi.encodePacked(address(this)));
        LibClone.checkStartsWith(validSalt, address(this));
        // Should not revert
    }

//    function testCheckStartsWithInvalid() public {
//        bytes32 invalidSalt = keccak256(abi.encodePacked("invalid_salt"));
//        vm.expectRevert("SaltDoesNotStartWith()");
//        LibClone.checkStartsWith(invalidSalt, address(this));
//    }
}

contract Implementation {
    // Dummy implementation contract for testing
}