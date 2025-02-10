// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/ECDSA.sol";

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
        bytes32 invalidR = bytes32(uint256(r) + 1); // Invalidate r
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_HASH, v, invalidR, s);
    }

    // function testRecoverWithZeroAddress() public {
    //     // Zero address should not be able to be a signer
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
    //     bytes32 invalidR = bytes32(uint256(r) + 1); // Invalidate r
    //     address recovered = ECDSA.tryRecover(TEST_HASH, v, invalidR, s);
    //     assertEq(recovered, address(0)); // Should return zero address
    // }

    function testRecoverFromDifferentHashes() public {
        // Generate a valid signature from one hash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            uint160(EXPECTED_SIGNER),
            TEST_HASH
        );
        bytes32 anotherHash = keccak256("Another message");
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(anotherHash, v, r, s);
    }

    function testToEthSignedMessageHash() public {
        bytes32 hash = keccak256("Test message");
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(hash);
        // Check if the hash is correctly prefixed
        assertEq(
            ethSignedHash,
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            )
        );
    }

    function testToEthSignedMessageHashWithBytes() public {
        bytes memory message = "Test message";
        bytes32 hash = keccak256(message);
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(message);
        // Check if the hash is correctly prefixed and length is included
        assertEq(
            ethSignedHash,
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n",
                    uint2str(message.length),
                    message
                )
            )
        );
    }

    function uint2str(
        uint _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
