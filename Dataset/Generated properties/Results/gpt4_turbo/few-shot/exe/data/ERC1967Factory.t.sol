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

    function testDeployProxy() public {
        address proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin, "Admin should be set correctly");
        emit log_named_address("Deployed proxy at", proxy);
    }

    function testDeployAndCallProxy() public {
        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 123);
        address proxy = factory.deployAndCall(implementation, admin, data);
        assertEq(factory.adminOf(proxy), admin, "Admin should be set correctly");
        assertEq(TestImplementation(proxy).value(), 123, "Value should be initialized to 123");
        emit log_named_address("Deployed and called proxy at", proxy);
    }

//    function testDeployDeterministicProxy() public {
//        bytes32 salt = keccak256(abi.encodePacked(address(this)));
//        address proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertEq(factory.adminOf(proxy), admin, "Admin should be set correctly");
//        emit log_named_address("Deployed deterministic proxy at", proxy);
//    }

//    function testDeployDeterministicAndCallProxy() public {
//        bytes32 salt = keccak256(abi.encodePacked(address(this)));
//        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 456);
//        address proxy = factory.deployDeterministicAndCall(implementation, admin, salt, data);
//        assertEq(factory.adminOf(proxy), admin, "Admin should be set correctly");
//        assertEq(TestImplementation(proxy).value(), 456, "Value should be initialized to 456");
//        emit log_named_address("Deployed deterministic and called proxy at", proxy);
//    }

    function testChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);
        address newAdmin = address(0x1);
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin, "Admin should be updated");
    }

    function testFailUnauthorizedChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);
        vm.prank(address(0xdead));
        factory.changeAdmin(proxy, address(0x1));
    }

    function testUpgradeProxy() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        factory.upgrade(proxy, newImplementation);
        assertEq(factory.adminOf(proxy), admin, "Admin should remain unchanged");
    }

    function testFailUnauthorizedUpgrade() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        vm.prank(address(0xdead));
        factory.upgrade(proxy, newImplementation);
    }

    function testUpgradeAndCallProxy() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 789);
        factory.upgradeAndCall(proxy, newImplementation, data);
        assertEq(TestImplementation(proxy).value(), 789, "Value should be updated to 789");
    }

    function testFailUnauthorizedUpgradeAndCall() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 789);
        vm.prank(address(0xdead));
        factory.upgradeAndCall(proxy, newImplementation, data);
    }
}

contract TestImplementation {
    uint256 private _value;

    function initialize(uint256 value) public {
        _value = value;
    }

    function setValue(uint256 value) public {
        _value = value;
    }

    function value() public view returns (uint256) {
        return _value;
    }
}