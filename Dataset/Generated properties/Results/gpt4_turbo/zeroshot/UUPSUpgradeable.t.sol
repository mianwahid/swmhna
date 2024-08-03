// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import "../src/UUPSUpgradeable.sol";

contract UUPSUpgradeableTest is Test {
    UUPSUpgradeableMock public uups;

    function setUp() public {
        uups = new UUPSUpgradeableMock();
    }

    function testProxiableUUID() public {
        bytes32 expected = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        assertEq(
            uups.proxiableUUID(),
            expected,
            "Proxiable UUID does not match expected value"
        );
    }

    function testUpgradeToAndCallUnauthorized() public {
        address newImplementation = address(0x1234);
        bytes memory data = "";

        vm.expectRevert(UUPSUpgradeable.UnauthorizedCallContext.selector);
        uups.upgradeToAndCall(newImplementation, data);
    }

    // function testUpgradeToAndCallWithInvalidImplementation() public {
    //     address newImplementation = address(new UUPSUpgradeableMock());
    //     bytes memory data = "";

    //     vm.prank(address(uups));
    //     vm.expectRevert(UUPSUpgradeable.UpgradeFailed.selector);
    //     uups.upgradeToAndCall(newImplementation, data);
    // }

    // function testUpgradeToAndCallWithValidImplementation() public {
    //     UUPSUpgradeableMock newImplementation = new UUPSUpgradeableMock();
    //     bytes memory data = "";

    //     vm.prank(address(uups));
    //     uups.upgradeToAndCall(address(newImplementation), data);

    //     assertEq(
    //         address(uups.implementation()),
    //         address(newImplementation),
    //         "Implementation address did not update correctly"
    //     );
    //}

    // function testUpgradeToAndCallWithData() public {
    //     UUPSUpgradeableMock newImplementation = new UUPSUpgradeableMock();
    //     bytes memory data = abi.encodeWithSignature("testFunction()");

    //     vm.prank(address(uups));
    //     uups.upgradeToAndCall(address(newImplementation), data);

    //     assertEq(
    //         address(uups.implementation()),
    //         address(newImplementation),
    //         "Implementation address did not update correctly"
    //     );
    //     assertTrue(
    //         newImplementation.wasCalled(),
    //         "Delegate call to new implementation failed"
    //     );
    // }
}

contract UUPSUpgradeableMock is UUPSUpgradeable {
    bool private called;

    function _authorizeUpgrade(address newImplementation) internal override {
        require(msg.sender == address(this), "Unauthorized upgrade");
    }

    function testFunction() public {
        called = true;
    }

    function wasCalled() public view returns (bool) {
        return called;
    }

    function implementation() public view returns (address) {
        return _implementation();
    }

    function _implementation() internal view returns (address impl) {
        bytes32 slot = _ERC1967_IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }
}
