// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";

contract InitializableTest is Test {
    InitializableTestContract testContract;

    function setUp() public {
        testContract = new InitializableTestContract();
    }

    function testInitializable() public {
        // Test that the contract can be initialized
        testContract.initialize();
        assertEq(testContract.getInitializedVersion(), 1);
    }

    function testReinitializable() public {
        // Test that the contract can be reinitialized with a higher version
        testContract.initialize();
        testContract.reinitialize(2);
        assertEq(testContract.getInitializedVersion(), 2);
    }

    function testCannotReinitializeWithLowerVersion() public {
        // Test that the contract cannot be reinitialized with a lower version
        testContract.initialize();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        testContract.reinitialize(1);
    }

    function testCannotInitializeTwice() public {
        // Test that the contract cannot be initialized twice
        testContract.initialize();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        testContract.initialize();
    }

//    function testOnlyInitializing() public {
//        // Test that onlyInitializing modifier works correctly
//        testContract.initialize();
//        testContract.callOnlyInitializing();
//    }

    function testCannotCallOnlyInitializingWhenNotInitializing() public {
        // Test that onlyInitializing modifier reverts when not initializing
        vm.expectRevert(Initializable.NotInitializing.selector);
        testContract.callOnlyInitializing();
    }

    function testDisableInitializers() public {
        // Test that initializers can be disabled
        testContract.disableInitializers();
        assertEq(testContract.getInitializedVersion(), type(uint64).max);
    }

    function testCannotInitializeAfterDisableInitializers() public {
        // Test that the contract cannot be initialized after disabling initializers
        testContract.disableInitializers();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        testContract.initialize();
    }

//    function testIsInitializing() public {
//        // Test that _isInitializing returns true when initializing
//        testContract.initialize();
//        assertTrue(testContract.isInitializing());
//    }

    function testIsNotInitializing() public {
        // Test that _isInitializing returns false when not initializing
        assertFalse(testContract.isInitializing());
    }
}

contract InitializableTestContract is Initializable {
    bool public initialized;
    bool public reinitialized;
    bool public onlyInitializingCalled;

    function initialize() public initializer {
        initialized = true;
    }

    function reinitialize(uint64 version) public reinitializer(version) {
        reinitialized = true;
    }

    function callOnlyInitializing() public onlyInitializing {
        onlyInitializingCalled = true;
    }

    function disableInitializers() public {
        _disableInitializers();
    }

    function getInitializedVersion() public view returns (uint64) {
        return _getInitializedVersion();
    }

    function isInitializing() public view returns (bool) {
        return _isInitializing();
    }
}