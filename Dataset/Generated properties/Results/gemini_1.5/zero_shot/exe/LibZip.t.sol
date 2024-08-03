// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";
contract LibZipTest is Test {

    function testFlzCompressDecompress(bytes calldata data) public {
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testFlzCompressDecompressEmpty() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testFlzCompressDecompressSingleByte() public {
        bytes memory data = hex"01";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testFlzCompressDecompressRepeatingBytes() public {
        bytes memory data = hex"0101010101010101010101010101010101010101010101010101010101010101";
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testFlzCompressDecompressRandomData(bytes calldata data) public {
//        vm.assume(data.length > 100 && data.length < 4096);
        bytes memory compressed = LibZip.flzCompress(data);
        bytes memory decompressed = LibZip.flzDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressDecompress(bytes calldata data) public {
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressDecompressEmpty() public {
        bytes memory data = "";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressDecompressSingleByte() public {
        bytes memory data = hex"01";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressDecompressRepeatingZeros() public {
        bytes memory data = hex"0000000000000000000000000000000000000000000000000000000000000000";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressDecompressRepeatingFFs() public {
        bytes memory data = hex"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

    function testCdCompressDecompressRandomData(bytes calldata data) public {
//        vm.assume(data.length > 100 && data.length < 4096);
        bytes memory compressed = LibZip.cdCompress(data);
        bytes memory decompressed = LibZip.cdDecompress(compressed);
        assertEq(data, decompressed);
    }

//    function testCdFallback(bytes calldata data) public {
//        vm.assume(data.length > 0 && data.length < 4096);
//        bytes memory compressed = LibZip.cdCompress(data);
//        (bool success, bytes memory returndata) = address(this).call(compressed);
//        assert(success);
//        assertEq(returndata, data);
//    }
}
