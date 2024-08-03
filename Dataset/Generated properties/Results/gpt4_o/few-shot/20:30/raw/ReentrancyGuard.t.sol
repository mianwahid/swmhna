// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract MockReentrancyGuard is ReentrancyGuard {
    uint256 public counter;

    function increment() public nonReentrant {
        counter++;
    }

    function incrementView() public nonReadReentrant view returns (uint256) {
        return counter + 1;
    }
}

contract ReentrancyGuardTest is Test {
    MockReentrancyGuard mockReentrancyGuard;

    function setUp() public {
        mockReentrancyGuard = new MockReentrancyGuard();
    }

    function testNonReentrant() public {
        mockReentrancyGuard.increment();
        assertEq(mockReentrancyGuard.counter(), 1);

        // Expect revert on reentrant call
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        mockReentrancyGuard.increment();
    }

    function testNonReadReentrant() public {
        uint256 result = mockReentrancyGuard.incrementView();
        assertEq(result, 1);

        // Expect no revert on read-only reentrant call
        result = mockReentrancyGuard.incrementView();
        assertEq(result, 1);
    }

    function testNonReentrantFuzz(uint256 times) public {
        for (uint256 i = 0; i < times; i++) {
            mockReentrancyGuard.increment();
        }
        assertEq(mockReentrancyGuard.counter(), times);
    }

    function testNonReadReentrantFuzz(uint256 times) public {
        for (uint256 i = 0; i < times; i++) {
            uint256 result = mockReentrancyGuard.incrementView();
            assertEq(result, 1);
        }
    }
}