// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";

contract Base64Test is Test {
    using Base64 for bytes;

    function testEncodeEmpty() public {
        bytes memory data = "";
        string memory encoded = Base64.encode(data);
        assertEq(encoded, "");
    }

    function testEncodeSingleByte() public {
        bytes memory data = hex"61"; // 'a'
        string memory encoded = Base64.encode(data);
        assertEq(encoded, "YQ==");
    }

    function testEncodeTwoBytes() public {
        bytes memory data = hex"6162"; // 'ab'
        string memory encoded = Base64.encode(data);
        assertEq(encoded, "YWI=");
    }

    function testEncodeThreeBytes() public {
        bytes memory data = hex"616263"; // 'abc'
        string memory encoded = Base64.encode(data);
        assertEq(encoded, "YWJj");
    }

    function testEncodeFileSafe() public {
        bytes memory data = hex"616263"; // 'abc'
        string memory encoded = Base64.encode(data, true);
        assertEq(encoded, "YWJj");
    }

    function testEncodeNoPadding() public {
        bytes memory data = hex"616263"; // 'abc'
        string memory encoded = Base64.encode(data, false, true);
        assertEq(encoded, "YWJj");
    }

    function testEncodeFileSafeNoPadding() public {
        bytes memory data = hex"616263"; // 'abc'
        string memory encoded = Base64.encode(data, true, true);
        assertEq(encoded, "YWJj");
    }

    function testDecodeEmpty() public {
        string memory data = "";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, "");
    }

    function testDecodeSingleByte() public {
        string memory data = "YQ==";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, hex"61"); // 'a'
    }

    function testDecodeTwoBytes() public {
        string memory data = "YWI=";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, hex"6162"); // 'ab'
    }

    function testDecodeThreeBytes() public {
        string memory data = "YWJj";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, hex"616263"); // 'abc'
    }

    function testDecodeFileSafe() public {
        string memory data = "YWJj";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, hex"616263"); // 'abc'
    }

    function testDecodeNoPadding() public {
        string memory data = "YWJj";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, hex"616263"); // 'abc'
    }

    function testDecodeFileSafeNoPadding() public {
        string memory data = "YWJj";
        bytes memory decoded = Base64.decode(data);
        assertEq(decoded, hex"616263"); // 'abc'
    }

    function testFuzzEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testFuzzEncodeDecodeFileSafe(bytes memory data) public {
        string memory encoded = Base64.encode(data, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testFuzzEncodeDecodeNoPadding(bytes memory data) public {
        string memory encoded = Base64.encode(data, false, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testFuzzEncodeDecodeFileSafeNoPadding(bytes memory data) public {
        string memory encoded = Base64.encode(data, true, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }
}