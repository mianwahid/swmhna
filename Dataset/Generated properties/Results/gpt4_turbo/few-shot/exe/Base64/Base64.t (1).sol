// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";

contract Base64Test is Test {
    /// @dev Test encoding and decoding a simple string.
    function testEncodeDecode() public {
        string memory input = "Hello, World!";
        string memory encoded = Base64.encode(bytes(input));
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, bytes(input));
    }

    /// @dev Test encoding with fileSafe and noPadding options.
    function testEncodeWithOptions() public {
        bytes memory input = bytes("Hello, World!");
        string memory encodedFileSafe = Base64.encode(input, true);
        string memory encodedNoPadding = Base64.encode(input, false, true);
        string memory encodedBoth = Base64.encode(input, true, true);

        // Check that fileSafe replaces '+' with '-' and '/' with '_'
        assertTrue(!hasChar(encodedFileSafe, '+'));
        assertTrue(!hasChar(encodedFileSafe, '/'));
        assertTrue(hasChar(encodedFileSafe, '-'));
        assertTrue(hasChar(encodedFileSafe, '_'));

        // Check that noPadding removes '='
        assertTrue(!hasChar(encodedNoPadding, '='));

        // Check both options together
        assertTrue(!hasChar(encodedBoth, '+'));
        assertTrue(!hasChar(encodedBoth, '/'));
        assertTrue(!hasChar(encodedBoth, '='));
        assertTrue(hasChar(encodedBoth, '-'));
        assertTrue(hasChar(encodedBoth, '_'));
    }

    /// @dev Test decoding various encoded strings.
    function testDecodeVariousEncodings() public {
        string[3] memory encodings = [
            "SGVsbG8sIFdvcmxkIQ==", // Standard Base64
            "SGVsbG8sIFdvcmxkIQ",   // No padding
            "SGVsbG8sIFdvcmxkIQ=="   // Standard with padding
        ];

        bytes memory expected = bytes("Hello, World!");

        for (uint i = 0; i < encodings.length; i++) {
            bytes memory decoded = Base64.decode(encodings[i]);
            assertEq(decoded, expected, "Decoded output does not match expected output");
        }
    }

    /// @dev Fuzz test for encoding and decoding random bytes.
    function testFuzzEncodeDecode(bytes memory randomData) public {
        string memory encoded = Base64.encode(randomData);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, randomData, "Decoded data does not match original");
    }

    /// @dev Helper function to check if a character exists in a string.
    function hasChar(string memory str, bytes1 char) internal pure returns (bool) {
        bytes memory b = bytes(str);
        for (uint i = 0; i < b.length; i++) {
            if (b[i] == char) {
                return true;
            }
        }
        return false;
    }
}