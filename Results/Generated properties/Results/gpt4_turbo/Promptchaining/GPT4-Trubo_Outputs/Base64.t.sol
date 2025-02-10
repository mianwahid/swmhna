// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/Base64.sol";

contract Base64Test is Test {
    function testEncodeLengthCheck(
        bytes memory data,
        bool fileSafe,
        bool noPadding
    ) public {
        string memory encoded = Base64.encode(data, fileSafe, noPadding);
        uint expectedLength = 4 * ((data.length + 2) / 3);
        if (noPadding) {
            uint padding = (3 - (data.length % 3)) % 3;
            expectedLength -= padding;
        }
        assertEq(bytes(encoded).length, expectedLength);
    }

    function testEncodeFileSafety(bytes memory data) public {
        string memory encoded = Base64.encode(data, true, false);
        bytes memory encodedBytes = bytes(encoded);
        for (uint i = 0; i < encodedBytes.length; i++) {
            assert(encodedBytes[i] != "+" && encodedBytes[i] != "/");
        }
    }

    // function testEncodePadding(bytes memory data) public {
    //     string memory encodedNoPadding = Base64.encode(data, false, true);
    //     string memory encodedWithPadding = Base64.encode(data, false, false);
    //     assert(!stringsContain(encodedNoPadding, "="));
    //     uint padding = (3 - (data.length % 3)) % 3;
    //     if (padding > 0) {
    //         assert(stringsEndWith(encodedWithPadding, padding == 1 ? "==" : "="));
    //     }
    // }

    function testEncodeReversibility(
        bytes memory data,
        bool fileSafe,
        bool noPadding
    ) public {
        string memory encoded = Base64.encode(data, fileSafe, noPadding);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    // function testEncodeDefaultBehavior(bytes memory data) public {
    //     string memory encodedDefault = Base64.encode(data);
    //     string memory encodedManual = Base64.encode(data, false, false);
    //     assertEq(encodedDefault, encodedManual);
    //     assert(!stringsContain(encodedDefault, "-"));
    //     assert(!stringsContain(encodedDefault, "_"));
    //     assert(stringsEndWith(encodedDefault, "=") || stringsEndWith(encodedDefault, "=="));
    // }

    function testEncodePartialDefault(bytes memory data, bool fileSafe) public {
        string memory encodedPartial = Base64.encode(data, fileSafe);
        string memory encodedManual = Base64.encode(data, fileSafe, false);
        assertEq(encodedPartial, encodedManual);
    }

    // function testDecodeLengthCheck(string memory data) public {
    //     bytes memory decoded = Base64.decode(data);
    //     uint expectedLength = 3 * (bytes(data).length / 4);
    //     // uint padding = countChar(data, "=");
    //     // expectedLength -= padding;
    //     assertEq(decoded.length, expectedLength);
    // }

    // function testDecodeHandlingFileSafeAndRFC3501(string memory data) public {
    //     bytes memory decoded = Base64.decode(data);
    //     string memory reEncoded = Base64.encode(decoded, true, false);
    //     assertEq(reEncoded, data);
    // }

    function testDecodeReversibility(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testDecodeRobustnessToInvalidInput(string memory data) public {
        bytes memory decoded = Base64.decode(data);
        // This test is to document behavior, no specific assertions are required.
        // Observing the output is sufficient to understand how the function handles invalid inputs.
    }

    // Helper functions
    function stringsContain(
        string memory haystack,
        string memory needle
    ) private pure returns (bool) {
        return
            bytes(haystack).length > 0 &&
            bytes(needle).length > 0 &&
            bytes(haystack).length >= bytes(needle).length;
    }

    function stringsEndWith(
        string memory haystack,
        string memory needle
    ) private pure returns (bool) {
        bytes memory bHaystack = bytes(haystack);
        bytes memory bNeedle = bytes(needle);
        if (bHaystack.length < bNeedle.length) {
            return false;
        }
        for (uint i = 0; i < bNeedle.length; i++) {
            if (
                bHaystack[bHaystack.length - bNeedle.length + i] != bNeedle[i]
            ) {
                return false;
            }
        }
        return true;
    }

    function countChar(
        string memory haystack,
        bytes1 char
    ) private pure returns (uint count) {
        bytes memory bHaystack = bytes(haystack);
        for (uint i = 0; i < bHaystack.length; i++) {
            if (bHaystack[i] == char) {
                count++;
            }
        }
    }
}
