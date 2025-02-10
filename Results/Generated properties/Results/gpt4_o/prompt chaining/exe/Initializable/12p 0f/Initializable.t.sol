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

    // 1.1.1: The `initializer` modifier should only allow the function to be called once.
    function testInitializerModifierOnlyOnce() public {
        testContract.initialize();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        testContract.initialize();
    }

    // 1.1.2: The `initializer` modifier should set the `initializing` flag to 1 during execution and reset it to 0 after execution.
    function testInitializerModifierFlag() public {
        assertEq(testContract.isInitializing(), false);
        testContract.initialize();
        assertEq(testContract.isInitializing(), false);
    }

    // 1.1.3: The `initializer` modifier should set the `initializedVersion` to 1 after execution.
    function testInitializerModifierVersion() public {
        assertEq(testContract.getInitializedVersion(), 0);
        testContract.initialize();
        assertEq(testContract.getInitializedVersion(), 1);
    }

    // 1.2.1: The `reinitializer` modifier should only allow the function to be called once per version.
    function testReinitializerModifierOnlyOncePerVersion() public {
        testContract.reinitialize(2);
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        testContract.reinitialize(2);
    }

    // 1.2.2: The `reinitializer` modifier should set the `initializing` flag to 1 during execution and reset it to 0 after execution.
    function testReinitializerModifierFlag() public {
        testContract.reinitialize(2);
        assertEq(testContract.isInitializing(), false);
    }

    // 1.2.3: The `reinitializer` modifier should set the `initializedVersion` to the provided version after execution.
    function testReinitializerModifierVersion() public {
        testContract.reinitialize(2);
        assertEq(testContract.getInitializedVersion(), 2);
    }

    // 2.1.1: The `onlyInitializing` modifier should only allow the function to be called during the initialization process.
    function testOnlyInitializingModifier() public {
        vm.expectRevert(Initializable.NotInitializing.selector);
        testContract.onlyInitializingFunction();
    }

    // 3.1.1: The `_disableInitializers` function should set the `initializedVersion` to `2**64 - 1`.
    function testDisableInitializersVersion() public {
        testContract.disableInitializers();
        assertEq(testContract.getInitializedVersion(), type(uint64).max);
    }

    // 3.1.2: The `_disableInitializers` function should emit the `Initialized` event with the version `2**64 - 1` the first time it is called.
    function testDisableInitializersEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Initializable.Initialized(type(uint64).max);
        testContract.disableInitializers();
    }

    // 4.1.1: The `_getInitializedVersion` function should return the correct `initializedVersion`.
    function testGetInitializedVersion() public {
        assertEq(testContract.getInitializedVersion(), 0);
        testContract.initialize();
        assertEq(testContract.getInitializedVersion(), 1);
    }

    // 4.2.1: The `_isInitializing` function should return the correct `initializing` flag.
    function testIsInitializing() public {
        assertEq(testContract.isInitializing(), false);
        testContract.initialize();
        assertEq(testContract.isInitializing(), false);
    }

    // 5.1.1: The `_initializableSlot` function should return the correct storage slot.
    function testInitializableSlot() public {
        assertEq(testContract.initializableSlot(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffbf601132);
    }
}

contract InitializableTestContract is Initializable {
    function initialize() public initializer {
        // Initialization logic
    }

    function reinitialize(uint64 version) public reinitializer(version) {
        // Reinitialization logic
    }

    function onlyInitializingFunction() public onlyInitializing {
        // Function logic
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

    function initializableSlot() public pure returns (bytes32) {
        return _initializableSlot();
    }
}