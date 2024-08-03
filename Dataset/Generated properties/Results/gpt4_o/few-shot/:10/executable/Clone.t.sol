//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/Clone.sol";
//
//contract CloneTest is Test,Clone {
//    function testGetArgBytes() public {
//        bytes memory expected = abi.encodePacked("test bytes");
//        bytes memory result = this.getArgBytes(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgBytesWithOffset() public {
//        bytes memory expected = abi.encodePacked("test bytes with offset");
//        bytes memory result = this.getArgBytesWithOffset(expected, 5, 10);
//        assertEq(result, bytes(expected[5:15]));
//    }
//
//    function testGetArgAddress() public {
//        address expected = address(0x1234567890abcdef1234567890abcdef12345678);
//        address result = this.getArgAddress(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint256Array() public {
//        uint256[] memory expected = new uint256[](3);
//        expected[0] = 1;
//        expected[1] = 2;
//        expected[2] = 3;
//        uint256[] memory result = this.getArgUint256Array(expected, 0, 3);
//        assertEq(result, expected);
//    }
//
//    function testGetArgBytes32Array() public {
//        bytes32[] memory expected = new bytes32[](2);
//        expected[0] = bytes32("test1");
//        expected[1] = bytes32("test2");
//        bytes32[] memory result = this.getArgBytes32Array(expected, 0, 2);
//        assertEq(result, expected);
//    }
//
//    function testGetArgBytes32() public {
//        bytes32 expected = bytes32("test bytes32");
//        bytes32 result = this.getArgBytes32(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint256() public {
//        uint256 expected = 1234567890;
//        uint256 result = this.getArgUint256(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint248() public {
//        uint248 expected = 1234567890;
//        uint248 result = this.getArgUint248(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint240() public {
//        uint240 expected = 1234567890;
//        uint240 result = this.getArgUint240(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint232() public {
//        uint232 expected = 1234567890;
//        uint232 result = this.getArgUint232(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint224() public {
//        uint224 expected = 1234567890;
//        uint224 result = this.getArgUint224(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint216() public {
//        uint216 expected = 1234567890;
//        uint216 result = this.getArgUint216(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint208() public {
//        uint208 expected = 1234567890;
//        uint208 result = this.getArgUint208(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint200() public {
//        uint200 expected = 1234567890;
//        uint200 result = this.getArgUint200(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint192() public {
//        uint192 expected = 1234567890;
//        uint192 result = this.getArgUint192(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint184() public {
//        uint184 expected = 1234567890;
//        uint184 result = this.getArgUint184(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint176() public {
//        uint176 expected = 1234567890;
//        uint176 result = this.getArgUint176(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint168() public {
//        uint168 expected = 1234567890;
//        uint168 result = this.getArgUint168(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint160() public {
//        uint160 expected = 1234567890;
//        uint160 result = this.getArgUint160(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint152() public {
//        uint152 expected = 1234567890;
//        uint152 result = this.getArgUint152(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint144() public {
//        uint144 expected = 1234567890;
//        uint144 result = this.getArgUint144(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint136() public {
//        uint136 expected = 1234567890;
//        uint136 result = this.getArgUint136(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint128() public {
//        uint128 expected = 1234567890;
//        uint128 result = this.getArgUint128(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint120() public {
//        uint120 expected = 1234567890;
//        uint120 result = this.getArgUint120(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint112() public {
//        uint112 expected = 1234567890;
//        uint112 result = this.getArgUint112(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint104() public {
//        uint104 expected = 1234567890;
//        uint104 result = this.getArgUint104(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint96() public {
//        uint96 expected = 1234567890;
//        uint96 result = this.getArgUint96(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint88() public {
//        uint88 expected = 1234567890;
//        uint88 result = this.getArgUint88(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint80() public {
//        uint80 expected = 1234567890;
//        uint80 result = this.getArgUint80(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint72() public {
//        uint72 expected = 1234567890;
//        uint72 result = this.getArgUint72(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint64() public {
//        uint64 expected = 1234567890;
//        uint64 result = this.getArgUint64(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint56() public {
//        uint56 expected = 1234567890;
//        uint56 result = this.getArgUint56(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint48() public {
//        uint48 expected = 1234567890;
//        uint48 result = this.getArgUint48(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint40() public {
//        uint40 expected = 1234567890;
//        uint40 result = this.getArgUint40(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint32() public {
//        uint32 expected = 1234567890;
//        uint32 result = this.getArgUint32(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint24() public {
//        uint24 expected = 1234567890;
//        uint24 result = this.getArgUint24(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint16() public {
//        uint16 expected = 1234567890;
//        uint16 result = this.getArgUint16(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetArgUint8() public {
//        uint8 expected = 123;
//        uint8 result = this.getArgUint8(expected);
//        assertEq(result, expected);
//    }
//
//    function testGetImmutableArgsOffset() public {
//        uint256 expected = 10;
//        uint256 result = this.getImmutableArgsOffset(expected);
//        assertEq(result, expected);
//    }
//}