// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";

contract Base64Test is Test {
    function testEncodeDecodeEmpty() public {
        bytes memory data = "";
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeBasic() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeLong() public {
        bytes memory data = new bytes(1024);
        for (uint256 i = 0; i < data.length; ++i) {
            data[i] = bytes1(uint8(i));
        }
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeFileSafe() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testEncodeDecodeNoPadding() public {
        bytes memory data = "Hello, world!";
        string memory encoded = Base64.encode(data, false, true);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testDecodeInvalidLength() public {
        string memory encoded = "abc";
        Base64.decode(encoded);
    }

    function testDecodeInvalidCharacters() public {
        string memory encoded = "SGVsbG8sIHdvcmxkISI=";
        Base64.decode(encoded);
    }

    function testDecodeWithLineBreaks() public {
        string memory encoded = "SGVsbG8s\nIHdv\ncmxk\nISI=";
        Base64.decode(encoded);
    }

    function testFuzzEncodeDecode(bytes memory data) public {
        string memory encoded = Base64.encode(data);
        bytes memory decoded = Base64.decode(encoded);
        assertEq(decoded, data);
    }

    function testFuzzDecode(bytes memory data) public {
        string memory encoded = string(data);
        Base64.decode(encoded);
    }
}
