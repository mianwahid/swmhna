// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";

contract MerkleProofLibTest is Test {
    // Define test data
    bytes32 internal constant ROOT =
        0xd0c689a998622f7d5a28113227073d82a1a2a70f807859ba9a678d5e98898201;
    bytes32 internal constant LEAF =
        0x0000000000000000000000000000000000000000000000000000000000000001;
    bytes32[] internal  PROOF = [
        0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883,
        0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2,
        0x0eb78aa542c5abf9e37722c2064f2d8a88c8aae2a88d8f08e1d25a356c1e0e9c
    ];

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

    function testVerify_ValidProof() public {
        assertTrue(MerkleProofLib.verify(PROOF, ROOT, LEAF));
    }

    function testVerifyCalldata_ValidProof() public {
        assertTrue(MerkleProofLib.verifyCalldata(PROOF, ROOT, LEAF));
    }

    function testVerify_InvalidProof_IncorrectRoot() public {
        bytes32 incorrectRoot = keccak256(abi.encodePacked(ROOT));
        assertFalse(MerkleProofLib.verify(PROOF, incorrectRoot, LEAF));
    }

    function testVerifyCalldata_InvalidProof_IncorrectRoot() public {
        bytes32 incorrectRoot = keccak256(abi.encodePacked(ROOT));
        assertFalse(
            MerkleProofLib.verifyCalldata(PROOF, incorrectRoot, LEAF)
        );
    }

    function testVerify_InvalidProof_ModifiedProofElement() public {
        bytes32[] memory modifiedProof = new bytes32[](PROOF.length);
        for (uint256 i = 0; i < PROOF.length; i++) {
            modifiedProof[i] = PROOF[i];
        }
        modifiedProof[1] = keccak256(abi.encodePacked(PROOF[1]));
        assertFalse(MerkleProofLib.verify(modifiedProof, ROOT, LEAF));
    }

    function testVerifyCalldata_InvalidProof_ModifiedProofElement() public {
        bytes32[] memory modifiedProof = new bytes32[](PROOF.length);
        for (uint256 i = 0; i < PROOF.length; i++) {
            modifiedProof[i] = PROOF[i];
        }
        modifiedProof[1] = keccak256(abi.encodePacked(PROOF[1]));
        assertFalse(
            MerkleProofLib.verifyCalldata(modifiedProof, ROOT, LEAF)
        );
    }

    function testVerify_InvalidProof_IncorrectLeaf() public {
        bytes32 incorrectLeaf = keccak256(abi.encodePacked(LEAF));
        assertFalse(MerkleProofLib.verify(PROOF, ROOT, incorrectLeaf));
    }

    function testVerifyCalldata_InvalidProof_IncorrectLeaf() public {
        bytes32 incorrectLeaf = keccak256(abi.encodePacked(LEAF));
        assertFalse(
            MerkleProofLib.verifyCalldata(PROOF, ROOT, incorrectLeaf)
        );
    }

    function testVerify_EmptyProof() public {
        bytes32[] memory emptyProof = new bytes32[](0);
        assertFalse(MerkleProofLib.verify(emptyProof, ROOT, LEAF));
        assertTrue(MerkleProofLib.verify(emptyProof, ROOT, ROOT));
    }

    function testVerifyCalldata_EmptyProof() public {
        assertFalse(MerkleProofLib.verifyCalldata(PROOF, ROOT, LEAF));
        assertTrue(MerkleProofLib.verifyCalldata(PROOF, ROOT, ROOT));
    }

    function testVerify_SingleElementProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        bytes32 leaf =
            0x0000000000000000000000000000000000000000000000000000000000000001;
        bytes32 expectedRoot =
            keccak256(
                abi.encodePacked(
                    proof[0],
                    keccak256(abi.encodePacked(leaf))
                )
            );
        assertTrue(MerkleProofLib.verify(proof, expectedRoot, leaf));
    }

    function testVerifyCalldata_SingleElementProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        bytes32 leaf =
            0x0000000000000000000000000000000000000000000000000000000000000001;
        bytes32 expectedRoot =
            keccak256(
                abi.encodePacked(
                    proof[0],
                    keccak256(abi.encodePacked(leaf))
                )
            );
        assertTrue(
            MerkleProofLib.verifyCalldata(proof, expectedRoot, leaf)
        );
    }

    function testVerifyMultiProof_ValidProof() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        assertTrue(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_ValidProof() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        assertTrue(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_InvalidProof_IncorrectRoot() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        bytes32 incorrectRoot = keccak256(abi.encodePacked(ROOT));
        assertFalse(
            MerkleProofLib.verifyMultiProof(
                proof,
                incorrectRoot,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProofCalldata_InvalidProof_IncorrectRoot()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        bytes32 incorrectRoot = keccak256(abi.encodePacked(ROOT));
        assertFalse(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                incorrectRoot,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_InvalidProof_ModifiedProofElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        proof[1] = keccak256(abi.encodePacked(proof[1]));
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_InvalidProof_ModifiedProofElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        proof[1] = keccak256(abi.encodePacked(proof[1]));
        assertFalse(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_InvalidProof_ModifiedLeavesElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        leaves[1] = keccak256(abi.encodePacked(leaves[1]));
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_InvalidProof_ModifiedLeavesElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        leaves[1] = keccak256(abi.encodePacked(leaves[1]));
        assertFalse(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_InvalidProof_ModifiedFlagsElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        flags[1] = !flags[1];
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_InvalidProof_ModifiedFlagsElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        flags[1] = !flags[1];
        assertFalse(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_InvalidProof_IncorrectFlagsLength()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_InvalidProof_IncorrectFlagsLength()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](2);
        flags[0] = true;
        flags[1] = false;
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        assertFalse(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_EmptyProofEmptyLeaves() public {
        bytes32[] memory leaves = new bytes32[](0);
        bool[] memory flags = new bool[](0);
        bytes32[] memory proof = new bytes32[](0);
        assertTrue(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_EmptyProofEmptyLeaves() public {
        bytes32[] memory leaves = new bytes32[](0);
        bool[] memory flags = new bool[](0);
        bytes32[] memory proof = new bytes32[](0);
        assertTrue(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_EmptyProofSingleLeaf() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = LEAF;
        bool[] memory flags = new bool[](0);
        bytes32[] memory proof = new bytes32[](0);
        assertFalse(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_EmptyProofSingleLeaf() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = LEAF;
        bool[] memory flags = new bool[](0);
        bytes32[] memory proof = new bytes32[](0);
        assertFalse(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_SingleLeafMultiProof() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = LEAF;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](3);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        proof[2] =
            0x0eb78aa542c5abf9e37722c2064f2d8a88c8aae2a88d8f08e1d25a356c1e0e9c;
        assertTrue(
            MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags)
        );
    }

    function testVerifyMultiProofCalldata_SingleLeafMultiProof() public {
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] = LEAF;
        bool[] memory flags = new bool[](3);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        bytes32[] memory proof = new bytes32[](3);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        proof[1] =
            0x2b53d020409c8c708c2788325315c6e522eabe7d8717a38a686c1d97ab78a5c2;
        proof[2] =
            0x0eb78aa542c5abf9e37722c2064f2d8a88c8aae2a88d8f08e1d25a356c1e0e9c;
        assertTrue(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                ROOT,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProof_MultipleLeavesSingleProofElement() public {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](1);
        flags[0] = true;
        bytes32[] memory proof = new bytes32[](1);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        bytes32 calculatedRoot =
            keccak256(
                abi.encodePacked(
                    proof[0],
                    keccak256(abi.encodePacked(leaves[0], leaves[1]))
                )
            );
        assertTrue(
            MerkleProofLib.verifyMultiProof(
                proof,
                calculatedRoot,
                leaves,
                flags
            )
        );
    }

    function testVerifyMultiProofCalldata_MultipleLeavesSingleProofElement()
        public
    {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = LEAF;
        leaves[1] =
            0x0000000000000000000000000000000000000000000000000000000000000002;
        bool[] memory flags = new bool[](1);
        flags[0] = true;
        bytes32[] memory proof = new bytes32[](1);
        proof[0] =
            0xb1178831c803080c129f002e1aa1d9809f080135a591ff0a801c4092288ab883;
        bytes32 calculatedRoot =
            keccak256(
                abi.encodePacked(
                    proof[0],
                    keccak256(abi.encodePacked(leaves[0], leaves[1]))
                )
            );
        assertTrue(
            MerkleProofLib.verifyMultiProofCalldata(
                proof,
                calculatedRoot,
                leaves,
                flags
            )
        );
    }
}