// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";

contract MockInitializable is Initializable {
    uint256 public value;

    function initialize(uint256 _value) external initializer {
        value = _value;
    }

    function reinitialize(uint256 _value) external reinitializer(2) {
        value = _value;
    }

    function onlyInitializingFunction() external onlyInitializing {
        value = 42;
    }

    function disableInitializers() external {
        _disableInitializers();
    }

    function getInitializedVersion() external view returns (uint64) {
        return _getInitializedVersion();
    }

    function isInitializing() external view returns (bool) {
        return _isInitializing();
    }
}

contract InitializableTest is Test {
    MockInitializable mock;

    event Initialized(uint64 version);

    function setUp() public {
        mock = new MockInitializable();
    }

    function testInitializer() public {
        vm.expectEmit(true, true, true, true);
        emit Initialized(1);
        mock.initialize(100);
        assertEq(mock.value(), 100);
    }

    function testReinitializer() public {
        mock.initialize(100);
        vm.expectEmit(true, true, true, true);
        emit Initialized(2);
        mock.reinitialize(200);
        assertEq(mock.value(), 200);
    }

    function testOnlyInitializingFunction() public {
        mock.initialize(100);
        vm.expectRevert(Initializable.NotInitializing.selector);
        mock.onlyInitializingFunction();
    }

    function testDisableInitializers() public {
        mock.disableInitializers();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.initialize(100);
    }

    function testGetInitializedVersion() public {
        assertEq(mock.getInitializedVersion(), 0);
        mock.initialize(100);
        assertEq(mock.getInitializedVersion(), 1);
        mock.reinitialize(200);
        assertEq(mock.getInitializedVersion(), 2);
    }

    function testIsInitializing() public {
        assertFalse(mock.isInitializing());
        mock.initialize(100);
        assertFalse(mock.isInitializing());
    }

    function testInvalidInitialization() public {
        mock.initialize(100);
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.initialize(200);
    }

    function testReinitializerInvalidInitialization() public {
        mock.initialize(100);
        mock.reinitialize(200);
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.reinitialize(300);
    }
}