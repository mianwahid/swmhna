// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/DeploylessPredeployQueryer.sol";

contract DeploylessPredeployQueryerTest is Test {
    DeploylessPredeployQueryer queryer;
    address target;
    address factory;
    bytes[] targetQueryCalldata;
    bytes factoryCalldata;

    function setUp() public {
        target = address(0x123);
        factory = address(this); // Mock factory address as this contract
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("testFunction()");
        factoryCalldata = abi.encodeWithSignature("deployMock(address)", target);
    }

    function deployMock(address _target) external returns (address) {
        return _target; // Mock deployment function
    }

    function testConstructorWithExistingTarget() public {
        vm.etch(target, bytes("0x00")); // Pretend that the target already has code
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testConstructorWithNonExistingTarget() public {
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testConstructorWithFactoryReturningWrongAddress() public {
        bytes memory wrongFactoryCalldata = abi.encodeWithSignature("deployWrongMock(address)", target);
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, wrongFactoryCalldata);
    }

    function deployWrongMock(address _target) external returns (address) {
        return address(0x456); // Return a wrong address
    }

    function testQueryExecution() public {
        vm.etch(target, bytes("0x00")); // Pretend that the target already has code
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
        (bool success, bytes memory data) = address(queryer).call(targetQueryCalldata[0]);
        assertTrue(success, "Query execution failed");
    }

    function testQueryExecutionFailure() public {
        vm.etch(target, bytes("0x00")); // Pretend that the target already has code
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
        bytes memory failingCalldata = abi.encodeWithSignature("nonExistentFunction()");
        vm.expectRevert("function selector was not recognized and there's no fallback function");
        address(queryer).call(failingCalldata);
    }
}
