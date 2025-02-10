// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";

contract LibStringTest is Test {
    using LibString for uint256;
    using LibString for int256;
    using LibString for address;
    using LibString for bytes;
    using LibString for string;

//    function testHexLengthInsufficient() public {
//        try LibString.toHexString(uint256(1), 0) {
//            fail("Expected HexLengthInsufficient error");
//        } catch Error(string memory reason) {
//            assertEq(reason, "HexLengthInsufficient");
//        }
//    }

//    function testTooBigForSmallString() public {
//        string memory longString = new string(33);
//        try LibString.toSmallString(longString) {
//            fail("Expected TooBigForSmallString error");
//        } catch Error(string memory reason) {
//            assertEq(reason, "TooBigForSmallString");
//        }
//    }

    function testToStringUint256() public {
        assertEq(LibString.toString(uint256(0)), "0");
        assertEq(LibString.toString(type(uint256).max), "115792089237316195423570985008687907853269984665640564039457584007913129639935");
        assertEq(LibString.toString(uint256(1234567890)), "1234567890");
    }

    function testToStringInt256() public {
        assertEq(LibString.toString(int256(0)), "0");
        assertEq(LibString.toString(type(int256).min), "-115792089237316195423570985008687907853269984665640564039457584007913129639935");
        assertEq(LibString.toString(int256(-1234567890)), "-1234567890");
        assertEq(LibString.toString(int256(1234567890)), "1234567890");
    }

    function testToHexStringUint256Length() public {
        assertEq(LibString.toHexString(uint256(0), 1), "0x0");
        assertEq(LibString.toHexString(type(uint256).max, 32), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
//        try LibString.toHexString(uint256(1), 0) {
//            fail("Expected HexLengthInsufficient error");
//        } catch Error(string memory reason) {
//            assertEq(reason, "HexLengthInsufficient");
//        }
    }

    function testToHexStringNoPrefixUint256Length() public {
        assertEq(LibString.toHexStringNoPrefix(uint256(0), 1), "0");
        assertEq(LibString.toHexStringNoPrefix(type(uint256).max, 32), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
//        try LibString.toHexStringNoPrefix(uint256(1), 0) {
//            fail("Expected HexLengthInsufficient error");
//        } catch Error(string memory reason) {
//            assertEq(reason, "HexLengthInsufficient");
//        }
    }

    function testToHexStringUint256() public {
        assertEq(LibString.toHexString(uint256(0)), "0x0");
        assertEq(LibString.toHexString(type(uint256).max), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexStringUint256() public {
        assertEq(LibString.toMinimalHexString(uint256(0)), "0x0");
        assertEq(LibString.toMinimalHexString(type(uint256).max), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexStringNoPrefixUint256() public {
        assertEq(LibString.toMinimalHexStringNoPrefix(uint256(0)), "0");
        assertEq(LibString.toMinimalHexStringNoPrefix(type(uint256).max), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringNoPrefixUint256() public {
        assertEq(LibString.toHexStringNoPrefix(uint256(0)), "0");
        assertEq(LibString.toHexStringNoPrefix(type(uint256).max), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringChecksummedAddress() public {
        assertEq(LibString.toHexStringChecksummed(address(0)), "0x0000000000000000000000000000000000000000");
        assertEq(LibString.toHexStringChecksummed(address(0x1234567890AbcdEF1234567890aBcdef12345678)), "0x1234567890AbcDef1234567890AbcDef12345678");
    }

    function testToHexStringAddress() public {
        assertEq(LibString.toHexString(address(0)), "0x0000000000000000000000000000000000000000");
        assertEq(LibString.toHexString(address(0x1234567890AbcdEF1234567890aBcdef12345678)), "0x1234567890abcdef1234567890abcdef12345678");
    }

    function testToHexStringNoPrefixAddress() public {
        assertEq(LibString.toHexStringNoPrefix(address(0)), "0000000000000000000000000000000000000000");
        assertEq(LibString.toHexStringNoPrefix(address(0x1234567890AbcdEF1234567890aBcdef12345678)), "1234567890abcdef1234567890abcdef12345678");
    }

    function testToHexStringBytes() public {
        bytes memory emptyBytes = new bytes(0);
        assertEq(LibString.toHexString(emptyBytes), "0x");
        bytes memory randomBytes = hex"1234567890abcdef";
        assertEq(LibString.toHexString(randomBytes), "0x1234567890abcdef");
    }

    function testToHexStringNoPrefixBytes() public {
        bytes memory emptyBytes = new bytes(0);
        assertEq(LibString.toHexStringNoPrefix(emptyBytes), "");
        bytes memory randomBytes = hex"1234567890abcdef";
        assertEq(LibString.toHexStringNoPrefix(randomBytes), "1234567890abcdef");
    }

    function testRuneCount() public {
        assertEq(LibString.runeCount(""), 0);
        assertEq(LibString.runeCount("hello"), 5);
//        assertEq(LibString.runeCount("你好"), 2);
    }

    function testIs7BitASCII() public {
        assertTrue(LibString.is7BitASCII(""));
        assertTrue(LibString.is7BitASCII("hello"));
//        assertFalse(LibString.is7BitASCII("你好"));
    }

    function testReplace() public {
        assertEq(LibString.replace("", "a", "b"), "");
        assertEq(LibString.replace("hello", "x", "y"), "hello");
        assertEq(LibString.replace("hello", "l", ""), "heo");
        assertEq(LibString.replace("hello", "l", "L"), "heLLo");
    }

    function testIndexOf() public {
        assertEq(LibString.indexOf("", "a"), LibString.NOT_FOUND);
        assertEq(LibString.indexOf("hello", ""), 0);
        assertEq(LibString.indexOf("hello", "x"), LibString.NOT_FOUND);
        assertEq(LibString.indexOf("hello", "l"), 2);
    }

    function testLastIndexOf() public {
        assertEq(LibString.lastIndexOf("", "a"), LibString.NOT_FOUND);
        assertEq(LibString.lastIndexOf("hello", ""), 5);
        assertEq(LibString.lastIndexOf("hello", "x"), LibString.NOT_FOUND);
        assertEq(LibString.lastIndexOf("hello", "l"), 3);
    }

    function testContains() public {
        assertFalse(LibString.contains("", "a"));
        assertTrue(LibString.contains("hello", "hello"));
        assertTrue(LibString.contains("hello", "l"));
    }

    function testStartsWith() public {
        assertTrue(LibString.startsWith("", ""));
        assertTrue(LibString.startsWith("hello", "hello"));
        assertTrue(LibString.startsWith("hello", "he"));
        assertFalse(LibString.startsWith("hello", "lo"));
    }

    function testEndsWith() public {
        assertTrue(LibString.endsWith("", ""));
        assertTrue(LibString.endsWith("hello", "hello"));
        assertTrue(LibString.endsWith("hello", "lo"));
        assertFalse(LibString.endsWith("hello", "he"));
    }

    function testRepeat() public {
        assertEq(LibString.repeat("", 5), "");
        assertEq(LibString.repeat("hello", 0), "");
        assertEq(LibString.repeat("hello", 3), "hellohellohello");
    }

    function testSlice() public {
        assertEq(LibString.slice("", 0, 1), "");
        assertEq(LibString.slice("hello", 2, 2), "");
        assertEq(LibString.slice("hello", 1, 4), "ell");
        assertEq(LibString.slice("hello", 1), "ello");
    }

    function testIndicesOf() public {
        uint256[] memory emptyArray = new uint256[](0);
        assertEq(LibString.indicesOf("", "a").length, emptyArray.length);
        assertEq(LibString.indicesOf("hello", "").length, 6);
        assertEq(LibString.indicesOf("hello", "x").length, emptyArray.length);
        uint256[] memory indices = LibString.indicesOf("hello", "l");
        assertEq(indices.length, 2);
        assertEq(indices[0], 2);
        assertEq(indices[1], 3);
    }

    function testSplit() public {
        string[] memory result = LibString.split("", "a");
        assertEq(result.length, 1);
        assertEq(result[0], "");
        result = LibString.split("hello", "");
        assertEq(result.length, 5);
        assertEq(result[0], "h");
        result = LibString.split("hello", "x");
        assertEq(result.length, 1);
        assertEq(result[0], "hello");
        result = LibString.split("hello", "l");
        assertEq(result.length, 3);
        assertEq(result[0], "he");
        assertEq(result[1], "");
        assertEq(result[2], "o");
    }

    function testConcat() public {
        assertEq(LibString.concat("", ""), "");
        assertEq(LibString.concat("hello", ""), "hello");
        assertEq(LibString.concat("hello", " world"), "hello world");
    }

    function testToCase() public {
        assertEq(LibString.toCase("", false), "");
        assertEq(LibString.toCase("HELLO", false), "hello");
        assertEq(LibString.toCase("hello", true), "HELLO");
    }

    function testFromSmallString() public {
        assertEq(LibString.fromSmallString(bytes32(0)), "");
        assertEq(LibString.fromSmallString("hello"), "hello");
    }

    function testNormalizeSmallString() public {
        assertEq(LibString.normalizeSmallString(bytes32(0)), bytes32(0));
        assertEq(LibString.normalizeSmallString("hello"), "hello");
    }

//    function testToSmallString() public {
//        assertEq(LibString.toSmallString(""), bytes32(0));
//        try LibString.toSmallString(new string(33)) {
//            fail("Expected TooBigForSmallString error");
//        } catch Error(string memory reason) {
//            assertEq(reason, "TooBigForSmallString");
//        }
//        assertEq(LibString.toSmallString("hello"), "hello");
//    }

    function testLower() public {
        assertEq(LibString.lower(""), "");
        assertEq(LibString.lower("HELLO"), "hello");
    }

    function testUpper() public {
        assertEq(LibString.upper(""), "");
        assertEq(LibString.upper("hello"), "HELLO");
    }

    function testEscapeHTML() public {
        assertEq(LibString.escapeHTML(""), "");
        assertEq(LibString.escapeHTML("hello"), "hello");
        assertEq(LibString.escapeHTML("<div>"), "&lt;div&gt;");
    }

    function testEscapeJSON() public {
        assertEq(LibString.escapeJSON("", false), "");
        assertEq(LibString.escapeJSON("hello", false), "hello");
        assertEq(LibString.escapeJSON("\"hello\"", false), "\\\"hello\\\"");
        assertEq(LibString.escapeJSON("", true), "\"\"");
        assertEq(LibString.escapeJSON("hello", true), "\"hello\"");
        assertEq(LibString.escapeJSON("\"hello\"", true), "\"\\\"hello\\\"\"");
    }

    function testEq() public {
        assertTrue(LibString.eq("", ""));
        assertTrue(LibString.eq("hello", "hello"));
        assertFalse(LibString.eq("hello", "world"));
    }

    function testEqs() public {
        assertTrue(LibString.eqs("", bytes32(0)));
        assertTrue(LibString.eqs("hello", "hello"));
        assertFalse(LibString.eqs("hello", "world"));
    }

    function testPackOne() public {
        assertEq(LibString.packOne(""), bytes32(0));
        assertEq(LibString.packOne(new string(32)), bytes32(0));
        assertEq(LibString.packOne("hello"), "hello");
    }

    function testUnpackOne() public {
        assertEq(LibString.unpackOne(bytes32(0)), "");
        assertEq(LibString.unpackOne("hello"), "hello");
    }

    function testPackTwo() public {
        assertEq(LibString.packTwo("", ""), bytes32(0));
        assertEq(LibString.packTwo(new string(31), "a"), bytes32(0));
        assertEq(LibString.packTwo("hello", "world"), "helloworld");
    }

    function testUnpackTwo() public {
        (string memory a, string memory b) = LibString.unpackTwo(bytes32(0));
        assertEq(a, "");
        assertEq(b, "");
        (a, b) = LibString.unpackTwo("helloworld");
        assertEq(a, "hello");
        assertEq(b, "world");
    }

    function testDirectReturn() public {
        LibString.directReturn("");
        LibString.directReturn("hello");
    }
}