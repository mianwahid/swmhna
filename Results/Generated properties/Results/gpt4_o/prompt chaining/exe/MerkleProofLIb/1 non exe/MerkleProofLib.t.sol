// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    using MerkleProofLib for bytes32[];

    // Helper function to generate a simple Merkle tree
    function generateMerkleTree(bytes32[] memory leaves) internal pure returns (bytes32 root, bytes32[] memory proof) {
        require(leaves.length > 0, "Leaves array must not be empty");
        uint256 n = leaves.length;
        while (n > 1) {
            for (uint256 i = 0; i < n / 2; i++) {
                leaves[i] = keccak256(abi.encodePacked(leaves[2 * i], leaves[2 * i + 1]));
            }
            if (n % 2 == 1) {
                leaves[n / 2] = leaves[n - 1];
                n = n / 2 + 1;
            } else {
                n = n / 2;
            }
        }
        root = leaves[0];
        proof = new bytes32[](0); // Simplified for single leaf case
    }

    // Invariants for `verify` Function
    function testVerifyValidProof() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        assertTrue(MerkleProofLib.verify(proof, root, leaves[0]));
    }

    function testVerifyInvalidProof() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        proof[0] = keccak256(abi.encodePacked("invalid"));
        assertFalse(MerkleProofLib.verify(proof, root, leaves[0]));
    }

    function testVerifyEmptyProof() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32 root = keccak256(abi.encodePacked("root"));
        bytes32 leaf = keccak256(abi.encodePacked("leaf"));
        assertFalse(MerkleProofLib.verify(proof, root, leaf));
    }

    function testVerifyLeafNotInTree() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        bytes32 invalidLeaf = keccak256(abi.encodePacked("invalidLeaf"));
        assertFalse(MerkleProofLib.verify(proof, root, invalidLeaf));
    }
//
//    // Invariants for `verifyCalldata` Function
//    function testVerifyCalldataValidProof() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        assertTrue(MerkleProofLib.verifyCalldata(proof, root, leaves[0]));
//    }
//
//    function testVerifyCalldataInvalidProof() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        proof[0] = keccak256(abi.encodePacked("invalid"));
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, leaves[0]));
//    }
//
//    function testVerifyCalldataEmptyProof() public {
//        bytes32[] memory proof = new bytes32[](0);
//        bytes32 root = keccak256(abi.encodePacked("root"));
//        bytes32 leaf = keccak256(abi.encodePacked("leaf"));
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, leaf));
//    }
//
//    function testVerifyCalldataLeafNotInTree() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        bytes32 invalidLeaf = keccak256(abi.encodePacked("invalidLeaf"));
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, invalidLeaf));
//    }

    // Invariants for `verifyMultiProof` Function
    function testVerifyMultiProofValid() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        bool[] memory flags = new bool[](0);
        assertTrue(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofInvalid() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        proof[0] = keccak256(abi.encodePacked("invalid"));
        bool[] memory flags = new bool[](0);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofEmptyProofAndLeaves() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32[] memory leaves = new bytes32[](0);
        bytes32 root = keccak256(abi.encodePacked("root"));
        bool[] memory flags = new bool[](1);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofIncorrectFlagsLength() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        bool[] memory flags = new bool[](2);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofLeavesNotInTree() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256(abi.encodePacked("leaf"));
        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
        bytes32[] memory invalidLeaves = new bytes32[](1);
        invalidLeaves[0] = keccak256(abi.encodePacked("invalidLeaf"));
        bool[] memory flags = new bool[](0);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, invalidLeaves, flags));
    }

//    // Invariants for `verifyMultiProofCalldata` Function
//    function testVerifyMultiProofCalldataValid() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        bool[] memory flags = new bool[](0);
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataInvalid() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        proof[0] = keccak256(abi.encodePacked("invalid"));
//        bool[] memory flags = new bool[](0);
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataEmptyProofAndLeaves() public {
//        bytes32[] memory proof = new bytes32[](0);
//        bytes32[] memory leaves = new bytes32[](0);
//        bytes32 root = keccak256(abi.encodePacked("root"));
//        bool[] memory flags = new bool[](1);
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataIncorrectFlagsLength() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        bool[] memory flags = new bool[](2);
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataLeavesNotInTree() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256(abi.encodePacked("leaf"));
//        (bytes32 root, bytes32[] memory proof) = generateMerkleTree(leaves);
//        bytes32[] memory invalidLeaves = new bytes32[](1);
//        invalidLeaves[0] = keccak256(abi.encodePacked("invalidLeaf"));
//        bool[] memory flags = new bool[](0);
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, invalidLeaves, flags));
//    }

    // Invariants for `emptyProof` Function
    function testEmptyProof() public {
        bytes32[] memory proof = MerkleProofLib.emptyProof();
        assertEq(proof.length, 0);
    }

    // Invariants for `emptyLeaves` Function
    function testEmptyLeaves() public {
        bytes32[] memory leaves = MerkleProofLib.emptyLeaves();
        assertEq(leaves.length, 0);
    }

    // Invariants for `emptyFlags` Function
    function testEmptyFlags() public {
        bool[] memory flags = MerkleProofLib.emptyFlags();
        assertEq(flags.length, 0);
    }
}