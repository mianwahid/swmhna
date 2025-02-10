// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/utils/ERC1967FactoryConstants.sol";

contract ERC1967FactoryConstantsTest is Test {
    /// @notice Test to ensure the ADDRESS constant is correct and has bytecode.
    function testAddressHasBytecode() public {
        address factoryAddress = ERC1967FactoryConstants.ADDRESS;
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(factoryAddress)
        }
        assertGt(codeSize, 0, "Factory address should have bytecode");
    }

    /// @notice Test to ensure the BYTECODE constant matches the deployed bytecode.
    function testBytecodeMatches() public {
        address factoryAddress = ERC1967FactoryConstants.ADDRESS;
        bytes memory deployedBytecode = address(factoryAddress).code;
        assertEq(deployedBytecode, ERC1967FactoryConstants.BYTECODE, "Deployed bytecode does not match the constant");
    }

    /// @notice Test to ensure the INITCODE generates the correct address using create2.
    function testInitCodeGeneratesCorrectAddress() public {
        bytes32 salt = ERC1967FactoryConstants.SALT;
        bytes memory initCode = ERC1967FactoryConstants.INITCODE;
        address computedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this), // deployer address, change if using a factory contract
            salt,
            keccak256(initCode)
        )))));

        assertEq(computedAddress, ERC1967FactoryConstants.ADDRESS, "Computed address does not match the constant address");
    }

    /// @notice Fuzz test for the integrity of the SALT and INITCODE constants.
    function testFuzzInitCodeAndSalt(bytes32 randomSalt, bytes memory randomInitCode) public {
        // Skip the test if random values match the constants to avoid false positives
        if (randomSalt == ERC1967FactoryConstants.SALT && keccak256(randomInitCode) == keccak256(ERC1967FactoryConstants.INITCODE)) {
            return;
        }

        address computedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this), // deployer address, change if using a factory contract
            randomSalt,
            keccak256(randomInitCode)
        )))));

        // Assert that no other salt and initcode combination can create the same address
        assertNotEq(computedAddress, ERC1967FactoryConstants.ADDRESS, "Different salt and initcode should not create the same address");
    }
}