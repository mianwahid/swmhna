// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";

contract MockInitializable is Initializable {
    uint256 public number;

    function initialize(uint256 _number) external initializer {
        number = _number;
    }

    function reinitialize(uint256 _number) external reinitializer(2) {
        number = _number;
    }

    function setNumber(uint256 _number) external onlyInitializing {
        number = _number;
    }

    function disable() external {
        _disableInitializers();
    }
}

contract InitializableTest is Test {
    MockInitializable public mock;

    function setUp() public {
        mock = new MockInitializable();
    }

    function testInitialSetup() public {
        assertEq(mock.number(), 0);
    }

//    function testInitialize() public {
//        mock.initialize(123);
//        assertEq(mock.number(), 123);
//        assertEq(mock._getInitializedVersion(), 1);
//    }

    function testFailReinitializeWithoutInitialization() public {
        mock.reinitialize(456);
    }

    function testReinitialize() public {
        mock.initialize(123);
        mock.reinitialize(456);
        assertEq(mock.number(), 456);
//        assertEq(mock._getInitializedVersion(), 2);
    }

    function testFailInitializeTwice() public {
        mock.initialize(123);
        mock.initialize(123);
    }

    function testOnlyInitializing() public {
        vm.expectRevert(Initializable.NotInitializing.selector);
        mock.setNumber(789);
    }

    function testOnlyInitializingAfterInitialization() public {
        mock.initialize(123);
        mock.setNumber(789);
        assertEq(mock.number(), 789);
    }

    function testDisableInitializers() public {
        mock.disable();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.initialize(123);
    }

//    function testIsInitializing() public {
//        assertFalse(mock._isInitializing());
//        vm.prank(address(this), address(this));
//        vm.startPrank(address(this));
//        mock.initialize(123);
//        assertTrue(mock._isInitializing());
//        vm.stopPrank();
//    }

    function testFailInitializeAfterDisable() public {
        mock.disable();
        mock.initialize(123);
    }

//    function testInitializationLock() public {
//        mock.disable();
//        uint64 maxVersion = type(uint64).max;
//        assertEq(mock._getInitializedVersion(), maxVersion);
//    }
}