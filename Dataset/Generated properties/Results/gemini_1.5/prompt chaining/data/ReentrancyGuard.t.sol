// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract ReentrancyGuardTest is Test {
    TestContract internal testContract;

    function setUp() public {
        testContract = new TestContract();
    }

    function testNonReentrant_SingleEntry_DirectRecursion() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        testContract.directRecursiveCall();
    }

    function testNonReentrant_SingleEntry_IndirectRecursion() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        testContract.indirectRecursiveCall();
    }

    function testNonReentrant_CrossFunctionProtection_SequentialCalls() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        testContract.crossFunctionCall_1();
    }

    function testNonReentrant_StateConsistency_StateModification() public {
        uint256 initialValue = testContract.value();
        testContract.nonReentrantFunction();
        uint256 finalValue = testContract.value();
        assertEq(finalValue, initialValue + 1, "State not updated correctly");
    }

    function testNonReentrant_UnlockingAfterExecution_CallAfterSuccess() public {
        testContract.nonReentrantFunction();
        testContract.nonReentrantFunction();
        assertEq(testContract.value(), 2, "Second call should succeed");
    }

//    function testNonReadReentrant_ReadOnlyReentrancyPrevention_RecursiveViewCall()
//        public
//    {
//        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
//        testContract.recursiveViewCall();
//    }

    function testNonReadReentrant_ReadOnlyReentrancyPrevention_CallFromNonReentrantFunction()
        public
    {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        testContract.callViewFromNonReentrant();
    }
}

contract TestContract is ReentrancyGuard {
    uint256 public value;

    function nonReentrantFunction() public nonReentrant {
        value++;
    }

    function directRecursiveCall() public nonReentrant {
        directRecursiveCall();
    }

    function indirectRecursiveCall() public nonReentrant {
        this.nonReentrantFunction();
    }

    function crossFunctionCall_1() public nonReentrant {
        crossFunctionCall_2();
    }

    function crossFunctionCall_2() public nonReentrant {
        // Some logic here...
    }

    function viewFunction() public view nonReadReentrant returns (uint256) {
        return value;
    }

    function recursiveViewCall() public view nonReadReentrant {
        viewFunction();
    }

    function callViewFromNonReentrant() public nonReentrant {
        viewFunction();
    }
}
