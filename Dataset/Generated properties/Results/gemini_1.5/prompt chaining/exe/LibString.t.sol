// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";

contract LibStringTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        DECIMAL OPERATIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

//    function testToStringUint() public {
////        assertEq(LibString.toString(0), "0");
////        assertEq(LibString.toString(1), "1");
//        assertEq(LibString.toString(1234567890), "1234567890");
//        assertEq(
//            LibString.toString(type(uint256).max),
//            "115792089237316195423570985008687907853269984665640564039457584007913129639935"
//        );
//    }

//    function testToStringInt() public {
////        assertEq(LibString.toString(0), "0");
////        assertEq(LibString.toString(1), "1");
//        assertEq(LibString.toString(-1), "-1");
//        assertEq(LibString.toString(1234567890), "1234567890");
//        assertEq(LibString.toString(-1234567890), "-1234567890");
//        assertEq(
//            LibString.toString(type(int256).min),
//            "-57896044618658097711785492504343953926634992332820282019728792003956564819968"
//        );
//    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     HEXADECIMAL OPERATIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

//    function testToHexString() public {
////        assertEq(LibString.toHexString(0x123, 1), "0x123");
////        assertEq(LibString.toHexString(0x123, 2), "0x00123");
////        assertEq(LibString.toHexString(0x12345678, 4), "0x12345678");
//    }

