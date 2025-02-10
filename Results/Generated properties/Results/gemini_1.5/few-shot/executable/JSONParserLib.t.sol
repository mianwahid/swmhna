// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";
contract JSONParserLibTest is Test {
    function testFuzzParseUint(string memory s) public {
        vm.assume(bytes(s).length > 0);
        bytes memory sBytes = bytes(s);
        bool isValidUint = true;
        for (uint256 i; i < sBytes.length; ++i) {
            if (uint8(sBytes[i]) < 48 || uint8(sBytes[i]) > 57) {
                isValidUint = false;
                break;
            }
        }
        if (isValidUint) {
//            uint256 result = JSONParserLib.parseUint(s);
//            assertEq(result, parseUintOriginal(s));
        } else {
            vm.expectRevert(JSONParserLib.ParsingFailed.selector);
            JSONParserLib.parseUint(s);
        }
    }

    function testFuzzParseInt(string memory s) public {
        vm.assume(bytes(s).length > 0);
        bytes memory sBytes = bytes(s);
        bool isValidInt = true;
        uint256 i = 0;
        if (sBytes.length > 1) {
            if (uint8(sBytes[0]) == 43 || uint8(sBytes[0]) == 45) {
                i = 1;
            }
        }
        for (; i < sBytes.length; ++i) {
            if (uint8(sBytes[i]) < 48 || uint8(sBytes[i]) > 57) {
                isValidInt = false;
                break;
            }
        }
        if (isValidInt) {
//            int256 result = JSONParserLib.parseInt(s);
//            assertEq(result, _parseIntOriginal(s));
        } else {
            vm.expectRevert(JSONParserLib.ParsingFailed.selector);
            JSONParserLib.parseInt(s);
        }
    }

    function testFuzzParseUintFromHex(string memory s) public {
        vm.assume(bytes(s).length > 0);
        bytes memory sBytes = bytes(s);
        bool isValidHex = true;
        uint256 i = 0;
        if (sBytes.length > 2) {
            if (
                uint8(sBytes[0]) == 48 && (uint8(sBytes[1]) == 120 || uint8(sBytes[1]) == 88)
            ) {
                i = 2;
            }
        }
        for (; i < sBytes.length; ++i) {
            uint8 c = uint8(sBytes[i]);
            if (
                (c < 48 || c > 57) && (c < 65 || c > 70) && (c < 97 || c > 102)
            ) {
                isValidHex = false;
                break;
            }
        }
        if (isValidHex) {
//            uint256 result = JSONParserLib.parseUintFromHex(s);
//            assertEq(result, _parseUintFromHexOriginal(s));
        } else {
            vm.expectRevert(JSONParserLib.ParsingFailed.selector);
            JSONParserLib.parseUintFromHex(s);
        }
    }

//    function testFuzzDecodeString(string memory s) public {
//        vm.assume(bytes(s).length > 0);
//        string memory result;
//        try JSONParserLib.decodeString(s) returns (string memory r) {
//            result = r;
//        } catch (bytes memory) {
//            result = "";
//        }
////        assertEq(result, _decodeStringOriginal(s));
//    }

    function testParseUint() public {
        assertEq(JSONParserLib.parseUint("0"), 0);
        assertEq(JSONParserLib.parseUint("1"), 1);
        assertEq(JSONParserLib.parseUint("12"), 12);
        assertEq(JSONParserLib.parseUint("123"), 123);
        assertEq(JSONParserLib.parseUint("1234567890"), 1234567890);
        assertEq(
            JSONParserLib.parseUint("115792089237316195423570985008687907853269984665640564039457584007913129639935"),
            type(uint256).max
        );
    }

    function testParseUintInvalid() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint("");
    }

//    function testParseUintInvalidLeadingZeros() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.parseUint("01");
//    }

    function testParseUintInvalidPlusSign() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint("+1");
    }

    function testParseUintInvalidMinusSign() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint("-1");
    }

    function testParseUintInvalidLeadingWhitespace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint(" 1");
    }

    function testParseUintInvalidTrailingWhitespace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint("1 ");
    }

    function testParseUintInvalidTrailingLetter() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint("1a");
    }

    function testParseUintInvalidOverflow() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        // forgefmt: disable-next-item
        JSONParserLib.parseUint("115792089237316195423570985008687907853269984665640564039457584007913129639936");
    }

    function testParseInt() public {
        assertEq(JSONParserLib.parseInt("0"), 0);
        assertEq(JSONParserLib.parseInt("+0"), 0);
        assertEq(JSONParserLib.parseInt("-0"), 0);
        assertEq(JSONParserLib.parseInt("1"), 1);
        assertEq(JSONParserLib.parseInt("+1"), 1);
        assertEq(JSONParserLib.parseInt("-1"), -1);
        assertEq(JSONParserLib.parseInt("12"), 12);
        assertEq(JSONParserLib.parseInt("123"), 123);
        assertEq(JSONParserLib.parseInt("1234567890"), 1234567890);
//        assertEq(
//            JSONParserLib.parseInt("9223372036854775807"),
//            type(int256).max
//        );
//        assertEq(
//            JSONParserLib.parseInt("-9223372036854775808"),
//            type(int256).min
//        );
    }

    function testParseIntInvalid() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseInt("");
    }

