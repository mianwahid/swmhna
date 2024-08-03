// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TEST CONSTANTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    bytes32 internal constant _SALT = keccak256(abi.encodePacked("test salt"));

    bytes internal constant _BYTECODE = hex"600055"; // PUSH1 0x00, SSTORE

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      TEST HELPER FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _deployWithSalt(bytes32 salt) internal returns (address deployed) {
        deployed = CREATE3.deploy(salt, _BYTECODE, 0);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           UNIT TESTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDeploy_Deterministic() public {
        address deployed1 = _deployWithSalt(_SALT);
        address deployed2 = _deployWithSalt(_SALT);
        assertEq(deployed1, deployed2, "Deployments with same salt should result in same address");
    }

    function testDeploy_DifferentSalts() public {
        address deployed1 = _deployWithSalt(_SALT);
        address deployed2 = _deployWithSalt(keccak256(abi.encodePacked("different salt")));
        assertNotEq(deployed1, deployed2, "Deployments with different salts should result in different addresses");
    }

    function testDeploy_DeploymentFailed() public {
        bytes memory badBytecode = hex"6000"; // PUSH1 0x00 (missing SSTORE)
        vm.expectRevert(abi.encodeWithSelector(CREATE3.DeploymentFailed.selector));
        CREATE3.deploy(_SALT, badBytecode, 0);
    }

    function testDeploy_InitializationFailed() public {
        bytes memory revertingBytecode = hex"600031"; // PUSH1 0x00, CALLER (will revert)
        vm.expectRevert(abi.encodeWithSelector(CREATE3.InitializationFailed.selector));
        CREATE3.deploy(_SALT, revertingBytecode, 0);
    }

    function testDeploy_ValueTransfer() public {
        uint256 value = 1 ether;
        address deployed = CREATE3.deploy(_SALT, _BYTECODE, value);
        assertEq(deployed.balance, value, "Deployed contract should receive correct ETH value");
    }

    function testGetDeployed_Accuracy() public {
        address calculatedAddress = CREATE3.getDeployed(_SALT);
        address deployedAddress = _deployWithSalt(_SALT);
        assertEq(calculatedAddress, deployedAddress, "Calculated and deployed addresses should match");
    }

    function testGetDeployed_SaltUniqueness() public {
        address address1 = CREATE3.getDeployed(_SALT);
        address address2 = CREATE3.getDeployed(keccak256(abi.encodePacked("different salt")));
        assertNotEq(address1, address2, "Different salts should result in different addresses");
    }

    function testGetDeployed_DeployerSpecificity() public {
        address address1 = CREATE3.getDeployed(_SALT);
        vm.startPrank(address(1));
        address address2 = CREATE3.getDeployed(_SALT);
        vm.stopPrank();
        assertNotEq(address1, address2, "Different deployers should result in different addresses");
    }

    function testGetDeployed_ConsistencyWithDeploy() public {
        address calculatedAddress = CREATE3.getDeployed(_SALT);
        address deployedAddress = _deployWithSalt(_SALT);
        assertEq(calculatedAddress, deployedAddress, "Calculated and deployed addresses should match");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                             FUZZ TESTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testFuzz_DeployGetDeployedConsistency(bytes32 salt, bytes memory creationCode) public {
        vm.assume(creationCode.length > 0); // Avoid empty bytecode
        address calculatedAddress = CREATE3.getDeployed(salt);
        address deployedAddress = CREATE3.deploy(salt, creationCode, 0);
        assertEq(calculatedAddress, deployedAddress, "Calculated and deployed addresses should match");
    }

    function testFuzz_DifferentSaltsDifferentAddresses(bytes32 salt1, bytes32 salt2) public {
        vm.assume(salt1 != salt2);
        address address1 = CREATE3.getDeployed(salt1);
        address address2 = CREATE3.getDeployed(salt2);
        assertNotEq(address1, address2, "Different salts should result in different addresses");
    }
}
