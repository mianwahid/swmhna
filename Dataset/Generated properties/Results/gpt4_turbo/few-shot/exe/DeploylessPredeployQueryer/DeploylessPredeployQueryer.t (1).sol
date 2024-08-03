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
        target = address(new MockContract());
        factory = address(new MockFactory());
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSelector(MockContract.someFunction.selector);
        factoryCalldata = abi.encodeWithSelector(MockFactory.deployMock.selector);
        queryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    }

    function testQueryReturnsExpectedResult() public {
        bytes memory result = address(queryer).code;
        bytes[] memory decodedResults = abi.decode(result, (bytes[]));
        uint256 returnedValue = abi.decode(decodedResults[0], (uint256));
        assertEq(returnedValue, 42, "The returned value should match the expected result.");
    }

    function testQueryWithNonExistentTarget() public {
        address nonExistentTarget = address(0xdead);
        DeploylessPredeployQueryer newQueryer = new DeploylessPredeployQueryer(
            nonExistentTarget,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
        bytes memory result = address(newQueryer).code;
        bytes[] memory decodedResults = abi.decode(result, (bytes[]));
        uint256 returnedValue = abi.decode(decodedResults[0], (uint256));
        assertEq(returnedValue, 42, "The returned value should match the expected result even with a non-existent target.");
    }

    function testQueryRevertsOnMismatch() public {
        bytes memory badFactoryCalldata = abi.encodeWithSelector(MockFactory.deployBadMock.selector);
        vm.expectRevert(DeploylessPredeployQueryer.ReturnedAddressMismatch.selector);
        new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, badFactoryCalldata);
    }


}


    // Mock contracts for testing
    contract MockContract {
        function someFunction() external pure returns (uint256) {
            return 42;
        }
    }


    contract MockFactory {
        function deployMock() external  returns (address) {
            return address(new MockContract());
        }

        function deployBadMock() external pure returns (address) {
            return address(0x123456); // Intentionally wrong address
        }
    }