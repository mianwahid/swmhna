// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";

contract SignatureCheckerLibTest is Test {
    address constant signer = address(0x123);
    bytes32 constant hash = keccak256("Hello, world!");
    bytes32 constant r = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
    bytes32 constant s = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;
    uint8 constant v = 27;
    bytes32 constant vs = 0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789;

    function testIsValidSignatureNow() public {
        bytes memory signature = abi.encodePacked(r, s, v);
        bool result = SignatureCheckerLib.isValidSignatureNow(signer, hash, signature);
        assertTrue(result);
    }

//    function testIsValidSignatureNowCalldata() public {
//        bytes memory signature = abi.encodePacked(r, s, v);
//        bool result = SignatureCheckerLib.isValidSignatureNowCalldata(signer, hash, signature);
//        assertTrue(result);
//    }

    function testIsValidSignatureNowWithRSVS() public {
        bool result = SignatureCheckerLib.isValidSignatureNow(signer, hash, r, vs);
        assertTrue(result);
    }

    function testIsValidSignatureNowWithVRS() public {
        bool result = SignatureCheckerLib.isValidSignatureNow(signer, hash, v, r, s);
        assertTrue(result);
    }

    function testIsValidERC1271SignatureNow() public {
        bytes memory signature = abi.encodePacked(r, s, v);
        bool result = SignatureCheckerLib.isValidERC1271SignatureNow(signer, hash, signature);
        assertTrue(result);
    }

//    function testIsValidERC1271SignatureNowCalldata() public {
//        bytes memory signature = abi.encodePacked(r, s, v);
//        bool result = SignatureCheckerLib.isValidERC1271SignatureNowCalldata(signer, hash, signature);
//        assertTrue(result);
//    }

    function testIsValidERC1271SignatureNowWithRSVS() public {
        bool result = SignatureCheckerLib.isValidERC1271SignatureNow(signer, hash, r, vs);
        assertTrue(result);
    }

    function testIsValidERC1271SignatureNowWithVRS() public {
        bool result = SignatureCheckerLib.isValidERC1271SignatureNow(signer, hash, v, r, s);
        assertTrue(result);
    }

    function testToEthSignedMessageHash() public {
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(hash);
        assertEq(result, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)));
    }

    function testToEthSignedMessageHashWithBytes() public {
        bytes memory data = "Hello, world!";
        bytes32 result = SignatureCheckerLib.toEthSignedMessageHash(data);
        assertEq(result, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", uint2str(data.length), data)));
    }

    function testEmptySignature() public {
        bytes memory signature = SignatureCheckerLib.emptySignature();
        assertEq(signature.length, 0);
    }

    // Helper function to convert uint to string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}