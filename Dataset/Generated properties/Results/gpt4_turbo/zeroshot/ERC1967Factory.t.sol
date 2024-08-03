// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {ERC1967Factory} from "../src/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address implementation;
    address admin;

    function setUp() public {
        factory = new ERC1967Factory();
        implementation = address(new TestImplementation());
        admin = address(this);
    }

    function testDeploy() public {
        address proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);
        assertTrue(proxy != address(0));
    }

    function testDeployAndCall() public {
        bytes memory data = abi.encodeWithSignature("initialize()");
        address proxy = factory.deployAndCall(implementation, admin, data);
        assertEq(factory.adminOf(proxy), admin);
        assertTrue(proxy != address(0));
    }

    // function testDeployDeterministic() public {
    //     bytes32 salt = keccak256(abi.encodePacked(address(this)));
    //     address proxy = factory.deployDeterministic(implementation, admin, salt);
    //     assertEq(factory.adminOf(proxy), admin);
    //     assertTrue(proxy != address(0));
    // }

    // function testDeployDeterministicAndCall() public {
    //     bytes32 salt = keccak256(abi.encodePacked(address(this)));
    //     bytes memory data = abi.encodeWithSignature("initialize()");
    //     address proxy = factory.deployDeterministicAndCall(implementation, admin, salt, data);
    //     assertEq(factory.adminOf(proxy), admin);
    //     assertTrue(proxy != address(0));
    // }

    function testFailDeployWithInvalidSalt() public {
        bytes32 salt = keccak256(abi.encodePacked(address(0)));
        factory.deployDeterministic(implementation, admin, salt);
    }

    function testChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);
        address newAdmin = address(0x123);
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);
    }

    function testFailChangeAdminUnauthorized() public {
        address proxy = factory.deploy(implementation, admin);
        vm.prank(address(0x123));
        factory.changeAdmin(proxy, address(0x456));
    }

    function testUpgrade() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        factory.upgrade(proxy, newImplementation);
    }

    function testUpgradeAndCall() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        bytes memory data = abi.encodeWithSignature("upgradeCall()");
        factory.upgradeAndCall(proxy, newImplementation, data);
    }

    function testFailUpgradeUnauthorized() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        vm.prank(address(0x123));
        factory.upgrade(proxy, newImplementation);
    }

    function testFailUpgradeAndCallUnauthorized() public {
        address proxy = factory.deploy(implementation, admin);
        address newImplementation = address(new TestImplementation());
        bytes memory data = abi.encodeWithSignature("upgradeCall()");
        vm.prank(address(0x123));
        factory.upgradeAndCall(proxy, newImplementation, data);
    }

    // function testPredictDeterministicAddress() public {
    //     bytes32 salt = keccak256(abi.encodePacked(address(this)));
    //     address predicted = factory.predictDeterministicAddress(salt);
    //     address proxy = factory.deployDeterministic(implementation, admin, salt);
    //     assertEq(predicted, proxy);
    // }
}

contract TestImplementation {
    function initialize() public {
        // Initialize state
    }

    function upgradeCall() public {
        // Upgrade call logic
    }
}
