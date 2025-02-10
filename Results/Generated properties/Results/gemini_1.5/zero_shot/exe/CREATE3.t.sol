// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/CREATE3.sol";

contract CREATE3Test is Test {
    bytes32 internal salt = keccak256(abi.encodePacked("Solady"));

    function testDeploy() public {
        address deployed = CREATE3.deploy(salt, vm.getCode("TestContract"), 0);
        assertTrue(deployed != address(0));
    }

    function testGetDeployed() public {
        address expected = CREATE3.deploy(salt, vm.getCode("TestContract"), 0);
        address actual = CREATE3.getDeployed(salt);
        assertEq(actual, expected);
    }

    function testDeployAndCall() public {
        address deployed = CREATE3.deploy(salt, vm.getCode("TestContract"), 0);
        (bool success, bytes memory result) = deployed.call(abi.encodeWithSignature("test()"));
        assertTrue(success);
        assertEq(result, abi.encode(true));
    }

//    function testDeployWithFunds() public {
//        uint256 value = 1 ether;
//        address deployed = CREATE3.deploy(salt, vm.getCode("TestContract"), value);
//        assertEq(deployed.balance, value);
//    }

//    function testDeployWithSaltCollision() public {
//        CREATE3.deploy(salt, vm.getCode("TestContract"), 0);
//        vm.expectRevert();
//        CREATE3.deploy(salt, vm.getCode("TestContract"), 0);
//    }

//    function testDeployWithEmptyCreationCode() public {
//        vm.expectRevert();
//        CREATE3.deploy(salt, "", 0);
//    }

//    function testDeployWithInvalidCreationCode() public {
//        vm.expectRevert();
//        CREATE3.deploy(salt, abi.encodePacked(bytes1(0xfe)), 0);
//    }

//    function testFuzz_Deploy(bytes32 _salt, bytes memory _creationCode, uint256 _value) public {
//        vm.assume(_creationCode.length > 0);
//        vm.assume(_creationCode.length < 10000);
//
//        address deployed = CREATE3.deploy(_salt, _creationCode, _value);
//
//        if (_creationCode.length > 0) {
//            assertTrue(deployed != address(0));
//        } else {
//            assertEq(deployed, address(0));
//        }
//    }
}

contract TestContract {
    function test() public pure returns (bool) {
        return true;
    }
}