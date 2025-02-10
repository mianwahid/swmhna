// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract MockReentrancyGuard is ReentrancyGuard {
    uint256 public value;

    function setValue(uint256 newValue) external nonReentrant {
        value = newValue;
    }

    function getValue() external view nonReadReentrant returns (uint256) {
        return value;
    }

    function reentrantSetValue(uint256 newValue) external {
        this.setValue(newValue);
    }

    function reentrantGetValue() external view returns (uint256) {
        return this.getValue();
    }
}

contract ReentrancyGuardTest is Test {
    MockReentrancyGuard mock;

    function setUp() public {
        mock = new MockReentrancyGuard();
    }

    function testNonReentrantModifierPreventsReentrancy() public {
        uint256 testValue = 123;
        mock.setValue(testValue);
        assertEq(mock.value(), testValue);

        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        mock.reentrantSetValue(456);
    }

    function testNonReadReentrantModifierPreventsReentrancy() public {
        uint256 testValue = 123;
        mock.setValue(testValue);
        assertEq(mock.getValue(), testValue);

        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        mock.reentrantGetValue();
    }

    function testSetValueWorksUnderNormalConditions() public {
        uint256 testValue = 789;
        mock.setValue(testValue);
        assertEq(mock.value(), testValue);
    }

    function testGetValueWorksUnderNormalConditions() public {
        uint256 testValue = 789;
        mock.setValue(testValue);
        assertEq(mock.getValue(), testValue);
    }

    function testReentrancyGuardResetsAfterFunctionCall() public {
        uint256 testValue = 321;
        mock.setValue(testValue);
        assertEq(mock.value(), testValue);

        // Should not revert as the guard should reset after the first call
        mock.setValue(testValue + 1);
        assertEq(mock.value(), testValue + 1);
    }
}