// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {MerkleProofLib} from "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    // Example Merkle Tree
    //          ROOT
    //         /    \
    //       A       B
    //      / \     / \
    //    L1  L2  L3  L4
    bytes32 constant L1 = keccak256("Leaf 1");
    bytes32 constant L2 = keccak256("Leaf 2");
    bytes32 constant L3 = keccak256("Leaf 3");
    bytes32 constant L4 = keccak256("Leaf 4");
    bytes32 constant A = keccak256(abi.encodePacked(L1, L2));
    bytes32 constant B = keccak256(abi.encodePacked(L3, L4));
    bytes32 constant ROOT = keccak256(abi.encodePacked(A, B));

    function testVerifySingleProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = L2;

        bool result = MerkleProofLib.verify(proof, ROOT, L1);
        assertTrue(result);
    }

    function testVerifySingleProofFail() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = L1;

        bool result = MerkleProofLib.verify(proof, ROOT, L2);
        assertFalse(result);
    }

    function testVerifyMultiProof() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = L2;
        proof[1] = B;

        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = L1;

        bool[] memory flags = new bool[](2);
        flags[0] = false;
        flags[1] = true;

        bool result = MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags);
        assertTrue(result);
    }

    function testVerifyMultiProofFail() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = L1;
        proof[1] = B;

        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = L2;

        bool[] memory flags = new bool[](2);
        flags[0] = false;
        flags[1] = true;

        bool result = MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags);
        assertFalse(result);
    }

    function testEmptyProof() public {
        bytes32[] memory proof = MerkleProofLib.emptyProof();
        assertTrue(proof.length == 0);
    }

    function testEmptyLeaves() public {
        bytes32[] memory leaves = MerkleProofLib.emptyLeaves();
        assertTrue(leaves.length == 0);
    }

    function testEmptyFlags() public {
        bool[] memory flags = MerkleProofLib.emptyFlags();
        assertTrue(flags.length == 0);
    }
//
//    function testVerifyCalldata() public {
//        bytes32[] memory proof = new bytes32[](1);
//        proof[0] = L2;
//
//        bool result = MerkleProofLib.verifyCalldata(proof, ROOT, L1);
//        assertTrue(result);
//    }

//    function testVerifyMultiProofCalldata() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = L2;
//        proof[1] = B;
//
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = L1;
//
//        bool[] memory flags = new bool[](2);
//        flags[0] = false;
//        flags[1] = true;
//
//        bool result = MerkleProofLib.verifyMultiProofCalldata(proof, ROOT, leaves, flags);
//        assertTrue(result);
//    }
}