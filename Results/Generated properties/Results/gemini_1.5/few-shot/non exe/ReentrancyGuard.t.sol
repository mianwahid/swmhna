// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ReentrancyGuard.sol";

contract ReentrancyGuardTest is Test {
    ReentrancyGuard rg;

    function setUp() public {
        rg = new ReentrancyGuard();
    }

//    function testReentrancyGuard() public {
//        vm.prank(address(rg));
//        rg.nonReentrant();
//    }

    function testReentrancyGuardReentrantCall() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        rg.nonReentrant();
        rg.nonReentrant();
    }

    function testNonReadReentrantGuard() public {
        rg.nonReadReentrant();
    }

    function testNonReadReentrantGuardReentrantCall() public {
        vm.expectRevert(ReentrancyGuard.Reentrancy.selector);
        rg.nonReadReentrant();
        rg.nonReadReentrant();
    }
}
