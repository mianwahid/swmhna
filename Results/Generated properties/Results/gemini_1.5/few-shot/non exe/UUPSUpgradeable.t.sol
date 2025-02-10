// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {MockUUPSUpgradeable, UUPSUpgradeable} from "./utils/mocks/MockUUPSUpgradeable.sol";
import {LibClone} from "../src/utils/LibClone.sol";

contract UUPSUpgradeableTest is Test {
    MockUUPSUpgradeable internal uups;
    MockUUPSUpgradeable internal impl;

    event Upgraded(address indexed implementation);

    function setUp() public {
        impl = new MockUUPSUpgradeable();
        uups = MockUUPSUpgradeable(payable(LibClone.deployERC1967(address(impl))));
    }

    function testUpgradeToAndCall(address newImplementation) public {
        vm.assume(newImplementation != address(0));
        vm.expectRevert(abi.encodeWithSelector(UUPSUpgradeable.UnauthorizedCallContext.selector));
        uups.upgradeToAndCall(newImplementation, "");
    }

    function testUpgradeToAndCall(address newImplementation, bytes calldata data) public {
        vm.assume(newImplementation != address(0));
        vm.prank(address(this));
        uups.upgradeToAndCall(newImplementation, data);
        assertEq(uups.implementation(), newImplementation);
    }

    function testFuzzUpgradeToAndCall(address newImplementation, bytes calldata data) public {
        vm.assume(newImplementation != address(0));
        vm.assume(newImplementation.code.length != 0);
        vm.prank(address(this));
        uups.upgradeToAndCall(newImplementation, data);
        assertEq(uups.implementation(), newImplementation);
    }

    function testUpgradeToAndCallSelf() public {
        address newImplementation = address(uups);
        vm.prank(address(this));
        vm.expectRevert(abi.encodeWithSelector(UUPSUpgradeable.UpgradeFailed.selector));
        uups.upgradeToAndCall(newImplementation, "");
    }

    function testUpgradeToAndCallEmit() public {
        address newImplementation = address(new MockUUPSUpgradeable());
        vm.prank(address(this));
        vm.expectEmit(true, true, true, true);
        emit Upgraded(newImplementation);
        uups.upgradeToAndCall(newImplementation, "");
    }

    function testOnlyProxy() public {
        vm.expectRevert(abi.encodeWithSelector(UUPSUpgradeable.UnauthorizedCallContext.selector));
        impl.upgradeToAndCall(address(impl), "");
    }

    function testNotDelegated() public {
        vm.prank(address(this));
        uups.upgradeToAndCall(address(impl), "");
        assertEq(uups.implementation(), address(impl));
    }
}