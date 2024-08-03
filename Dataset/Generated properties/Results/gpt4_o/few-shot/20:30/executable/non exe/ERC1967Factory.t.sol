//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import {ERC1967Factory} from "../src/utils/ERC1967Factory.sol";
//import {MockImplementation} from "./utils/mocks/MockImplementation.sol";
//
//contract ERC1967FactoryTest is Test {
//    ERC1967Factory factory;
//    MockImplementation implementation;
//
//    event AdminChanged(address indexed proxy, address indexed admin);
//    event Upgraded(address indexed proxy, address indexed implementation);
//    event Deployed(address indexed proxy, address indexed implementation, address indexed admin);
//
//    function setUp() public {
//        factory = new ERC1967Factory();
//        implementation = new MockImplementation();
//    }
//
//    function testDeploy() public {
//        address admin = address(this);
//        address proxy = factory.deploy(address(implementation), admin);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(vm.load(proxy, factory._IMPLEMENTATION_SLOT()), bytes32(uint256(uint160(address(implementation)))));
//    }
//
//    function testDeployAndCall() public {
//        address admin = address(this);
//        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 42);
//        address proxy = factory.deployAndCall(address(implementation), admin, data);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(vm.load(proxy, factory._IMPLEMENTATION_SLOT()), bytes32(uint256(uint160(address(implementation)))));
//        assertEq(MockImplementation(proxy).value(), 42);
//    }
//
//    function testDeployDeterministic() public {
//        address admin = address(this);
//        bytes32 salt = keccak256(abi.encodePacked("test"));
//        address proxy = factory.deployDeterministic(address(implementation), admin, salt);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(vm.load(proxy, factory._IMPLEMENTATION_SLOT()), bytes32(uint256(uint160(address(implementation)))));
//    }
//
//    function testDeployDeterministicAndCall() public {
//        address admin = address(this);
//        bytes32 salt = keccak256(abi.encodePacked("test"));
//        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 42);
//        address proxy = factory.deployDeterministicAndCall(address(implementation), admin, salt, data);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(vm.load(proxy, factory._IMPLEMENTATION_SLOT()), bytes32(uint256(uint160(address(implementation)))));
//        assertEq(MockImplementation(proxy).value(), 42);
//    }
//
//    function testUpgrade() public {
//        address admin = address(this);
//        address proxy = factory.deploy(address(implementation), admin);
//        MockImplementation newImplementation = new MockImplementation();
//        factory.upgrade(proxy, address(newImplementation));
//        assertEq(vm.load(proxy, factory._IMPLEMENTATION_SLOT()), bytes32(uint256(uint160(address(newImplementation)))));
//    }
//
//    function testUpgradeAndCall() public {
//        address admin = address(this);
//        address proxy = factory.deploy(address(implementation), admin);
//        MockImplementation newImplementation = new MockImplementation();
//        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 42);
//        factory.upgradeAndCall(proxy, address(newImplementation), data);
//        assertEq(vm.load(proxy, factory._IMPLEMENTATION_SLOT()), bytes32(uint256(uint160(address(newImplementation)))));
//        assertEq(MockImplementation(proxy).value(), 42);
//    }
//
//    function testChangeAdmin() public {
//        address admin = address(this);
//        address proxy = factory.deploy(address(implementation), admin);
//        address newAdmin = address(0xBEEF);
//        factory.changeAdmin(proxy, newAdmin);
//        assertEq(factory.adminOf(proxy), newAdmin);
//    }
//
//    function testPredictDeterministicAddress() public {
//        bytes32 salt = keccak256(abi.encodePacked("test"));
//        address predicted = factory.predictDeterministicAddress(salt);
//        address proxy = factory.deployDeterministic(address(implementation), address(this), salt);
//        assertEq(predicted, proxy);
//    }
//
//    function testInitCodeHash() public {
//        bytes32 initCodeHash = factory.initCodeHash();
//        assertEq(initCodeHash, keccak256(abi.encodePacked(factory._initCode())));
//    }
//}