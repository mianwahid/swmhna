// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";

contract InitializableTest is Test {
    InitializableMock initializable;

    event Initialized(uint64 version);

    function setUp() public {
        initializable = new InitializableMock();
    }

    // Test that _initializableSlot() returns the same value on every call
    function test_InitializableSlotImmutability() public {
        bytes32 slot1 = initializable._initializableSlot();
        bytes32 slot2 = initializable._initializableSlot();
        assertEq(slot1, slot2, "Initializable slot should be immutable");
    }

    // Test that initializer modifier only allows initialization once
    function test_InitializerOnce() public {
        initializable.initialize();
        vm.expectRevert(InitializableMock.InvalidInitialization.selector);
        initializable.initialize();
    }

    // Test that reinitializer modifier only allows initialization with higher version
    function test_ReinitializerVersionCheck() public {
        initializable.initialize(); // version 1
        vm.expectRevert(InitializableMock.InvalidInitialization.selector);
        initializable.reinitialize(0);
        vm.expectRevert(InitializableMock.InvalidInitialization.selector);
        initializable.reinitialize(1);
        initializable.reinitialize(2); // version 2
        assertEq(
            initializable._getInitializedVersion(),
            2,
            "Reinitializer should update version correctly"
        );
    }

    // Test that onlyInitializing modifier restricts access outside initialization
    function test_OnlyInitializingRestriction() public {
        vm.expectRevert(InitializableMock.NotInitializing.selector);
        initializable.onlyInitializingFunction();
    }

    // Test that _disableInitializers() prevents further initialization
    function test_DisableInitializers() public {
        initializable._disableInitializers();
        vm.expectRevert(InitializableMock.InvalidInitialization.selector);
        initializable.initialize();
        vm.expectRevert(InitializableMock.InvalidInitialization.selector);
        initializable.reinitialize(2);
    }

    // Test that _disableInitializers() sets version to max uint64
    function test_DisableInitializersVersion() public {
        initializable._disableInitializers();
        assertEq(
            initializable._getInitializedVersion(),
            type(uint64).max,
            "_disableInitializers should set max version"
        );
    }

    // Test that _isInitializing returns correct values
    function test_IsInitializing() public {
        assertTrue(!initializable._isInitializing());
        initializable.initialize();
        assertTrue(!initializable._isInitializing());
    }

    // Test that Initialized event is emitted correctly
    function test_InitializedEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Initialized(1);
        initializable.initialize();

        vm.expectEmit(true, true, true, true);
        emit Initialized(5);
        initializable.reinitialize(5);
    }

    // Test reinitializer with zero version
    function test_ReinitializerZeroVersion() public {
        vm.expectRevert(InitializableMock.InvalidInitialization.selector);
        initializable.reinitialize(0);
    }

    // Test reinitializer with max uint64
    function test_ReinitializerMaxUint64() public {
        initializable.initialize();
        initializable.reinitialize(type(uint64).max);
        assertEq(
            initializable._getInitializedVersion(),
            type(uint64).max,
            "Reinitializer should handle max uint64 correctly"
        );
    }

    // Test error messages
    function test_ErrorMessages() public {
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        new InitializableMock().initialize();
        vm.expectRevert(abi.encodeWithSelector(Initializable.NotInitializing.selector));
        new InitializableMock().onlyInitializingFunction();
    }
}

contract InitializableMock is Initializable {
    uint256 public x;

    function initialize() public initializer {
        x = 1;
    }

    function reinitialize(uint64 version) public reinitializer(version) {
        x = 2;
    }

    function onlyInitializingFunction() public onlyInitializing {}

    function _initializableSlot() internal pure override returns (bytes32) {
        return super._initializableSlot();
    }

    function _getInitializedVersion()
        internal
        view
        override
        returns (uint64 version)
    {
        return super._getInitializedVersion();
    }

    function _isInitializing() internal view override returns (bool result) {
        return super._isInitializing();
    }
}
