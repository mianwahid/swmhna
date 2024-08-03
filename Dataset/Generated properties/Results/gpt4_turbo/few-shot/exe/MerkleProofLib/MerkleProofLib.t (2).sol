// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {MerkleProofLib} from "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    bytes32[] private proof;
    bytes32 private root;
    bytes32 private leaf;

    function setUp() public {
        // Example setup (values would need to be correct for an actual Merkle Tree)
        proof = new bytes32[](2);
        proof[0] = keccak256("data1");
        proof[1] = keccak256("data2");

        leaf = keccak256("leaf");
        root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(leaf, proof[0])), proof[1]));
    }

    function testVerifyValidProof() public {
        bool result = MerkleProofLib.verify(proof, root, leaf);
        assertTrue(result, "The proof should be valid.");
    }

    function testVerifyInvalidProof() public {
        bytes32 fakeLeaf = keccak256("fakeLeaf");
        bool result = MerkleProofLib.verify(proof, root, fakeLeaf);
        assertFalse(result, "The proof should be invalid.");
    }

    function testVerifyEmptyProof() public {
        bytes32[] memory emptyProof = new bytes32[](0);
        bytes32 emptyLeaf = keccak256("emptyLeaf");
        bytes32 emptyRoot = keccak256(abi.encodePacked(emptyLeaf));

        bool result = MerkleProofLib.verify(emptyProof, emptyRoot, emptyLeaf);
        assertTrue(result, "The proof with a single leaf and no proof elements should be valid.");
    }

    function testVerifyMultiProofValid() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");

        bytes32[] memory multiProof = new bytes32[](2);
        multiProof[0] = keccak256("proof1");
        multiProof[1] = keccak256("proof2");

        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;

        bytes32 multiRoot = keccak256(abi.encodePacked(multiProof[0], leaves[0], multiProof[1], leaves[1]));

        bool result = MerkleProofLib.verifyMultiProof(multiProof, multiRoot, leaves, flags);
        assertTrue(result, "The multi proof should be valid.");
    }

    function testVerifyMultiProofInvalid() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");

        bytes32[] memory multiProof = new bytes32[](2);
        multiProof[0] = keccak256("proof1");
        multiProof[1] = keccak256("proof2");

        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = false; // Incorrect flag to simulate an invalid proof

        bytes32 multiRoot = keccak256(abi.encodePacked(multiProof[0], leaves[0], multiProof[1], leaves[1]));

        bool result = MerkleProofLib.verifyMultiProof(multiProof, multiRoot, leaves, flags);
        assertFalse(result, "The multi proof should be invalid.");
    }

    function testEmptyHelpers() public {
        bytes32[] calldata emptyProof = MerkleProofLib.emptyProof();
        bytes32[] calldata emptyLeaves = MerkleProofLib.emptyLeaves();
        bool[] calldata emptyFlags = MerkleProofLib.emptyFlags();

        assertEq(emptyProof.length, 0, "Empty proof should have length 0.");
        assertEq(emptyLeaves.length, 0, "Empty leaves should have length 0.");
        assertEq(emptyFlags.length, 0, "Empty flags should have length 0.");
    }
}