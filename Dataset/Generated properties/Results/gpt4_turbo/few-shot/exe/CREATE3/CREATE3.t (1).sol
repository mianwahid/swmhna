// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    bytes32 private constant TEST_SALT = keccak256("TestSalt");
    bytes private constant TEST_CREATION_CODE = hex"6080604052348015600f57600080fd5b50607d80601d6000396000f3fe6080604052600080fdfea2646970667358221220a1b02d8c67d07a01a6d7a02d2f2e1a4e4c1234567890a1b02d8c67d07a01a6d764736f6c63430008040033";

    function setUp() public {
        // Setup code if needed
    }

    function testDeploy() public {
        // Attempt to deploy using CREATE3
        address deployedAddress = CREATE3.deploy(TEST_SALT, TEST_CREATION_CODE, 0);
        
        // Check that the contract was deployed at the expected address
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);
        assertEq(deployedAddress, expectedAddress, "Deployed address does not match expected address");

        // Check that the contract has code
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(deployedAddress)
        }
        assertTrue(codeSize > 0, "Deployed contract has no code");
    }

    function testDeployWithEther() public {
        uint256 sendValue = 1 ether;
        vm.deal(address(this), sendValue);

        // Attempt to deploy using CREATE3 with value
        address deployedAddress = CREATE3.deploy(TEST_SALT, TEST_CREATION_CODE, sendValue);
        
        // Check that the contract was deployed at the expected address
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);
        assertEq(deployedAddress, expectedAddress, "Deployed address does not match expected address");

        // Check that the contract has code
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(deployedAddress)
        }
        assertTrue(codeSize > 0, "Deployed contract has no code");

        // Check that the contract received the ether
        assertEq(address(deployedAddress).balance, sendValue, "Deployed contract did not receive the correct amount of Ether");
    }

    function testFailDeployWithSameSalt() public {
        // Deploy the first contract
        CREATE3.deploy(TEST_SALT, TEST_CREATION_CODE, 0);

        // Attempt to deploy another contract with the same salt should fail
        CREATE3.deploy(TEST_SALT, TEST_CREATION_CODE, 0);
    }

    function testGetDeployedAddress() public {
        // Calculate expected address without deploying
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);

        // Deploy the contract
        CREATE3.deploy(TEST_SALT, TEST_CREATION_CODE, 0);

        // Check that the calculated address matches the deployed address
        address deployedAddress = CREATE3.getDeployed(TEST_SALT);
        assertEq(deployedAddress, expectedAddress, "Calculated address does not match deployed address");
    }

    function testInitializationFailure() public {
        // Use creation code that fails on initialization
        bytes memory failingCreationCode = hex"60006000fd"; // opcode for REVERT
        vm.expectRevert(CREATE3.InitializationFailed.selector);
        CREATE3.deploy(TEST_SALT, failingCreationCode, 0);
    }
}