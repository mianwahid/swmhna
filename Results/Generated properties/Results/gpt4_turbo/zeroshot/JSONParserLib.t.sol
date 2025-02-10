// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {JSONParserLib} from "../src/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for JSONParserLib.Item;

    function testParseValidJSONString() public {
        string memory jsonString = '{"name":"John", "age":30, "city":"New York"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
    }

    function testParseInvalidJSONString() public {
        string memory jsonString = '{"name": "John", "age": 30, "city": "New York"';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(jsonString);
    }

    function testParseEmptyJSONObject() public {
        string memory jsonString = '{}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        assertEq(item.size(), 0, "Object should have no children");
    }

    function testParseEmptyJSONArray() public {
        string memory jsonString = '[]';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isArray(), "Parsed item should be an array");
        assertEq(item.size(), 0, "Array should have no elements");
    }

    function testParseNestedJSON() public {
        string memory jsonString = '{"person": {"name": "John", "age": 30}, "city": "New York"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory person = item.at('"person"');
        assertTrue(person.isObject(), "Nested 'person' should be an object");
        assertEq(person.size(), 2, "Person object should have two properties");
    }

    function testParseJSONWithArray() public {
        string memory jsonString = '{"data": [1, 2, 3]}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory data = item.at('"data"');
        assertTrue(data.isArray(), "'data' should be an array");
        assertEq(data.size(), 3, "Array should have three elements");
    }

    function testParseJSONWithBoolean() public {
        string memory jsonString = '{"success": true, "failure": false}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory success = item.at('"success"');
        assertTrue(success.isBoolean(), "'success' should be a boolean");
        JSONParserLib.Item memory failure = item.at('"failure"');
        assertTrue(failure.isBoolean(), "'failure' should be a boolean");
    }

    function testParseJSONWithNull() public {
        string memory jsonString = '{"value": null}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory value = item.at('"value"');
        assertTrue(value.isNull(), "'value' should be null");
    }

    function testParseJSONWithNumbers() public {
        string memory jsonString = '{"integer": 123, "float": 123.456}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory integer = item.at('"integer"');
        assertTrue(integer.isNumber(), "'integer' should be a number");
        JSONParserLib.Item memory floatItem = item.at('"float"');
        assertTrue(floatItem.isNumber(), "'float' should be a number");
    }

    function testParseJSONWithSpecialCharacters() public {
        string memory jsonString = '{"special": "\u0041\u0042\u0043"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory special = item.at('"special"');
        assertTrue(special.isString(), "'special' should be a string");
    }

    function testParseJSONWithEscapedCharacters() public {
        string memory jsonString = '{"escaped": "\\\"Hello\\\""}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(item.isObject(), "Parsed item should be an object");
        JSONParserLib.Item memory escaped = item.at('"escaped"');
        assertTrue(escaped.isString(), "'escaped' should be a string");
    }
}