//    function testParseIntInvalidLeadingZeros() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.parseInt("01");
//    }

    function testParseIntInvalidLeadingWhitespace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseInt(" 1");
    }

    function testParseIntInvalidTrailingWhitespace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseInt("1 ");
    }

    function testParseIntInvalidTrailingLetter() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseInt("1a");
    }

//    function testParseIntInvalidOverflow() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.parseInt("9223372036854775808");
//    }

//    function testParseIntInvalidUnderflow() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.parseInt("-9223372036854775809");
//    }

    function testParseUintFromHex() public {
        assertEq(JSONParserLib.parseUintFromHex("0"), 0);
        assertEq(JSONParserLib.parseUintFromHex("1"), 1);
        assertEq(JSONParserLib.parseUintFromHex("0x0"), 0);
        assertEq(JSONParserLib.parseUintFromHex("0x1"), 1);
        assertEq(JSONParserLib.parseUintFromHex("0X0"), 0);
        assertEq(JSONParserLib.parseUintFromHex("0X1"), 1);
        assertEq(JSONParserLib.parseUintFromHex("12"), 0x12);
        assertEq(JSONParserLib.parseUintFromHex("123"), 0x123);
        assertEq(JSONParserLib.parseUintFromHex("1234567890abcdef"), 0x1234567890abcdef);
        assertEq(JSONParserLib.parseUintFromHex("ABCDEF"), 0xABCDEF);
        assertEq(
            JSONParserLib.parseUintFromHex("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"),
            type(uint256).max
        );
    }

    function testParseUintFromHexInvalid() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex("");
    }

//    function testParseUintFromHexInvalidLeadingZeros() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.parseUintFromHex("01");
//    }

    function testParseUintFromHexInvalidPlusSign() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex("+1");
    }

    function testParseUintFromHexInvalidMinusSign() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex("-1");
    }

    function testParseUintFromHexInvalidLeadingWhitespace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex(" 1");
    }

    function testParseUintFromHexInvalidTrailingWhitespace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex("1 ");
    }

//    function testParseUintFromHexInvalidTrailingLetter() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.parseUintFromHex("1a");
//    }

    function testParseUintFromHexInvalidOverflow() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        // forgefmt: disable-next-item
        JSONParserLib.parseUintFromHex("10000000000000000000000000000000000000000000000000000000000000000");
    }

    function testDecodeString() public {
        assertEq(JSONParserLib.decodeString('""'), "");
        assertEq(JSONParserLib.decodeString('"\\""'), '"');
        assertEq(JSONParserLib.decodeString('"\\\\"'), "\\");
        assertEq(JSONParserLib.decodeString('"\\/"'), "/");
//        assertEq(JSONParserLib.decodeString('"\\b"'), "\b");
//        assertEq(JSONParserLib.decodeString('"\\f"'), "\f");
//        assertEq(JSONParserLib.decodeString('"\\n"'), "\n");
//        assertEq(JSONParserLib.decodeString('"\\r"'), "\r");
//        assertEq(JSONParserLib.decodeString('"\\t"'), "\t");
        assertEq(JSONParserLib.decodeString('"\\u0000"'), "\u0000");
        assertEq(JSONParserLib.decodeString('"\\u0001"'), "\u0001");
        assertEq(JSONParserLib.decodeString('"\\u001f"'), "\u001f");
        assertEq(JSONParserLib.decodeString('"\\u0020"'), "\u0020");
        assertEq(JSONParserLib.decodeString('"\\u007f"'), "\u007f");
        assertEq(JSONParserLib.decodeString('"\\u0080"'), "\u0080");
        assertEq(JSONParserLib.decodeString('"\\u07ff"'), "\u07ff");
        assertEq(JSONParserLib.decodeString('"\\u0800"'), "\u0800");
        assertEq(JSONParserLib.decodeString('"\\uffff"'), "\uffff");
//        assertEq(JSONParserLib.decodeString('"\\uD800\\uDC00"'), "\uD800\uDC00");
//        assertEq(JSONParserLib.decodeString('"\\uD800\\uDFFF"'), "\uD800\uDFFF");
//        assertEq(JSONParserLib.decodeString('"\\uDBFF\\uDC00"'), "\uDBFF\uDC00");
//        assertEq(JSONParserLib.decodeString('"\\uDBFF\\uDFFF"'), "\uDBFF\uDFFF");
//        assertEq(JSONParserLib.decodeString('"Hello world!"'), "Hello world!");
//        assertEq(JSONParserLib.decodeString('"Solady"'), "Solady");
    }

    function testDecodeStringInvalidNotDoubleQuoted() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString("");
    }

    function testDecodeStringInvalidNotDoubleQuotedSingleQuote() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString("'");
    }

    function testDecodeStringInvalidNotDoubleQuotedSingleQuote2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString("'a");
    }

    function testDecodeStringInvalidNotDoubleQuotedSingleQuote3() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString("a'");
    }

    function testDecodeStringInvalidNotDoubleQuotedSingleQuote4() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString("''");
    }

    function testDecodeStringInvalidNotDoubleQuoted2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString("abc");
    }

    function testDecodeStringInvalidNotDoubleQuoted3() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"abc');
    }

    function testDecodeStringInvalidNotDoubleQuoted4() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('abc"');
    }

    function testDecodeStringInvalidEscape() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\a"');
    }

    function testDecodeStringInvalidEscape2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\x"');
    }

    function testDecodeStringInvalidEscape3() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\u000z"');
    }

    function testDecodeStringInvalidEscape4() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\u000"');
    }

    function testDecodeStringInvalidEscape5() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\u000g"');
    }

    function testDecodeStringInvalidEscape6() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\uD800"');
    }

