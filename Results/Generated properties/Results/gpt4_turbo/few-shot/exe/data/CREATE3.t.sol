// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    bytes32 private constant TEST_SALT = keccak256("TestSalt");
    bytes private constant TEST_CODE = hex"6080604052348015600f57600080fd5b50607d80601d6000396000f3fe6080604052600080fdfea2646970667358221220d9f7b99e6daffc1c3085b5d8457d492f5c8e1b8c1a6f3b2b1f5b3f3b2b1f5b3f64736f6c63430008040033";

    function setUp() public {
        // Setup code if needed
    }

    function testDeploy() public {
        // Deploy using CREATE3
        address deployedAddress = CREATE3.deploy(TEST_SALT, TEST_CODE, 0);
        
        // Check if the contract is deployed at the expected address
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);
        assertEq(deployedAddress, expectedAddress, "Deployed address does not match expected address");

        // Check if the contract has code
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(deployedAddress)
        }
        assertTrue(codeSize > 0, "Deployed contract has no code");
    }

    function testFailDeployWithSameSalt() public {
        // Deploy the first time
        CREATE3.deploy(TEST_SALT, TEST_CODE, 0);

        // Attempt to deploy again with the same salt should fail
        CREATE3.deploy(TEST_SALT, TEST_CODE, 0);
    }

    function testGetDeployedAddress() public {
        // Calculate expected address without deploying
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);

        // Deploy the contract
        address deployedAddress = CREATE3.deploy(TEST_SALT, TEST_CODE, 0);

        // Check if the addresses match
        assertEq(deployedAddress, expectedAddress, "Computed address does not match deployed address");
    }

//    function testInitializationFailure() public {
//        // Deploy with initialization code that fails (assuming TEST_CODE is such that it will fail)
//        vm.expectRevert(CREATE3.InitializationFailed.selector);
//        CREATE3.deploy(TEST_SALT, TEST_CODE, 0);
//    }

//    function testDeploymentFailure() public {
//        // Deploy with invalid creation code (empty code)
//        vm.expectRevert(CREATE3.DeploymentFailed.selector);
//        CREATE3.deploy(TEST_SALT, "", 0);
//    }

//    function testNonZeroValueDeployment() public {
//        // Deploy with non-zero ETH value
//        uint256 sendValue = 1 ether;
//        vm.deal(address(this), sendValue);
//        address deployedAddress = CREATE3.deploy{value: sendValue}(TEST_SALT, TEST_CODE, sendValue);
//
//        // Check if the contract has the sent ETH
//        assertEq(address(deployedAddress).balance, sendValue, "Deployed contract did not receive the correct ETH amount");
//    }
}