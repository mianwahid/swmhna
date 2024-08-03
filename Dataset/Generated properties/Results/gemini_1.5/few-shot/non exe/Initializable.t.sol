// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {Initializable} from "../src/utils/Initializable.sol";

contract InitializableTest is Test {
    event Initialized(uint64 version);

    bytes32 internal constant _INITIALIZABLE_SLOT =
        0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffbf601132;

    error InvalidInitialization();

    error NotInitializing();

    function testInitializable() public {
        MockInitializable c = new MockInitializable();
        assertEq(c.x(), 1);
        assertEq(c.version(), 1);
    }

    function testInitializableRevertsIfAlreadyInitialized() public {
        MockInitializable c = new MockInitializable();
        vm.expectRevert(InvalidInitialization.selector);
        c.initialize();
    }

    function testInitializableRevertsIfAlreadyInitializedWithReinitializer() public {
        MockInitializable c = new MockInitializable();
        vm.expectRevert(InvalidInitialization.selector);
        c.reinitialize(1);
    }

    function testReinitializer(uint64 version) public {
        vm.assume(version > 1);
        MockInitializable c = new MockInitializable();
        c.reinitialize(version);
        assertEq(c.x(), 2);
        assertEq(c.version(), version);
    }

    function testReinitializerRevertsIfVersionIsLowerOrEqual(uint64 version) public {
        vm.assume(version <= 1);
        MockInitializable c = new MockInitializable();
        vm.expectRevert(InvalidInitialization.selector);
        c.reinitialize(version);
    }

    function testOnlyInitializingRevertsIfNoInitializer() public {
        MockInitializable c = new MockInitializable();
        vm.expectRevert(NotInitializing.selector);
        c.onlyInitializing1();
    }

    function testOnlyInitializingRevertsIfNoInitializerWithReinitializer() public {
        MockInitializable c = new MockInitializable();
        vm.expectRevert(NotInitializing.selector);
        c.onlyInitializingWithReinitializer(1);
    }

    function testDisableInitializers() public {
        MockInitializableWithConstructor c = new MockInitializableWithConstructor();
        assertEq(c.x(), 1);
        assertEq(c.version(), type(uint64).max);
    }

//    function testDisableInitializersRevertsIfAlreadyInitialized() public {
//        MockInitializable c = new MockInitializable();
//        vm.expectRevert(InvalidInitialization.selector);
//        c._disableInitializers();
//    }

//    function testGetInitializedVersion() public {
//        MockInitializable c = new MockInitializable();
//        assertEq(c._getInitializedVersion(), 1);
//    }

//    function testIsInitializing() public {
//        MockInitializable c = new MockInitializable();
//        assertFalse(c._isInitializing());
//    }

    function testFuzz_Initializable(uint64 version) public {
        vm.assume(version != 0);
        MockInitializable c = new MockInitializable();
        if (version == 1) {
            vm.expectRevert(InvalidInitialization.selector);
            c.reinitialize(version);
        } else {
            c.reinitialize(version);
            assertEq(c.x(), 2);
            assertEq(c.version(), version);
        }
    }

//    function testFuzz_DisableInitializers(uint64 version) public {
//        vm.assume(version != 0);
//        MockInitializable c = new MockInitializable();
//        c.reinitialize(version);
//        vm.expectRevert(InvalidInitialization.selector);
//        c._disableInitializers();
//    }
}

contract MockInitializable is Initializable {
    uint256 public x;
    uint64 public version;

    function initialize() public initializer {
        x = 1;
        version = 1;
    }

    function reinitialize(uint64 _version) public reinitializer(_version) {
        x = 2;
        version = _version;
    }

    function onlyInitializing1() public onlyInitializing {
        x = 3;
    }

    function onlyInitializingWithReinitializer(uint64 _version)
        public
        onlyInitializing
        reinitializer(_version)
    {
        x = 4;
        version = _version;
    }
}

contract MockInitializableWithConstructor is Initializable {
    uint256 public x;
    uint64 public version;

    constructor() initializer {
        _disableInitializers();
        x = 1;
        version = _getInitializedVersion();
    }
}
