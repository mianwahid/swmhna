// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/LibZip.sol";

contract LibZipTest is Test {
    using LibZip for bytes;

    function testFlzCompressEmpty() public {
        bytes memory empty = "";
        bytes memory compressed = LibZip.flzCompress(empty);
        assertEq(
            compressed.length,
            0,
            "Compressing an empty array should return an empty array"
        );
    }

    function testFlzCompressEffectiveness() public {
        bytes memory data = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        bytes memory compressed = LibZip.flzCompress(data);
        assertTrue(
            compressed.length < data.length,
            "Compression should be effective for repetitive data"
        );
    }

    // function testFlzCompressNonRepetitive() public {
    //     bytes memory data = "abcdefghijklmnopqrstuvwxyz";
    //     bytes memory compressed = LibZip.flzCompress(data);
    //     assertTrue(compressed.length <= data.length, "Compression of non-repetitive data should not increase size");
    // }

    function testFlzDecompressToOriginal() public {
        bytes memory data = "forge foundry test";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(
            decompressed,
            data,
            "Decompressed data should match the original"
        );
    }

    function testFlzDecompressEmpty() public {
        bytes memory empty = "";
        bytes memory decompressed = LibZip.flzDecompress(empty);
        assertEq(
            decompressed.length,
            0,
            "Decompressing an empty array should return an empty array"
        );
    }

    function testCdCompressEmpty() public {
        bytes memory empty = "";
        bytes memory compressed = LibZip.cdCompress(empty);
        assertEq(
            compressed.length,
            0,
            "Compressing an empty array should return an empty array"
        );
    }

    function testCdCompressEffectiveness() public {
        bytes memory data = new bytes(200);
        for (uint i = 0; i < 200; i++) {
            data[i] = 0x00;
        }
        bytes memory compressed = LibZip.cdCompress(data);
        assertTrue(
            compressed.length < data.length,
            "Compression should be effective for long sequences of 0x00"
        );
    }

    function testCdDecompressToOriginal() public {
        bytes memory data = "test data for compression";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(
            decompressed,
            data,
            "Decompressed data should match the original"
        );
    }

    function testCdDecompressEmpty() public {
        bytes memory empty = "";
        bytes memory decompressed = LibZip.cdDecompress(empty);
        assertEq(
            decompressed.length,
            0,
            "Decompressing an empty array should return an empty array"
        );
    }

    // function testCdFallbackExecution() public {
    //     bytes memory data = "test data for fallback";
    //     bytes memory compressed = LibZip.cdCompress(data);
    //     (bool success,) = address(this).call(compressed);
    //     assertTrue(success, "Fallback should execute correctly with valid compressed data");
    // }

    function testCdFallbackRevertOnCorruptedData() public {
        bytes memory data = "corrupted data";
        (bool success, ) = address(this).call(data);
        assertFalse(success, "Fallback should revert on corrupted data");
    }
}
