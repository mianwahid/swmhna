// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    bytes32[] emptyArray;
    bytes32 testRoot = keccak256("testRoot");
    bytes32 testLeaf = keccak256("testLeaf");
    bytes32 otherLeaf = keccak256("otherLeaf");

    // function testVerifyCorrectness() public {
    //     bytes32[] memory proof = new bytes32[](1);
    //     proof[0] = testLeaf;

    //     // Should return true for correct root, leaf, and proof
    //     assertTrue(MerkleProofLib.verify(proof, testRoot, testLeaf));

    //     // Should return false for incorrect root
    //     assertFalse(MerkleProofLib.verify(proof, otherLeaf, testLeaf));
    // }

    function testVerifyEmptyProof() public {
        // Should return true if proof is empty and leaf equals root
        assertTrue(MerkleProofLib.verify(emptyArray, testLeaf, testLeaf));

        // Should return false if proof is empty and leaf does not equal root
        assertFalse(MerkleProofLib.verify(emptyArray, testRoot, testLeaf));
    }

    // function testVerifySingleElementProof() public {
    //     bytes32[] memory proof = new bytes32[](1);
    //     proof[0] = testLeaf;

    //     // Correct order
    //     assertTrue(MerkleProofLib.verify(proof, testRoot, testLeaf));

    //     // Incorrect order
    //     assertFalse(MerkleProofLib.verify(proof, testLeaf, testRoot));
    // }

    // function testVerifyReversibility() public {
    //     bytes32[] memory proof = new bytes32[](2);
    //     proof[0] = testLeaf;
    //     proof[1] = otherLeaf;

    //     // Correct order
    //     assertTrue(MerkleProofLib.verify(proof, testRoot, testLeaf));

    //     // Reversed order
    //     assertFalse(MerkleProofLib.verify(proof, testRoot, testLeaf));
    // }

    // function testVerifyMultiProofCorrectness() public {
    //     bytes32[] memory leaves = new bytes32[](2);
    //     leaves[0] = testLeaf;
    //     leaves[1] = otherLeaf;
    //     bytes32[] memory proof = new bytes32[](1);
    //     proof[0] = testLeaf;
    //     bool[] memory flags = new bool[](2);
    //     flags[0] = true;
    //     flags[1] = false;

    //     // Should return true for correct inputs
    //     assertTrue(
    //         MerkleProofLib.verifyMultiProof(proof, testRoot, leaves, flags)
    //     );

    //     // Should return false for incorrect inputs
    //     assertFalse(
    //         MerkleProofLib.verifyMultiProof(proof, otherLeaf, leaves, flags)
    //     );
    // }

    function testVerifyMultiProofFlagsAndProofLengthRelationship() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = testLeaf;
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = otherLeaf;
        bool[] memory flags = new bool[](1);
        flags[0] = true;

        // Incorrect relationship
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, testRoot, leaves, flags)
        );
    }

    function testVerifyMultiProofSingleLeafEdgeCase() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = testRoot;
        bytes32[] memory proof = new bytes32[](0);
        bool[] memory flags = new bool[](0);

        // Single leaf equals root
        assertTrue(
            MerkleProofLib.verifyMultiProof(proof, testRoot, leaves, flags)
        );

        // Single leaf does not equal root
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, otherLeaf, leaves, flags)
        );
    }

    function testVerifyMultiProofProofExhaustion() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = testLeaf;
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = otherLeaf;
        bool[] memory flags = new bool[](1);
        flags[0] = true;

        // Proof not exhausted
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, testRoot, leaves, flags)
        );
    }

    function testEmptyProof() public {
        bytes32[] calldata proof = MerkleProofLib.emptyProof();
        assertEq(proof.length, 0);
    }

    function testEmptyLeaves() public {
        bytes32[] calldata leaves = MerkleProofLib.emptyLeaves();
        assertEq(leaves.length, 0);
    }

    function testEmptyFlags() public {
        bool[] calldata flags = MerkleProofLib.emptyFlags();
        assertEq(flags.length, 0);
    }
}
