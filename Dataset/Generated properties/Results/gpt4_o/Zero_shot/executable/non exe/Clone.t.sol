// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Clone.sol";

contract CloneTest is Test {
    Clone clone;

    function setUp() public {
        clone = new Clone();
    }

    function testGetArgBytes() public {
        bytes memory expected = hex"123456";
        bytes memory result = clone._getArgBytes();
        assertEq(result, expected, "Bytes do not match");
    }

    function testGetArgBytesWithOffset() public {
        bytes memory expected = hex"123456";
        bytes memory result = clone._getArgBytes(0, 3);
        assertEq(result, expected, "Bytes do not match");
    }

    function testGetArgAddress() public {
        address expected = address(0x1234567890123456789012345678901234567890);
        address result = clone._getArgAddress(0);
        assertEq(result, expected, "Addresses do not match");
    }

    function testGetArgUint256Array() public {
        uint256[] memory expected = new uint256[](2);
        expected[0] = 1;
        expected[1] = 2;
        uint256[] memory result = clone._getArgUint256Array(0, 2);
        assertEq(result, expected, "Uint256 arrays do not match");
    }

    function testGetArgBytes32Array() public {
        bytes32[] memory expected = new bytes32[](2);
        expected[0] = bytes32(0x1);
        expected[1] = bytes32(0x2);
        bytes32[] memory result = clone._getArgBytes32Array(0, 2);
        assertEq(result, expected, "Bytes32 arrays do not match");
    }

    function testGetArgBytes32() public {
        bytes32 expected = bytes32(0x1234567890123456789012345678901234567890123456789012345678901234);
        bytes32 result = clone._getArgBytes32(0);
        assertEq(result, expected, "Bytes32 do not match");
    }

    function testGetArgUint256() public {
        uint256 expected = 123456;
        uint256 result = clone._getArgUint256(0);
        assertEq(result, expected, "Uint256 do not match");
    }

    function testGetArgUint248() public {
        uint248 expected = 123456;
        uint248 result = clone._getArgUint248(0);
        assertEq(result, expected, "Uint248 do not match");
    }

    function testGetArgUint240() public {
        uint240 expected = 123456;
        uint240 result = clone._getArgUint240(0);
        assertEq(result, expected, "Uint240 do not match");
    }

    function testGetArgUint232() public {
        uint232 expected = 123456;
        uint232 result = clone._getArgUint232(0);
        assertEq(result, expected, "Uint232 do not match");
    }

    function testGetArgUint224() public {
        uint224 expected = 123456;
        uint224 result = clone._getArgUint224(0);
        assertEq(result, expected, "Uint224 do not match");
    }

    function testGetArgUint216() public {
        uint216 expected = 123456;
        uint216 result = clone._getArgUint216(0);
        assertEq(result, expected, "Uint216 do not match");
    }

    function testGetArgUint208() public {
        uint208 expected = 123456;
        uint208 result = clone._getArgUint208(0);
        assertEq(result, expected, "Uint208 do not match");
    }

    function testGetArgUint200() public {
        uint200 expected = 123456;
        uint200 result = clone._getArgUint200(0);
        assertEq(result, expected, "Uint200 do not match");
    }

    function testGetArgUint192() public {
        uint192 expected = 123456;
        uint192 result = clone._getArgUint192(0);
        assertEq(result, expected, "Uint192 do not match");
    }

    function testGetArgUint184() public {
        uint184 expected = 123456;
        uint184 result = clone._getArgUint184(0);
        assertEq(result, expected, "Uint184 do not match");
    }

    function testGetArgUint176() public {
        uint176 expected = 123456;
        uint176 result = clone._getArgUint176(0);
        assertEq(result, expected, "Uint176 do not match");
    }

    function testGetArgUint168() public {
        uint168 expected = 123456;
        uint168 result = clone._getArgUint168(0);
        assertEq(result, expected, "Uint168 do not match");
    }

    function testGetArgUint160() public {
        uint160 expected = 123456;
        uint160 result = clone._getArgUint160(0);
        assertEq(result, expected, "Uint160 do not match");
    }

    function testGetArgUint152() public {
        uint152 expected = 123456;
        uint152 result = clone._getArgUint152(0);
        assertEq(result, expected, "Uint152 do not match");
    }

    function testGetArgUint144() public {
        uint144 expected = 123456;
        uint144 result = clone._getArgUint144(0);
        assertEq(result, expected, "Uint144 do not match");
    }

    function testGetArgUint136() public {
        uint136 expected = 123456;
        uint136 result = clone._getArgUint136(0);
        assertEq(result, expected, "Uint136 do not match");
    }

    function testGetArgUint128() public {
        uint128 expected = 123456;
        uint128 result = clone._getArgUint128(0);
        assertEq(result, expected, "Uint128 do not match");
    }

    function testGetArgUint120() public {
        uint120 expected = 123456;
        uint120 result = clone._getArgUint120(0);
        assertEq(result, expected, "Uint120 do not match");
    }

    function testGetArgUint112() public {
        uint112 expected = 123456;
        uint112 result = clone._getArgUint112(0);
        assertEq(result, expected, "Uint112 do not match");
    }

    function testGetArgUint104() public {
        uint104 expected = 123456;
        uint104 result = clone._getArgUint104(0);
        assertEq(result, expected, "Uint104 do not match");
    }

    function testGetArgUint96() public {
        uint96 expected = 123456;
        uint96 result = clone._getArgUint96(0);
        assertEq(result, expected, "Uint96 do not match");
    }

    function testGetArgUint88() public {
        uint88 expected = 123456;
        uint88 result = clone._getArgUint88(0);
        assertEq(result, expected, "Uint88 do not match");
    }

    function testGetArgUint80() public {
        uint80 expected = 123456;
        uint80 result = clone._getArgUint80(0);
        assertEq(result, expected, "Uint80 do not match");
    }

    function testGetArgUint72() public {
        uint72 expected = 123456;
        uint72 result = clone._getArgUint72(0);
        assertEq(result, expected, "Uint72 do not match");
    }

    function testGetArgUint64() public {
        uint64 expected = 123456;
        uint64 result = clone._getArgUint64(0);
        assertEq(result, expected, "Uint64 do not match");
    }

    function testGetArgUint56() public {
        uint56 expected = 123456;
        uint56 result = clone._getArgUint56(0);
        assertEq(result, expected, "Uint56 do not match");
    }

    function testGetArgUint48() public {
        uint48 expected = 123456;
        uint48 result = clone._getArgUint48(0);
        assertEq(result, expected, "Uint48 do not match");
    }

    function testGetArgUint40() public {
        uint40 expected = 123456;
        uint40 result = clone._getArgUint40(0);
        assertEq(result, expected, "Uint40 do not match");
    }

    function testGetArgUint32() public {
        uint32 expected = 123456;
        uint32 result = clone._getArgUint32(0);
        assertEq(result, expected, "Uint32 do not match");
    }

    function testGetArgUint24() public {
        uint24 expected = 123456;
        uint24 result = clone._getArgUint24(0);
        assertEq(result, expected, "Uint24 do not match");
    }

    function testGetArgUint16() public {
        uint16 expected = 123456;
        uint16 result = clone._getArgUint16(0);
        assertEq(result, expected, "Uint16 do not match");
    }

    function testGetArgUint8() public {
        uint8 expected = 123456;
        uint8 result = clone._getArgUint8(0);
        assertEq(result, expected, "Uint8 do not match");
    }

    function testGetImmutableArgsOffset() public {
        uint256 expected = 123456;
        uint256 result = clone._getImmutableArgsOffset();
        assertEq(result, expected, "Immutable args offset do not match");
    }
}