// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;

    address alice = address(0x1337);
    address bob = address(0x1338);

    receive() external payable {}

    function setUp() public {
        factory = new ERC1967Factory();
        vm.label(address(factory), "ERC1967Factory");
        vm.deal(alice, 100 ether);
    }

    function testAdminOf() public {
        address implementation = address(0xcafe);
        vm.prank(alice);
        address proxy = factory.deploy(implementation, alice);
        assertEq(factory.adminOf(proxy), alice);
    }

    function testChangeAdmin() public {
        address implementation = address(0xcafe);
        vm.prank(alice);
        address proxy = factory.deploy(implementation, alice);
        vm.prank(alice);
        factory.changeAdmin(proxy, bob);
        assertEq(factory.adminOf(proxy), bob);
    }

    function testChangeAdminUnauthorized() public {
        address implementation = address(0xcafe);
        vm.prank(alice);
        address proxy = factory.deploy(implementation, alice);
        vm.prank(bob);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, bob);
    }

    function testUpgrade() public {
        address implementationV1 = address(0xcafe);
        address implementationV2 = address(0xbeef);
        vm.prank(alice);
        address proxy = factory.deploy(implementationV1, alice);
        bytes32 slot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
        assertEq(vm.load(proxy, slot), bytes32(uint256(uint160(implementationV1))));
        vm.prank(alice);
        factory.upgrade(proxy, implementationV2);
        assertEq(vm.load(proxy, slot), bytes32(uint256(uint160(implementationV2))));
    }

    function testUpgradeUnauthorized() public {
        address implementationV1 = address(0xcafe);
        address implementationV2 = address(0xbeef);
        vm.prank(alice);
        address proxy = factory.deploy(implementationV1, alice);
        vm.prank(bob);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, implementationV2);
    }

    function testUpgradeAndCall() public {
        address implementationV1 = address(0xcafe);
        address implementationV2 = address(0xbeef);
        vm.prank(alice);
        address proxy = factory.deploy(implementationV1, alice);
        bytes32 slot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
        assertEq(vm.load(proxy, slot), bytes32(uint256(uint160(implementationV1))));
        vm.prank(alice);
        factory.upgradeAndCall(
            proxy,
            implementationV2,
            abi.encodeWithSignature("init(uint256)", 1337)
        );
        assertEq(vm.load(proxy, slot), bytes32(uint256(uint160(implementationV2))));
    }

    function testUpgradeAndCallUnauthorized() public {
        address implementationV1 = address(0xcafe);
        address implementationV2 = address(0xbeef);
        vm.prank(alice);
        address proxy = factory.deploy(implementationV1, alice);
        vm.prank(bob);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgradeAndCall(proxy, implementationV2, "");
    }

    function testDeploy() public {
        address implementation = address(0xcafe);
        vm.prank(alice);
        address proxy = factory.deploy(implementation, alice);
        bytes32 slot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
        assertEq(vm.load(proxy, slot), bytes32(uint256(uint160(implementation))));
    }

    function testDeployAndCall() public {
        address implementation = address(0xcafe);
        vm.prank(alice);
        address proxy = factory.deployAndCall(
            implementation,
            alice,
            abi.encodeWithSignature("init(uint256)", 1337)
        );
        bytes32 slot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
        assertEq(vm.load(proxy, slot), bytes32(uint256(uint160(implementation))));
    }

    function testDeployDeterministic() public {
        bytes32 salt = keccak256(abi.encode(alice, 1));
        address implementation = address(0xcafe);
        vm.prank(alice);
        address predicted = factory.predictDeterministicAddress(salt);
        address deployed = factory.deployDeterministic(implementation, alice, salt);
        assertEq(predicted, deployed);
    }

    function testDeployDeterministicAndCall() public {
        bytes32 salt = keccak256(abi.encode(alice, 1));
        address implementation = address(0xcafe);
        vm.prank(alice);
        address predicted = factory.predictDeterministicAddress(salt);
        address deployed = factory.deployDeterministicAndCall(
            implementation,
            alice,
            salt,
            abi.encodeWithSignature("init(uint256)", 1337)
        );
        assertEq(predicted, deployed);
    }

    function testDeployDeterministicSaltDoesNotStartWithCaller() public {
        bytes32 salt = keccak256(abi.encode(bob, 1));
        address implementation = address(0xcafe);
        vm.prank(alice);
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministic(implementation, alice, salt);
    }

    function testDeployDeterministicAndCallSaltDoesNotStartWithCaller() public {
        bytes32 salt = keccak256(abi.encode(bob, 1));
        address implementation = address(0xcafe);
        vm.prank(alice);
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministicAndCall(implementation, alice, salt, "");
    }



    function testPredictDeterministicAddress() public {
        bytes32 salt = keccak256(abi.encode(alice, 1));
        address implementation = address(0xcafe);
        vm.prank(alice);
        address predicted = factory.predictDeterministicAddress(salt);
        console2.logAddress(predicted);
    }
}


interface IInitialize {
    function init(uint256) external;
}