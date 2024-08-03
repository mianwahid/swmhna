// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {MerkleProofLib} from "../src/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    bytes32[] private proof;
    bytes32 private root;
    bytes32 private leaf;

    function setUp() public {
        // Example setup - this should be adjusted based on actual use case
        leaf = keccak256(abi.encodePacked("leaf"));
        bytes32 leaf2 = keccak256(abi.encodePacked("leaf2"));
        proof.push(keccak256(abi.encodePacked(leaf2)));
        root = keccak256(
            abi.encodePacked(
                keccak256(abi.encodePacked(leaf)),
                keccak256(abi.encodePacked(leaf2))
            )
        );
    }

    // function testVerifyValidProof() public {
    //     bool result = MerkleProofLib.verify(proof, root, leaf);
    //     assertTrue(result);
    // }

    function testVerifyInvalidProof() public {
        bytes32 wrongLeaf = keccak256(abi.encodePacked("wrongLeaf"));
        bool result = MerkleProofLib.verify(proof, root, wrongLeaf);
        assertFalse(result);
    }

    function testVerifyEmptyProof() public {
        bytes32[] memory emptyProof = new bytes32[](0);
        bool result = MerkleProofLib.verify(emptyProof, root, leaf);
        assertFalse(result);
    }

    // function testVerifyMultiProofValid() public {
    //     bytes32[] memory leaves = new bytes32[](2);
    //     leaves[0] = leaf;
    //     leaves[1] = proof[0];
    //     bool[] memory flags = new bool[](2);
    //     flags[0] = false;
    //     flags[1] = true;
    //     bool result = MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
    //     assertTrue(result);
    // }

    function testVerifyMultiProofInvalidFlags() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = leaf;
        leaves[1] = proof[0];
        bool[] memory flags = new bool[](1); // Incorrect number of flags
        flags[0] = true;
        bool result = MerkleProofLib.verifyMultiProof(
            proof,
            root,
            leaves,
            flags
        );
        assertFalse(result);
    }

    function testVerifyMultiProofInvalidLeaves() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = leaf;
        bool[] memory flags = new bool[](1);
        flags[0] = false;
        bool result = MerkleProofLib.verifyMultiProof(
            proof,
            root,
            leaves,
            flags
        );
        assertFalse(result);
    }

    function testVerifyMultiProofEmpty() public {
        bytes32[] memory emptyLeaves = new bytes32[](0);
        bool[] memory emptyFlags = new bool[](0);
        bool result = MerkleProofLib.verifyMultiProof(
            proof,
            root,
            emptyLeaves,
            emptyFlags
        );
        assertFalse(result);
    }

    function testEmptyProofHelper() public {
        bytes32[] calldata emptyProof = MerkleProofLib.emptyProof();
        assertEq(emptyProof.length, 0);
    }

    function testEmptyLeavesHelper() public {
        bytes32[] calldata emptyLeaves = MerkleProofLib.emptyLeaves();
        assertEq(emptyLeaves.length, 0);
    }

    function testEmptyFlagsHelper() public {
        bool[] calldata emptyFlags = MerkleProofLib.emptyFlags();
        assertEq(emptyFlags.length, 0);
    }
}
