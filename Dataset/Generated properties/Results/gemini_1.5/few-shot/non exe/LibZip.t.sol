// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    function _generateBytes(uint256 length) internal pure returns (bytes memory result) {
        result = new bytes(length);
        for (uint256 i; i < length; ++i) {
            result[i] = bytes1(uint8(i));
        }
    }

    function _assertEqualBytes(bytes memory a, bytes memory b) internal {
        assertEq(a.length, b.length, "Lengths mismatch");
        for (uint256 i; i < a.length; ++i) {
            assertEq(a[i], b[i], "Bytes mismatch");
        }
    }

    function testFLZCompressDecompress(uint256 length) public {
        bytes memory data = _generateBytes(length);
        _assertEqualBytes(data, LibZip.flzDecompress(LibZip.flzCompress(data)));
    }

    function testFLZCompressDecompress() public {
        bytes memory data =
            hex"00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff";
        bytes memory compressed =
            hex"2c04112233445566778899aabbccddeeff00112233445566778899aabbccddeeff0f100000112233445566778899aabbccddeeff00";
        _assertEqualBytes(compressed, LibZip.flzCompress(data));
        _assertEqualBytes(data, LibZip.flzDecompress(compressed));
    }

//    function testFLZDecompressOutOfBounds(bytes calldata data) public {
//        bytes memory decompressed = LibZip.flzDecompress(data);
//        // Try to access the out of bounds element.
//        // It should revert.
//        assembly {
//            mload(add(decompressed, add(0x20, mload(decompressed))))
//        }
//    }

    function testCDCompressDecompress() public {
        uint256 length=100000;
        bytes memory data = _generateBytes(length);
        _assertEqualBytes(data, LibZip.cdDecompress(LibZip.cdCompress(data)));
    }
//
//    function testCDCompressDecompress() public {
//        bytes memory data =
//            hex"000000000000000000000000000000000000000000000000000000000000000123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdefffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000";
//        bytes memory compressed =
//            hex"fffffff3008123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0021fffffff40080";
//        _assertEqualBytes(compressed, LibZip.cdCompress(data));
//        _assertEqualBytes(data, LibZip.cdDecompress(compressed));
//    }
//
//    function testCDCompressDecompressEmpty() public {
//        bytes memory data = "";
//        _assertEqualBytes(data, LibZip.cdDecompress(LibZip.cdCompress(data)));
//    }
//
//    function testCDFallback(bytes calldata data) public {
//        vm.assume(data.length < 256);
//        bytes memory compressed = LibZip.cdCompress(data);
//        bytes memory decompressed;
//        assembly {
//            let size := mload(compressed)
//            calldatacopy(0, 0, size)
//            mstore(sub(compressed, 0x20), size)
//            let success := call(gas(), address(), 0, 0, size, 0, 0)
//            if iszero(success) {
//                returndatacopy(0, 0, returndatasize())
//                revert(0, returndatasize())
//            }
//            size := returndatasize()
//            decompressed := mload(0x40)
//            mstore(0x40, add(decompressed, add(0x20, size)))
//            mstore(decompressed, size)
//            returndatacopy(add(decompressed, 0x20), 0, size)
//        }
//        _assertEqualBytes(data, decompressed);
//    }
}