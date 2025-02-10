// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    event Deployed(address deployed, address expected);

    error CustomError(uint256 value);

    function setUp() public {}

    function testCannotDeployToZeroAddress(bytes32 salt, bytes memory creationCode) public {
        vm.expectRevert();
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testDeploy(bytes32 salt, bytes memory creationCode, uint256 value) public {
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expected);
        emit Deployed(deployed, expected);
    }

    function testDeployAndInit(bytes32 salt, uint256 value) public {
        bytes memory creationCode = abi.encodePacked(
            type(Initializable).creationCode, abi.encodeWithSelector(Initializable.initialize.selector)
        );
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expected);
        assertTrue(Initializable(deployed).initialized());
        emit Deployed(deployed, expected);
    }

    function testDeployMinimalProxy(bytes32 salt, address implementation, uint256 value) public {
        bytes memory creationCode = abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            bytes20(implementation),
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expected);
        emit Deployed(deployed, expected);
    }

    function testFuzzDeployMinimalProxy(
        bytes32 salt,
        address implementation,
        uint256 value,
        bytes calldata data
    ) public {
        vm.assume(implementation != address(0));
        bytes memory creationCode = abi.encodePacked(
            hex"3d602d80600a3d3981f3363d3d373d3d3d363d73",
            bytes20(implementation),
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expected);
        emit Deployed(deployed, expected);
        (bool success, bytes memory returnData) = deployed.delegatecall(data);
        if (success) {
            console2.logBytes(returnData);
        } else {
            console2.log("delegatecall reverted");
        }
    }

    function testDeployFailed(bytes32 salt) public {
        bytes memory creationCode = hex"fe";
        vm.expectRevert(CREATE3.DeploymentFailed.selector);
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testInitializationFailed(bytes32 salt) public {
        bytes memory creationCode = hex"60003d39fd";
        vm.expectRevert(CREATE3.InitializationFailed.selector);
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testInitializationFailed2(bytes32 salt) public {
        bytes memory creationCode = hex"";
        vm.expectRevert(CREATE3.InitializationFailed.selector);
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testCorrectness(bytes32 salt, bytes memory creationCode, uint256 value) public {
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expected);
        emit Deployed(deployed, expected);
    }

    function testDeployLargeContract(bytes32 salt) public {
        bytes memory creationCode = new bytes(49152);
        for (uint256 i; i < creationCode.length; ++i) {
            creationCode[i] = bytes1(uint8(i));
        }
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, 0);
        assertEq(deployed, expected);
        assertEq(deployed.code.length, creationCode.length);
        emit Deployed(deployed, expected);
    }

    function testFuzzCorrectness(bytes32 salt, bytes memory creationCode) public {
        vm.assume(creationCode.length <= 49152);
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, 0);
        assertEq(deployed, expected);
        emit Deployed(deployed, expected);
    }

    function testFuzzCorrectnessWithValue(
        bytes32 salt,
        bytes memory creationCode,
        uint256 value
    ) public {
        vm.assume(creationCode.length <= 49152);
        address expected = CREATE3.getDeployed(salt);
        address deployed = CREATE3.deploy(salt, creationCode, value);
        assertEq(deployed, expected);
        emit Deployed(deployed, expected);
    }
}

contract Initializable {
    bool public initialized;

    function initialize() public {
        require(!initialized);
        initialized = true;
    }
}
