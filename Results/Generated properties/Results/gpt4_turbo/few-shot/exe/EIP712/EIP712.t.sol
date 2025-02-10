// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {EIP712} from "../src/utils/EIP712.sol";

contract EIP712Test is Test, EIP712 {
    bytes32 constant TEST_STRUCT_HASH = keccak256("Test(address testAddress,uint256 testNumber)");
    address constant TEST_ADDRESS = 0x1234567890123456789012345678901234567890;
    uint256 constant TEST_NUMBER = 123456;

    function setUp() public {
        // Setup code if needed
    }

//    function testDomainSeparator() public {
//        bytes32 calculatedDomainSeparator = _domainSeparator();
//        bytes32 expectedDomainSeparator = _buildDomainSeparator();
//        assertEq(calculatedDomainSeparator, expectedDomainSeparator, "Domain separator mismatch");
//    }

    function testHashTypedData() public {
        bytes32 structHash = keccak256(abi.encode(TEST_STRUCT_HASH, TEST_ADDRESS, TEST_NUMBER));
        bytes32 typedDataHash = _hashTypedData(structHash);
        bytes32 expectedHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                _domainSeparator(),
                structHash
            )
        );
        assertEq(typedDataHash, expectedHash, "Typed data hash mismatch");
    }

    function testEIP712Domain() public {
        (bytes1 fields, string memory name, string memory version, uint256 chainId, address verifyingContract, bytes32 salt, uint256[] memory extensions) = eip712Domain();
        assertEq(fields, hex"0f", "Fields mismatch");
        assertEq(name, "EIP712Test", "Name mismatch");
        assertEq(version, "1", "Version mismatch");
        assertEq(chainId, block.chainid, "Chain ID mismatch");
        assertEq(verifyingContract, address(this), "Verifying contract mismatch");
        assertEq(salt, bytes32(0), "Salt mismatch");
        assertEq(extensions.length, 0, "Extensions should be empty");
    }

//    function testBuildDomainSeparator() public {
//        bytes32 separator = _buildDomainSeparator();
//        (string memory name, string memory version) = _domainNameAndVersion();
//        bytes32 nameHash = keccak256(bytes(name));
//        bytes32 versionHash = keccak256(bytes(version));
//        bytes32 expectedSeparator = keccak256(
//            abi.encode(
//                _DOMAIN_TYPEHASH,
//                nameHash,
//                versionHash,
//                block.chainid,
//                address(this)
//            )
//        );
//        assertEq(separator, expectedSeparator, "Built domain separator mismatch");
//    }

//    function testCachedDomainSeparatorInvalidated() public {
//        bool invalidated = _cachedDomainSeparatorInvalidated();
//        assertFalse(invalidated, "Domain separator should not be invalidated");
//    }

    function _domainNameAndVersion()
        internal
        view
        override
        returns (string memory name, string memory version)
    {
        name = "EIP712Test";
        version = "1";
    }
}