// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    event ReceiveETH(uint256 value);

    address internal constant _IMPLEMENTATION = address(0x1234);

//    function testClone(address implementation) public {
//        address instance = LibClone.clone(implementation);
//        assertEq(instance.code, LibClone.initCode(implementation));
//    }

    function testCloneDeterministic(address implementation, bytes32 salt) public {
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertEq(instance, LibClone.predictDeterministicAddress(implementation, salt, address(this)));
    }

    function testCloneDeterministicETH(uint256 value, address implementation, bytes32 salt)
        public
    {
        vm.assume(value < 100 ether);
        vm.deal(address(this), value);
        address instance = LibClone.cloneDeterministic(value, implementation, salt);
        assertEq(instance.balance, value);
    }

//    function testCloneWithImmutableArgs(address implementation, bytes calldata data) public {
//        address instance = LibClone.clone(implementation, data);
//        assertEq(instance.code, LibClone.initCode(implementation, data));
//    }

    function testCloneWithImmutableArgsDeterministic(
        address implementation,
        bytes calldata data,
        bytes32 salt
    ) public {
        address instance = LibClone.cloneDeterministic(implementation, data, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddress(implementation, data, salt, address(this))
        );
    }

    function testCloneWithImmutableArgsDeterministicETH(
        uint256 value,
        address implementation,
        bytes calldata data,
        bytes32 salt
    ) public {
        vm.assume(value < 100 ether);
        vm.deal(address(this), value);
        address instance = LibClone.cloneDeterministic(value, implementation, data, salt);
        assertEq(instance.balance, value);
    }

    function testCloneWithImmutableArgsDeterministicETHZeroValue(
        address implementation,
        bytes calldata data,
        bytes32 salt
    ) public {
        address instance = LibClone.cloneDeterministic(0, implementation, data, salt);
        assertEq(instance.balance, 0);
    }

    function testCloneWithImmutableArgsReceiveETH(bytes calldata data) public {
        vm.expectEmit(true, true, true, true);
        emit ReceiveETH(123);
        (bool success,) =
            LibClone.clone(implementation(), data).call{value: 123}("");
        assertEq(success, true);
    }

//    function testDeployERC1967(address implementation) public {
//        address instance = LibClone.deployERC1967(implementation);
//        assertEq(instance.code, LibClone.initCodeERC1967(implementation));
//    }

    function testDeployDeterministicERC1967(address implementation, bytes32 salt) public {
        address instance = LibClone.deployDeterministicERC1967(implementation, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
    }

    function testDeployDeterministicERC1967ETH(uint256 value, address implementation, bytes32 salt)
        public
    {
        vm.assume(value < 100 ether);
        vm.deal(address(this), value);
        address instance = LibClone.deployDeterministicERC1967(value, implementation, salt);
        assertEq(instance.balance, value);
    }

    function testCreateDeterministicERC1967(address implementation, bytes32 salt) public {
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967(implementation, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
        if (alreadyDeployed) {
            assertEq(instance.code.length, 0);
        } else {
            assertGt(instance.code.length, 0);
        }
    }

    function testCreateDeterministicERC1967ETH(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(value < 100 ether);
        vm.deal(address(this), value);
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967(value, implementation, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
        if (alreadyDeployed) {
            assertEq(instance.code.length, 0);
        } else {
            assertGt(instance.code.length, 0);
        }
        assertEq(instance.balance, value);
    }

//    function testDeployERC1967IBootstrap(address implementation) public {
//        address bootstrap = LibClone.constantERC1967Bootstrap();
//        assertEq(bootstrap.code.length, 0x2e);
//        address instance = LibClone.deployDeterministicERC1967(0, bootstrap, bytes32(0));
//        assertEq(instance.code.length, 0x5f);
//        LibClone.bootstrapERC1967(bootstrap, implementation);
//        assertEq(instance.code, LibClone.initCodeERC1967(implementation));
//    }

//    function testDeployERC1967I(address implementation) public {
//        address instance = LibClone.deployERC1967I(implementation);
//        assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
//    }

    function testDeployDeterministicERC1967I(address implementation, bytes32 salt) public {
        address instance = LibClone.deployDeterministicERC1967I(implementation, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
    }

    function testDeployDeterministicERC1967IETH(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(value < 100 ether);
        vm.deal(address(this), value);
        address instance = LibClone.deployDeterministicERC1967I(value, implementation, salt);
        assertEq(instance.balance, value);
    }

    function testCreateDeterministicERC1967I(address implementation, bytes32 salt) public {
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967I(implementation, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
        if (alreadyDeployed) {
            assertEq(instance.code.length, 0);
        } else {
            assertGt(instance.code.length, 0);
        }
    }

    function testCreateDeterministicERC1967IETH(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(value < 100 ether);
        vm.deal(address(this), value);
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967I(value, implementation, salt);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
        if (alreadyDeployed) {
            assertEq(instance.code.length, 0);
        } else {
            assertGt(instance.code.length, 0);
        }
        assertEq(instance.balance, value);
    }

//    function testFuzz_SaltDoesNotStartWith(bytes32 salt, address by) public {
//        vm.assume(salt != bytes32(0));
//        vm.assume(uint256(salt) >> 96 != uint160(by));
//        vm.expectRevert(LibClone.SaltDoesNotStartWith.selector);
//        LibClone.checkStartsWith(salt, by);
//    }

    function implementation() internal pure returns (address) {
        return _IMPLEMENTATION;
    }
}