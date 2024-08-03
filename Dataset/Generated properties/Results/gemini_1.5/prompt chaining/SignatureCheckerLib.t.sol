// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    address internal alice = address(0x123);
    address internal bob = address(0x456);

    function testToEthSignedMessageHash(bytes32 hash) public {
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(hash);
        console2.logBytes32(result);
    }

    function testToEthSignedMessageHash(bytes memory message) public {
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(message);
        console2.logBytes32(result);
    }

    function testEmptySignature() public {
        bytes calldata signature = SignatureCheckerLib.emptySignature();
        assertEq(signature.length, 0);
    }

//    function testIsValidSignatureNow(
//        uint8 v,
//        bytes32 r,
//        bytes32 s,
//        bytes32 messageHash
//    ) public {
//        address expectedSigner = ecrecover(messageHash, v, r, s);
//        bytes memory signature = abi.encodePacked(r, s, v);
//
//        // Test `isValidSignatureNow(address, bytes32, bytes memory)`
//        assertEq(
//            SignatureCheckerLib.isValidSignatureNow(
//                expectedSigner,
//                messageHash,
//                signature
//            ),
//            true
//        );
//
//        // Test `isValidSignatureNow(address, bytes32, bytes32, bytes32)`
////        assertEq(
////            SignatureCheckerLib.isValidSignatureNow(
////                expectedSigner,
////                messageHash,
////                r,
////                bytes32(uint256(vs) << 248)
////            ),
////            true
////        );
//
//        // Test `isValidSignatureNow(address, bytes32, uint8, bytes32, bytes32)`
//        assertEq(
//            SignatureCheckerLib.isValidSignatureNow(
//                expectedSigner,
//                messageHash,
//                v,
//                r,
//                s
//            ),
//            true
//        );
//    }

    function testIsValidSignatureNow_InvalidSignature(
        address signer,
        bytes32 messageHash
    ) public {
        uint8 v = 27;
        bytes32 r = keccak256(abi.encodePacked(block.timestamp));
        bytes32 s = keccak256(abi.encodePacked(block.difficulty));
        bytes memory signature = abi.encodePacked(r, s, v);

        assertEq(
            SignatureCheckerLib.isValidSignatureNow(
                signer,
                messageHash,
                signature
            ),
            false
        );
    }

    function testIsValidSignatureNow_ZeroAddress(bytes32 messageHash) public {
        uint8 v = 27;
        bytes32 r = keccak256(abi.encodePacked(block.timestamp));
        bytes32 s = keccak256(abi.encodePacked(block.difficulty));
        bytes memory signature = abi.encodePacked(r, s, v);

        assertEq(
            SignatureCheckerLib.isValidSignatureNow(
                address(0),
                messageHash,
                signature
            ),
            false
        );
    }

    function testIsValidSignatureNow_EmptySignature(
        address signer,
        bytes32 messageHash
    ) public {
        bytes memory signature = "";

        assertEq(
            SignatureCheckerLib.isValidSignatureNow(
                signer,
                messageHash,
                signature
            ),
            false
        );
    }
}
