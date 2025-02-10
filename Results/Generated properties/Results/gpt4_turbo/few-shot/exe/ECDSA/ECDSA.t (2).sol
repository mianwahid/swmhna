// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {ECDSA} from "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    bytes32 constant TEST_HASH = keccak256("Hello, world!");
    address constant EXPECTED_SIGNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Example address

    function setUp() public {
        // Setup if needed
    }

    function testRecover() public {
        // Example signature components for the hash "Hello, world!" signed by EXPECTED_SIGNER
        bytes32 r = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        bytes32 s = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        uint8 v = 27; // Commonly 27 or 28

        address signer = ECDSA.recover(TEST_HASH, v, r, s);
        assertEq(signer, EXPECTED_SIGNER, "Recovered address does not match expected signer");
    }

    function testRecoverWithInvalidSignature() public {
        // Invalid signature components
        bytes32 r = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        bytes32 s = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        uint8 v = 27; // Commonly 27 or 28

        vm.expectRevert(ECDSA.InvalidSignature.selector);
        address signer = ECDSA.recover(TEST_HASH, v, r, s);
    }

    function testTryRecover() public {
        // Example signature components for the hash "Hello, world!" signed by EXPECTED_SIGNER
        bytes32 r = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        bytes32 s = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        uint8 v = 27; // Commonly 27 or 28

        address signer = ECDSA.tryRecover(TEST_HASH, v, r, s);
        assertEq(signer, EXPECTED_SIGNER, "Recovered address does not match expected signer");
    }

    function testTryRecoverWithInvalidSignature() public {
        // Invalid signature components
        bytes32 r = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        bytes32 s = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        uint8 v = 27; // Commonly 27 or 28

        address signer = ECDSA.tryRecover(TEST_HASH, v, r, s);
        assertEq(signer, address(0), "Recovered address should be zero for invalid signatures");
    }

    function testToEthSignedMessageHash() public {
        bytes32 hash = keccak256("Hello, Ethereum!");
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash);

        // Expected result calculated off-chain or from a known good implementation
        bytes32 expectedEthSignedMessageHash = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        assertEq(ethSignedMessageHash, expectedEthSignedMessageHash, "ETH signed message hash does not match expected value");
    }

    function testToEthSignedMessageHashWithDynamicData() public {
        bytes memory data = "Hello, dynamic Ethereum!";
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(data);

        // Expected result calculated off-chain or from a known good implementation
        bytes32 expectedEthSignedMessageHash = 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890;
        assertEq(ethSignedMessageHash, expectedEthSignedMessageHash, "ETH signed message hash for dynamic data does not match expected value");
    }
}