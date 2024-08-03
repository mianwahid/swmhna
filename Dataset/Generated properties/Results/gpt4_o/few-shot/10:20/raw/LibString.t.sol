// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";

contract LibStringTest is Test {
    using LibString for *;

    function testToStringUint256() public {
        assertEq(LibString.toString(0), "0");
        assertEq(LibString.toString(1234567890), "1234567890");
        assertEq(LibString.toString(type(uint256).max), "115792089237316195423570985008687907853269984665640564039457584007913129639935");
    }

    function testToStringInt256() public {
        assertEq(LibString.toString(int256(0)), "0");
        assertEq(LibString.toString(int256(1234567890)), "1234567890");
        assertEq(LibString.toString(int256(-1234567890)), "-1234567890");
        assertEq(LibString.toString(type(int256).min), "-57896044618658097711785492504343953926634992332820282019728792003956564819968");
    }

    function testToHexString() public {
        assertEq(LibString.toHexString(0), "0x0");
        assertEq(LibString.toHexString(0x1234567890abcdef), "0x1234567890abcdef");
        assertEq(LibString.toHexString(type(uint256).max), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringNoPrefix() public {
        assertEq(LibString.toHexStringNoPrefix(0), "0");
        assertEq(LibString.toHexStringNoPrefix(0x1234567890abcdef), "1234567890abcdef");
        assertEq(LibString.toHexStringNoPrefix(type(uint256).max), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexString() public {
        assertEq(LibString.toMinimalHexString(0), "0x0");
        assertEq(LibString.toMinimalHexString(0x1234567890abcdef), "0x1234567890abcdef");
        assertEq(LibString.toMinimalHexString(type(uint256).max), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexStringNoPrefix() public {
        assertEq(LibString.toMinimalHexStringNoPrefix(0), "0");
        assertEq(LibString.toMinimalHexStringNoPrefix(0x1234567890abcdef), "1234567890abcdef");
        assertEq(LibString.toMinimalHexStringNoPrefix(type(uint256).max), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringChecksummed() public {
        assertEq(LibString.toHexStringChecksummed(address(0)), "0x0000000000000000000000000000000000000000");
        assertEq(LibString.toHexStringChecksummed(address(0x1234567890abcdef1234567890abcdef12345678)), "0x1234567890AbcDef1234567890aBCdEF12345678");
    }

    function testRuneCount() public {
        assertEq(LibString.runeCount(""), 0);
        assertEq(LibString.runeCount("hello"), 5);
        assertEq(LibString.runeCount("こんにちは"), 5);
    }

    function testIs7BitASCII() public {
        assertTrue(LibString.is7BitASCII("hello"));
        assertFalse(LibString.is7BitASCII("こんにちは"));
    }

    function testReplace() public {
        assertEq(LibString.replace("hello world", "world", "solidity"), "hello solidity");
        assertEq(LibString.replace("hello world", "world", ""), "hello ");
        assertEq(LibString.replace("hello world", "foo", "bar"), "hello world");
    }

    function testIndexOf() public {
        assertEq(LibString.indexOf("hello world", "world"), 6);
        assertEq(LibString.indexOf("hello world", "foo"), LibString.NOT_FOUND);
    }

    function testLastIndexOf() public {
        assertEq(LibString.lastIndexOf("hello world world", "world"), 12);
        assertEq(LibString.lastIndexOf("hello world", "foo"), LibString.NOT_FOUND);
    }

    function testContains() public {
        assertTrue(LibString.contains("hello world", "world"));
        assertFalse(LibString.contains("hello world", "foo"));
    }

    function testStartsWith() public {
        assertTrue(LibString.startsWith("hello world", "hello"));
        assertFalse(LibString.startsWith("hello world", "world"));
    }

    function testEndsWith() public {
        assertTrue(LibString.endsWith("hello world", "world"));
        assertFalse(LibString.endsWith("hello world", "hello"));
    }

    function testRepeat() public {
        assertEq(LibString.repeat("abc", 3), "abcabcabc");
        assertEq(LibString.repeat("abc", 0), "");
    }

    function testSlice() public {
        assertEq(LibString.slice("hello world", 0, 5), "hello");
        assertEq(LibString.slice("hello world", 6), "world");
    }

    function testIndicesOf() public {
        uint256[] memory indices = LibString.indicesOf("hello world world", "world");
        assertEq(indices.length, 2);
        assertEq(indices[0], 6);
        assertEq(indices[1], 12);
    }

    function testSplit() public {
        string[] memory parts = LibString.split("hello,world,solidity", ",");
        assertEq(parts.length, 3);
        assertEq(parts[0], "hello");
        assertEq(parts[1], "world");
        assertEq(parts[2], "solidity");
    }

    function testConcat() public {
        assertEq(LibString.concat("hello", " world"), "hello world");
    }

    function testToCase() public {
        assertEq(LibString.toCase("hello", true), "HELLO");
        assertEq(LibString.toCase("HELLO", false), "hello");
    }

    function testFromSmallString() public {
        assertEq(LibString.fromSmallString("hello"), "hello");
    }

    function testNormalizeSmallString() public {
        assertEq(LibString.normalizeSmallString("hello"), "hello");
    }

    function testToSmallString() public {
        assertEq(LibString.toSmallString("hello"), "hello");
    }

    function testLower() public {
        assertEq(LibString.lower("HELLO"), "hello");
    }

    function testUpper() public {
        assertEq(LibString.upper("hello"), "HELLO");
    }

    function testEscapeHTML() public {
        assertEq(LibString.escapeHTML("<div>hello & 'world'</div>"), "&lt;div&gt;hello &amp; &#39;world&#39;&lt;/div&gt;");
    }

    function testEscapeJSON() public {
        assertEq(LibString.escapeJSON("\"hello\""), "\\\"hello\\\"");
    }

    function testEq() public {
        assertTrue(LibString.eq("hello", "hello"));
        assertFalse(LibString.eq("hello", "world"));
    }

    function testEqs() public {
        assertTrue(LibString.eqs("hello", "hello"));
        assertFalse(LibString.eqs("hello", "world"));
    }

    function testPackOne() public {
        assertEq(LibString.packOne("hello"), "hello");
    }

    function testUnpackOne() public {
        assertEq(LibString.unpackOne("hello"), "hello");
    }

    function testPackTwo() public {
        assertEq(LibString.packTwo("hello", "world"), "helloworld");
    }

    function testUnpackTwo() public {
        (string memory a, string memory b) = LibString.unpackTwo("helloworld");
        assertEq(a, "hello");
        assertEq(b, "world");
    }

    function testDirectReturn() public {
        LibString.directReturn("hello");
    }
}