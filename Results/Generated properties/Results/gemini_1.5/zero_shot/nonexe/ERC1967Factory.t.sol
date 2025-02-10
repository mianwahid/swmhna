// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {ERC1967Factory} from "../src/utils/ERC1967Factory.sol";
import {Vm} from "forge-std/Vm.sol";
import {Proxy} from "../../proxy/src/Proxy.sol";

contract ERC1967FactoryTest is Test {
    Vm internal vm = Vm(address(0x7109709ECfa91a80626fF3989D683767A80A3908));

    ERC1967Factory factory;
    address alice = address(0x123);
    address bob = address(0x456);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          SET UP                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function setUp() public {
        factory = new ERC1967Factory();
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      TEST FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testAdminOf() public {
        address implementation = address(new Proxy());
        address proxy = factory.deploy(implementation, alice);
        assertEq(factory.adminOf(proxy), alice);
    }

    function testChangeAdmin() public {
        address implementation = address(new Proxy());
        address proxy = factory.deploy(implementation, alice);
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.AdminChanged(proxy, bob);
        factory.changeAdmin(proxy, bob);
        assertEq(factory.adminOf(proxy), bob);
    }

    function testChangeAdminUnauthorized() public {
        address implementation = address(new Proxy());
        address proxy = factory.deploy(implementation, alice);
        vm.startPrank(bob);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.Unauthorized.selector));
        factory.changeAdmin(proxy, bob);
    }

    function testUpgrade() public {
        address implementationV1 = address(new Proxy());
        address implementationV2 = address(new Proxy());
        address proxy = factory.deploy(implementationV1, alice);
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Upgraded(proxy, implementationV2);
        factory.upgrade(proxy, implementationV2);
        assertEq(uint256(vm.load(proxy, bytes32(_IMPLEMENTATION_SLOT()))), uint256(uint160(implementationV2)));
    }

    function testUpgradeUnauthorized() public {
        address implementationV1 = address(new Proxy());
        address implementationV2 = address(new Proxy());
        address proxy = factory.deploy(implementationV1, alice);
        vm.startPrank(bob);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.Unauthorized.selector));
        factory.upgrade(proxy, implementationV2);
    }

    function testUpgradeAndCall() public {
        address implementationV1 = address(new Proxy());
        address implementationV2 = address(new Proxy());
        address proxy = factory.deploy(implementationV1, alice);
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 123);
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Upgraded(proxy, implementationV2);
        factory.upgradeAndCall{value: 1 ether}(proxy, implementationV2, data);
        assertEq(uint256(vm.load(proxy, bytes32(_IMPLEMENTATION_SLOT()))), uint256(uint160(implementationV2)));
    }

    function testUpgradeAndCallUnauthorized() public {
        address implementationV1 = address(new Proxy());
        address implementationV2 = address(new Proxy());
        address proxy = factory.deploy(implementationV1, alice);
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 123);
        vm.startPrank(bob);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.Unauthorized.selector));
        factory.upgradeAndCall(proxy, implementationV2, data);
    }

    function testDeploy() public {
        address implementation = address(new Proxy());
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(address(0), implementation, alice);
        address proxy = factory.deploy(implementation, alice);
        assertEq(uint256(vm.load(proxy, bytes32(_IMPLEMENTATION_SLOT()))), uint256(uint160(implementation)));
    }

    function testDeployAndCall() public {
        address implementation = address(new Proxy());
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 123);
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(address(0), implementation, alice);
        address proxy = factory.deployAndCall(implementation, alice, data);
        assertEq(uint256(vm.load(proxy, bytes32(_IMPLEMENTATION_SLOT()))), uint256(uint160(implementation)));
    }

    function testDeployDeterministic() public {
        bytes32 salt = keccak256(abi.encodePacked(alice, block.timestamp));
        address implementation = address(new Proxy());
        address predicted = factory.predictDeterministicAddress(salt);
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(predicted, implementation, alice);
        address proxy = factory.deployDeterministic(implementation, alice, salt);
        assertEq(uint256(vm.load(proxy, bytes32(_IMPLEMENTATION_SLOT()))), uint256(uint160(implementation)));
        assertEq(proxy, predicted);
    }

    function testDeployDeterministicAndCall() public {
        bytes32 salt = keccak256(abi.encodePacked(alice, block.timestamp));
        address implementation = address(new Proxy());
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 123);
        address predicted = factory.predictDeterministicAddress(salt);
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(predicted, implementation, alice);
        address proxy = factory.deployDeterministicAndCall(implementation, alice, salt, data);
        assertEq(uint256(vm.load(proxy, bytes32(_IMPLEMENTATION_SLOT()))), uint256(uint160(implementation)));
        assertEq(proxy, predicted);
    }

    function testDeployDeterministicSaltDoesNotStartWithCaller() public {
        bytes32 salt = keccak256(abi.encodePacked(bob, block.timestamp));
        address implementation = address(new Proxy());
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.SaltDoesNotStartWithCaller.selector));
        factory.deployDeterministic(implementation, alice, salt);
    }

    function testDeployDeterministicAndCallSaltDoesNotStartWithCaller() public {
        bytes32 salt = keccak256(abi.encodePacked(bob, block.timestamp));
        address implementation = address(new Proxy());
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 123);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.SaltDoesNotStartWithCaller.selector));
        factory.deployDeterministicAndCall(implementation, alice, salt, data);
    }

    function testPredictDeterministicAddress() public {
        bytes32 salt = keccak256(abi.encodePacked(alice, block.timestamp));
        address implementation = address(new Proxy());
        address predicted = factory.predictDeterministicAddress(salt);
        address proxy = factory.deployDeterministic(implementation, alice, salt);
        assertEq(proxy, predicted);
    }

    function testInitCodeHash() public {
        bytes32 hash = factory.initCodeHash();
        assertEq(hash, keccak256(abi.encodePacked(factory._initCode(), bytes1(0x13), bytes1(0x88))));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       HELPERS                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
}