// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract MockReentrancyGuard is ReentrancyGuard {
    uint256 public value;

    function setValue(uint256 newValue) external nonReentrant {
        value = newValue;
    }

    function getValue() external view nonReadReentrant returns (uint256) {
        return value;
    }

    function reentrantCall() external nonReentrant {
        this.setValue(123); // This should fail due to reentrancy
    }

    function reentrantReadCall() external view nonReadReentrant returns (uint256) {
        return this.getValue(); // This should fail due to reentrancy
    }
}

contract ReentrancyGuardTest is Test {
    MockReentrancyGuard mock;

    function setUp() public {
        mock = new MockReentrancyGuard();
    }

    function testNonReentrantModifierPreventsReentrancy() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        mock.reentrantCall();
    }

    function testNonReadReentrantModifierPreventsReentrancy() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        uint256 value = mock.reentrantReadCall();
    }

    function testSetValueWorks() public {
        uint256 testValue = 42;
        mock.setValue(testValue);
        assertEq(mock.value(), testValue);
    }

    function testGetValueWorks() public {
        uint256 testValue = 42;
        mock.setValue(testValue);
        assertEq(mock.getValue(), testValue);
    }

    function testReentrancyGuardResetsAfterFunctionCall() public {
        uint256 testValue = 42;
        mock.setValue(testValue); // Should work without reentrancy issues
        mock.setValue(testValue + 1); // Should also work as the guard resets after each call
        assertEq(mock.value(), testValue + 1);
    }

    function testReentrancyGuardOnViewFunction() public {
        uint256 testValue = 42;
        mock.setValue(testValue);
        assertEq(mock.getValue(), testValue); // Should work without reentrancy issues
        assertEq(mock.getValue(), testValue); // Should also work as the guard resets after each call
    }
}