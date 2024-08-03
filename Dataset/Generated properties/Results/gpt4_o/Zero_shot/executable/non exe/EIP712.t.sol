// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EIP712.sol";

contract EIP712Test is Test {
    EIP712Mock eip712;

    function setUp() public {
        eip712 = new EIP712Mock();
    }

//    function testDomainSeparator() public {
//        bytes32 expectedSeparator = eip712._domainSeparator();
//        bytes32 actualSeparator = eip712._buildDomainSeparator();
//        assertEq(expectedSeparator, actualSeparator, "Domain separator mismatch");
//    }

    function testHashTypedData() public {
        bytes32 structHash = keccak256(abi.encode(
            keccak256("Mail(address to,string contents)"),
            address(this),
            keccak256(bytes("Hello, world!"))
        ));
        bytes32 digest = eip712._hashTypedData(structHash);
        assertEq(digest, keccak256(abi.encodePacked("\x19\x01", eip712._domainSeparator(), structHash)), "HashTypedData mismatch");
    }

    function testEIP712Domain() public {
        (bytes1 fields, string memory name, string memory version, uint256 chainId, address verifyingContract, bytes32 salt, uint256[] memory extensions) = eip712.eip712Domain();
        assertEq(fields, hex"0f", "Fields mismatch");
        assertEq(name, "Solady", "Name mismatch");
        assertEq(version, "1", "Version mismatch");
        assertEq(chainId, block.chainid, "ChainId mismatch");
        assertEq(verifyingContract, address(eip712), "VerifyingContract mismatch");
        assertEq(salt, bytes32(0), "Salt mismatch");
        assertEq(extensions.length, 0, "Extensions length mismatch");
    }

    function testCachedDomainSeparatorInvalidated() public {
        bool invalidated = eip712._cachedDomainSeparatorInvalidated();
        assertFalse(invalidated, "Cached domain separator should not be invalidated initially");

        // Simulate chain ID change
        vm.chainId(block.chainid + 1);
        invalidated = eip712._cachedDomainSeparatorInvalidated();
        assertTrue(invalidated, "Cached domain separator should be invalidated after chain ID change");

        // Revert chain ID change
        vm.chainId(block.chainid - 1);
    }

    function testCachedDomainSeparatorInvalidatedWithAddressChange() public {
        bool invalidated = eip712._cachedDomainSeparatorInvalidated();
        assertFalse(invalidated, "Cached domain separator should not be invalidated initially");

        // Simulate address change
        address newAddress = address(uint160(address(eip712)) + 1);
        vm.prank(newAddress);
        invalidated = eip712._cachedDomainSeparatorInvalidated();
        assertTrue(invalidated, "Cached domain separator should be invalidated after address change");
    }
}

contract EIP712Mock is EIP712 {
    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {
        name = "Solady";
        version = "1";
    }

    function _domainNameAndVersionMayChange() internal pure override returns (bool result) {
        return false;
    }

    function _buildDomainSeparator() public view returns (bytes32) {
        return super._buildDomainSeparator();
    }

    function _cachedDomainSeparatorInvalidated() public view returns (bool) {
        return super._cachedDomainSeparatorInvalidated();
    }
}