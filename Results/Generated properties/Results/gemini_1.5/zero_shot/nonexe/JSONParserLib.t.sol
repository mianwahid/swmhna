// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/JSONParserLib.sol";
contract JSONParserLibTest is Test {
    function testParseUintFromHex(string memory s, uint256 x) public {
        // Ensure that the input string is a valid hexadecimal number.
        if (bytes(s).length > 2 && bytes(s)[0] == '0' && bytes(s)[1] == 'x') {
            s = string(abi.encodePacked(bytes(s)[:2], bytes(s)[4:]));
        }
        for (uint256 i = 0; i < bytes(s).length; ++i) {
            bytes1 c = bytes(s)[i];
            if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))) {
                vm.assume(false);
            }
        }
        // Ensure that the input number can be represented as a hexadecimal string.
        vm.assume(x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        // Convert the input number to a hexadecimal string.
        string memory expected = toHexString(x);
        // Parse the hexadecimal string using the `parseUintFromHex` function.
        uint256 result = JSONParserLib.parseUintFromHex(s);
        // Check that the parsed number matches the expected number.
        assertEq(result, x, string(abi.encodePacked("Expected: ", expected, ", got: ", toHexString(result))));
    }
    function testParseInt(string memory s, int256 x) public {
        string memory expected = toString(x);
        int256 result = JSONParserLib.parseInt(s);
        assertEq(result, x, string(abi.encodePacked("Expected: ", expected, ", got: ", toString(result))));
    }
    function testFuzz_parseInt(string memory s) public {
        try JSONParserLib.parseInt(s) {} catch (bytes memory) {}
    }
    function testParseUint(string memory s, uint256 x) public {
        string memory expected = toString(x);
        uint256 result = JSONParserLib.parseUint(s);
        assertEq(result, x, string(abi.encodePacked("Expected: ", expected, ", got: ", toString(result))));
    }
    function testFuzz_parseUint(string memory s) public {
        try JSONParserLib.parseUint(s) {} catch (bytes memory) {}
    }
    function testDecodeString(string memory s) public {
        string memory encoded = string(abi.encodePacked('"', s, '"'));
        string memory result = JSONParserLib.decodeString(encoded);
        assertEq(result, s);
    }
    function testFuzz_decodeString(string memory s) public {
        try JSONParserLib.decodeString(s) {} catch (bytes memory) {}
    }
//    function testAt(string memory json, string memory key) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        JSONParserLib.Item memory item = root.at(key);
//        if (item.isUndefined()) {
//            // Key not found.
//            return;
//        }
//        // Check that the item's key matches the input key.
//        assertEq(item.key(), key);
//    }
//    function testFuzz_at(string memory json, uint256 i) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        JSONParserLib.Item memory item = root.at(i);
//        if (item.isUndefined()) {
//            // Index out of bounds.
//            return;
//        }
//        // Check that the item's index matches the input index.
//        assertEq(item.index(), i);
//    }
//    function testValue(string memory json) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        string memory result = root.value();
//        assertEq(result, json);
//    }
//    function testChildren(string memory json) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        JSONParserLib.Item[] memory children = root.children();
//        if (root.isArray()) {
//            // Check that the number of children matches the length of the array.
//            assertEq(children.length, root.size());
//            // Check that each child's index is correct.
//            for (uint256 i = 0; i < children.length; ++i) {
//                assertEq(children[i].index(), i);
//            }
//        } else if (root.isObject()) {
//            // Check that the number of children matches the number of keys in the object.
//            assertEq(children.length, root.size());
//            // Check that each child's key is unique.
//            for (uint256 i = 0; i < children.length; ++i) {
//                for (uint256 j = i + 1; j < children.length; ++j) {
//                    assertFalse(keccak256(bytes(children[i].key())) == keccak256(bytes(children[j].key())));
//                }
//            }
//        } else {
//            // The root is not an array or object.
//            assertEq(children.length, 0);
//        }
//    }
//    function testSize(string memory json) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        uint256 size = root.size();
//        if (root.isArray() || root.isObject()) {
//            assertTrue(size > 0);
//        } else {
//            assertEq(size, 0);
//        }
//    }
//    function testGetType(string memory json, uint8 expectedType) public {
//        vm.assume(expectedType <= 6);
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        uint8 result = root.getType();
//        assertEq(result, expectedType);
//    }
//    function testIsUndefined(string memory json) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        bool result = root.isUndefined();
//        assertFalse(result);
//    }
//    function testIsArray(string memory json) public {
//        JSONParserLib.Item memory root = JSONParserLib.parse(json);
//        bool result = root.isArray();
//        if (bytes(json)[0] == '[') {
//            assertTrue(result);
//        } else {
//            assertFalse(result);
//        }
//    }
    function testIsObject(string memory json) public {
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        bool result = root.isObject();
        if (bytes(json)[0] == '{') {
            assertTrue(result);
        } else {
            assertFalse(result);
        }
    }
    function testIsNumber(string memory json) public {
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        bool result = root.isNumber();
        bytes memory jsonBytes = bytes(json);
        if ((jsonBytes[0] >= '0' && jsonBytes[0] <= '9') || jsonBytes[0] == '-') {
            assertTrue(result);
        } else {
            assertFalse(result);
        }
    }
    function testIsString(string memory json) public {
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        bool result = root.isString();
        if (bytes(json)[0] == '"') {
            assertTrue(result);
        } else {
            assertFalse(result);
        }
    }
    function testIsBoolean(string memory json) public {
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        bool result = root.isBoolean();
        if (keccak256(bytes(json)) == keccak256(bytes("true")) || keccak256(bytes(json)) == keccak256(bytes("false"))) {
            assertTrue(result);
        } else {
            assertFalse(result);
        }
    }
    function testIsNull(string memory json) public {
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        bool result = root.isNull();
        if (keccak256(bytes(json)) == keccak256(bytes("null"))) {
            assertTrue(result);
        } else {
            assertFalse(result);
        }
    }
    function testParent(string memory json) public {
        JSONParserLib.Item memory root = JSONParserLib.parse(json);
        JSONParserLib.Item memory child = root.at(0);
        if (!child.isUndefined()) {
            JSONParserLib.Item memory parent = child.parent();
            assertEq(parent._data, root._data);
        }
    }
    function testFuzz_parse(string memory json) public {
        try JSONParserLib.parse(json) {} catch (bytes memory) {}
    }
    function toHexString(uint256 value) private pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        bytes memory buffer = new bytes(length * 2);
        for (uint256 i = length * 2 - 1; i > 0; i -= 2) {
            buffer[i] = bytes1(uint8(48 + (value & 0xf)));
            value >>= 4;
            buffer[i - 1] = bytes1(uint8(48 + ((value & 0xf) + (value >= 10 ? 7 : 0))));
            value >>= 4;
        }
        return string(abi.encodePacked("0x", buffer));
    }
    function toString(int256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        bool isNegative = value < 0;
        uint256 unsignedValue = isNegative ? uint256(-value) : uint256(value);
        uint256 temp = unsignedValue;
        uint256 digits = 0;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        if (isNegative) {
            digits++;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = unsignedValue;
        while (temp != 0) {
            buffer[index--] = bytes1(uint8(48 + (temp % 10)));
            temp /= 10;
        }
        if (isNegative) {
            buffer[0] = "-";
        }
        return string(buffer);
    }
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits = 0;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = bytes1(uint8(48 + (temp % 10)));
            temp /= 10;
        }
        return string(buffer);
    }
}