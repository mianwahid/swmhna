// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {UUPSUpgradeable} from "../src/utils/UUPSUpgradeable.sol";

contract UUPSSetup is UUPSUpgradeable {
    uint256 public value;

    function initialize(uint256 _value) public {
        value = _value;
    }

    function _authorizeUpgrade(address) internal override {}
}

contract UUPSImplementationV2 is UUPSSetup {
    function increment() public {
        value++;
    }
}

contract UUPSUpgradeableTest is Test {
    UUPSSetup public uups;

    address internal alice = address(0x1);
    address internal bob = address(0x2);

    function setUp() public {
        vm.startPrank(alice);
        uups = new UUPSSetup();
        vm.stopPrank();
    }

    function testOnlyProxy() public {
        vm.expectRevert(abi.encodeWithSelector(UUPSUpgradeable.UnauthorizedCallContext.selector));
        uups.upgradeToAndCall(address(0), "");
    }

    function testUpgradeToAndCall() public {
        address implementationV2 = address(new UUPSImplementationV2());

        vm.startPrank(alice);
        vm.label(address(uups), "Proxy");
        vm.label(implementationV2, "ImplementationV2");

        // Upgrade the proxy
        uups.upgradeToAndCall(implementationV2, "");

        // Check if the implementation has been updated
        assertEq(address(uups), address(implementationV2));

        // Interact with the new implementation
        UUPSImplementationV2(address(uups)).increment();
        assertEq(UUPSImplementationV2(address(uups)).value(), 1);
        vm.stopPrank();
    }

    function testFuzzUpgradeToAndCall(address newImplementation, bytes calldata data) public {
        vm.assume(newImplementation != address(0));

        vm.startPrank(alice);

        // Attempt to upgrade the proxy
        vm.tryCatch(
            () => uups.upgradeToAndCall(newImplementation, data),
            abi.encodeWithSelector(UUPSUpgradeable.UpgradeFailed.selector)
        );

        vm.stopPrank();
    }
}
