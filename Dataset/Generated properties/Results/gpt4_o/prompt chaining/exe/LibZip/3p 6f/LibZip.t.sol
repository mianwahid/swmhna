// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    using LibZip for bytes;

    function testFlzCompressAndDecompressConsistency() public {
        bytes memory data = "";
        assertEq(data.flzCompress().flzDecompress(), data);

        data = "a";
        assertEq(data.flzCompress().flzDecompress(), data);

//        data = bytes("a".repeat(1000));
//        assertEq(data.flzCompress().flzDecompress(), data);

        data = "abcabcabc";
        assertEq(data.flzCompress().flzDecompress(), data);

        data = "abcdefghij";
        assertEq(data.flzCompress().flzDecompress(), data);
    }

    function testFlzIdempotentCompression() public {
        bytes memory data = "";
        assertEq(data.flzCompress().flzCompress(), data.flzCompress());

        data = "a";
        assertEq(data.flzCompress().flzCompress(), data.flzCompress());

//        data = bytes("a".repeat(1000));
//        assertEq(data.flzCompress().flzCompress(), data.flzCompress());

        data = "abcabcabc";
        assertEq(data.flzCompress().flzCompress(), data.flzCompress());

        data = "abcdefghij";
        assertEq(data.flzCompress().flzCompress(), data.flzCompress());
    }

    function testFlzIdempotentDecompression() public {
        bytes memory data = "";
        assertEq(data.flzDecompress().flzDecompress(), data.flzDecompress());

        data = "a";
        assertEq(data.flzDecompress().flzDecompress(), data.flzDecompress());

//        data = bytes("a".repeat(1000));
//        assertEq(data.flzDecompress().flzDecompress(), data.flzDecompress());

        data = "abcabcabc";
        assertEq(data.flzDecompress().flzDecompress(), data.flzDecompress());

        data = "abcdefghij";
        assertEq(data.flzDecompress().flzDecompress(), data.flzDecompress());
    }

    function testCdCompressAndDecompressConsistency() public {
        bytes memory data = "";
        assertEq(data.cdCompress().cdDecompress(), data);

        data = "a";
        assertEq(data.cdCompress().cdDecompress(), data);

//        data = bytes("a".repeat(1000));
//        assertEq(data.cdCompress().cdDecompress(), data);

        data = "\x00\x00\x00";
        assertEq(data.cdCompress().cdDecompress(), data);

        data = "\xff\xff\xff";
        assertEq(data.cdCompress().cdDecompress(), data);

        data = "\x00\xff\x00\xff";
        assertEq(data.cdCompress().cdDecompress(), data);
    }

    function testCdIdempotentCompression() public {
        bytes memory data = "";
        assertEq(data.cdCompress().cdCompress(), data.cdCompress());

        data = "a";
        assertEq(data.cdCompress().cdCompress(), data.cdCompress());

//        data = bytes("a".repeat(1000));
//        assertEq(data.cdCompress().cdCompress(), data.cdCompress());

        data = "\x00\x00\x00";
        assertEq(data.cdCompress().cdCompress(), data.cdCompress());

        data = "\xff\xff\xff";
        assertEq(data.cdCompress().cdCompress(), data.cdCompress());

        data = "\x00\xff\x00\xff";
        assertEq(data.cdCompress().cdCompress(), data.cdCompress());
    }

    function testCdIdempotentDecompression() public {
        bytes memory data = "";
        assertEq(data.cdDecompress().cdDecompress(), data.cdDecompress());

        data = "a";
        assertEq(data.cdDecompress().cdDecompress(), data.cdDecompress());

//        data = bytes("a".repeat(1000));
//        assertEq(data.cdDecompress().cdDecompress(), data.cdDecompress());

        data = "\x00\x00\x00";
        assertEq(data.cdDecompress().cdDecompress(), data.cdDecompress());

        data = "\xff\xff\xff";
        assertEq(data.cdDecompress().cdDecompress(), data.cdDecompress());

        data = "\x00\xff\x00\xff";
        assertEq(data.cdDecompress().cdDecompress(), data.cdDecompress());
    }

    function testCdFallbackHandling() public {
        // Implementing a mock contract to test fallback handling
        MockContract mock = new MockContract();
        bytes memory data = "";
        (bool success, bytes memory result) = address(mock).call(data.cdCompress());
        assertTrue(success);
        assertEq(result, data);

        data = "a";
        (success, result) = address(mock).call(data.cdCompress());
        assertTrue(success);
        assertEq(result, data);

//        data = bytes("a".repeat(1000));
//        (success, result) = address(mock).call(data.cdCompress());
//        assertTrue(success);
//        assertEq(result, data);

        data = "\x00\x00\x00";
        (success, result) = address(mock).call(data.cdCompress());
        assertTrue(success);
        assertEq(result, data);

        data = "\xff\xff\xff";
        (success, result) = address(mock).call(data.cdCompress());
        assertTrue(success);
        assertEq(result, data);

        data = "\x00\xff\x00\xff";
        (success, result) = address(mock).call(data.cdCompress());
        assertTrue(success);
        assertEq(result, data);
    }

    function testDelegatecallSuccess() public {
        // Implementing a mock contract to test delegatecall success
        MockContract mock = new MockContract();
        bytes memory data = "valid data";
        (bool success, bytes memory result) = address(mock).call(data.cdCompress());
        assertTrue(success);
        assertEq(result, data);
    }

    function testDelegatecallReversion() public {
        // Implementing a mock contract to test delegatecall reversion
        MockContract mock = new MockContract();
        bytes memory data = "invalid data";
        (bool success, bytes memory result) = address(mock).call(data.cdCompress());
        assertFalse(success);
    }
}

contract MockContract {
    fallback() external payable {
        LibZip.cdFallback();
    }

    receive() external payable {}
}