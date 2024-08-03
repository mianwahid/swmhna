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

    function testToStringUint256() public {
        assertEq(uint256(0).toString(), "0");
        assertEq(uint256(1234567890).toString(), "1234567890");
        assertEq(uint256(type(uint256).max).toString(), "115792089237316195423570985008687907853269984665640564039457584007913129639935");
    }

    function testToStringInt256() public {
        assertEq(int256(0).toString(), "0");
        assertEq(int256(1234567890).toString(), "1234567890");
        assertEq(int256(-1234567890).toString(), "-1234567890");
        assertEq(int256(type(int256).min).toString(), "-115792089237316195423570985008687907853269984665640564039457584007913129639935");
    }

    function testToHexStringUint256() public {
        assertEq(uint256(0).toHexString(), "0x0");
        assertEq(uint256(1234567890).toHexString(), "0x499602d2");
        assertEq(uint256(type(uint256).max).toHexString(), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToHexStringAddress() public {
        assertEq(address(0).toHexString(), "0x0000000000000000000000000000000000000000");
        assertEq(address(0x1234567890abcdef1234567890abcdef12345678).toHexString(), "0x1234567890abcdef1234567890abcdef12345678");
    }

    function testToMinimalHexStringUint256() public {
        assertEq(uint256(0).toMinimalHexString(), "0x0");
        assertEq(uint256(1234567890).toMinimalHexString(), "0x499602d2");
        assertEq(uint256(type(uint256).max).toMinimalHexString(), "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testToMinimalHexStringNoPrefixUint256() public {
        assertEq(uint256(0).toMinimalHexStringNoPrefix(), "0");
        assertEq(uint256(1234567890).toMinimalHexStringNoPrefix(), "499602d2");
        assertEq(uint256(type(uint256).max).toMinimalHexStringNoPrefix(), "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

//    function testRuneCount() public {
//        assertEq("".runeCount(), 0);
//        assertEq("hello".runeCount(), 5);
//
//    }

//    function testIs7BitASCII() public {
//        assertTrue("hello".is7BitASCII());
//
//    }


//    function testReplace() public {
//        assertEq("hello world".replace("world", "solidity"), "hello solidity");
//        assertEq("hello world".replace("world", ""), "hello ");
//        assertEq("hello world".replace("", "solidity"), "hello world");
//    }

//    function testIndexOf() public {
//        assertEq("hello world".indexOf("world"), 6);
//        assertEq("hello world".indexOf("solidity"), LibString.NOT_FOUND);
//    }

//    function testLastIndexOf() public {
//        assertEq("hello world world".lastIndexOf("world"), 12);
//        assertEq("hello world".lastIndexOf("solidity"), LibString.NOT_FOUND);
//    }

//    function testContains() public {
//        assertTrue("hello world".contains("world"));
//        assertFalse("hello world".contains("solidity"));
//    }
//
//    function testStartsWith() public {
//        assertTrue("hello world".startsWith("hello"));
//        assertFalse("hello world".startsWith("world"));
//    }
//
//    function testEndsWith() public {
//        assertTrue("hello world".endsWith("world"));
//        assertFalse("hello world".endsWith("hello"));
//    }
//
//    function testRepeat() public {
//        assertEq("hello".repeat(3), "hellohellohello");
//        assertEq("hello".repeat(0), "");
//    }
//
//    function testSlice() public {
//        assertEq("hello world".slice(0, 5), "hello");
//        assertEq("hello world".slice(6), "world");
//    }

    function testIndicesOf() public {
        uint256[] memory indices = "hello world world".indicesOf("world");
        assertEq(indices.length, 2);
        assertEq(indices[0], 6);
        assertEq(indices[1], 12);
    }

    function testSplit() public {
        string[] memory parts = "hello world solidity".split(" ");
        assertEq(parts.length, 3);
        assertEq(parts[0], "hello");
        assertEq(parts[1], "world");
        assertEq(parts[2], "solidity");
    }

    function testConcat() public {
        assertEq("hello".concat(" world"), "hello world");
    }

    function testToCase() public {
        assertEq("hello".toCase(true), "HELLO");
        assertEq("HELLO".toCase(false), "hello");
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
        assertEq("HELLO".lower(), "hello");
    }

    function testUpper() public {
        assertEq("hello".upper(), "HELLO");
    }

    function testEscapeHTML() public {
        assertEq("hello <world>".escapeHTML(), "hello &lt;world&gt;");
    }

    function testEscapeJSON() public {
        assertEq("hello \"world\"".escapeJSON(), "hello \\\"world\\\"");
    }

    function testEq() public {
        assertTrue("hello".eq("hello"));
        assertFalse("hello".eq("world"));
    }

    function testEqs() public {
        assertTrue("hello".eqs("hello"));
        assertFalse("hello".eqs("world"));
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
        string memory a = "hello";
        LibString.directReturn(a);
    }
}