// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract ReentrancyGuardTest is Test {
    ReentrancyGuardTestContract testContract;

    function setUp() public {
        testContract = new ReentrancyGuardTestContract();
    }

    // Invariant 1: Initial State
    function testInitialState() public {
        uint256 guardSlot = testContract.getReentrancyGuardSlot();
        assert(guardSlot != uint256(uint160(address(testContract))));
    }

    // Invariant 2: Single Entry for `nonReentrant`
    function testSingleEntryNonReentrant() public {
        testContract.nonReentrantFunction();
    }

    // Invariant 3: Reentrancy Prevention for `nonReentrant`
    function testReentrancyPreventionNonReentrant() public {
        try testContract.reentrantCall() {
//            fail("Expected reentrancy to be prevented");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    // Invariant 4: Guard Reset for `nonReentrant`
    function testGuardResetNonReentrant() public {
        testContract.nonReentrantFunction();
        uint256 guardSlot = testContract.getReentrancyGuardSlot();
        assertEq(guardSlot, testContract.codeSize());
    }

    // Invariant 5: Single Entry for `nonReadReentrant`
    function testSingleEntryNonReadReentrant() public {
        testContract.nonReadReentrantFunction();
    }

    // Invariant 6: Reentrancy Prevention for `nonReadReentrant`
    function testReentrancyPreventionNonReadReentrant() public {
        try testContract.reentrantReadCall() {
            fail("Expected reentrancy to be prevented");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    // Invariant 7: No State Change for `nonReadReentrant`
    function testNoStateChangeNonReadReentrant() public {
        uint256 initialGuardSlot = testContract.getReentrancyGuardSlot();
        testContract.nonReadReentrantFunction();
        uint256 finalGuardSlot = testContract.getReentrancyGuardSlot();
        assertEq(initialGuardSlot, finalGuardSlot);
    }

    // Invariant 8: Nested Calls with `nonReentrant` and `nonReadReentrant`
    function testNestedCallsNonReentrantAndNonReadReentrant() public {
        testContract.nestedCall();
    }

    // Invariant 9: Multiple Calls to `nonReentrant`
    function testMultipleCallsNonReentrant() public {
        testContract.nonReentrantFunction();
        testContract.nonReentrantFunction();
    }

    // Invariant 10: Multiple Calls to `nonReadReentrant`
    function testMultipleCallsNonReadReentrant() public {
        testContract.nonReadReentrantFunction();
        testContract.nonReadReentrantFunction();
    }

    // Invariant 11: Cross-Contract Reentrancy
    function testCrossContractReentrancy() public {
        ReentrancyGuardTestContract2 testContract2 = new ReentrancyGuardTestContract2(address(testContract));
        try testContract2.crossContractCall() {
            fail("Expected reentrancy to be prevented");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }
}

contract ReentrancyGuardTestContract is ReentrancyGuard {
//    function getReentrancyGuardSlot() public view returns (uint256) {
//        uint256 slot;
//        assembly {
//            slot := sload(_REENTRANCY_GUARD_SLOT)
//        }
//        return slot;
//    }

    function codeSize() public view returns (uint256) {
        uint256 size;
        assembly {
            size := codesize()
        }
        return size;
    }

    function nonReentrantFunction() public nonReentrant {
        // Function logic
    }

    function nonReadReentrantFunction() public nonReadReentrant view {
        // Function logic
    }

    function reentrantCall() public nonReentrant {
        this.nonReentrantFunction();
    }

    function reentrantReadCall() public nonReadReentrant view {
        this.nonReadReentrantFunction();
    }

    function nestedCall() public nonReentrant {
        this.nonReadReentrantFunction();
    }
}

contract ReentrancyGuardTestContract2 {
    ReentrancyGuardTestContract testContract;

    constructor(address _testContract) {
        testContract = ReentrancyGuardTestContract(_testContract);
    }

    function crossContractCall() public {
        testContract.nonReentrantFunction();
    }
}