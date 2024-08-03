// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    Multicallable public mc;

    function setUp() public {
        mc = new Multicallable();
    }

    function testMulticallableEmpty() public {
        bytes[] calldata data = new bytes[](0);
        bytes[] memory results = mc.multicall(data);
        assertEq(results.length, 0);
    }

    function testMulticallableSingle() public {
        bytes[] calldata data = new bytes[](1);
        data = abi.encodePacked(data, abi.encodeWithSignature("test()"));
        bytes[] memory results = mc.multicall(data);
        assertEq(results.length, 1);
    }

//    function testMulticallableMultiple() public {
//        bytes[] calldata data = new bytes[](2);
//        data = abi.encodePacked(data, abi.encodeWithSignature("test()"));
//        data = abi.encodePacked(data, abi.encodeWithSignature("test()"));
//        bytes[] memory results = mc.multicall(data);
//        assertEq(results.length, 2);
//    }

//    function testMulticallableRevert() public {
//        bytes[] calldata data = new bytes[](2);
//        data = abi.encodePacked(data, abi.encodeWithSignature("test()"));
//        data = abi.encodePacked(data, abi.encodeWithSignature("revertTest()"));
//        vm.expectRevert();
//        mc.multicall(data);
//    }

    function test() public pure returns (uint256) {
        return 1;
    }

    function revertTest() public pure {
        revert("test");
    }
}
