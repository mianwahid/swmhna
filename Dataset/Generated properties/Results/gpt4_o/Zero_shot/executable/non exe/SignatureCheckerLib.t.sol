// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    using SignatureCheckerLib for address;

    address signer;
    bytes32 hash;
    bytes memory signature;
    bytes32 r;
    bytes32 vs;
    uint8 v;
    bytes32 s;

    function setUp() public {
        signer = address(0x1234567890123456789012345678901234567890);
        hash = keccak256(abi.encodePacked("test message"));
        (v, r, s) = vm.sign(uint256(uint160(signer)), hash);
        signature = abi.encodePacked(r, s, v);
        vs = bytes32(uint256(s) << 1 | uint256(v) >> 7);
    }

    function testIsValidSignatureNow() public {
        bool isValid = signer.isValidSignatureNow(hash, signature);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidSignatureNowCalldata() public {
        bool isValid = signer.isValidSignatureNowCalldata(hash, signature);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidSignatureNowShort() public {
        bool isValid = signer.isValidSignatureNow(hash, r, vs);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidSignatureNowFull() public {
        bool isValid = signer.isValidSignatureNow(hash, v, r, s);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidERC1271SignatureNow() public {
        bool isValid = signer.isValidERC1271SignatureNow(hash, signature);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidERC1271SignatureNowCalldata() public {
        bool isValid = signer.isValidERC1271SignatureNowCalldata(hash, signature);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidERC1271SignatureNowShort() public {
        bool isValid = signer.isValidERC1271SignatureNow(hash, r, vs);
        assertTrue(isValid, "Signature should be valid");
    }

    function testIsValidERC1271SignatureNowFull() public {
        bool isValid = signer.isValidERC1271SignatureNow(hash, v, r, s);
        assertTrue(isValid, "Signature should be valid");
    }

    function testToEthSignedMessageHash() public {
        bytes32 ethSignedMessageHash = SignatureCheckerLib.toEthSignedMessageHash(hash);
        assertEq(ethSignedMessageHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)));
    }

    function testToEthSignedMessageHashBytes() public {
        bytes memory message = "test message";
        bytes32 ethSignedMessageHash = SignatureCheckerLib.toEthSignedMessageHash(message);
        assertEq(ethSignedMessageHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n12", message)));
    }

    function testEmptySignature() public {
        bytes calldata emptySig = SignatureCheckerLib.emptySignature();
        assertEq(emptySig.length, 0);
    }

    // Fuzz testing for edge cases
    function testFuzzIsValidSignatureNow(address _signer, bytes32 _hash, bytes memory _signature) public {
        bool isValid = _signer.isValidSignatureNow(_hash, _signature);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidSignatureNowCalldata(address _signer, bytes32 _hash, bytes calldata _signature) public {
        bool isValid = _signer.isValidSignatureNowCalldata(_hash, _signature);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidSignatureNowShort(address _signer, bytes32 _hash, bytes32 _r, bytes32 _vs) public {
        bool isValid = _signer.isValidSignatureNow(_hash, _r, _vs);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidSignatureNowFull(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public {
        bool isValid = _signer.isValidSignatureNow(_hash, _v, _r, _s);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidERC1271SignatureNow(address _signer, bytes32 _hash, bytes memory _signature) public {
        bool isValid = _signer.isValidERC1271SignatureNow(_hash, _signature);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidERC1271SignatureNowCalldata(address _signer, bytes32 _hash, bytes calldata _signature) public {
        bool isValid = _signer.isValidERC1271SignatureNowCalldata(_hash, _signature);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidERC1271SignatureNowShort(address _signer, bytes32 _hash, bytes32 _r, bytes32 _vs) public {
        bool isValid = _signer.isValidERC1271SignatureNow(_hash, _r, _vs);
        // No assertion, just checking for reverts or unexpected behavior
    }

    function testFuzzIsValidERC1271SignatureNowFull(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public {
        bool isValid = _signer.isValidERC1271SignatureNow(_hash, _v, _r, _s);
        // No assertion, just checking for reverts or unexpected behavior
    }
}