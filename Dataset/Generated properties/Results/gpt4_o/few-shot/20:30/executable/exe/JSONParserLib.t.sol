// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for string;
    using JSONParserLib for JSONParserLib.Item;

    function testParseValidJSON() public {
        string memory json = '{"name":"John","age":30,"isStudent":false,"courses":["Math","Science"]}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);

        assertTrue(root.isObject());

        JSONParserLib.Item memory nameItem = root.at('"name"');
        assertTrue(nameItem.isString());
        assertEq(nameItem.value(), '"John"');

        JSONParserLib.Item memory ageItem = root.at('"age"');
        assertTrue(ageItem.isNumber());
        assertEq(ageItem.value(), '30');

        JSONParserLib.Item memory isStudentItem = root.at('"isStudent"');
        assertTrue(isStudentItem.isBoolean());
        assertEq(isStudentItem.value(), 'false');

        JSONParserLib.Item memory coursesItem = root.at('"courses"');
        assertTrue(coursesItem.isArray());
        assertEq(coursesItem.size(), 2);

        JSONParserLib.Item memory firstCourse = coursesItem.at(0);
        assertTrue(firstCourse.isString());
        assertEq(firstCourse.value(), '"Math"');

        JSONParserLib.Item memory secondCourse = coursesItem.at(1);
        assertTrue(secondCourse.isString());
        assertEq(secondCourse.value(), '"Science"');
    }

    function testParseInvalidJSON() public {
        string memory invalidJson = '{"name":"John","age":30,"isStudent":false,"courses":["Math","Science"';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(invalidJson);
    }

    function testParseEmptyJSON() public {
        string memory emptyJson = '{}';
        JSONParserLib.Item memory root = JSONParserLib.parse(emptyJson);
        assertTrue(root.isObject());
        assertEq(root.size(), 0);
    }

    function testParseArrayJSON() public {
        string memory jsonArray = '["apple", "banana", "cherry"]';
        JSONParserLib.Item memory root = JSONParserLib.parse(jsonArray);
        assertTrue(root.isArray());
        assertEq(root.size(), 3);

        JSONParserLib.Item memory firstItem = root.at(0);
        assertTrue(firstItem.isString());
        assertEq(firstItem.value(), '"apple"');

        JSONParserLib.Item memory secondItem = root.at(1);
        assertTrue(secondItem.isString());
        assertEq(secondItem.value(), '"banana"');

        JSONParserLib.Item memory thirdItem = root.at(2);
        assertTrue(thirdItem.isString());
        assertEq(thirdItem.value(), '"cherry"');
    }

    function testParseNestedJSON() public {
        string memory nestedJson = '{"person":{"name":"Alice","details":{"age":25,"city":"Wonderland"}}}';
        JSONParserLib.Item memory root = JSONParserLib.parse(nestedJson);
        assertTrue(root.isObject());

        JSONParserLib.Item memory personItem = root.at('"person"');
        assertTrue(personItem.isObject());

        JSONParserLib.Item memory nameItem = personItem.at('"name"');
        assertTrue(nameItem.isString());
        assertEq(nameItem.value(), '"Alice"');

        JSONParserLib.Item memory detailsItem = personItem.at('"details"');
        assertTrue(detailsItem.isObject());

        JSONParserLib.Item memory ageItem = detailsItem.at('"age"');
        assertTrue(ageItem.isNumber());
        assertEq(ageItem.value(), '25');

        JSONParserLib.Item memory cityItem = detailsItem.at('"city"');
        assertTrue(cityItem.isString());
        assertEq(cityItem.value(), '"Wonderland"');
    }

    function testParseUint() public {
        string memory uintString = "123456";
        uint256 parsedUint = JSONParserLib.parseUint(uintString);
        assertEq(parsedUint, 123456);
    }

    function testParseInt() public {
        string memory intString = "-123456";
        int256 parsedInt = JSONParserLib.parseInt(intString);
        assertEq(parsedInt, -123456);
    }

    function testParseUintFromHex() public {
        string memory hexString = "0x1a2b3c";
        uint256 parsedUint = JSONParserLib.parseUintFromHex(hexString);
        assertEq(parsedUint, 0x1a2b3c);
    }

    function testDecodeString() public {
        string memory encodedString = '"Hello, world!"';
        string memory decodedString = JSONParserLib.decodeString(encodedString);
        assertEq(decodedString, "Hello, world!");
    }

    function testDecodeStringWithEscapes() public {
        string memory encodedString = '"Hello, \\nworld!\\t"';
        string memory decodedString = JSONParserLib.decodeString(encodedString);
        assertEq(decodedString, "Hello, \nworld!\t");
    }
}