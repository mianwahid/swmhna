// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    using MerkleProofLib for bytes32[];

    bytes32 root;
    bytes32 leaf;
    bytes32[] proof;
    bytes32[] leaves;
    bool[] flags;

    function setUp() public {
        // Initialize with some default values
        root = keccak256(abi.encodePacked("root"));
        leaf = keccak256(abi.encodePacked("leaf"));
        proof = new bytes32[](1);
        proof[0] = keccak256(abi.encodePacked("proof"));
        leaves = new bytes32[](1);
        leaves[0] = leaf;
        flags = new bool[](1);
        flags[0] = true;
    }

    // 1. verify
    function testVerifyCorrectProof() public {
        bytes32[] memory validProof = new bytes32[](1);
        validProof[0] = keccak256(abi.encodePacked(leaf));
        assertTrue(MerkleProofLib.verify(validProof, keccak256(abi.encodePacked(validProof[0])), leaf));
    }

    function testVerifyIncorrectProof() public {
        bytes32[] memory invalidProof = new bytes32[](1);
        invalidProof[0] = keccak256(abi.encodePacked("invalid"));
        assertFalse(MerkleProofLib.verify(invalidProof, root, leaf));
    }

    function testVerifyEmptyProof() public {
        bytes32[] memory emptyProof = new bytes32[](0);
        assertFalse(MerkleProofLib.verify(emptyProof, root, leaf));
    }

    function testVerifySingleElementProof() public {
        bytes32[] memory singleProof = new bytes32[](1);
        singleProof[0] = leaf;
        assertTrue(MerkleProofLib.verify(singleProof, leaf, leaf));
    }

    function testVerifyBoundaryConditions() public {
        bytes32 smallest = bytes32(0);
        bytes32 largest = bytes32(type(uint256).max);
        bytes32[] memory proofSmall = new bytes32[](1);
        proofSmall[0] = smallest;
        bytes32[] memory proofLarge = new bytes32[](1);
        proofLarge[0] = largest;
        assertFalse(MerkleProofLib.verify(proofSmall, root, smallest));
        assertFalse(MerkleProofLib.verify(proofLarge, root, largest));
    }

    // 2. verifyCalldata
//    function testVerifyCalldataCorrectProof() public {
//        bytes32[] memory validProof = new bytes32[](1);
//        validProof[0] = keccak256(abi.encodePacked(leaf));
//        assertTrue(MerkleProofLib.verifyCalldata(validProof, keccak256(abi.encodePacked(validProof[0])), leaf));
//    }
//
//    function testVerifyCalldataIncorrectProof() public {
//        bytes32[] memory invalidProof = new bytes32[](1);
//        invalidProof[0] = keccak256(abi.encodePacked("invalid"));
//        assertFalse(MerkleProofLib.verifyCalldata(invalidProof, root, leaf));
//    }
//
//    function testVerifyCalldataEmptyProof() public {
//        bytes32[] memory emptyProof = new bytes32[](0);
//        assertFalse(MerkleProofLib.verifyCalldata(emptyProof, root, leaf));
//    }
//
//    function testVerifyCalldataSingleElementProof() public {
//        bytes32[] memory singleProof = new bytes32[](1);
//        singleProof[0] = leaf;
//        assertTrue(MerkleProofLib.verifyCalldata(singleProof, leaf, leaf));
//    }
//
//    function testVerifyCalldataBoundaryConditions() public {
//        bytes32 smallest = bytes32(0);
//        bytes32 largest = bytes32(type(uint256).max);
//        bytes32[] memory proofSmall = new bytes32[](1);
//        proofSmall[0] = smallest;
//        bytes32[] memory proofLarge = new bytes32[](1);
//        proofLarge[0] = largest;
//        assertFalse(MerkleProofLib.verifyCalldata(proofSmall, root, smallest));
//        assertFalse(MerkleProofLib.verifyCalldata(proofLarge, root, largest));
//    }

    // 3. verifyMultiProof
    function testVerifyMultiProofCorrect() public {
        bytes32[] memory validProof = new bytes32[](1);
        validProof[0] = keccak256(abi.encodePacked(leaf));
        bool[] memory validFlags = new bool[](1);
        validFlags[0] = true;
        assertTrue(MerkleProofLib.verifyMultiProof(validProof, keccak256(abi.encodePacked(validProof[0])), leaves, validFlags));
    }

    function testVerifyMultiProofIncorrect() public {
        bytes32[] memory invalidProof = new bytes32[](1);
        invalidProof[0] = keccak256(abi.encodePacked("invalid"));
        assertFalse(MerkleProofLib.verifyMultiProof(invalidProof, root, leaves, flags));
    }

    function testVerifyMultiProofEmpty() public {
        bytes32[] memory emptyProof = new bytes32[](0);
        bytes32[] memory emptyLeaves = new bytes32[](0);
        assertFalse(MerkleProofLib.verifyMultiProof(emptyProof, root, emptyLeaves, flags));
    }

    function testVerifyMultiProofSingleElement() public {
        bytes32[] memory singleProof = new bytes32[](1);
        singleProof[0] = leaf;
        bytes32[] memory singleLeaf = new bytes32[](1);
        singleLeaf[0] = leaf;
        assertTrue(MerkleProofLib.verifyMultiProof(singleProof, leaf, singleLeaf, flags));
    }

    function testVerifyMultiProofFlagsLengthMismatch() public {
        bool[] memory invalidFlags = new bool[](2);
        invalidFlags[0] = true;
        invalidFlags[1] = false;
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, invalidFlags));
    }

    function testVerifyMultiProofBoundaryConditions() public {
        bytes32 smallest = bytes32(0);
        bytes32 largest = bytes32(type(uint256).max);
        bytes32[] memory proofSmall = new bytes32[](1);
        proofSmall[0] = smallest;
        bytes32[] memory proofLarge = new bytes32[](1);
        proofLarge[0] = largest;
        bytes32[] memory leavesSmall = new bytes32[](1);
        leavesSmall[0] = smallest;
        bytes32[] memory leavesLarge = new bytes32[](1);
        leavesLarge[0] = largest;
        assertFalse(MerkleProofLib.verifyMultiProof(proofSmall, root, leavesSmall, flags));
        assertFalse(MerkleProofLib.verifyMultiProof(proofLarge, root, leavesLarge, flags));
    }
