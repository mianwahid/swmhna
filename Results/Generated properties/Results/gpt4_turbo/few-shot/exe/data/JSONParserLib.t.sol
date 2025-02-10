// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {JSONParserLib} from "../src/utils/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    function testParseValidJSONString() public {
        string memory jsonString = '{"name":"John", "age":30, "city":"New York"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
    }

    function testParseInvalidJSONString() public {
        string memory jsonString = '{"name": "John", "age": 30, "city": "New York"'; // Missing closing brace
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(jsonString);
    }

    function testParseEmptyJSONObject() public {
        string memory jsonString = '{}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        assertEq(JSONParserLib.size(item), 0, "Object should have no properties");
    }

    function testParseJSONArray() public {
        string memory jsonString = '["apple", "banana", "cherry"]';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isArray(item), "Parsed item should be an array");
        assertEq(JSONParserLib.size(item), 3, "Array should have three items");
    }

    function testParseNestedJSON() public {
        string memory jsonString = '{"person": {"name": "John", "age": 30}, "city": "New York"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        JSONParserLib.Item memory person = JSONParserLib.at(item, '"person"');
        assertTrue(JSONParserLib.isObject(person), "Nested 'person' should be an object");
        assertEq(JSONParserLib.size(person), 2, "Person object should have two properties");
    }

    function testParseJSONWithArray() public {
        string memory jsonString = '{"fruits": ["apple", "banana", "cherry"]}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        JSONParserLib.Item memory fruits = JSONParserLib.at(item, '"fruits"');
        assertTrue(JSONParserLib.isArray(fruits), "'fruits' should be an array");
        assertEq(JSONParserLib.size(fruits), 3, "Fruits array should have three items");
    }

    function testParseJSONWithNumbers() public {
        string memory jsonString = '{"value": 123, "price": 19.99}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        JSONParserLib.Item memory value = JSONParserLib.at(item, '"value"');
        assertTrue(JSONParserLib.isNumber(value), "'value' should be a number");
        JSONParserLib.Item memory price = JSONParserLib.at(item, '"price"');
        assertTrue(JSONParserLib.isNumber(price), "'price' should be a number");
    }

    function testParseJSONWithBoolean() public {
        string memory jsonString = '{"success": true, "failure": false}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        JSONParserLib.Item memory success = JSONParserLib.at(item, '"success"');
        assertTrue(JSONParserLib.isBoolean(success), "'success' should be a boolean");
        JSONParserLib.Item memory failure = JSONParserLib.at(item, '"failure"');
        assertTrue(JSONParserLib.isBoolean(failure), "'failure' should be a boolean");
    }

    function testParseJSONWithNull() public {
        string memory jsonString = '{"data": null}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);

        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        JSONParserLib.Item memory data = JSONParserLib.at(item, '"data"');
        assertTrue(JSONParserLib.isNull(data), "'data' should be null");
    }
}