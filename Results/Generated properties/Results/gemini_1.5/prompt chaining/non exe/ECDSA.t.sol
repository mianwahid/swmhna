// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/ECDSA.sol";

contract ECDSATest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    bytes32 internal constant TEST_MESSAGE_HASH =
        keccak256("This is a test message.");
    bytes32 internal constant MALLEABLE_SIGNATURE_S =
        0x768481a3410a0d77775e755d3018b7414774209db918ec1b06363eeac7184ee7;
    bytes32 internal constant INVALID_SIGNATURE_HIGH_S =
        0xd797d10a0d77775e755d3018b7414774209db918ec1b06363eeac7184ee77685;
    bytes internal constant TEST_MESSAGE = "This is a test message.";

    address internal constant SIGNER =
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          TEST HELPERS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _signMessage(bytes32 messageHash)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        (v, r, s) = vm.sign(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            messageHash
        );
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           UNIT TESTS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testRecoverFromValidSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, v, r, s);
        assertEq(recovered, SIGNER);
    }

    function testRecoverFromValidShortSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes32 vs = bytes32(uint256(s) * 2 + (v == 27 ? 0 : 1));
        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, r, vs);
        assertEq(recovered, SIGNER);
    }

    function testRecoverFromValidSignatureBytes() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes memory signature = abi.encodePacked(r, s, v);
        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, signature);
        assertEq(recovered, SIGNER);
    }

    function testRecoverFromValidShortSignatureBytes() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes32 vs = bytes32(uint256(s) * 2 + (v == 27 ? 0 : 1));
        bytes memory signature = abi.encodePacked(r, vs);
        address recovered = ECDSA.recover(TEST_MESSAGE_HASH, signature);
        assertEq(recovered, SIGNER);
    }

    function testRecoverCalldataFromValidSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes memory signature = abi.encodePacked(r, s, v);
        address recovered = ECDSA.recoverCalldata(
            TEST_MESSAGE_HASH,
            signature
        );
        assertEq(recovered, SIGNER);
    }

    function testRecoverCalldataFromValidShortSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes32 vs = bytes32(uint256(s) * 2 + (v == 27 ? 0 : 1));
        bytes memory signature = abi.encodePacked(r, vs);
        address recovered = ECDSA.recoverCalldata(
            TEST_MESSAGE_HASH,
            signature
        );
        assertEq(recovered, SIGNER);
    }

    function testTryRecoverFromValidSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, v, r, s);
        assertEq(recovered, SIGNER);
    }

    function testTryRecoverFromValidShortSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes32 vs = bytes32(uint256(s) * 2 + (v == 27 ? 0 : 1));
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, r, vs);
        assertEq(recovered, SIGNER);
    }

    function testTryRecoverFromValidSignatureBytes() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes memory signature = abi.encodePacked(r, s, v);
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, signature);
        assertEq(recovered, SIGNER);
    }

    function testTryRecoverFromValidShortSignatureBytes() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes32 vs = bytes32(uint256(s) * 2 + (v == 27 ? 0 : 1));
        bytes memory signature = abi.encodePacked(r, vs);
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, signature);
        assertEq(recovered, SIGNER);
    }

    function testTryRecoverCalldataFromValidSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes memory signature = abi.encodePacked(r, s, v);
        address recovered = ECDSA.tryRecoverCalldata(
            TEST_MESSAGE_HASH,
            signature
        );
        assertEq(recovered, SIGNER);
    }

    function testTryRecoverCalldataFromValidShortSignature() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(TEST_MESSAGE_HASH);
        bytes32 vs = bytes32(uint256(s) * 2 + (v == 27 ? 0 : 1));
        bytes memory signature = abi.encodePacked(r, vs);
        address recovered = ECDSA.tryRecoverCalldata(
            TEST_MESSAGE_HASH,
            signature
        );
        assertEq(recovered, SIGNER);
    }

    function testFailRecoverFromZeroHash() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(bytes32(0));
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(bytes32(0), v, r, s);
    }

    function testFailRecoverFromEmptySignature() public {
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_MESSAGE_HASH, "");
    }

    function testFailRecoverFromInvalidSignatureLength() public {
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(TEST_MESSAGE_HASH, "123");
    }

    function testFailRecoverFromInvalidSignatureHighS() public {
        (uint8 v, bytes32 r, ) = _signMessage(TEST_MESSAGE_HASH);
        vm.expectRevert(ECDSA.InvalidSignature.selector);
        ECDSA.recover(
            TEST_MESSAGE_HASH,
            v,
            r,
            INVALID_SIGNATURE_HIGH_S
        );
    }

    function testFailTryRecoverFromZeroHash() public {
        (uint8 v, bytes32 r, bytes32 s) = _signMessage(bytes32(0));
        address recovered = ECDSA.tryRecover(bytes32(0), v, r, s);
        assertEq(recovered, address(0));
    }

    function testFailTryRecoverFromEmptySignature() public {
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, "");
        assertEq(recovered, address(0));
    }

    function testFailTryRecoverFromInvalidSignatureLength() public {
        address recovered = ECDSA.tryRecover(TEST_MESSAGE_HASH, "123");
        assertEq(recovered, address(0));
    }

    function testFailTryRecoverFromInvalidSignatureHighS() public {
        (uint8 v, bytes32 r, ) = _signMessage(TEST_MESSAGE_HASH);
        address recovered = ECDSA.tryRecover(
            TEST_MESSAGE_HASH,
            v,
            r,
            INVALID_SIGNATURE_HIGH_S
        );
        assertEq(recovered, address(0));
    }

    function testToEthSignedMessageHash() public {
        bytes32 messageHash = keccak256(TEST_MESSAGE);
        bytes32 expectedEthSignedMessageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                messageHash
            )
        );
        assertEq(
            ECDSA.toEthSignedMessageHash(messageHash),
            expectedEthSignedMessageHash
        );
    }

    function testToEthSignedMessageHashFromBytes() public {
        bytes32 expectedEthSignedMessageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n",
                "19",
                "This is a test message."
            )
        );
        assertEq(
            ECDSA.toEthSignedMessageHash(TEST_MESSAGE),
            expectedEthSignedMessageHash
        );
    }

    function testEmptySignature() public {
        bytes calldata signature = ECDSA.emptySignature();
        assertEq(signature.length, 0);
    }
}