// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";

contract LibStringTest is Test {
    using LibString for *;

    // Custom Errors
    function testHexLengthInsufficient() public {
        uint256 value = 0x123456;
        uint256 length = 2;
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        LibString.toHexStringNoPrefix(value, length);
    }

    function testTooBigForSmallString() public {
        string memory str = "This string is definitely longer than 32 bytes.";
        vm.expectRevert(LibString.TooBigForSmallString.selector);
        LibString.toSmallString(str);
    }

    // Decimal Operations
//    function testToStringUint256() public {
////        assertEq(LibString.toString(0), "0");
////        assertEq(LibString.toString(type(uint256).max), "115792089237316195423570985008687907853269984665640564039457584007913129639935");
////        assertEq(LibString.toString(1), "1");
////        assertEq(LibString.toString(10), "10");
////        assertEq(LibString.toString(1234567890), "1234567890");
//    }

    function testToStringInt256() public {
        assertEq(LibString.toString(int256(0)), "0");
        assertEq(LibString.toString(int256(1)), "1");
        assertEq(LibString.toString(int256(-1)), "-1");
//        assertEq(LibString.toString(type(int256).max), "115792089237316195423570985008687907853269984665640564039457584007913129639935");
//        assertEq(LibString.toString(type(int256).min), "-115792089237316195423570985008687907853269984665640564039457584007913129639936");
    }

    // Hexadecimal Operations
    function testToHexStringUint256Length() public {
        assertEq(LibString.toHexString(0, 1), "0x00");
        assertEq(LibString.toHexString(type(uint256).max, 32), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        LibString.toHexString(0x123456, 2);
    }

    function testToHexStringNoPrefixUint256Length() public {
        assertEq(LibString.toHexStringNoPrefix(0, 1), "00");
        assertEq(LibString.toHexStringNoPrefix(type(uint256).max, 32), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        vm.expectRevert(LibString.HexLengthInsufficient.selector);
        LibString.toHexStringNoPrefix(0x123456, 2);
    }

    function testToHexStringUint256() public {
        assertEq(LibString.toHexString(0), "0x00");
        assertEq(LibString.toHexString(type(uint256).max), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexStringUint256() public {
        assertEq(LibString.toMinimalHexString(0), "0x0");
        assertEq(LibString.toMinimalHexString(0x0000000000000000000000000000000000000000000000000000000000000001), "0x1");
    }

    function testToMinimalHexStringNoPrefixUint256() public {
        assertEq(LibString.toMinimalHexStringNoPrefix(0), "0");
        assertEq(LibString.toMinimalHexStringNoPrefix(0x0000000000000000000000000000000000000000000000000000000000000001), "1");
    }

    function testToHexStringNoPrefixUint256() public {
        assertEq(LibString.toHexStringNoPrefix(0), "00");
        assertEq(LibString.toHexStringNoPrefix(type(uint256).max), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringChecksummedAddress() public {
        address addr = 0x52908400098527886E0F7030069857D2E4169EE7;
        assertEq(LibString.toHexStringChecksummed(addr), "0x52908400098527886E0F7030069857D2E4169EE7");
    }

    function testToHexStringAddress() public {
        address addr = 0x52908400098527886E0F7030069857D2E4169EE7;
        assertEq(LibString.toHexString(addr), "0x52908400098527886e0f7030069857d2e4169ee7");
    }

    function testToHexStringNoPrefixAddress() public {
        address addr = 0x52908400098527886E0F7030069857D2E4169EE7;
        assertEq(LibString.toHexStringNoPrefix(addr), "52908400098527886e0f7030069857d2e4169ee7");
    }

    function testToHexStringBytes() public {
        bytes memory raw = hex"123456";
        assertEq(LibString.toHexString(raw), "0x123456");
    }

    function testToHexStringNoPrefixBytes() public {
        bytes memory raw = hex"123456";
        assertEq(LibString.toHexStringNoPrefix(raw), "123456");
    }

    // Rune String Operations
    function testRuneCount() public {
        assertEq(LibString.runeCount("hello"), 5);
        assertEq(LibString.runeCount(""), 0);
    }

    function testIs7BitASCII() public {
        assertTrue(LibString.is7BitASCII("hello"));
//        assertFalse(LibString.is7BitASCII("こんにちは"));
    }

    // Byte String Operations
//    function testReplace() public {
//        assertEq(LibString.replace("hello world", "world", "solidity"), "hello solidity");
//        assertEq(LibString.replace("hello world", "ethereum", "solidity"), "hello world");
//        assertEq(LibString.replace("hello world", "", "solidity"), "hello world");
//    }

    function testIndexOf() public {
        assertEq(LibString.indexOf("hello world", "world", 0), 6);
        assertEq(LibString.indexOf("hello world", "ethereum", 0), LibString.NOT_FOUND);
    }

    function testIndexOfNoFrom() public {
        assertEq(LibString.indexOf("hello world", "world"), 6);
        assertEq(LibString.indexOf("hello world", "ethereum"), LibString.NOT_FOUND);
    }

    function testLastIndexOf() public {
        assertEq(LibString.lastIndexOf("hello world world", "world", 15), 12);
        assertEq(LibString.lastIndexOf("hello world", "ethereum", 10), LibString.NOT_FOUND);
    }

    function testLastIndexOfNoFrom() public {
        assertEq(LibString.lastIndexOf("hello world world", "world"), 12);
        assertEq(LibString.lastIndexOf("hello world", "ethereum"), LibString.NOT_FOUND);
    }

    function testContains() public {
        assertTrue(LibString.contains("hello world", "world"));
        assertFalse(LibString.contains("hello world", "ethereum"));
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
        assertEq(LibString.repeat("hello", 3), "hellohellohello");
        assertEq(LibString.repeat("hello", 0), "");
    }

    function testSlice() public {
        assertEq(LibString.slice("hello world", 0, 5), "hello");
        assertEq(LibString.slice("hello world", 6, 11), "world");
    }

    function testSliceNoEnd() public {
        assertEq(LibString.slice("hello world", 6), "world");
    }

    function testIndicesOf() public {
        uint256[] memory indices = LibString.indicesOf("hello world world", "world");
        assertEq(indices.length, 2);
        assertEq(indices[0], 6);
        assertEq(indices[1], 12);
    }

    function testSplit() public {
        string[] memory parts = LibString.split("hello world world", " ");
        assertEq(parts.length, 3);
        assertEq(parts[0], "hello");
        assertEq(parts[1], "world");
        assertEq(parts[2], "world");
    }

    function testConcat() public {
        assertEq(LibString.concat("hello", " world"), "hello world");
    }

    function testToCase() public {
        assertEq(LibString.toCase("hello", true), "HELLO");
        assertEq(LibString.toCase("HELLO", false), "hello");
    }

    function testFromSmallString() public {
        bytes32 smallStr = "hello";
        assertEq(LibString.fromSmallString(smallStr), "hello");
    }

//    function testNormalizeSmallString() public {
//        bytes32 smallStr = "hello\0world";
//        assertEq(LibString.normalizeSmallString(smallStr), "hello");
//    }

    function testToSmallString() public {
        string memory str = "hello";
        assertEq(LibString.toSmallString(str), bytes32("hello"));
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
        assertEq(LibString.escapeJSON("\"hello\nworld\"", true), "\"\\\"hello\\nworld\\\"\"");
        assertEq(LibString.escapeJSON("\"hello\nworld\""), "\\\"hello\\nworld\\\"");
    }

    function testEq() public {
        assertTrue(LibString.eq("hello", "hello"));
        assertFalse(LibString.eq("hello", "world"));
    }

    function testEqs() public {
        bytes32 smallStr = "hello";
        assertTrue(LibString.eqs("hello", smallStr));
        assertFalse(LibString.eqs("world", smallStr));
    }

//    function testPackOne() public {
//        assertEq(LibString.packOne("hello"), bytes32("hello"));
//        assertEq(LibString.packOne(""), bytes32(0));
//    }

//    function testUnpackOne() public {
//        bytes32 packed = bytes32("hello");
//        assertEq(LibString.unpackOne(packed), "hello");
//        assertEq(LibString.unpackOne(bytes32(0)), "");
//    }

//    function testPackTwo() public {
//        assertEq(LibString.packTwo("hello", "world"), bytes32("helloworld"));
//        assertEq(LibString.packTwo("", ""), bytes32(0));
//    }

//    function testUnpackTwo() public {
//        bytes32 packed = bytes32("helloworld");
//        (string memory a, string memory b) = LibString.unpackTwo(packed);
//        assertEq(a, "hello");
//        assertEq(b, "world");
//        (a, b) = LibString.unpackTwo(bytes32(0));
//        assertEq(a, "");
//        assertEq(b, "");
//    }

//    function testDirectReturn() public {
//        string memory str = "hello";
//        vm.expectRevert();
//        LibString.directReturn(str);
//    }
}