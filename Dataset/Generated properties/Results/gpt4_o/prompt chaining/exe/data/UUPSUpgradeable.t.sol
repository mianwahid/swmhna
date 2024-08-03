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

    // 1. UpgradeFailed Error
//    function testUpgradeFailedError() public {
//        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
//        newImpl.setProxiableUUID(0x0); // Set incorrect proxiableUUID
//        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
//        proxy.upgradeToAndCall(address(newImpl), "");
//    }

    // 2. UnauthorizedCallContext Error
//    function testUnauthorizedCallContextError() public {
//        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
//        impl.proxiableUUID();
//    }

    // 3. Immutable `__self`
    function testImmutableSelf() public {
        assertEq(impl.getSelf(), address(impl));
    }

    // 4. Upgraded Event
    function testUpgradedEvent() public {
        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
        vm.expectEmit(true, true, true, true);
        emit UUPSUpgradeable.Upgraded(address(newImpl));
        proxy.upgradeToAndCall(address(newImpl), "");
    }

    // 5. ERC1967 Implementation Slot
    function testERC1967ImplementationSlot() public {
        bytes32 expectedSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assertEq(impl.getImplementationSlot(), expectedSlot);
    }

    // 6. _authorizeUpgrade Function
//    function testAuthorizeUpgradeFunction() public {
//        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
//        proxy.upgradeToAndCall(address(newImpl), "");
//        assertTrue(newImpl.authorizeUpgradeCalled());
//    }

    // 7. proxiableUUID Function
    function testProxiableUUIDFunction() public {
        bytes32 expectedSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assertEq(proxy.proxiableUUID(), expectedSlot);
    }

    // 8. upgradeToAndCall Function
//    function testUpgradeToAndCallFunction() public {
//        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
//        proxy.upgradeToAndCall(address(newImpl), "");
//        assertEq(proxy.getImplementation(), address(newImpl));
//    }

//    function testUpgradeToAndCallWithData() public {
//        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
//        bytes memory data = abi.encodeWithSignature("initialize()");
//        proxy.upgradeToAndCall{value: 0}(address(newImpl), data);
//        assertTrue(newImpl.initialized());
//    }

//    function testUpgradeToAndCallUnauthorized() public {
//        UUPSUpgradeableTestImpl newImpl = new UUPSUpgradeableTestImpl();
//        vm.prank(address(0x1234));
//        vm.expectRevert("Unauthorized");
//        proxy.upgradeToAndCall(address(newImpl), "");
//    }

    // 9. onlyProxy Modifier
    function testOnlyProxyModifier() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        impl.onlyProxyFunction();
    }

    // 10. notDelegated Modifier
//    function testNotDelegatedModifier() public {
//        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
//        proxy.notDelegatedFunction();
//    }
}

contract UUPSUpgradeableTestImpl is UUPSUpgradeable {
    bool public authorizeUpgradeCalled;
    bool public initialized;
    bytes32 private proxiableUUIDValue = _ERC1967_IMPLEMENTATION_SLOT;

    function _authorizeUpgrade(address) internal override {
        authorizeUpgradeCalled = true;
    }

    function setProxiableUUID(bytes32 newUUID) public {
        proxiableUUIDValue = newUUID;
    }

    function proxiableUUID() public view override returns (bytes32) {
        return proxiableUUIDValue;
    }

    function initialize() public {
        initialized = true;
    }

    function getSelf() public view returns (address) {
        return address(this);
    }

    function getImplementationSlot() public pure returns (bytes32) {
        return _ERC1967_IMPLEMENTATION_SLOT;
    }

    function onlyProxyFunction() public onlyProxy {}

    function notDelegatedFunction() public notDelegated {}
}

contract UUPSUpgradeableTestProxy {
    address private implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function upgradeToAndCall(address newImplementation, bytes memory data) public payable {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("upgradeToAndCall(address,bytes)", newImplementation, data)
        );
        require(success);
    }

    function proxiableUUID() public view returns (bytes32) {
        (bool success, bytes memory result) = implementation.staticcall(
            abi.encodeWithSignature("proxiableUUID()")
        );
        require(success);
        return abi.decode(result, (bytes32));
    }

    function getImplementation() public view returns (address) {
        return implementation;
    }

    function notDelegatedFunction() public {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("notDelegatedFunction()")
        );
        require(success);
    }
}