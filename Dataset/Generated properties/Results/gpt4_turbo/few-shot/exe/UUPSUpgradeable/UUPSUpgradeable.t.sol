// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract MockUUPSUpgradeable is UUPSUpgradeable {
    uint256 public value;

    function setValue(uint256 newValue) external {
        value = newValue;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        // Allow any address to upgrade for testing purposes
    }
}

contract UUPSUpgradeableTest is Test {
    MockUUPSUpgradeable public uups;
    MockUUPSUpgradeable public newImpl;

    function setUp() public {
        uups = new MockUUPSUpgradeable();
        newImpl = new MockUUPSUpgradeable();
    }

    function testInitialValue() public {
        assertEq(uups.value(), 0);
    }

//    function testUpgradeToAndCall() public {
//        address newImplementation = address(newImpl);
//        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
//
//        vm.expectEmit(true, true, true, true);
//        emit Upgraded(newImplementation);
//
//        uups.upgradeToAndCall(newImplementation, data);
//
//        assertEq(uups.value(), 123);
//        assertEq(address(uups.proxiableUUID()), _ERC1967_IMPLEMENTATION_SLOT);
//    }

//    function testUpgradeToAndCallWithEmptyData() public {
//        address newImplementation = address(newImpl);
//        bytes memory data = "";
//
//        vm.expectEmit(true, true, true, true);
//        emit Upgraded(newImplementation);
//
//        uups.upgradeToAndCall(newImplementation, data);
//
//        assertEq(uups.value(), 0); // No change expected
//        assertEq(address(uups.proxiableUUID()), _ERC1967_IMPLEMENTATION_SLOT);
//    }

    function testUpgradeToAndCallUnauthorized() public {
        address newImplementation = address(newImpl);
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);

        // Simulate unauthorized upgrade attempt by overriding the _authorizeUpgrade function
        vm.prank(address(0xdead));
        vm.expectRevert("UnauthorizedCallContext");
        uups.upgradeToAndCall(newImplementation, data);
    }

    function testUpgradeToInvalidImplementation() public {
        // Create a contract that does not match the expected proxiableUUID
        address invalidImplementation = address(new MockUUPSUpgradeable());
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);

        // Expect the upgrade to fail due to invalid proxiableUUID
        vm.expectRevert("UpgradeFailed");
        uups.upgradeToAndCall(invalidImplementation, data);
    }

    function testOnlyProxyModifier() public {
        // Attempt to call a function with onlyProxy modifier directly
        vm.expectRevert("UnauthorizedCallContext");
        uups.setValue(999);
    }

    function testNotDelegatedModifier() public {
        // Attempt to call a function with notDelegated modifier via delegatecall
        MockUUPSUpgradeable anotherInstance = new MockUUPSUpgradeable();
        vm.expectRevert("UnauthorizedCallContext");
        address(anotherInstance).delegatecall(
            abi.encodeWithSignature("proxiableUUID()")
        );
    }
}