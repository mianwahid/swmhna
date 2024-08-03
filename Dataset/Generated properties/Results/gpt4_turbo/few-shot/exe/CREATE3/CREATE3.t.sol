// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    bytes32 private constant TEST_SALT = keccak256("TestSalt");
    uint256 private constant TEST_VALUE = 1 ether;

    function setUp() public {
        vm.deal(address(this), 10 ether);
    }

    function testDeploy() public {
        bytes memory creationCode = type(TestContract).creationCode;
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);

        address deployedAddress = CREATE3.deploy(TEST_SALT, creationCode, TEST_VALUE);

        assertEq(deployedAddress, expectedAddress, "Deployed address does not match expected address");
        assertTrue(deployedAddress.code.length > 0, "Contract code should be present at the deployed address");
        assertEq(address(deployedAddress).balance, TEST_VALUE, "Deployed contract should have the correct balance");
    }

    function testDeployRevertsOnFailedDeployment() public {
        bytes memory creationCode = ""; // Empty creation code should fail
        vm.expectRevert(CREATE3.DeploymentFailed.selector);
        CREATE3.deploy(TEST_SALT, creationCode, TEST_VALUE);
    }

    function testDeployRevertsOnFailedInitialization() public {
        bytes memory creationCode = type(FailingContract).creationCode;
        vm.expectRevert(CREATE3.InitializationFailed.selector);
        CREATE3.deploy(TEST_SALT, creationCode, TEST_VALUE);
    }

    function testGetDeployedAddress() public {
        address expectedAddress = CREATE3.getDeployed(TEST_SALT);
        address computedAddress = CREATE3.getDeployed(TEST_SALT, address(this));

        assertEq(expectedAddress, computedAddress, "Computed address should match the expected address");
    }

    function testGetDeployedAddressWithDifferentDeployer() public {
        address differentDeployer = address(uint160(uint256(keccak256("DifferentDeployer"))));
        address expectedAddress = CREATE3.getDeployed(TEST_SALT, differentDeployer);

        assertNotEq(expectedAddress, CREATE3.getDeployed(TEST_SALT), "Addresses should differ for different deployers");
    }
}

contract TestContract {
    uint256 public value;

    constructor() {
        value = 123;
    }
}

contract FailingContract {
    constructor() {
        revert("Initialization failed");
    }
}