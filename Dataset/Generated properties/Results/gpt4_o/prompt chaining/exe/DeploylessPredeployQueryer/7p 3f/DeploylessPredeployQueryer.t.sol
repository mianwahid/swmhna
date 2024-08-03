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
        target = address(0x123);
        factory = address(0x456);
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("someFunction()");
        factoryCalldata = abi.encodeWithSignature("deployTarget()");
    }

    function testReturnedAddressMismatch() public {
        // Mock the factory to return an incorrect address
        vm.mockCall(factory, factoryCalldata, abi.encode(address(0x789)));
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testTargetContractExists() public {
        // Mock the target contract to exist
        vm.etch(target, hex"00");
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(42)));
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
        // Ensure factory was not called
        vm.expectCall(factory, factoryCalldata, 0);
    }

    function testDeployTargetIfNotExists() public {
        // Mock the factory to deploy the target correctly
        vm.mockCall(factory, factoryCalldata, abi.encode(target));
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(42)));
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testFactoryFailsToDeployTarget() public {
        // Mock the factory to fail
        vm.mockCall(factory, factoryCalldata, "");
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testQueryTargetContract() public {
        // Mock the target contract to return varying lengths of data
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(42)));
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testEmptyTargetQueryCalldata() public {
        // Test with empty targetQueryCalldata
        bytes[] memory emptyCalldata = new bytes[](0);
        queryer = new DeploylessPredeployQueryer(target, emptyCalldata, factory, factoryCalldata);
    }

    function testInvalidTargetQueryCalldata() public {
        // Mock the target contract to revert
        vm.mockCall(target, targetQueryCalldata[0], abi.encodeWithSignature("Error()"));
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testRevertOnFailure() public {
        // Mock the target contract to revert with custom error
        vm.mockCall(target, targetQueryCalldata[0], abi.encodeWithSignature("CustomError()"));
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testFactoryCalldataEmpty() public {
        // Test with empty factoryCalldata
        bytes memory emptyFactoryCalldata = new bytes(0);
        vm.mockCall(factory, emptyFactoryCalldata, abi.encode(target));
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(42)));
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, emptyFactoryCalldata);
    }

    function testInvalidTargetQueryCalldataFormat() public {
        // Test with non-ABI encoded data in targetQueryCalldata
        bytes[] memory invalidCalldata = new bytes[](1);
        invalidCalldata[0] = hex"1234";
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, invalidCalldata, factory, factoryCalldata);
    }
}