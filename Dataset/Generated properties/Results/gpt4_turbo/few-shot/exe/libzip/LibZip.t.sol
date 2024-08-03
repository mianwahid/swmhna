// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {


    /// @dev Test compression and decompression of FastLZ algorithm
    function testFastLZCompressionDecompression() public {
        bytes memory originalData = "Hello, Solidity!";
        bytes memory compressedData = LibZip.flzCompress(originalData);
        bytes memory decompressedData = LibZip.flzDecompress(compressedData);

        assertEq(decompressedData, originalData, "Decompressed data does not match original");
    }

    /// @dev Test compression and decompression of calldata operations
    function testCalldataCompressionDecompression() public {
        bytes memory originalData = "Hello, Calldata Compression!";
        bytes memory compressedData = LibZip.cdCompress(originalData);
        bytes memory decompressedData = LibZip.cdDecompress(compressedData);

        assertEq(decompressedData, originalData, "Decompressed calldata does not match original");
    }

    /// @dev Fuzz test for FastLZ compression and decompression
    function testFuzzFastLZCompressionDecompression(bytes memory randomData) public {
        bytes memory compressedData = LibZip.flzCompress(randomData);
        bytes memory decompressedData = LibZip.flzDecompress(compressedData);

        assertEq(decompressedData, randomData, "Decompressed data does not match original for fuzzed input");
    }

    /// @dev Fuzz test for calldata compression and decompression
    function testFuzzCalldataCompressionDecompression(bytes memory randomData) public {
        bytes memory compressedData = LibZip.cdCompress(randomData);
        bytes memory decompressedData = LibZip.cdDecompress(compressedData);

        assertEq(decompressedData, randomData, "Decompressed calldata does not match original for fuzzed input");
    }

    /// @dev Test the cdFallback function to ensure it handles calldata correctly
    function testCDFallback() public {
        bytes memory inputData = "Test input for fallback";
        bytes memory expectedOutput = LibZip.cdDecompress(LibZip.cdCompress(inputData));

        (bool success, bytes memory result) = address(LibZip).call(abi.encodeWithSignature("cdFallback()"));

        assertTrue(success, "Fallback function did not succeed");
        assertEq(result, expectedOutput, "Fallback function output does not match expected output");
    }
}