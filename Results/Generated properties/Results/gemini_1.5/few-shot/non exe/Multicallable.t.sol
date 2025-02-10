// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    MulticallableImpl test;

    function setUp() public {
        test = new MulticallableImpl();
    }

    function testMulticallable(bytes[] calldata data) public {
        vm.expectRevert(bytes("FAIL"));
        test.multicall(data);
    }

    function testMulticallableFuzz(bytes[] calldata data) public  {
        bytes[] memory result = test.multicall(data);
        assertEq(result.length, data.length);
        for (uint256 i; i < data.length; ++i) {
            (bool success, bytes memory returndata) = address(test).delegatecall(data[i]);
            if (success) {
                assertEq(returndata, result[i]);
            } else {
                assertEq(returndata, result[i]);
            }
        }
    }
}

contract MulticallableImpl is Multicallable {
    function foo() public pure returns (uint256) {
        return 1;
    }

    function bar(uint256 a) public pure returns (uint256) {
        return a + 1;
    }

    function baz(string calldata a) public pure returns (string memory) {
        return string.concat(a, " world");
    }

    function fail() public pure {
        revert("FAIL");
    }
}
