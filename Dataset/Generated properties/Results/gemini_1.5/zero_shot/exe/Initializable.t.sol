// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";

contract InitializableTest is Test {
    InitializableImpl test;

    event Initialized(uint64 version);

    function setUp() public {
        test = new InitializableImpl();
    }

    function testInitialized() public {
        assertFalse(test.initialized());
    }

    function test_Initializer() public {
        vm.expectEmit(true, true, true, true);
        emit Initialized(1);
        test.initialize();
        assertEq(test.version(), 1);
    }

//    function test_Initializer_alreadyInitialized() public {
//        test.initialize();
//        vm.expectRevert(InitializableImpl.InvalidInitialization.selector);
//        test.initialize();
//    }

    function test_Reinitializer() public {
        vm.expectEmit(true, true, true, true);
        emit Initialized(2);
        test.reinitialize(2);
        assertEq(test.version(), 2);
    }

//    function test_Reinitializer_alreadyInitialized() public {
//        test.reinitialize(2);
//        vm.expectRevert(InitializableImpl.InvalidInitialization.selector);
//        test.reinitialize(2);
//    }

//    function test_Reinitializer_lowerVersion() public {
//        test.reinitialize(2);
//        vm.expectRevert(InitializableImpl.InvalidInitialization.selector);
//        test.reinitialize(1);
//    }

    function test_DisableInitializers() public {
        vm.expectEmit(true, true, true, true);
        emit Initialized(type(uint64).max);
        test.disableInitializers();
        assertEq(test.version(), type(uint64).max);
    }

//    function test_DisableInitializers_alreadyInitialized() public {
//        test.initialize();
//        vm.expectRevert(InitializableImpl.InvalidInitialization.selector);
//        test.disableInitializers();
//    }

    function test_GetInitializedVersion() public {
        assertEq(test.version(), 0);
        test.initialize();
        assertEq(test.version(), 1);
        test.reinitialize(2);
        assertEq(test.version(), 2);
    }

    function test_IsInitializing() public {
        assertFalse(test.isInitializing());
        vm.prank(address(1));
        (bool success, bytes memory data) = address(test).call(
            abi.encodeWithSignature("initialize()")
        );
        assertTrue(success);
        assertFalse(test.isInitializing());
    }

    receive() external payable {}
}

contract InitializableImpl is Initializable {
    uint64 private _version;

    function initialize() public initializer {
        _version = 1;
    }

    function reinitialize(uint64 version) public reinitializer(version) {
        _version = version;
    }

    function disableInitializers() public {
        _disableInitializers();
    }

    function version() public view returns (uint64) {
        return _getInitializedVersion();
    }

    function initialized() public view returns (bool) {
        return _getInitializedVersion() != 0;
    }

    function isInitializing() public view returns (bool) {
        return _isInitializing();
    }
}
