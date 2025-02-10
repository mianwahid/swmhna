// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    using SignatureCheckerLib for address;

    address signer;
    bytes32 hash;
    bytes  signature;
    bytes32 r;
    bytes32 vs;
    uint8 v;
    bytes32 s;

    function setUp() public {
        signer = address(0x1234567890123456789012345678901234567890);
        hash = keccak256("test message");
        // Generate valid and invalid signatures for testing
        (v, r, s) = vm.sign(uint256(uint160(signer)), hash);
        signature = abi.encodePacked(r, s, v);
        vs = bytes32(uint256(s) << 1 | uint256(v - 27));
    }

    // 1. isValidSignatureNow(address signer, bytes32 hash, bytes memory signature)
    function testValidECDSASignature() public {
        assertTrue(signer.isValidSignatureNow(hash, signature));
    }

    function testInvalidECDSASignature() public {
        bytes memory invalidSignature = abi.encodePacked(r, s, v + 1);
        assertFalse(signer.isValidSignatureNow(hash, invalidSignature));
    }

    function testValidEIP2098Signature() public {
        bytes memory eip2098Signature = abi.encodePacked(r, vs);
        assertTrue(signer.isValidSignatureNow(hash, eip2098Signature));
    }

    function testInvalidEIP2098Signature() public {
        bytes memory invalidEIP2098Signature = abi.encodePacked(r, bytes32(uint256(vs) + 1));
        assertFalse(signer.isValidSignatureNow(hash, invalidEIP2098Signature));
    }

    function testValidERC1271Signature() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271Signature() public {
        // Mock ERC1271 contract and test
    }

    function testSignatureWithIncorrectLength() public {
        bytes memory incorrectLengthSignature = abi.encodePacked(r, s);
        assertFalse(signer.isValidSignatureNow(hash, incorrectLengthSignature));
    }

    function testSignatureWithDirtyUpper96Bits() public {
        address dirtySigner = address(uint160(signer) | (1 << 160));
        assertTrue(dirtySigner.isValidSignatureNow(hash, signature));
    }

    // 2. isValidSignatureNowCalldata(address signer, bytes32 hash, bytes calldata signature)
    function testValidECDSASignatureCalldata() public {
        assertTrue(signer.isValidSignatureNowCalldata(hash, signature));
    }

    function testInvalidECDSASignatureCalldata() public {
        bytes memory invalidSignature = abi.encodePacked(r, s, v + 1);
        assertFalse(signer.isValidSignatureNowCalldata(hash, invalidSignature));
    }

    function testValidEIP2098SignatureCalldata() public {
        bytes memory eip2098Signature = abi.encodePacked(r, vs);
        assertTrue(signer.isValidSignatureNowCalldata(hash, eip2098Signature));
    }

    function testInvalidEIP2098SignatureCalldata() public {
        bytes memory invalidEIP2098Signature = abi.encodePacked(r, bytes32(uint256(vs) + 1));
        assertFalse(signer.isValidSignatureNowCalldata(hash, invalidEIP2098Signature));
    }

    function testValidERC1271SignatureCalldata() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureCalldata() public {
        // Mock ERC1271 contract and test
    }

    function testSignatureWithIncorrectLengthCalldata() public {
        bytes memory incorrectLengthSignature = abi.encodePacked(r, s);
        assertFalse(signer.isValidSignatureNowCalldata(hash, incorrectLengthSignature));
    }

    function testSignatureWithDirtyUpper96BitsCalldata() public {
        address dirtySigner = address(uint160(signer) | (1 << 160));
        assertTrue(dirtySigner.isValidSignatureNowCalldata(hash, signature));
    }

    // 3. isValidSignatureNow(address signer, bytes32 hash, bytes32 r, bytes32 vs)
    function testValidEIP2098SignatureRVS() public {
        assertTrue(signer.isValidSignatureNow(hash, r, vs));
    }

    function testInvalidEIP2098SignatureRVS() public {
        assertFalse(signer.isValidSignatureNow(hash, r, bytes32(uint256(vs) + 1)));
    }

    function testValidERC1271SignatureRVS() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureRVS() public {
        // Mock ERC1271 contract and test
    }

    function testSignatureWithDirtyUpper96BitsRVS() public {
        address dirtySigner = address(uint160(signer) | (1 << 160));
        assertTrue(dirtySigner.isValidSignatureNow(hash, r, vs));
    }

    // 4. isValidSignatureNow(address signer, bytes32 hash, uint8 v, bytes32 r, bytes32 s)
    function testValidECDSASignatureVRS() public {
        assertTrue(signer.isValidSignatureNow(hash, v, r, s));
    }

    function testInvalidECDSASignatureVRS() public {
        assertFalse(signer.isValidSignatureNow(hash, v + 1, r, s));
    }

    function testValidERC1271SignatureVRS() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureVRS() public {
        // Mock ERC1271 contract and test
    }

    function testSignatureWithDirtyUpper96BitsVRS() public {
        address dirtySigner = address(uint160(signer) | (1 << 160));
        assertTrue(dirtySigner.isValidSignatureNow(hash, v, r, s));
    }

    // 5. isValidERC1271SignatureNow(address signer, bytes32 hash, bytes memory signature)
    function testValidERC1271SignatureNow() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureNow() public {
        // Mock ERC1271 contract and test
    }

    function testERC1271SignatureWithIncorrectLength() public {
        bytes memory incorrectLengthSignature = abi.encodePacked(r, s);
        assertFalse(signer.isValidERC1271SignatureNow(hash, incorrectLengthSignature));
    }

    // 6. isValidERC1271SignatureNowCalldata(address signer, bytes32 hash, bytes calldata signature)
    function testValidERC1271SignatureNowCalldata() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureNowCalldata() public {
        // Mock ERC1271 contract and test
    }

    function testERC1271SignatureWithIncorrectLengthCalldata() public {
        bytes memory incorrectLengthSignature = abi.encodePacked(r, s);
        assertFalse(signer.isValidERC1271SignatureNowCalldata(hash, incorrectLengthSignature));
    }

    // 7. isValidERC1271SignatureNow(address signer, bytes32 hash, bytes32 r, bytes32 vs)
    function testValidERC1271SignatureNowRVS() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureNowRVS() public {
        // Mock ERC1271 contract and test
    }

    // 8. isValidERC1271SignatureNow(address signer, bytes32 hash, uint8 v, bytes32 r, bytes32 s)
    function testValidERC1271SignatureNowVRS() public {
        // Mock ERC1271 contract and test
    }

    function testInvalidERC1271SignatureNowVRS() public {
        // Mock ERC1271 contract and test
    }

    // 9. toEthSignedMessageHash(bytes32 hash)
    function testToEthSignedMessageHash() public {
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        assertEq(SignatureCheckerLib.toEthSignedMessageHash(hash), expectedHash);
    }

    // 10. toEthSignedMessageHash(bytes memory s)
    function testToEthSignedMessageHashBytes() public {
        bytes memory message = "test message";
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n12", message));
        assertEq(SignatureCheckerLib.toEthSignedMessageHash(message), expectedHash);
    }

    function testToEthSignedMessageHashBytesLength() public {
        bytes memory message = new bytes(999999);
        bytes32 expectedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n999999", message));
        assertEq(SignatureCheckerLib.toEthSignedMessageHash(message), expectedHash);
    }

    function testToEthSignedMessageHashBytesHeaderLength() public {
        bytes memory message = new bytes(1000000);
        vm.expectRevert();
        SignatureCheckerLib.toEthSignedMessageHash(message);
    }

    // 11. emptySignature()
    function testEmptySignature() public {
        bytes memory emptySig = SignatureCheckerLib.emptySignature();
        assertEq(emptySig.length, 0);
    }
}