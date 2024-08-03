// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/UUPSUpgradeable.sol";

contract MockUUPSUpgradeable is UUPSUpgradeable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
}

contract UUPSUpgradeableTest is Test {
    MockUUPSUpgradeable internal uups;
    address internal newImplementation;

    event Upgraded(address indexed implementation);

    function setUp() public {
        uups = new MockUUPSUpgradeable();
        newImplementation = address(new MockUUPSUpgradeable());
    }

    function testUpgradeToAndCall() public {
        vm.expectEmit(true, true, true, true);
        emit Upgraded(newImplementation);

        bytes memory data = abi.encodeWithSignature("initialize()");
        vm.prank(uups.owner());
        uups.upgradeToAndCall(newImplementation, data);

        bytes32 implementationSlot = uups._ERC1967_IMPLEMENTATION_SLOT();
        address implementation;
        assembly {
            implementation := sload(implementationSlot)
        }
        assertEq(implementation, newImplementation);
    }

    function testUpgradeToAndCallUnauthorized() public {
        bytes memory data = abi.encodeWithSignature("initialize()");
        vm.expectRevert("Not the owner");
        uups.upgradeToAndCall(newImplementation, data);
    }

    function testProxiableUUID() public {
        bytes32 expectedUUID = uups._ERC1967_IMPLEMENTATION_SLOT();
        assertEq(uups.proxiableUUID(), expectedUUID);
    }

    function testOnlyProxy() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.onlyProxy();
    }

    function testNotDelegated() public {
        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.notDelegated();
    }

    function testUpgradeFailed() public {
        address invalidImplementation = address(0x123);
        bytes memory data = abi.encodeWithSignature("initialize()");
        vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
        vm.prank(uups.owner());
        uups.upgradeToAndCall(invalidImplementation, data);
    }
}