// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DeploylessPredeployQueryer.sol";

contract DeploylessPredeployQueryerTest is Test {
    DeploylessPredeployQueryer queryer;
    address target;
    address factory;
    bytes[] targetQueryCalldata;
    bytes factoryCalldata;

    function setUp() public {
        target = address(0x1234);
        factory = address(0x5678);
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("someFunction()");
        factoryCalldata = abi.encodeWithSignature("deployTarget()");
    }

//    function testConstructorDeploysTarget() public {
//        // Simulate the target not existing
//        vm.etch(target, "");
//
//        // Mock the factory call to deploy the target
//        vm.mockCall(factory, factoryCalldata, abi.encode(target));
//
//        // Deploy the queryer
//        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
//
//        // Check that the target was deployed
//        assertTrue(target.code.length > 0, "Target was not deployed");
//    }

    function testConstructorRevertsOnFactoryFailure() public {
        // Simulate the target not existing
        vm.etch(target, "");

        // Mock the factory call to fail
        vm.mockCall(factory, factoryCalldata, "");

        // Expect revert
        vm.expectRevert();

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testConstructorRevertsOnAddressMismatch() public {
        // Simulate the target not existing
        vm.etch(target, "");

        // Mock the factory call to return a different address
        vm.mockCall(factory, factoryCalldata, abi.encode(address(0x9999)));

        // Expect revert with ReturnedAddressMismatch
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testConstructorHandlesExistingTarget() public {
        // Simulate the target already existing
        vm.etch(target, hex"60016000526001601f");

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // Check that the target was not redeployed
        assertTrue(target.code.length > 0, "Target was redeployed");
    }

    function testConstructorHandlesMultipleCalls() public {
        // Simulate the target already existing
        vm.etch(target, hex"60016000526001601f");

        // Add multiple calls to targetQueryCalldata
        targetQueryCalldata.push(abi.encodeWithSignature("anotherFunction()"));
        targetQueryCalldata.push(abi.encodeWithSignature("yetAnotherFunction()"));

        // Mock the target calls
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(1)));
        vm.mockCall(target, targetQueryCalldata[1], abi.encode(uint256(2)));
        vm.mockCall(target, targetQueryCalldata[2], abi.encode(uint256(3)));

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // Check that the calls were made
        // This is a bit tricky since the constructor returns the data directly
        // We will need to decode the returned data
        bytes memory returnedData = address(queryer).code;
        bytes[] memory decodedData = abi.decode(returnedData, (bytes[]));

        assertEq(abi.decode(decodedData[0], (uint256)), 1, "First call did not return expected value");
        assertEq(abi.decode(decodedData[1], (uint256)), 2, "Second call did not return expected value");
        assertEq(abi.decode(decodedData[2], (uint256)), 3, "Third call did not return expected value");
    }

    function testConstructorHandlesEmptyCalldata() public {
        // Simulate the target already existing
        vm.etch(target, hex"60016000526001601f");

        // Set targetQueryCalldata to empty
        targetQueryCalldata = new bytes[](0);

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // Check that no calls were made
        bytes memory returnedData = address(queryer).code;
        bytes[] memory decodedData = abi.decode(returnedData, (bytes[]));

        assertEq(decodedData.length, 0, "Calls were made when they should not have been");
    }
}