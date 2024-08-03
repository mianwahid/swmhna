//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/MerkleProofLib.sol";
//
//contract MerkleProofLibTest is Test {
//    using MerkleProofLib for bytes32[];
//
//    bytes32 constant ROOT = 0x2c26b46b68ffc68ff99b453c1d30413413422f4b5f82a0d8a0e6f5c6c3e6e0f0;
//    bytes32 constant LEAF = 0x0d1d4e89f6d2a1c1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1;
//    bytes32[] proof;
//
//    function setUp() public {
//        proof = new bytes32[](2);
//        proof[0] = 0x1c1d4e89f6d2a1c1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1;
//        proof[1] = 0x2c1d4e89f6d2a1c1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1b1e1;
//    }
//
//    function testVerify() public {
//        bool isValid = MerkleProofLib.verify(proof, ROOT, LEAF);
//        assertTrue(isValid, "Merkle proof verification failed");
//    }
//
//    function testVerifyCalldata() public {
//        bool isValid = MerkleProofLib.verifyCalldata(proof, ROOT, LEAF);
//        assertTrue(isValid, "Merkle proof calldata verification failed");
//    }
//
//    function testVerifyMultiProof() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = LEAF;
//        bool[] memory flags = new bool[](1);
//        flags[0] = true;
//        bool isValid = MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags);
//        assertTrue(isValid, "Merkle multi-proof verification failed");
//    }
//
//    function testVerifyMultiProofCalldata() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = LEAF;
//        bool[] memory flags = new bool[](1);
//        flags[0] = true;
//        bool isValid = MerkleProofLib.verifyMultiProofCalldata(proof, ROOT, leaves, flags);
//        assertTrue(isValid, "Merkle multi-proof calldata verification failed");
//    }
//
//    function testEmptyProof() public {
//        bytes32[] calldata emptyProof = MerkleProofLib.emptyProof();
//        assertEq(emptyProof.length, 0, "Empty proof length mismatch");
//    }
//
//    function testEmptyLeaves() public {
//        bytes32[] calldata emptyLeaves = MerkleProofLib.emptyLeaves();
//        assertEq(emptyLeaves.length, 0, "Empty leaves length mismatch");
//    }
//
//    function testEmptyFlags() public {
//        bool[] calldata emptyFlags = MerkleProofLib.emptyFlags();
//        assertEq(emptyFlags.length, 0, "Empty flags length mismatch");
//    }
//}