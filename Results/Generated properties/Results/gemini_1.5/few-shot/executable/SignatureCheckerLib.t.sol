// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {stdError} from "forge-std/StdError.sol";
import {SignatureCheckerLib} from "../src/utils/SignatureCheckerLib.sol";
import {ECDSA} from "../src/utils/ECDSA.sol";
import {LibString} from "../src/utils/LibString.sol";

contract SignatureCheckerLibTest is Test {
    using SignatureCheckerLib for address;

    address internal constant ALICE = address(0x1337);
    address internal constant BOB = address(0x1338);

    bytes32 internal constant TEST_MESSAGE_HASH =
        keccak256(abi.encodePacked("SignatureCheckerLibTest", "test message"));

    function setUp() public {
        vm.label(ALICE, "Alice");
        vm.label(BOB, "Bob");
    }

    function testToEthSignedMessageHash() public {
        assertEq(
            SignatureCheckerLib.toEthSignedMessageHash(TEST_MESSAGE_HASH),
            ECDSA.toEthSignedMessageHash(TEST_MESSAGE_HASH)
        );
    }

    function testBytesToEthSignedMessageHashShort() public {
        bytes memory message = hex"61626364";
        assertEq(
            SignatureCheckerLib.toEthSignedMessageHash(message),
            ECDSA.toEthSignedMessageHash(message)
        );
    }

//    function testBytesToEthSignedMessageHashEmpty() public {
//        bytes memory message = hex("");
//        assertEq(
//            SignatureCheckerLib.toEthSignedMessageHash(message),
//            ECDSA.toEthSignedMessageHash(message)
//        );
//    }

    function testBytesToEthSignedMessageHashLong() public {
        bytes memory message =
            hex"4142434445464748494a4b4c4d4e4f505152535455565758595a6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383921402324255e262a28292d3d5b5d7b7d";
        assertEq(
            SignatureCheckerLib.toEthSignedMessageHash(message),
            ECDSA.toEthSignedMessageHash(message)
        );
    }

    function testBytesToEthSignedMessageHash() public {
        _testBytesToEthSignedMessageHash(999999);
        _testBytesToEthSignedMessageHash(135790);
        _testBytesToEthSignedMessageHash(99999);
        _testBytesToEthSignedMessageHash(88888);
        _testBytesToEthSignedMessageHash(3210);
        _testBytesToEthSignedMessageHash(111);
        _testBytesToEthSignedMessageHash(22);
        _testBytesToEthSignedMessageHash(1);
        _testBytesToEthSignedMessageHash(0);
    }

    function testBytesToEthSignedMessageHashExceedsMaxLengthReverts() public {
        vm.expectRevert();
        _testBytesToEthSignedMessageHash(999999 + 1);
    }

    function _testBytesToEthSignedMessageHash(uint256 n) internal  {
        bytes memory message;
        /// @solidity memory-safe-assembly
        assembly {
            message := mload(0x40)
            mstore(message, n)
            mstore(0x40, add(add(message, 0x20), n))
        }
        assertEq(
            SignatureCheckerLib.toEthSignedMessageHash(message),
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n", LibString.toString(n), message)
            )
        );
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x40, message)
        }
    }

//    function testIsValidSignatureNowWithShortEIP2098Format(uint256 privateKey) public {
//        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, TEST_MESSAGE_HASH);
//        bytes32 vs = bytes32((v == 28 ? 1 << 255 : 0) | uint256(s));
//        address signer = vm.addr(privateKey);
//        assertTrue(signer.isValidSignatureNow(TEST_MESSAGE_HASH, r, vs));
//    }
// //Failing test
//    function testIsValidSignatureNowWithInvalidShortEIP2098Format(uint256 privateKey)
//        public
//    {
//        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, TEST_MESSAGE_HASH);
//        bytes32 vs = bytes32(uint256(s) ^ 1);
//        address signer = vm.addr(privateKey);
//        assertFalse(signer.isValidSignatureNow(TEST_MESSAGE_HASH, r, vs));
//    }

//    function testIsValidSignatureNowWithValidSignature(uint256 privateKey) public {
//        bytes memory signature = _sign(privateKey, TEST_MESSAGE_HASH);
//        address signer = vm.addr(privateKey);
//        assertTrue(signer.isValidSignatureNow(TEST_MESSAGE_HASH, signature));
//    }
//
//    function testIsValidSignatureNowWithWrongSigner(uint256 privateKey) public {
//        bytes memory signature = _sign(privateKey, TEST_MESSAGE_HASH);
//        address signer = vm.addr(privateKey);
//        address wrongSigner = address(uint160(uint256(signer) + 1));
//        assertFalse(wrongSigner.isValidSignatureNow(TEST_MESSAGE_HASH, signature));
//    }

//    function testIsValidSignatureNowWithInvalidSignature(uint256 privateKey) public {
//        bytes memory signature = _sign(privateKey, TEST_MESSAGE_HASH);
//        signature[0] = 0xff;
//        address signer = vm.addr(privateKey);
//        assertFalse(signer.isValidSignatureNow(TEST_MESSAGE_HASH, signature));
//    }
//
//    function testIsValidSignatureNowCalldataWithValidSignature(uint256 privateKey) public {
//        bytes memory signature = _sign(privateKey, TEST_MESSAGE_HASH);
//        address signer = vm.addr(privateKey);
//        assertTrue(signer.isValidSignatureNowCalldata(TEST_MESSAGE_HASH, signature));
//    }

//    function testIsValidSignatureNowCalldataWithWrongSigner(uint256 privateKey) public {
//        bytes memory signature = _sign(privateKey, TEST_MESSAGE_HASH);
//        address signer = vm.addr(privateKey);
//        address wrongSigner = address(uint160(uint256(signer) + 1));
//        assertFalse(wrongSigner.isValidSignatureNowCalldata(TEST_MESSAGE_HASH, signature));
//    }
//
//    function testIsValidSignatureNowCalldataWithInvalidSignature(uint256 privateKey) public {
//        bytes memory signature = _sign(privateKey, TEST_MESSAGE_HASH);
//        signature[0] = 0xff;
//        address signer = vm.addr(privateKey);
//        assertFalse(signer.isValidSignatureNowCalldata(TEST_MESSAGE_HASH, signature));
//    }

    function testEmptyCalldataHelpers() public {
        assertFalse(address(1).isValidSignatureNow(bytes32(0), SignatureCheckerLib.emptySignature()));
    }

//    function _sign(uint256 privateKey, bytes32 hash) internal returns (bytes memory signature) {
//        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hash);
//        signature = new bytes(65);
//        signature[0] = bytes1(uint8(r >> 0));
//        signature[1] = bytes1(uint8(r >> 8));
//        signature[2] = bytes1(uint8(r >> 16));
//        signature[3] = bytes1(uint8(r >> 24));
//        signature[4] = bytes1(uint8(r >> 32));
//        signature[5] = bytes1(uint8(r >> 40));
//        signature[6] = bytes1(uint8(r >> 48));
//        signature[7] = bytes1(uint8(r >> 56));
//        signature[8] = bytes1(uint8(s >> 0));
//        signature[9] = bytes1(uint8(s >> 8));
//        signature[10] = bytes1(uint8(s >> 16));
//        signature[11] = bytes1(uint8(s >> 24));
//        signature[12] = bytes1(uint8(s >> 32));
//        signature[13] = bytes1(uint8(s >> 40));
//        signature[14] = bytes1(uint8(s >> 48));
//        signature[15] = bytes1(uint8(s >> 56));
//        signature[64] = bytes1(v);
//    }
}