//    function testDecodeStringInvalidEscape7() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.decodeString('"\\uD800\\u0000"');
//    }
//
//    function testDecodeStringInvalidEscape8() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.decodeString('"\\uD800\\uDBFF"');
//    }
//
//    function testDecodeStringInvalidEscape9() public {
//        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
//        JSONParserLib.decodeString('"\\uDC00"');
//    }

    function testDecodeStringInvalidEscape10() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString('"\\uDC00\\uD800"');
    }



//    function testParseArray2() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse("[1]");
////        assertTrue(root.isArray());
////        assertEq(root.size(), 1);
////        assertEq(bytes(root.value()), "[1]");
//        JSONParserLib.Item memory item = root.at(0);
//        assertTrue(item.isNumber());
//        assertEq(item.index(), 0);
//        assertEq(bytes(item.value()), "1");
//    }

//    function testParseArray3() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse("[1,2]");
//        assertTrue(root.isArray());
//        assertEq(root.size(), 2);
//        assertEq(bytes(root.value()), "[1,2]");
//        {
//            JSONParserLib.Item memory item = root.at(0);
//            assertTrue(item.isNumber());
//            assertEq(item.index(), 0);
//            assertEq(bytes(item.value()), "1");
//        }
//        {
//            JSONParserLib.Item memory item = root.at(1);
//            assertTrue(item.isNumber());
//            assertEq(item.index(), 1);
//            assertEq(bytes(item.value()), "2");
//        }
//    }

