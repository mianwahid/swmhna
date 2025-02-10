// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    using MerkleProofLib for bytes32[];

    function testVerify() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = keccak256(abi.encodePacked("A"));
        proof[1] = keccak256(abi.encodePacked("B"));
        bytes32 root = keccak256(abi.encodePacked(proof[0], proof[1]));
        bytes32 leaf = keccak256(abi.encodePacked("A"));

        bool isValid = MerkleProofLib.verify(proof, root, leaf);
        assertTrue(isValid, "Proof should be valid");
    }

    function testVerifyInvalidProof() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = keccak256(abi.encodePacked("A"));
        proof[1] = keccak256(abi.encodePacked("C")); // Invalid proof element
        bytes32 root = keccak256(abi.encodePacked(proof[0], proof[1]));
        bytes32 leaf = keccak256(abi.encodePacked("A"));

        bool isValid = MerkleProofLib.verify(proof, root, leaf);
        assertFalse(isValid, "Proof should be invalid");
    }

    function testVerifyEmptyProof() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32 root = keccak256(abi.encodePacked("A"));
        bytes32 leaf = keccak256(abi.encodePacked("A"));

        bool isValid = MerkleProofLib.verify(proof, root, leaf);
        assertFalse(isValid, "Proof should be invalid for empty proof");
    }

//    function testVerifyCalldata() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = keccak256(abi.encodePacked("A"));
//        proof[1] = keccak256(abi.encodePacked("B"));
//        bytes32 root = keccak256(abi.encodePacked(proof[0], proof[1]));
//        bytes32 leaf = keccak256(abi.encodePacked("A"));
//
//        bool isValid = MerkleProofLib.verifyCalldata(proof, root, leaf);
//        assertTrue(isValid, "Proof should be valid");
//    }

    function testVerifyMultiProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = keccak256(abi.encodePacked("C"));
        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked("A", "B")), proof[0]));
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256(abi.encodePacked("A"));
        leaves[1] = keccak256(abi.encodePacked("B"));
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;

        bool isValid = MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
        assertTrue(isValid, "MultiProof should be valid");
    }

    function testVerifyMultiProofInvalid() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = keccak256(abi.encodePacked("D")); // Invalid proof element
        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked("A", "B")), proof[0]));
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256(abi.encodePacked("A"));
        leaves[1] = keccak256(abi.encodePacked("B"));
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;

        bool isValid = MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
        assertFalse(isValid, "MultiProof should be invalid");
    }

//    function testVerifyMultiProofCalldata() public {
//        bytes32[] memory proof = new bytes32[](1);
//        proof[0] = keccak256(abi.encodePacked("C"));
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked("A", "B")), proof[0]));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked("A"));
//        leaves[1] = keccak256(abi.encodePacked("B"));
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = false;
//
//        bool isValid = MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags);
//        assertTrue(isValid, "MultiProofCalldata should be valid");
//    }

//    function testVerifyMultiProofCalldataInvalid() public {
//        bytes32[] memory proof = new bytes32[](1);
//        proof[0] = keccak256(abi.encodePacked("D")); // Invalid proof element
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked("A", "B")), proof[0]));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked("A"));
//        leaves[1] = keccak256(abi.encodePacked("B"));
//        bool[] memory flags = new bool[](2);
//        flags[0] = true;
//        flags[1] = false;
//
//        bool isValid = MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags);
//        assertFalse(isValid, "MultiProofCalldata should be invalid");
//    }

    function testEmptyProof() public {
        bytes32[] memory proof = MerkleProofLib.emptyProof();
        assertEq(proof.length, 0, "Empty proof should have length 0");
    }

    function testEmptyLeaves() public {
        bytes32[] memory leaves = MerkleProofLib.emptyLeaves();
        assertEq(leaves.length, 0, "Empty leaves should have length 0");
    }

    function testEmptyFlags() public {
        bool[] memory flags = MerkleProofLib.emptyFlags();
        assertEq(flags.length, 0, "Empty flags should have length 0");
    }
}