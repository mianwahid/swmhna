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
        string memory jsonString = '{"name":"John", "age":30, "city":"New York"';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(jsonString);
    }

    function testParseEmptyJSONObject() public {
        string memory jsonString = '{}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");
        assertEq(JSONParserLib.size(item), 0, "Object should be empty");
    }

    function testParseJSONWithArray() public {
        string memory jsonString = '{"data":[1, 2, 3, 4]}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");

        JSONParserLib.Item memory dataItem = JSONParserLib.at(item, '"data"');
        assertTrue(JSONParserLib.isArray(dataItem), "Data item should be an array");
        assertEq(JSONParserLib.size(dataItem), 4, "Array should contain 4 items");
    }

    function testParseNestedJSON() public {
        string memory jsonString = '{"person": {"name": "John", "age": 30}}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");

        JSONParserLib.Item memory personItem = JSONParserLib.at(item, '"person"');
        assertTrue(JSONParserLib.isObject(personItem), "Person item should be an object");
        assertEq(JSONParserLib.size(personItem), 2, "Person object should contain 2 items");
    }

    function testParseJSONWithBoolean() public {
        string memory jsonString = '{"success":true, "failure":false}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");

        JSONParserLib.Item memory successItem = JSONParserLib.at(item, '"success"');
        assertTrue(JSONParserLib.isBoolean(successItem), "Success item should be a boolean");
//        assertTrue(JSONParserLib.value(successItem).toBool(), "Success should be true");

        JSONParserLib.Item memory failureItem = JSONParserLib.at(item, '"failure"');
        assertTrue(JSONParserLib.isBoolean(failureItem), "Failure item should be a boolean");
//        assertFalse(JSONParserLib.value(failureItem).toBool(), "Failure should be false");
    }

    function testParseJSONWithNull() public {
        string memory jsonString = '{"item":null}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");

        JSONParserLib.Item memory nullItem = JSONParserLib.at(item, '"item"');
        assertTrue(JSONParserLib.isNull(nullItem), "Item should be null");
    }

    function testParseJSONWithNumbers() public {
        string memory jsonString = '{"integer": 123, "float": 123.456}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(JSONParserLib.isObject(item), "Parsed item should be an object");

        JSONParserLib.Item memory integerItem = JSONParserLib.at(item, '"integer"');
        assertTrue(JSONParserLib.isNumber(integerItem), "Integer item should be a number");
//        assertEq(JSONParserLib.value(integerItem).toUint(), 123, "Integer value should be 123");

        JSONParserLib.Item memory floatItem = JSONParserLib.at(item, '"float"');
        assertTrue(JSONParserLib.isNumber(floatItem), "Float item should be a number");
//        assertEq(JSONParserLib.value(floatItem).toUint(), 123456, "Float value should be 123.456");
    }
}