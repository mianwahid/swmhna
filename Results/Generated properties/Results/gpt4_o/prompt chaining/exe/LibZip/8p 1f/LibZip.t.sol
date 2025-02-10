// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    // FastLZ Operations

    // Invariant: Compression and Decompression Consistency
    function testFlzCompressDecompressConsistency() public {
        bytes memory originalData = hex"1234567890abcdef";
        bytes memory compressedData = LibZip.flzCompress(originalData);
        bytes memory decompressedData = LibZip.flzDecompress(compressedData);
        assert(keccak256(originalData) == keccak256(decompressedData));
    }

    // Invariant: Empty Data Compression
    function testFlzCompressDecompressEmptyData() public {
        bytes memory emptyData = "";
        bytes memory compressedData = LibZip.flzCompress(emptyData);
        bytes memory decompressedData = LibZip.flzDecompress(compressedData);
        assert(decompressedData.length == 0);
    }

    // Invariant: Single Byte Data Compression
    function testFlzCompressDecompressSingleByte() public {
        bytes memory singleByteData = hex"01";
        bytes memory compressedData = LibZip.flzCompress(singleByteData);
        bytes memory decompressedData = LibZip.flzDecompress(compressedData);
        assert(keccak256(singleByteData) == keccak256(decompressedData));
    }

    // Invariant: Large Data Compression
//    function testFlzCompressDecompressLargeData() public {
//        bytes memory largeData = new bytes(10000);
//        for (uint i = 0; i < largeData.length; i++) {
//            largeData[i] = byte(uint8(i % 256));
//        }
//        bytes memory compressedData = LibZip.flzCompress(largeData);
//        bytes memory decompressedData = LibZip.flzDecompress(compressedData);
//        assert(keccak256(largeData) == keccak256(decompressedData));
//    }

    // Calldata Operations

    // Invariant: Calldata Compression and Decompression Consistency
    function testCdCompressDecompressConsistency() public {
        bytes memory originalData = hex"1234567890abcdef";
        bytes memory compressedData = LibZip.cdCompress(originalData);
        bytes memory decompressedData = LibZip.cdDecompress(compressedData);
        assert(keccak256(originalData) == keccak256(decompressedData));
    }

    // Invariant: Empty Calldata Compression
    function testCdCompressDecompressEmptyData() public {
        bytes memory emptyData = "";
        bytes memory compressedData = LibZip.cdCompress(emptyData);
        bytes memory decompressedData = LibZip.cdDecompress(compressedData);
        assert(decompressedData.length == 0);
    }

    // Invariant: Single Byte Calldata Compression
    function testCdCompressDecompressSingleByte() public {
        bytes memory singleByteData = hex"01";
        bytes memory compressedData = LibZip.cdCompress(singleByteData);
        bytes memory decompressedData = LibZip.cdDecompress(compressedData);
        assert(keccak256(singleByteData) == keccak256(decompressedData));
    }

    // Invariant: Large Calldata Compression
//    function testCdCompressDecompressLargeData() public {
//        bytes memory largeData = new bytes(10000);
//        for (uint i = 0; i < largeData.length; i++) {
//            largeData[i] = byte(uint8(i % 256));
//        }
//        bytes memory compressedData = LibZip.cdCompress(largeData);
//        bytes memory decompressedData = LibZip.cdDecompress(compressedData);
//        assert(keccak256(largeData) == keccak256(decompressedData));
//    }

    // Invariant: Calldata with Sequences of 0x00 and 0xff
    function testCdCompressDecompressSequences() public {
        bytes memory sequenceData = new bytes(256);
        for (uint i = 0; i < 128; i++) {
            sequenceData[i] = 0x00;
        }
        for (uint i = 128; i < 256; i++) {
            sequenceData[i] = 0xff;
        }
        bytes memory compressedData = LibZip.cdCompress(sequenceData);
        bytes memory decompressedData = LibZip.cdDecompress(compressedData);
        assert(keccak256(sequenceData) == keccak256(decompressedData));
    }

    // Fallback Function

    // Invariant: Fallback Function with Empty Calldata
    function testFallbackEmptyCalldata() public {
        TestContract testContract = new TestContract();
        (bool success, ) = address(testContract).call("");
        assert(success);
    }

    // Invariant: Fallback Function with Compressed Calldata
    function testFallbackCompressedCalldata() public {
        TestContract testContract = new TestContract();
        bytes memory originalData = hex"1234567890abcdef";
        bytes memory compressedData = LibZip.cdCompress(originalData);
        (bool success, bytes memory returnedData) = address(testContract).call(compressedData);
        assert(success);
        assert(keccak256(returnedData) == keccak256(originalData));
    }
}

contract TestContract {
    fallback() external payable {
        LibZip.cdFallback();
    }
}