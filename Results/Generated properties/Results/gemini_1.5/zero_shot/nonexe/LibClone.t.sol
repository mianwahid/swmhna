// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {LibClone} from "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    address implementation;

    function setUp() public {
        implementation = address(new DummyImplementation());
    }

    function testClone() public {
        address instance = LibClone.clone(implementation);
        assertEq(instance.code, implementation.code);
    }

    function testCloneDeterministic() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertEq(instance.code, implementation.code);
    }

    function testCloneWithValue() public {
        uint256 value = 1 ether;
        address instance = LibClone.clone(value, implementation);
        assertEq(instance.code, implementation.code);
        assertEq(instance.balance, value);
    }

    function testCloneDeterministicWithValue() public {
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic(value, implementation, salt);
        assertEq(instance.code, implementation.code);
        assertEq(instance.balance, value);
    }

    function testCloneWithSaltStartsWithZeroAddress() public {
        bytes32 salt = keccak256(abi.encodePacked(address(0), block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertEq(instance.code, implementation.code);
    }

    function testCloneWithSaltStartsWithBy() public {
        bytes32 salt = keccak256(abi.encodePacked(address(this), block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertEq(instance.code, implementation.code);
    }

    function testCloneWithSaltDoesNotStartWithZeroAddressOrBy() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        vm.expectRevert(LibClone.SaltDoesNotStartWith.selector);
        LibClone.checkStartsWith(salt, address(this));
    }

    function testInitCode() public {
        bytes memory initCode = LibClone.initCode(implementation);
        address instance = address(new DummyProxy(initCode));
        assertEq(instance.code, implementation.code);
    }

    function testInitCodeHash() public {
        bytes32 initCodeHash = LibClone.initCodeHash(implementation);
        bytes32 expectedHash = keccak256(LibClone.initCode(implementation));
        assertEq(initCodeHash, expectedHash);
    }

    function testPredictDeterministicAddress() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address predictedAddress = LibClone.predictDeterministicAddress(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertEq(predictedAddress, instance);
    }

    function testDeployERC1967() public {
        address instance = LibClone.deployERC1967(implementation);
        assertEq(instance.code.length, 55);
    }

    function testDeployDeterministicERC1967() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.deployDeterministicERC1967(implementation, salt);
        assertEq(instance.code.length, 55);
    }

    function testDeployERC1967WithValue() public {
        uint256 value = 1 ether;
        address instance = LibClone.deployERC1967(value, implementation);
        assertEq(instance.code.length, 55);
        assertEq(instance.balance, value);
    }

    function testDeployDeterministicERC1967WithValue() public {
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.deployDeterministicERC1967(value, implementation, salt);
        assertEq(instance.code.length, 55);
        assertEq(instance.balance, value);
    }

    function testCreateDeterministicERC1967() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(
            implementation,
            salt
        );
        assertEq(alreadyDeployed, false);
        assertEq(instance.code.length, 55);
        address instance2;
        (alreadyDeployed,instance2 ) = LibClone.createDeterministicERC1967(
            implementation,
            salt
        );
        assertEq(alreadyDeployed, true);
        assertEq(instance2, instance);
    }

    function testCreateDeterministicERC1967WithValue() public {
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(
            value,
            implementation,
            salt
        );
        assertEq(alreadyDeployed, false);
        assertEq(instance.code.length, 55);
        assertEq(instance.balance, value);
        address instance2;
        (alreadyDeployed,  instance2) = LibClone.createDeterministicERC1967(
            value,
            implementation,
            salt
        );
        assertEq(alreadyDeployed, true);
        assertEq(instance2, instance);
        assertEq(instance2.balance, 2 * value);
    }

    function testInitCodeERC1967() public {
        bytes memory initCode = LibClone.initCodeERC1967(implementation);
        address instance = address(new DummyProxy(initCode));
        assertEq(instance.code.length, 55);
    }

    function testInitCodeHashERC1967() public {
        bytes32 initCodeHash = LibClone.initCodeHashERC1967(implementation);
        bytes32 expectedHash = keccak256(LibClone.initCodeERC1967(implementation));
        assertEq(initCodeHash, expectedHash);
    }

    function testPredictDeterministicAddressERC1967() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address predictedAddress = LibClone.predictDeterministicAddressERC1967(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.deployDeterministicERC1967(implementation, salt);
        assertEq(predictedAddress, instance);
    }

    function testDeployERC1967I() public {
        address instance = LibClone.deployERC1967I(implementation);
        assertEq(instance.code.length, 116);
    }

    function testDeployDeterministicERC1967I() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.deployDeterministicERC1967I(implementation, salt);
        assertEq(instance.code.length, 116);
    }

    function testDeployERC1967IWithValue() public {
        uint256 value = 1 ether;
        address instance = LibClone.deployERC1967I(value, implementation);
        assertEq(instance.code.length, 116);
        assertEq(instance.balance, value);
    }

    function testDeployDeterministicERC1967IWithValue() public {
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.deployDeterministicERC1967I(value, implementation, salt);
        assertEq(instance.code.length, 116);
        assertEq(instance.balance, value);
    }

    function testCreateDeterministicERC1967I() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(
            implementation,
            salt
        );
        assertEq(alreadyDeployed, false);
        assertEq(instance.code.length, 116);
        address instance2;
        (alreadyDeployed,  instance2) = LibClone.createDeterministicERC1967I(
            implementation,
            salt
        );
        assertEq(alreadyDeployed, true);
        assertEq(instance2, instance);
    }

    function testCreateDeterministicERC1967IWithValue() public {
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(
            value,
            implementation,
            salt
        );
        assertEq(alreadyDeployed, false);
        assertEq(instance.code.length, 116);
        assertEq(instance.balance, value);
        address instance2;
        (alreadyDeployed,  instance2) = LibClone.createDeterministicERC1967I(
            value,
            implementation,
            salt
        );
        assertEq(alreadyDeployed, true);
        assertEq(instance2, instance);
        assertEq(instance2.balance, 2 * value);
    }

    function testInitCodeERC1967I() public {
        bytes memory initCode = LibClone.initCodeERC1967I(implementation);
        address instance = address(new DummyProxy(initCode));
        assertEq(instance.code.length, 116);
    }

    function testInitCodeHashERC1967I() public {
        bytes32 initCodeHash = LibClone.initCodeHashERC1967I(implementation);
        bytes32 expectedHash = keccak256(LibClone.initCodeERC1967I(implementation));
        assertEq(initCodeHash, expectedHash);
    }

    function testPredictDeterministicAddressERC1967I() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address predictedAddress = LibClone.predictDeterministicAddressERC1967I(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.deployDeterministicERC1967I(implementation, salt);
        assertEq(predictedAddress, instance);
    }

    function testConstantERC1967Bootstrap() public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        assertEq(bootstrap.code.length, 42);
    }

    function testConstantERC1967BootstrapAddress() public {
        address bootstrap = LibClone.constantERC1967BootstrapAddress();
        address bootstrap2 = LibClone.constantERC1967Bootstrap();
        assertEq(bootstrap, bootstrap2);
    }

    function testBootstrapERC1967() public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.deployDeterministicERC1967(bootstrap, salt);
        LibClone.bootstrapERC1967(instance, implementation);
        // Check that the implementation has been set.
        (bool success, bytes memory data) = instance.call(abi.encodeWithSignature("dummy()"));
        assertEq(success, true);
        assertEq(data, abi.encode(true));
    }

    function testClone_PUSH0() public {
        address instance = LibClone.clone_PUSH0(implementation);
        assertEq(instance.code, implementation.code);
    }

    function testCloneDeterministic_PUSH0() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic_PUSH0(implementation, salt);
        assertEq(instance.code, implementation.code);
    }

    function testCloneWithValue_PUSH0() public {
        uint256 value = 1 ether;
        address instance = LibClone.clone_PUSH0(value, implementation);
        assertEq(instance.code, implementation.code);
        assertEq(instance.balance, value);
    }

    function testCloneDeterministicWithValue_PUSH0() public {
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic_PUSH0(value, implementation, salt);
        assertEq(instance.code, implementation.code);
        assertEq(instance.balance, value);
    }

    function testInitCode_PUSH0() public {
        bytes memory initCode = LibClone.initCode_PUSH0(implementation);
        address instance = address(new DummyProxy(initCode));
        assertEq(instance.code, implementation.code);
    }

    function testInitCodeHash_PUSH0() public {
        bytes32 initCodeHash = LibClone.initCodeHash_PUSH0(implementation);
        bytes32 expectedHash = keccak256(LibClone.initCode_PUSH0(implementation));
        assertEq(initCodeHash, expectedHash);
    }

    function testPredictDeterministicAddress_PUSH0() public {
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address predictedAddress = LibClone.predictDeterministicAddress_PUSH0(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.cloneDeterministic_PUSH0(implementation, salt);
        assertEq(predictedAddress, instance);
    }

    function testCloneWithData() public {
        bytes memory data = abi.encode(uint256(123));
        address instance = LibClone.clone(implementation, data);
        assertEq(instance.code.length, 162);
    }

    function testCloneWithDataAndValue() public {
        bytes memory data = abi.encode(uint256(123));
        uint256 value = 1 ether;
        address instance = LibClone.clone(value, implementation, data);
        assertEq(instance.code.length, 162);
        assertEq(instance.balance, value);
    }

    function testCloneDeterministicWithData() public {
        bytes memory data = abi.encode(uint256(123));
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic(implementation, data, salt);
        assertEq(instance.code.length, 162);
    }

    function testCloneDeterministicWithDataAndValue() public {
        bytes memory data = abi.encode(uint256(123));
        uint256 value = 1 ether;
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address instance = LibClone.cloneDeterministic(value, implementation, data, salt);
        assertEq(instance.code.length, 162);
        assertEq(instance.balance, value);
    }

    function testInitCodeWithData() public {
        bytes memory data = abi.encode(uint256(123));
        bytes memory initCode = LibClone.initCode(implementation, data);
        address instance = address(new DummyProxy(initCode));
        assertEq(instance.code.length, 162);
    }

    function testInitCodeHashWithData() public {
        bytes memory data = abi.encode(uint256(123));
        bytes32 initCodeHash = LibClone.initCodeHash(implementation, data);
        bytes32 expectedHash = keccak256(LibClone.initCode(implementation, data));
        assertEq(initCodeHash, expectedHash);
    }

    function testPredictDeterministicAddressWithData() public {
        bytes memory data = abi.encode(uint256(123));
        bytes32 salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        address predictedAddress = LibClone.predictDeterministicAddress(
            implementation,
            data,
            salt,
            address(this)
        );
        address instance = LibClone.cloneDeterministic(implementation, data, salt);
        assertEq(predictedAddress, instance);
    }
}

contract DummyImplementation {
    function dummy() public pure returns (bool) {
        return true;
    }
}

contract DummyProxy {
    constructor(bytes memory _code) {
        assembly {
            // Copy the code into the constructor.
            let size := mload(_code)
            returndatacopy(0, 0, size)

            // Selfdestruct, which will deploy the code.
            selfdestruct(address())
        }
    }
}