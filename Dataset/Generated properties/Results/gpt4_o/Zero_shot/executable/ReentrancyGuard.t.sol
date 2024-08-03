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

    function testNonReentrant() public {
        testContract.nonReentrantFunction();
    }

    function testNonReentrantRevertsOnReentrancy() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        testContract.callNonReentrantFunction();
    }

    function testNonReadReentrant() public {
        testContract.nonReadReentrantFunction();
    }

//    function testNonReadReentrantRevertsOnReentrancy() public {
//        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
//        testContract.callNonReadReentrantFunction();
//    }

    function testNonReentrantWithMultipleCalls() public {
        testContract.nonReentrantFunction();
        testContract.nonReentrantFunction();
    }

    function testNonReadReentrantWithMultipleCalls() public {
        testContract.nonReadReentrantFunction();
        testContract.nonReadReentrantFunction();
    }

    function testNonReentrantWithFuzzing(uint256 amount) public {
        testContract.nonReentrantFunction();
    }

    function testNonReadReentrantWithFuzzing(uint256 amount) public {
        testContract.nonReadReentrantFunction();
    }
}

contract ReentrancyGuardTestContract is ReentrancyGuard {
    function nonReentrantFunction() public nonReentrant {
        // Function logic here
    }

    function nonReadReentrantFunction() public nonReadReentrant {
        // Function logic here
    }

    function callNonReentrantFunction() public nonReentrant {
        this.nonReentrantFunction();
    }

    function callNonReadReentrantFunction() public nonReadReentrant {
        this.nonReadReentrantFunction();
    }
}