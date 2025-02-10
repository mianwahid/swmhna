// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
//    LibZip LibZip;

    // Test data for compression and decompression
    bytes constant testInput = "Hello, Solidity!";
    bytes constant testInputLong = "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.";

    function setUp() public {
//        LibZip = new LibZip();
    }

    function testFLZCompressDecompress() public {
        // Compress and then decompress the data
        bytes memory compressed = LibZip.flzCompress(testInput);
        bytes memory decompressed = LibZip.flzDecompress(compressed);

        // Check if the original data is retrieved after decompression
        assertEq(decompressed, testInput);
    }

    function testFLZCompressDecompressLongInput() public {
        // Compress and then decompress the data
        bytes memory compressed = LibZip.flzCompress(testInputLong);
        bytes memory decompressed = LibZip.flzDecompress(compressed);

        // Check if the original data is retrieved after decompression
        assertEq(decompressed, testInputLong);
    }

    function testCDCompressDecompress() public {
        // Compress and then decompress the data
        bytes memory compressed = LibZip.cdCompress(testInput);
        bytes memory decompressed = LibZip.cdDecompress(compressed);

        // Check if the original data is retrieved after decompression
        assertEq(decompressed, testInput);
    }

    function testCDCompressDecompressLongInput() public {
        // Compress and then decompress the data
        bytes memory compressed = LibZip.cdCompress(testInputLong);
        bytes memory decompressed = LibZip.cdDecompress(compressed);

        // Check if the original data is retrieved after decompression
        assertEq(decompressed, testInputLong);
    }

    function testCDFallback() public {
        // Simulate calldata compression and fallback handling
        bytes memory compressed = LibZip.cdCompress(testInput);
        (bool success, bytes memory result) = address(LibZip).call(compressed);

        // Check if the fallback function handled the data correctly
        assertTrue(success);
        assertEq(result, testInput);
    }

    function testFLZCompressionEfficiency() public {
        bytes memory compressed = LibZip.flzCompress(testInputLong);
        assertTrue(compressed.length < testInputLong.length);
    }

    function testCDCompressionEfficiency() public {
        bytes memory compressed = LibZip.cdCompress(testInputLong);
        assertTrue(compressed.length < testInputLong.length);
    }
}