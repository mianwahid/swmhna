//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/LibClone.sol";
//
//contract LibCloneTest is Test {
//    address internal constant _IMPLEMENTATION = 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
//
//    function setUp() public {
//        // Etch something onto `_IMPLEMENTATION` such that we can deploy the clone.
//        vm.etch(_IMPLEMENTATION, hex"00");
//    }
//
//    function testClone() public {
//        address instance = LibClone.clone(_IMPLEMENTATION);
//        assertTrue(instance != address(0));
//        assertEq(vm.load(instance, bytes32(0)), bytes32(uint256(uint160(_IMPLEMENTATION))));
//    }
//
//    function testCloneWithValue() public {
//        uint256 value = 1 ether;
//        vm.deal(address(this), value);
//        address instance = LibClone.clone{value: value}(_IMPLEMENTATION);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testCloneDeterministic() public {
//        bytes32 salt = keccak256("salt");
//        address instance = LibClone.cloneDeterministic(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertEq(vm.load(instance, bytes32(0)), bytes32(uint256(uint160(_IMPLEMENTATION))));
//    }
//
//    function testCloneDeterministicWithValue() public {
//        uint256 value = 1 ether;
//        bytes32 salt = keccak256("salt");
//        vm.deal(address(this), value);
//        address instance = LibClone.cloneDeterministic{value: value}(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testInitCode() public {
//        bytes memory initCode = LibClone.initCode(_IMPLEMENTATION);
//        assertTrue(initCode.length > 0);
//    }
//
//    function testInitCodeHash() public {
//        bytes32 initCodeHash = LibClone.initCodeHash(_IMPLEMENTATION);
//        assertTrue(initCodeHash != bytes32(0));
//    }
//
//    function testPredictDeterministicAddress() public {
//        bytes32 salt = keccak256("salt");
//        address deployer = address(this);
//        address predicted = LibClone.predictDeterministicAddress(_IMPLEMENTATION, salt, deployer);
//        assertTrue(predicted != address(0));
//    }
//
//    function testCloneWithImmutableArgs() public {
//        bytes memory data = abi.encode("arg1", "arg2");
//        address instance = LibClone.clone(_IMPLEMENTATION, data);
//        assertTrue(instance != address(0));
//    }
//
//    function testCloneWithImmutableArgsAndValue() public {
//        uint256 value = 1 ether;
//        bytes memory data = abi.encode("arg1", "arg2");
//        vm.deal(address(this), value);
//        address instance = LibClone.clone{value: value}(_IMPLEMENTATION, data);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testCloneDeterministicWithImmutableArgs() public {
//        bytes memory data = abi.encode("arg1", "arg2");
//        bytes32 salt = keccak256("salt");
//        address instance = LibClone.cloneDeterministic(_IMPLEMENTATION, data, salt);
//        assertTrue(instance != address(0));
//    }
//
//    function testCloneDeterministicWithImmutableArgsAndValue() public {
//        uint256 value = 1 ether;
//        bytes memory data = abi.encode("arg1", "arg2");
//        bytes32 salt = keccak256("salt");
//        vm.deal(address(this), value);
//        address instance = LibClone.cloneDeterministic{value: value}(_IMPLEMENTATION, data, salt);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testInitCodeWithImmutableArgs() public {
//        bytes memory data = abi.encode("arg1", "arg2");
//        bytes memory initCode = LibClone.initCode(_IMPLEMENTATION, data);
//        assertTrue(initCode.length > 0);
//    }
//
//    function testInitCodeHashWithImmutableArgs() public {
//        bytes memory data = abi.encode("arg1", "arg2");
//        bytes32 initCodeHash = LibClone.initCodeHash(_IMPLEMENTATION, data);
//        assertTrue(initCodeHash != bytes32(0));
//    }
//
//    function testPredictDeterministicAddressWithImmutableArgs() public {
//        bytes memory data = abi.encode("arg1", "arg2");
//        bytes32 salt = keccak256("salt");
//        address deployer = address(this);
//        address predicted = LibClone.predictDeterministicAddress(_IMPLEMENTATION, data, salt, deployer);
//        assertTrue(predicted != address(0));
//    }
//
//    function testDeployERC1967() public {
//        address instance = LibClone.deployERC1967(_IMPLEMENTATION);
//        assertTrue(instance != address(0));
//    }
//
//    function testDeployERC1967WithValue() public {
//        uint256 value = 1 ether;
//        vm.deal(address(this), value);
//        address instance = LibClone.deployERC1967{value: value}(_IMPLEMENTATION);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testDeployDeterministicERC1967() public {
//        bytes32 salt = keccak256("salt");
//        address instance = LibClone.deployDeterministicERC1967(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//    }
//
//    function testDeployDeterministicERC1967WithValue() public {
//        uint256 value = 1 ether;
//        bytes32 salt = keccak256("salt");
//        vm.deal(address(this), value);
//        address instance = LibClone.deployDeterministicERC1967{value: value}(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testCreateDeterministicERC1967() public {
//        bytes32 salt = keccak256("salt");
//        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertFalse(alreadyDeployed);
//    }
//
//    function testCreateDeterministicERC1967WithValue() public {
//        uint256 value = 1 ether;
//        bytes32 salt = keccak256("salt");
//        vm.deal(address(this), value);
//        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967{value: value}(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertFalse(alreadyDeployed);
//        assertEq(instance.balance, value);
//    }
//
//    function testInitCodeERC1967() public {
//        bytes memory initCode = LibClone.initCodeERC1967(_IMPLEMENTATION);
//        assertTrue(initCode.length > 0);
//    }
//
//    function testInitCodeHashERC1967() public {
//        bytes32 initCodeHash = LibClone.initCodeHashERC1967(_IMPLEMENTATION);
//        assertTrue(initCodeHash != bytes32(0));
//    }
//
//    function testPredictDeterministicAddressERC1967() public {
//        bytes32 salt = keccak256("salt");
//        address deployer = address(this);
//        address predicted = LibClone.predictDeterministicAddressERC1967(_IMPLEMENTATION, salt, deployer);
//        assertTrue(predicted != address(0));
//    }
//
//    function testDeployERC1967I() public {
//        address instance = LibClone.deployERC1967I(_IMPLEMENTATION);
//        assertTrue(instance != address(0));
//    }
//
//    function testDeployERC1967IWithValue() public {
//        uint256 value = 1 ether;
//        vm.deal(address(this), value);
//        address instance = LibClone.deployERC1967I{value: value}(_IMPLEMENTATION);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testDeployDeterministicERC1967I() public {
//        bytes32 salt = keccak256("salt");
//        address instance = LibClone.deployDeterministicERC1967I(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//    }
//
//    function testDeployDeterministicERC1967IWithValue() public {
//        uint256 value = 1 ether;
//        bytes32 salt = keccak256("salt");
//        vm.deal(address(this), value);
//        address instance = LibClone.deployDeterministicERC1967I{value: value}(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertEq(instance.balance, value);
//    }
//
//    function testCreateDeterministicERC1967I() public {
//        bytes32 salt = keccak256("salt");
//        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertFalse(alreadyDeployed);
//    }
//
//    function testCreateDeterministicERC1967IWithValue() public {
//        uint256 value = 1 ether;
//        bytes32 salt = keccak256("salt");
//        vm.deal(address(this), value);
//        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I{value: value}(_IMPLEMENTATION, salt);
//        assertTrue(instance != address(0));
//        assertFalse(alreadyDeployed);
//        assertEq(instance.balance, value);
//    }
//
//    function testInitCodeERC1967I() public {
//        bytes memory initCode = LibClone.initCodeERC1967I(_IMPLEMENTATION);
//        assertTrue(initCode.length > 0);
//    }
//
//    function testInitCodeHashERC1967I() public {
//        bytes32 initCodeHash = LibClone.initCodeHashERC1967I(_IMPLEMENTATION);
//        assertTrue(initCodeHash != bytes32(0));
//    }
//
//    function testPredictDeterministicAddressERC1967I() public {
//        bytes32 salt = keccak256("salt");
//        address deployer = address(this);
//        address predicted = LibClone.predictDeterministicAddressERC1967I(_IMPLEMENTATION, salt, deployer);
//        assertTrue(predicted != address(0));
//    }
//
//    function testConstantERC1967Bootstrap() public {
//        address bootstrap = LibClone.constantERC1967Bootstrap();
//        assertTrue(bootstrap != address(0));
//    }
//
//    function testConstantERC1967BootstrapAddress() public {
//        address bootstrap = LibClone.constantERC1967BootstrapAddress();
//        assertTrue(bootstrap != address(0));
//    }
//
//    function testBootstrapERC1967() public {
//        address instance = LibClone.deployERC1967(_IMPLEMENTATION);
//        LibClone.bootstrapERC1967(instance, _IMPLEMENTATION);
//        assertEq(vm.load(instance, bytes32(0)), bytes32(uint256(uint160(_IMPLEMENTATION))));
//    }
//
//    function testPredictDeterministicAddressWithHash() public {
//        bytes32 hash = keccak256("hash");
//        bytes32 salt = keccak256("salt");
//        address deployer = address(this);
//        address predicted = LibClone.predictDeterministicAddress(hash, salt, deployer);
//        assertTrue(predicted != address(0));
//    }
//
//    function testCheckStartsWith() public {
//        bytes32 salt = keccak256(abi.encodePacked(address(this)));
//        LibClone.checkStartsWith(salt, address(this));
//    }
//
//    function testCheckStartsWithReverts() public {
//        bytes32 salt = keccak256("salt");
//        vm.expectRevert(LibClone.SaltDoesNotStartWith.selector);
//        LibClone.checkStartsWith(salt, address(this));
//    }
//}