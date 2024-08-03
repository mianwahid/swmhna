// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    using ECDSA for bytes32;

    address private signer;
    bytes32 private hash;
    bytes private signature;
    bytes32 private r;
    bytes32 private vs;
    uint8 private v;
    bytes32 private s;

    function setUp() public {
        signer = address(0x1234567890123456789012345678901234567890);
        hash = keccak256(abi.encodePacked("test message"));
        (v, r, s) = vm.sign(uint256(uint160(signer)), hash);
        signature = abi.encodePacked(r, s, v);
        vs = bytes32(uint256(s) | (uint256(v - 27) << 255));
    }

    function testRecover() public {
        address recovered = hash.recover(signature);
        assertEq(recovered, signer, "Recovered address does not match signer");
    }

//    function testRecoverCalldata() public {
//        address recovered = hash.recoverCalldata(signature);
//        assertEq(recovered, signer, "Recovered address does not match signer");
//    }

    function testRecoverShortForm() public {
        address recovered = hash.recover(r, vs);
        assertEq(recovered, signer, "Recovered address does not match signer");
    }

    function testRecoverVRS() public {
        address recovered = hash.recover(v, r, s);
        assertEq(recovered, signer, "Recovered address does not match signer");
    }

    function testTryRecover() public {
        address recovered = hash.tryRecover(signature);
        assertEq(recovered, signer, "Recovered address does not match signer");
    }

//    function testTryRecoverCalldata() public {
//        address recovered = hash.tryRecoverCalldata(signature);
//        assertEq(recovered, signer, "Recovered address does not match signer");
//    }

    function testTryRecoverShortForm() public {
        address recovered = hash.tryRecover(r, vs);
        assertEq(recovered, signer, "Recovered address does not match signer");
    }

    function testTryRecoverVRS() public {
        address recovered = hash.tryRecover(v, r, s);
        assertEq(recovered, signer, "Recovered address does not match signer");
    }

    function testInvalidSignatureLength() public {
        bytes memory invalidSignature = new bytes(63);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

//    function testInvalidSignatureLengthCalldata() public {
//        bytes memory invalidSignature = new bytes(63);
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        hash.recoverCalldata(invalidSignature);
//    }

    function testInvalidSignatureValues() public {
        bytes memory invalidSignature = abi.encodePacked(r, s, uint8(28));
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        hash.recover(invalidSignature);
    }

//    function testInvalidSignatureValuesCalldata() public {
//        bytes memory invalidSignature = abi.encodePacked(r, s, uint8(28));
//        vm.expectRevert(ECDSA.InvalidSignature.selector);
//        hash.recoverCalldata(invalidSignature);
//    }

    function testEmptySignature() public {
        bytes memory emptySig = ECDSA.emptySignature();
        assertEq(emptySig.length, 0, "Empty signature length is not zero");
    }

    function testToEthSignedMessageHash() public {
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(hash);
        assertEq(ethSignedHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), "Eth signed message hash mismatch");
    }

    function testToEthSignedMessageHashBytes() public {
        bytes memory message = "test message";
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(message);
        assertEq(ethSignedHash, keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n12", message)), "Eth signed message hash mismatch");
    }

    function testFuzzRecover(bytes32 _hash, bytes memory _signature) public {
        address recovered = _hash.tryRecover(_signature);
        if (_signature.length == 65 || _signature.length == 64) {
            assertTrue(recovered != address(0));
        } else {
            assertEq(recovered, address(0), "Recovered address is not zero for invalid signature length");
        }
    }

    function testFuzzRecoverCalldata(bytes32 _hash, bytes calldata _signature) public {
        address recovered = _hash.tryRecoverCalldata(_signature);
        if (_signature.length == 65 || _signature.length == 64) {
            assertTrue(recovered != address(0));
        } else {
            assertEq(recovered, address(0), "Recovered address is not zero for invalid signature length");
        }
    }
}