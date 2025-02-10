// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    using LibZip for bytes;

    function testFlzCompressAndDecompress() public {
        bytes memory data = hex"1234567890abcdef";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testFlzCompressEmpty() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testFlzCompressLargeData() public {
        bytes memory data = new bytes(1024);
        for (uint i = 0; i < 1024; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testCdCompressAndDecompress() public {
        bytes memory data = hex"1234567890abcdef";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testCdCompressEmpty() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testCdCompressLargeData() public {
        bytes memory data = new bytes(1024);
        for (uint i = 0; i < 1024; i++) {
            data[i] = bytes1(uint8(i % 256));
        }
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testCdCompressWithZeros() public {
        bytes memory data = new bytes(128);
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testCdCompressWithFFs() public {
        bytes memory data = new bytes(32);
        for (uint i = 0; i < 32; i++) {
            data[i] = 0xff;
        }
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

//    function testCdFallback() public {
//        bytes memory data = hex"1234567890abcdef";
//        bytes memory compressed = LibZip.cdCompress(data);
//        (bool success, bytes memory result) = address(this).call(compressed);
//        require(success, "Fallback call failed");
//        bytes memory decompressed = LibZip.cdDecompress(result);
//        assertEq(data, decompressed, "Decompressed data does not match original");
//    }

    function testFuzzFlzCompressAndDecompress(bytes memory data) public {
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }

    function testFuzzCdCompressAndDecompress(bytes memory data) public {
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed, "Decompressed data does not match original");
    }
}