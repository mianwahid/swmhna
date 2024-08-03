// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    MulticallableStub public target;

    event Result(bytes result);

    function setUp() public {
        target = new MulticallableStub();
    }

    function testMulticallable() public {
        bytes[] memory data = new bytes[](3);
        data[0] = abi.encodeWithSignature("fn0()");
        data[1] = abi.encodeWithSignature("fn1(uint256)", 1);
        data[2] = abi.encodeWithSignature("fn2(uint256,uint256)", 2, 3);
        bytes[] memory results = target.multicall(data);
        assertEq(results.length, 3);
        assertEq(abi.decode(results[0], (uint256)), 0);
        assertEq(abi.decode(results[1], (uint256)), 1);
        assertEq(abi.decode(results[2], (uint256)), 5);
    }


}

contract MulticallableStub is Multicallable {
    function fn0() public pure returns (uint256) {
        return 0;
    }

    function fn1(uint256 a) public pure returns (uint256) {
        return a;
    }

    function fn2(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function fn3() public pure {
        revert("FAIL");
    }
}