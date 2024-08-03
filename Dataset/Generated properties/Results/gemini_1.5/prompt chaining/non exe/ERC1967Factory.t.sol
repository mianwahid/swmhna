// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address internal alice;
    address internal bob;
    address internal carol;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    event AdminChanged(address indexed proxy, address indexed admin);
    event Upgraded(address indexed proxy, address indexed implementation);
    event Deployed(address indexed proxy, address indexed implementation, address indexed admin);

    function setUp() public {
        factory = new ERC1967Factory();
        alice = address(0x1111);
        bob = address(0x2222);
        carol = address(0x3333);
        vm.label(address(factory), "ERC1967Factory");
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(carol, "Carol");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testAdminOf(address proxy) public {
        vm.assume(proxy != address(0));
        vm.assume(uint256(uint160(proxy)) > 100);
        address admin = factory.adminOf(proxy);
        console2.log("Admin of proxy:", admin);
    }

    function testChangeAdmin() public {
        address implementation = address(new DummyImplementation());
        address proxy = factory.deploy(implementation, alice);
        assertEq(factory.adminOf(proxy), alice);
        vm.expectEmit(true, true, true, true);
        emit AdminChanged(proxy, bob);
        vm.prank(alice);
        factory.changeAdmin(proxy, bob);
        assertEq(factory.adminOf(proxy), bob);
    }

    function testChangeAdminUnauthorized() public {
        address implementation = address(new DummyImplementation());
        address proxy = factory.deploy(implementation, alice);
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.Unauthorized.selector));
        factory.changeAdmin(proxy, bob);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     UPGRADE FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testUpgrade() public {
        DummyImplementation implementationV1 = new DummyImplementation();
        DummyImplementation implementationV2 = new DummyImplementation();
        address proxy = factory.deploy(address(implementationV1), alice);
        vm.prank(alice);
        vm.expectEmit(true, true, true, true);
        emit Upgraded(proxy, address(implementationV2));
        factory.upgrade(proxy, address(implementationV2));
        assertEq(implementationV2.number(), 0);
        vm.prank(alice);
        implementationV2.setNumber(10);
        assertEq(implementationV2.number(), 10);
    }

    function testUpgradeUnauthorized() public {
        DummyImplementation implementationV1 = new DummyImplementation();
        DummyImplementation implementationV2 = new DummyImplementation();
        address proxy = factory.deploy(address(implementationV1), alice);
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.Unauthorized.selector));
        factory.upgrade(proxy, address(implementationV2));
    }

    function testUpgradeAndCall() public {
        DummyImplementation implementationV1 = new DummyImplementation();
        DummyImplementation implementationV2 = new DummyImplementation();
        address proxy = factory.deploy(address(implementationV1), alice);
        vm.prank(alice);
        vm.expectEmit(true, true, true, true);
        emit Upgraded(proxy, address(implementationV2));
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 10);
        factory.upgradeAndCall(proxy, address(implementationV2), data);
        assertEq(implementationV2.number(), 10);
    }

    function testUpgradeAndCallUnauthorized() public {
        DummyImplementation implementationV1 = new DummyImplementation();
        DummyImplementation implementationV2 = new DummyImplementation();
        address proxy = factory.deploy(address(implementationV1), alice);
        vm.prank(bob);
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 10);
        vm.expectRevert(abi.encodeWithSelector(ERC1967Factory.Unauthorized.selector));
        factory.upgradeAndCall(proxy, address(implementationV2), data);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      DEPLOY FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDeploy() public {
        DummyImplementation implementation = new DummyImplementation();
        vm.expectEmit(true, true, true, true);
        emit Deployed(address(1), address(implementation), alice);
        address proxy = factory.deploy(address(implementation), alice);
        assertEq(factory.adminOf(proxy), alice);
    }

    function testDeployAndCall() public {
        DummyImplementation implementation = new DummyImplementation();
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 10);
        vm.expectEmit(true, true, true, true);
        emit Deployed(address(1), address(implementation), alice);
        address proxy = factory.deployAndCall(address(implementation), alice, data);
        assertEq(factory.adminOf(proxy), alice);
        assertEq(implementation.number(), 10);
    }

    function testDeployDeterministic() public {
        bytes32 salt = keccak256(abi.encodePacked(alice, block.timestamp));
        DummyImplementation implementation = new DummyImplementation();
        address predictedAddress = factory.predictDeterministicAddress(salt);
        vm.expectEmit(true, true, true, true);
        emit Deployed(predictedAddress, address(implementation), alice);
        address proxy = factory.deployDeterministic(address(implementation), alice, salt);
        assertEq(predictedAddress, proxy);
    }

    function testDeployDeterministicAndCall() public {
        bytes32 salt = keccak256(abi.encodePacked(alice, block.timestamp));
        DummyImplementation implementation = new DummyImplementation();
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 10);
        address predictedAddress = factory.predictDeterministicAddress(salt);
        vm.expectEmit(true, true, true, true);
        emit Deployed(predictedAddress, address(implementation), alice);
        address proxy = factory.deployDeterministicAndCall(
            address(implementation),
            alice,
            salt,
            data
        );
        assertEq(predictedAddress, proxy);
        assertEq(implementation.number(), 10);
    }

    function testDeployDeterministicSaltDoesNotStartWithCaller() public {
        bytes32 salt = keccak256(abi.encodePacked(bob, block.timestamp));
        DummyImplementation implementation = new DummyImplementation();
        vm.expectRevert(
            abi.encodeWithSelector(ERC1967Factory.SaltDoesNotStartWithCaller.selector)
        );
        factory.deployDeterministic(address(implementation), alice, salt);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          HELPERS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

//    function testEmptyData() public {
//        bytes calldata data = factory._emptyData();
//        assertEq(data.length, 0);
//    }
}

contract DummyImplementation {
    uint256 public number;

    function setNumber(uint256 _number) public {
        number = _number;
    }
}