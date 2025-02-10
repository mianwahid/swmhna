// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    bytes32 constant TEST_HASH = keccak256("Hello, world!");
    address constant EXPECTED_SIGNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Example address

    function setUp() public {
        // Setup code here if needed
    }

//    function testRecover() public {
//        // Example signature components for the hash "Hello, world!" signed by EXPECTED_SIGNER
//        bytes32 r = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
//        bytes32 s = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
//        uint8 v = 27; // Commonly 27 or 28
//
//        address signer = ECDSA.recover(TEST_HASH, v, r, s);
//        assertEq(signer, EXPECTED_SIGNER, "Recovered address does not match expected signer");
//    }

    function testRecoverWithInvalidSignature() public {
        // Invalid signature components
        bytes32 r = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
        bytes32 s = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
        uint8 v = 27; // Commonly 27 or 28

        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_HASH, v, r, s);
    }

//    function testTryRecover() public {
//        // Example signature components for the hash "Hello, world!" signed by EXPECTED_SIGNER
//        bytes32 r = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
//        bytes32 s = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
//        uint8 v = 27; // Commonly 27 or 28
//
//        address signer = ECDSA.tryRecover(TEST_HASH, v, r, s);
//        assertEq(signer, EXPECTED_SIGNER, "Recovered address does not match expected signer");
//    }

    function testTryRecoverWithInvalidSignature() public {
        // Invalid signature components
        bytes32 r = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
        bytes32 s = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
        uint8 v = 27; // Commonly 27 or 28

        address signer = ECDSA.tryRecover(TEST_HASH, v, r, s);
        assertEq(signer, address(0), "Recovered address should be zero for invalid signatures");
    }

    function testToEthSignedMessageHash() public {
        bytes32 hash = keccak256("Hello, world!");
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash);

        // Expected hash using the "\x19Ethereum Signed Message:\n32" prefix
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        assertEq(ethSignedMessageHash, expectedHash, "ETH signed message hash does not match expected hash");
    }

//    function testToEthSignedMessageHashWithDynamicData() public {
//        bytes memory data = "Hello, world!";
//        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(data);
//
//        // Expected hash using the "\x19Ethereum Signed Message:\n" prefix and dynamic data length
//        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", uint256(data.length).toString(), data));
//        assertEq(ethSignedMessageHash, expectedHash, "ETH signed message hash does not match expected hash for dynamic data");
//    }
}