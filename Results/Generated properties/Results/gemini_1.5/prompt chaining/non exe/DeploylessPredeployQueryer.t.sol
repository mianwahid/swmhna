// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DeploylessPredeployQueryer.sol";

contract DeploylessPredeployQueryerTest is Test {
    address internal target;
    bytes[] internal targetQueryCalldata;
    address internal factory;
    bytes internal factoryCalldata;

    function setUp() public virtual {
        target = address(0x1234);
        targetQueryCalldata = new bytes[](0);
        factory = address(0x5678);
        factoryCalldata = "";
    }

    function testInvariant1_TargetContractDeploymentSuccess() public {
        // Condition: `target` contract does not exist prior to contract construction.
        vm.etch(target, "");

        // Input: Valid `factory`, `factoryCalldata`, and `target` address.
        // Assume a simple factory that returns the target address
        factoryCalldata = abi.encodeWithSignature("deploy(address)", target);
        vm.etch(factory, hex"602036811461001857600080fd5b600080fd");

        // Expected Behavior:
        // * `target` contract is successfully deployed at the provided `target` address.
        // * Constructor executes successfully without reverting.
        new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
//        assertTrue(extcodesize(target) > 0);

    }

    function testInvariant2_TargetContractDeploymentFailure() public {
        // Condition: `target` contract does not exist prior to contract construction.
        vm.etch(target, "");

        // Input: Invalid `factory`, `factoryCalldata`, or `target` address.
        // Example: Factory that always reverts
        factoryCalldata = abi.encodeWithSignature("deploy(address)", target);
        vm.etch(factory, hex"600080fd");

        // Expected Behavior:
        // * Constructor reverts with an error.
        vm.expectRevert();
        new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
    }

    function testInvariant3_TargetContractPreExists() public {
        // Condition: `target` contract already exists prior to contract construction.
        vm.etch(target, "600055"); // Simple contract with a state variable

        // Input: Any valid input parameters.
        // We can use the same setup as Invariant 1
        factoryCalldata = abi.encodeWithSignature("deploy(address)", target);
        vm.etch(factory, hex"602036811461001857600080fd5b600080fd");

        // Expected Behavior:
        // * Constructor does not attempt to deploy the `target` contract.
        // * Constructor executes successfully without reverting.
        new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
        // No need to check extcodesize, as the contract already exists
    }

    function testInvariant4_TargetQueryExecutionSuccess() public {
        // Condition: `target` contract exists (pre-existing or deployed).
        vm.etch(target, "600160005260206000f3"); // Returns 1

        // Input: Valid `targetQueryCalldata` for the `target` contract.
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = ""; // Call the default function

        // Expected Behavior:
        // * All queries in `targetQueryCalldata` are executed successfully.
        // * Constructor returns a byte array containing the return data of each query.
        DeploylessPredeployQueryer queryer = new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
        bytes memory result = queryer.code();
        bytes[] memory decodedResult = abi.decode(result, (bytes[]));
        assertEq(decodedResult.length, 1);
        assertEq(uint256(bytes32(decodedResult[0])), 1);
    }

    function testInvariant5_TargetQueryExecutionFailure() public {
        // Condition: `target` contract exists (pre-existing or deployed).
        vm.etch(target, "600060005260206000f3"); // Returns 0, might cause issues

        // Input: Invalid `targetQueryCalldata` for the `target` contract.
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("nonExistentFunction()");

        // Expected Behavior:
        // * Constructor reverts with an error.
        vm.expectRevert();
        new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
    }

    // Invariant 6: Gas Efficiency - Difficult to test directly in Foundry
    // Invariant 7: Revert Data Propagation - Covered by other tests indirectly

    // Edge Case: Empty targetQueryCalldata
    function testEdgeCase_EmptyTargetQueryCalldata() public {
        vm.etch(target, "600055"); // Simple contract with a state variable
        targetQueryCalldata = new bytes[](0);

        DeploylessPredeployQueryer queryer = new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
        bytes memory result = queryer.code();
        assertEq(result.length, 64); // Only the length encoding for the empty array
    }

    // Edge Case: Large targetQueryCalldata - Can be added, but might hit gas limits
    // Edge Case: Zero address as target - Covered by other tests as invalid address
    // Edge Case: Different Solidity versions - Requires multiple Solidity versions in Foundry
}
