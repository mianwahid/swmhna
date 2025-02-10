// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";
contract MerkleProofLibTest is Test {

    function testVerifyEmptyProof() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32 root = keccak256(abi.encodePacked(uint256(1), uint256(2)));
        bytes32 leaf = keccak256(abi.encodePacked(uint256(3)));
        assertFalse(MerkleProofLib.verify(proof, root, leaf), "Should return false for empty proof");
    }
//    function testVerifySingleProof() public {
//        bytes32[] memory proof = new bytes32[](1);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        bytes32 root = keccak256(abi.encodePacked(uint256(1), uint256(2)));
//        bytes32 leaf = keccak256(abi.encodePacked(uint256(1)));
//        assertTrue(MerkleProofLib.verify(proof, root, leaf), "Should return true for valid single proof");
//    }
    function testVerifyInvalidProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = keccak256(abi.encodePacked(uint256(2)));
        bytes32 root = keccak256(abi.encodePacked(uint256(1), uint256(3)));
        bytes32 leaf = keccak256(abi.encodePacked(uint256(1)));
        assertFalse(MerkleProofLib.verify(proof, root, leaf), "Should return false for invalid proof");
    }
//    function testVerifyValidMultiProof() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
//        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
//        bool[] memory flags = new bool[](3);
//        flags[0] = false;
//        flags[1] = true;
//        flags[2] = false;
//        assertTrue(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags), "Should return true for valid multi proof");
//    }
    function testVerifyInvalidMultiProof() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = keccak256(abi.encodePacked(uint256(2)));
        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(7)))));
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
        bool[] memory flags = new bool[](3);
        flags[0] = false;
        flags[1] = true;
        flags[2] = false;
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags), "Should return false for invalid multi proof");
    }
    function testVerifyMultiProofEmptyProof() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
        bool[] memory flags = new bool[](1);
        flags[0] = true;
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags), "Should return false for empty proof");
    }
    function testVerifyMultiProofEmptyLeaves() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = keccak256(abi.encodePacked(uint256(2)));
        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
        bytes32[] memory leaves = new bytes32[](0);
        bool[] memory flags = new bool[](3);
        flags[0] = false;
        flags[1] = false;
        flags[2] = false;
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags), "Should return false for empty leaves");
    }
    function testVerifyMultiProofEmptyFlags() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = keccak256(abi.encodePacked(uint256(2)));
        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
        bool[] memory flags = new bool[](0);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, root, leaves, flags), "Should return false for empty flags");
    }
//    function testVerifyCalldataEmptyProof() public {
//        bytes32[] calldata proof = MerkleProofLib.emptyProof();
//        bytes32 root = keccak256(abi.encodePacked(uint256(1), uint256(2)));
//        bytes32 leaf = keccak256(abi.encodePacked(uint256(3)));
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, leaf), "Should return false for empty proof");
//    }
//    function testVerifyCalldataSingleProof() public {
//        bytes32[] memory proof = new bytes32[](1);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        bytes32 root = keccak256(abi.encodePacked(uint256(1), uint256(2)));
//        bytes32 leaf = keccak256(abi.encodePacked(uint256(1)));
//        assertTrue(MerkleProofLib.verifyCalldata(proof, root, leaf), "Should return true for valid single proof");
//    }
//    function testVerifyCalldataInvalidProof() public {
//        bytes32[] memory proof = new bytes32[](1);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        bytes32 root = keccak256(abi.encodePacked(uint256(1), uint256(3)));
//        bytes32 leaf = keccak256(abi.encodePacked(uint256(1)));
//        assertFalse(MerkleProofLib.verifyCalldata(proof, root, leaf), "Should return false for invalid proof");
//    }
//    function testVerifyMultiProofCalldataValidMultiProof() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
//        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
//        bool[] memory flags = new bool[](3);
//        flags[0] = false;
//        flags[1] = true;
//        flags[2] = false;
//        assertTrue(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags), "Should return true for valid multi proof");
//    }
//    function testVerifyMultiProofCalldataInvalidMultiProof() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(7)))));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
//        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
//        bool[] memory flags = new bool[](3);
//        flags[0] = false;
//        flags[1] = true;
//        flags[2] = false;
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags), "Should return false for invalid multi proof");
//    }
//    function testVerifyMultiProofCalldataEmptyProof() public {
//        bytes32[] calldata proof = MerkleProofLib.emptyProof();
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
//        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
//        bool[] memory flags = new bool[](1);
//        flags[0] = true;
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags), "Should return false for empty proof");
//    }
//    function testVerifyMultiProofCalldataEmptyLeaves() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
//        bytes32[] calldata leaves = MerkleProofLib.emptyLeaves();
//        bool[] memory flags = new bool[](3);
//        flags[0] = false;
//        flags[1] = false;
//        flags[2] = false;
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags), "Should return false for empty leaves");
//    }
//    function testVerifyMultiProofCalldataEmptyFlags() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] = keccak256(abi.encodePacked(uint256(2)));
//        proof[1] = keccak256(abi.encodePacked(uint256(5),uint256(6)));
//        bytes32 root = keccak256(abi.encodePacked(keccak256(abi.encodePacked(uint256(1), uint256(2))), keccak256(abi.encodePacked(uint256(3),uint256(4)))));
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] = keccak256(abi.encodePacked(uint256(1)));
//        leaves[1] = keccak256(abi.encodePacked(uint256(3)));
//        bool[] calldata flags = MerkleProofLib.emptyFlags();
//        assertFalse(MerkleProofLib.verifyMultiProofCalldata(proof, root, leaves, flags), "Should return false for empty flags");
//    }
}
 
