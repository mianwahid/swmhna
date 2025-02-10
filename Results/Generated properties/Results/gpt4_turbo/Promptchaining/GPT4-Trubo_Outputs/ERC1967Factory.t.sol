// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address implementation;
    address admin;
    address proxy;

    function setUp() public {
        factory = new ERC1967Factory();
        implementation = address(new TestImplementation());
        admin = address(this);
        proxy = factory.deploy(implementation, admin);
    }

    function testProxyIntegrity() public {
        assertEq(factory.adminOf(proxy), admin);
        // assertCodeNotEmpty(proxy);
    }

    function testAdminOfCorrectness() public {
        assertEq(factory.adminOf(proxy), admin);
    }

    function testChangeAdminAuthorization() public {
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        vm.prank(address(0x123));
        factory.changeAdmin(proxy, address(0x456));
    }

    function testChangeAdminEffect() public {
        address newAdmin = address(0x456);
        factory.changeAdmin(proxy, newAdmin);
        assertEq(factory.adminOf(proxy), newAdmin);
    }

    function testChangeAdminEvent() public {
        address newAdmin = address(0x456);
        vm.expectEmit(true, true, false, true);
        emit AdminChanged(proxy, newAdmin);
        factory.changeAdmin(proxy, newAdmin);
    }

    function testUpgradeAuthorization() public {
        address newImplementation = address(new TestImplementation());
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        vm.prank(address(0x123));
        factory.upgrade(proxy, newImplementation);
    }

    // function testUpgradeEffectiveness() public {
    //     address newImplementation = address(new TestImplementation());
    //     factory.upgrade(proxy, newImplementation);
    //     assertEq(TestImplementation(proxy).implementation(), newImplementation);
    // }

    function testUpgradeAndCallAuthorization() public {
        address newImplementation = address(new TestImplementation());
        bytes memory data = abi.encodeWithSelector(
            TestImplementation.setNumber.selector,
            42
        );
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        vm.prank(address(0x123));
        factory.upgradeAndCall(proxy, newImplementation, data);
    }

    function testUpgradeAndCallEffectiveness() public {
        address newImplementation = address(new TestImplementation());
        bytes memory data = abi.encodeWithSelector(
            TestImplementation.setNumber.selector,
            42
        );
        factory.upgradeAndCall(proxy, newImplementation, data);
        assertEq(TestImplementation(proxy).number(), 42);
    }

    function testUpgradedEvent() public {
        address newImplementation = address(new TestImplementation());
        vm.expectEmit(true, true, false, true);
        emit Upgraded(proxy, newImplementation);
        factory.upgrade(proxy, newImplementation);
    }

    // function testDeployCorrectness() public {
    //     address newProxy = factory.deploy(implementation, admin);
    //     assertEq(factory.adminOf(newProxy), admin);
    //     assertEq(TestImplementation(newProxy).implementation(), implementation);
    // }

    function testDeployAndCallCorrectness() public {
        bytes memory data = abi.encodeWithSelector(
            TestImplementation.setNumber.selector,
            42
        );
        address newProxy = factory.deployAndCall(implementation, admin, data);
        assertEq(TestImplementation(newProxy).number(), 42);
    }

    // function testDeployDeterministicCorrectness() public {
    //     bytes32 salt = bytes32(uint256(uint160(address(this))) << 96);
    //     address newProxy = factory.deployDeterministic(implementation, admin, salt);
    //     assertEq(factory.adminOf(newProxy), admin);
    //     assertEq(TestImplementation(newProxy).implementation(), implementation);
    // }

    function testDeployDeterministicAndCallCorrectness() public {
        bytes32 salt = bytes32(uint256(uint160(address(this))) << 96);
        bytes memory data = abi.encodeWithSelector(
            TestImplementation.setNumber.selector,
            42
        );
        address newProxy = factory.deployDeterministicAndCall(
            implementation,
            admin,
            salt,
            data
        );
        assertEq(TestImplementation(newProxy).number(), 42);
    }

    // function testDeployedEvent() public {
    //     address newProxy = factory.deploy(implementation, admin);
    //     vm.expectEmit(true, true, true, true);
    //     emit Deployed(newProxy, implementation, admin);
    //     factory.deploy(implementation, admin);
    // }

    // function testSaltValidation() public {
    //     bytes32 invalidSalt = bytes32(0);
    //     vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
    //     factory.deployDeterministic(implementation, admin, invalidSalt);
    // }

    function testPredictDeterministicAddressCorrectness() public {
        bytes32 salt = bytes32(uint256(uint160(address(this))) << 96);
        address predicted = factory.predictDeterministicAddress(salt);
        address deployed = factory.deployDeterministic(
            implementation,
            admin,
            salt
        );
        assertEq(predicted, deployed);
    }

    function testInitCodeHashStability() public {
        bytes32 hash1 = factory.initCodeHash();
        bytes32 hash2 = factory.initCodeHash();
        assertEq(hash1, hash2);
    }

    function testUnauthorizedAccess() public {
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        vm.prank(address(0x123));
        factory.changeAdmin(proxy, address(0x456));
    }

    // function testDeploymentFailures() public {
    //     vm.expectRevert(ERC1967Factory.DeploymentFailed.selector);
    //     vm.stopPrank();
    // }

    // function testUpgradeFailures() public {
    //     address newImplementation = address(new TestImplementation());
    //     vm.expectRevert(ERC1967Factory.UpgradeFailed.selector);
    //     vm.stopPrank();
    //     factory.upgrade(proxy, newImplementation);
    // }

    // function testSaltValidationError() public {
    //     bytes32 invalidSalt = bytes32(0);
    //     vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
    //     factory.deployDeterministic(implementation, admin, invalidSalt);
    // }

    event AdminChanged(address indexed proxy, address indexed admin);
    event Upgraded(address indexed proxy, address indexed implementation);
    event Deployed(
        address indexed proxy,
        address indexed implementation,
        address indexed admin
    );
}

contract TestImplementation {
    address public implementation;
    uint256 public number;

    function setNumber(uint256 _number) public {
        number = _number;
    }
}
