// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {LibClone} from "../src/utils/LibClone.sol";
import {Clone} from "../src/utils/Clone.sol";

contract LibCloneTest is Test {
    address internal alice = address(0x123);
    address internal bob = address(0x456);

    function testCloneDeterministic(address implementation, bytes32 salt) public {
        address predicted = LibClone.predictDeterministicAddress(implementation, salt, address(this));
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertEq(predicted, instance);
    }

    function testCloneDeterministic_value(address implementation, bytes32 salt, uint256 value)
        public
    {
        vm.assume(value < 1000 ether);
        address predicted = LibClone.predictDeterministicAddress(implementation, salt, address(this));
        vm.deal(address(this), value);
        address instance = LibClone.cloneDeterministic(value, implementation, salt);
        assertEq(predicted, instance);
    }

    function testCloneDeterministic_PUSH0(address implementation, bytes32 salt) public {
        address predicted = LibClone.predictDeterministicAddress_PUSH0(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.cloneDeterministic_PUSH0(implementation, salt);
        assertEq(predicted, instance);
    }

    function testCloneDeterministic_PUSH0_value(
        address implementation,
        bytes32 salt,
        uint256 value
    ) public {
        vm.assume(value < 1000 ether);
        address predicted = LibClone.predictDeterministicAddress_PUSH0(
            implementation,
            salt,
            address(this)
        );
        vm.deal(address(this), value);
        address instance = LibClone.cloneDeterministic_PUSH0(value, implementation, salt);
        assertEq(predicted, instance);
    }

    function testClone(address implementation) public {
        address instance = LibClone.clone(implementation);
        assertEq(keccak256(getCode(instance)), keccak256(getCode(implementation)));
    }

    function testClone_value(address implementation, uint256 value) public {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        address instance = LibClone.clone(value, implementation);
        assertEq(keccak256(getCode(instance)), keccak256(getCode(implementation)));
    }

    function testClone_PUSH0(address implementation) public {
        address instance = LibClone.clone_PUSH0(implementation);
        assertEq(keccak256(getCode(instance)), keccak256(getCode(implementation)));
    }

    function testClone_PUSH0_value(address implementation, uint256 value) public {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        address instance = LibClone.clone_PUSH0(value, implementation);
        assertEq(keccak256(getCode(instance)), keccak256(getCode(implementation)));
    }

    function testDeployERC1967(address implementation) public {
        address instance = LibClone.deployERC1967(implementation);
        assertEq(keccak256(getCode(instance)), LibClone.ERC1967_CODE_HASH);
    }

    function testDeployERC1967_value(address implementation, uint256 value) public {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        address instance = LibClone.deployERC1967(value, implementation);
        assertEq(keccak256(getCode(instance)), LibClone.ERC1967_CODE_HASH);
    }

    function testDeployDeterministicERC1967(address implementation, bytes32 salt) public {
        address predicted = LibClone.predictDeterministicAddressERC1967(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.deployDeterministicERC1967(implementation, salt);
        assertEq(predicted, instance);
    }

    function testDeployDeterministicERC1967_value(
        address implementation,
        bytes32 salt,
        uint256 value
    ) public {
        vm.assume(value < 1000 ether);
        address predicted = LibClone.predictDeterministicAddressERC1967(
            implementation,
            salt,
            address(this)
        );
        vm.deal(address(this), value);
        address instance = LibClone.deployDeterministicERC1967(value, implementation, salt);
        assertEq(predicted, instance);
    }

    function testCreateDeterministicERC1967(address implementation, bytes32 salt) public {
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(
            implementation,
            salt
        );
        address predicted = LibClone.predictDeterministicAddressERC1967(
            implementation,
            salt,
            address(this)
        );
        assertEq(instance, predicted);
        if (!alreadyDeployed) {
            assertEq(keccak256(getCode(instance)), LibClone.ERC1967_CODE_HASH);
        }
    }

    function testCreateDeterministicERC1967_value(
        address implementation,
        bytes32 salt,
        uint256 value
    ) public {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967(
            value,
            implementation,
            salt
        );
        address predicted = LibClone.predictDeterministicAddressERC1967(
            implementation,
            salt,
            address(this)
        );
        assertEq(instance, predicted);
        if (!alreadyDeployed) {
            assertEq(keccak256(getCode(instance)), LibClone.ERC1967_CODE_HASH);
        }
    }

    function testDeployERC1967I(address implementation) public {
        address instance = LibClone.deployERC1967I(implementation);
        assertEq(keccak256(getCode(instance)), LibClone.ERC1967I_CODE_HASH);
    }

    function testDeployERC1967I_value(address implementation, uint256 value) public {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        address instance = LibClone.deployERC1967I(value, implementation);
        assertEq(keccak256(getCode(instance)), LibClone.ERC1967I_CODE_HASH);
    }

    function testDeployDeterministicERC1967I(address implementation, bytes32 salt) public {
        address predicted = LibClone.predictDeterministicAddressERC1967I(
            implementation,
            salt,
            address(this)
        );
        address instance = LibClone.deployDeterministicERC1967I(implementation, salt);
        assertEq(predicted, instance);
    }

    function testDeployDeterministicERC1967I_value(
        address implementation,
        bytes32 salt,
        uint256 value
    ) public {
        vm.assume(value < 1000 ether);
        address predicted = LibClone.predictDeterministicAddressERC1967I(
            implementation,
            salt,
            address(this)
        );
        vm.deal(address(this), value);
        address instance = LibClone.deployDeterministicERC1967I(value, implementation, salt);
        assertEq(predicted, instance);
    }

    function testCreateDeterministicERC1967I(address implementation, bytes32 salt) public {
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(
            implementation,
            salt
        );
        address predicted = LibClone.predictDeterministicAddressERC1967I(
            implementation,
            salt,
            address(this)
        );
        assertEq(instance, predicted);
        if (!alreadyDeployed) {
            assertEq(keccak256(getCode(instance)), LibClone.ERC1967I_CODE_HASH);
        }
    }

    function testCreateDeterministicERC1967I_value(
        address implementation,
        bytes32 salt,
        uint256 value
    ) public {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        (bool alreadyDeployed, address instance) = LibClone.createDeterministicERC1967I(
            value,
            implementation,
            salt
        );
        address predicted = LibClone.predictDeterministicAddressERC1967I(
            implementation,
            salt,
            address(this)
        );
        assertEq(instance, predicted);
        if (!alreadyDeployed) {
            assertEq(keccak256(getCode(instance)), LibClone.ERC1967I_CODE_HASH);
        }
    }

    function testConstantERC1967Bootstrap() public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        assertEq(bootstrap, LibClone.constantERC1967BootstrapAddress());
    }

    function testBootstrapERC1967(address implementation, bytes32 salt) public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        address instance = LibClone.deployDeterministicERC1967(bootstrap, salt);
        LibClone.bootstrapERC1967(instance, implementation);
        (bool success, bytes memory result) = instance.delegatecall("");
        assertTrue(success);
        assertEq(result.length, 32);
        assertEq(bytes32(result), bytes32(uint256(uint160(implementation))));
    }

    function testCloneDeterministic_data(address implementation, bytes calldata data, bytes32 salt)
        public
    {
        address predicted = LibClone.predictDeterministicAddress(implementation, data, salt, address(this));
        address instance = LibClone.cloneDeterministic(implementation, data, salt);
        assertEq(predicted, instance);
    }

    function testCloneDeterministic_data_value(
        address implementation,
        bytes calldata data,
        bytes32 salt,
        uint256 value
    ) public {
        vm.assume(value < 1000 ether);
        address predicted = LibClone.predictDeterministicAddress(implementation, data, salt, address(this));
        vm.deal(address(this), value);
        address instance = LibClone.cloneDeterministic(value, implementation, data, salt);
        assertEq(predicted, instance);
    }

    function testClone_data(address implementation, bytes calldata data) public {
        address instance = LibClone.clone(implementation, data);
        (bool success, bytes memory result) = instance.delegatecall("");
        assertTrue(success);
        assertEq(result, data);
    }

    function testClone_data_value(address implementation, bytes calldata data, uint256 value)
        public
    {
        vm.assume(value < 1000 ether);
        vm.deal(address(this), value);
        address instance = LibClone.clone(value, implementation, data);
        (bool success, bytes memory result) = instance.delegatecall("");
        assertTrue(success);
        assertEq(result, data);
    }

    function testCheckStartsWith(bytes32 salt) public {
        LibClone.checkStartsWith(salt, address(0));
        LibClone.checkStartsWith(salt, address(this));
    }

    function testCheckStartsWith_revert(bytes32 salt, address by) public {
        vm.assume(by != address(0) && by != address(this));
        vm.expectRevert(LibClone.SaltDoesNotStartWith.selector);
        LibClone.checkStartsWith(salt, by);
    }

    function getCode(address who) internal view returns (bytes memory code) {
        /// @solidity memory-safe-assembly
        assembly {
            code := mload(0x40)
            let size := extcodesize(who)
            if size {
                code := mload(0x40)
                let end := add(code, size)
                extcodecopy(who, code, 0, size)
                mstore(0x40, end)
            }
        }
    }
}