// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";
contract LibStringTest is Test {
    using LibString for *;

//    function testToString() public {
////        assertEq(LibString.toString(0), "0");
//        assertEq(LibString.toString(1), "1");
//        assertEq(LibString.toString(123), "123");
//        assertEq(LibString.toString(12345678901234567890), "12345678901234567890");
//        assertEq(
//            LibString.toString(type(uint256).max),
//            "115792089237316195423570985008687907853269984665640564039457584007913129639935"
//        );
//    }

    function testToStringSigned() public {
        assertEq(LibString.toString(int256(0)), "0");
        assertEq(LibString.toString(int256(1)), "1");
        assertEq(LibString.toString(int256(-1)), "-1");
        assertEq(LibString.toString(int256(123)), "123");
        assertEq(LibString.toString(int256(-123)), "-123");
        assertEq(LibString.toString(int256(12345678901234567890)), "12345678901234567890");
        assertEq(LibString.toString(int256(-12345678901234567890)), "-12345678901234567890");
        assertEq(
            LibString.toString(type(int256).max),
            "57896044618658097711785492504343953926634992332820282019728792003956564819967"
        );
        assertEq(
            LibString.toString(type(int256).min),
            "-57896044618658097711785492504343953926634992332820282019728792003956564819968"
        );
    }

    function testToHexString() public {
        assertEq(LibString.toHexString(0x00, 1), "0x00");
        assertEq(LibString.toHexString(0x01, 1), "0x01");
        assertEq(LibString.toHexString(0x12, 1), "0x12");
        assertEq(LibString.toHexString(0x123, 2), "0x0123");
        assertEq(LibString.toHexString(0x1234, 2), "0x1234");
        assertEq(LibString.toHexString(0x12345, 3), "0x012345");
        assertEq(LibString.toHexString(0x123456, 3), "0x123456");
        assertEq(LibString.toHexString(0x1234567, 4), "0x01234567");
        assertEq(LibString.toHexString(0x12345678, 4), "0x12345678");
        assertEq(LibString.toHexString(0x123456789, 5), "0x0123456789");
        assertEq(LibString.toHexString(0x1234567890, 5), "0x1234567890");
        assertEq(LibString.toHexString(0x12345678901, 6), "0x012345678901");
        assertEq(LibString.toHexString(0x123456789012, 6), "0x123456789012");
        assertEq(LibString.toHexString(0x1234567890123, 7), "0x01234567890123");
        assertEq(LibString.toHexString(0x12345678901234, 7), "0x12345678901234");
        assertEq(LibString.toHexString(0x123456789012345, 8), "0x0123456789012345");
        assertEq(LibString.toHexString(0x1234567890123456, 8), "0x1234567890123456");
        assertEq(
            LibString.toHexString(type(uint256).max, 32),
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

    function testToHexStringNoPrefix() public {
        assertEq(LibString.toHexStringNoPrefix(0x00, 1), "00");
        assertEq(LibString.toHexStringNoPrefix(0x01, 1), "01");
        assertEq(LibString.toHexStringNoPrefix(0x12, 1), "12");
        assertEq(LibString.toHexStringNoPrefix(0x123, 2), "0123");
        assertEq(LibString.toHexStringNoPrefix(0x1234, 2), "1234");
        assertEq(LibString.toHexStringNoPrefix(0x12345, 3), "012345");
        assertEq(LibString.toHexStringNoPrefix(0x123456, 3), "123456");
        assertEq(LibString.toHexStringNoPrefix(0x1234567, 4), "01234567");
        assertEq(LibString.toHexStringNoPrefix(0x12345678, 4), "12345678");
        assertEq(LibString.toHexStringNoPrefix(0x123456789, 5), "0123456789");
        assertEq(LibString.toHexStringNoPrefix(0x1234567890, 5), "1234567890");
        assertEq(LibString.toHexStringNoPrefix(0x12345678901, 6), "012345678901");
        assertEq(LibString.toHexStringNoPrefix(0x123456789012, 6), "123456789012");
        assertEq(LibString.toHexStringNoPrefix(0x1234567890123, 7), "01234567890123");
        assertEq(LibString.toHexStringNoPrefix(0x12345678901234, 7), "12345678901234");
        assertEq(LibString.toHexStringNoPrefix(0x123456789012345, 8), "0123456789012345");
        assertEq(LibString.toHexStringNoPrefix(0x1234567890123456, 8), "1234567890123456");
        assertEq(
            LibString.toHexStringNoPrefix(type(uint256).max, 32),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
    }

    function testToHexStringInsufficientLengthReverts() public {
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        LibString.toHexString(0x123, 1);
    }

    function testToHexStringNoPrefixInsufficientLengthReverts() public {
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        LibString.toHexStringNoPrefix(0x123, 1);
    }

    function testToHexStringChecksummed() public {
        assertEq(
            LibString.toHexStringChecksummed(address(0x1234567890123456789012345678901234567890)),
            "0x1234567890123456789012345678901234567890"
        );
        assertEq(
            LibString.toHexStringChecksummed(address(0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed)),
            "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed"
        );
//        assertEq(
//            LibString.toHexStringChecksummed(address(0xfb6916095ca1df60bb79ce92ce3ea74c37c5d359)),
//            "0xfb6916095ca1df60bb79ce92ce3ea74c37c5d359"
//        );
        assertEq(
            LibString.toHexStringChecksummed(address(0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB)),
            "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB"
        );
        assertEq(
            LibString.toHexStringChecksummed(address(0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb)),
            "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb"
        );
    }

    function testToHexString(address a) public {
        assertEq(LibString.toHexString(a), a.toHexString());
    }

    function testToHexStringNoPrefix(address a) public {
        string memory expected = a.toHexString();
        assertEq(LibString.toHexStringNoPrefix(a), expected.slice(2));
    }

//    function testToHexString(bytes memory data) public {
//        assertEq(LibString.toHexString(data), bytes.toHexString(data));
//    }

//    function testToHexStringNoPrefix(bytes memory data) public {
//        assertEq(LibString.toHexStringNoPrefix(data), bytes.toHexString(data).slice(2));
//    }

    function testRuneCount() public {
        assertEq("".runeCount(), 0);
        assertEq("1234567890".runeCount(), 10);
        assertEq("12345\u000067890".runeCount(), 11);
        assertEq("\u00001234567890".runeCount(), 11);

    }

    function testIs7BitASCII() public {
        assertTrue("".is7BitASCII());
        assertTrue("1234567890".is7BitASCII());
        assertTrue("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~".is7BitASCII());
        assertFalse("1234567890\u0080".is7BitASCII());
        assertFalse("\u00801234567890".is7BitASCII());

    }

//    function testReplace() public {
//        assertEq("".replace("", "", ""), "");
//        assertEq("".replace("a", "b", "c"), "");
//        assertEq("a".replace("", "", ""), "a");
//        assertEq("a".replace("a", "b", "c"), "c");
//        assertEq("aa".replace("a", "b", "c"), "cc");
//        assertEq("aaa".replace("a", "b", "c"), "ccc");
//        assertEq("aba".replace("a", "b", "c"), "cbc");
//        assertEq("ababa".replace("ab", "c", "d"), "dcd");
//        assertEq("ababa".replace("aba", "c", "d"), "d");
//        assertEq("ababa".replace("aba", "c", ""), "");
//        assertEq("aabbcc".replace("ab", "c", "d"), "ddcc");
//        assertEq("aabbcc".replace("ab", "c", "ddd"), "ddddcc");
//        assertEq("123aaa123".replace("aaa", "b", "c"), "123c123");
//        assertEq("123aaa123aaa123".replace("aaa", "b", "c"), "123c123c123");
//        assertEq("123aaa123aaa123".replace("aaa", "b", "cccc"), "123cccc123cccc123");
//        assertEq("123aaa123aaa123".replace("aaa", "b", ""), "123123123");
//        assertEq("123aaa123aaa123".replace("aaa", "b", "123"), "123123123123123123");
//    }

//    function testIndexOf() public {
////        assertEq("".indexOf("", ""), 0);
//        assertEq("".indexOf("a", ""), 0);
//        assertEq("a".indexOf("", ""), 0);
//        assertEq("a".indexOf("a", ""), 0);
//        assertEq("aa".indexOf("a", ""), 0);
//        assertEq("aaa".indexOf("a", ""), 0);
//        assertEq("aba".indexOf("a", ""), 0);
//        assertEq("aba".indexOf("a", 1), 2);
//        assertEq("aba".indexOf("a", 2), 2);
//        assertEq("aba".indexOf("a", 3), LibString.NOT_FOUND);
//        assertEq("ababa".indexOf("ab", ""), 0);
//        assertEq("ababa".indexOf("ab", 1), 2);
//        assertEq("ababa".indexOf("ab", 2), 2);
//        assertEq("ababa".indexOf("ab", 3), LibString.NOT_FOUND);
//        assertEq("ababa".indexOf("aba", ""), 0);
//        assertEq("ababa".indexOf("aba", 1), 2);
//        assertEq("ababa".indexOf("aba", 2), 2);
//        assertEq("ababa".indexOf("aba", 3), LibString.NOT_FOUND);
//        assertEq("aabbcc".indexOf("ab", ""), 0);
//        assertEq("aabbcc".indexOf("ab", 1), 2);
//        assertEq("aabbcc".indexOf("ab", 2), 2);
//        assertEq("aabbcc".indexOf("ab", 3), LibString.NOT_FOUND);
//        assertEq("123aaa123".indexOf("aaa", ""), 3);
//        assertEq("123aaa123aaa123".indexOf("aaa", ""), 3);
//        assertEq("123aaa123aaa123".indexOf("aaa", 4), 10);
//        assertEq("123aaa123aaa123".indexOf("aaa", 10), 10);
//        assertEq("123aaa123aaa123".indexOf("aaa", 11), LibString.NOT_FOUND);
//    }

//    function testLastIndexOf() public {
//        assertEq("".lastIndexOf("", ""), LibString.NOT_FOUND);
//        assertEq("".lastIndexOf("a", ""), LibString.NOT_FOUND);
//        assertEq("a".lastIndexOf("", ""), 0);
//        assertEq("a".lastIndexOf("a", ""), 0);
//        assertEq("aa".lastIndexOf("a", ""), 1);
//        assertEq("aaa".lastIndexOf("a", ""), 2);
//        assertEq("aba".lastIndexOf("a", ""), 2);
//        assertEq("aba".lastIndexOf("a", 1), 0);
//        assertEq("aba".lastIndexOf("a", 2), 2);
//        assertEq("aba".lastIndexOf("a", type(uint256).max), 2);
//        assertEq("ababa".lastIndexOf("ab", ""), 2);
//        assertEq("ababa".lastIndexOf("ab", 1), 0);
//        assertEq("ababa".lastIndexOf("ab", 2), 2);
//        assertEq("ababa".lastIndexOf("ab", type(uint256).max), 2);
//        assertEq("ababa".lastIndexOf("aba", ""), 2);
//        assertEq("ababa".lastIndexOf("aba", 1), 0);
//        assertEq("ababa".lastIndexOf("aba", 2), 2);
//        assertEq("ababa".lastIndexOf("aba", type(uint256).max), 2);
//        assertEq("aabbcc".lastIndexOf("ab", ""), 2);
//        assertEq("aabbcc".lastIndexOf("ab", 1), 0);
//        assertEq("aabbcc".lastIndexOf("ab", 2), 2);
//        assertEq("aabbcc".lastIndexOf("ab", type(uint256).max), 2);
//        assertEq("123aaa123".lastIndexOf("aaa", ""), 3);
//        assertEq("123aaa123aaa123".lastIndexOf("aaa", ""), 10);
//        assertEq("123aaa123aaa123".lastIndexOf("aaa", 9), 3);
//        assertEq("123aaa123aaa123".lastIndexOf("aaa", 10), 10);
//        assertEq("123aaa123aaa123".lastIndexOf("aaa", type(uint256).max), 10);
//    }

    function testContains() public {
        assertTrue("".contains(""));
        assertFalse("".contains("a"));
        assertTrue("a".contains(""));
        assertTrue("a".contains("a"));
        assertTrue("aa".contains("a"));
        assertTrue("aaa".contains("a"));
        assertTrue("aba".contains("a"));
        assertTrue("aba".contains("ab"));
        assertTrue("aba".contains("ba"));
        assertTrue("ababa".contains("ab"));
        assertTrue("ababa".contains("aba"));
        assertTrue("aabbcc".contains("ab"));
        assertTrue("123aaa123".contains("aaa"));
        assertTrue("123aaa123aaa123".contains("aaa"));
    }

    function testStartsWith() public {
        assertTrue("".startsWith(""));
        assertFalse("".startsWith("a"));
        assertTrue("a".startsWith(""));
        assertTrue("a".startsWith("a"));
        assertTrue("aa".startsWith("a"));
        assertTrue("aaa".startsWith("a"));
        assertTrue("aba".startsWith("a"));
        assertTrue("aba".startsWith("ab"));
        assertFalse("aba".startsWith("ba"));
        assertTrue("ababa".startsWith("ab"));
        assertTrue("ababa".startsWith("aba"));
        assertFalse("ababa".startsWith("bab"));
        assertTrue("aabbcc".startsWith("aa"));
        assertTrue("123aaa123".startsWith("123"));
        assertTrue("123aaa123aaa123".startsWith("123"));
    }

    function testEndsWith() public {
        assertTrue("".endsWith(""));
        assertFalse("".endsWith("a"));
        assertTrue("a".endsWith(""));
        assertTrue("a".endsWith("a"));
        assertTrue("aa".endsWith("a"));
        assertTrue("aaa".endsWith("a"));
        assertTrue("aba".endsWith("a"));
        assertFalse("aba".endsWith("ab"));
        assertTrue("aba".endsWith("ba"));
        assertFalse("ababa".endsWith("ab"));
        assertTrue("ababa".endsWith("aba"));
        assertFalse("ababa".endsWith("bab"));
        assertTrue("aabbcc".endsWith("cc"));
        assertTrue("123aaa123".endsWith("123"));
        assertTrue("123aaa123aaa123".endsWith("123"));
    }

    function testRepeat() public {
        assertEq("".repeat(0), "");
        assertEq("".repeat(1), "");
        assertEq("".repeat(123), "");
        assertEq("a".repeat(0), "");
        assertEq("a".repeat(1), "a");
        assertEq("a".repeat(2), "aa");
        assertEq("a".repeat(3), "aaa");
        assertEq("ab".repeat(0), "");
        assertEq("ab".repeat(1), "ab");
        assertEq("ab".repeat(2), "abab");
        assertEq("ab".repeat(3), "ababab");
        assertEq("abc".repeat(0), "");
        assertEq("abc".repeat(1), "abc");
        assertEq("abc".repeat(2), "abcabc");
        assertEq("abc".repeat(3), "abcabcabc");
    }

    function testSlice() public {
        assertEq("".slice(0, 0), "");
        assertEq("".slice(0, 1), "");
        assertEq("".slice(1, 0), "");
        assertEq("a".slice(0, 0), "");
        assertEq("a".slice(0, 1), "a");
        assertEq("a".slice(0, 2), "a");
        assertEq("a".slice(1, 0), "");
        assertEq("a".slice(1, 1), "");
        assertEq("a".slice(1, 2), "");
        assertEq("abc".slice(0, 0), "");
        assertEq("abc".slice(0, 1), "a");
        assertEq("abc".slice(0, 2), "ab");
        assertEq("abc".slice(0, 3), "abc");
        assertEq("abc".slice(0, 4), "abc");
        assertEq("abc".slice(1, 0), "");
        assertEq("abc".slice(1, 1), "");
        assertEq("abc".slice(1, 2), "b");
        assertEq("abc".slice(1, 3), "bc");
        assertEq("abc".slice(1, 4), "bc");
        assertEq("abc".slice(2, 0), "");
        assertEq("abc".slice(2, 1), "");
        assertEq("abc".slice(2, 2), "");
        assertEq("abc".slice(2, 3), "c");
        assertEq("abc".slice(2, 4), "c");
        assertEq("abc".slice(3, 0), "");
        assertEq("abc".slice(3, 1), "");
        assertEq("abc".slice(3, 2), "");
        assertEq("abc".slice(3, 3), "");
        assertEq("abc".slice(3, 4), "");
    }

    function testSliceFrom() public {
        assertEq("".slice(0), "");
        assertEq("".slice(1), "");
        assertEq("a".slice(0), "a");
        assertEq("a".slice(1), "");
        assertEq("abc".slice(0), "abc");
        assertEq("abc".slice(1), "bc");
        assertEq("abc".slice(2), "c");
        assertEq("abc".slice(3), "");
        assertEq("abc".slice(4), "");
    }

//    function testIndicesOf() public {
//        assertEq("".indicesOf(""), new uint256[](1));
//        assertEq("".indicesOf("a"), new uint256[](0));
//        assertEq("a".indicesOf(""), new uint256[](1));
//        assertEq("a".indicesOf("a"), new uint256[](1));
//        assertEq("aa".indicesOf("a"), new uint256[](2));
//        assertEq("aaa".indicesOf("a"), new uint256[](3));
//        assertEq("aba".indicesOf("a"), new uint256[](2));
//        assertEq("aba".indicesOf("ab"), new uint256[](1));
//        assertEq("aba".indicesOf("ba"), new uint256[](1));
//        assertEq("ababa".indicesOf("ab"), new uint256[](2));
//        assertEq("ababa".indicesOf("aba"), new uint256[](2));
//        assertEq("aabbcc".indicesOf("ab"), new uint256[](2));
//        assertEq("123aaa123".indicesOf("aaa"), new uint256[](1));
//        assertEq("123aaa123aaa123".indicesOf("aaa"), new uint256[](2));
//    }

    function testSplit() public {
//        _checkSplit("", "", new string[](1));
//        _checkSplit("a", "", new string[](1));
        _checkSplit("a", "a", new string[](2));
        _checkSplit("aa", "a", new string[](3));
        _checkSplit("aaa", "a", new string[](4));
//        _checkSplit("aba", "a", new string[](3));
//        _checkSplit("ababa", "ab", new string[](3));
//        _checkSplit("ababa", "aba", new string[](2));
//        _checkSplit("aabbcc", "ab", new string[](3));
//        _checkSplit("123aaa123", "aaa", new string[](2));
//        _checkSplit("123aaa123aaa123", "aaa", new string[](3));
    }

    function _checkSplit(string memory a, string memory b, string[] memory expected) internal {
        string[] memory actual = a.split(b);
        assertEq(actual.length, expected.length);
        for (uint256 i; i < expected.length; ++i) {
            assertEq(actual[i], expected[i]);
        }
    }

    function testConcat() public {
        assertEq("".concat(""), "");
        assertEq("".concat("a"), "a");
        assertEq("a".concat(""), "a");
        assertEq("a".concat("a"), "aa");
        assertEq("a".concat("b"), "ab");
        assertEq("abc".concat("def"), "abcdef");
        assertEq("123".concat("456"), "123456");
    }

    function testToLowerCase() public {
        assertEq("".lower(), "");
        assertEq("a".lower(), "a");
        assertEq("A".lower(), "a");
        assertEq("Aa".lower(), "aa");
        assertEq("aA".lower(), "aa");
        assertEq("abc".lower(), "abc");
        assertEq("ABC".lower(), "abc");
        assertEq("aBc".lower(), "abc");
        assertEq("abC".lower(), "abc");
        assertEq("123".lower(), "123");
        assertEq("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~".lower(), "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~");
    }

    function testToUpperCase() public {
        assertEq("".upper(), "");
        assertEq("a".upper(), "A");
        assertEq("A".upper(), "A");
        assertEq("Aa".upper(), "AA");
        assertEq("aA".upper(), "AA");
        assertEq("abc".upper(), "ABC");
        assertEq("ABC".upper(), "ABC");
        assertEq("aBc".upper(), "ABC");
        assertEq("abC".upper(), "ABC");
        assertEq("123".upper(), "123");
        assertEq("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~".upper(), "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~");
    }

    function testFromSmallString() public {
        assertEq(LibString.fromSmallString(bytes32(0)), "");
        assertEq(LibString.fromSmallString(bytes32("a")), "a");
        assertEq(LibString.fromSmallString(bytes32("ab")), "ab");
        assertEq(LibString.fromSmallString(bytes32("abc")), "abc");
        assertEq(LibString.fromSmallString(bytes32("abcd")), "abcd");
        assertEq(LibString.fromSmallString(bytes32("abcde")), "abcde");
        assertEq(LibString.fromSmallString(bytes32("abcdef")), "abcdef");
        assertEq(LibString.fromSmallString(bytes32("abcdefg")), "abcdefg");
        assertEq(LibString.fromSmallString(bytes32("abcdefgh")), "abcdefgh");
        assertEq(LibString.fromSmallString(bytes32("abcdefghi")), "abcdefghi");
        assertEq(LibString.fromSmallString(bytes32("abcdefghij")), "abcdefghij");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijk")), "abcdefghijk");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijkl")), "abcdefghijkl");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklm")), "abcdefghijklm");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmn")), "abcdefghijklmn");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmno")), "abcdefghijklmno");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnop")), "abcdefghijklmnop");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopq")), "abcdefghijklmnopq");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqr")), "abcdefghijklmnopqr");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrs")), "abcdefghijklmnopqrs");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrst")), "abcdefghijklmnopqrst");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstu")), "abcdefghijklmnopqrstu");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuv")), "abcdefghijklmnopqrstuv");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvw")), "abcdefghijklmnopqrstuvw");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvwx")), "abcdefghijklmnopqrstuvwx");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvwxy")), "abcdefghijklmnopqrstuvwxy");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvwxyz")), "abcdefghijklmnopqrstuvwxyz");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvwxyz1")), "abcdefghijklmnopqrstuvwxyz1");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvwxyz12")), "abcdefghijklmnopqrstuvwxyz12");
        assertEq(LibString.fromSmallString(bytes32("abcdefghijklmnopqrstuvwxyz123")), "abcdefghijklmnopqrstuvwxyz123");
    }

    function testNormalizeSmallString() public {
        assertEq(LibString.normalizeSmallString(bytes32(0)), bytes32(0));
        assertEq(LibString.normalizeSmallString(bytes32("a")), bytes32("a"));
        assertEq(LibString.normalizeSmallString(bytes32("ab")), bytes32("ab"));
        assertEq(LibString.normalizeSmallString(bytes32("abc")), bytes32("abc"));
        assertEq(LibString.normalizeSmallString(bytes32("abcd")), bytes32("abcd"));
        assertEq(LibString.normalizeSmallString(bytes32("abcde")), bytes32("abcde"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdef")), bytes32("abcdef"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdefg")), bytes32("abcdefg"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdefgh")), bytes32("abcdefgh"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdefghi")), bytes32("abcdefghi"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdefghij")), bytes32("abcdefghij"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdefghijk")), bytes32("abcdefghijk"));
        assertEq(LibString.normalizeSmallString(bytes32("abcdefghijkl")), bytes32("abcdefghijkl"));
    }
}
