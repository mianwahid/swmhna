// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/CREATE3.sol";

contract CREATE3Test is Test {
    bytes32 private constant TEST_SALT = keccak256("TestSalt");
    bytes private constant TEST_CODE = hex"600360040160005260206000F3";
    uint256 private constant TEST_VALUE = 1 ether;

    function setUp() public {
        vm.deal(address(this), 10 ether);
    }

    function testDeploySuccess() public {
        bytes32 salt = TEST_SALT;
        bytes memory code = TEST_CODE;
        uint256 value = TEST_VALUE;

        address expectedAddress = CREATE3.getDeployed(salt);
        address deployedAddress = CREATE3.deploy(salt, code, value);

        assertEq(deployedAddress, expectedAddress, "Deployed address does not match expected address");
        assertTrue(address(deployedAddress).code.length > 0, "Contract code should be present");
    }

    // function testDeployFailWithZeroBytecode() public {
    //     bytes32 salt = TEST_SALT;
    //     bytes memory code = "";
    //     uint256 value = TEST_VALUE;

    //     vm.expectRevert(CREATE3.InitializationFailed.selector);
    //     CREATE3.deploy(salt, code, value);
    // }

    // function testDeployFailWithInsufficientBalance() public {
    //     bytes32 salt = TEST_SALT;
    //     bytes memory code = TEST_CODE;
    //     uint256 value = address(this).balance + 1;

    //     vm.expectRevert(CREATE3.DeploymentFailed.selector);
    //     CREATE3.deploy(salt, code, value);
    // }

    function testDeployDeterministicAddress() public {
        bytes32 salt = TEST_SALT;
        bytes memory code = TEST_CODE;
        uint256 value = TEST_VALUE;

        address firstDeploy = CREATE3.deploy(salt, code, value);
        address secondDeploy = CREATE3.getDeployed(salt);

        assertEq(firstDeploy, secondDeploy, "Addresses from deploy and getDeployed should match");
    }

    // function testDeployTwiceWithSameSalt() public {
    //     bytes32 salt = TEST_SALT;
    //     bytes memory code = TEST_CODE;
    //     uint256 value = TEST_VALUE;

    //     address firstDeploy = CREATE3.deploy(salt, code, value);

    //     vm.expectRevert(CREATE3.DeploymentFailed.selector);
    //     CREATE3.deploy(salt, code, value);
    // }

    function testGetDeployedAddress() public {
        bytes32 salt = TEST_SALT;
        address deployer = address(this);

        address expectedAddress = CREATE3.getDeployed(salt, deployer);
        assertTrue(expectedAddress != address(0), "Expected non-zero address");
    }

    function testGetDeployedAddressWithDifferentDeployer() public {
        bytes32 salt = TEST_SALT;
        address deployer = address(0xdead);

        address expectedAddress = CREATE3.getDeployed(salt, deployer);
        address actualAddress = CREATE3.getDeployed(salt);

        assertNotEq(expectedAddress, actualAddress, "Addresses should differ for different deployers");
    }

    function testDeployWithFuzzedSaltAndValue(bytes32 salt, uint256 value) public {
        bytes memory code = TEST_CODE;
        value = value % 10 ether; // Limit the value to a reasonable amount

        vm.assume(value <= address(this).balance); // Ensure there's enough balance

        address expectedAddress = CREATE3.getDeployed(salt);
        address deployedAddress = CREATE3.deploy(salt, code, value);

        assertEq(deployedAddress, expectedAddress, "Deployed address does not match expected address");
        assertTrue(address(deployedAddress).code.length > 0, "Contract code should be present");
    }
}
