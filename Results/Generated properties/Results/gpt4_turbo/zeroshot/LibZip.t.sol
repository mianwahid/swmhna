// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/LibZip.sol";

contract LibZipTest is Test {
    /// @dev Test compression and decompression of empty bytes.
    function testEmptyBytesCompressionDecompression() public {
        bytes memory empty = "";
        bytes memory compressed = LibZip.flzCompress(empty);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(
            decompressed,
            empty,
            "Decompressed data should match original empty data"
        );
    }

    /// @dev Test compression and decompression of random bytes.
    function testRandomBytesCompressionDecompression() public {
        bytes memory randomBytes = "Random data to compress and decompress";
        bytes memory compressed = LibZip.flzCompress(randomBytes);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(
            decompressed,
            randomBytes,
            "Decompressed data should match original random data"
        );
    }

    /// @dev Test edge case with maximum size input for compression.
    function testMaxSizeInputCompression() public {
        bytes memory largeData = new bytes(2 ** 16 - 1); // Maximum size that can be handled
        for (uint256 i = 0; i < largeData.length; i++) {
            largeData[i] = bytes1(uint8(i % 256));
        }
        bytes memory compressed = LibZip.flzCompress(largeData);
        assertTrue(
            compressed.length < largeData.length,
            "Compressed data should be smaller than input"
        );
    }

    /// @dev Test calldata compression and decompression with typical data.
    function testCalldataCompressionDecompression() public {
        bytes memory typicalData = "Typical calldata compression test";
        bytes memory compressed = LibZip.cdCompress(typicalData);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(
            decompressed,
            typicalData,
            "Decompressed data should match original typical data"
        );
    }

    /// @dev Test calldata compression with edge cases of repeated characters.
    function testCalldataCompressionRepeatedChars() public {
        bytes memory repeatedZeros = new bytes(128);
        bytes memory repeatedFFs = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            repeatedFFs[i] = bytes1(0xFF);
        }
        bytes memory compressedZeros = LibZip.cdCompress(repeatedZeros);
        bytes memory compressedFFs = LibZip.cdCompress(repeatedFFs);
        bytes memory decompressedZeros = LibZip.cdDecompress(compressedZeros);
        bytes memory decompressedFFs = LibZip.cdDecompress(compressedFFs);
        assertEq(
            decompressedZeros,
            repeatedZeros,
            "Decompressed zeros should match original zeros"
        );
        assertEq(
            decompressedFFs,
            repeatedFFs,
            "Decompressed FFs should match original FFs"
        );
    }

    // /// @dev Test fallback function behavior with compressed calldata.
    // function testFallbackFunctionWithCompressedCalldata() public {
    //     bytes memory data = "Data to test fallback function";
    //     bytes memory compressed = LibZip.cdCompress(data);
    //     (bool success,) = address(LibZip).call(compressed);
    //     assertTrue(success, "Fallback function should handle compressed calldata successfully");
    // }
}
