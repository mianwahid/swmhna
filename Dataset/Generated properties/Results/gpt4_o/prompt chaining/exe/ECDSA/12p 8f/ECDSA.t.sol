// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    using ECDSA for bytes32;

    address private signer;
    bytes32 private hash;
    bytes private signature;
    bytes32 private r;
    bytes32 private s;
    uint8 private v;
    bytes32 private vs;

    function setUp() public {
        signer = address(0x1234567890123456789012345678901234567890);
        hash = keccak256(abi.encodePacked("test message"));
        (v, r, s) = vm.sign(uint256(uint160(signer)), hash);
        signature = abi.encodePacked(r, s, v);
        vs = bytes32(uint256(s) | (uint256(v - 27) << 255));
    }

    // Custom Errors
    function testInvalidSignatureError() public {
        bytes memory invalidSignature = new bytes(63);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

    // Recovery Operations
    function testRecoverBytesValidSignature() public {
        address recovered = hash.recover(signature);
        assertEq(recovered, signer);
    }

    function testRecoverBytesInvalidSignatureLength() public {
        bytes memory invalidSignature = new bytes(63);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

    function testRecoverBytesInvalidSignatureValues() public {
        bytes memory invalidSignature = abi.encodePacked(r, bytes32(uint256(s) + 1), v);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

//    function testRecoverCalldataValidSignature() public {
//        address recovered = hash.recoverCalldata(signature);
//        assertEq(recovered, signer);
//    }
//
//    function testRecoverCalldataInvalidSignatureLength() public {
//        bytes memory invalidSignature = new bytes(63);
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        hash.recoverCalldata(invalidSignature);
//    }
//
//    function testRecoverCalldataInvalidSignatureValues() public {
//        bytes memory invalidSignature = abi.encodePacked(r, bytes32(uint256(s) + 1), v);
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        hash.recoverCalldata(invalidSignature);
//    }

    function testRecoverBytes32ValidSignature() public {
        address recovered = hash.recover(r, vs);
        assertEq(recovered, signer);
    }

    function testRecoverBytes32InvalidSignatureValues() public {
        bytes32 invalidVs = bytes32(uint256(vs) + 1);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(r, invalidVs);
    }

    function testRecoverUint8ValidSignature() public {
        address recovered = hash.recover(v, r, s);
        assertEq(recovered, signer);
    }

    function testRecoverUint8InvalidSignatureValues() public {
        uint8 invalidV = v + 1;
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidV, r, s);
    }

    // Try-Recover Operations
    function testTryRecoverBytesValidSignature() public {
        address recovered = hash.tryRecover(signature);
        assertEq(recovered, signer);
    }

    function testTryRecoverBytesInvalidSignatureLength() public {
        bytes memory invalidSignature = new bytes(63);
        address recovered = hash.tryRecover(invalidSignature);
        assertEq(recovered, address(0));
    }

    function testTryRecoverBytesInvalidSignatureValues() public {
        bytes memory invalidSignature = abi.encodePacked(r, bytes32(uint256(s) + 1), v);
        address recovered = hash.tryRecover(invalidSignature);
        assertEq(recovered, address(0));
    }

//    function testTryRecoverCalldataValidSignature() public {
//        address recovered = hash.tryRecoverCalldata(signature);
//        assertEq(recovered, signer);
//    }
//
//    function testTryRecoverCalldataInvalidSignatureLength() public {
//        bytes memory invalidSignature = new bytes(63);
//        address recovered = hash.tryRecoverCalldata(invalidSignature);
//        assertEq(recovered, address(0));
//    }
//
//    function testTryRecoverCalldataInvalidSignatureValues() public {
//        bytes memory invalidSignature = abi.encodePacked(r, bytes32(uint256(s) + 1), v);
//        address recovered = hash.tryRecoverCalldata(invalidSignature);
//        assertEq(recovered, address(0));
//    }

    function testTryRecoverBytes32ValidSignature() public {
        address recovered = hash.tryRecover(r, vs);
        assertEq(recovered, signer);
    }

    function testTryRecoverBytes32InvalidSignatureValues() public {
        bytes32 invalidVs = bytes32(uint256(vs) + 1);
        address recovered = hash.tryRecover(r, invalidVs);
        assertEq(recovered, address(0));
    }

    function testTryRecoverUint8ValidSignature() public {
        address recovered = hash.tryRecover(v, r, s);
        assertEq(recovered, signer);
    }

    function testTryRecoverUint8InvalidSignatureValues() public {
        uint8 invalidV = v + 1;
        address recovered = hash.tryRecover(invalidV, r, s);
        assertEq(recovered, address(0));
    }

    // Hashing Operations
    function testToEthSignedMessageHashBytes32() public {
        bytes32 expected = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        bytes32 result = ECDSA.toEthSignedMessageHash(hash);
        assertEq(result, expected);
    }

    function testToEthSignedMessageHashBytes32EdgeCases() public {
        bytes32 zeroHash = ECDSA.toEthSignedMessageHash(bytes32(0));
        bytes32 maxHash = ECDSA.toEthSignedMessageHash(bytes32(type(uint256).max));
        assertEq(zeroHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", bytes32(0))));
        assertEq(maxHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", bytes32(type(uint256).max))));
    }

    function testToEthSignedMessageHashBytes() public {
        bytes memory message = "test message";
        bytes32 expected = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n12", message));
        bytes32 result = ECDSA.toEthSignedMessageHash(message);
        assertEq(result, expected);
    }

    function testToEthSignedMessageHashBytesEdgeCases() public {
        bytes memory emptyMessage = "";
        bytes memory maxLengthMessage = new bytes(999999);
        bytes32 emptyHash = ECDSA.toEthSignedMessageHash(emptyMessage);
        bytes32 maxLengthHash = ECDSA.toEthSignedMessageHash(maxLengthMessage);
        assertEq(emptyHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n0", emptyMessage)));
        assertEq(maxLengthHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n999999", maxLengthMessage)));
    }

    // Empty Calldata Helpers
    function testEmptySignature() public {
        bytes calldata emptySig = ECDSA.emptySignature();
        assertEq(emptySig.length, 0);
    }
}