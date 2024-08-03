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
        factoryCalldata = abi.encodeWithSignature("deploy(address)", target);
    }

    function testReturnedAddressMismatch() public {
        // Mock the factory to return a different address
        vm.mockCall(factory, factoryCalldata, abi.encode(address(0x789)));
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testTargetContractDeployment() public {
        // Mock the factory to return the correct address
        vm.mockCall(factory, factoryCalldata, abi.encode(target));
        // Ensure the target contract does not exist initially
        vm.etch(target, "");
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
        // Ensure the target contract is deployed
        assertTrue(target.code.length > 0);
    }

    function testFactoryCallSuccess() public {
        // Mock the factory to return the correct address
        vm.mockCall(factory, factoryCalldata, abi.encode(target));
        // Ensure the factory call succeeds
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testFactoryCallFailureDueToGas() public {
        // Mock the factory to fail due to insufficient gas
        vm.mockCall(factory, factoryCalldata, "");
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testFactoryCallFailureDueToIncorrectCalldata() public {
        // Mock the factory to fail due to incorrect calldata
        bytes memory incorrectCalldata = abi.encodeWithSignature("wrongFunction()");
        vm.mockCall(factory, incorrectCalldata, "");
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, incorrectCalldata);
    }

    function testFactoryCallFailureDueToNonExistentFactory() public {
        // Mock the factory to be non-existent
        address nonExistentFactory = address(0x0);
        vm.expectRevert();
        new DeploylessPredeployQueryer(target, targetQueryCalldata, nonExistentFactory, factoryCalldata);
    }

    function testFactoryCallReturnData() public {
        // Mock the factory to return an incorrect address
        vm.mockCall(factory, factoryCalldata, abi.encode(address(0x789)));
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testQueryTargetContract() public {
        // Mock the factory to return the correct address
        vm.mockCall(factory, factoryCalldata, abi.encode(target));
        // Mock the target contract to respond to the query
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(42)));
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testReturnDataFormat() public {
        // Mock the factory to return the correct address
        vm.mockCall(factory, factoryCalldata, abi.encode(target));
        // Mock the target contract to respond with varying lengths of data
        vm.mockCall(target, targetQueryCalldata[0], abi.encode(uint256(42)));
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testMemorySafety() public {
        // Test with empty targetQueryCalldata
        bytes[] memory emptyCalldata = new bytes[](0);
        new DeploylessPredeployQueryer(target, emptyCalldata, factory, factoryCalldata);

        // Test with very large targetQueryCalldata
        bytes[] memory largeCalldata = new bytes[](1);
        largeCalldata[0] = new bytes(2**16);
        new DeploylessPredeployQueryer(target, largeCalldata, factory, factoryCalldata);

        // Test with empty factoryCalldata
        bytes memory emptyFactoryCalldata = new bytes(0);
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, emptyFactoryCalldata);

        // Test with very large factoryCalldata
        bytes memory largeFactoryCalldata = new bytes(2**16);
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, largeFactoryCalldata);
    }

//    function testGasUsage() public {
//        // Test with minimal gas
//        vm.expectRevert();
////        vm.prank(address(this), address(this).balance - 1);
//        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
//
//        // Test with excessive gas
//        new DeploylessPredeployQueryer{gas: gasleft()}(target, targetQueryCalldata, factory, factoryCalldata);
//
//        // Test with multiple queries
//        bytes[] memory multipleQueries = new bytes[](3);
//        multipleQueries[0] = abi.encodeWithSignature("function1()");
//        multipleQueries[1] = abi.encodeWithSignature("function2()");
//        multipleQueries[2] = abi.encodeWithSignature("function3()");
//        new DeploylessPredeployQueryer(target, multipleQueries, factory, factoryCalldata);
//    }
}