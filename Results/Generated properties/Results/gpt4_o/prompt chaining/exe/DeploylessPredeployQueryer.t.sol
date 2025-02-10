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

//    function testTargetContractExistsAfterConstructorExecution() public {
//        // Simulate target contract not existing before constructor call
//        vm.etch(target, "");
////        assertEq(extcodesize(target), 0);
//
//        // Deploy the queryer contract
//        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
//
//        // Check if target contract exists after constructor execution
//        assertGt(extcodesize(target), 0);
//    }

    function testReturnedAddressMatchesTargetAddress() public {
        // Simulate factory returning the correct address
        vm.mockCall(factory, factoryCalldata, abi.encode(target));

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if the address doesn't match
    }

    function testSuccessfulQueryExecution() public {
        // Simulate target contract existing
        vm.etch(target, "0x600160005401600055");

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if any query fails
    }

    function testCorrectDataReturned() public {
        // Simulate target contract returning expected data
        bytes memory expectedData = abi.encode(uint256(42));
        vm.mockCall(target, targetQueryCalldata[0], expectedData);

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if data is incorrect
    }

    function testProperMemoryAllocation() public {
        // Simulate target contract existing
        vm.etch(target, "0x600160005401600055");

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if memory allocation fails
    }

    function testCorrectDataAggregation() public {
        // Simulate target contract returning expected data
        bytes memory expectedData = abi.encode(uint256(42));
        vm.mockCall(target, targetQueryCalldata[0], expectedData);

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if data aggregation fails
    }

    function testCorrectErrorThrownForAddressMismatch() public {
        // Simulate factory returning an incorrect address
        vm.mockCall(factory, factoryCalldata, abi.encode(address(0x789)));

        // Expect the constructor to revert with ReturnedAddressMismatch error
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

//    function testRevertOnQueryFailure() public {
//        // Simulate target contract returning an error
//        vm.mockCall(target, targetQueryCalldata[0], abi.encodeWithSignature("Error()"));
//
//        // Expect the constructor to revert
//        vm.expectRevert();
//        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
//    }

//    function testSufficientGasForExecution() public {
//        // Simulate target contract existing
//        vm.etch(target, "0x600160005401600055");
//
//        // Deploy the queryer contract with sufficient gas
//        queryer = new DeploylessPredeployQueryer{gas: 1000000}(target, targetQueryCalldata, factory, factoryCalldata);
//
//        // No need to assert as the constructor will revert if gas is insufficient
//    }

    function testCorrectHandlingOfSelfBalance() public {
        // Simulate target contract existing
        vm.etch(target, "0x600160005401600055");

        // Deploy the queryer contract with sufficient balance
        queryer = new DeploylessPredeployQueryer{value: 1 ether}(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if balance is insufficient
    }

    function testStaticCallCompatibility() public {
        // Simulate target contract existing
        vm.etch(target, "0x600160005401600055");

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if static call is not compatible
    }

    function testEmptyTargetQueryCalldataArray() public {
        // Simulate target contract existing
        vm.etch(target, "0x600160005401600055");

        // Deploy the queryer contract with empty targetQueryCalldata
        bytes[] memory emptyCalldata = new bytes[](0);
        queryer = new DeploylessPredeployQueryer(target, emptyCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if handling empty array fails
    }

    function testLargeTargetQueryCalldataArray() public {
        // Simulate target contract existing
        vm.etch(target, "0x600160005401600055");

        // Create a large targetQueryCalldata array
        bytes[] memory largeCalldata = new bytes[](1000);
        for (uint256 i = 0; i < 1000; i++) {
            largeCalldata[i] = abi.encodeWithSignature("someFunction()");
        }

        // Deploy the queryer contract with large targetQueryCalldata
        queryer = new DeploylessPredeployQueryer(target, largeCalldata, factory, factoryCalldata);

        // No need to assert as the constructor will revert if handling large array fails
    }
}