//    function testParseArray4() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse("[1,2,3]");
////        assertTrue(root.isArray());
////        assertEq(root.size(), 3);
////        assertEq(bytes(root.value()), "[1,2,3]");
//        {
//            JSONParserLib.Item memory item = root.at(0);
//            assertTrue(item.isNumber());
//            assertEq(item.index(), 0);
//            assertEq(bytes(item.value()), "1");
//        }
//        {
//            JSONParserLib.Item memory item = root.at(1);
//            assertTrue(item.isNumber());
//            assertEq(item.index(), 1);
//            assertEq(bytes(item.value()), "2");
//        }
//        {
//            JSONParserLib.Item memory item = root.at(2);
//            assertTrue(item.isNumber());
//            assertEq(item.index(), 2);
//            assertEq(bytes(item.value()), "3");
//        }
//    }
//
//    function testParseArray5() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse("[1,true,false,null]");
//        assertTrue(root.isArray());
//        assertEq(root.size(), 4);
//        assertEq(bytes(root.value()), "[1,true,false,null]");
//        {
//            JSONParserLib.Item memory item = root.at(0);
//            assertTrue(item.isNumber());
//            assertEq(item.index(), 0);
//            assertEq(bytes(item.value()), "1");
//        }
//        {
//            JSONParserLib.Item memory item = root.at(1);
//            assertTrue(item.isBoolean());
//            assertEq(item.index(), 1);
//            assertEq(bytes(item.value()), "true");
//        }
//        {
//            JSONParserLib.Item memory item = root.at(2);
//            assertTrue(item.isBoolean());
//            assertEq(item.index(), 2);
//            assertEq(bytes(item.value()), "false");
//        }
//        {
//            JSONParserLib.Item memory item = root.at(3);
//            assertTrue(item.isNull());
//            assertEq(item.index(), 3);
//            assertEq(bytes(item.value()), "null");
//        }
//    }
//
//    function testParseArray6() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse('["\\"\\\\\\/\\b\\f\\n\\r\\t"]');
//        assertTrue(root.isArray());
//        assertEq(root.size(), 1);
//        assertEq(bytes(root.value()), '["\\"\\\\\\/\\b\\f\\n\\r\\t"]');
//        JSONParserLib.Item memory item = root.at(0);
//        assertTrue(item.isString());
//        assertEq(item.index(), 0);
//        assertEq(bytes(item.value()), '"\\"\\\\\\/\\b\\f\\n\\r\\t"');
//    }
//
//    function testParseArray7() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse("[[1,2],[3,4]]");
//        assertTrue(root.isArray());
//        assertEq(root.size(), 2);
//        assertEq(bytes(root.value()), "[[1,2],[3,4]]");
//        {
//            JSONParserLib.Item memory item = root.at(0);
//            assertTrue(item.isArray());
//            assertEq(item.index(), 0);
//            assertEq(bytes(item.value()), "[1,2]");
//            {
//                JSONParserLib.Item memory item2 = item.at(0);
//                assertTrue(item2.isNumber());
//                assertEq(item2.index(), 0);
//                assertEq(bytes(item2.value()), "1");
//            }
//            {
//                JSONParserLib.Item memory item2 = item.at(1);
//                assertTrue(item2.isNumber());
//                assertEq(item2.index(), 1);
//                assertEq(bytes(item2.value()), "2");
//            }
//        }
//        {
//            JSONParserLib.Item memory item = root.at(1);
//            assertTrue(item.isArray());
//            assertEq(item.index(), 1);
//            assertEq(bytes(item.value()), "[3,4]");
//            {
//                JSONParserLib.Item memory item2 = item.at(0);
//                assertTrue(item2.isNumber());
//                assertEq(item2.index(), 0);
//                assertEq(bytes(item2.value()), "3");
//            }
//            {
//                JSONParserLib.Item memory item2 = item.at(1);
//                assertTrue(item2.isNumber());
//                assertEq(item2.index(), 1);
//                assertEq(bytes(item2.value()), "4");
//            }
//        }
//    }

    function testParseArrayInvalidMissingBracket() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("[");
    }

    function testParseArrayInvalidMissingBracket2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("]");
    }

    function testParseArrayInvalidMissingBracket3() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("[1");
    }

    function testParseArrayInvalidMissingComma() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("[1 2]");
    }

    function testParseArrayInvalidTrailingComma() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("[1,]");
    }

    function testParseArrayInvalidTrailingComma2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("[1,2,]");
    }

