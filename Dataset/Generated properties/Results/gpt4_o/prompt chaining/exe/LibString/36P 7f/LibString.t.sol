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

    // Custom Errors
    function testHexLengthInsufficient() public {
        uint256 value = 0x123456;
        uint256 length = 1;
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        value.toHexString(length);
    }

    function testTooBigForSmallString() public {
        string memory str = "This string is definitely longer than 32 bytes.";
        vm.expectRevert(LibString.TooBigForSmallString.selector);
        str.toSmallString();
    }

    // Decimal Operations
    function testToStringUint256() public {
        assertEq(uint256(0).toString(), "0");
        assertEq(type(uint256).max.toString(), "115792089237316195423570985008687907853269984665640564039457584007913129639935");
        assertEq(uint256(1234567890).toString(), "1234567890");
    }

    function testToStringInt256() public {
        assertEq(int256(0).toString(), "0");
        assertEq(type(int256).max.toString(), "57896044618658097711785492504343953926634992332820282019728792003956564819967");
        assertEq(type(int256).min.toString(), "-57896044618658097711785492504343953926634992332820282019728792003956564819968");
        assertEq(int256(-1234567890).toString(), "-1234567890");
    }

    // Hexadecimal Operations
    function testToHexStringUint256Length() public {
        assertEq(uint256(0).toHexString(1), "0x00");
        assertEq(type(uint256).max.toHexString(32), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        uint256(0x123456).toHexString(1);
    }

    function testToHexStringNoPrefixUint256Length() public {
        assertEq(uint256(0).toHexStringNoPrefix(1), "00");
        assertEq(type(uint256).max.toHexStringNoPrefix(32), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        uint256(0x123456).toHexStringNoPrefix(1);
    }

    function testToHexStringUint256() public {
        assertEq(uint256(0).toHexString(), "0x00");
        assertEq(type(uint256).max.toHexString(), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexStringUint256() public {
        assertEq(uint256(0).toMinimalHexString(), "0x0");
        assertEq(uint256(1).toMinimalHexString(), "0x1");
        assertEq(uint256(0x123).toMinimalHexString(), "0x123");
    }

    function testToMinimalHexStringNoPrefixUint256() public {
        assertEq(uint256(0).toMinimalHexStringNoPrefix(), "0");
        assertEq(uint256(1).toMinimalHexStringNoPrefix(), "1");
        assertEq(uint256(0x123).toMinimalHexStringNoPrefix(), "123");
    }

    function testToHexStringNoPrefixUint256() public {
        assertEq(uint256(0).toHexStringNoPrefix(), "00");
        assertEq(type(uint256).max.toHexStringNoPrefix(), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringChecksummedAddress() public {
        address addr = 0x1234567890AbcdEF1234567890aBcdef12345678;
        assertEq(addr.toHexStringChecksummed(), "0x1234567890AbcDef1234567890AbcDef12345678");
    }

    function testToHexStringAddress() public {
        address addr = 0x1234567890AbcdEF1234567890aBcdef12345678;
        assertEq(addr.toHexString(), "0x1234567890abcdef1234567890abcdef12345678");
    }

    function testToHexStringNoPrefixAddress() public {
        address addr = 0x1234567890AbcdEF1234567890aBcdef12345678;
        assertEq(addr.toHexStringNoPrefix(), "1234567890abcdef1234567890abcdef12345678");
    }

    function testToHexStringBytes() public {
        bytes memory raw = hex"123456";
        assertEq(raw.toHexString(), "0x123456");
    }

    function testToHexStringNoPrefixBytes() public {
        bytes memory raw = hex"123456";
        assertEq(raw.toHexStringNoPrefix(), "123456");
    }

    // Rune String Operations
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

    // Byte String Operations
    function testReplace() public {
        assertEq(LibString.replace("", "a", "b"), "");
        assertEq(LibString.replace("hello", "x", "y"), "hello");
        assertEq(LibString.replace("hello world", "o", "a"), "hella warld");
    }

    function testIndexOf() public {
        assertEq(LibString.indexOf("", "a"), LibString.NOT_FOUND);
        assertEq(LibString.indexOf("hello", "x"), LibString.NOT_FOUND);
        assertEq(LibString.indexOf("hello world", "o"), 4);
    }

    function testLastIndexOf() public {
        assertEq(LibString.lastIndexOf("", "a"), LibString.NOT_FOUND);
        assertEq(LibString.lastIndexOf("hello", "x"), LibString.NOT_FOUND);
        assertEq(LibString.lastIndexOf("hello world", "o"), 7);
    }

    function testContains() public {
        assertFalse(LibString.contains("", "a"));
        assertFalse(LibString.contains("hello", "x"));
        assertTrue(LibString.contains("hello world", "o"));
    }

    function testStartsWith() public {
        assertFalse(LibString.startsWith("", "a"));
        assertFalse(LibString.startsWith("hello", "x"));
        assertTrue(LibString.startsWith("hello world", "hello"));
    }

    function testEndsWith() public {
        assertFalse(LibString.endsWith("", "a"));
        assertFalse(LibString.endsWith("hello", "x"));
        assertTrue(LibString.endsWith("hello world", "world"));
    }

    function testRepeat() public {
        assertEq(LibString.repeat("", 3), "");
        assertEq(LibString.repeat("hello", 0), "");
        assertEq(LibString.repeat("hello", 3), "hellohellohello");
    }

    function testSlice() public {
        assertEq(LibString.slice("", 0, 1), "");
        assertEq(LibString.slice("hello", 1, 4), "ell");
        assertEq(LibString.slice("hello", 4, 1), "");
    }

    function testIndicesOf() public {
        uint256[] memory indices = LibString.indicesOf("", "a");
        assertEq(indices.length, 0);
        indices = LibString.indicesOf("hello", "x");
        assertEq(indices.length, 0);
        indices = LibString.indicesOf("hello world", "o");
        assertEq(indices.length, 2);
        assertEq(indices[0], 4);
        assertEq(indices[1], 7);
    }

    function testSplit() public {
        string[] memory parts = LibString.split("", " ");
        assertEq(parts.length, 1);
        assertEq(parts[0], "");
        parts = LibString.split("hello", "x");
        assertEq(parts.length, 1);
        assertEq(parts[0], "hello");
        parts = LibString.split("hello world", " ");
        assertEq(parts.length, 2);
        assertEq(parts[0], "hello");
        assertEq(parts[1], "world");
    }

    function testConcat() public {
        assertEq(LibString.concat("", ""), "");
        assertEq(LibString.concat("", "hello"), "hello");
        assertEq(LibString.concat("hello", " world"), "hello world");
    }

    function testToCase() public {
        assertEq(LibString.toCase("", true), "");
        assertEq(LibString.toCase("hello", true), "HELLO");
        assertEq(LibString.toCase("HELLO", false), "hello");
    }

    function testFromSmallString() public {
        bytes32 smallStr = "hello";
        assertEq(LibString.fromSmallString(smallStr), "hello");
    }

    function testNormalizeSmallString() public {
        bytes32 smallStr = "hello";
        assertEq(LibString.normalizeSmallString(smallStr), smallStr);
    }

    function testToSmallString() public {
        string memory str = "hello";
        assertEq(LibString.toSmallString(str), bytes32("hello"));
        vm.expectRevert(LibString.TooBigForSmallString.selector);
        LibString.toSmallString("This string is definitely longer than 32 bytes.");
    }

    function testLower() public {
        assertEq(LibString.lower(""), "");
        assertEq(LibString.lower("HELLO"), "hello");
        assertEq(LibString.lower("HeLLo"), "hello");
    }

    function testUpper() public {
        assertEq(LibString.upper(""), "");
        assertEq(LibString.upper("hello"), "HELLO");
        assertEq(LibString.upper("HeLLo"), "HELLO");
    }

    function testEscapeHTML() public {
        assertEq(LibString.escapeHTML(""), "");
        assertEq(LibString.escapeHTML("hello"), "hello");
        assertEq(LibString.escapeHTML("<div>hello & 'world'</div>"), "&lt;div&gt;hello &amp; &#39;world&#39;&lt;/div&gt;");
    }

    function testEscapeJSON() public {
        assertEq(LibString.escapeJSON("", true), "\"\"");
        assertEq(LibString.escapeJSON("hello", true), "\"hello\"");
        assertEq(LibString.escapeJSON("\"hello\"", true), "\"\\\"hello\\\"\"");
    }

    function testEq() public {
        assertTrue(LibString.eq("", ""));
        assertFalse(LibString.eq("", "hello"));
        assertTrue(LibString.eq("hello", "hello"));
    }

    function testEqs() public {
        bytes32 smallStr = "hello";
        assertTrue(LibString.eqs("hello", smallStr));
        assertFalse(LibString.eqs("world", smallStr));
    }

    function testPackOne() public {
        assertEq(LibString.packOne(""), bytes32(0));
        assertEq(LibString.packOne("hello"), bytes32("hello"));
    }

    function testUnpackOne() public {
        bytes32 packed = bytes32("hello");
        assertEq(LibString.unpackOne(packed), "hello");
        assertEq(LibString.unpackOne(bytes32(0)), "");
    }

    function testPackTwo() public {
        assertEq(LibString.packTwo("", ""), bytes32(0));
        assertEq(LibString.packTwo("hello", "world"), bytes32("helloworld"));
    }

    function testUnpackTwo() public {
        bytes32 packed = bytes32("helloworld");
        (string memory a, string memory b) = LibString.unpackTwo(packed);
        assertEq(a, "hello");
        assertEq(b, "world");
        (a, b) = LibString.unpackTwo(bytes32(0));
        assertEq(a, "");
        assertEq(b, "");
    }

    function testDirectReturn() public {
        string memory str = "hello";
        vm.expectRevert();
        LibString.directReturn(str);
    }
}