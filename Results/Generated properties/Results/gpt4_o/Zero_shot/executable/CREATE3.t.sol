// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    using CREATE3 for bytes32;

    // Test deployment with valid inputs
    function testDeployValid() public {
        bytes32 salt = keccak256(abi.encodePacked("valid_salt"));
        bytes memory creationCode = hex"600a600c600039600a6000f3602a60205260206020f3"; // Simple contract creation code
        uint256 value = 1 ether;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertTrue(deployed != address(0), "Deployment failed");
        assertEq(deployed.balance, value, "Incorrect balance");
    }

    // Test deployment with zero value
    function testDeployZeroValue() public {
        bytes32 salt = keccak256(abi.encodePacked("zero_value_salt"));
        bytes memory creationCode = hex"600a600c600039600a6000f3602a60205260206020f3"; // Simple contract creation code
        uint256 value = 0;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertTrue(deployed != address(0), "Deployment failed");
        assertEq(deployed.balance, value, "Incorrect balance");
    }

    // Test deployment with empty creation code
//    function testDeployEmptyCreationCode() public {
//        bytes32 salt = keccak256(abi.encodePacked("empty_code_salt"));
//        bytes memory creationCode = "";
//        uint256 value = 1 ether;
//
//        vm.expectRevert(CREATE3.DeploymentFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

    // Test deployment with invalid creation code
//    function testDeployInvalidCreationCode() public {
//        bytes32 salt = keccak256(abi.encodePacked("invalid_code_salt"));
//        bytes memory creationCode = hex"600a600c600039600a6000f3"; // Invalid contract creation code
//        uint256 value = 1 ether;
//
//        vm.expectRevert(CREATE3.InitializationFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

    // Test deployment with duplicate salt
//    function testDeployDuplicateSalt() public {
//        bytes32 salt = keccak256(abi.encodePacked("duplicate_salt"));
//        bytes memory creationCode = hex"600a600c600039600a6000f3602a60205260206020f3"; // Simple contract creation code
//        uint256 value = 1 ether;
//
//        address deployed1 = CREATE3.deploy(salt, creationCode, value);
//        assertTrue(deployed1 != address(0), "First deployment failed");
//
//        vm.expectRevert(CREATE3.DeploymentFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

    // Test getDeployed with valid inputs
    function testGetDeployedValid() public {
        bytes32 salt = keccak256(abi.encodePacked("valid_salt"));
        address deployer = address(this);

        address expectedAddress = CREATE3.getDeployed(salt, deployer);
        assertTrue(expectedAddress != address(0), "Invalid deployed address");
    }

    // Test getDeployed with zero address deployer
    function testGetDeployedZeroAddressDeployer() public {
        bytes32 salt = keccak256(abi.encodePacked("zero_address_salt"));
        address deployer = address(0);

        address expectedAddress = CREATE3.getDeployed(salt, deployer);
        assertTrue(expectedAddress != address(0), "Invalid deployed address");
    }

    // Test getDeployed with different salts
    function testGetDeployedDifferentSalts() public {
        bytes32 salt1 = keccak256(abi.encodePacked("salt1"));
        bytes32 salt2 = keccak256(abi.encodePacked("salt2"));
        address deployer = address(this);

        address address1 = CREATE3.getDeployed(salt1, deployer);
        address address2 = CREATE3.getDeployed(salt2, deployer);

        assertTrue(address1 != address(0), "Invalid address1");
        assertTrue(address2 != address(0), "Invalid address2");
        assertTrue(address1 != address2, "Addresses should be different");
    }

    // Test getDeployed with same salt and different deployers
    function testGetDeployedSameSaltDifferentDeployers() public {
        bytes32 salt = keccak256(abi.encodePacked("same_salt"));
        address deployer1 = address(this);
        address deployer2 = address(0x123);

        address address1 = CREATE3.getDeployed(salt, deployer1);
        address address2 = CREATE3.getDeployed(salt, deployer2);

        assertTrue(address1 != address(0), "Invalid address1");
        assertTrue(address2 != address(0), "Invalid address2");
        assertTrue(address1 != address2, "Addresses should be different");
    }
}