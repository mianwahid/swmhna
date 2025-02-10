// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address implementation = address(0x123);
    address admin = address(0x456);
    address newAdmin = address(0x789);
    address nonAdmin = address(0xabc);

    function setUp() public {
        factory = new ERC1967Factory();
    }

    // Admin Functions

    function testAdminOf() public {
        address proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);

        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);
    }

    function testChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);

        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, newAdmin);

        vm.prank(admin);
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);

        vm.prank(newAdmin);
        factory.changeAdmin(proxy, address(0));
        assertEq(factory.adminOf(proxy), address(0));

        vm.prank(address(0));
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);
    }

    function testAdminChangedEvent() public {
        address proxy = factory.deploy(implementation, admin);

        vm.prank(admin);
        vm.expectEmit(true, true, false, true);
        emit ERC1967Factory.AdminChanged(proxy, newAdmin);
        factory.changeAdmin(proxy, newAdmin);
    }

    // Upgrade Functions

    function testUpgrade() public {
        address proxy = factory.deploy(implementation, admin);

        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, address(0xdef));

        vm.prank(admin);
        factory.upgrade(proxy, address(0xdef));
    }

    function testUpgradeEvent() public {
        address proxy = factory.deploy(implementation, admin);

        vm.prank(admin);
        vm.expectEmit(true, true, false, true);
        emit ERC1967Factory.Upgraded(proxy, address(0xdef));
        factory.upgrade(proxy, address(0xdef));
    }

    function testProxyDelegateCalls() public {
        address proxy = factory.deploy(implementation, admin);

        vm.prank(admin);
        factory.upgrade(proxy, address(0xdef));

        // Add logic to verify proxy delegates calls correctly
    }

    // Deploy Functions

    function testDeploy() public {
        address proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testDeployEvent() public {
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(address(0x1), implementation, admin);
        factory.deploy(implementation, admin);
    }

    function testDeployDeterministic() public {
        bytes32 salt = keccak256(abi.encodePacked("salt"));
        address proxy = factory.deployDeterministic(implementation, admin, salt);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testDeployDeterministicEvent() public {
        bytes32 salt = keccak256(abi.encodePacked("salt"));
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(address(0x1), implementation, admin);
        factory.deployDeterministic(implementation, admin, salt);
    }

    function testDeployWithSalt() public {
        bytes32 salt = keccak256(abi.encodePacked("salt"));
        address proxy = factory.deployDeterministic(implementation, admin, salt);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testPredictDeterministicAddress() public {
        bytes32 salt = keccak256(abi.encodePacked("salt"));
        address predicted = factory.predictDeterministicAddress(salt);
        address proxy = factory.deployDeterministic(implementation, admin, salt);
        assertEq(predicted, proxy);
    }

    function testInitCodeHash() public {
        bytes32 hash = factory.initCodeHash();
        // Add logic to verify the hash matches the expected initialization code hash
    }

//    function testEmptyData() public {
//        bytes memory data = factory._emptyData();
//        assertEq(data.length, 0);
//    }

    function testCustomErrors() public {
        address proxy = factory.deploy(implementation, admin);

        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, newAdmin);

        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, address(0xdef));

        bytes32 salt = keccak256(abi.encodePacked("salt"));
        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministic(implementation, admin, salt);
    }
}