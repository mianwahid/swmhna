// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/DeploylessPredeployQueryer.sol";

contract DeploylessPredeployQueryerTest is Test {
    DeploylessPredeployQueryer deploylessPredeployQueryer;
    address target;
    bytes[] targetQueryCalldata;
    address factory;
    bytes factoryCalldata;

    function setUp() public {
        target = address(0x123);
        factory = address(0x456);
        factoryCalldata = abi.encodeWithSignature("createContract()");
        targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("getValue()");
    }

    function testConstructorWithExistingTarget() public {
        vm.assume(target != address(0));
        vm.assume(factory != address(0));
        vm.mockCall(
            target,
            abi.encodeWithSelector(bytes4(keccak256("getValue()"))),
            abi.encode(uint256(123))
        );
        vm.mockCall(factory, factoryCalldata, abi.encode(target));

        deploylessPredeployQueryer = new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
    }

    function testConstructorWithNonExistingTarget() public {
        vm.assume(target != address(0));
        vm.assume(factory != address(0));
        vm.mockCall(
            target,
            abi.encodeWithSelector(bytes4(keccak256("getValue()"))),
            abi.encode(uint256(123))
        );
        vm.mockCall(factory, factoryCalldata, abi.encode(target));

        // Simulate target not existing
        vm.etch(target, bytes(""));

        deploylessPredeployQueryer = new DeploylessPredeployQueryer(
            target,
            targetQueryCalldata,
            factory,
            factoryCalldata
        );
    }

    // function testConstructorWithFactoryFailing() public {
    //     vm.assume(target != address(0));
    //     vm.assume(factory != address(0));
    //     vm.mockCall(target, abi.encodeWithSelector(bytes4(keccak256("getValue()"))), abi.encode(uint256(123)));
    //     vm.mockCall(factory, factoryCalldata, bytes(""));

    //     vm.expectRevert("ReturnedAddressMismatch()");
    //     deploylessPredeployQueryer = new DeploylessPredeployQueryer(target, targetQueryCalldata, factory, factoryCalldata);
    // }

    // function testConstructorWithFactoryReturningWrongAddress() public {
    //     vm.assume(target != address(0));
    //     vm.assume(factory != address(0));
    //     vm.mockCall(
    //         target,
    //         abi.encodeWithSelector(bytes4(keccak256("getValue()"))),
    //         abi.encode(uint256(123))
    //     );
    //     address wrongAddress = address(0x789);
    //     vm.mockCall(factory, factoryCalldata, abi.encode(wrongAddress));

    //     vm.expectRevert("ReturnedAddressMismatch()");
    //     deploylessPredeployQueryer = new DeploylessPredeployQueryer(
    //         target,
    //         targetQueryCalldata,
    //         factory,
    //         factoryCalldata
    //     );
    // }

    // function testConstructorWithInvalidCalldata() public {
    //     vm.assume(target != address(0));
    //     vm.assume(factory != address(0));
    //     // Simulate invalid calldata causing the call to fail
    //     vm.mockCall(
    //         target,
    //         abi.encodeWithSelector(bytes4(keccak256("getValue()"))),
    //         bytes("")
    //     );
    //     vm.mockCall(factory, factoryCalldata, abi.encode(target));

    //     vm.expectRevert();
    //     deploylessPredeployQueryer = new DeploylessPredeployQueryer(
    //         target,
    //         targetQueryCalldata,
    //         factory,
    //         factoryCalldata
    //     );
    // }
}
