// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";


// Mock contract to test Initializable
    contract MockInitializable is Initializable {
        bool public initialized;
        bool public reinitialized;
        uint64 public reinitVersion;

        function initialize() public initializer {
            initialized = true;
        }

        function reinitialize(uint64 version) public reinitializer(version) {
            reinitialized = true;
            reinitVersion = version;
        }

        function onlyInitializingFunction() public onlyInitializing {
            // This function can only be called during initialization
        }

        function disableInitializers() public {
            _disableInitializers();
        }

        function isInitializing() public view returns (bool) {
            return _isInitializing();
        }

        function getInitializedVersion() public view returns (uint64) {
            return _getInitializedVersion();
        }
    }


contract InitializableTest is Test {
    event Initialized(uint64 version);


    function testSingleInitialization() public {
        MockInitializable mock = new MockInitializable();
        mock.initialize();

        // Attempt to call the initializer function again should revert
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.initialize();
    }

    function testReinitializationWithVersioning() public {
        MockInitializable mock = new MockInitializable();
        mock.initialize();

        // Call the reinitializer function with version 2
        mock.reinitialize(2);

        // Attempt to reinitialize with the same version should revert
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.reinitialize(2);

        // Attempt to reinitialize with a lower version should revert
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.reinitialize(1);
    }

    function testOnlyInitializingState() public {
        MockInitializable mock = new MockInitializable();
        mock.initialize();

        // Attempt to call a function with onlyInitializing outside of initialization should revert
        vm.expectRevert(Initializable.NotInitializing.selector);
        mock.onlyInitializingFunction();
    }

    function testDisableInitializers() public {
        MockInitializable mock = new MockInitializable();
        mock.initialize();

        // Call the disableInitializers function
        mock.disableInitializers();

        // Attempt to initialize or reinitialize should revert
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.initialize();

        vm.expectRevert(Initializable.InvalidInitialization.selector);
        mock.reinitialize(2);
    }

    function testInitializationEventEmission() public {
        MockInitializable mock = new MockInitializable();

        // Expect the Initialized event with version 1
        vm.expectEmit(true, true, true, true);
        emit Initialized(1);
        mock.initialize();

        // Expect the Initialized event with version 2
        vm.expectEmit(true, true, true, true);
        emit Initialized(2);
        mock.reinitialize(2);
    }

    function testInitializationStateCheck() public {
        MockInitializable mock = new MockInitializable();
        mock.initialize();

        // Verify that _isInitializing returns false outside of initialization
        assert(!mock.isInitializing());

        // Call a function with initializer and verify _isInitializing returns true
        vm.prank(address(mock));
        mock.initialize();
        assert(mock.isInitializing());
    }

    function testInitializedVersionCheck() public {
        MockInitializable mock = new MockInitializable();
        mock.initialize();

        // Verify that _getInitializedVersion returns 1
        assert(mock.getInitializedVersion() == 1);

        // Call the reinitializer function with version 2
        mock.reinitialize(2);

        // Verify that _getInitializedVersion returns 2
        assert(mock.getInitializedVersion() == 2);
    }
}