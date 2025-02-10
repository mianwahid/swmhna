// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    bytes32 internal constant TEST_MESSAGE_HASH =
        keccak256(abi.encodePacked("This is a test message."));
    bytes32 internal constant FAKE_MESSAGE_HASH =
        keccak256(abi.encodePacked("This is a fake message."));

    address internal constant ALICE = address(0x1111000000000000000000000000000000001111);
    address internal constant BOB = address(0x2222000000000000000000000000000000002222);

    bytes internal validSignature;
    bytes internal shortSignature;
    bytes internal invalidSignature;

    function setUp() public {
        vm.prank(ALICE);
        validSignature = abi.encodePacked(
            hex"a829a22a70882ce78930951836c88e8d727a70e789c71c500b5d88a7e102505d",
            hex"209659080a1eb72335a1e501d830e3a709f2602a3ee6c1cd7211898c382f0d8f",
            uint8(27)
        );
        shortSignature = abi.encodePacked(
            hex"a829a22a70882ce78930951836c88e8d727a70e789c71c500b5d88a7e102505d",
            hex"209659080a1eb72335a1e501d830e3a709f2602a3ee6c1cd7211898c382f0d8fa1"
        );
        invalidSignature = abi.encodePacked(
            hex"0000000000000000000000000000000000000000000000000000000000000000",
            hex"0000000000000000000000000000000000000000000000000000000000000000",
            uint8(27)
        );
    }

//    function testRecoverFromValidSignature() public {
//        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, validSignature);
//        assertEq(recovered, ALICE);
//    }

//    function testRecoverFromShortSignature() public {
//        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, shortSignature);
//        assertEq(recovered, ALICE);
//    }

//    function testRecoverFromCalldata() public {
//        address recovered = ECDSA.recoverCalldata(TEST_MESSAGE_HASH, validSignature);
//        assertEq(recovered, ALICE);
//    }

//    function testRecoverFromRVS() public {
//        (bytes32 r, bytes32 vs) = abi.decode(shortSignature, (bytes32, bytes32));
//        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, r, vs);
//        assertEq(recovered, ALICE);
//    }

//    function testRecoverFromVRS() public {
//        (bytes32 r, bytes32 s, uint8 v) = abi.decode(
//            validSignature,
//            (bytes32, bytes32, uint8)
//        );
//        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, v, r, s);
//        assertEq(recovered, ALICE);
//    }

    function testRecoverFromInvalidSignature() public {
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_MESSAGE_HASH, invalidSignature);
    }

//    function testTryRecoverFromValidSignature() public {
//        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, validSignature);
//        assertEq(recovered, ALICE);
//    }

    function testTryRecoverFromInvalidSignature() public {
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, invalidSignature);
        assertEq(recovered, address(0));
    }

//    function testToEthSignedMessageHash() public {
//        bytes32 messageHash = ECDSA.toEthSignedMessageHash("Test Message");
//        bytes32 expectedHash = keccak256(
//            abi.encodePacked("\x19Ethereum Signed Message:\n", "12", "Test Message")
//        );
//        assertEq(messageHash, expectedHash);
//    }

    function testToEthSignedMessageHashFromHash() public {
        bytes32 messageHash = ECDSA.toEthSignedMessageHash(TEST_MESSAGE_HASH);
        bytes32 expectedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", TEST_MESSAGE_HASH)
        );
        assertEq(messageHash, expectedHash);
    }

    function testEmptySignature() public {
        bytes calldata signature = ECDSA.emptySignature();
        assertEq(signature.length, 0);
    }
}