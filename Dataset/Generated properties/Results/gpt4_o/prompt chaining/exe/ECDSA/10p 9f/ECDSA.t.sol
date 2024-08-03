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
        vs = bytes32(uint256(s) | (uint256(v - 27) << 255));
        signature = abi.encodePacked(r, s, v);
    }

    // Custom Errors
    function testInvalidSignatureError() public {
        bytes memory invalidSignature = new bytes(63);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

    // Recovery Operations
    function testRecoverValidSignature() public {
        address recovered = hash.recover(signature);
        assertEq(recovered, signer);
    }

    function testRecoverInvalidSignatureLength() public {
        bytes memory invalidSignature = new bytes(63);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

    function testRecoverInvalidSignatureValues() public {
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

//    function testRecoverCalldataInvalidSignatureValues() public {
//        bytes memory invalidSignature = abi.encodePacked(r, bytes32(uint256(s) + 1), v);
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        hash.recoverCalldata(invalidSignature);
//    }

    function testRecoverRvsValidSignature() public {
        address recovered = hash.recover(r, vs);
        assertEq(recovered, signer);
    }

    function testRecoverRvsInvalidSignatureValues() public {
        bytes32 invalidVs = bytes32(uint256(vs) + 1);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(r, invalidVs);
    }

    function testRecoverVrsValidSignature() public {
        address recovered = hash.recover(v, r, s);
        assertEq(recovered, signer);
    }

    function testRecoverVrsInvalidSignatureValues() public {
        bytes32 invalidS = bytes32(uint256(s) + 1);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(v, r, invalidS);
    }

    // Try-Recover Operations
    function testTryRecoverValidSignature() public {
        address recovered = hash.tryRecover(signature);
        assertEq(recovered, signer);
    }

    function testTryRecoverInvalidSignatureLength() public {
        bytes memory invalidSignature = new bytes(63);
        address recovered = hash.tryRecover(invalidSignature);
        assertEq(recovered, address(0));
    }

    function testTryRecoverInvalidSignatureValues() public {
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

    function testTryRecoverRvsValidSignature() public {
        address recovered = hash.tryRecover(r, vs);
        assertEq(recovered, signer);
    }

    function testTryRecoverRvsInvalidSignatureValues() public {
        bytes32 invalidVs = bytes32(uint256(vs) + 1);
        address recovered = hash.tryRecover(r, invalidVs);
        assertEq(recovered, address(0));
    }

    function testTryRecoverVrsValidSignature() public {
        address recovered = hash.tryRecover(v, r, s);
        assertEq(recovered, signer);
    }

    function testTryRecoverVrsInvalidSignatureValues() public {
        bytes32 invalidS = bytes32(uint256(s) + 1);
        address recovered = hash.tryRecover(v, r, invalidS);
        assertEq(recovered, address(0));
    }

    // Hashing Operations
    function testToEthSignedMessageHashBytes32() public {
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash);
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        assertEq(ethSignedMessageHash, expectedHash);
    }

    function testToEthSignedMessageHashBytes() public {
        bytes memory message = "test message";
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(message);
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n12", message));
        assertEq(ethSignedMessageHash, expectedHash);
    }

    function testToEthSignedMessageHashMaxLength() public {
        bytes memory message = new bytes(999999);
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(message);
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n999999", message));
        assertEq(ethSignedMessageHash, expectedHash);
    }

    // Empty Calldata Helpers
    function testEmptySignature() public {
        bytes calldata emptySig = ECDSA.emptySignature();
        assertEq(emptySig.length, 0);
    }
}