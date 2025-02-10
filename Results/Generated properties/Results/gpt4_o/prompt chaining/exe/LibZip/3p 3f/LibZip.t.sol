// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    using LibZip for bytes;

    function testFlzCompressDecompressConsistency() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = "aaaaaa";
        testData[3] = "abababab";
        testData[4] = hex"00112233445566778899aabbccddeeff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = testData[i];
            bytes memory compressed = LibZip.flzCompress(data);
            bytes memory decompressed = LibZip.flzDecompress(compressed);
            assertEq(decompressed, data, "Decompressed data does not match original");
        }
    }

    function testFlzCompressIdempotency() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = "aaaaaa";
        testData[3] = "abababab";
        testData[4] = hex"00112233445566778899aabbccddeeff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = testData[i];
            bytes memory compressedOnce = LibZip.flzCompress(data);
            bytes memory compressedTwice = LibZip.flzCompress(compressedOnce);
            assertEq(compressedTwice, compressedOnce, "Double compression does not match single compression");
        }
    }

    function testFlzDecompressIdempotency() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = "aaaaaa";
        testData[3] = "abababab";
        testData[4] = hex"00112233445566778899aabbccddeeff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = LibZip.flzCompress(testData[i]);
            bytes memory decompressedOnce = LibZip.flzDecompress(data);
            bytes memory decompressedTwice = LibZip.flzDecompress(decompressedOnce);
            assertEq(decompressedTwice, decompressedOnce, "Double decompression does not match single decompression");
        }
    }

    function testFlzCompressReducesSize() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = "aaaaaa";
        testData[3] = "abababab";
        testData[4] = hex"00112233445566778899aabbccddeeff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = testData[i];
            bytes memory compressed = LibZip.flzCompress(data);
            assertLe(compressed.length, data.length, "Compressed data is larger than original");
        }
    }

    function testCdCompressDecompressConsistency() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = hex"000000";
        testData[3] = hex"ffffff";
        testData[4] = hex"00ff00ff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = testData[i];
            bytes memory compressed = LibZip.cdCompress(data);
            bytes memory decompressed = LibZip.cdDecompress(compressed);
            assertEq(decompressed, data, "Decompressed data does not match original");
        }
    }

    function testCdCompressIdempotency() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = hex"000000";
        testData[3] = hex"ffffff";
        testData[4] = hex"00ff00ff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = testData[i];
            bytes memory compressedOnce = LibZip.cdCompress(data);
            bytes memory compressedTwice = LibZip.cdCompress(compressedOnce);
            assertEq(compressedTwice, compressedOnce, "Double compression does not match single compression");
        }
    }

    function testCdDecompressIdempotency() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = hex"000000";
        testData[3] = hex"ffffff";
        testData[4] = hex"00ff00ff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = LibZip.cdCompress(testData[i]);
            bytes memory decompressedOnce = LibZip.cdDecompress(data);
            bytes memory decompressedTwice = LibZip.cdDecompress(decompressedOnce);
            assertEq(decompressedTwice, decompressedOnce, "Double decompression does not match single decompression");
        }
    }

    function testCdCompressReducesSize() public {
        bytes[] memory testData = new bytes[](5);
        testData[0] = "";
        testData[1] = "a";
        testData[2] = hex"000000";
        testData[3] = hex"ffffff";
        testData[4] = hex"00ff00ff";

        for (uint i = 0; i < testData.length; i++) {
            bytes memory data = testData[i];
            bytes memory compressed = LibZip.cdCompress(data);
            assertLe(compressed.length, data.length, "Compressed data is larger than original");
        }
    }

    function testCdFallbackHandlesEmptyCalldata() public {
        bytes memory emptyCalldata = "";
        (bool success, ) = address(this).call(emptyCalldata);
        assertTrue(success, "cdFallback should not revert on empty calldata");
    }

    function testCdFallbackHandlesCompressedCalldata() public {
        bytes memory data = hex"00ff00ff";
        bytes memory compressed = LibZip.cdCompress(data);
        (bool success, ) = address(this).call(compressed);
        assertTrue(success, "cdFallback should handle compressed calldata correctly");
    }

    function testCdFallbackRevertsOnFailure() public {
        bytes memory invalidCalldata = hex"deadbeef";
        (bool success, ) = address(this).call(invalidCalldata);
        assertFalse(success, "cdFallback should revert on invalid calldata");
    }
}