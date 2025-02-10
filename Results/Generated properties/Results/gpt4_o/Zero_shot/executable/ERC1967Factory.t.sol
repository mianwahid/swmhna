// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address implementation;
    address admin;
    address proxy;
    bytes32 salt;

    function setUp() public {
        factory = new ERC1967Factory();
        implementation = address(0x1234567890123456789012345678901234567890);
        admin = address(this);
        salt = keccak256(abi.encodePacked("test_salt"));
    }

    function testDeploy() public {
        proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testDeployAndCall() public {
        bytes memory data = abi.encodeWithSignature("initialize()");
        proxy = factory.deployAndCall(implementation, admin, data);
        assertEq(factory.adminOf(proxy), admin);
    }

//    function testDeployDeterministic() public {
//        proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertEq(factory.adminOf(proxy), admin);
//    }

//    function testDeployDeterministicAndCall() public {
//        bytes memory data = abi.encodeWithSignature("initialize()");
//        proxy = factory.deployDeterministicAndCall(implementation, admin, salt, data);
//        assertEq(factory.adminOf(proxy), admin);
//    }

    function testChangeAdmin() public {
        proxy = factory.deploy(implementation, admin);
        address newAdmin = address(0x9876543210987654321098765432109876543210);
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);
    }

    function testUpgrade() public {
        proxy = factory.deploy(implementation, admin);
        address newImplementation = address(0xa);
        factory.upgrade(proxy, newImplementation);
    }

    function testUpgradeAndCall() public {
        proxy = factory.deploy(implementation, admin);
        address newImplementation = address(0xa);
        bytes memory data = abi.encodeWithSignature("initialize()");
        factory.upgradeAndCall(proxy, newImplementation, data);
    }

//    function testPredictDeterministicAddress() public {
//        address predicted = factory.predictDeterministicAddress(salt);
//        proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertEq(predicted, proxy);
//    }

    function testUnauthorizedChangeAdmin() public {
        proxy = factory.deploy(implementation, admin);
        address newAdmin = address(0x9876543210987654321098765432109876543210);
        vm.prank(address(0xdeadbeef));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, newAdmin);
    }

    function testUnauthorizedUpgrade() public {
        proxy = factory.deploy(implementation, admin);
        address newImplementation = address(0xa);
        vm.prank(address(0xdeadbeef));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, newImplementation);
    }

    function testUnauthorizedUpgradeAndCall() public {
        proxy = factory.deploy(implementation, admin);
        address newImplementation = address(0xa);
        bytes memory data = abi.encodeWithSignature("initialize()");
        vm.prank(address(0xdeadbeef));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgradeAndCall(proxy, newImplementation, data);
    }

    function testSaltDoesNotStartWithCaller() public {
        bytes32 invalidSalt = keccak256(abi.encodePacked(address(0xdeadbeef), "invalid_salt"));
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministic(implementation, admin, invalidSalt);
    }

//    function testDeploymentFailed() public {
//        address invalidImplementation = address(0);
//        vm.expectRevert(ERC1967Factory.DeploymentFailed.selector);
//        factory.deploy(invalidImplementation, admin);
//    }

//    function testUpgradeFailed() public {
//        proxy = factory.deploy(implementation, admin);
//        address invalidImplementation = address(0);
//        vm.expectRevert(ERC1967Factory.UpgradeFailed.selector);
//        factory.upgrade(proxy, invalidImplementation);
//    }
}