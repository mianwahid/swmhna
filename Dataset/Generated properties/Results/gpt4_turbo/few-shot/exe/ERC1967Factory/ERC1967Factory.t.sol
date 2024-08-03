// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address implementation;
    address admin;

    function setUp() public {
        factory = new ERC1967Factory();
        implementation = address(new TestImplementation());
        admin = address(this);
    }

//    function testDeploy() public {
//        address proxy = factory.deploy(implementation, admin);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(factory.implementationOf(proxy), implementation);
//        emit log_named_address("Deployed proxy at", proxy);
//    }

//    function testDeployAndCall() public {
//        bytes memory data = abi.encodeWithSignature("initialize()");
//        address proxy = factory.deployAndCall(implementation, admin, data);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(factory.implementationOf(proxy), implementation);
//        emit log_named_address("Deployed and initialized proxy at", proxy);
//    }

//    function testDeployDeterministic() public {
//        bytes32 salt = keccak256(abi.encodePacked(address(this)));
//        address proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertEq(factory.adminOf(proxy), admin);
//        assertEq(factory.implementationOf(proxy), implementation);
//        emit log_named_address("Deployed deterministic proxy at", proxy);
//    }

//    function testDeployDeterministicAndCall() public {
//        bytes32 salt = keccak256(abi.encodePacked(address(this)));
//        bytes memory data = abi.encodeWithSignature("initialize()");
//        address proxy = factory.deployDeterministicAndCall(implementation, admin, salt, data);
//        assertEq(factory.adminOf(proxy), admin);
////        assertEq(factory.implementationOf(proxy), implementation);
////        emit log_named_address("Deployed and initialized deterministic proxy at", proxy);
//    }

    function testChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);
        address newAdmin = address(0x123);
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);
    }

//    function testUpgrade() public {
//        address proxy = factory.deploy(implementation, admin);
//        address newImplementation = address(new TestImplementation());
//        factory.upgrade(proxy, newImplementation);
//        assertEq(factory.implementationOf(proxy), newImplementation);
//    }

//    function testUpgradeAndCall() public {
//        address proxy = factory.deploy(implementation, admin);
//        address newImplementation = address(new TestImplementation());
//        bytes memory data = abi.encodeWithSignature("upgradeState()");
//        factory.upgradeAndCall(proxy, newImplementation, data);
//        assertEq(factory.implementationOf(proxy), newImplementation);
//    }

    function testUnauthorizedChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);
        address newAdmin = address(0x123);
        vm.prank(address(0x456));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, newAdmin);
    }

    function testUnauthorizedUpgrade() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        vm.prank(address(0x456));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, newImplementation);
    }

    function testFailedDeployment() public {
        vm.expectRevert(ERC1967Factory.DeploymentFailed.selector);
        address proxy = factory.deploy(address(0), admin);
    }

    function testFailedUpgrade() public {
        address proxy = factory.deploy(implementation, admin);
        vm.expectRevert(ERC1967Factory.UpgradeFailed.selector);
        factory.upgrade(proxy, address(0));
    }

//    function testPredictDeterministicAddress() public {
//        bytes32 salt = keccak256(abi.encodePacked(address(this)));
//        address predicted = factory.predictDeterministicAddress(salt);
//        address proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertEq(predicted, proxy);
//    }

//    function testInitCodeHash() public {
//        bytes32 hash = factory.initCodeHash();
//        assert(hash != bytes32(0), "Init code hash should not be zero");
//    }
}

contract TestImplementation {
    uint256 public value;

    function initialize() public {
        value = 1;
    }

    function upgradeState() public {
        value = 2;
    }
}