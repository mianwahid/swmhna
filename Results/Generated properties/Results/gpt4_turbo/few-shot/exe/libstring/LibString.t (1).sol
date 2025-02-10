// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/LibString.sol";

contract LibStringTest is Test {
    using LibString for string;
    using LibString for uint256;
    using LibString for address;

    function testToStringUint() public {
        uint256 testValue = 1234567890;
        string memory result = testValue.toString();
        assertEq(result, "1234567890");
    }

//    function testToStringInt() public {
//        int256 testValue = -1234567890;
//        string memory result = testValue.toString();
//        assertEq(result, "-1234567890");
//    }

    function testToHexStringUint() public {
        uint256 testValue = 0x1234ABCD;
        string memory result = testValue.toHexString(4);
        assertEq(result, "0x1234abcd");
    }

    function testToHexStringAddress() public {
        address testValue = 0x1234aBCD1234ABCd1234abcD1234ABCd1234aBCD;
        string memory result = testValue.toHexString();
        assertEq(result, "0x1234abcd1234abcd1234abcd1234abcd1234abcd");
    }

    function testToMinimalHexString() public {
        uint256 testValue = 0x01;
        string memory result = testValue.toMinimalHexString();
        assertEq(result, "0x1");
    }

    function testToMinimalHexStringNoPrefix() public {
        uint256 testValue = 0x01;
        string memory result = testValue.toMinimalHexStringNoPrefix();
        assertEq(result, "1");
    }

    function testRuneCount() public {
        string memory testValue = "Hello, World!";
        uint256 result = testValue.runeCount();
        assertEq(result, 13);
    }

    function testIs7BitASCII() public {
        string memory testValue = "Hello, World!";
        bool result = testValue.is7BitASCII();
        assertTrue(result);
    }

    function testReplace() public {
        string memory subject = "Hello, World!";
        string memory search = "World";
        string memory replacement = "Forge";
        string memory result = subject.replace(search, replacement);
        assertEq(result, "Hello, Forge!");
    }

    function testIndexOf() public {
        string memory subject = "Hello, World!";
        string memory search = "World";
        uint256 result = subject.indexOf(search);
        assertEq(result, 7);
    }

    function testLastIndexOf() public {
        string memory subject = "Hello, World, Hello, World!";
        string memory search = "World";
        uint256 result = subject.lastIndexOf(search);
        assertEq(result, 21);
    }

    function testContains() public {
        string memory subject = "Hello, World!";
        string memory search = "World";
        bool result = subject.contains(search);
        assertTrue(result);
    }

    function testStartsWith() public {
        string memory subject = "Hello, World!";
        string memory search = "Hello";
        bool result = subject.startsWith(search);
        assertTrue(result);
    }

    function testEndsWith() public {
        string memory subject = "Hello, World!";
        string memory search = "World!";
        bool result = subject.endsWith(search);
        assertTrue(result);
    }

    function testRepeat() public {
        string memory subject = "abc";
        uint256 times = 3;
        string memory result = subject.repeat(times);
        assertEq(result, "abcabcabc");
    }

    function testSlice() public {
        string memory subject = "Hello, World!";
        uint256 start = 7;
        uint256 end = 12;
        string memory result = subject.slice(start, end);
        assertEq(result, "World");
    }

    function testIndicesOf() public {
        string memory subject = "Hello, World, Hello, World!";
        string memory search = "World";
        uint256[] memory result = subject.indicesOf(search);
        assertEq(result.length, 2);
        assertEq(result[0], 7);
        assertEq(result[1], 21);
    }

    function testSplit() public {
        string memory subject = "Hello, World, Hello, World!";
        string memory delimiter = ",";
        string[] memory result = subject.split(delimiter);
        assertEq(result.length, 4);
        assertEq(result[0], "Hello");
        assertEq(result[1], " World");
        assertEq(result[2], " Hello");
        assertEq(result[3], " World!");
    }

    function testConcat() public {
        string memory a = "Hello, ";
        string memory b = "World!";
        string memory result = a.concat(b);
        assertEq(result, "Hello, World!");
    }

    function testToLower() public {
        string memory subject = "HELLO, WORLD!";
        string memory result = subject.lower();
        assertEq(result, "hello, world!");
    }

    function testToUpper() public {
        string memory subject = "hello, world!";
        string memory result = subject.upper();
        assertEq(result, "HELLO, WORLD!");
    }

    function testEscapeHTML() public {
        string memory subject = "<div>\"Hello, World!\"</div>";
        string memory result = subject.escapeHTML();
        assertEq(result, "&lt;div&gt;&quot;Hello, World!&quot;&lt;/div&gt;");
    }

    function testEscapeJSON() public {
        string memory subject = "\"Hello, World!\"";
        string memory result = subject.escapeJSON();
        assertEq(result, "\\\"Hello, World!\\\"");
    }

    function testEq() public {
        string memory a = "Hello, World!";
        string memory b = "Hello, World!";
        bool result = a.eq(b);
        assertTrue(result);
    }

    function testEqs() public {
        string memory a = "Hello, World!";
        bytes32 b = LibString.toSmallString(a);
        bool result = a.eqs(b);
        assertTrue(result);
    }

    function testPackOne() public {
        string memory a = "Hello";
        bytes32 result = LibString.packOne(a);
        assertEq(result, bytes32(uint256(0x0548656c6c6f0000000000000000000000000000000000000000000000000000)));
    }

    function testUnpackOne() public {
        bytes32 packed = bytes32(uint256(0x0548656c6c6f0000000000000000000000000000000000000000000000000000));
        string memory result = LibString.unpackOne(packed);
        assertEq(result, "Hello");
    }

    function testPackTwo() public {
        string memory a = "Hello";
        string memory b = "World";
        bytes32 result = LibString.packTwo(a, b);
        assertEq(result, bytes32(uint256(0x0548656c6c6f05576f726c640000000000000000000000000000000000000000)));
    }

    function testUnpackTwo() public {
        bytes32 packed = bytes32(uint256(0x0548656c6c6f05576f726c640000000000000000000000000000000000000000));
        (string memory a, string memory b) = LibString.unpackTwo(packed);
        assertEq(a, "Hello");
        assertEq(b, "World");
    }

    function testDirectReturn() public {
        string memory a = "Hello, World!";
        LibString.directReturn(a);
    }
}