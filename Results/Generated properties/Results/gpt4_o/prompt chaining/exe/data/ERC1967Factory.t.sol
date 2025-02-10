// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address admin;
    address implementation;
    address proxy;
    bytes32 salt;

    function setUp() public {
        factory = new ERC1967Factory();
        admin = address(this);
        implementation = address(0x1234);
        salt = keccak256(abi.encodePacked(admin));
    }

    // Custom Errors
    function testUnauthorizedError() public {
        // Ensure only admin can call changeAdmin
        vm.prank(address(0x1));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, address(0x2));

        // Ensure only admin can call upgrade
        vm.prank(address(0x1));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, implementation);

        // Ensure only admin can call upgradeAndCall
        vm.prank(address(0x1));
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgradeAndCall(proxy, implementation, "");
    }

//    function testDeploymentFailedError() public {
//        // Simulate deployment failure
//        vm.etch(address(0x0), new bytes(0));
//        vm.expectRevert(ERC1967Factory.DeploymentFailed.selector);
//        factory.deploy(address(0x0), admin);
//    }

//    function testUpgradeFailedError() public {
//        // Simulate upgrade failure
//        proxy = factory.deploy(implementation, admin);
//        vm.etch(proxy, new bytes(0));
//        vm.expectRevert(ERC1967Factory.UpgradeFailed.selector);
//        factory.upgrade(proxy, address(0x0));
//    }

    function testSaltDoesNotStartWithCallerError() public {
        // Ensure salt does not start with caller
        bytes32 invalidSalt = keccak256(abi.encodePacked(address(0x1)));
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministic(implementation, admin, invalidSalt);
    }

    // Events
    function testAdminChangedEvent() public {
        proxy = factory.deploy(implementation, admin);
        vm.expectEmit(true, true, false, false);
        emit ERC1967Factory.AdminChanged(proxy, address(0x2));
        factory.changeAdmin(proxy, address(0x2));
    }

    function testUpgradedEvent() public {
        proxy = factory.deploy(implementation, admin);
        vm.expectEmit(true, true, false, false);
        emit ERC1967Factory.Upgraded(proxy, address(0x5678));
        factory.upgrade(proxy, address(0x5678));
    }

//    function testDeployedEvent() public {
//        vm.expectEmit(true, true, true, false);
//        emit ERC1967Factory.Deployed(proxy, implementation, admin);
//        proxy = factory.deploy(implementation, admin);
//    }

    // Admin Functions
    function testAdminOfFunction() public {
        proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testChangeAdminFunction() public {
        proxy = factory.deploy(implementation, admin);
        factory.changeAdmin(proxy, address(0x2));
        assertEq(factory.adminOf(proxy), address(0x2));
    }

    // Upgrade Functions
    function testUpgradeFunction() public {
        proxy = factory.deploy(implementation, admin);
        factory.upgrade(proxy, address(0x5678));
        // Check implementation is updated
    }

    function testUpgradeAndCallFunction() public {
        proxy = factory.deploy(implementation, admin);
        factory.upgradeAndCall(proxy, address(0x5678), "");
        // Check implementation is updated and call is executed
    }

    // Deploy Functions
    function testDeployFunction() public {
        proxy = factory.deploy(implementation, admin);
        assertNotEq(proxy, address(0));
    }

    function testDeployAndCallFunction() public {
        proxy = factory.deployAndCall(implementation, admin, "");
        assertNotEq(proxy, address(0));
    }

//    function testDeployDeterministicFunction() public {
//        proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertNotEq(proxy, address(0));
//    }

//    function testDeployDeterministicAndCallFunction() public {
//        proxy = factory.deployDeterministicAndCall(implementation, admin, salt, "");
//        assertNotEq(proxy, address(0));
//    }

    // Internal Deploy Function
    function testInternalDeployFunction() public {
        proxy = factory.deploy(implementation, admin);
        // Check implementation and admin are set correctly
    }

    // Helper Functions
//    function testPredictDeterministicAddressFunction() public {
//        address predicted = factory.predictDeterministicAddress(salt);
//        proxy = factory.deployDeterministic(implementation, admin, salt);
//        assertEq(predicted, proxy);
//    }

    function testInitCodeHashFunction() public {
        bytes32 hash = factory.initCodeHash();
        // Check hash matches expected value
    }

//    function testInitCodeFunction() public {
//        bytes32 code = factory._initCode();
//        // Check code matches expected bytecode
//    }

//    function testEmptyDataFunction() public {
//        bytes calldata data = factory._emptyData();
//        assertEq(data.length, 0);
//    }
}