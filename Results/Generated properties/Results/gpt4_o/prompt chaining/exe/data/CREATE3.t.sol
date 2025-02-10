// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    using CREATE3 for bytes32;

    event Deployed(address indexed deployedAddress);

    function testSuccessfulDeployment() public {
        bytes32 salt = keccak256("testSalt");
        bytes memory creationCode = hex"600a600c600039600a6000f3";
        uint256 value = 0;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        assert(deployed != address(0));
        emit Deployed(deployed);
    }

//    function testDeploymentFailure() public {
//        bytes32 salt = keccak256("testSalt");
//        bytes memory creationCode = hex"600a600c600039600a6000f3";
//        uint256 value = 0;
//
//        vm.expectRevert(CREATE3.DeploymentFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

//    function testInitializationFailure() public {
//        bytes32 salt = keccak256("testSalt");
//        bytes memory creationCode = hex"600a600c600039600a6000f3";
//        uint256 value = 0;
//
//        vm.expectRevert(CREATE3.InitializationFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

//    function testZeroCodeSize() public {
//        bytes32 salt = keccak256("testSalt");
//        bytes memory creationCode = hex"";
//        uint256 value = 0;
//
//        vm.expectRevert(CREATE3.InitializationFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

    function testDeterministicAddressCalculation() public {
        bytes32 salt = keccak256("testSalt");
        bytes memory creationCode = hex"600a600c600039600a6000f3";
        uint256 value = 0;

        address expectedAddress = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expectedAddress);
    }

    function testFundingTheDeployedContract() public {
        bytes32 salt = keccak256("testSalt");
        bytes memory creationCode = hex"600a600c600039600a6000f3";
        uint256 value = 1 ether;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed.balance, value);
    }

    function testCorrectAddressCalculationWithDeployer() public {
        bytes32 salt = keccak256("testSalt");
        address deployer = address(this);

        address expectedAddress = CREATE3.getDeployed(salt, deployer);
        assert(expectedAddress != address(0));
    }

    function testAddressConsistencyWithDeployer() public {
        bytes32 salt = keccak256("testSalt");
        address deployer = address(this);

        address address1 = CREATE3.getDeployed(salt, deployer);
        address address2 = CREATE3.getDeployed(salt, deployer);
        assertEq(address1, address2);
    }

    function testCorrectAddressCalculationWithoutDeployer() public {
        bytes32 salt = keccak256("testSalt");

        address expectedAddress = CREATE3.getDeployed(salt);
        assert(expectedAddress != address(0));
    }

    function testAddressConsistencyWithoutDeployer() public {
        bytes32 salt = keccak256("testSalt");

        address address1 = CREATE3.getDeployed(salt);
        address address2 = CREATE3.getDeployed(salt);
        assertEq(address1, address2);
    }

//    function testEmptyCreationCode() public {
//        bytes32 salt = keccak256("testSalt");
//        bytes memory creationCode = hex"";
//        uint256 value = 0;
//
//        vm.expectRevert(CREATE3.InitializationFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

//    function testMaximumGasLimit() public {
//        bytes32 salt = keccak256("testSalt");
//        bytes memory creationCode = hex"600a600c600039600a6000f3";
//        uint256 value = 0;
//
//        vm.recordGas();
//        CREATE3.deploy(salt, creationCode, value);
//        uint256 gasUsed = vm.stopGasMetering();
//        console2.log("Gas used:", gasUsed);
//    }

//    function testReusedSalt() public {
//        bytes32 salt = keccak256("testSalt");
//        bytes memory creationCode = hex"600a600c600039600a6000f3";
//        uint256 value = 0;
//
//        address deployed1 = CREATE3.deploy(salt, creationCode, value);
//        vm.expectRevert(CREATE3.DeploymentFailed.selector);
//        CREATE3.deploy(salt, creationCode, value);
//    }

    function testBoundaryValuesForSalt() public {
        bytes32 salt1 = bytes32(0);
        bytes32 salt2 = bytes32(type(uint256).max);

        bytes memory creationCode = hex"600a600c600039600a6000f3";
        uint256 value = 0;

        address deployed1 = CREATE3.deploy(salt1, creationCode, value);
        address deployed2 = CREATE3.deploy(salt2, creationCode, value);

        assert(deployed1 != address(0));
        assert(deployed2 != address(0));
    }
}