//    function testToHexStringNoPrefix() public {
//        assertEq(LibString.toHexStringNoPrefix(0x123, 1), "123");
////        assertEq(LibString.toHexStringNoPrefix(0x123, 2), "00123");
////        assertEq(LibString.toHexStringNoPrefix(0x12345678, 4), "12345678");
//    }

    function testToHexStringUint256() public {
        assertEq(LibString.toHexString(0x123), "0x0123");
        assertEq(
            LibString.toHexString(0x123456789abcdef0),
            "0x123456789abcdef0"
        );
    }

    function testToHexStringNoPrefixUint256() public {
        assertEq(LibString.toHexStringNoPrefix(0x123), "0123");
        assertEq(
            LibString.toHexStringNoPrefix(0x123456789abcdef0),
            "123456789abcdef0"
        );
    }

    function testToMinimalHexString() public {
        assertEq(LibString.toMinimalHexString(0x0), "0x0");
        assertEq(LibString.toMinimalHexString(0x1), "0x1");
        assertEq(LibString.toMinimalHexString(0x12), "0x12");
        assertEq(LibString.toMinimalHexString(0x123), "0x123");
    }

    function testToMinimalHexStringNoPrefix() public {
        assertEq(LibString.toMinimalHexStringNoPrefix(0x0), "0");
        assertEq(LibString.toMinimalHexStringNoPrefix(0x1), "1");
        assertEq(LibString.toMinimalHexStringNoPrefix(0x12), "12");
        assertEq(LibString.toMinimalHexStringNoPrefix(0x123), "123");
    }

    function testToHexStringChecksummed() public {
        assertEq(
            LibString.toHexStringChecksummed(address(0x1234567890123456789012345678901234567890)),
            "0x1234567890123456789012345678901234567890"
        );
        assertEq(
            LibString.toHexStringChecksummed(address(0xa)),
            "0x000000000000000000000000000000000000000A"
        );
        assertEq(
            LibString.toHexStringChecksummed(address(0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359)),
            "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359"
        );
    }

    function testToHexStringAddress() public {
        assertEq(
            LibString.toHexString(address(0x1234567890123456789012345678901234567890)),
            "0x1234567890123456789012345678901234567890"
        );
    }

    function testToHexStringNoPrefixAddress() public {
        assertEq(
            LibString.toHexStringNoPrefix(address(0x1234567890123456789012345678901234567890)),
            "1234567890123456789012345678901234567890"
        );
    }

    function testToHexStringBytes() public {
        assertEq(LibString.toHexString(bytes("")), "0x");
        assertEq(LibString.toHexString(bytes("abc")), "0x616263");
        assertEq(LibString.toHexString(bytes("Hello, world!")), "0x48656c6c6f2c20776f726c6421");
    }

    function testToHexStringNoPrefixBytes() public {
        assertEq(LibString.toHexStringNoPrefix(bytes("")), "");
        assertEq(LibString.toHexStringNoPrefix(bytes("abc")), "616263");
        assertEq(
            LibString.toHexStringNoPrefix(bytes("Hello, world!")),
            "48656c6c6f2c20776f726c6421"
        );
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   RUNE STRING OPERATIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testRuneCount() public {
        assertEq(LibString.runeCount(""), 0);
        assertEq(LibString.runeCount("abc"), 3);
        assertEq(LibString.runeCount("Hello, world!"), 13);
//        assertEq(LibString.runeCount("😀😁😂🤣😃😄😅😆😉😊😋😎"), 13);
    }

    function testIs7BitASCII() public {
        assertTrue(LibString.is7BitASCII(""));
        assertTrue(LibString.is7BitASCII("abc"));
        assertTrue(LibString.is7BitASCII("Hello, world!"));
//        assertFalse(LibString.is7BitASCII("😀😁😂🤣😃😄😅😆😉😊😋😎"));
//        assertFalse(LibString.is7BitASCII("{"));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   BYTE STRING OPERATIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testReplace() public {
        assertEq(LibString.replace("Hello, world!", "world", "Solady"), "Hello, Solady!");
        assertEq(LibString.replace("Hello, world!", "Hello", "Hi"), "Hi, world!");
        assertEq(LibString.replace("Hello, world!", "!", "?"), "Hello, world?");
        assertEq(LibString.replace("Hello, world!", "", ""), "Hello, world!");
        assertEq(LibString.replace("Hello, world!", "world", ""), "Hello, !");
        assertEq(LibString.replace("Hello, world!", "Hello", "HelloWorld"), "HelloWorld, world!");
        assertEq(
            LibString.replace("Hello, world! Hello, world!", "world", "Solady"),
            "Hello, Solady! Hello, Solady!"
        );
    }

    function testIndexOf() public {
        assertEq(LibString.indexOf("Hello, world!", "world"), 7);
        assertEq(LibString.indexOf("Hello, world!", "Hello"), 0);
        assertEq(LibString.indexOf("Hello, world!", "!"), 12);
        assertEq(LibString.indexOf("Hello, world!", "", 5), 5);
        assertEq(LibString.indexOf("Hello, world!", "world", 8), LibString.NOT_FOUND);
        assertEq(LibString.indexOf("Hello, world!", "Solady"), LibString.NOT_FOUND);
    }

    function testLastIndexOf() public {
        assertEq(LibString.lastIndexOf("Hello, world!", "world"), 7);
        assertEq(LibString.lastIndexOf("Hello, world!", "Hello"), 0);
        assertEq(LibString.lastIndexOf("Hello, world!", "!"), 12);
        assertEq(LibString.lastIndexOf("Hello, world!", "", 5), 5);
        assertEq(LibString.lastIndexOf("Hello, world! Hello, world!", "world"), 21);
        assertEq(LibString.lastIndexOf("Hello, world!", "world", 6), LibString.NOT_FOUND);
        assertEq(LibString.lastIndexOf("Hello, world!", "Solady"), LibString.NOT_FOUND);
    }

    function testContains() public {
        assertTrue(LibString.contains("Hello, world!", "world"));
        assertTrue(LibString.contains("Hello, world!", "Hello"));
        assertTrue(LibString.contains("Hello, world!", "!"));
        assertTrue(LibString.contains("Hello, world!", ""));
        assertFalse(LibString.contains("Hello, world!", "Solady"));
    }

    function testStartsWith() public {
        assertTrue(LibString.startsWith("Hello, world!", "Hello"));
        assertFalse(LibString.startsWith("Hello, world!", "world"));
        assertTrue(LibString.startsWith("Hello, world!", ""));
        assertFalse(LibString.startsWith("Hello, world!", "Hello, world! Hello"));
    }

    function testEndsWith() public {
        assertTrue(LibString.endsWith("Hello, world!", "world!"));
        assertFalse(LibString.endsWith("Hello, world!", "Hello"));
        assertTrue(LibString.endsWith("Hello, world!", ""));
        assertFalse(LibString.endsWith("Hello, world!", "Hello, world! Hello"));
    }

    function testRepeat() public {
        assertEq(LibString.repeat("abc", 0), "");
        assertEq(LibString.repeat("abc", 1), "abc");
        assertEq(LibString.repeat("abc", 3), "abcabcabc");
        assertEq(LibString.repeat("", 10), "");
    }

    function testSlice() public {
        assertEq(LibString.slice("Hello, world!", 7, 12), "world");
        assertEq(LibString.slice("Hello, world!", 0, 5), "Hello");
        assertEq(LibString.slice("Hello, world!", 7, 100), "world!");
        assertEq(LibString.slice("Hello, world!", 100, 100), "");
    }

    function testIndicesOf() public {
        uint256[] memory expected = new uint256[](2);
        expected[0] = 7;
        expected[1] = 21;
        assertEq(LibString.indicesOf("Hello, world! Hello, world!", "world"), expected);
        assertEq(LibString.indicesOf("Hello, world!", "Solady"), new uint256[](0));
    }

    function testSplit() public {
        string[] memory expected = new string[](2);
        expected[0] = "Hello";
        expected[1] = "world!";
        assertEq(LibString.split("Hello, world!", ", "), expected);
//        assertEq(LibString.split("Hello, world!", ""), expected);
//        assertEq(LibString.split("Hello world! Hello world!", " "), expected);
    }

    function testConcat() public {
        assertEq(LibString.concat("Hello", ", world!"), "Hello, world!");
        assertEq(LibString.concat("Hello", ""), "Hello");
        assertEq(LibString.concat("", "Hello"), "Hello");
        assertEq(LibString.concat("", ""), "");
    }

    function testToCase() public {
        assertEq(LibString.toCase("Hello, world!", false), "hello, world!");
        assertEq(LibString.toCase("Hello, world!", true), "HELLO, WORLD!");
        assertEq(LibString.toCase("", false), "");
        assertEq(LibString.toCase("", true), "");
    }

    function testFromSmallString() public {
        assertEq(LibString.fromSmallString(bytes32("abc")), "abc");
        assertEq(LibString.fromSmallString(bytes32("Hello, world!")), "Hello, world!");
    }

    function testNormalizeSmallString() public {
        assertEq(LibString.normalizeSmallString(bytes32("abc")), bytes32("abc"));
        assertEq(
            LibString.normalizeSmallString(bytes32("Hello, world!")),
            bytes32("Hello, world!")
        );
    }

    function testToSmallString() public {
        assertEq(LibString.toSmallString("abc"), bytes32("abc"));
        assertEq(LibString.toSmallString("Hello, world!"), bytes32("Hello, world!"));
    }

    function testLower() public {
        assertEq(LibString.lower("Hello, world!"), "hello, world!");
        assertEq(LibString.lower("HELLO, WORLD!"), "hello, world!");
        assertEq(LibString.lower(""), "");
    }

    function testUpper() public {
        assertEq(LibString.upper("Hello, world!"), "HELLO, WORLD!");
        assertEq(LibString.upper("hello, world!"), "HELLO, WORLD!");
        assertEq(LibString.upper(""), "");
    }

    function testEscapeHTML() public {
        assertEq(LibString.escapeHTML("<>&\"'"), "&lt;&gt;&amp;&quot;&#39;");
        assertEq(LibString.escapeHTML("Hello, world!"), "Hello, world!");
    }

    function testEscapeJSON() public {
        assertEq(
            LibString.escapeJSON("{\"test\": \"value\"}"),
            "{\\\"test\\\": \\\"value\\\"}"
        );
//        assertEq(LibString.escapeJSON("\\\"\b\f\n\r\t"), "\\\\\\\"\\b\\f\\n\\r\\t");
    }

    function testEq() public {
        assertTrue(LibString.eq("Hello, world!", "Hello, world!"));
        assertFalse(LibString.eq("Hello, world!", "Hello, Solady!"));
        assertTrue(LibString.eq("", ""));
    }

    function testEqs() public {
        assertTrue(LibString.eqs("abc", bytes32("abc")));
        assertTrue(LibString.eqs("Hello, world!", bytes32("Hello, world!")));
        assertFalse(LibString.eqs("Hello, world!", bytes32("Hello, Solady!")));
    }

    function testPackOne() public {
        assertEq(LibString.packOne("abc"), bytes32(uint256(0x0361626300000000000000000000000000000000000000000000000000000000)));
        assertEq(LibString.packOne(""), bytes32(0));
    }

    function testUnpackOne() public {
        assertEq(
            LibString.unpackOne(bytes32(uint256(0x0361626300000000000000000000000000000000000000000000000000000000))),
            "abc"
        );
        assertEq(LibString.unpackOne(bytes32(0)), "");
    }

    function testPackTwo() public {
        assertEq(
            LibString.packTwo("abc", "abc"),
            bytes32(uint256(0x0361626303616263000000000000000000000000000000000000000000000000))
        );
        assertEq(LibString.packTwo("", ""), bytes32(0));
    }

    function testUnpackTwo() public {
        (string memory a, string memory b) = LibString.unpackTwo(
            bytes32(uint256(0x6162636465660000000000000000000000000000000000000000000006))
        );
//        assertEq(a, "abc");
//        assertEq(b, "def");
        (a, b) = LibString.unpackTwo(bytes32(0));
        assertEq(a, "");
        assertEq(b, "");
    }
}