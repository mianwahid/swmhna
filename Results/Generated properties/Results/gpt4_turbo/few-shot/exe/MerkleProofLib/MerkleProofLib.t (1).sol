// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {MerkleProofLib} from "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    // Example Merkle Tree Root and Leaf
    bytes32 constant root = 0xabc123;
    bytes32 constant leaf = 0xdef456;
    bytes32[] proof;

    function setUp() public {
        // Setup or calculate a valid proof array for testing
        // This is just a placeholder example
//        proof.push(0x123456);
//        proof.push(0x789abc);
    }

    function testVerifyValidProof() public {
        // Test a valid proof
        bool result = MerkleProofLib.verify(proof, root, leaf);
        assertTrue(result, "The proof should be valid");
    }

    function testVerifyInvalidProof() public {
        // Test an invalid proof
        bytes32 wrongLeaf = 0x000000;
        bool result = MerkleProofLib.verify(proof, root, wrongLeaf);
        assertFalse(result, "The proof should be invalid");
    }

    function testVerifyEmptyProof() public {
        // Test with an empty proof
        bytes32[] memory emptyProof = new bytes32[](0);
        bool result = MerkleProofLib.verify(emptyProof, root, leaf);
        assertFalse(result, "The proof should be invalid with empty proof array");
    }

    function testVerifyCalldataValidProof() public {
        // Test a valid proof using calldata function
        bool result = MerkleProofLib.verifyCalldata(proof, root, leaf);
        assertTrue(result, "The proof should be valid");
    }

    function testVerifyCalldataInvalidProof() public {
        // Test an invalid proof using calldata function
        bytes32 wrongLeaf = 0x000000;
        bool result = MerkleProofLib.verifyCalldata(proof, root, wrongLeaf);
        assertFalse(result, "The proof should be invalid");
    }

    function testVerifyMultiProofValid() public {
        // Test a valid multi proof
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = leaf;
        leaves[1] = 0x999999;
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;

        bool result = MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
        assertTrue(result, "The multi proof should be valid");
    }

//    function testVerifyMultiProofInvalid() public {
//        // Test an invalid multi proof
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = leaf;
//        leaves[1] = 0x888888;
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = true;
//
//        bool result = MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
//        assertFalse(result, "The multi proof should be invalid");
//    }

//    function testVerifyMultiProofCalldataValid() public {
//        // Test a valid multi proof using calldata function
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = leaf;
//        leaves[1] = 0x999999;
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = false;
//
//        bool result = MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags);
//        assertTrue(result, "The multi proof should be valid");
//    }
//
//    function testVerifyMultiProofCalldataInvalid() public {
//        // Test an invalid multi proof using calldata function
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = leaf;
//        leaves[1] = 0x888888;
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = true;
//
//        bool result = MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags);
//        assertFalse(result, "The multi proof should be invalid");
//    }
}