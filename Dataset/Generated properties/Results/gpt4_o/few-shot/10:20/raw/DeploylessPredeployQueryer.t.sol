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
        // Initialize the target, factory, targetQueryCalldata, and factoryCalldata
        target = address(0x1234);
        factory = address(0x5678);
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("someFunction()");
        factoryCalldata = abi.encodeWithSignature("deploy(address)", target);
    }

    function testConstructorDeploysTarget() public {
        // Ensure the target does not exist initially
        vm.etch(target, "");

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // Check that the target was deployed
        assertTrue(target.code.length > 0, "Target contract was not deployed");
    }

    function testConstructorReturnsCorrectData() public {
        // Mock the target contract to return specific data
        bytes memory returnData = abi.encode(uint256(42));
        vm.mockCall(target, targetQueryCalldata[0], returnData);

        // Deploy the queryer
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // Decode the returned data from the queryer
        bytes[] memory returnedData = abi.decode(address(queryer).code, (bytes[]));
        uint256 returnedValue = abi.decode(returnedData[0], (uint256));

        // Check that the returned data is correct
        assertEq(returnedValue, 42, "Returned data does not match expected value");
    }

    function testConstructorRevertsOnAddressMismatch() public {
        // Mock the factory to return a different address
        address wrongAddress = address(0x9999);
        bytes memory wrongReturnData = abi.encode(wrongAddress);
        vm.mockCall(factory, factoryCalldata, wrongReturnData);

        // Expect the constructor to revert with ReturnedAddressMismatch
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testConstructorRevertsOnFactoryCallFailure() public {
        // Mock the factory call to fail
        vm.mockCallRevert(factory, factoryCalldata, "Factory call failed");

        // Expect the constructor to revert with the factory call failure message
        vm.expectRevert(bytes("Factory call failed"));
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testConstructorRevertsOnTargetCallFailure() public {
        // Mock the target call to fail
        vm.mockCallRevert(target, targetQueryCalldata[0], "Target call failed");

        // Expect the constructor to revert with the target call failure message
        vm.expectRevert(bytes("Target call failed"));
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }
}