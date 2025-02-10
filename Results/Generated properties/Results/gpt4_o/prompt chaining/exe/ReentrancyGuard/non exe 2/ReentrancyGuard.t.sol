// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract ReentrancyGuardTest is Test {
    ReentrancyGuardMock reentrancyGuard;

    function setUp() public {
        reentrancyGuard = new ReentrancyGuardMock();
    }

    // Test invariant: Custom Error: `Reentrancy()`
    function testReentrancyError() public {
        try reentrancyGuard.callNonReentrant() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    // Test invariant: Storage: `_REENTRANCY_GUARD_SLOT`
    function testReentrancyGuardSlotSetAndReset() public {
        reentrancyGuard.callNonReentrant();
        // Check that _REENTRANCY_GUARD_SLOT is reset to the contract's code size
        uint256 expectedValue = address(reentrancyGuard).code.length;
        uint256 actualValue = reentrancyGuard.getReentrancyGuardSlot();
        assertEq(expectedValue, actualValue);
    }

    function testReentrancyGuardSlotUnchangedForNonReadReentrant() public {
        reentrancyGuard.callNonReadReentrant();
        // Check that _REENTRANCY_GUARD_SLOT remains unchanged
        uint256 expectedValue = 0;
        uint256 actualValue = reentrancyGuard.getReentrancyGuardSlot();
        assertEq(expectedValue, actualValue);
    }

    // Test invariant: Modifier: `nonReentrant`
    function testNonReentrantDirectCall() public {
        try reentrancyGuard.callNonReentrant() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    function testNonReentrantIndirectCall() public {
        try reentrancyGuard.callNonReentrantIndirect() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    function testNonReentrantNestedCalls() public {
        try reentrancyGuard.callNonReentrantNested() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    // Test invariant: Modifier: `nonReadReentrant`
    function testNonReadReentrantDirectCall() public {
        try reentrancyGuard.callNonReadReentrant() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    function testNonReadReentrantIndirectCall() public {
        try reentrancyGuard.callNonReadReentrantIndirect() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    function testNonReadReentrantNestedCalls() public {
        try reentrancyGuard.callNonReadReentrantNested() {
            fail("Expected Reentrancy error not thrown");
        } catch Error(string memory reason) {
            assertEq(reason, "Reentrancy()");
        }
    }

    // Combined Invariants
    function testNonReentrantAndNonReadReentrantCoexistence() public {
        reentrancyGuard.callNonReentrantAndNonReadReentrant();
        // Check that _REENTRANCY_GUARD_SLOT is correctly managed
        uint256 expectedValue = address(reentrancyGuard).code.length;
        uint256 actualValue = reentrancyGuard.getReentrancyGuardSlot();
        assertEq(expectedValue, actualValue);
    }

    // Additional Edge Cases
    function testNoReentrancyAttempt() public {
        reentrancyGuard.callNonReentrant();
        reentrancyGuard.callNonReadReentrant();
    }

    function testMultipleConcurrentTransactions() public {
        // Simulate multiple concurrent transactions
        for (uint256 i = 0; i < 10; i++) {
            reentrancyGuard.callNonReentrant();
            reentrancyGuard.callNonReadReentrant();
        }
    }
}

contract ReentrancyGuardMock is ReentrancyGuard {
    function callNonReentrant() public nonReentrant {
        // Reentrant call
        this.callNonReentrant();
    }

    function callNonReentrantIndirect() public nonReentrant {
        // Indirect reentrant call
        this.callNonReentrant();
    }

    function callNonReentrantNested() public nonReentrant {
        // Nested reentrant call
        this.callNonReentrant();
        this.callNonReentrant();
    }

    function callNonReadReentrant() public nonReadReentrant {
        // Reentrant call
        this.callNonReadReentrant();
    }

    function callNonReadReentrantIndirect() public nonReadReentrant {
        // Indirect reentrant call
        this.callNonReadReentrant();
    }

    function callNonReadReentrantNested() public nonReadReentrant {
        // Nested reentrant call
        this.callNonReadReentrant();
        this.callNonReadReentrant();
    }

    function callNonReentrantAndNonReadReentrant() public nonReentrant {
        this.callNonReadReentrant();
    }

    function getReentrancyGuardSlot() public view returns (uint256) {
        uint256 slot;
        assembly {
            slot := sload(_REENTRANCY_GUARD_SLOT)
        }
        return slot;
    }
}