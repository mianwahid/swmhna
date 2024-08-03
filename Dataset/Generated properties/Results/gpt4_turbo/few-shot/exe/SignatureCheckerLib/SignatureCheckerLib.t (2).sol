// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    // Test variables
    address constant TEST_SIGNER = address(0x123);
    bytes32 constant TEST_HASH = keccak256("Hello, world!");
    bytes constant TEST_SIGNATURE = hex"deadbeef";

    function testIsValidSignatureNow() public {
        // Simulate a valid ECDSA signature (this is a dummy signature and won't actually be valid)
        bytes memory signature = hex"deadbeef";
        address signer = address(0x1); // Dummy address
        bytes32 hash = keccak256("Hello, world!");

        // Assuming the signature is valid (this should be mocked or the signature should be properly generated)
        bool result = SignatureCheckerLib.isValidSignatureNow(signer, hash, signature);
        assertTrue(result, "The signature should be valid.");
    }

    function testIsValidSignatureNowWithInvalidSignature() public {
        // Simulate an invalid ECDSA signature
        bytes memory signature = hex"baadf00d";
        address signer = address(0x1); // Dummy address
        bytes32 hash = keccak256("Hello, world!");

        // Assuming the signature is invalid
        bool result = SignatureCheckerLib.isValidSignatureNow(signer, hash, signature);
        assertFalse(result, "The signature should be invalid.");
    }

    function testIsValidSignatureNowWithERC1271() public {
        // Deploy a mock ERC1271 contract that will return valid for any signatures
        MockERC1271 mock = new MockERC1271();
        address signer = address(mock); // Use the mock contract's address as the signer
        bytes32 hash = keccak256("Hello, world!");
        bytes memory signature = hex"deadbeef";

        // The mock should return valid for any signature
        bool result = SignatureCheckerLib.isValidSignatureNow(signer, hash, signature);
        assertTrue(result, "The ERC1271 signature should be valid.");
    }

    function testToEthSignedMessageHash() public {
        bytes32 hash = keccak256("Hello, world!");
        bytes32 ethSignedMessageHash = SignatureCheckerLib.toEthSignedMessageHash(hash);

        // Check the hash
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        assertEq(ethSignedMessageHash, expectedHash, "The Ethereum signed message hash does not match.");
    }

    function testEmptySignature() public {
        bytes memory signature = SignatureCheckerLib.emptySignature();
        assertEq(signature.length, 0, "The signature should be empty.");
    }
}

// Mock ERC1271 contract
contract MockERC1271 {
    // Magic value to be returned by isValidSignature
    bytes4 constant MAGIC_VALUE = 0x1626ba7e;

    function isValidSignature(bytes32, bytes memory) external pure returns (bytes4) {
        return MAGIC_VALUE;
    }
}