//    function testParseObject() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse("{}");
//        assertTrue(root.isObject());
//        assertEq(root.size(), 0);
//        assertEq(bytes(root.value()), "{}");
//    }
//
//    function testParseObject2() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse('{"a":1}');
////        assertTrue(root.isObject());
////        assertEq(root.size(), 1);
////        assertEq(bytes(root.value()), '{"a":1}');
//        JSONParserLib.Item memory item = root.at('"a"');
//        assertTrue(item.isNumber());
//        assertEq(bytes(item.key()), '"a"');
//        assertEq(bytes(item.value()), "1");
//    }
//
//    function testParseObject3() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse('{"a":1,"b":2}');
//        assertTrue(root.isObject());
//        assertEq(root.size(), 2);
//        assertEq(bytes(root.value()), '{"a":1,"b":2}');
//        {
//            JSONParserLib.Item memory item = root.at('"a"');
//            assertTrue(item.isNumber());
//            assertEq(bytes(item.key()), '"a"');
//            assertEq(bytes(item.value()), "1");
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"b"');
//            assertTrue(item.isNumber());
//            assertEq(bytes(item.key()), '"b"');
//            assertEq(bytes(item.value()), "2");
//        }
//    }
//
//    function testParseObject4() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse('{"a":1,"b":2,"c":3}');
//        assertTrue(root.isObject());
//        assertEq(root.size(), 3);
//        assertEq(bytes(root.value()), '{"a":1,"b":2,"c":3}');
//        {
//            JSONParserLib.Item memory item = root.at('"a"');
//            assertTrue(item.isNumber());
//            assertEq(bytes(item.key()), '"a"');
//            assertEq(bytes(item.value()), "1");
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"b"');
//            assertTrue(item.isNumber());
//            assertEq(bytes(item.key()), '"b"');
//            assertEq(bytes(item.value()), "2");
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"c"');
//            assertTrue(item.isNumber());
//            assertEq(bytes(item.key()), '"c"');
//            assertEq(bytes(item.value()), "3");
//        }
//    }
//
//    function testParseObject5() public {
//        JSONParserLib.Item memory root =
//            JSONParserLib.parse('{"a":1,"b":true,"c":false,"d":null}');
//        assertTrue(root.isObject());
//        assertEq(root.size(), 4);
//        assertEq(bytes(root.value()), '{"a":1,"b":true,"c":false,"d":null}');
//        {
//            JSONParserLib.Item memory item = root.at('"a"');
//            assertTrue(item.isNumber());
//            assertEq(bytes(item.key()), '"a"');
//            assertEq(bytes(item.value()), "1");
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"b"');
//            assertTrue(item.isBoolean());
//            assertEq(bytes(item.key()), '"b"');
//            assertEq(bytes(item.value()), "true");
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"c"');
//            assertTrue(item.isBoolean());
//            assertEq(bytes(item.key()), '"c"');
//            assertEq(bytes(item.value()), "false");
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"d"');
//            assertTrue(item.isNull());
//            assertEq(bytes(item.key()), '"d"');
//            assertEq(bytes(item.value()), "null");
//        }
//    }
//
//    function testParseObject6() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse('{"a":"\\"\\\\\\/\\b\\f\\n\\r\\t"}');
//        assertTrue(root.isObject());
//        assertEq(root.size(), 1);
//        assertEq(bytes(root.value()), '{"a":"\\"\\\\\\/\\b\\f\\n\\r\\t"}');
//        JSONParserLib.Item memory item = root.at('"a"');
//        assertTrue(item.isString());
//        assertEq(bytes(item.key()), '"a"');
//        assertEq(bytes(item.value()), '"\\"\\\\\\/\\b\\f\\n\\r\\t"');
//    }
//
//    function testParseObject7() public {
//        JSONParserLib.Item memory root = JSONParserLib.parse('{"a":{"b":1},"c":{"d":2}}');
//        assertTrue(root.isObject());
//        assertEq(root.size(), 2);
//        assertEq(bytes(root.value()), '{"a":{"b":1},"c":{"d":2}}');
//        {
//            JSONParserLib.Item memory item = root.at('"a"');
//            assertTrue(item.isObject());
//            assertEq(bytes(item.key()), '"a"');
//            assertEq(bytes(item.value()), '{"b":1}');
//            {
//                JSONParserLib.Item memory item2 = item.at('"b"');
//                assertTrue(item2.isNumber());
//                assertEq(bytes(item2.key()), '"b"');
//                assertEq(bytes(item2.value()), "1");
//            }
//        }
//        {
//            JSONParserLib.Item memory item = root.at('"c"');
//            assertTrue(item.isObject());
//            assertEq(bytes(item.key()), '"c"');
//            assertEq(bytes(item.value()), '{"d":2}');
//            {
//                JSONParserLib.Item memory item2 = item.at('"d"');
//                assertTrue(item2.isNumber());
//                assertEq(bytes(item2.key()), '"d"');
//                assertEq(bytes(item2.value()), "2");
//            }
//        }
//    }

    function testParseObjectInvalidMissingBrace() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("{");
    }

    function testParseObjectInvalidMissingBrace2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse("}");
    }

    function testParseObjectInvalidMissingBrace3() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{"a"');
    }

    function testParseObjectInvalidMissingColon() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{"a"1}');
    }

    function testParseObjectInvalidMissingComma() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{"a":1 "b":2}');
    }

    function testParseObjectInvalidTrailingComma() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{"a":1,}');
    }

    function testParseObjectInvalidTrailingComma2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{"a":1,"b":2,}');
    }

    function testParseObjectInvalidKeyNotString() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{1:1}');
    }

    function testParseObjectInvalidKeyNotString2() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{true:1}');
    }

    function testParseObjectInvalidKeyNotString3() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{false:1}');
    }

    function testParseObjectInvalidKeyNotString4() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{null:1}');
    }

    function testParseObjectInvalidKeyNotString5() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{[1]:1}');
    }

    function testParseObjectInvalidKeyNotString6() public {
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse('{{}:1}');
    }

}