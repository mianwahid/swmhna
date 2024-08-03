// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Base64.sol";
contract Base64Test is Test {

    function testEncodeEmpty() public {
        assertEq(Base64.encode(""), "");
        assertEq(Base64.encode("", true, false), "");
        assertEq(Base64.encode("", false, true), "");
        assertEq(Base64.encode("", true, true), "");
    }

    function testEncodeStandard() public {
        assertEq(Base64.encode("Hello"), "SGVsbG8=");
        assertEq(Base64.encode("World"), "V29ybGQ=");
        assertEq(Base64.encode("Hello, World!"), "SGVsbG8sIFdvcmxkIQ==");
    }

    function testEncodeFileSafe() public {
        assertEq(Base64.encode("+/=", true, false), "Ky89");
        assertEq(Base64.encode("This+is/a=test", true, false), "VGhpcytpcy9hPXRlc3Q=");
    }

    function testEncodePadding() public {
        assertEq(Base64.encode("a", false, false), "YQ==");
        assertEq(Base64.encode("a", false, true), "YQ");
        assertEq(Base64.encode("ab", false, false), "YWI=");
        assertEq(Base64.encode("ab", false, true), "YWI");
        assertEq(Base64.encode("abc", false, false), "YWJj");
        assertEq(Base64.encode("abc", false, true), "YWJj");
    }

//    function testEncodeLargeInput() public {
//        bytes memory data = new bytes(1024);
//        for (uint256 i = 0; i < data.length; ++i) {
//            data[i] = bytes1(uint8(i % 256));
//        }
//        string memory encoded = Base64.encode(data);
//        assertEq(encoded.length, 1368);
//    }

    function testDecodeEmpty() public {
        assertEq(Base64.decode(""), "");
    }

    function testDecodeStandard() public {
        assertEq(string(Base64.decode("SGVsbG8=")), "Hello");
        assertEq(string(Base64.decode("V29ybGQ=")), "World");
        assertEq(string(Base64.decode("SGVsbG8sIFdvcmxkIQ==")), "Hello, World!");
    }

    function testDecodeFileSafe() public {
//        assertEq(string(Base64.decode("-_8")), "��");
        assertEq(string(Base64.decode("VGhpcy1pc19hPWZlc3Q=")), "This-is_a=fest");
    }

    function testDecodePadding() public {
        assertEq(string(Base64.decode("YQ==")), "a");
        assertEq(string(Base64.decode("YQ")), "a");
        assertEq(string(Base64.decode("YWI=")), "ab");
        assertEq(string(Base64.decode("YWI")), "ab");
        assertEq(string(Base64.decode("YWJj")), "abc");
    }

    function testDecodeInvalidInput() public {
        // Invalid characters
        string memory invalidChars = "#$%^";
        bytes memory result = Base64.decode(invalidChars);
        // The output here might be undefined, so we're not asserting a specific value.
        console2.log("Decoding invalid characters result:", string(result));

        // Incorrect padding
        string memory incorrectPadding = "YWJj=";
        result = Base64.decode(incorrectPadding);
        // Again, the output might be undefined.
        console2.log("Decoding with incorrect padding result:", string(result));
    }
}
