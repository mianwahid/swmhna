// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibClone.sol";

contract LibCloneTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    address internal constant DEPLOYER = address(0x1337);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST HELPERS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _checkDeploymentFailed(address instance) internal {
        if (instance != address(0)) {
            console2.logBytes(abi.encodePacked(LibClone.initCode(address(this))));
            console2.logBytes(address(this).code);
        }
        assertTrue(instance == address(0));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           TESTS                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testClone(address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.clone(implementation);
        assertTrue(instance != address(0));
        assertTrue(instance.code.length != 0);
        assertEq(instance.code, LibClone.initCode(implementation));
    }

    function testCloneDeploymentFailed() public {
        _checkDeploymentFailed(LibClone.clone(address(0)));
    }

    function testCloneWithValue(uint256 value, address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.clone(value, implementation);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(instance.code, LibClone.initCode(implementation));
    }

    function testCloneWithValueDeploymentFailed(uint256 value) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.clone(value, address(0)));
    }

    function testCloneDeterministic(address implementation, bytes32 salt) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.cloneDeterministic(implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance, LibClone.predictDeterministicAddress(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCode(implementation));
    }

    function testCloneDeterministicDeploymentFailed(bytes32 salt) public {
        _checkDeploymentFailed(LibClone.cloneDeterministic(address(0), salt));
    }

    function testCloneDeterministicWithValue(uint256 value, address implementation, bytes32 salt)
        public
    {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.cloneDeterministic(value, implementation, salt);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(
            instance, LibClone.predictDeterministicAddress(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCode(implementation));
    }

    function testCloneDeterministicWithValueDeploymentFailed(uint256 value, bytes32 salt)
        public
    {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.cloneDeterministic(value, address(0), salt));
    }

    function testInitCodeHash(address implementation) public {
        bytes memory initCode = LibClone.initCode(implementation);
        bytes32 hash = keccak256(initCode);
        assertEq(hash, LibClone.initCodeHash(implementation));
    }

    function testPredictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) public {
        address predicted = LibClone.predictDeterministicAddress(implementation, salt, deployer);
        bytes memory initCode = LibClone.initCode(implementation);
        address instance = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            deployer,
            salt,
            keccak256(initCode)
        )))));
        assertEq(predicted, instance);
    }

    function testCheckStartsWith(bytes32 salt, address by) public {
        vm.assume(
            salt != bytes32(0) && by != address(0) && uint256(salt) != uint160(by)
        );
        bytes32 newSalt = bytes32(uint256(keccak256(abi.encodePacked(salt, by))));
//        vm.assume(uint256(newSalt) > uint256(bytes32(uint160(by))));
        vm.prank(DEPLOYER);
        if (uint256(newSalt) & 0xffffffffffffffffffffffffffffffffffffffff0000000000000000
            == 0)
        {
            LibClone.checkStartsWith(newSalt, address(0));
        } else {
            LibClone.checkStartsWith(newSalt, by);
        }
    }

    function testCheckStartsWithSaltDoesNotStartWith(bytes32 salt, address by) public {
        vm.assume(
            salt != bytes32(0) && by != address(0) && uint256(salt) != uint160(by)
        );
        bytes32 newSalt = bytes32(uint256(keccak256(abi.encodePacked(salt, by))));
        vm.assume(
            uint256(newSalt) & 0xffffffffffffffffffffffffffffffffffffffff0000000000000000
                != 0
                && uint256(newSalt) & 0xffffffffffffffffffffffffffffffffffffffff0000000000000000
                != uint160(by) << 96
        );
        vm.prank(DEPLOYER);
        vm.expectRevert(abi.encodeWithSelector(LibClone.SaltDoesNotStartWith.selector));
        LibClone.checkStartsWith(newSalt, by);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              MINIMAL PROXY OPERATIONS (PUSH0)              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testClone_PUSH0(address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.clone_PUSH0(implementation);
        assertTrue(instance != address(0));
        assertTrue(instance.code.length != 0);
        assertEq(instance.code, LibClone.initCode_PUSH0(implementation));
    }

    function testClone_PUSH0DeploymentFailed() public {
        _checkDeploymentFailed(LibClone.clone_PUSH0(address(0)));
    }

    function testClone_PUSH0WithValue(uint256 value, address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.clone_PUSH0(value, implementation);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(instance.code, LibClone.initCode_PUSH0(implementation));
    }

    function testClone_PUSH0WithValueDeploymentFailed(uint256 value) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.clone_PUSH0(value, address(0)));
    }

    function testCloneDeterministic_PUSH0(address implementation, bytes32 salt) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.cloneDeterministic_PUSH0(implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddress_PUSH0(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCode_PUSH0(implementation));
    }

    function testCloneDeterministic_PUSH0DeploymentFailed(bytes32 salt) public {
        _checkDeploymentFailed(LibClone.cloneDeterministic_PUSH0(address(0), salt));
    }

    function testCloneDeterministic_PUSH0WithValue(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.cloneDeterministic_PUSH0(value, implementation, salt);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(
            instance,
            LibClone.predictDeterministicAddress_PUSH0(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCode_PUSH0(implementation));
    }

    function testCloneDeterministic_PUSH0WithValueDeploymentFailed(
        uint256 value,
        bytes32 salt
    ) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.cloneDeterministic_PUSH0(value, address(0), salt));
    }

    function testInitCodeHash_PUSH0(address implementation) public {
        bytes memory initCode = LibClone.initCode_PUSH0(implementation);
        bytes32 hash = keccak256(initCode);
        assertEq(hash, LibClone.initCodeHash_PUSH0(implementation));
    }

    function testPredictDeterministicAddress_PUSH0(
        address implementation,
        bytes32 salt,
        address deployer
    ) public {
        address predicted =
            LibClone.predictDeterministicAddress_PUSH0(implementation, salt, deployer);
        bytes memory initCode = LibClone.initCode_PUSH0(implementation);
        address instance = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            deployer,
            salt,
            keccak256(initCode)
        )))));
        assertEq(predicted, instance);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*           CLONES WITH IMMUTABLE ARGS OPERATIONS            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testCloneWithData(address implementation, bytes calldata data) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.clone(implementation, data);
        assertTrue(instance != address(0));
        assertTrue(instance.code.length != 0);
    }

    function testCloneWithDataDeploymentFailed(bytes calldata data) public {
        _checkDeploymentFailed(LibClone.clone(address(0), data));
    }

    function testCloneWithDataWithValue(uint256 value, address implementation, bytes calldata data)
        public
    {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.clone(value, implementation, data);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
    }

    function testCloneWithDataWithValueDeploymentFailed(uint256 value, bytes calldata data)
        public
    {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.clone(value, address(0), data));
    }

    function testCloneDeterministicWithData(
        address implementation,
        bytes calldata data,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.cloneDeterministic(implementation, data, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddress(implementation, data, salt, address(this))
        );
    }

    function testCloneDeterministicWithDataDeploymentFailed(bytes calldata data, bytes32 salt)
        public
    {
        _checkDeploymentFailed(LibClone.cloneDeterministic(address(0), data, salt));
    }

    function testCloneDeterministicWithDataWithValue(
        uint256 value,
        address implementation,
        bytes calldata data,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.cloneDeterministic(value, implementation, data, salt);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(
            instance,
            LibClone.predictDeterministicAddress(implementation, data, salt, address(this))
        );
    }

    function testCloneDeterministicWithDataWithValueDeploymentFailed(
        uint256 value,
        bytes calldata data,
        bytes32 salt
    ) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.cloneDeterministic(value, address(0), data, salt));
    }

    function testInitCodeWithDataHash(address implementation, bytes calldata data) public {
        bytes memory initCode = LibClone.initCode(implementation, data);
        bytes32 hash = keccak256(initCode);
        assertEq(hash, LibClone.initCodeHash(implementation, data));
    }

    function testPredictDeterministicAddressWithData(
        address implementation,
        bytes calldata data,
        bytes32 salt,
        address deployer
    ) public {
        address predicted =
            LibClone.predictDeterministicAddress(implementation, data, salt, deployer);
        bytes memory initCode = LibClone.initCode(implementation, data);
        address instance = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            deployer,
            salt,
            keccak256(initCode)
        )))));
        assertEq(predicted, instance);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              MINIMAL ERC1967 PROXY OPERATIONS              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDeployERC1967(address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.deployERC1967(implementation);
        assertTrue(instance != address(0));
        assertTrue(instance.code.length != 0);
        assertEq(instance.code, LibClone.initCodeERC1967(implementation));
    }

    function testDeployERC1967DeploymentFailed() public {
        _checkDeploymentFailed(LibClone.deployERC1967(address(0)));
    }

    function testDeployERC1967WithValue(uint256 value, address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.deployERC1967(value, implementation);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(instance.code, LibClone.initCodeERC1967(implementation));
    }

    function testDeployERC1967WithValueDeploymentFailed(uint256 value) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.deployERC1967(value, address(0)));
    }

    function testDeployDeterministicERC1967(address implementation, bytes32 salt) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.deployDeterministicERC1967(implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCodeERC1967(implementation));
    }

    function testDeployDeterministicERC1967DeploymentFailed(bytes32 salt) public {
        _checkDeploymentFailed(LibClone.deployDeterministicERC1967(address(0), salt));
    }

    function testDeployDeterministicERC1967WithValue(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.deployDeterministicERC1967(value, implementation, salt);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCodeERC1967(implementation));
    }

    function testDeployDeterministicERC1967WithValueDeploymentFailed(
        uint256 value,
        bytes32 salt
    ) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(
            LibClone.deployDeterministicERC1967(value, address(0), salt)
        );
    }

    function testCreateDeterministicERC1967(address implementation, bytes32 salt) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967(implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
        if (!alreadyDeployed) {
            assertEq(instance.code, LibClone.initCodeERC1967(implementation));
        }
    }

    function testCreateDeterministicERC1967WithValue(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967(value, implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967(implementation, salt, address(this))
        );
        if (!alreadyDeployed) {
            assertEq(instance.code, LibClone.initCodeERC1967(implementation));
        }
    }

    function testInitCodeHashERC1967(address implementation) public {
        bytes memory initCode = LibClone.initCodeERC1967(implementation);
        bytes32 hash = keccak256(initCode);
        assertEq(hash, LibClone.initCodeHashERC1967(implementation));
    }

    function testPredictDeterministicAddressERC1967(
        address implementation,
        bytes32 salt,
        address deployer
    ) public {
        address predicted =
            LibClone.predictDeterministicAddressERC1967(implementation, salt, deployer);
        bytes memory initCode = LibClone.initCodeERC1967(implementation);
        address instance = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            deployer,
            salt,
            keccak256(initCode)
        )))));
        assertEq(predicted, instance);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                 ERC1967I PROXY OPERATIONS                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDeployERC1967I(address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.deployERC1967I(implementation);
        assertTrue(instance != address(0));
        assertTrue(instance.code.length != 0);
        assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
    }

    function testDeployERC1967IDeploymentFailed() public {
        _checkDeploymentFailed(LibClone.deployERC1967I(address(0)));
    }

    function testDeployERC1967IWithValue(uint256 value, address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.deployERC1967I(value, implementation);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
    }

    function testDeployERC1967IWithValueDeploymentFailed(uint256 value) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(LibClone.deployERC1967I(value, address(0)));
    }

    function testDeployDeterministicERC1967I(address implementation, bytes32 salt) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address instance = LibClone.deployDeterministicERC1967I(implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
    }

    function testDeployDeterministicERC1967IDeploymentFailed(bytes32 salt) public {
        _checkDeploymentFailed(LibClone.deployDeterministicERC1967I(address(0), salt));
    }

    function testDeployDeterministicERC1967IWithValue(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        address instance = LibClone.deployDeterministicERC1967I(value, implementation, salt);
        assertTrue(instance != address(0));
        assertEq(instance.balance, value);
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
        assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
    }

    function testDeployDeterministicERC1967IWithValueDeploymentFailed(
        uint256 value,
        bytes32 salt
    ) public {
        vm.assume(value < 2 ** 128);
        _checkDeploymentFailed(
            LibClone.deployDeterministicERC1967I(value, address(0), salt)
        );
    }

    function testCreateDeterministicERC1967I(address implementation, bytes32 salt) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967I(implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
        if (!alreadyDeployed) {
            assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
        }
    }

    function testCreateDeterministicERC1967IWithValue(
        uint256 value,
        address implementation,
        bytes32 salt
    ) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        vm.assume(value < 2 ** 128);
        (bool alreadyDeployed, address instance) =
            LibClone.createDeterministicERC1967I(value, implementation, salt);
        assertTrue(instance != address(0));
        assertEq(
            instance,
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, address(this))
        );
        if (!alreadyDeployed) {
            assertEq(instance.code, LibClone.initCodeERC1967I(implementation));
        }
    }

    function testInitCodeHashERC1967I(address implementation) public {
        bytes memory initCode = LibClone.initCodeERC1967I(implementation);
        bytes32 hash = keccak256(initCode);
        assertEq(hash, LibClone.initCodeHashERC1967I(implementation));
    }

    function testPredictDeterministicAddressERC1967I(
        address implementation,
        bytes32 salt,
        address deployer
    ) public {
        address predicted =
            LibClone.predictDeterministicAddressERC1967I(implementation, salt, deployer);
        bytes memory initCode = LibClone.initCodeERC1967I(implementation);
        address instance = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            deployer,
            salt,
            keccak256(initCode)
        )))));
        assertEq(predicted, instance);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*            CONSTANT ERC1967 BOOTSTRAP OPERATIONS           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testConstantERC1967Bootstrap() public {
        address bootstrap = LibClone.constantERC1967Bootstrap();
        assertTrue(bootstrap != address(0));
        assertTrue(bootstrap.code.length != 0);
        assertEq(bootstrap, LibClone.constantERC1967BootstrapAddress());
    }

    function testBootstrapERC1967(address implementation) public {
        vm.assume(implementation != address(0) && implementation.code.length != 0);
        address bootstrap = LibClone.constantERC1967Bootstrap();
        assertTrue(bootstrap != address(0));
        assertTrue(bootstrap.code.length != 0);
        LibClone.bootstrapERC1967(bootstrap, implementation);
    }
}