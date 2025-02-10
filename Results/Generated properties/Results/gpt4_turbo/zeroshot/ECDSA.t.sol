// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {ECDSA} from "../src/ECDSA.sol";

contract ECDSATest is Test {
    bytes32 constant TEST_HASH = keccak256("Hello, world!");
    address constant EXPECTED_SIGNER = address(0x123);

    // function testRecoverWithValidSignature() public {
    //     // Generate a valid signature
    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint160(EXPECTED_SIGNER), TEST_HASH);
    //     address recovered = ECDSA.recover(TEST_HASH, v, r, s);
    //     assertEq(recovered, EXPECTED_SIGNER);
    // }

    function testRecoverWithInvalidSignature() public {
        // Generate a valid signature and modify it
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            uint160(EXPECTED_SIGNER),
            TEST_HASH
        );
        bytes32 invalidR = bytes32(uint256(r) + 1); // Invalidate the r value
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_HASH, v, invalidR, s);
    }

    // function testRecoverWithZeroAddress() public {
    //     // Zero address should not be able to sign
    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint160(address(0)), TEST_HASH);
    //     vm.expectRevert(ECDSA.InvalidSignature.selector);
    //     ECDSA.recover(TEST_HASH, v, r, s);
    // }

    // function testTryRecoverWithValidSignature() public {
    //     // Generate a valid signature
    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint160(EXPECTED_SIGNER), TEST_HASH);
    //     address recovered = ECDSA.tryRecover(TEST_HASH, v, r, s);
    //     assertEq(recovered, EXPECTED_SIGNER);
    // }

    // function testTryRecoverWithInvalidSignature() public {
    //     // Generate a valid signature and modify it
    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint160(EXPECTED_SIGNER), TEST_HASH);
    //     bytes32 invalidR = bytes32(uint256(r) + 1); // Invalidate the r value
    //     address recovered = ECDSA.tryRecover(TEST_HASH, v, invalidR, s);
    //     assertEq(recovered, address(0)); // Should return zero address
    // }

    function testToEthSignedMessageHash() public {
        bytes32 hash = keccak256("Test message");
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash);
        assertEq(
            ethSignedMessageHash,
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            )
        );
    }

    // function testToEthSignedMessageHashWithLongMessage() public {
    //     bytes memory longMessage = new bytes(1000); // Create a long message of 1000 bytes
    //     for (uint i = 0; i < 1000; i++) {
    //         longMessage[i] = byte(uint8(i % 256));
    //     }
    //     bytes32 hash = keccak256(longMessage);
    //     bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(longMessage);
    //     assertEq(ethSignedMessageHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n1000", longMessage)));
    // }

    // function testEmptySignature() public {
    //     bytes calldata signature = ECDSA.emptySignature();
    //     assertEq(signature.length, 0);
    // }
}
