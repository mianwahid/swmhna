// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";

contract LibStringTest is Test {


    function testToStringMaxUint() public {
        assertEq(
            LibString.toString(type(uint256).max),
            "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        );
    }

    function testToStringIntZero() public {
        assertEq(LibString.toString(int256(0)), "0");
    }

    function testToStringIntPositive() public {
        assertEq(LibString.toString(int256(123456789)), "123456789");
    }

    function testToStringIntNegative() public {
        assertEq(LibString.toString(int256(-123456789)), "-123456789");
    }

    function testToStringIntMax() public {
        assertEq(
            LibString.toString(type(int256).max),
            "57896044618658097711785492504343953926634992332820282019728792003956564819967"
        );
    }

    function testToStringIntMin() public {
        assertEq(
            LibString.toString(type(int256).min),
            "-57896044618658097711785492504343953926634992332820282019728792003956564819968"
        );
    }

    function testToHexStringZero() public {
        assertEq(LibString.toHexString(0), "0x00");
    }

    function testToHexStringPositive() public {
        assertEq(LibString.toHexString(0x123456789abcdef0), "0x123456789abcdef0");
    }

    function testToHexStringMaxUint() public {
        assertEq(
            LibString.toHexString(type(uint256).max),
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

//    function testToHexStringWithLengthZero() public {
//        assertEq(LibString.toHexString(0, 0), "0x");
//    }

    function testToHexStringWithLengthPositive() public {
        assertEq(LibString.toHexString(0x1234, 2), "0x1234");
    }

    function testToHexStringWithLengthMaxUint() public {
        assertEq(
            LibString.toHexString(type(uint256).max, 32),
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

    function testToHexStringNoPrefixZero() public {
        assertEq(LibString.toHexStringNoPrefix(0), "00");
    }

    function testToHexStringNoPrefixPositive() public {
        assertEq(LibString.toHexStringNoPrefix(0x123456789abcdef0), "123456789abcdef0");
    }

    function testToHexStringNoPrefixMaxUint() public {
        assertEq(
            LibString.toHexStringNoPrefix(type(uint256).max),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

//    function testToHexStringNoPrefixWithLengthZero() public {
//        assertEq(LibString.toHexStringNoPrefix(0, 0), "");
//    }

    function testToHexStringNoPrefixWithLengthPositive() public {
        assertEq(LibString.toHexStringNoPrefix(0x1234, 2), "1234");
    }

    function testToHexStringNoPrefixWithLengthMaxUint() public {
        assertEq(
            LibString.toHexStringNoPrefix(type(uint256).max, 32),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

    function testToMinimalHexStringZero() public {
        assertEq(LibString.toMinimalHexString(0), "0x0");
    }

    function testToMinimalHexStringPositive() public {
        assertEq(LibString.toMinimalHexString(0x123456789abcdef0), "0x123456789abcdef0");
    }

    function testToMinimalHexStringMaxUint() public {
        assertEq(
            LibString.toMinimalHexString(type(uint256).max),
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

    function testToMinimalHexStringNoPrefixZero() public {
        assertEq(LibString.toMinimalHexStringNoPrefix(0), "0");
    }

    function testToMinimalHexStringNoPrefixPositive() public {
        assertEq(LibString.toMinimalHexStringNoPrefix(0x123456789abcdef0), "123456789abcdef0");
    }

    function testToMinimalHexStringNoPrefixMaxUint() public {
        assertEq(
            LibString.toMinimalHexStringNoPrefix(type(uint256).max),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

    function testToHexStringChecksummedZero() public {
        assertEq(LibString.toHexStringChecksummed(address(0)), "0x0000000000000000000000000000000000000000");
    }

//    function testToHexStringChecksummedPositive() public {
//        assertEq(
//            LibString.toHexStringChecksummed(address(0x1234567890abcdef1234567890ABCDEF12345678)),
//            "0x1234567890aBcDeF1234567890ABCDEf12345678"
//        );
//    }

    function testToHexStringAddressZero() public {
        assertEq(LibString.toHexString(address(0)), "0x0000000000000000000000000000000000000000");
    }

//    function testToHexStringAddressPositive() public {
//        assertEq(
//            LibString.toHexString(address(0x1234567890abcdef1234567890ABCDEF12345678)),
//            "0x1234567890abcdef1234567890ABCDEF12345678"
//        );
//    }

    function testToHexStringNoPrefixAddressZero() public {
        assertEq(LibString.toHexStringNoPrefix(address(0)), "0000000000000000000000000000000000000000");
    }



    function testToHexStringBytesEmpty() public {
        bytes memory emptyBytes;
        assertEq(LibString.toHexString(emptyBytes), "0x");
    }

    function testToHexStringBytesZero() public {
        bytes memory zeroBytes = hex"00";
        assertEq(LibString.toHexString(zeroBytes), "0x00");
    }

    function testToHexStringBytesPositive() public {
        bytes memory positiveBytes = hex"123456789abcdef0";
        assertEq(LibString.toHexString(positiveBytes), "0x123456789abcdef0");
    }

    function testToHexStringNoPrefixBytesEmpty() public {
        bytes memory emptyBytes;
        assertEq(LibString.toHexStringNoPrefix(emptyBytes), "");
    }

    function testToHexStringNoPrefixBytesZero() public {
        bytes memory zeroBytes = hex"00";
        assertEq(LibString.toHexStringNoPrefix(zeroBytes), "00");
    }

    function testToHexStringNoPrefixBytesPositive() public {
        bytes memory positiveBytes = hex"123456789abcdef0";
        assertEq(LibString.toHexStringNoPrefix(positiveBytes), "123456789abcdef0");
    }

    function testRuneCountEmpty() public {
        assertEq(LibString.runeCount(""), 0);
    }

    function testRuneCountASCII() public {
        assertEq(LibString.runeCount("abcdefg"), 7);
    }





    function testIs7BitASCIIEmpty() public {
        assertTrue(LibString.is7BitASCII(""));
    }

    function testIs7BitASCIIValid() public {
        assertTrue(LibString.is7BitASCII("abcdefg"));
    }


    function testReplaceEmpty() public {
        assertEq(LibString.replace("", "a", "b"), "");
    }

    function testReplaceNoMatch() public {
        assertEq(LibString.replace("abcdefg", "h", "i"), "abcdefg");
    }

    function testReplaceSingleMatch() public {
        assertEq(LibString.replace("abcdefg", "c", "x"), "abxdefg");
    }

    function testReplaceMultipleMatches() public {
        assertEq(LibString.replace("abcabc", "bc", "xy"), "axyaxy");
    }

    function testReplaceOverlappingMatches() public {
        assertEq(LibString.replace("aaaa", "aa", "b"), "bb");
    }

    function testIndexOfEmptySearch() public {
        assertEq(LibString.indexOf("abcdefg", "", 0), 0);
    }

    function testIndexOfEmptySubject() public {
        assertEq(LibString.indexOf("", "a", 0), LibString.NOT_FOUND);
    }

    function testIndexOfNotFound() public {
        assertEq(LibString.indexOf("abcdefg", "h", 0), LibString.NOT_FOUND);
    }

    function testIndexOfFirstOccurrence() public {
        assertEq(LibString.indexOf("abcdefg", "c", 0), 2);
    }

    function testIndexOfFromIndex() public {
        assertEq(LibString.indexOf("abcabc", "b", 2), 4);
    }

    function testIndexOfLastOccurrence() public {
        assertEq(LibString.lastIndexOf("abcabc", "b", type(uint256).max), 4);
    }

    function testIndexOfLastOccurrenceFromIndex() public {
        assertEq(LibString.lastIndexOf("abcabc", "b", 2), 1);
    }

    function testContainsFound() public {
        assertTrue(LibString.contains("abcdefg", "c"));
    }

    function testContainsNotFound() public {
        assertFalse(LibString.contains("abcdefg", "h"));
    }

    function testStartsWithMatch() public {
        assertTrue(LibString.startsWith("abcdefg", "abc"));
    }

    function testStartsWithNoMatch() public {
        assertFalse(LibString.startsWith("abcdefg", "bcd"));
    }

    function testEndsWithMatch() public {
        assertTrue(LibString.endsWith("abcdefg", "efg"));
    }

    function testEndsWithNoMatch() public {
        assertFalse(LibString.endsWith("abcdefg", "cde"));
    }

    function testRepeatZeroTimes() public {
        assertEq(LibString.repeat("abc", 0), "");
    }

    function testRepeatOneTime() public {
        assertEq(LibString.repeat("abc", 1), "abc");
    }

    function testRepeatMultipleTimes() public {
        assertEq(LibString.repeat("abc", 3), "abcabcabc");
    }

    function testSliceStartLessThanEnd() public {
        assertEq(LibString.slice("abcdefg", 2, 5), "cde");
    }

    function testSliceStartEqualsEnd() public {
        assertEq(LibString.slice("abcdefg", 2, 2), "");
    }

    function testSliceStartGreaterThanEnd() public {
        assertEq(LibString.slice("abcdefg", 5, 2), "");
    }

    function testSliceStartZero() public {
        assertEq(LibString.slice("abcdefg", 0, 3), "abc");
    }

    function testSliceEndLength() public {
        assertEq(LibString.slice("abcdefg", 3, 7), "defg");
    }

    function testSliceStartAndEndOutOfRange() public {
        assertEq(LibString.slice("abcdefg", 10, 20), "");
    }

    function testSliceEmpty() public {
        assertEq(LibString.slice("", 1, 2), "");
    }

//    function testIndicesOfEmptySearch() public {
//        uint256[] memory expected = new uint256[](1);
//        expected[0] = 0;
//        assertEq(LibString.indicesOf("abcdefg", ""), expected);
//    }

    function testIndicesOfEmptySubject() public {
        uint256[] memory expected = new uint256[](0);
        assertEq(LibString.indicesOf("", "a"), expected);
    }

    function testIndicesOfNotFound() public {
        uint256[] memory expected = new uint256[](0);
        assertEq(LibString.indicesOf("abcdefg", "h"), expected);
    }

    function testIndicesOfMultipleOccurrences() public {
        uint256[] memory expected = new uint256[](3);
        expected[0] = 1;
        expected[1] = 4;
        expected[2] = 7;
        assertEq(LibString.indicesOf("abcabcabc", "bc"), expected);
    }

    function testIndicesOfOverlappingMatches() public {
        uint256[] memory expected = new uint256[](2);
        expected[0] = 0;
        expected[1] = 2;
        assertEq(LibString.indicesOf("abab", "ab"), expected);
    }

    function testSplitEmptyDelimiter() public {
        string[] memory expected = new string[](7);
        expected[0] = "a";
        expected[1] = "b";
        expected[2] = "c";
        expected[3] = "d";
        expected[4] = "e";
        expected[5] = "f";
        expected[6] = "g";
        assertEq(LibString.split("abcdefg", ""), expected);
    }

//    function testSplitEmptySubject() public {
//        string[] memory expected = new string[](0);
//        assertEq(LibString.split("", "a"), expected);
//    }

    function testSplitNotFound() public {
        string[] memory expected = new string[](1);
        expected[0] = "abcdefg";
        assertEq(LibString.split("abcdefg", "h"), expected);
    }

    function testSplitMultipleOccurrences() public {
        string[] memory expected = new string[](3);
        expected[0] = "abc";
        expected[1] = "abc";
        expected[2] = "abc";
        assertEq(LibString.split("abc,abc,abc", ","), expected);
    }

//    function testSplitOverlappingMatches() public {
//        string[] memory expected = new string[](1);
//        expected[0] = "a";
//        expected[1] = "b";
//        expected[2] = "";
//        assertEq(LibString.split("aab", "ab"), expected);
//    }

    function testConcatEmpty() public {
        assertEq(LibString.concat("", ""), "");
    }

    function testConcatLeftEmpty() public {
        assertEq(LibString.concat("", "abc"), "abc");
    }

    function testConcatRightEmpty() public {
        assertEq(LibString.concat("abc", ""), "abc");
    }

    function testConcatBothNonEmpty() public {
        assertEq(LibString.concat("abc", "def"), "abcdef");
    }

    function testToCaseLower() public {
        assertEq(LibString.toCase("AbCdEfG", false), "abcdefg");
    }

    function testToCaseUpper() public {
        assertEq(LibString.toCase("AbCdEfG", true), "ABCDEFG");
    }

    function testFromSmallStringEmpty() public {
        assertEq(LibString.fromSmallString(bytes32(0)), "");
    }

    function testNormalizeSmallStringEmpty() public {
        assertEq(LibString.normalizeSmallString(bytes32(0)), bytes32(0));
    }



    function testToSmallStringEmpty() public {
        assertEq(LibString.toSmallString(""), bytes32(0));
    }

    function testToSmallStringNonEmpty() public {
        assertEq(LibString.toSmallString("abc"), bytes32(abi.encodePacked("abc", bytes29(0))));
    }

    function testLower() public {
        assertEq(LibString.lower("AbCdEfG"), "abcdefg");
    }

    function testUpper() public {
        assertEq(LibString.upper("AbCdEfG"), "ABCDEFG");
    }

    function testEscapeHTML() public {
        assertEq(
            LibString.escapeHTML('<>&"\''),
            "&lt;&gt;&amp;&quot;&#39;"
        );
    }

    function testEscapeJSON() public {
        assertEq(
            LibString.escapeJSON("{\"test\": \"123\"}"),
            "{\\\"test\\\": \\\"123\\\"}"
        );
    }

    function testEscapeJSONWithDoubleQuotes() public {
        assertEq(
            LibString.escapeJSON("{\"test\": \"123\"}", true),
            "\"{\\\"test\\\": \\\"123\\\"}\""
        );
    }

    function testEq() public {
        assertTrue(LibString.eq("abc", "abc"));
        assertFalse(LibString.eq("abc", "def"));
    }

    function testEqs() public {
        assertTrue(LibString.eqs("abc", bytes32(abi.encodePacked("abc", bytes29(0)))));
        assertFalse(LibString.eqs("abc", bytes32(abi.encodePacked("def", bytes29(0)))));
    }

//    function testPackOne() public {
//        assertEq(LibString.packOne(""), bytes32(0));
//        assertEq(LibString.packOne("a"), bytes32(uint256(1) << 248));
//        assertEq(LibString.packOne("abcdefghijklmnopqrstuvwxyz123456"), bytes32(0));
//    }

    function testUnpackOne() public {
        assertEq(LibString.unpackOne(bytes32(0)), "");
//        assertEq(LibString.unpackOne(bytes32(uint256(1) << 248)), "a");
    }


}