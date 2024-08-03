// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";

contract Base64Test is Test {
    // Test encoding with no padding and no file-safe characters
    function testEncodeNoPaddingNoFileSafe() public {
        bytes memory data = "Hello, World!";
        string memory expected = "SGVsbG8sIFdvcmxkIQ==";
        assertEq(Base64.encode(data, false, true), expected);
    }

    // Test encoding with padding and file-safe characters
    function testEncodePaddingFileSafe() public {
        bytes memory data = "Hello, World!";
        string memory expected = "SGVsbG8sIFdvcmxkIQ";
        assertEq(Base64.encode(data, true, true), expected);
    }

    // Test decoding standard Base64
    function testDecodeStandardBase64() public {
        string memory data = "SGVsbG8sIFdvcmxkIQ==";
        bytes memory expected = "Hello, World!";
        assertEq(Base64.decode(data), expected);
    }

    // Test decoding file-safe Base64
    function testDecodeFileSafeBase64() public {
        string memory data = "SGVsbG8sIFdvcmxkIQ";
        bytes memory expected = "Hello, World!";
        assertEq(Base64.decode(data), expected);
    }

    // Fuzz test for encoding and decoding consistency
    function testFuzzEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    // Fuzz test for file-safe encoding and decoding consistency
    function testFuzzFileSafeEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data, true, false);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    // Fuzz test for no padding encoding and decoding consistency
    function testFuzzNoPaddingEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data, false, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    // Test encoding with empty data
    function testEncodeEmptyData() public {
        bytes memory data = "";
        string memory expected = "";
        assertEq(Base64.encode(data, false, true), expected);
    }

    // Test decoding with empty data
    function testDecodeEmptyData() public {
        string memory data = "";
        bytes memory expected = "";
        assertEq(Base64.decode(data), expected);
    }
}