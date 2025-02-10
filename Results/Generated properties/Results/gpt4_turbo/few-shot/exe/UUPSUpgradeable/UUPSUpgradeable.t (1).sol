// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract MockUUPSUpgradeable is UUPSUpgradeable {
    uint256 public value;

    function setValue(uint256 newValue) external {
        value = newValue;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        // Allow all upgrades in this mock
    }
}

contract UUPSUpgradeableTest is Test {
    MockUUPSUpgradeable public uups;
    address public newImplementation;

    function setUp() public {
        uups = new MockUUPSUpgradeable();
        newImplementation = address(new MockUUPSUpgradeable());
    }

    function testUpgradeToAndCall() public {
        uint256 newValue = 42;
        bytes memory data = abi.encodeWithSelector(MockUUPSUpgradeable.setValue.selector, newValue);

        vm.prank(address(this));
        uups.upgradeToAndCall(newImplementation, data);

        assertEq(uups.value(), newValue, "Value should be updated to new value");
//        assertEq(address(uups.proxiableUUID()), newImplementation, "Implementation should be updated");
    }
//
//    function testUpgradeToAndCallWithEmptyData() public {
//        vm.prank(address(this));
//        uups.upgradeToAndCall(newImplementation, "");
//
//        assertEq(address(uups.proxiableUUID()), newImplementation, "Implementation should be updated");
//    }

    function testUpgradeToAndCallUnauthorized() public {
        bytes memory data = abi.encodeWithSelector(MockUUPSUpgradeable.setValue.selector, 100);

        vm.expectRevert("UnauthorizedCallContext");
        uups.upgradeToAndCall(newImplementation, data);
    }

    function testUpgradeToAndCallWithInvalidImplementation() public {
        address invalidImplementation = address(0); // Zero address, likely not a valid implementation
        bytes memory data = abi.encodeWithSelector(MockUUPSUpgradeable.setValue.selector, 100);

        vm.prank(address(this));
        vm.expectRevert("UpgradeFailed");
        uups.upgradeToAndCall(invalidImplementation, data);
    }

    function testProxiableUUID() public {
        assertEq(uups.proxiableUUID(), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, "Should return the correct UUID");
    }

    function testOnlyProxyModifier() public {
        vm.expectRevert("UnauthorizedCallContext");
        uups.setValue(123);
    }

    function testNotDelegatedModifier() public {
        // This should pass as it's called directly and not through a delegatecall
        uups.setValue(123);
        assertEq(uups.value(), 123, "Value should be set correctly");
    }
}