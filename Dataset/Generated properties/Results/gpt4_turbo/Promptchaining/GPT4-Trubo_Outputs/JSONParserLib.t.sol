// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for JSONParserLib.Item;

    function testParseValidJSON() public {
        string memory json = '{"name":"John", "age":30, "city":"New York"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isObject());
    }

    function testParseEmptyJSON() public {
        string memory json = '{}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isObject());
        assertEq(item.size(), 0);
    }

    function testParseInvalidJSON() public {
        string memory json = '{"name": "John", "age": 30,}';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(json);
    }

    function testValueStringItem() public {
        string memory json = '{"greeting": "Hello, world!"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        JSONParserLib.Item memory greeting = item.at('"greeting"');
        assertEq(greeting.value(), '"Hello, world!"');
    }

    function testIndexInArray() public {
        string memory json = '["apple", "banana", "cherry"]';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.at(1).value(), '"banana"');
        assertEq(item.at(1).index(), 1);
    }

    function testKeyInObject() public {
        string memory json = '{"fruit": "apple", "color": "green"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.at('"fruit"').key(), '"fruit"');
    }

    function testChildrenInArray() public {
        string memory json = '["apple", "banana", "cherry"]';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        JSONParserLib.Item[] memory children = item.children();
        assertEq(children.length, 3);
        assertEq(children[0].value(), '"apple"');
    }

    function testSizeOfObject() public {
        string memory json = '{"fruit": "apple", "color": "green"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.size(), 2);
    }

    function testTypeChecks() public {
        string memory json = '{"number": 123, "string": "text", "boolean": true, "null": null}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.at('"number"').isNumber());
        assertTrue(item.at('"string"').isString());
        assertTrue(item.at('"boolean"').isBoolean());
        assertTrue(item.at('"null"').isNull());
    }

    function testParent() public {
        string memory json = '{"data": {"number": 123}}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        JSONParserLib.Item memory data = item.at('"data"');
        JSONParserLib.Item memory number = data.at('"number"');
        assertTrue(number.parent().isObject());
    }

    function testParseUint() public {
        string memory uintStr = "12345";
        uint256 number = JSONParserLib.parseUint(uintStr);
        assertEq(number, 12345);
    }

    function testParseInt() public {
        string memory intStr = "-12345";
        int256 number = JSONParserLib.parseInt(intStr);
        assertEq(number, -12345);
    }

    function testParseUintFromHex() public {
        string memory hexStr = "0x1a3f";
        uint256 number = JSONParserLib.parseUintFromHex(hexStr);
        assertEq(number, 0x1a3f);
    }

    function testDecodeString() public {
        string memory encodedStr = '"Hello, \\"world\\"!"';
        string memory decodedStr = JSONParserLib.decodeString(encodedStr);
        assertEq(decodedStr, 'Hello, "world"!');
    }
}
