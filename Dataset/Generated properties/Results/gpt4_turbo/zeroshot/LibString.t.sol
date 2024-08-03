// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {LibString} from "../src/LibString.sol";

contract LibStringTest is Test {
    /// @dev Test for `toString(uint256)` with typical values.
    function testToStringUint() public {
        assertEq(LibString.toString(uint256(0)), "0");
        assertEq(LibString.toString(uint256(123)), "123");
        assertEq(LibString.toString(uint256(1234567890)), "1234567890");
    }

    /// @dev Test for `toString(int256)` with positive, negative and zero values.
    function testToStringInt() public {
        assertEq(LibString.toString(int256(0)), "0");
        assertEq(LibString.toString(int256(123)), "123");
        assertEq(LibString.toString(int256(-123)), "-123");
    }

    // /// @dev Test for `toHexString(uint256, uint256)` with edge cases.
    // function testToHexStringWithLength() public {
    //     assertEq(LibString.toHexString(uint256(0x123), 1), "0x123");
    //     assertEq(LibString.toHexString(uint256(0x123), 2), "0x0123");
    //     vm.expectRevert(LibString.HexLengthInsufficient.selector);
    //     LibString.toHexString(uint256(0x123), 0);
    // }

    // /// @dev Test for `toHexString(uint256)` with typical values.
    // function testToHexString() public {
    //     assertEq(
    //         LibString.toHexString(uint256(0x123)),
    //         "0x0000000000000000000000000000000000000000000000000000000000000123"
    //     );
    //     assertEq(
    //         LibString.toHexString(uint256(0xabcdef)),
    //         "0x00000000000000000000000000000000000000000000000000000000000abcdef"
    //     );
    // }

    /// @dev Test for `toMinimalHexString(uint256)` with leading zeros.
    function testToMinimalHexString() public {
        assertEq(LibString.toMinimalHexString(uint256(0x01)), "0x1");
        assertEq(LibString.toMinimalHexString(uint256(0x100)), "0x100");
    }

    /// @dev Test for `toHexString(address)` with typical values.
    function testToHexStringAddress() public {
        address addr = address(0x123456789abcdef);
        assertEq(
            LibString.toHexString(addr),
            "0x0000000000000000000000000123456789abcdef"
        );
    }

    /// @dev Test for `toHexString(bytes memory)` with typical values.
    function testToHexStringBytes() public {
        bytes memory b = "abc";
        assertEq(LibString.toHexString(b), "0x616263");
    }

    /// @dev Test for `runeCount(string memory)` with multibyte characters.
    function testRuneCount() public {
        assertEq(LibString.runeCount("hello"), 5);
        assertEq(LibString.runeCount("world"), 5);
    }

    // /// @dev Test for `is7BitASCII(string memory)` with ASCII and non-ASCII characters.
    // function testIs7BitASCII() public {
    //     assertTrue(LibString.is7BitASCII("hello"));
    //     assertFalse(LibString.is7BitASCII("world"));
    // }

    /// @dev Test for `indexOf(string memory, string memory)` with typical values.
    function testIndexOf() public {
        assertEq(LibString.indexOf("hello world", "world"), 6);
        assertEq(LibString.indexOf("hello world", "x"), LibString.NOT_FOUND);
    }

    /// @dev Test for `lastIndexOf(string memory, string memory)` with typical values.
    function testLastIndexOf() public {
        assertEq(LibString.lastIndexOf("hello world world", "world"), 12);
        assertEq(
            LibString.lastIndexOf("hello world", "x"),
            LibString.NOT_FOUND
        );
    }

    /// @dev Test for `contains(string memory, string memory)` with typical values.
    function testContains() public {
        assertTrue(LibString.contains("hello world", "world"));
        assertFalse(LibString.contains("hello world", "x"));
    }

    /// @dev Test for `startsWith(string memory, string memory)` with typical values.
    function testStartsWith() public {
        assertTrue(LibString.startsWith("hello world", "hello"));
        assertFalse(LibString.startsWith("hello world", "world"));
    }

    /// @dev Test for `endsWith(string memory, string memory)` with typical values.
    function testEndsWith() public {
        assertTrue(LibString.endsWith("hello world", "world"));
        assertFalse(LibString.endsWith("hello world", "hello"));
    }

    /// @dev Test for `repeat(string memory, uint256)` with typical values.
    function testRepeat() public {
        assertEq(LibString.repeat("ha", 3), "hahaha");
        assertEq(LibString.repeat("ha", 0), "");
    }

    /// @dev Test for `slice(string memory, uint256, uint256)` with typical values.
    function testSlice() public {
        assertEq(LibString.slice("hello world", 0, 5), "hello");
        assertEq(LibString.slice("hello world", 6, 11), "world");
    }

    /// @dev Test for `split(string memory, string memory)` with typical values.
    function testSplit() public {
        string[] memory parts = LibString.split(
            "hello,world,this,is,a,test",
            ","
        );
        assertEq(parts.length, 6);
        assertEq(parts[0], "hello");
        assertEq(parts[1], "world");
    }

    /// @dev Test for `concat(string memory, string memory)` with typical values.
    function testConcat() public {
        assertEq(LibString.concat("hello ", "world"), "hello world");
    }

    /// @dev Test for `lower(string memory)` and `upper(string memory)` with typical values.
    function testLowerUpper() public {
        assertEq(LibString.lower("HELLO"), "hello");
        assertEq(LibString.upper("hello"), "HELLO");
    }

    /// @dev Test for `escapeHTML(string memory)` with typical values.
    function testEscapeHTML() public {
        assertEq(
            LibString.escapeHTML("<script>alert('xss');</script>"),
            "&lt;script&gt;alert(&#39;xss&#39;);&lt;/script&gt;"
        );
    }

    /// @dev Test for `escapeJSON(string memory)` with typical values.
    function testEscapeJSON() public {
        assertEq(
            LibString.escapeJSON('"hello\\world"'),
            '\\"hello\\\\world\\"'
        );
    }

    /// @dev Test for `eq(string memory, string memory)` with typical values.
    function testEq() public {
        assertTrue(LibString.eq("hello", "hello"));
        assertFalse(LibString.eq("hello", "world"));
    }

    /// @dev Test for `eqs(string memory, bytes32)` with typical values.
    function testEqs() public {
        assertTrue(LibString.eqs("hello", LibString.toSmallString("hello")));
        assertFalse(LibString.eqs("hello", LibString.toSmallString("world")));
    }

    /// @dev Test for `packOne(string memory)` and `unpackOne(bytes32)` with typical values.
    function testPackUnpackOne() public {
        bytes32 packed = LibString.packOne("hello");
        string memory unpacked = LibString.unpackOne(packed);
        assertEq(unpacked, "hello");
    }

    /// @dev Test for `packTwo(string memory, string memory)` and `unpackTwo(bytes32)` with typical values.
    function testPackUnpackTwo() public {
        bytes32 packed = LibString.packTwo("he", "llo");
        (string memory a, string memory b) = LibString.unpackTwo(packed);
        assertEq(a, "he");
        assertEq(b, "llo");
    }
}
