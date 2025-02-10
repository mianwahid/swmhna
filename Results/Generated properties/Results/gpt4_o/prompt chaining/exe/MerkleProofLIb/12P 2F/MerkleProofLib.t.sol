// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    using MerkleProofLib for bytes32[];

    // Helper function to generate a simple Merkle tree proof
    function generateProof(bytes32[] memory leaves, uint256 index) internal pure returns (bytes32[] memory proof) {
        uint256 n = leaves.length;
        require(index < n, "Index out of bounds");
        proof = new bytes32[](n - 1);
        for (uint256 i = 0; i < n - 1; i++) {
            proof[i] = leaves[(index + i + 1) % n];
        }
    }

    // Helper function to compute the root of a simple Merkle tree
    function computeRoot(bytes32[] memory leaves) internal pure returns (bytes32 root) {
        uint256 n = leaves.length;
        require(n > 0, "No leaves provided");
        root = leaves[0];
        for (uint256 i = 1; i < n; i++) {
            root = keccak256(abi.encodePacked(root, leaves[i]));
        }
    }

    // Test invariants for verify function
    function testVerifyCorrectProof() public {
        bytes32[] memory leaves = new bytes32[](3);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");
        leaves[2] = keccak256("leaf3");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 0);
        assertTrue(MerkleProofLib.verify(proof, root, leaves[0]));
    }

    function testVerifyIncorrectProof() public {
        bytes32[] memory leaves = new bytes32[](3);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");
        leaves[2] = keccak256("leaf3");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 1);
        assertFalse(MerkleProofLib.verify(proof, root, leaves[0]));
    }

    function testVerifyEmptyProof() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32 root = keccak256("root");
        bytes32 leaf = keccak256("leaf");
        assertFalse(MerkleProofLib.verify(proof, root, leaf));
    }

    function testVerifySingleElementProof() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256("leaf1");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = new bytes32[](0);
        assertTrue(MerkleProofLib.verify(proof, root, leaves[0]));
    }

    function testVerifyBoundaryValues() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = bytes32(0);
        leaves[1] = bytes32(type(uint256).max);
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 0);
        assertTrue(MerkleProofLib.verify(proof, root, leaves[0]));
    }

    // Test invariants for verifyCalldata function
//    function testVerifyCalldataCorrectProof() public {
//        bytes32[] memory leaves = new bytes32[](3);
//        leaves[0] = keccak256("leaf1");
//        leaves[1] = keccak256("leaf2");
//        leaves[2] = keccak256("leaf3");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 0);
//        assertTrue(MerkleProofLib.verifyCalldata(proof, root, leaves[0]));
//    }
//
//    function testVerifyCalldataIncorrectProof() public {
//        bytes32[] memory leaves = new bytes32[](3);
//        leaves[0] = keccak256("leaf1");
//        leaves[1] = keccak256("leaf2");
//        leaves[2] = keccak256("leaf3");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 1);
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, leaves[0]));
//    }
//
//    function testVerifyCalldataEmptyProof() public {
//        bytes32[] memory proof = new bytes32[](0);
//        bytes32 root = keccak256("root");
//        bytes32 leaf = keccak256("leaf");
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, leaf));
//    }
//
//    function testVerifyCalldataSingleElementProof() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256("leaf1");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = new bytes32[](0);
//        assertTrue(MerkleProofLib.verifyCalldata(proof, root, leaves[0]));
//    }
//
//    function testVerifyCalldataBoundaryValues() public {
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = bytes32(0);
//        leaves[1] = bytes32(type(uint256).max);
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 0);
//        assertTrue(MerkleProofLib.verifyCalldata(proof, root, leaves[0]));
//    }

    // Test invariants for verifyMultiProof function
    function testVerifyMultiProofCorrectProof() public {
        bytes32[] memory leaves = new bytes32[](3);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");
        leaves[2] = keccak256("leaf3");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 0);
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;
        assertTrue(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofIncorrectProof() public {
        bytes32[] memory leaves = new bytes32[](3);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");
        leaves[2] = keccak256("leaf3");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 1);
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofEmptyProofAndLeaves() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32[] memory leaves = new bytes32[](0);
        bytes32 root = keccak256("root");
        bool[] memory flags = new bool[](0);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofSingleLeafAndProof() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = keccak256("leaf1");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = new bytes32[](0);
        bool[] memory flags = new bool[](0);
        assertTrue(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofFlagsLengthMismatch() public {
        bytes32[] memory leaves = new bytes32[](3);
        leaves[0] = keccak256("leaf1");
        leaves[1] = keccak256("leaf2");
        leaves[2] = keccak256("leaf3");
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 0);
        bool[] memory flags = new bool[](1); // Incorrect length
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    function testVerifyMultiProofBoundaryValues() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = bytes32(0);
        leaves[1] = bytes32(type(uint256).max);
        bytes32 root = computeRoot(leaves);
        bytes32[] memory proof = generateProof(leaves, 0);
        bool[] memory flags = new bool[](1);
        flags[0] = true;
        assertTrue(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags));
    }

    // Test invariants for verifyMultiProofCalldata function
//    function testVerifyMultiProofCalldataCorrectProof() public {
//        bytes32[] memory leaves = new bytes32[](3);
//        leaves[0] = keccak256("leaf1");
//        leaves[1] = keccak256("leaf2");
//        leaves[2] = keccak256("leaf3");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 0);
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = false;
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataIncorrectProof() public {
//        bytes32[] memory leaves = new bytes32[](3);
//        leaves[0] = keccak256("leaf1");
//        leaves[1] = keccak256("leaf2");
//        leaves[2] = keccak256("leaf3");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 1);
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = false;
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataEmptyProofAndLeaves() public {
//        bytes32[] memory proof = new bytes32[](0);
//        bytes32[] memory leaves = new bytes32[](0);
//        bytes32 root = keccak256("root");
//        bool[] memory flags = new bool[](0);
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataSingleLeafAndProof() public {
//        bytes32[] memory leaves = new bytes32[](1);
//        leaves[0] = keccak256("leaf1");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = new bytes32[](0);
//        bool[] memory flags = new bool[](0);
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataFlagsLengthMismatch() public {
//        bytes32[] memory leaves = new bytes32[](3);
//        leaves[0] = keccak256("leaf1");
//        leaves[1] = keccak256("leaf2");
//        leaves[2] = keccak256("leaf3");
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 0);
//        bool[] memory flags = new bool[](1); // Incorrect length
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataBoundaryValues() public {
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = bytes32(0);
//        leaves[1] = bytes32(type(uint256).max);
//        bytes32 root = computeRoot(leaves);
//        bytes32[] memory proof = generateProof(leaves, 0);
//        bool[] memory flags = new bool[](1);
//        flags[0] = true;
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags));
//    }

    // Test invariants for emptyProof function
    function testEmptyProof() public {
        bytes32[] memory proof = MerkleProofLib.emptyProof();
        assertEq(proof.length, 0);
    }

    // Test invariants for emptyLeaves function
    function testEmptyLeaves() public {
        bytes32[] memory leaves = MerkleProofLib.emptyLeaves();
        assertEq(leaves.length, 0);
    }

    // Test invariants for emptyFlags function
    function testEmptyFlags() public {
        bool[] memory flags = MerkleProofLib.emptyFlags();
        assertEq(flags.length, 0);
    }
}