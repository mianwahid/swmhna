// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    Multicallable multicallable;

    function setUp() public {
        multicallable = new Multicallable();
    }

    function testEmptyDataArray() public {
        bytes[] memory data = new bytes[](0);
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 0);
    }

    function testSingleCallSuccess() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("someFunction()");
        bytes[] memory results = multicallable.multicall(data);
        // Assuming someFunction() returns some known value
        assertEq(results.length, 1);
        // Add more assertions based on the expected return value of someFunction()
    }

    function testMultipleCallsSuccess() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("someFunction()");
        data[1] = abi.encodeWithSignature("anotherFunction()");
        bytes[] memory results = multicallable.multicall(data);
        assertEq(results.length, 2);
        // Add more assertions based on the expected return values of someFunction() and anotherFunction()
    }

    function testSingleCallRevert() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertingFunction()");
        vm.expectRevert();
        multicallable.multicall(data);
    }

    function testMultipleCallsWithOneRevert() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("someFunction()");
        data[1] = abi.encodeWithSignature("revertingFunction()");
        vm.expectRevert();
        multicallable.multicall(data);
    }

    function testGasConsumption() public {
        bytes[] memory data = new bytes[](10);
        for (uint i = 0; i < 10; i++) {
            data[i] = abi.encodeWithSignature("someFunction()");
        }
        uint gasStart = gasleft();
        multicallable.multicall(data);
        uint gasUsed = gasStart - gasleft();
        console2.log("Gas used for 10 calls:", gasUsed);
        // Add assertions based on expected gas usage
    }

    function testReturnDataSizeAlignment() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("functionReturningVariousSizes()");
        bytes[] memory results = multicallable.multicall(data);
        // Add assertions to check the alignment of return data size
    }

    function testNonPayableFunction() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("someFunction()");
        vm.expectRevert();
        multicallable.multicall{value: 1 ether}(data);
    }

    function testDelegatecallContext() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("stateModifyingFunction()");
        multicallable.multicall(data);
        // Add assertions to verify state changes
    }

    function testRevertDataPropagation() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertingFunctionWithSpecificData()");
        vm.expectRevert(bytes("Specific revert data"));
        multicallable.multicall(data);
    }

    function testMemoryManagement() public {
        bytes[] memory data = new bytes[](100);
        for (uint i = 0; i < 100; i++) {
            data[i] = abi.encodeWithSignature("someFunction()");
        }
        multicallable.multicall(data);
        // Add assertions to verify memory usage
    }

    function testCalldataCopying() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("functionWithCalldata(bytes)", abi.encode("test"));
        bytes[] memory results = multicallable.multicall(data);
        // Add assertions to verify calldata copying
    }
}