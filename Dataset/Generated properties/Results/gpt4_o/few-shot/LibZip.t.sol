// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    using LibZip for *;

    function testFlzCompressAndDecompress() public {
        bytes memory data = hex"11223344556677889900aabbccddeeff";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testFlzCompressAndDecompressEmpty() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testFlzCompressAndDecompressRandom(bytes memory data) public {
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressAndDecompress() public {
        bytes memory data = hex"11223344556677889900aabbccddeeff";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressAndDecompressEmpty() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressAndDecompressRandom(bytes memory data) public {
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

//    function testCdFallback() public {
//        bytes memory data = hex"11223344556677889900aabbccddeeff";
//        bytes memory compressed = LibZip.cdCompress(data);
//
//        // Simulate a call to the fallback function with compressed data
//        (bool success, bytes memory result) = address(this).call(compressed);
//        require(success, "Fallback call failed");
//
//        // Check if the decompressed data matches the original data
//        assertEq(result, data);
//    }

    fallback() external payable {
        LibZip.cdFallback();
    }

    receive() external payable {}
}