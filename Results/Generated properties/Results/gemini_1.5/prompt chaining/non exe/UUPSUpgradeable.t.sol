// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

// Dummy contract for upgrade testing
contract DummyImplementation is UUPSUpgradeable {
    uint256 public value;

    function initialize(uint256 _value) public {
        value = _value;
    }

    function increment() public {
        value++;
    }

    function _authorizeUpgrade(address) internal override {}
}

contract UUPSUpgradeableTest is Test {
    UUPSUpgradeable uups;
    DummyImplementation implementationV1;
    DummyImplementation implementationV2;

    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x123);

        implementationV1 = new DummyImplementation();
        implementationV2 = new DummyImplementation();
    }

    function testUpgradeToAndCall_Authorization() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.upgradeToAndCall(address(implementationV1), "");
    }

    function testUpgradeToAndCall_ImplementationValidity() public {
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        // Pass zero address as new implementation
        vm.prank(owner);
        uups.upgradeToAndCall(address(0), "");
    }

    function testUpgradeToAndCall_StateUpdatesAndEvents() public {
        // Deploy a proxy
        address proxy = deployProxy(address(implementationV1), "");

        // Upgrade the proxy
        vm.startPrank(owner);
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(implementationV2), "");
        vm.stopPrank();

        // Check if the implementation is updated
        assertEq(
            address(implementationV2),
            getAddressFromSlot(_ERC1967_IMPLEMENTATION_SLOT),
            "Implementation not updated"
        );
    }

    function testUpgradeToAndCall_DelegatecallBehavior() public {
        // Deploy a proxy
        address proxy = deployProxy(address(implementationV1), "");

        // Upgrade and call a function on the new implementation
        bytes memory data = abi.encodeWithSignature("increment()");
        vm.prank(owner);
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(implementationV2), data);

        // Check if the function call was successful
        assertEq(implementationV2.value(), 1, "Delegatecall failed");
    }

    function testProxiableUUID() public {
        assertEq(
            uups.proxiableUUID(),
            _ERC1967_IMPLEMENTATION_SLOT,
            "proxiableUUID returned incorrect value"
        );
    }

    function testModifiers() public {
        // Test onlyProxy modifier
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.upgradeToAndCall(address(implementationV1), "");

        // Test notDelegated modifier (cannot be tested directly in this context)
    }

    function testEdgeCases_ZeroAddress() public {
        // Deploy a proxy
        address proxy = deployProxy(address(implementationV1), "");

        // Attempt to upgrade to the zero address
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        vm.prank(owner);
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(0), "");
    }

    function testEdgeCases_EmptyData() public {
        // Deploy a proxy
        address proxy = deployProxy(address(implementationV1), "");

        // Upgrade with empty data
        vm.prank(owner);
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(implementationV2), "");

        // Check if the implementation is updated
        assertEq(
            address(implementationV2),
            getAddressFromSlot(_ERC1967_IMPLEMENTATION_SLOT),
            "Implementation not updated"
        );
    }

    function testEdgeCases_RevertedDelegatecall() public {
        // Deploy a proxy
        address proxy = deployProxy(address(implementationV1), "");

        // Upgrade and call a function that reverts
        bytes memory data = abi.encodeWithSignature("functionThatReverts()");
        vm.expectRevert("DummyImplementation: Function reverted");
        vm.prank(owner);
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(implementationV2), data);
    }

    function testEdgeCases_DifferentImplementations() public {
        // Deploy a proxy
        address proxy = deployProxy(address(implementationV1), "");

        // Upgrade to implementationV2
        vm.startPrank(owner);
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(implementationV2), "");

        // Call a function on implementationV2
        DummyImplementation(payable(proxy)).increment();

        // Upgrade back to implementationV1
        UUPSUpgradeable(payable(proxy)).upgradeToAndCall(address(implementationV1), "");
        vm.stopPrank();

        // Call a function on implementationV1
        DummyImplementation(payable(proxy)).increment();

        // Check if the function calls were successful on respective implementations
        assertEq(implementationV1.value(), 1, "ImplementationV1 function call failed");
        assertEq(implementationV2.value(), 1, "ImplementationV2 function call failed");
    }

    // Helper functions
    function deployProxy(address _implementation, bytes memory _data) internal returns (address) {
        return address(new UUPSUpgradeableProxy(_implementation, _data));
    }

    function getAddressFromSlot(bytes32 _slot) internal view returns (address result) {
        assembly {
            result := sload(_slot)
        }
    }

    bytes32 internal constant _ERC1967_IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
}

contract UUPSUpgradeableProxy is UUPSUpgradeable {
    constructor(address _implementation, bytes memory _data) payable {
        _upgradeToAndCall(_implementation, _data);
    }

    function _authorizeUpgrade(address) internal override {}
}
