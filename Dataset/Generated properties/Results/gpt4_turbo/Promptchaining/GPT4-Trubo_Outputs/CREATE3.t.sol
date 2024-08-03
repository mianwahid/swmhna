// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/CREATE3.sol";

contract CREATE3Test is Test {
    bytes32 constant TEST_SALT = keccak256("TestSalt");
    bytes constant MINIMAL_CREATION_CODE = type(TestContract).creationCode;
    uint256 constant NON_ZERO_VALUE = 1 ether;

    // function testSuccessfulDeployment() public {
    //     uint256 initialBalance = address(this).balance;
    //     // vm.deposit(address(this), NON_ZERO_VALUE);

    //     address deployed = CREATE3.deploy(TEST_SALT, MINIMAL_CREATION_CODE, NON_ZERO_VALUE);
    //     assertTrue(deployed != address(0), "Deployment should return a non-zero address");
    //     assertEq(address(deployed).balance, NON_ZERO_VALUE, "Deployed contract should have the correct balance");
    //     assertEq(CREATE3.getDeployed(TEST_SALT), deployed, "Deployed address should match getDeployed result");
    // }

    // function testDeploymentFailureDueToSaltClash() public {
    //     CREATE3.deploy(TEST_SALT, MINIMAL_CREATION_CODE, 0);
    //     vm.expectRevert(CREATE3.DeploymentFailed.selector);
    //     CREATE3.deploy(TEST_SALT, MINIMAL_CREATION_CODE, 0);
    // }

    // function testInitializationFailure() public {
    //     bytes memory faultyCreationCode = hex"00";
    //     vm.expectRevert(CREATE3.InitializationFailed.selector);
    //     CREATE3.deploy(TEST_SALT, faultyCreationCode, 0);
    // }

    function testGetDeployedWithDeployer() public {
        address deployer = address(this);
        address expectedAddress = CREATE3.getDeployed(TEST_SALT, deployer);
        assertEq(
            expectedAddress,
            CREATE3.getDeployed(TEST_SALT, deployer),
            "Should return the same address on multiple calls"
        );
    }

    function testGetDeployedWithoutDeployer() public {
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);
        assertEq(
            expectedAddress,
            CREATE3.getDeployed(TEST_SALT),
            "Should return the same address on multiple calls"
        );
    }

    function testGetDeployedExtremeSaltValues() public {
        bytes32 zeroSalt = bytes32(0);
        bytes32 maxSalt = bytes32(type(uint256).max);
        address deployer = address(this);

        address zeroSaltAddress = CREATE3.getDeployed(zeroSalt, deployer);
        address maxSaltAddress = CREATE3.getDeployed(maxSalt, deployer);

        assertNotEq(
            zeroSaltAddress,
            maxSaltAddress,
            "Different salts should produce different addresses"
        );
    }

    function testGetDeployedDifferentDeployers() public {
        address deployer1 = address(0x1);
        address deployer2 = address(0x2);

        address address1 = CREATE3.getDeployed(TEST_SALT, deployer1);
        address address2 = CREATE3.getDeployed(TEST_SALT, deployer2);

        assertNotEq(
            address1,
            address2,
            "Different deployers should produce different addresses"
        );
    }

    function testZeroValueDeployment() public {
        address deployed = CREATE3.deploy(TEST_SALT, MINIMAL_CREATION_CODE, 0);
        assertTrue(
            deployed != address(0),
            "Deployment should succeed with zero value"
        );
        assertEq(
            address(deployed).balance,
            0,
            "Deployed contract should have zero balance"
        );
    }

    function testMinimalCreationCodeDeployment() public {
        address deployed = CREATE3.deploy(TEST_SALT, MINIMAL_CREATION_CODE, 0);
        assertTrue(
            deployed != address(0),
            "Deployment should succeed with minimal creation code"
        );
    }
}

contract TestContract {
    function testFunction() external pure returns (string memory) {
        return "TestFunction";
    }
}
