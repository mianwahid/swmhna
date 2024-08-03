// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";

contract Base64Test is Test {
    function testEncodeEmpty() public {
        bytes memory data = "";
        string memory encoded = Base64.encode(data);
        assertEq(encoded, "");
    }

    function testEncodeSimple() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data);
        assertEq(encoded, "SGVsbG8sIHdvcmxkIQ==");
    }

    function testEncodeFileSafe() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data, true);
        assertEq(encoded, "SGVsbG8sIHdvcmxkIQ==");
    }

    function testEncodeNoPadding() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data, false, true);
        assertEq(encoded, "SGVsbG8sIHdvcmxkIQ");
    }

    function testEncodeFileSafeNoPadding() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data, true, true);
        assertEq(encoded, "SGVsbG8sIHdvcmxkIQ");
    }

    function testDecodeEmpty() public {
        string memory data = "";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "");
    }

    function testDecodeSimple() public {
        string memory data = "SGVsbG8sIHdvcmxkIQ==";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "Hello, world!");
    }

    function testDecodeFileSafe() public {
        string memory data = "SGVsbG8sIHdvcmxkIQ==";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "Hello, world!");
    }

    function testDecodeNoPadding() public {
        string memory data = "SGVsbG8sIHdvcmxkIQ";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "Hello, world!");
    }

    function testDecodeFileSafeNoPadding() public {
        string memory data = "SGVsbG8sIHdvcmxkIQ";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "Hello, world!");
    }

    function testEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeFileSafe(bytes memory data) public {
        string memory encoded = Base64.encode(data, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeNoPadding(bytes memory data) public {
        string memory encoded = Base64.encode(data, false, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeFileSafeNoPadding(bytes memory data) public {
        string memory encoded = Base64.encode(data, true, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }
}