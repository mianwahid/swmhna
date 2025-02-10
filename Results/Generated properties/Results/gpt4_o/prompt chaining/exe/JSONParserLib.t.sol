// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for string;
    using JSONParserLib for JSONParserLib.Item;

    // General Invariants
    function testParsingInvalidJSON() public {
        string memory invalidJSON = "{invalid}";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(invalidJSON);
    }

    // parse Function
    function testValidJSONParsing() public {
        string memory validJSON = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(validJSON);
        assertTrue(root.isObject());
    }

    function testEmptyJSONObject() public {
        string memory emptyJSON = "{}";
        JSONParserLib.Item memory root = JSONParserLib.parse(emptyJSON);
        assertTrue(root.isObject());
        assertEq(root.size(), 0);
    }

    function testEmptyJSONArray() public {
        string memory emptyJSON = "[]";
        JSONParserLib.Item memory root = JSONParserLib.parse(emptyJSON);
        assertTrue(root.isArray());
        assertEq(root.size(), 0);
    }

    // value Function
    function testStringValue() public {
        string memory json = '"hello"';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.value(), '"hello"');
    }

    function testNumberValue() public {
        string memory json = '123';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.value(), '123');
    }

    function testBooleanValue() public {
        string memory json = 'true';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.value(), 'true');
    }

    function testNullValue() public {
        string memory json = 'null';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertEq(item.value(), 'null');
    }

    // index Function
    function testArrayIndex() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at(1);
        assertEq(item.index(), 1);
    }

    function testNonArrayIndex() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at('"key"');
        assertEq(item.index(), 0);
    }

    // key Function
    function testObjectKey() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at('"key"');
        assertEq(item.key(), '"key"');
    }

    function testNonObjectKey() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at(1);
        assertEq(item.key(), '');
    }

    // children Function
    function testArrayChildren() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item[] memory children = root.children();
        assertEq(children.length, 3);
    }

    function testObjectChildren() public {
        string memory json = '{"key1": "value1", "key2": "value2"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item[] memory children = root.children();
        assertEq(children.length, 2);
    }

    function testNonArrayObjectChildren() public {
        string memory json = '123';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item[] memory children = root.children();
        assertEq(children.length, 0);
    }

    // size Function
    function testArraySize() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertEq(root.size(), 3);
    }

    function testObjectSize() public {
        string memory json = '{"key1": "value1", "key2": "value2"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertEq(root.size(), 2);
    }

    function testNonArrayObjectSize() public {
        string memory json = '123';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertEq(root.size(), 0);
    }

    // at Function (Array)
    function testValidArrayIndex() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at(1);
        assertEq(item.value(), '2');
    }

    function testInvalidArrayIndex() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at(3);
        assertTrue(item.isUndefined());
    }

    function testNonArrayItem() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at(1);
        assertTrue(item.isUndefined());
    }

    // at Function (Object)
    function testValidObjectKey() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at('"key"');
        assertEq(item.value(), '"value"');
    }

    function testInvalidObjectKey() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at('"invalid"');
        assertTrue(item.isUndefined());
    }

    function testNonObjectItem() public {
        string memory json = '[1, 2, 3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at('"key"');
        assertTrue(item.isUndefined());
    }

    // Type Checking Functions
    function testTypeUndefined() public {
        JSONParserLib.Item memory item;
        assertTrue(item.isUndefined());
    }

    function testTypeArray() public {
        string memory json = '[]';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isArray());
    }

    function testTypeObject() public {
        string memory json = '{}';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isObject());
    }

    function testTypeNumber() public {
        string memory json = '123';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isNumber());
    }

    function testTypeString() public {
        string memory json = '"hello"';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isString());
    }

    function testTypeBoolean() public {
        string memory json = 'true';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isBoolean());
    }

    function testTypeNull() public {
        string memory json = 'null';
        JSONParserLib.Item memory item = JSONParserLib.parse(json);
        assertTrue(item.isNull());
    }

    // parent Function
    function testValidParent() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory item = root.at('"key"');
        JSONParserLib.Item memory parent = item.parent();
        assertTrue(parent.isObject());
    }

    function testNoParent() public {
        string memory json = '{"key": "value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory parent = root.parent();
        assertTrue(parent.isUndefined());
    }

    // Utility Functions
    function testParseValidUint() public {
        string memory uintString = "123";
        uint256 result = JSONParserLib.parseUint(uintString);
        assertEq(result, 123);
    }

    function testParseInvalidUint() public {
        string memory invalidUintString = "abc";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint(invalidUintString);
    }

    function testParseValidInt() public {
        string memory intString = "-123";
        int256 result = JSONParserLib.parseInt(intString);
        assertEq(result, -123);
    }

    function testParseInvalidInt() public {
        string memory invalidIntString = "abc";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseInt(invalidIntString);
    }

    function testParseValidHexUint() public {
        string memory hexString = "0x1a";
        uint256 result = JSONParserLib.parseUintFromHex(hexString);
        assertEq(result, 0x1a);
    }

    function testParseInvalidHexUint() public {
        string memory invalidHexString = "0xzz";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex(invalidHexString);
    }

    function testDecodeValidJSONString() public {
        string memory jsonString = '"hello"';
        string memory result = JSONParserLib.decodeString(jsonString);
        assertEq(result, "hello");
    }

    function testDecodeInvalidJSONString() public {
        string memory invalidJSONString = '"hello';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString(invalidJSONString);
    }
}