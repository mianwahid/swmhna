// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for string;
    using JSONParserLib for JSONParserLib.Item;

    function testParseValidJSON() public {
        string memory json = '{"key1":"value1","key2":123,"key3":true,"key4":null,"key5":[1,2,3],"key6":{"nestedKey":"nestedValue"}}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
    }

    function testParseInvalidJSON() public {
        string memory json = '{"key1":"value1", "key2":123, "key3":true, "key4":null, "key5":[1,2,3], "key6":{"nestedKey":"nestedValue"';
        vm.expectRevert(JSONParserLib.ParsingFailed.selector);
        JSONParserLib.parse(json);
    }

    function testParseEmptyJSON() public {
        string memory json = '{}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        assertEq(root.size(), 0);
    }

    function testParseArrayJSON() public {
        string memory json = '[1,2,3]';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isArray());
        assertEq(root.size(), 3);
    }

    function testParseNestedJSON() public {
        string memory json = '{"key":{"nestedKey":"nestedValue"}}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        JSONParserLib.Item memory nested = root.at('"key"');
        assertTrue(nested.isObject());
        JSONParserLib.Item memory nestedValue = nested.at('"nestedKey"');
        assertTrue(nestedValue.isString());
        assertEq(nestedValue.value(), '"nestedValue"');
    }

    function testParseBooleanJSON() public {
        string memory json = '{"key":true}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        JSONParserLib.Item memory value = root.at('"key"');
        assertTrue(value.isBoolean());
    }

    function testParseNullJSON() public {
        string memory json = '{"key":null}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        JSONParserLib.Item memory value = root.at('"key"');
        assertTrue(value.isNull());
    }

    function testParseNumberJSON() public {
        string memory json = '{"key":123}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        JSONParserLib.Item memory value = root.at('"key"');
        assertTrue(value.isNumber());
    }

    function testParseStringJSON() public {
        string memory json = '{"key":"value"}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        JSONParserLib.Item memory value = root.at('"key"');
        assertTrue(value.isString());
        assertEq(value.value(), '"value"');
    }

    function testParseComplexJSON() public {
        string memory json = '{"key1":"value1","key2":123,"key3":true,"key4":null,"key5":[1,2,3],"key6":{"nestedKey":"nestedValue"}}';
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        assertTrue(root.isObject());
        assertEq(root.size(), 6);
    }

    function testParseUint() public {
        string memory number = "123456";
        uint256 result = JSONParserLib.parseUint(number);
        assertEq(result, 123456);
    }

    function testParseInt() public {
        string memory number = "-123456";
        int256 result = JSONParserLib.parseInt(number);
        assertEq(result, -123456);
    }

    function testParseUintFromHex() public {
        string memory hexNumber = "0x1a2b3c";
        uint256 result = JSONParserLib.parseUintFromHex(hexNumber);
        assertEq(result, 0x1a2b3c);
    }

    function testDecodeString() public {
        string memory encodedString = '"hello"';
        string memory result = JSONParserLib.decodeString(encodedString);
        assertEq(result, "hello");
    }

//    function testFuzzParseValidJSON(string memory json) public {
//        vm.assume(bytes(json).length > 0);
//        try JSONParserLib.parse(json) {
//            // If it doesn't revert, it should be a valid JSON
//        } catch {
//            // If it reverts, it should be an invalid JSON
//        }
//    }
//
//    function testFuzzParseUint(string memory number) public {
//        vm.assume(bytes(number).length > 0);
//        try JSONParserLib.parseUint(number) {
//            // If it doesn't revert, it should be a valid uint
//        } catch {
//            // If it reverts, it should be an invalid uint
//        }
//    }
//
//    function testFuzzParseInt(string memory number) public {
//        vm.assume(bytes(number).length > 0);
//        try JSONParserLib.parseInt(number) {
//            // If it doesn't revert, it should be a valid int
//        } catch {
//            // If it reverts, it should be an invalid int
//        }
//    }
//
//    function testFuzzParseUintFromHex(string memory hexNumber) public {
//        vm.assume(bytes(hexNumber).length > 0);
//        try JSONParserLib.parseUintFromHex(hexNumber) {
//            // If it doesn't revert, it should be a valid hex uint
//        } catch {
//            // If it reverts, it should be an invalid hex uint
//        }
//    }

//    function testFuzzDecodeString(string memory encodedString) public {
//        vm.assume(bytes(encodedString).length > 0);
//        try JSONParserLib.decodeString(encodedString) {
//            // If it doesn't revert, it should be a valid encoded string
//        } catch {
//            // If it reverts, it should be an invalid encoded string
//        }
//    }
}