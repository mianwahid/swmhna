// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    bytes32 constant TEST_MESSAGE =
        0x7dbaf558b0a1a5dc7a67202117ab143c1d8605a983e4a743bc06fcc03162dc0d;
    bytes32 constant WRONG_MESSAGE =
        0x2d0828dd7c97cff316356da3c16c68ba2316886a0e05ebafb8291939310d51a3;

    address constant SIGNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address constant OTHER = address(uint160(1));

    bytes32 constant TEST_SIGNED_MESSAGE_HASH =
        0x7d768af957ef8cbf6219a37e743d5546d911dae3e46449d8a5810522db2ef65e;
    bytes32 constant WRONG_SIGNED_MESSAGE_HASH =
        0x8cd3e659093d21364c6330514aff328218aa29c2693c5b0e96602df075561952;

    bytes constant SIGNATURE =
        hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
    bytes constant INVALID_SIGNATURE =
        hex"7688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";

//    function testRecoverFromHashAndSignature() public {
//        address recovered = ECDSA.recover(TEST_MESSAGE, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }

//    function testRecoverFromHashAndSignatureCalldata() public {
//        address recovered = ECDSA.recoverCalldata(TEST_MESSAGE, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }

//    function testRecoverFromHashAndPassword() public {
//        uint256 privateKey = 0x7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f;
//        address expectedSigner = vm.addr(privateKey);
//        bytes32 messageHash = keccak256(
//            abi.encodePacked("\x19Ethereum Signed Message:\n32", TEST_MESSAGE)
//        );
//        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
//        address recovered = ECDSA.recover(TEST_MESSAGE, v, r, s);
//        assertEq(recovered, expectedSigner);
//    }

    function testRecoverFromHashAndInvalidSignature() public {
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_MESSAGE, INVALID_SIGNATURE);
    }

    function testRecoverFromHashAndSignatureWithInvalidV() public {
        bytes32 messageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", TEST_MESSAGE)
        );
        uint256 privateKey = 0x7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f;
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
        // make v invalid
        v = 0;
        bytes memory invalidSignature = abi.encodePacked(r, s, v);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_MESSAGE, invalidSignature);
    }

    function testToEthSignedMessageHash() public {
        bytes32 messageHash = ECDSA.toEthSignedMessageHash(TEST_MESSAGE);
        assertEq(messageHash, TEST_SIGNED_MESSAGE_HASH);
    }

//    function testToEthSignedMessageHashFromBytes() public {
//        bytes memory message = "Hello World";
//        bytes32 expectedHash =
//            0xa1de988600a42c4b4ab089b619297c17d93d3d87970c232a6d6c5924707496cf;
//        bytes32 messageHash = ECDSA.toEthSignedMessageHash(message);
//        assertEq(messageHash, expectedHash);
//    }

//    function testTryRecover() public {
//        address recovered = ECDSA.tryRecover(TEST_MESSAGE, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }

    function testTryRecoverFromHashAndInvalidSignature() public {
        address recovered = ECDSA.tryRecover(TEST_MESSAGE, INVALID_SIGNATURE);
        assertEq(recovered, address(0));
    }

//    function testTryRecoverCalldata() public {
//        address recovered = ECDSA.tryRecoverCalldata(TEST_MESSAGE, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }

//    function testTryRecoverFromHashAndInvalidSignatureCalldata() public {
//        address recovered = ECDSA.tryRecoverCalldata(TEST_MESSAGE, INVALID_SIGNATURE);
//        assertEq(recovered, address(0));
//    }

    function testEmptySignature() public {
        bytes calldata signature = ECDSA.emptySignature();
        assertEq(signature.length, 0);
    }
}