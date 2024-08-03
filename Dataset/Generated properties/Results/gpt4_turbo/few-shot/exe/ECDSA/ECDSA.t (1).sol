// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {ECDSA} from "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    bytes32 constant TEST_HASH = keccak256("Hello, world!");
    address constant EXPECTED_SIGNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Example address

    function setUp() public {
        // Setup code here if needed
    }

    function testRecover() public {
        // Example private key corresponding to EXPECTED_SIGNER
        uint256 privateKey = 0xa11ce;
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, TEST_HASH);

        address recovered = ECDSA.recover(TEST_HASH, v, r, s);
        assertEq(recovered, EXPECTED_SIGNER, "Recovered address does not match expected signer");
    }

    function testRecoverWithInvalidSignature() public {
        // Intentionally corrupt the signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(0xa11ce, TEST_HASH);
        bytes32 corruptedR = bytes32(uint256(r) + 1);

        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_HASH, v, corruptedR, s);
    }

    function testTryRecover() public {
        uint256 privateKey = 0xa11ce;
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, TEST_HASH);

        address recovered = ECDSA.tryRecover(TEST_HASH, v, r, s);
        assertEq(recovered, EXPECTED_SIGNER, "Recovered address does not match expected signer");
    }

    function testTryRecoverWithInvalidSignature() public {
        // Intentionally corrupt the signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(0xa11ce, TEST_HASH);
        bytes32 corruptedR = bytes32(uint256(r) + 1);

        address recovered = ECDSA.tryRecover(TEST_HASH, v, corruptedR, s);
        assertEq(recovered, address(0), "Recovered address should be zero for invalid signatures");
    }

    function testToEthSignedMessageHash() public {
        bytes32 hash = keccak256("Hello, Ethereum!");
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash);

        // Compare with expected hash
        bytes32 expectedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
        assertEq(ethSignedMessageHash, expectedHash, "ETH signed message hash does not match");
    }

//    function testToEthSignedMessageHashWithDynamicData() public {
//        bytes memory data = "Hello, dynamic Ethereum!";
//        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(data);
//
//        // Compare with expected hash
//        string memory length = Strings.toString(data.length);
//        bytes32 expectedHash = keccak256(
//            abi.encodePacked("\x19Ethereum Signed Message:\n", length, data)
//        );
//        assertEq(ethSignedMessageHash, expectedHash, "ETH signed message hash does not match for dynamic data");
//    }
}