// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SignatureCheckerLib.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract SignatureCheckerLibTest is Test {
    address internal alice = address(0x1337);
    address internal bob = address(0x1338);

//    function testIsValidSignatureNow(
//        bytes32 hash,
//        uint8 v,
//        bytes32 r,
//        bytes32 s
//    ) public {
//        bytes memory signature = abi.encodePacked(r, s, v);
//        address signer = ECDSA.recover(hash, signature);
//        assertEq(
//            SignatureCheckerLib.isValidSignatureNow(signer, hash, signature),
//            true
//        );
//    }

//    function testIsValidSignatureNowCalldata(
//        bytes32 hash,
//        uint8 v,
//        bytes32 r,
//        bytes32 s
//    ) public {
//        bytes memory signature = abi.encodePacked(r, s, v);
//        address signer = ECDSA.recover(hash, signature);
//        assertEq(
//            SignatureCheckerLib.isValidSignatureNowCalldata(
//                signer,
//                hash,
//                signature
//            ),
//            true
//        );
//    }

//    function testIsValidSignatureNowShort(
//        bytes32 hash,
//        uint8 v,
//        bytes32 r,
//        bytes32 s
//    ) public {
//        bytes32 vs = bytes32(uint256(v) + 27) << 255 | s;
//        bytes memory signature = abi.encodePacked(r, vs);
//        address signer = ECDSA.recover(hash, signature);
//        assertEq(
//            SignatureCheckerLib.isValidSignatureNow(signer, hash, r, vs),
//            true
//        );
//    }

//    function testIsValidSignatureNowVRS(
//        bytes32 hash,
//        uint8 v,
//        bytes32 r,
//        bytes32 s
//    ) public {
//        bytes memory signature = abi.encodePacked(r, s, v);
//        address signer = ECDSA.recover(hash, signature);
//        assertEq(
//            SignatureCheckerLib.isValidSignatureNow(signer, hash, v, r, s),
//            true
//        );
//    }

    function testToEthSignedMessageHash(bytes32 hash)
        public
        view
        returns (bytes32)
    {
        return SignatureCheckerLib.toEthSignedMessageHash(hash);
    }

    function testToEthSignedMessageHash(string memory message)
        public
        view
        returns (bytes32)
    {
        return SignatureCheckerLib.toEthSignedMessageHash(bytes(message));
    }
}