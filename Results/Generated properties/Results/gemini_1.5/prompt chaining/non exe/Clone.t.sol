// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Clone.sol";

contract CloneTest is Test {
    function _encodeArgs(
        address arg1,
        uint256 arg2,
        bytes32 arg3,
        bytes memory arg4
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(arg1, arg2, arg3, arg4);
    }

    function _generateCalldata(bytes memory args) internal pure returns (bytes memory) {
        return abi.encodePacked(args.length, args);
    }

    function testOffsetCalculation() public {
        bytes memory args = _encodeArgs(address(1), 123, bytes32("test"), "hello");
        bytes memory calldata = _generateCalldata(args);
        uint256 offset = this.targetContract.interface.getFunction("_getImmutableArgsOffset()").selector;
        (bool success, bytes memory result) = address(this).call(abi.encodeWithSelector(offset, calldata));
        assertTrue(success, "Call to _getImmutableArgsOffset() failed");
        uint256 resultOffset = abi.decode(result, (uint256));
        assertLt(resultOffset, calldata.length, "Offset should be less than calldata size");
    }

    function testEmptyArguments() public {
        bytes memory calldata = _generateCalldata("");
        uint256 offset = this.targetContract.interface.getFunction("_getImmutableArgsOffset()").selector;
        (bool success, bytes memory result) = address(this).call(abi.encodeWithSelector(offset, calldata));
        assertTrue(success, "Call to _getImmutableArgsOffset() failed");
        uint256 resultOffset = abi.decode(result, (uint256));
        assertEq(resultOffset, calldata.length, "Offset should be equal to calldata size");
    }

    function testGetArgBytes() public {
        bytes memory arg4 = "hello";
        bytes memory args = _encodeArgs(address(1), 123, bytes32("test"), arg4);
        bytes memory calldata = _generateCalldata(args);

        // Test zero length
        bytes memory result = this.targetContract.getArgBytes(calldata, 0, 0);
        assertEq(result.length, 0, "Zero length should return empty bytes");

        // Test full length
        result = this.targetContract.getArgBytes(calldata, 0, args.length);
        assertEq(result, args, "Full length should return all arguments");

        // Test partial length
        uint256 partialLength = 2;
        result = this.targetContract.getArgBytes(calldata, 0, partialLength);
        assertEq(result.length, partialLength, "Partial length should return correct number of bytes");

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgBytes(calldata, 0, args.length + 1);
    }

    function testGetArgBytesWithOffset() public {
        bytes memory arg4 = "hello";
        bytes memory args = _encodeArgs(address(1), 123, bytes32("test"), arg4);
        bytes memory calldata = _generateCalldata(args);

        // Test zero length
        bytes memory result = this.targetContract.getArgBytes(calldata, 66, 0);
        assertEq(result.length, 0, "Zero length should return empty bytes");

        // Test exact length
        result = this.targetContract.getArgBytes(calldata, 66, arg4.length);
        assertEq(result, arg4, "Exact length should return correct bytes");

        // Test partial length
        uint256 partialLength = 2;
        result = this.targetContract.getArgBytes(calldata, 66, partialLength);
        assertEq(result.length, partialLength, "Partial length should return correct number of bytes");

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgBytes(calldata, 66, arg4.length + 1);
    }

    function testGetArgAddress() public {
        address arg1 = address(1);
        bytes memory args = _encodeArgs(arg1, 123, bytes32("test"), "hello");
        bytes memory calldata = _generateCalldata(args);

        // Test valid address
        address result = this.targetContract.getArgAddress(calldata, 0);
        assertEq(result, arg1, "Valid offset should return correct address");

        // Test misaligned offset
        vm.expectRevert();
        this.targetContract.getArgAddress(calldata, 1);

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgAddress(calldata, args.length - 19);
    }

    function testGetArgUint256Array() public {
        uint256[] memory arg = new uint256[](3);
        arg[0] = 1;
        arg[1] = 2;
        arg[2] = 3;
        bytes memory args = abi.encode(arg, address(1), bytes32("test"), "hello");
        bytes memory calldata = _generateCalldata(args);

        // Test zero length
        uint256[] memory result = this.targetContract.getArgUint256Array(calldata, 0, 0);
        assertEq(result.length, 0, "Zero length should return empty array");

        // Test exact length
        result = this.targetContract.getArgUint256Array(calldata, 0, arg.length);
        assertEq(result, arg, "Exact length should return correct array");

        // Test partial length
        uint256 partialLength = 2;
        result = this.targetContract.getArgUint256Array(calldata, 0, partialLength);
        assertEq(result.length, partialLength, "Partial length should return correct number of elements");

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgUint256Array(calldata, 0, arg.length + 1);
    }

    function testGetArgBytes32Array() public {
        bytes32[] memory arg = new bytes32[](3);
        arg[0] = bytes32("test1");
        arg[1] = bytes32("test2");
        arg[2] = bytes32("test3");
        bytes memory args = abi.encode(arg, address(1), uint256(123), "hello");
        bytes memory calldata = _generateCalldata(args);

        // Test zero length
        bytes32[] memory result = this.targetContract.getArgBytes32Array(calldata, 0, 0);
        assertEq(result.length, 0, "Zero length should return empty array");

        // Test exact length
        result = this.targetContract.getArgBytes32Array(calldata, 0, arg.length);
        assertEq(result, arg, "Exact length should return correct array");

        // Test partial length
        uint256 partialLength = 2;
        result = this.targetContract.getArgBytes32Array(calldata, 0, partialLength);
        assertEq(result.length, partialLength, "Partial length should return correct number of elements");

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgBytes32Array(calldata, 0, arg.length + 1);
    }

    function testGetArgBytes32() public {
        bytes32 arg3 = bytes32("test");
        bytes memory args = _encodeArgs(address(1), 123, arg3, "hello");
        bytes memory calldata = _generateCalldata(args);

        // Test valid offset
        bytes32 result = this.targetContract.getArgBytes32(calldata, 32);
        assertEq(result, arg3, "Valid offset should return correct bytes32");

        // Test misaligned offset
        vm.expectRevert();
        this.targetContract.getArgBytes32(calldata, 33);

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgBytes32(calldata, args.length - 31);
    }

    function testGetArgUint256() public {
        uint256 arg2 = 123;
        bytes memory args = _encodeArgs(address(1), arg2, bytes32("test"), "hello");
        bytes memory calldata = _generateCalldata(args);

        // Test valid offset
        uint256 result = this.targetContract.getArgUint256(calldata, 20);
        assertEq(result, arg2, "Valid offset should return correct uint256");

        // Test misaligned offset
        vm.expectRevert();
        this.targetContract.getArgUint256(calldata, 21);

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgUint256(calldata, args.length - 31);
    }

    function testGetArgUintTypes() public {
        bytes memory args = _encodeArgs(address(1), 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef, bytes32("test"), "hello");
        bytes memory calldata = _generateCalldata(args);

        // Test valid offsets and values for all uint types
        assertEq(this.targetContract.getArgUint248(calldata, 21), 0x34567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint248");
        assertEq(this.targetContract.getArgUint240(calldata, 22), 0x567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint240");
        assertEq(this.targetContract.getArgUint232(calldata, 23), 0x7890abcdef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint232");
        assertEq(this.targetContract.getArgUint224(calldata, 24), 0x90abcdef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint224");
        assertEq(this.targetContract.getArgUint216(calldata, 25), 0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint216");
        assertEq(this.targetContract.getArgUint208(calldata, 26), 0xcdef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint208");
        assertEq(this.targetContract.getArgUint200(calldata, 27), 0xef1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint200");
        assertEq(this.targetContract.getArgUint192(calldata, 28), 0x1234567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint192");
        assertEq(this.targetContract.getArgUint184(calldata, 29), 0x34567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint184");
        assertEq(this.targetContract.getArgUint176(calldata, 30), 0x567890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint176");
        assertEq(this.targetContract.getArgUint168(calldata, 31), 0x7890abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint168");
        assertEq(this.targetContract.getArgUint160(calldata, 32), 0x90abcdef1234567890abcdef1234567890abcdef, "Invalid value for uint160");
        assertEq(this.targetContract.getArgUint152(calldata, 33), 0xabcdef1234567890abcdef1234567890abcdef, "Invalid value for uint152");
        assertEq(this.targetContract.getArgUint144(calldata, 34), 0xcdef1234567890abcdef1234567890abcdef, "Invalid value for uint144");
        assertEq(this.targetContract.getArgUint136(calldata, 35), 0xef1234567890abcdef1234567890abcdef, "Invalid value for uint136");
        assertEq(this.targetContract.getArgUint128(calldata, 36), 0x1234567890abcdef1234567890abcdef, "Invalid value for uint128");
        assertEq(this.targetContract.getArgUint120(calldata, 37), 0x34567890abcdef1234567890abcdef, "Invalid value for uint120");
        assertEq(this.targetContract.getArgUint112(calldata, 38), 0x567890abcdef1234567890abcdef, "Invalid value for uint112");
        assertEq(this.targetContract.getArgUint104(calldata, 39), 0x7890abcdef1234567890abcdef, "Invalid value for uint104");
        assertEq(this.targetContract.getArgUint96(calldata, 40), 0x90abcdef1234567890abcdef, "Invalid value for uint96");
        assertEq(this.targetContract.getArgUint88(calldata, 41), 0xabcdef1234567890abcdef, "Invalid value for uint88");
        assertEq(this.targetContract.getArgUint80(calldata, 42), 0xcdef1234567890abcdef, "Invalid value for uint80");
        assertEq(this.targetContract.getArgUint72(calldata, 43), 0xef1234567890abcdef, "Invalid value for uint72");
        assertEq(this.targetContract.getArgUint64(calldata, 44), 0x1234567890abcdef, "Invalid value for uint64");
        assertEq(this.targetContract.getArgUint56(calldata, 45), 0x34567890abcdef, "Invalid value for uint56");
        assertEq(this.targetContract.getArgUint48(calldata, 46), 0x567890abcdef, "Invalid value for uint48");
        assertEq(this.targetContract.getArgUint40(calldata, 47), 0x7890abcdef, "Invalid value for uint40");
        assertEq(this.targetContract.getArgUint32(calldata, 48), 0x90abcdef, "Invalid value for uint32");
        assertEq(this.targetContract.getArgUint24(calldata, 49), 0xabcdef, "Invalid value for uint24");
        assertEq(this.targetContract.getArgUint16(calldata, 50), 0xcdef, "Invalid value for uint16");
        assertEq(this.targetContract.getArgUint8(calldata, 51), 0xef, "Invalid value for uint8");

        // Test misaligned offsets
        vm.expectRevert();
        this.targetContract.getArgUint248(calldata, 22);
        vm.expectRevert();
        this.targetContract.getArgUint240(calldata, 23);
        vm.expectRevert();
        this.targetContract.getArgUint232(calldata, 24);
        vm.expectRevert();
        this.targetContract.getArgUint224(calldata, 25);
        vm.expectRevert();
        this.targetContract.getArgUint216(calldata, 26);
        vm.expectRevert();
        this.targetContract.getArgUint208(calldata, 27);
        vm.expectRevert();
        this.targetContract.getArgUint200(calldata, 28);
        vm.expectRevert();
        this.targetContract.getArgUint192(calldata, 29);
        vm.expectRevert();
        this.targetContract.getArgUint184(calldata, 30);
        vm.expectRevert();
        this.targetContract.getArgUint176(calldata, 31);
        vm.expectRevert();
        this.targetContract.getArgUint168(calldata, 32);
        vm.expectRevert();
        this.targetContract.getArgUint160(calldata, 33);
        vm.expectRevert();
        this.targetContract.getArgUint152(calldata, 34);
        vm.expectRevert();
        this.targetContract.getArgUint144(calldata, 35);
        vm.expectRevert();
        this.targetContract.getArgUint136(calldata, 36);
        vm.expectRevert();
        this.targetContract.getArgUint128(calldata, 37);
        vm.expectRevert();
        this.targetContract.getArgUint120(calldata, 38);
        vm.expectRevert();
        this.targetContract.getArgUint112(calldata, 39);
        vm.expectRevert();
        this.targetContract.getArgUint104(calldata, 40);
        vm.expectRevert();
        this.targetContract.getArgUint96(calldata, 41);
        vm.expectRevert();
        this.targetContract.getArgUint88(calldata, 42);
        vm.expectRevert();
        this.targetContract.getArgUint80(calldata, 43);
        vm.expectRevert();
        this.targetContract.getArgUint72(calldata, 44);
        vm.expectRevert();
        this.targetContract.getArgUint64(calldata, 45);
        vm.expectRevert();
        this.targetContract.getArgUint56(calldata, 46);
        vm.expectRevert();
        this.targetContract.getArgUint48(calldata, 47);
        vm.expectRevert();
        this.targetContract.getArgUint40(calldata, 48);
        vm.expectRevert();
        this.targetContract.getArgUint32(calldata, 49);
        vm.expectRevert();
        this.targetContract.getArgUint24(calldata, 50);
        vm.expectRevert();
        this.targetContract.getArgUint16(calldata, 51);
        vm.expectRevert();
        this.targetContract.getArgUint8(calldata, 52);

        // Test out-of-bounds
        vm.expectRevert();
        this.targetContract.getArgUint256(calldata, args.length - 31);
    }
}