//
//    // 4. verifyMultiProofCalldata
//    function testVerifyMultiProofCalldataCorrect() public {
//        bytes32[] memory validProof = new bytes32[](1);
//        validProof[0] = keccak256(abi.encodePacked(leaf));
//        bool[] memory validFlags = new bool[](1);
//        validFlags[0] = true;
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(validProof, keccak256(abi.encodePacked(validProof[0])), leaves, validFlags));
//    }
//
//    function testVerifyMultiProofCalldataIncorrect() public {
//        bytes32[] memory invalidProof = new bytes32[](1);
//        invalidProof[0] = keccak256(abi.encodePacked("invalid"));
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(invalidProof, root, leaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataEmpty() public {
//        bytes32[] memory emptyProof = new bytes32[](0);
//        bytes32[] memory emptyLeaves = new bytes32[](0);
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(emptyProof, root, emptyLeaves, flags));
//    }
//
//    function testVerifyMultiProofCalldataSingleElement() public {
//        bytes32[] memory singleProof = new bytes32[](1);
//        singleProof[0] = leaf;
//        bytes32[] memory singleLeaf = new bytes32[](1);
//        singleLeaf[0] = leaf;
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(singleProof, leaf, singleLeaf, flags));
//    }
//
//    function testVerifyMultiProofCalldataFlagsLengthMismatch() public {
//        bool[] memory invalidFlags = new bool[](2);
//        invalidFlags[0] = true;
//        invalidFlags[1] = false;
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, invalidFlags));
//    }
//
//    function testVerifyMultiProofCalldataBoundaryConditions() public {
//        bytes32 smallest = bytes32(0);
//        bytes32 largest = bytes32(type(uint256).max);
//        bytes32[] memory proofSmall = new bytes32[](1);
//        proofSmall[0] = smallest;
//        bytes32[] memory proofLarge = new bytes32[](1);
//        proofLarge[0] = largest;
//        bytes32[] memory leavesSmall = new bytes32[](1);
//        leavesSmall[0] = smallest;
//        bytes32[] memory leavesLarge = new bytes32[](1);
//        leavesLarge[0] = largest;
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proofSmall, root, leavesSmall, flags));
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proofLarge, root, leavesLarge, flags));
//    }

    // 5. emptyProof
    function testEmptyProof() public {
        bytes32[] memory emptyProof = MerkleProofLib.emptyProof();
        assertEq(emptyProof.length, 0);
    }

    // 6. emptyLeaves
    function testEmptyLeaves() public {
        bytes32[] memory emptyLeaves = MerkleProofLib.emptyLeaves();
        assertEq(emptyLeaves.length, 0);
    }

    // 7. emptyFlags
    function testEmptyFlags() public {
        bool[] memory emptyFlags = MerkleProofLib.emptyFlags();
        assertEq(emptyFlags.length, 0);
    }
}