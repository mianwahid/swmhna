//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/ECDSA.sol";
//
//contract ECDSATest is Test {
//    bytes32 constant TEST_MESSAGE_HASH = 0x7dbaf558b0a1a5dc7a67202117ab143c1d8605a983e4a743bc06fcc03162dc0d;
//    bytes32 constant WRONG_MESSAGE_HASH = 0x2d0828dd7c97cff316356da3c16c68ba2316886a0e05ebafb8291939310d51a3;
//    address constant SIGNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
//    bytes public SIGNATURE = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
//    bytes public INVALID_SIGNATURE = hex"7688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
//
//    function testRecoverWithValidSignature() public {
//        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }
//
//    function testRecoverWithInvalidSignature() public {
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        ECDSA.recover(TEST_MESSAGE_HASH, INVALID_SIGNATURE);
//    }
//
//    function testRecoverWithWrongMessageHash() public {
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        ECDSA.recover(WRONG_MESSAGE_HASH, SIGNATURE);
//    }
//
//    function testRecoverCalldataWithValidSignature() public {
//        address recovered = ECDSA.recoverCalldata(TEST_MESSAGE_HASH, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }
//
//    function testRecoverCalldataWithInvalidSignature() public {
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        ECDSA.recoverCalldata(TEST_MESSAGE_HASH, INVALID_SIGNATURE);
//    }
//
//    function testRecoverCalldataWithWrongMessageHash() public {
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        ECDSA.recoverCalldata(WRONG_MESSAGE_HASH, SIGNATURE);
//    }
//
//    function testTryRecoverWithValidSignature() public {
//        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }
//
//    function testTryRecoverWithInvalidSignature() public {
//        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, INVALID_SIGNATURE);
//        assertEq(recovered, address(0));
//    }
//
//    function testTryRecoverWithWrongMessageHash() public {
//        address recovered = ECDSA.tryRecover(WRONG_MESSAGE_HASH, SIGNATURE);
//        assertEq(recovered, address(0));
//    }
//
//    function testTryRecoverCalldataWithValidSignature() public {
//        address recovered = ECDSA.tryRecoverCalldata(TEST_MESSAGE_HASH, SIGNATURE);
//        assertEq(recovered, SIGNER);
//    }
//
//    function testTryRecoverCalldataWithInvalidSignature() public {
//        address recovered = ECDSA.tryRecoverCalldata(TEST_MESSAGE_HASH, INVALID_SIGNATURE);
//        assertEq(recovered, address(0));
//    }
//
//    function testTryRecoverCalldataWithWrongMessageHash() public {
//        address recovered = ECDSA.tryRecoverCalldata(WRONG_MESSAGE_HASH, SIGNATURE);
//        assertEq(recovered, address(0));
//    }
//
//    function testToEthSignedMessageHashWithHash() public {
//        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(TEST_MESSAGE_HASH);
//        assertEq(ethSignedMessageHash, 0x7d768af957ef8cbf6219a37e743d5546d911dae3e46449d8a5810522db2ef65e);
//    }
//
//    function testToEthSignedMessageHashWithBytes() public {
//        bytes memory message = "Hello, world!";
//        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(message);
//        assertEq(ethSignedMessageHash, 0x2d0828dd7c97cff316356da3c16c68ba2316886a0e05ebafb8291939310d51a3);
//    }
//
//    function testEmptySignature() public {
//        bytes memory emptySig = ECDSA.emptySignature();
//        assertEq(emptySig.length, 0);
//    }
//}
