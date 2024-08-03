// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract UUPSUpgradeableTest is Test {
    UUPSUpgradeableTestImpl impl;
    UUPSUpgradeableTestProxy proxy;

    function setUp() public {
        impl = new UUPSUpgradeableTestImpl();
        proxy = new UUPSUpgradeableTestProxy(address(impl));
    }

    // 1. `UpgradeFailed`
    function testUpgradeFailed() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        newImpl.setProxiableUUID(bytes32(0)); // Set incorrect proxiableUUID

        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        proxy.upgradeToAndCall(address(newImpl), "");
    }

    // 2. `UnauthorizedCallContext`
    function testUnauthorizedCallContext() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        impl.onlyProxyFunction();
    }

    // 3. `__self`
    function testSelfImmutable() public {
        assertEq(impl.getSelf(), address(impl));
    }

    // 4. `Upgraded`
    function testUpgradedEvent() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        vm.expectEmit(true, true, true, true);
        emit UUPSUpgradeable.Upgraded(address(newImpl));
        proxy.upgradeToAndCall(address(newImpl), "");
    }

//    // 5. `_UPGRADED_EVENT_SIGNATURE`
//    function testUpgradedEventSignature() public {
//        assertEq(UUPSUpgradeable._UPGRADED_EVENT_SIGNATURE, keccak256("Upgraded(address)"));
//    }

    // 6. `_ERC1967_IMPLEMENTATION_SLOT`
//    function testERC1967ImplementationSlot() public {
//        assertEq(UUPSUpgradeable._ERC1967_IMPLEMENTATION_SLOT, bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
//    }

    // 7. `_authorizeUpgrade`
    function testAuthorizeUpgrade() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        proxy.setAuthorized(address(this));
        proxy.upgradeToAndCall(address(newImpl), "");
    }

//    // 8. `proxiableUUID`
//    function testProxiableUUID() public {
//        assertEq(impl.proxiableUUID(), UUPSUpgradeable._ERC1967_IMPLEMENTATION_SLOT);
//    }

    // 9. `upgradeToAndCall`
    function testUpgradeToAndCall() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        proxy.setAuthorized(address(this));
        proxy.upgradeToAndCall(address(newImpl), "");

        // Test with valid data
        bytes memory data = abi.encodeWithSignature("initialize()");
        proxy.upgradeToAndCall(address(newImpl), data);

        // Test with unauthorized address
        vm.prank(address(0x1234));
        vm.expectRevert("Unauthorized");
        proxy.upgradeToAndCall(address(newImpl), "");

        // Test with empty data
        proxy.upgradeToAndCall(address(newImpl), "");

        // Test with incorrect proxiableUUID
        newImpl.setProxiableUUID(bytes32(0));
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        proxy.upgradeToAndCall(address(newImpl), "");
    }

    // 10. `onlyProxy`
    function testOnlyProxy() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        impl.onlyProxyFunction();
    }

    // 11. `notDelegated`
//    function testNotDelegated() public {
//        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
//        proxy.notDelegatedFunction();
//    }
}

contract UUPSUpgradeableTestImpl is UUPSUpgradeable {
    bytes32 private _proxiableUUID = _ERC1967_IMPLEMENTATION_SLOT;

    function setProxiableUUID(bytes32 newUUID) public {
        _proxiableUUID = newUUID;
    }

    function proxiableUUID() public view override returns (bytes32) {
        return _proxiableUUID;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        require(msg.sender == address(this), "Unauthorized");
    }

    function onlyProxyFunction() public onlyProxy {
        // Function logic
    }

    function notDelegatedFunction() public notDelegated {
        // Function logic
    }

    function getSelf() public view returns (address) {
        return address(this);
    }
}

contract UUPSUpgradeableTestProxy {
    address private _implementation;
    address private _authorized;

    constructor(address implementation_) {
        _implementation = implementation_;
    }

    function setAuthorized(address authorized_) public {
        _authorized = authorized_;
    }

    function upgradeToAndCall(address newImplementation, bytes memory data) public {
        require(msg.sender == _authorized, "Unauthorized");
        (bool success, ) = _implementation.delegatecall(
            abi.encodeWithSignature("upgradeToAndCall(address,bytes)", newImplementation, data)
        );
        require(success, "Upgrade failed");
    }

    fallback() external payable {
        (bool success, ) = _implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }
}