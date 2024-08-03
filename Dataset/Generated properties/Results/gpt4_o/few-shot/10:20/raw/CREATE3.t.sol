// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    using CREATE3 for bytes32;

    event Deployed(address indexed deployedAddress);

    function testDeploy() public {
        bytes32 salt = keccak256("testSalt");
        bytes memory creationCode = type(TestContract).creationCode;
        uint256 value = 1 ether;

        address deployed = CREATE3.deploy(salt, creationCode, value);

        assertTrue(deployed != address(0), "Deployment failed");
        assertEq(deployed.balance, value, "Incorrect balance after deployment");

        emit Deployed(deployed);
    }

    function testDeployRevertsOnFailure() public {
        bytes32 salt = keccak256("testSalt");
        bytes memory creationCode = hex"00"; // Invalid creation code
        uint256 value = 1 ether;

        vm.expectRevert(CREATE3.DeploymentFailed.selector);
        CREATE3.deploy(salt, creationCode, value);
    }

    function testGetDeployed() public {
        bytes32 salt = keccak256("testSalt");
        address deployer = address(this);
        address expectedAddress = CREATE3.getDeployed(salt, deployer);

        assertTrue(expectedAddress != address(0), "Expected address is zero");
    }

    function testGetDeployedWithDifferentDeployer() public {
        bytes32 salt = keccak256("testSalt");
        address deployer = address(0x1234);
        address expectedAddress = CREATE3.getDeployed(salt, deployer);

        assertTrue(expectedAddress != address(0), "Expected address is zero");
    }

    function testGetDeployedWithCurrentContract() public {
        bytes32 salt = keccak256("testSalt");
        address expectedAddress = CREATE3.getDeployed(salt);

        assertTrue(expectedAddress != address(0), "Expected address is zero");
    }

    function testDeployAndGetDeployed() public {
        bytes32 salt = keccak256("testSalt");
        bytes memory creationCode = type(TestContract).creationCode;
        uint256 value = 1 ether;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        address expectedAddress = CREATE3.getDeployed(salt);

        assertEq(deployed, expectedAddress, "Deployed address does not match expected address");
    }
}

contract TestContract {
    uint256 public value;

    constructor() payable {
        value = msg.value;
    }
}