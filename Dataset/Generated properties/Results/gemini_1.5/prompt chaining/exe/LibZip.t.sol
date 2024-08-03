// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";
contract LibZipTest is Test {

    function testIdempotencyFLZ() public {
        bytes memory data = "This is a test string for FastLZ compression.";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(decompressed, data, "FastLZ idempotency failed");
    }

    function testIdempotencyCD() public {
        bytes memory data = "This is a test string for calldata compression.";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(decompressed, data, "Calldata idempotency failed");
    }

    function testEmptyInputFLZ() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.flzCompress(data);
        assertEq(compressed.length, 0, "FastLZ empty input compression failed");
    }

    function testEmptyInputCD() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.cdCompress(data);
        assertEq(compressed.length, 0, "Calldata empty input compression failed");
    }

    function testZeroLengthFLZ() public {
        bytes memory data = "This is a test string.This is a test string.This is a test string.This is a test string.";
        bytes memory compressed = LibZip.flzCompress(data);
        assertLe(compressed.length, data.length, "FastLZ zero length invariant failed");
    }

    function testZeroLengthCD() public {
        bytes memory data = "This is a test string.";
        bytes memory compressed = LibZip.cdCompress(data);
        assertLe(compressed.length, data.length, "Calldata zero length invariant failed");
    }

    function testShortDataFLZ() public {
        bytes memory data = "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTest";
        bytes memory compressed = LibZip.flzCompress(data);
        assertLe(compressed.length, data.length, "FastLZ short data compression failed");
    }

    function testRepetitivePatternsFLZ() public {
        bytes memory data = "AAAAABBBBBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        bytes memory compressed = LibZip.flzCompress(data);
        assertLe(compressed.length, data.length, "FastLZ repetitive patterns compression failed");
    }

//    function testRandomDataFLZ() public view {
//        bytes memory data = abi.encodePacked(blockhash(block.number - 1));
//        bytes memory compressed = LibZip.flzCompress(data);
//        assertLe(compressed.length, data.length, "FastLZ random data compression failed");
//    }

    function testLargeDataFLZ() public {
        string memory baseString = "This is a test string that will be repeated many times. ";
        bytes memory data;
        for (uint256 i = 0; i < 1000; i++) {
            data = abi.encodePacked(data, baseString);
        }
        bytes memory compressed = LibZip.flzCompress(data);
        assertLe(compressed.length, data.length, "FastLZ large data compression failed");
    }

    function testZeroByteRunsCD() public {
        bytes memory data = hex"0000000000000000000000000000000000000000000000000000000000000000";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(decompressed, data, "Calldata zero byte runs compression failed");
    }

    function test0xFFByteRunsCD() public {
        bytes memory data = hex"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(decompressed, data, "Calldata 0xFF byte runs compression failed");
    }

    function testMixedDataCD() public {
        bytes memory data = hex"000102030405060708090a0b0c0d0e0ff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(decompressed, data, "Calldata mixed data compression failed");
    }

    function testFirst4BytesNegationCD() public {
        bytes memory data = hex"1234567890abcdef";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes4 expectedNegatedBytes = bytes4(~bytes4(data));
        bytes4 actualNegatedBytes = bytes4(compressed);
        assertEq(actualNegatedBytes, expectedNegatedBytes, "Calldata first 4 bytes negation failed");
    }

    function testMaxValuesCD() public {
        bytes memory data = hex"0000000000000000000000000000000000000000000000000000000000000080ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(decompressed, data, "Calldata max values compression failed");
    }

    function testBoundaryConditionsCD() public {
        bytes memory data = hex"000000000000000000000000000000000000000000000000000000000000007f0000000000000000000000000000000000000000000000000000000000000080ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(decompressed, data, "Calldata boundary conditions compression failed");
    }
}
