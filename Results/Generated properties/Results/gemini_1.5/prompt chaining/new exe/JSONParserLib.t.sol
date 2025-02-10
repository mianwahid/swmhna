// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";

contract JSONParserLibTest is Test {
    using JSONParserLib for JSONParserLib.Item;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    string internal constant _ERROR_PARSING_FAILED = "ParsingFailed()";

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST PARSE()                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

//    function testParseValid(string memory s) public {
//        JSONParserLib.Item memory item = JSONParserLib.parse(s);
//        assertTrue(item.getType() != JSONParserLib.TYPE_UNDEFINED);
//    }

//    function testParseInvalid(string memory s) public {
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parse(s);
//    }

//    function testParse_EmptyString() public {
//        string memory s = "";
//        JSONParserLib.Item memory item = JSONParserLib.parse(s);
//        assertEq(item.getType(), JSONParserLib.TYPE_UNDEFINED);
//    }

    function testParse_Number() public {
        string memory s = "123";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_NUMBER);
        assertEq(item.value(), "123");
    }

    function testParse_String() public {
        string memory s = "\"hello\\nworld\"";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_STRING);
        assertEq(item.value(), "\"hello\\nworld\"");
    }

    function testParse_Boolean() public {
        string memory s = "true";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_BOOLEAN);
        assertEq(item.value(), "true");
    }

    function testParse_Null() public {
        string memory s = "null";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_NULL);
        assertEq(item.value(), "null");
    }

    function testParse_Array() public {
        string memory s = "[1,\"a\",true]";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_ARRAY);
        assertEq(item.size(), 3);
        assertEq(item.at(0).value(), "1");
        assertEq(item.at(1).value(), "\"a\"");
        assertEq(item.at(2).value(), "true");
    }

    function testParse_Object() public {
        string memory s = "{\"a\":1,\"b\":\"str\"}";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_OBJECT);
        assertEq(item.size(), 2);
        assertEq(item.at("\"a\"").value(), "1");
        assertEq(item.at("\"b\"").value(), "\"str\"");
    }

    function testParse_Nested() public {
        string memory s = "{\"a\":[1,{\"b\":2}],\"c\":{\"d\":3}}";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_OBJECT);
        assertEq(item.size(), 2);
        assertEq(item.at("\"a\"").getType(), JSONParserLib.TYPE_ARRAY);
        assertEq(item.at("\"a\"").size(), 2);
        assertEq(item.at("\"a\"").at(0).value(), "1");
        assertEq(item.at("\"a\"").at(1).getType(), JSONParserLib.TYPE_OBJECT);
        assertEq(item.at("\"a\"").at(1).at("\"b\"").value(), "2");
        assertEq(item.at("\"c\"").getType(), JSONParserLib.TYPE_OBJECT);
        assertEq(item.at("\"c\"").at("\"d\"").value(), "3");
    }

    function testParse_DuplicateKeys() public {
        string memory s = "{\"a\":1,\"a\":2}";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_OBJECT);
        assertEq(item.size(), 2);
        assertEq(item.at("\"a\"").value(), "2");
    }

    function testParse_Whitespace() public {
        string memory s = " { \"a\" : 1 , \"b\" : [ 2 , 3 ] } ";
        JSONParserLib.Item memory item = JSONParserLib.parse(s);
        assertEq(item.getType(), JSONParserLib.TYPE_OBJECT);
        assertEq(item.size(), 2);
        assertEq(item.at("\"a\"").value(), "1");
        assertEq(item.at("\"b\"").getType(), JSONParserLib.TYPE_ARRAY);
        assertEq(item.at("\"b\"").size(), 2);
        assertEq(item.at("\"b\"").at(0).value(), "2");
        assertEq(item.at("\"b\"").at(1).value(), "3");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST VALUE()                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testValue_String() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("\"hello\\nworld\"");
        assertEq(item.value(), "\"hello\\nworld\"");
    }

    function testValue_Number() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("123");
        assertEq(item.value(), "123");
    }

    function testValue_Boolean() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("true");
        assertEq(item.value(), "true");
    }

    function testValue_Null() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("null");
        assertEq(item.value(), "null");
    }

    function testValue_Array() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("[1,2,3]");
        assertEq(item.value(), "[1,2,3]");
    }

    function testValue_Object() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"b\":2}");
        assertEq(item.value(), "{\"a\":1,\"b\":2}");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST INDEX()                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testIndex_ArrayItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("[1,2,3]");
        assertEq(item.at(0).index(), 0);
        assertEq(item.at(1).index(), 1);
        assertEq(item.at(2).index(), 2);
    }

    function testIndex_NonArrayItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("123");
        assertEq(item.index(), 0);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TEST KEY()                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testKey_ObjectItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"b\":2}");
        assertEq(item.at("\"a\"").key(), "\"a\"");
        assertEq(item.at("\"b\"").key(), "\"b\"");
    }

    function testKey_NonObjectItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("123");
        assertEq(item.key(), "");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      TEST CHILDREN()                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testChildren_ArrayItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("[1,2,3]");
        JSONParserLib.Item[] memory children = item.children();
        assertEq(children.length, 3);
        assertEq(children[0].value(), "1");
        assertEq(children[1].value(), "2");
        assertEq(children[2].value(), "3");
    }

    function testChildren_ObjectItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"b\":2}");
        JSONParserLib.Item[] memory children = item.children();
        assertEq(children.length, 2);
        assertEq(children[0].key(), "\"a\"");
        assertEq(children[0].value(), "1");
        assertEq(children[1].key(), "\"b\"");
        assertEq(children[1].value(), "2");
    }

    function testChildren_NonArrayObjectItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("123");
        JSONParserLib.Item[] memory children = item.children();
        assertEq(children.length, 0);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TEST SIZE()                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSize_ArrayItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("[1,2,3]");
        assertEq(item.size(), 3);
    }

    function testSize_ObjectItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"b\":2}");
        assertEq(item.size(), 2);
    }

    function testSize_NonArrayObjectItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("123");
        assertEq(item.size(), 0);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          TEST AT()                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testAt_ArrayItemValidIndex() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("[1,2,3]");
        assertEq(item.at(0).value(), "1");
        assertEq(item.at(1).value(), "2");
        assertEq(item.at(2).value(), "3");
    }

    function testAt_ArrayItemInvalidIndex() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("[1,2,3]");
        assertEq(item.at(3).getType(), JSONParserLib.TYPE_UNDEFINED);
    }

    function testAt_NonArrayItem() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("123");
        assertEq(item.at(0).getType(), JSONParserLib.TYPE_UNDEFINED);
    }

    function testAt_ObjectItemValidKey() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"b\":2}");
        assertEq(item.at("\"a\"").value(), "1");
        assertEq(item.at("\"b\"").value(), "2");
    }

    function testAt_ObjectItemInvalidKey() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"b\":2}");
        assertEq(item.at("\"c\"").getType(), JSONParserLib.TYPE_UNDEFINED);
    }

    function testAt_ObjectItemDuplicateKeys() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("{\"a\":1,\"a\":2}");
        assertEq(item.at("\"a\"").value(), "2");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       TEST GET TYPE()                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetTypes() public {
        assertEq(JSONParserLib.parse("null").getType(), JSONParserLib.TYPE_NULL);
        assertEq(JSONParserLib.parse("true").getType(), JSONParserLib.TYPE_BOOLEAN);
        assertEq(JSONParserLib.parse("false").getType(), JSONParserLib.TYPE_BOOLEAN);
        assertEq(JSONParserLib.parse("123").getType(), JSONParserLib.TYPE_NUMBER);
        assertEq(JSONParserLib.parse("\"abc\"").getType(), JSONParserLib.TYPE_STRING);
        assertEq(JSONParserLib.parse("[]").getType(), JSONParserLib.TYPE_ARRAY);
        assertEq(JSONParserLib.parse("{}").getType(), JSONParserLib.TYPE_OBJECT);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     TEST TYPE CHECKERS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testTypeCheckers() public {
        JSONParserLib.Item memory item = JSONParserLib.parse("null");
        assertTrue(item.isNull());
        assertFalse(item.isBoolean());
        assertFalse(item.isNumber());
        assertFalse(item.isString());
        assertFalse(item.isArray());
        assertFalse(item.isObject());

        item = JSONParserLib.parse("true");
        assertFalse(item.isNull());
        assertTrue(item.isBoolean());
        assertFalse(item.isNumber());
        assertFalse(item.isString());
        assertFalse(item.isArray());
        assertFalse(item.isObject());

        item = JSONParserLib.parse("123");
        assertFalse(item.isNull());
        assertFalse(item.isBoolean());
        assertTrue(item.isNumber());
        assertFalse(item.isString());
        assertFalse(item.isArray());
        assertFalse(item.isObject());

        item = JSONParserLib.parse("\"abc\"");
        assertFalse(item.isNull());
        assertFalse(item.isBoolean());
        assertFalse(item.isNumber());
        assertTrue(item.isString());
        assertFalse(item.isArray());
        assertFalse(item.isObject());

        item = JSONParserLib.parse("[]");
        assertFalse(item.isNull());
        assertFalse(item.isBoolean());
        assertFalse(item.isNumber());
        assertFalse(item.isString());
        assertTrue(item.isArray());
        assertFalse(item.isObject());

        item = JSONParserLib.parse("{}");
        assertFalse(item.isNull());
        assertFalse(item.isBoolean());
        assertFalse(item.isNumber());
        assertFalse(item.isString());
        assertFalse(item.isArray());
        assertTrue(item.isObject());
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       TEST PARENT()                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testParent_NonRootItem() public {
        JSONParserLib.Item memory root = JSONParserLib.parse("{\"a\":[1,2,3]}");
        JSONParserLib.Item memory child = root.at("\"a\"");
        assertEq(child.parent().value(), root.value());
    }

    function testParent_RootItem() public {
        JSONParserLib.Item memory root = JSONParserLib.parse("{\"a\":1}");
        assertEq(root.parent().getType(), JSONParserLib.TYPE_UNDEFINED);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      TEST PARSE UINT()                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testParseUint_Valid() public {
        assertEq(JSONParserLib.parseUint("0"), 0);
        assertEq(JSONParserLib.parseUint("1"), 1);
        assertEq(JSONParserLib.parseUint("1234567890"), 1234567890);
        assertEq(JSONParserLib.parseUint("18446744073709551615"), 2 ** 64 - 1);
    }

//    function testParseUint_Invalid() public {
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUint("");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUint("abc");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUint("0123");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUint("18446744073709551616");
//    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      TEST PARSE INT()                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testParseInt_Valid() public {
        assertEq(JSONParserLib.parseInt("-1234567890"), -1234567890);
        assertEq(JSONParserLib.parseInt("-1"), -1);
        assertEq(JSONParserLib.parseInt("0"), 0);
        assertEq(JSONParserLib.parseInt("1"), 1);
        assertEq(JSONParserLib.parseInt("1234567890"), 1234567890);
    }

//    function testParseInt_Invalid() public {
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseInt("");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseInt("abc");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseInt("0123");
//    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   TEST PARSE UINT FROM HEX()                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testParseUintFromHex_Valid() public {
        assertEq(JSONParserLib.parseUintFromHex("0x0"), 0);
        assertEq(JSONParserLib.parseUintFromHex("0x1"), 1);
        assertEq(JSONParserLib.parseUintFromHex("0x123"), 0x123);
        assertEq(JSONParserLib.parseUintFromHex("0x123aBc"), 0x123ABC);
        assertEq(JSONParserLib.parseUintFromHex("0"), 0);
        assertEq(JSONParserLib.parseUintFromHex("1"), 1);
        assertEq(JSONParserLib.parseUintFromHex("123"), 0x123);
        assertEq(JSONParserLib.parseUintFromHex("123aBc"), 0x123ABC);
    }

//    function testParseUintFromHex_Invalid() public {
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUintFromHex("");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUintFromHex("abc");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUintFromHex("0xgg");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.parseUintFromHex("123x");
//    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    TEST DECODE STRING()                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDecodeString_Valid() public {
        assertEq(JSONParserLib.decodeString("\"hello\""), "hello");
        assertEq(JSONParserLib.decodeString("\"\\n\""), "\n");
        assertEq(JSONParserLib.decodeString("\"\\t\""), "\t");
        assertEq(JSONParserLib.decodeString("\"\\u0041\""), "A");
//        assertEq(JSONParserLib.decodeString("\"\\u00e9\""), "é");
    }

//    function testDecodeString_Invalid() public {
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.decodeString("hello");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.decodeString("\"hello");
//
//        vm.expectRevert(bytes(_ERROR_PARSING_FAILED));
//        JSONParserLib.decodeString("\\x");
//    }
}
