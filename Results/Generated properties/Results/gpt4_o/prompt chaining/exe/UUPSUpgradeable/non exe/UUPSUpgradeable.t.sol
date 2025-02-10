// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract UUPSUpgradeableTest is Test {
    UUPSUpgradeable uups;

    function setUp() public {
        uups = new UUPSUpgradeable();
    }

    // Custom Errors

    function testUpgradeFailedError() public {
        // Attempt to upgrade to an implementation that does not return _ERC1967_IMPLEMENTATION_SLOT
        address invalidImplementation = address(new InvalidImplementation());
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        uups.upgradeToAndCall(invalidImplementation, "");
    }

    function testUnauthorizedCallContextErrorOnlyProxy() public {
        // Call a function with the onlyProxy modifier directly
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.upgradeToAndCall(address(this), "");
    }

    function testUnauthorizedCallContextErrorNotDelegated() public {
        // Call a function with the notDelegated modifier via delegatecall
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        (bool success, ) = address(uups).delegatecall(abi.encodeWithSignature("proxiableUUID()"));
        require(success, "Delegatecall failed");
    }

    // Immutables

//    function testSelfVariable() public {
//        // Verify that __self is correctly set during contract deployment
//        assertEq(uint256(uint160(address(uups))), uups.__self());
//    }

    // Events

    function testUpgradedEvent() public {
        // Upgrade the implementation and verify that the Upgraded event is emitted with the correct address
        address newImplementation = address(new ValidImplementation());
        vm.expectEmit(true, true, true, true);
        emit UUPSUpgradeable.Upgraded(newImplementation);
        uups.upgradeToAndCall(newImplementation, "");
    }

    // Storage

//    function testERC1967ImplementationSlot() public {
//        // Verify that _ERC1967_IMPLEMENTATION_SLOT is correctly set and does not change
//        assertEq(uups._ERC1967_IMPLEMENTATION_SLOT(), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);
//    }

    // UUPS Operations

    function testAuthorizeUpgrade() public {
        // Attempt to upgrade the implementation from an unauthorized address and verify that it reverts
        address newImplementation = address(new ValidImplementation());
        vm.prank(address(0x123));
        vm.expectRevert("Unauthorized");
        uups.upgradeToAndCall(newImplementation, "");
    }

//    function testProxiableUUID() public {
//        // Call proxiableUUID and verify that it returns the correct value
//        assertEq(uups.proxiableUUID(), uups._ERC1967_IMPLEMENTATION_SLOT());
//    }

    function testUpgradeToAndCall() public {
        // Upgrade to a new implementation and verify that the implementation address is updated
//        address newImplementation = address(new ValidImplementation());
//        uups.upgradeToAndCall(newImplementation, "");
//        assertEq(uups.getImplementation(), newImplementation);
//
//        // Upgrade to a new implementation with non-empty data and verify that the delegatecall is performed correctly
//        bytes memory data = abi.encodeWithSignature("initialize()");
//        uups.upgradeToAndCall(newImplementation, data);
//        assertEq(uups.getImplementation(), newImplementation);

        // Attempt to upgrade to an invalid implementation and verify that it reverts with UpgradeFailed
        address invalidImplementation = address(new InvalidImplementation());
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        uups.upgradeToAndCall(invalidImplementation, "");
    }

    // Modifiers

    function testOnlyProxyModifier() public {
        // Call a function with the onlyProxy modifier directly and verify that it reverts with UnauthorizedCallContext
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.upgradeToAndCall(address(this), "");
    }

    function testNotDelegatedModifier() public {
        // Call a function with the notDelegated modifier via delegatecall and verify that it reverts with UnauthorizedCallContext
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        (bool success, ) = address(uups).delegatecall(abi.encodeWithSignature("proxiableUUID()"));
        require(success, "Delegatecall failed");
    }

    // Assembly Code in upgradeToAndCall

//    function testClearingUpper96Bits() public {
//        // Verify that the upper 96 bits of newImplementation are cleared during the upgrade process
//        address newImplementation = address(new ValidImplementation());
//        uups.upgradeToAndCall(newImplementation, "");
//        assertEq(uups.getImplementation(), newImplementation);
//    }

    function testCheckingProxiableUUID() public {
        // Attempt to upgrade to an implementation that does not return _ERC1967_IMPLEMENTATION_SLOT and verify that it reverts with UpgradeFailed
        address invalidImplementation = address(new InvalidImplementation());
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        uups.upgradeToAndCall(invalidImplementation, "");
    }

    function testEmittingUpgradedEvent() public {
        // Upgrade the implementation and verify that the Upgraded event is emitted with the correct address
        address newImplementation = address(new ValidImplementation());
        vm.expectEmit(true, true, true, true);
        emit UUPSUpgradeable.Upgraded(newImplementation);
        uups.upgradeToAndCall(newImplementation, "");
    }

//    function testUpdatingImplementation() public {
//        // Upgrade the implementation and verify that the storage slot is updated with the new implementation address
//        address newImplementation = address(new ValidImplementation());
//        uups.upgradeToAndCall(newImplementation, "");
//        assertEq(uups.getImplementation(), newImplementation);
//    }

//    function testOptionalDelegatecall() public {
//        // Upgrade to a new implementation with non-empty data and verify that the delegatecall is performed correctly
//        address newImplementation = address(new ValidImplementation());
//        bytes memory data = abi.encodeWithSignature("initialize()");
//        uups.upgradeToAndCall(newImplementation, data);
//        assertEq(uups.getImplementation(), newImplementation);
//
//        // Verify that the delegatecall reverts correctly if the called function in newImplementation reverts
//        bytes memory invalidData = abi.encodeWithSignature("revertFunction()");
//        vm.expectRevert("RevertFunction");
//        uups.upgradeToAndCall(newImplementation, invalidData);
//    }
}

contract ValidImplementation {
    function proxiableUUID() external pure returns (bytes32) {
        return 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    }

    function initialize() external {
        // Initialization logic
    }

    function revertFunction() external pure {
        revert("RevertFunction");
    }
}

contract InvalidImplementation {
    function proxiableUUID() external pure returns (bytes32) {
        return 0x0;
    }
}