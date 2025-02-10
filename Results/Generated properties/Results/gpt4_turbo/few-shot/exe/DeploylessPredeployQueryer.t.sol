// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/DeploylessPredeployQueryer.sol";

contract DeploylessPredeployQueryerTest is Test {
    DeploylessPredeployQueryer queryer;
    address target;
    address factory;
    bytes[] targetQueryCalldata;
    bytes factoryCalldata;

    function setUp() public {
        // Setup a mock target and factory address
        target = address(new MockContract());
        factory = address(new MockFactory());

        // Example calldata for target queries
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("getValue()");

        // Example calldata for factory deployment
        factoryCalldata = abi.encodeWithSignature("deploy(address)", target);

        // Deploy the queryer contract
        queryer = new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
    }

//    function testQueryExecution() public {
//        // Simulate a call to the queryer and check the response
//        (bool success, bytes memory data) = address(queryer).call(
//            abi.encodeWithSignature("constructor(address,bytes[],address,bytes)", target, targetQueryCalldata, factory, factoryCalldata)
//        );
//
//        assertTrue(success, "Query execution failed");
//        uint256 returnedValue = abi.decode(data, (uint256));
//        assertEq(returnedValue, 42, "Returned value does not match expected");
//    }

//    function testFactoryInteraction() public {
//        // Check if the factory was interacted with correctly
//        MockFactory mockFactory = MockFactory(factory);
//        assertTrue(mockFactory.deployed(), "Factory did not deploy the contract as expected");
//    }

    function testReturnedAddressMismatch() public {
        // Test the custom error for address mismatch
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        new DeploylessPredeployQueryer(
            address(0xdead),
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
    }
}

// Mock contract to simulate target behavior
contract MockContract {
    function getValue() external pure returns (uint256) {
        return 42;
    }
}

// Mock factory to simulate deployment behavior
contract MockFactory {
    bool private _deployed;

    function deploy(address _target) external returns (address) {
        _deployed = true;
        return _target; // Simulate successful deployment
    }

    function deployed() external view returns (bool) {
        return _deployed;
    }
}