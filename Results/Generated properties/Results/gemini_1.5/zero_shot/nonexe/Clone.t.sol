// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Clone.sol";

contract CloneTest is Test {
    /// @dev Empty reserved space.
    uint256[50] private _____gap;

    function setUp() public virtual {}

    function testFuzzGetArgUint256(uint256 x) public {
        bytes memory data = abi.encodePacked(x, uint16(32));
        vm.record();
        bytes32 hash = keccak256(data);
        address addr = address(uint160(uint256(hash)));
        vm.assume(addr.code.length == 0);
        vm.etch(addr, data);
        assertEq(Clone(addr)._getArgUint256(0), x);
    }

    function testFuzzGetArgUint256Array(uint256[] memory x) public {
        bytes memory data = abi.encodePacked(x, uint16(x.length * 32));
        vm.record();
        bytes32 hash = keccak256(data);
        address addr = address(uint160(uint256(hash)));
        vm.assume(addr.code.length == 0);
        vm.etch(addr, data);
        uint256[] memory result = Clone(addr)._getArgUint256Array(0, x.length);
        assertEq(result.length, x.length);
        for (uint256 i; i < x.length; ++i) {
            assertEq(result[i], x[i]);
        }
    }

    function testFuzzGetArgBytes32Array(bytes32[] memory x) public {
        bytes memory data = abi.encodePacked(x, uint16(x.length * 32));
        vm.record();
        bytes32 hash = keccak256(data);
        address addr = address(uint160(uint256(hash)));
        vm.assume(addr.code.length == 0);
        vm.etch(addr, data);
        bytes32[] memory result = Clone(addr)._getArgBytes32Array(0, x.length);
        assertEq(result.length, x.length);
        for (uint256 i; i < x.length; ++i) {
            assertEq(result[i], x[i]);
        }
    }

    function testFuzzGetArgBytes(bytes memory x) public {
        bytes memory data = abi.encodePacked(x, uint16(x.length));
        vm.record();
        bytes32 hash = keccak256(data);
        address addr = address(uint160(uint256(hash)));
        vm.assume(addr.code.length == 0);
        vm.etch(addr, data);
        assertEq(Clone(addr)._getArgBytes(0, x.length), x);
    }

    function testFuzzGetArgBytesFull(bytes memory x) public {
        bytes memory data = abi.encodePacked(x, uint16(x.length));
        vm.record();
        bytes32 hash = keccak256(data);
        address addr = address(uint160(uint256(hash)));
        vm.assume(addr.code.length == 0);
        vm.etch(addr, data);
        assertEq(Clone(addr)._getArgBytes(), x);
    }
}