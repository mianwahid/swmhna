// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    using CREATE3 for bytes32;

    event Deployed(address indexed deployedAddress);

    function testSuccessfulDeployment() public {
        bytes32 salt = keccak256(abi.encodePacked("testSalt"));
        bytes memory creationCode = type(SimpleContract).creationCode;
        uint256 value = 0;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        emit Deployed(deployed);

        assert(deployed != address(0));
        assertEq(deployed.code.length, creationCode.length);
    }

    function testSuccessfulDeploymentWithValue() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltWithValue"));
        bytes memory creationCode = type(SimpleContract).creationCode;
        uint256 value = 1 ether;

        address deployed = CREATE3.deploy(salt, creationCode, value);
        emit Deployed(deployed);

        assert(deployed != address(0));
        assertEq(deployed.code.length, creationCode.length);
        assertEq(deployed.balance, value);
    }

    function testDeploymentFailure() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltFailure"));
        bytes memory creationCode = new bytes(0); // Invalid creation code

        vm.expectRevert(CREATE3.DeploymentFailed.selector);
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testInitializationFailure() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltInitFailure"));
        bytes memory creationCode = type(FailingContract).creationCode;

        vm.expectRevert(CREATE3.InitializationFailed.selector);
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testZeroCodeSize() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltZeroCodeSize"));
        bytes memory creationCode = type(ZeroCodeSizeContract).creationCode;

        vm.expectRevert(CREATE3.InitializationFailed.selector);
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testDeterministicAddressCalculation() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltAddressCalc"));
        bytes memory creationCode = type(SimpleContract).creationCode;
        uint256 value = 0;

        address expectedAddress = CREATE3.getDeployed(salt, address(this));
        address deployed = CREATE3.deploy(salt, creationCode, value);

        assertEq(deployed, expectedAddress);
    }

    function testCorrectAddressCalculationWithDeployer() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltWithDeployer"));
        address deployer = address(this);

        address expectedAddress = CREATE3.getDeployed(salt, deployer);
        assert(expectedAddress != address(0));
    }

    function testCorrectAddressCalculationWithoutDeployer() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltWithoutDeployer"));

        address expectedAddress = CREATE3.getDeployed(salt);
        assert(expectedAddress != address(0));
    }

    function testGasConsumption() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltGas"));
        bytes memory creationCode = type(SimpleContract).creationCode;

        uint256 gasStart = gasleft();
        CREATE3.deploy(salt, creationCode, 0);
        uint256 gasUsed = gasleft() - gasStart;

        console2.log("Gas used for deployment:", gasUsed);
    }

    function testReentrancy() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltReentrancy"));
        bytes memory creationCode = type(ReentrantContract).creationCode;

        vm.expectRevert("ReentrancyGuard: reentrant call");
        CREATE3.deploy(salt, creationCode, 0);
    }

    function testStatePreservation() public {
        bytes32 salt = keccak256(abi.encodePacked("testSaltState"));
        bytes memory creationCode = type(SimpleContract).creationCode;

        uint256 initialBalance = address(this).balance;
        CREATE3.deploy(salt, creationCode, 0);
        uint256 finalBalance = address(this).balance;

        assertEq(initialBalance, finalBalance);
    }
}

contract SimpleContract {
    // A simple contract for testing purposes
}

contract FailingContract {
    constructor() {
        revert("Initialization failed");
    }
}

contract ZeroCodeSizeContract {
    // A contract that results in zero code size
}

contract ReentrantContract {
    constructor() {
        CREATE3.deploy(keccak256(abi.encodePacked("reentrant")), type(SimpleContract).creationCode, 0);
    }
}