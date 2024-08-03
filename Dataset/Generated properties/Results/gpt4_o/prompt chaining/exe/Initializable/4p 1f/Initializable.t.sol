// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Initializable.sol";

contract InitializableTest is Test {
    InitializableTestContract contractInstance;

    function setUp() public {
        contractInstance = new InitializableTestContract();
    }

    function testInitialStateInvariant() public {
        assert(!contractInstance.isInitializing());
        assert(contractInstance.getInitializedVersion() == 0);
    }

    function testSingleInitializationInvariant() public {
        // First initialization should succeed
        contractInstance.initializerFunction();
        assert(contractInstance.getInitializedVersion() == 1);
        assert(!contractInstance.isInitializing());

        // Second initialization should revert
        try contractInstance.initializerFunction() {
            assert(false); // Should not reach here
        } catch Error(string memory reason) {
            assert(keccak256(bytes(reason)) == keccak256("InvalidInitialization()"));
        }
    }

    function testReinitializationInvariant() public {
        // First reinitialization with version 2 should succeed
        contractInstance.reinitializerFunction(2);
        assert(contractInstance.getInitializedVersion() == 2);
        assert(!contractInstance.isInitializing());

        // Reinitialization with the same version should revert
        try contractInstance.reinitializerFunction(2) {
            assert(false); // Should not reach here
        } catch Error(string memory reason) {
            assert(keccak256(bytes(reason)) == keccak256("InvalidInitialization()"));
        }

        // Reinitialization with a lower version should revert
        try contractInstance.reinitializerFunction(1) {
            assert(false); // Should not reach here
        } catch Error(string memory reason) {
            assert(keccak256(bytes(reason)) == keccak256("InvalidInitialization()"));
        }

        // Reinitialization with a higher version should succeed
        contractInstance.reinitializerFunction(3);
        assert(contractInstance.getInitializedVersion() == 3);
        assert(!contractInstance.isInitializing());
    }

    function testOnlyInitializingInvariant() public {
        // Function guarded by onlyInitializing should revert if called outside initialization
        try contractInstance.onlyInitializingFunction() {
            assert(false); // Should not reach here
        } catch Error(string memory reason) {
            assert(keccak256(bytes(reason)) == keccak256("NotInitializing()"));
        }

        // Function should succeed if called during initialization
        contractInstance.initializerFunction();
        contractInstance.onlyInitializingFunction();
    }

    function testDisableInitializersInvariant() public {
        // Disable initializers
        contractInstance.disableInitializers();
        assert(contractInstance.getInitializedVersion() == type(uint64).max);

        // Any further initialization or reinitialization should revert
        try contractInstance.initializerFunction() {
            assert(false); // Should not reach here
        } catch Error(string memory reason) {
            assert(keccak256(bytes(reason)) == keccak256("InvalidInitialization()"));
        }

        try contractInstance.reinitializerFunction(4) {
            assert(false); // Should not reach here
        } catch Error(string memory reason) {
            assert(keccak256(bytes(reason)) == keccak256("InvalidInitialization()"));
        }
    }

//    function testEventEmissionInvariant() public {
//        // Capture events
//        vm.recordLogs();
//        contractInstance.initializerFunction();
//        Vm.Log[] memory logs = vm.getRecordedLogs();
//        assert(logs.length == 1);
//        assert(logs[0].topics[0] == keccak256("Initialized(uint64)"));
//        assert(uint256(logs[0].data) == 1);
//
////        vm.recordLogs();
////        contractInstance.reinitializerFunction(2);
////        logs = vm.getRecordedLogs();
////        assert(logs.length == 1);
////        assert(logs[0].topics[0] == keccak256("Initialized(uint64)"));
////        assert(uint256(logs[0].data) == 2);
//    }
}

contract InitializableTestContract is Initializable {
    function initializerFunction() public initializer {
        // Initialization logic
    }

    function reinitializerFunction(uint64 version) public reinitializer(version) {
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
}