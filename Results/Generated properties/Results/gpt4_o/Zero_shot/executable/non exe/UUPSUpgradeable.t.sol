// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract UUPSUpgradeableTest is Test {
    UUPSUpgradeableTestImpl testImpl;
    address proxy;

    function setUp() public {
        testImpl = new UUPSUpgradeableTestImpl();
//        proxy = address(new ERC1967Proxy(address(testImpl), ""));
    }

    function testUpgradeToAndCall() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        bytes memory data = abi.encodeWithSignature("initialize()");

        vm.prank(proxy);
        testImpl.upgradeToAndCall(address(newImpl), data);

        assertEq(UUPSUpgradeableTestImpl(proxy).implementation(), address(newImpl));
    }

    function testUpgradeToAndCallUnauthorized() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        bytes memory data = abi.encodeWithSignature("initialize()");

        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        testImpl.upgradeToAndCall(address(newImpl), data);
    }

    function testUpgradeToAndCallInvalidImplementation() public {
        InvalidImplementation invalidImpl = new InvalidImplementation();
        bytes memory data = abi.encodeWithSignature("initialize()");

        vm.prank(proxy);
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        testImpl.upgradeToAndCall(address(invalidImpl), data);
    }

    function testProxiableUUID() public {
        bytes32 expectedUUID = keccak256("eip1967.proxy.implementation") - 1;
        assertEq(testImpl.proxiableUUID(), expectedUUID);
    }

    function testOnlyProxyModifier() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        testImpl.onlyProxyFunction();
    }

    function testNotDelegatedModifier() public {
        vm.prank(proxy);
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        UUPSUpgradeableTestImpl(proxy).notDelegatedFunction();
    }
}

contract UUPSUpgradeableTestImpl is UUPSUpgradeable {
    address public implementation;

    function _authorizeUpgrade(address newImplementation) internal override {
        // For testing purposes, we allow any upgrade
    }

    function upgradeToAndCall(address newImplementation, bytes calldata data) public payable override {
        super.upgradeToAndCall(newImplementation, data);
        implementation = newImplementation;
    }

    function onlyProxyFunction() public onlyProxy {
        // Function to test onlyProxy modifier
    }

    function notDelegatedFunction() public notDelegated {
        // Function to test notDelegated modifier
    }
}

contract InvalidImplementation {
    // This contract does not implement proxiableUUID correctly
}