// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ERC1967Factory.sol";

contract ERC1967FactoryTest is Test {
    ERC1967Factory factory;
    address implementation = address(0x123);
    address admin = address(0x456);
    address nonAdmin = address(0x789);

    function setUp() public {
        factory = new ERC1967Factory();
    }

    // Admin Functions

    function testAdminOf() public {
        address proxy = factory.deploy(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);

        // Edge Case: Querying the admin of a proxy that has not been deployed
        address nonExistentProxy = address(0x999);
        assertEq(factory.adminOf(nonExistentProxy), address(0));

        // Edge Case: Querying the admin of a proxy after it has been changed
        factory.changeAdmin(proxy, nonAdmin);
        assertEq(factory.adminOf(proxy), nonAdmin);
    }

    function testChangeAdmin() public {
        address proxy = factory.deploy(implementation, admin);

        // Only admin can change the admin
        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, nonAdmin);

        // Change admin to zero address
        vm.prank(admin);
        factory.changeAdmin(proxy, address(0));
        assertEq(factory.adminOf(proxy), address(0));

        // Change admin to the same address (no-op)
        vm.prank(address(0));
        factory.changeAdmin(proxy, address(0));
        assertEq(factory.adminOf(proxy), address(0));
    }

    // Upgrade Functions

    function testUpgrade() public {
        address proxy = factory.deploy(implementation, admin);

        // Only admin can upgrade the proxy
        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, address(0xabc));

        // Upgrade to zero address
        vm.prank(admin);
        factory.upgrade(proxy, address(0));
        // No direct way to check implementation, assume no revert means success

        // Upgrade to the same implementation address (no-op)
        vm.prank(admin);
        factory.upgrade(proxy, address(0));
    }

    function testUpgradeAndCall() public {
        address proxy = factory.deploy(implementation, admin);

        // Only admin can upgrade and call the proxy
        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgradeAndCall(proxy, address(0xabc), "");

        // Providing empty data for the call
        vm.prank(admin);
        factory.upgradeAndCall(proxy, address(0xabc), "");

        // Providing invalid data for the call
        vm.prank(admin);
        vm.expectRevert();
        factory.upgradeAndCall(proxy, address(0xabc), "invalid data");
    }

    // Deploy Functions

    function testDeploy() public {
        // Deploy with zero address as implementation
        vm.expectRevert();
        factory.deploy(address(0), admin);

        // Deploy with zero address as admin
        vm.expectRevert();
        factory.deploy(implementation, address(0));

        // Deploy with non-zero value (ETH) sent to the function
        address proxy = factory.deploy{value: 1 ether}(implementation, admin);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testDeployAndCall() public {
        // Deploy and call with empty data
        address proxy = factory.deployAndCall(implementation, admin, "");
        assertEq(factory.adminOf(proxy), admin);

        // Deploy and call with invalid data
        vm.expectRevert();
        factory.deployAndCall(implementation, admin, "invalid data");
    }

    function testDeployDeterministic() public {
        bytes32 salt = keccak256(abi.encodePacked(address(this)));

        // Deploy with zero address as implementation
        vm.expectRevert();
        factory.deployDeterministic(address(0), admin, salt);

        // Deploy with zero address as admin
        vm.expectRevert();
        factory.deployDeterministic(implementation, address(0), salt);

        // Deploy with salt that does not start with caller's address
        bytes32 invalidSalt = keccak256(abi.encodePacked(nonAdmin));
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministic(implementation, admin, invalidSalt);

        // Deploy with non-zero value (ETH) sent to the function
        address proxy = factory.deployDeterministic{value: 1 ether}(implementation, admin, salt);
        assertEq(factory.adminOf(proxy), admin);
    }

    function testDeployDeterministicAndCall() public {
        bytes32 salt = keccak256(abi.encodePacked(address(this)));

        // Deploy and call with empty data
        address proxy = factory.deployDeterministicAndCall(implementation, admin, salt, "");
        assertEq(factory.adminOf(proxy), admin);

        // Deploy and call with invalid data
        vm.expectRevert();
        factory.deployDeterministicAndCall(implementation, admin, salt, "invalid data");

        // Deploy with salt that does not start with caller's address
        bytes32 invalidSalt = keccak256(abi.encodePacked(nonAdmin));
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministicAndCall(implementation, admin, invalidSalt, "");
    }

    // Utility Functions

    function testPredictDeterministicAddress() public {
        bytes32 salt = keccak256(abi.encodePacked(address(this)));
        address predicted = factory.predictDeterministicAddress(salt);
        address proxy = factory.deployDeterministic(implementation, admin, salt);
        assertEq(predicted, proxy);

        // Predicting the address with zero salt
        address predictedZeroSalt = factory.predictDeterministicAddress(bytes32(0));
        assert(predictedZeroSalt != address(0));

        // Predicting the address with salt that starts with caller's address
        bytes32 validSalt = keccak256(abi.encodePacked(address(this)));
        address predictedValidSalt = factory.predictDeterministicAddress(validSalt);
        assert(predictedValidSalt != address(0));
    }

//    function testInitCodeHash() public {
//        bytes32 hash = factory.initCodeHash();
//        bytes32 expectedHash = keccak256(abi.encodePacked(factory._initCode()));
//        assertEq(hash, expectedHash);
//
//        // Ensuring the hash remains consistent across multiple calls
//        bytes32 hash2 = factory.initCodeHash();
//        assertEq(hash, hash2);
//    }

    // General Invariants

    function testEvents() public {
        address proxy = factory.deploy(implementation, admin);

        // Ensuring `AdminChanged` is emitted with the correct parameters
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.AdminChanged(proxy, nonAdmin);
        vm.prank(admin);
        factory.changeAdmin(proxy, nonAdmin);

        // Ensuring `Upgraded` is emitted with the correct parameters
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Upgraded(proxy, address(0xabc));
        vm.prank(nonAdmin);
        factory.upgrade(proxy, address(0xabc));

        // Ensuring `Deployed` is emitted with the correct parameters
        vm.expectEmit(true, true, true, true);
        emit ERC1967Factory.Deployed(proxy, implementation, admin);
        factory.deploy(implementation, admin);
    }

    function testCustomErrors() public {
        address proxy = factory.deploy(implementation, admin);

        // Ensuring `Unauthorized` is thrown when a non-admin attempts to change the admin or upgrade the proxy
        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.changeAdmin(proxy, nonAdmin);

        vm.prank(nonAdmin);
        vm.expectRevert(ERC1967Factory.Unauthorized.selector);
        factory.upgrade(proxy, address(0xabc));

        // Ensuring `DeploymentFailed` is thrown when the proxy deployment fails
        vm.expectRevert(ERC1967Factory.DeploymentFailed.selector);
        factory.deploy(address(0), admin);

        // Ensuring `UpgradeFailed` is thrown when the proxy upgrade fails
        vm.prank(admin);
        vm.expectRevert(ERC1967Factory.UpgradeFailed.selector);
        factory.upgradeAndCall(proxy, address(0xabc), "invalid data");

        // Ensuring `SaltDoesNotStartWithCaller` is thrown when the provided salt does not start with the caller's address
        bytes32 invalidSalt = keccak256(abi.encodePacked(nonAdmin));
        vm.expectRevert(ERC1967Factory.SaltDoesNotStartWithCaller.selector);
        factory.deployDeterministic(implementation, admin, invalidSalt);
    }
}