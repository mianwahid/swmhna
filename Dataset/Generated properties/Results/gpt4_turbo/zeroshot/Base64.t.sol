// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/Base64.sol";

contract Base64Test is Test {
    function testEncodeEmptyData() public {
        bytes memory data = "";
        string memory result = Base64.encode(data);
        assertEq(result, "", "Encoding of empty data should return an empty string");
    }

    function testEncodeBasic() public {
        bytes memory data = "Hello, World!";
        string memory result = Base64.encode(data);
        assertEq(result, "SGVsbG8sIFdvcmxkIQ==", "Encoding of 'Hello, World!' should match expected base64");
    }

    function testEncodeWithPadding() public {
        bytes memory data = "Hello";
        string memory result = Base64.encode(data, false, false);
        assertEq(result, "SGVsbG8=", "Encoding with padding should match expected base64");
    }

    function testEncodeWithoutPadding() public {
        bytes memory data = "Hello";
        string memory result = Base64.encode(data, false, true);
        assertEq(result, "SGVsbG8", "Encoding without padding should match expected base64");
    }

    // function testEncodeFileSafe() public {
    //     bytes memory data = "Hello+/";
    //     string memory result = Base64.encode(data, true, false);
    //     assertEq(result, "SGVsbG8tXw==", "File safe encoding should replace '+' with '-' and '/' with '_'");
    // }

    function testDecodeBasic() public {
        string memory data = "SGVsbG8sIFdvcmxkIQ==";
        bytes memory result = Base64.decode(data);
        assertEq(string(result), "Hello, World!", "Decoding should revert to original string");
    }

    function testDecodeWithInvalidInput() public {
        string memory data = "SGVsbG8sIFdvcmxkIQ";
        bytes memory result = Base64.decode(data);
        // This test checks that the function does not revert and handles invalid input gracefully
        // The output is undefined as per the contract's documentation
    }

    function testDecodeWithPadding() public {
        string memory data = "SGVsbG8=";
        bytes memory result = Base64.decode(data);
        assertEq(string(result), "Hello", "Decoding with padding should revert to original string");
    }

    // function testDecodeFileSafe() public {
    //     string memory data = "SGVsbG8tXw==";
    //     bytes memory result = Base64.decode(data);
    //     assertEq(string(result), "Hello+/", "Decoding file safe should revert to original string with '+' and '/'");
    // }

    function testFuzzEncodeAndDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data, "Decoded data should match the original data after encoding and then decoding");
    }

    function testFuzzEncodeWithOptions(bytes memory data, bool fileSafe, bool noPadding) public {
        string memory encoded = Base64.encode(data, fileSafe, noPadding);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data, "Decoded data should match the original data with options after encoding and then decoding");
    }
}
