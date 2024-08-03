// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";

contract Base64Test is Test {
    using Base64 for bytes;
    using Base64 for string;

    function testEncodeEmptyInput() public {
        bytes memory data = "";
        string memory encoded = Base64.encode(data, false, false);
        assertEq(encoded, "");
    }

    function testEncodeSingleByteInput() public {
        bytes memory data = "f";
        string memory encoded = Base64.encode(data, false, false);
        assertEq(encoded, "Zg==");
    }

    function testEncodeTwoBytesInput() public {
        bytes memory data = "fo";
        string memory encoded = Base64.encode(data, false, false);
        assertEq(encoded, "Zm8=");
    }

    function testEncodeThreeBytesInput() public {
        bytes memory data = "foo";
        string memory encoded = Base64.encode(data, false, false);
        assertEq(encoded, "Zm9v");
    }

    function testEncodeFileSafe() public {
        bytes memory data = "foo";
        string memory encoded = Base64.encode(data, true, false);
        assertEq(encoded, "Zm9v");
    }

    function testEncodeNoPadding() public {
        bytes memory data = "fo";
        string memory encoded = Base64.encode(data, false, true);
        assertEq(encoded, "Zm8");
    }

    function testEncodeFileSafeNoPadding() public {
        bytes memory data = "fo";
        string memory encoded = Base64.encode(data, true, true);
        assertEq(encoded, "Zm8");
    }

    function testDefaultEncoding() public {
        bytes memory data = "foo";
        string memory encodedDefault = Base64.encode(data);
        string memory encodedExplicit = Base64.encode(data, false, false);
        assertEq(encodedDefault, encodedExplicit);
    }

    function testFileSafeEncodingWithPadding() public {
        bytes memory data = "foo";
        string memory encodedFileSafe = Base64.encode(data, true);
        string memory encodedExplicit = Base64.encode(data, true, false);
        assertEq(encodedFileSafe, encodedExplicit);
    }

    function testDecodeEmptyInput() public {
        string memory data = "";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "");
    }

    function testDecodeSingleByteOutput() public {
        string memory data = "Zg==";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "f");
    }

    function testDecodeTwoBytesOutput() public {
        string memory data = "Zm8=";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "fo");
    }

    function testDecodeThreeBytesOutput() public {
        string memory data = "Zm9v";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "foo");
    }

    function testDecodeFileSafe() public {
        string memory data = "Zm9v";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "foo");
    }

    function testDecodeNonPadded() public {
        string memory data = "Zm8";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "fo");
    }

    function testDecodeInvalidInputHandling() public {
        string memory data = "invalid_base64";
        bytes memory decoded = Base64.decode(data);
        // The output is undefined, but the function should not revert.
        console2.logBytes(decoded);
    }
}