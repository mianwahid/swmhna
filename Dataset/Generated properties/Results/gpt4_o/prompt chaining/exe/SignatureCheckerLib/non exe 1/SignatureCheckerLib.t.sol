// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    using SignatureCheckerLib for address;

    address eoaSigner;
    address contractSigner;
    bytes32 hash;
    bytes   validSignature;
    bytes  invalidSignature;
    bytes32 r;
    bytes32 vs;
    uint8 v;
    bytes32 s;

    function setUp() public {
        eoaSigner = address(0x123);
        contractSigner = address(0x456);
        hash = keccak256("test message");
        validSignature = hex"";
        invalidSignature = hex"";
        r = bytes32(0);
        vs = bytes32(0);
        v = 27;
        s = bytes32(0);
    }

    function testIsValidSignatureNowEOA() public {
        bool result = eoaSigner.isValidSignatureNow(hash, validSignature);
        assertTrue(result, "Valid EOA signature should return true");

        result = eoaSigner.isValidSignatureNow(hash, invalidSignature);
        assertFalse(result, "Invalid EOA signature should return false");
    }

    function testIsValidSignatureNowContract() public {
        bool result = contractSigner.isValidSignatureNow(hash, validSignature);
        assertTrue(result, "Valid contract signature should return true");

        result = contractSigner.isValidSignatureNow(hash, invalidSignature);
        assertFalse(result, "Invalid contract signature should return false");
    }

    function testIsValidSignatureNow64Byte() public {
        bool result = eoaSigner.isValidSignatureNow(hash, validSignature);
        assertTrue(result, "Valid 64-byte signature should return true");
    }

    function testIsValidSignatureNow65Byte() public {
        bool result = eoaSigner.isValidSignatureNow(hash, validSignature);
        assertTrue(result, "Valid 65-byte signature should return true");
    }

    function testIsValidSignatureNowDirtyUpperBits() public {
        address dirtySigner = address(uint160(eoaSigner) | (1 << 160));
        bool result = dirtySigner.isValidSignatureNow(hash, validSignature);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidSignatureNowCalldataEOA() public {
        bool result = eoaSigner.isValidSignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Valid EOA signature should return true");

        result = eoaSigner.isValidSignatureNowCalldata(hash, invalidSignature);
        assertFalse(result, "Invalid EOA signature should return false");
    }

    function testIsValidSignatureNowCalldataContract() public {
        bool result = contractSigner.isValidSignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Valid contract signature should return true");

        result = contractSigner.isValidSignatureNowCalldata(hash, invalidSignature);
        assertFalse(result, "Invalid contract signature should return false");
    }

    function testIsValidSignatureNowCalldata64Byte() public {
        bool result = eoaSigner.isValidSignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Valid 64-byte signature should return true");
    }

    function testIsValidSignatureNowCalldata65Byte() public {
        bool result = eoaSigner.isValidSignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Valid 65-byte signature should return true");
    }

    function testIsValidSignatureNowCalldataDirtyUpperBits() public {
        address dirtySigner = address(uint160(eoaSigner) | (1 << 160));
        bool result = dirtySigner.isValidSignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidSignatureNowRVS() public {
        bool result = eoaSigner.isValidSignatureNow(hash, r, vs);
        assertTrue(result, "Valid EOA signature should return true");

        result = eoaSigner.isValidSignatureNow(hash, r, vs);
        assertFalse(result, "Invalid EOA signature should return false");
    }

    function testIsValidSignatureNowRVSContract() public {
        bool result = contractSigner.isValidSignatureNow(hash, r, vs);
        assertTrue(result, "Valid contract signature should return true");

        result = contractSigner.isValidSignatureNow(hash, r, vs);
        assertFalse(result, "Invalid contract signature should return false");
    }

    function testIsValidSignatureNowRVSDirtyUpperBits() public {
        address dirtySigner = address(uint160(eoaSigner) | (1 << 160));
        bool result = dirtySigner.isValidSignatureNow(hash, r, vs);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidSignatureNowVRS() public {
        bool result = eoaSigner.isValidSignatureNow(hash, v, r, s);
        assertTrue(result, "Valid EOA signature should return true");

        result = eoaSigner.isValidSignatureNow(hash, v, r, s);
        assertFalse(result, "Invalid EOA signature should return false");
    }

    function testIsValidSignatureNowVRSContract() public {
        bool result = contractSigner.isValidSignatureNow(hash, v, r, s);
        assertTrue(result, "Valid contract signature should return true");

        result = contractSigner.isValidSignatureNow(hash, v, r, s);
        assertFalse(result, "Invalid contract signature should return false");
    }

    function testIsValidSignatureNowVRSDirtyUpperBits() public {
        address dirtySigner = address(uint160(eoaSigner) | (1 << 160));
        bool result = dirtySigner.isValidSignatureNow(hash, v, r, s);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidERC1271SignatureNow() public {
        bool result = contractSigner.isValidERC1271SignatureNow(hash, validSignature);
        assertTrue(result, "Valid ERC1271 signature should return true");

        result = contractSigner.isValidERC1271SignatureNow(hash, invalidSignature);
        assertFalse(result, "Invalid ERC1271 signature should return false");
    }

    function testIsValidERC1271SignatureNowDirtyUpperBits() public {
        address dirtySigner = address(uint160(contractSigner) | (1 << 160));
        bool result = dirtySigner.isValidERC1271SignatureNow(hash, validSignature);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidERC1271SignatureNowCalldata() public {
        bool result = contractSigner.isValidERC1271SignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Valid ERC1271 signature should return true");

        result = contractSigner.isValidERC1271SignatureNowCalldata(hash, invalidSignature);
        assertFalse(result, "Invalid ERC1271 signature should return false");
    }

    function testIsValidERC1271SignatureNowCalldataDirtyUpperBits() public {
        address dirtySigner = address(uint160(contractSigner) | (1 << 160));
        bool result = dirtySigner.isValidERC1271SignatureNowCalldata(hash, validSignature);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidERC1271SignatureNowRVS() public {
        bool result = contractSigner.isValidERC1271SignatureNow(hash, r, vs);
        assertTrue(result, "Valid ERC1271 signature should return true");

        result = contractSigner.isValidERC1271SignatureNow(hash, r, vs);
        assertFalse(result, "Invalid ERC1271 signature should return false");
    }

    function testIsValidERC1271SignatureNowRVSDirtyUpperBits() public {
        address dirtySigner = address(uint160(contractSigner) | (1 << 160));
        bool result = dirtySigner.isValidERC1271SignatureNow(hash, r, vs);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testIsValidERC1271SignatureNowVRS() public {
        bool result = contractSigner.isValidERC1271SignatureNow(hash, v, r, s);
        assertTrue(result, "Valid ERC1271 signature should return true");

        result = contractSigner.isValidERC1271SignatureNow(hash, v, r, s);
        assertFalse(result, "Invalid ERC1271 signature should return false");
    }

    function testIsValidERC1271SignatureNowVRSDirtyUpperBits() public {
        address dirtySigner = address(uint160(contractSigner) | (1 << 160));
        bool result = dirtySigner.isValidERC1271SignatureNow(hash, v, r, s);
        assertTrue(result, "Dirty upper bits in signer address should be handled correctly");
    }

    function testToEthSignedMessageHashBytes32() public {
        bytes32 expected = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(hash);
        assertEq(result, expected, "Hash calculation should be correct");
    }

    function testToEthSignedMessageHashBytes() public {
        bytes memory message = "test message";
        bytes32 expected = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n12", message));
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(message);
        assertEq(result, expected, "Hash calculation should be correct");
    }

    function testToEthSignedMessageHashBytesMaxLength() public {
        bytes memory message = new bytes(999999);
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(message);
        assertTrue(result != bytes32(0), "Hash calculation should handle maximum length");
    }

    function testEmptySignature() public {
        bytes calldata result = SignatureCheckerLib.emptySignature();
        assertEq(result.length, 0, "Empty signature should return empty calldata bytes");
    }
}