// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import {Test} from "forge-std/Test.sol";
import {Base64} from "../src/utils/Base64.sol";

contract Base64Test is Test {
    // Test encoding with no padding and no file-safe characters
    function testEncodeNoPaddingNoFileSafe() public {
        bytes memory data = "Hello, World!";
        string memory encoded = Base64.encode(data, false, true);
        assertEq(encoded, "SGVsbG8sIFdvcmxkIQ");
    }

    // Test encoding with padding and no file-safe characters
    function testEncodeWithPaddingNoFileSafe() public {
        bytes memory data = "Hello, World!";
        string memory encoded = Base64.encode(data, false, false);
        assertEq(encoded, "SGVsbG8sIFdvcmxkIQ==");
    }

    // Test encoding with no padding and file-safe characters
    function testEncodeNoPaddingFileSafe() public {
        bytes memory data = "Hello, World!";
        string memory encoded = Base64.encode(data, true, true);
        assertEq(encoded, "SGVsbG8sIFdvcmxkIQ");
    }

    // Test encoding with padding and file-safe characters
    function testEncodeWithPaddingFileSafe() public {
        bytes memory data = "Hello, World!";
        string memory encoded = Base64.encode(data, true, false);
        assertEq(encoded, "SGVsbG8sIFdvcmxkIQ==");
    }

    // Test decoding standard Base64 encoded string
    function testDecodeStandardBase64() public {
        string memory encoded = "SGVsbG8sIFdvcmxkIQ==";
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, "Hello, World!");
    }

    // Test decoding file-safe Base64 encoded string
    function testDecodeFileSafeBase64() public {
        string memory encoded = "SGVsbG8sIFdvcmxkIQ";
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, "Hello, World!");
    }

    // Test decoding with non-standard characters
    function testDecodeNonStandardChars() public {
        string memory encoded = "SGVsbG8sIFdvcmxkIQ$$"; // Invalid characters at the end
        bytes memory decoded = Base64.decode(encoded);
        // The output is undefined due to invalid input, but should not revert
    }

    // Fuzz test for encoding and decoding
    function testFuzzEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data, false, false);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data, "Decoded data does not match original");
    }

    // Fuzz test for file-safe encoding and decoding
    function testFuzzFileSafeEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data, true, false);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data, "Decoded data does not match original");
    }
}