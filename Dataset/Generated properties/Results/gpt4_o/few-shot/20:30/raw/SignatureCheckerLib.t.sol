// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    using SignatureCheckerLib for bytes32;
    using SignatureCheckerLib for bytes;

    bytes32 constant TEST_MESSAGE = 0x7dbaf558b0a1a5dc7a67202117ab143c1d8605a983e4a743bc06fcc03162dc0d;
    bytes32 constant WRONG_MESSAGE = 0x2d0828dd7c97cff316356da3c16c68ba2316886a0e05ebafb8291939310d51a3;
    address constant SIGNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function testIsValidSignatureNowWithInvalidShortSignatureReturnsFalse() public {
        bytes memory signature = hex"1234";
        assertFalse(this.isValidSignatureNow(SIGNER, TEST_MESSAGE, signature));
    }

    function testIsValidSignatureNowWithInvalidLongSignatureReturnsFalse() public {
        bytes memory signature = hex"01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789";
        assertFalse(this.isValidSignatureNow(SIGNER, TEST_MESSAGE, signature));
    }

    function testIsValidSignatureNowWithValidSignature() public {
        bytes memory signature = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
        assertTrue(this.isValidSignatureNow(SIGNER, TEST_MESSAGE.toEthSignedMessageHash(), signature));
    }

    function testIsValidSignatureNowWithWrongSigner() public {
        bytes memory signature = hex"8688e590483917863a35ef230c0f839be8418aa4ee765228eddfcea7fe2652815db01c2c84b0ec746e1b74d97475c599b3d3419fa7181b4e01de62c02b721aea1b";
        assertFalse(this.isValidSignatureNow(SIGNER, WRONG_MESSAGE.toEthSignedMessageHash(), signature));
    }

    function testIsValidSignatureNowWithInvalidSignature() public {
        bytes memory signature = hex"332ce75a821c982f9127538858900d87d3ec1f9f737338ad67cad133fa48feff48e6fa0c18abc62e42820f05943e47af3e9fbe306ce74d64094bdf1691ee53e01c";
        assertFalse(this.isValidSignatureNow(SIGNER, TEST_MESSAGE.toEthSignedMessageHash(), signature));
    }

    function testIsValidSignatureNowWithShortEIP2098Format() public {
        bytes32 r = 0x5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f;
        bytes32 vs = 0x3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be892;
        assertTrue(this.isValidSignatureNow(SIGNER, TEST_MESSAGE, r, vs));
    }

    function testIsValidSignatureNowWithVRSFormat() public {
        bytes32 r = 0x5d99b6f7f6d1f73d1a26497f2b1c89b24c0993913f86e9a2d02cd69887d9c94f;
        bytes32 s = 0x3c880358579d811b21dd1b7fd9bb01c1d81d10e69f0384e675c32b39643be892;
        uint8 v = 27;
        assertTrue(this.isValidSignatureNow(SIGNER, TEST_MESSAGE, v, r, s));
    }

    function testToEthSignedMessageHash() public {
        assertEq(
            TEST_MESSAGE.toEthSignedMessageHash(),
            bytes32(0x7d768af957ef8cbf6219a37e743d5546d911dae3e46449d8a5810522db2ef65e)
        );
    }

    function testBytesToEthSignedMessageHashShort() public {
        bytes memory message = hex"61626364";
        assertEq(
            message.toEthSignedMessageHash(),
            bytes32(0xefd0b51a9c4e5f3449f4eeacb195bf48659fbc00d2f4001bf4c088ba0779fb33)
        );
    }

    function testBytesToEthSignedMessageHashEmpty() public {
        bytes memory message = hex"";
        assertEq(
            message.toEthSignedMessageHash(),
            bytes32(0x5f35dce98ba4fba25530a026ed80b2cecdaa31091ba4958b99b52ea1d068adad)
        );
    }

    function testBytesToEthSignedMessageHashLong() public {
        bytes memory message = hex"4142434445464748494a4b4c4d4e4f505152535455565758595a6162636465666768696a6b6c6d6e6f707172737475767778797a3031323334353637383921402324255e262a28292d3d5b5d7b7d";
        assertEq(
            message.toEthSignedMessageHash(),
            bytes32(0xa46dbedd405cff161b6e80c17c8567597621d9f4c087204201097cb34448e71b)
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

    function _testBytesToEthSignedMessageHash(uint256 n) internal brutalizeMemory {
        bytes memory message;
        /// @solidity memory-safe-assembly
        assembly {
            message := mload(0x40)
            mstore(message, n)
            mstore(0x40, add(add(message, 0x20), n))
        }
        assertEq(
            message.toEthSignedMessageHash(),
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n", LibString.toString(n), message)
            )
        );
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x40, message)
        }
    }

    function isValidSignatureNow(address signer, bytes32 hash, bytes calldata signature) external returns (bool result) {
        result = SignatureCheckerLib.isValidSignatureNowCalldata(signer, hash, signature);
        assertEq(SignatureCheckerLib.isValidSignatureNow(signer, hash, signature), result);
    }

    function isValidSignatureNow(address signer, bytes32 hash, bytes32 r, bytes32 vs) external view returns (bool) {
        return SignatureCheckerLib.isValidSignatureNow(signer, hash, r, vs);
    }

    function isValidSignatureNow(address signer, bytes32 hash, uint8 v, bytes32 r, bytes32 s) external view returns (bool) {
        return SignatureCheckerLib.isValidSignatureNow(signer, hash, v, r, s);
    }

    function testEmptyCalldataHelpers() public {
        assertFalse(SignatureCheckerLib.isValidSignatureNow(bytes32(0), SignatureCheckerLib.emptySignature()) == address(1));
    }
}