// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract MockUUPSUpgradeable is UUPSUpgradeable {
    uint256 public value;

    function setValue(uint256 newValue) external {
        value = newValue;
    }

    function _authorizeUpgrade(address newImplementation) internal override  {
        // Custom authorization logic, simplified for testing
    }
}

contract UUPSUpgradeableTest is Test {
    MockUUPSUpgradeable public mock;
    address public newImplementation;

    function setUp() public {
        mock = new MockUUPSUpgradeable();
        newImplementation = address(new MockUUPSUpgradeable());
    }

    function testProxiableUUID() public {
        bytes32 expected = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assertEq(mock.proxiableUUID(), expected, "Proxiable UUID does not match expected value.");
    }

    function testUpgradeToAndCall() public {
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
        vm.prank(address(this)); // Simulate the call from an authorized address
        mock.upgradeToAndCall(newImplementation, data);

        assertEq(address(mock).code, newImplementation.code, "Implementation was not upgraded correctly.");
        assertEq(mock.value(), 123, "State was not updated correctly after upgrade.");
    }

    function testUpgradeToAndCallRevertsOnUnauthorized() public {
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
        vm.expectRevert("UnauthorizedCallContext");
        mock.upgradeToAndCall(newImplementation, data);
    }

    function testUpgradeToAndCallRevertsOnInvalidImplementation() public {
        address invalidImplementation = address(0); // Invalid because it's zero
        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 123);
        vm.prank(address(this)); // Simulate the call from an authorized address
        vm.expectRevert("UpgradeFailed");
        mock.upgradeToAndCall(invalidImplementation, data);
    }

    function testOnlyProxyModifier() public {
        vm.expectRevert("UnauthorizedCallContext");
        mock.setValue(256); // This should fail because it's not called through a proxy
    }

    function testNotDelegatedModifier() public {
        vm.expectRevert("UnauthorizedCallContext");
        mock.proxiableUUID(); // This should fail because it's assumed to be called via delegatecall
    }
}