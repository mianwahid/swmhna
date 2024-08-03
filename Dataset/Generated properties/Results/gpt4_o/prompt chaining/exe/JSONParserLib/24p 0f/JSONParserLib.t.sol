// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for string;
    using JSONParserLib for JSONParserLib.Item;

    // Invariant 1.1: Parsing a valid JSON string should not revert.
    function testParseValidJSON() public {
        string memory jsonString = '{"key": "value"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertTrue(!item.isUndefined());
    }

    // Invariant 1.2: Parsing an invalid JSON string should revert with `ParsingFailed`.
    function testParseInvalidJSON() public {
        string memory jsonString = '{"key": "value"';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(jsonString);
    }

    // Invariant 2.1: Retrieving the value of a string item should return the exact string representation.
    function testRetrieveStringValue() public {
        string memory jsonString = '{"key": "value"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key"');
        assertEq(item.value(), '"value"');
    }

    // Invariant 2.2: Retrieving the value of a number item should return the exact number representation.
    function testRetrieveNumberValue() public {
        string memory jsonString = '{"key": 123}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key"');
        assertEq(item.value(), "123");
    }

    // Invariant 2.3: Retrieving the value of a boolean item should return the exact boolean representation.
    function testRetrieveBooleanValue() public {
        string memory jsonString = '{"key": true}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key"');
        assertEq(item.value(), "true");
    }

    // Invariant 2.4: Retrieving the value of a null item should return `null`.
    function testRetrieveNullValue() public {
        string memory jsonString = '{"key": null}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key"');
        assertEq(item.value(), "null");
    }

    // Invariant 3.1: Retrieving the index of an item in an array should return the correct index.
    function testRetrieveIndexInArray() public {
        string memory jsonString = '[1, 2, 3]';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at(1);
        assertEq(item.index(), 1);
    }

    // Invariant 3.2: Retrieving the key of an item in an object should return the correct key.
    function testRetrieveKeyInObject() public {
        string memory jsonString = '{"key": "value"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key"');
        assertEq(item.key(), '"key"');
    }

    // Invariant 4.1: Retrieving children of an array should return all items in the array.
    function testRetrieveChildrenInArray() public {
        string memory jsonString = '[1, 2, 3]';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        JSONParserLib.Item[] memory children = item.children();
        assertEq(children.length, 3);
    }

    // Invariant 4.2: Retrieving children of an object should return all key-value pairs in the object.
    function testRetrieveChildrenInObject() public {
        string memory jsonString = '{"key1": "value1", "key2": "value2"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        JSONParserLib.Item[] memory children = item.children();
        assertEq(children.length, 2);
    }

    // Invariant 5.1: Retrieving the size of an array should return the correct number of items.
    function testRetrieveSizeOfArray() public {
        string memory jsonString = '[1, 2, 3]';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertEq(item.size(), 3);
    }

    // Invariant 5.2: Retrieving the size of an object should return the correct number of key-value pairs.
    function testRetrieveSizeOfObject() public {
        string memory jsonString = '{"key1": "value1", "key2": "value2"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString);
        assertEq(item.size(), 2);
    }

    // Invariant 6.1: Retrieving an item by index in an array should return the correct item.
    function testRetrieveItemByIndex() public {
        string memory jsonString = '[1, 2, 3]';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at(1);
        assertEq(item.value(), "2");
    }

    // Invariant 6.2: Retrieving an item by key in an object should return the correct item.
    function testRetrieveItemByKey() public {
        string memory jsonString = '{"key1": "value1", "key2": "value2"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key2"');
        assertEq(item.value(), '"value2"');
    }

    // Invariant 7.1: Checking the type of an item should return the correct type.
    function testCheckItemType() public {
        string memory jsonString = '{"key": "value"}';
        JSONParserLib.Item memory item = JSONParserLib.parse(jsonString).at('"key"');
        assertEq(item.getType(), JSONParserLib.TYPE_STRING);
    }

    // Invariant 8.1: Retrieving the parent of an item should return the correct parent item.
    function testRetrieveParentItem() public {
        string memory jsonString = '{"parent": {"child": "value"}}';
        JSONParserLib.Item memory parentItem = JSONParserLib.parse(jsonString).at('"parent"');
        JSONParserLib.Item memory childItem = parentItem.at('"child"');
        assertEq(childItem.parent().key(), '"parent"');
    }

    // Invariant 9.1: Parsing a valid unsigned integer string should return the correct uint256 value.
    function testParseValidUint() public {
        string memory uintString = "123";
        uint256 result = JSONParserLib.parseUint(uintString);
        assertEq(result, 123);
    }

    // Invariant 9.2: Parsing an invalid unsigned integer string should revert with `ParsingFailed`.
    function testParseInvalidUint() public {
        string memory uintString = "abc";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUint(uintString);
    }

    // Invariant 9.3: Parsing a valid signed integer string should return the correct int256 value.
    function testParseValidInt() public {
        string memory intString = "-123";
        int256 result = JSONParserLib.parseInt(intString);
        assertEq(result, -123);
    }

    // Invariant 9.4: Parsing an invalid signed integer string should revert with `ParsingFailed`.
    function testParseInvalidInt() public {
        string memory intString = "abc";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseInt(intString);
    }

    // Invariant 9.5: Parsing a valid hexadecimal string should return the correct uint256 value.
    function testParseValidHex() public {
        string memory hexString = "0x1a";
        uint256 result = JSONParserLib.parseUintFromHex(hexString);
        assertEq(result, 0x1a);
    }

    // Invariant 9.6: Parsing an invalid hexadecimal string should revert with `ParsingFailed`.
    function testParseInvalidHex() public {
        string memory hexString = "0x1g";
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parseUintFromHex(hexString);
    }

    // Invariant 9.7: Decoding a valid JSON encoded string should return the correct string.
    function testDecodeValidJSONString() public {
        string memory jsonString = '"hello"';
        string memory result = JSONParserLib.decodeString(jsonString);
        assertEq(result, "hello");
    }

    // Invariant 9.8: Decoding an invalid JSON encoded string should revert with `ParsingFailed`.
    function testDecodeInvalidJSONString() public {
        string memory jsonString = 'hello';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.decodeString(jsonString);
    }
}