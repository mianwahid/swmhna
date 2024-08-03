// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MerkleProofLib.sol";
contract MerkleProofLibTest is Test {

    bytes32 public constant ROOT =
        0xd073e0804bc07229a7757a577707a8d5d6f599769681283c42a7a447ebc1d694;

//    function testVerify() public {
//        bytes32[] memory proof = new bytes32[](2);
//        proof[0] =
//            0x94455b488a4a6b816e48387861838243f4829864788628217f7a885a6815082a;
//        proof[1] =
//            0x65d00938a9823f4b0ab092a1c1e272c2b972d08b7f0a5899c1f157a1a7d808e3;
//        bytes32 leaf =
//            0x61d624c175181a2a40f90750bd8c0e9b4e46768d76568d86e9a40d0a2902884b;
//        assertTrue(MerkleProofLib.verify(proof, ROOT, leaf));
////        assertTrue(this.verifyCalldata(proof, ROOT, leaf));
//    }

    function testVerifyFails() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] =
            0x94455b488a4a6b816e48387861838243f4829864788628217f7a885a6815082a;
        proof[1] =
            0x65d00938a9823f4b0ab092a1c1e272c2b972d08b7f0a5899c1f157a1a7d808e3;
        bytes32 leaf =
            0x61d624c175181a2a40f90750bd8c0e9b4e46768d76568d86e9a40d0a2902884c;
        assertFalse(MerkleProofLib.verify(proof, ROOT, leaf));
//        assertFalse(this.verifyCalldata(proof, ROOT, leaf));
    }

//    function testVerifyMultiProof() public {
//        bytes32[] memory proof = new bytes32[](3);
//        proof[0] =
//            0x94455b488a4a6b816e48387861838243f4829864788628217f7a885a6815082a;
//        proof[1] =
//            0x65d00938a9823f4b0ab092a1c1e272c2b972d08b7f0a5899c1f157a1a7d808e3;
//        proof[2] =
//            0x2b0e2c55a78a208c2f49998532862582eb7d578a95eed27e1ef002c8a8211c83;
//        bytes32[] memory leaves = new bytes32[](2);
//        leaves[0] =
//            0x61d624c175181a2a40f90750bd8c0e9b4e46768d76568d86e9a40d0a2902884b;
//        leaves[1] =
//            0x9c28e086a18871a7a68bc2c79f82881a7221480fd760a5698268b6286779f806;
//        bool[] memory flags = new bool[](4);
//        flags[0] = true;
//        flags[1] = false;
//        flags[2] = true;
//        flags[3] = true;
//        assertTrue(MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags));
////        assertTrue(this.verifyMultiProofCalldata(proof, ROOT, leaves, flags));
//    }

    function testVerifyMultiProofFails() public {
        bytes32[] memory proof = new bytes32[](3);
        proof[0] =
            0x94455b488a4a6b816e48387861838243f4829864788628217f7a885a6815082a;
        proof[1] =
            0x65d00938a9823f4b0ab092a1c1e272c2b972d08b7f0a5899c1f157a1a7d808e3;
        proof[2] =
            0x2b0e2c55a78a208c2f49998532862582eb7d578a95eed27e1ef002c8a8211c83;
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] =
            0x61d624c175181a2a40f90750bd8c0e9b4e46768d76568d86e9a40d0a2902884c;
        leaves[1] =
            0x9c28e086a18871a7a68bc2c79f82881a7221480fd760a5698268b6286779f806;
        bool[] memory flags = new bool[](4);
        flags[0] = true;
        flags[1] = false;
        flags[2] = true;
        flags[3] = true;
        assertFalse(MerkleProofLib.verifyMultiProof(proof, ROOT, leaves, flags));
//        assertFalse(this.verifyMultiProofCalldata(proof, ROOT, leaves, flags));
    }

    function testVerifyMultiProofBounds() public {
        bytes32[] memory proof = new bytes32[](0);
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] =
            0x61d624c175181a2a40f90750bd8c0e9b4e46768d76568d86e9a40d0a2902884b;
        bool[] memory flags = new bool[](0);
        assertTrue(MerkleProofLib.verifyMultiProof(proof, leaves[0], leaves, flags));
    }

    function testVerifyMultiProofBoundsFails() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] =
            0x94455b488a4a6b816e48387861838243f4829864788628217f7a885a6815082a;
        bytes32[] memory leaves = new bytes32[](1);
        leaves[0] =
            0x61d624c175181a2a40f90750bd8c0e9b4e46768d76568d86e9a40d0a2902884b;
        bool[] memory flags = new bool[](0);
        assertFalse(MerkleProofLib.verifyMultiProof(proof, leaves[0], leaves, flags));
    }

//    function testVerifyCalldata(
//        bytes32[] memory proof,
//        bytes32 root,
//        bytes32 leaf
//    ) public {
//        bytes32[] calldata proof_ = proof;
//        assertTrue(MerkleProofLib.verifyCalldata(proof_, root, leaf));
//    }

//    function testVerifyMultiProofCalldata(
//        bytes32[] memory proof,
//        bytes32 root,
//        bytes32[] memory leaves,
//        bool[] memory flags
//    ) public {
//        bytes32[] calldata proof_ = proof;
//        bytes32[] calldata leaves_ = leaves;
//        bool[] calldata flags_ = flags;
//        assertTrue(
//            MerkleProofLib.verifyMultiProofCalldata(proof_, root, leaves_, flags_)
//        );
//    }

    function testEmptyCalldataHelpers() public {
        bytes32[] calldata proof = MerkleProofLib.emptyProof();
        bytes32[] calldata leaves = MerkleProofLib.emptyLeaves();
        bool[] calldata flags = MerkleProofLib.emptyFlags();
        assertTrue(proof.length == 0);
        assertTrue(leaves.length == 0);
        assertTrue(flags.length == 0);
    }

    function testFuzzVerify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) public {
        MerkleProofLib.verify(proof, root, leaf);
    }

//    function testFuzzVerifyMultiProof(
//        bytes32[] memory proof,
//        bytes32 root,
//        bytes32[] memory leaves,
//        bool[] memory flags
//    ) public {
//        vm.assume(
//            flags.length == (leaves.length > 0 ? leaves.length - 1 : 0) + proof.length
//        );
//        MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
//    }
}
