// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Clone.sol";

contract CloneTest is Test {
    function testGetArgUint(uint256 x) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), x);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
//        assertEq(Clone(clone)._getArgUint256(0), x);
    }

    function testGetArgUintArray(uint256[2] memory a) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), a);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
//        uint256[] memory result = Clone(clone)._getArgUint256Array(0, 2);
        assertEq(result.length, 2);
        assertEq(result[0], a[0]);
        assertEq(result[1], a[1]);
    }

    function testGetArgBytes(bytes calldata a) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), a);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
        assertEq(Clone(clone)._getArgBytes(0, a.length), a);
    }

    function testGetArgAddress(address a) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), a);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
        assertEq(Clone(clone)._getArgAddress(0), a);
    }

    function testGetArgBytes32(bytes32 a) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), a);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
        assertEq(Clone(clone)._getArgBytes32(0), a);
    }

    function testGetArgBytes32Array(bytes32[2] memory a) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), a);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
        bytes32[] memory result = Clone(clone)._getArgBytes32Array(0, 2);
        assertEq(result.length, 2);
        assertEq(result[0], a[0]);
        assertEq(result[1], a[1]);
    }

    function testGetArgUint16(uint16 x) public {
        bytes memory data = abi.encodePacked(bytes32(uint256(4)), bytes2(0), x);
        vm.recordLogs();
        address clone = this.deploy(data);
        assertEq(this.getImmutableArgsOffset(clone), 4);
        assertEq(Clone(clone)._getArgUint16(2), x);
    }

    function testFuzzGetArgUint(uint256 x) public {
        vm.assume(x != 0);
        this.testGetArgUint(x);
    }

    function testFuzzGetArgUintArray(uint256[2] memory a) public {
        vm.assume(a[0] != 0 || a[1] != 0);
        this.testGetArgUintArray(a);
    }

    function testFuzzGetArgBytes(bytes calldata a) public {
        vm.assume(a.length != 0);
        this.testGetArgBytes(a);
    }

    function testFuzzGetArgAddress(address a) public {
        this.testGetArgAddress(a);
    }

    function testFuzzGetArgBytes32(bytes32 a) public {
        this.testGetArgBytes32(a);
    }

    function testFuzzGetArgBytes32Array(bytes32[2] memory a) public {
        this.testGetArgBytes32Array(a);
    }

    function testFuzzGetArgUint16(uint16 x) public {
        this.testGetArgUint16(x);
    }

    function deploy(bytes memory data) public returns (address result) {
        bytes memory bytecode = abi.encodePacked(
            // constructor header
            hex"608060405234801561001057600080fd5b50",
            // constructor body
            // get length of data
            hex"366000511461002d57600080fd5b",
            // revert if no data
            // store data length
            hex"6002600052",
            // return
            hex"60206000f3",
            data
        );
        /// @solidity memory-safe-assembly
        assembly {
            result := create(0, add(bytecode, 32), mload(bytecode))
        }
    }

    function getImmutableArgsOffset(address clone) public view returns (uint256 offset) {
        /// @solidity memory-safe-assembly
        assembly {
            offset := sub(extcodesize(clone), shr(240, byte(0, extcodehash(clone))))
        }
    }
}
