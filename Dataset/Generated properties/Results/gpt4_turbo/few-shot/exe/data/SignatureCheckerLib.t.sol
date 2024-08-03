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

    function setUp() public {
        // Setup code here, if necessary
    }

//    function testIsValidSignatureNow() public {
//        // Simulate a valid signature check
//        bool result = SignatureCheckerLib.isValidSignatureNow(TEST_SIGNER, TEST_HASH, TEST_SIGNATURE);
//        assertTrue(result, "The signature should be valid");
//    }

    function testIsValidSignatureNowWithInvalidSignature() public {
        // Simulate an invalid signature check
        bytes memory invalidSignature = hex"baadf00d";
        bool result = SignatureCheckerLib.isValidSignatureNow(TEST_SIGNER, TEST_HASH, invalidSignature);
        assertFalse(result, "The signature should be invalid");
    }

//    function testIsValidSignatureNowCalldata() public {
//        // Simulate a valid signature check using calldata
//        bool result = SignatureCheckerLib.isValidSignatureNowCalldata(TEST_SIGNER, TEST_HASH, TEST_SIGNATURE);
//        assertTrue(result, "The signature should be valid");
//    }

//    function testIsValidSignatureNowCalldataWithInvalidSignature() public {
//        // Simulate an invalid signature check using calldata
//        bytes memory invalidSignature = hex"baadf00d";
//        bool result = SignatureCheckerLib.isValidSignatureNowCalldata(TEST_SIGNER, TEST_HASH, invalidSignature);
//        assertFalse(result, "The signature should be invalid");
//    }

    function testIsValidERC1271SignatureNow() public {
        // Assuming ERC1271 implementation that always returns true for any signature
        address mockERC1271Signer = address(new MockERC1271AlwaysValid());
        bool result = SignatureCheckerLib.isValidERC1271SignatureNow(mockERC1271Signer, TEST_HASH, TEST_SIGNATURE);
        assertTrue(result, "The ERC1271 signature should be valid");
    }

    function testIsValidERC1271SignatureNowWithInvalidContract() public {
        // Assuming ERC1271 implementation that always returns false
        address mockERC1271Signer = address(new MockERC1271AlwaysInvalid());
        bool result = SignatureCheckerLib.isValidERC1271SignatureNow(mockERC1271Signer, TEST_HASH, TEST_SIGNATURE);
        assertFalse(result, "The ERC1271 signature should be invalid");
    }

    function testToEthSignedMessageHash() public {
        // Test the hash conversion
        bytes32 ethSignedMessageHash = SignatureCheckerLib.toEthSignedMessageHash(TEST_HASH);
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", TEST_HASH));
        assertEq(ethSignedMessageHash, expectedHash, "The hashes should match");
    }

    function testEmptySignature() public {
        // Test the empty signature helper
        bytes memory signature = SignatureCheckerLib.emptySignature();
        assertEq(signature.length, 0, "The signature should be empty");
    }


}

    // Mock contracts for ERC1271 testing
    contract MockERC1271AlwaysValid {
        function isValidSignature(bytes32, bytes memory) external pure returns (bytes4) {
            return 0x1626ba7e;
        }
    }

    contract MockERC1271AlwaysInvalid {
        function isValidSignature(bytes32, bytes memory) external pure returns (bytes4) {
            return 0xffffffff;
        }
    }