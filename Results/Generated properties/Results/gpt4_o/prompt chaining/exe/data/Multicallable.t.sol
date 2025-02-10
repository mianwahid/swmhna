// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/Multicallable.sol";

contract MulticallableTest is Test {
    MulticallableTestContract testContract;

    function setUp() public {
        testContract = new MulticallableTestContract();
    }

    function testEmptyDataArray() public {
        bytes[] memory data = new bytes[](0);
        bytes[] memory results = testContract.multicall(data);
        assert(results.length == 0);
    }

    function testSingleCallSuccess() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("someMethod()");
        bytes[] memory results = testContract.multicall(data);
        assert(results.length == 1);
        assert(keccak256(results[0]) == keccak256(abi.encode("someMethodResult")));
    }

    function testMultipleCallsSuccess() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("methodOne()");
        data[1] = abi.encodeWithSignature("methodTwo()");
        bytes[] memory results = testContract.multicall(data);
        assert(results.length == 2);
        assert(keccak256(results[0]) == keccak256(abi.encode("methodOneResult")));
        assert(keccak256(results[1]) == keccak256(abi.encode("methodTwoResult")));
    }

    function testSingleCallRevert() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("revertingMethod()");
        try testContract.multicall(data) {
            assert(false); // Should not reach here
        } catch (bytes memory reason) {
            assert(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "revert reason")));
        }
    }

    function testMultipleCallsWithOneRevert() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("methodOne()");
        data[1] = abi.encodeWithSignature("revertingMethod()");
        try testContract.multicall(data) {
            assert(false); // Should not reach here
        } catch (bytes memory reason) {
            assert(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "revert reason")));
        }
    }

    function testGasConsumption() public {
        bytes[] memory data = new bytes[](100);
        for (uint i = 0; i < 100; i++) {
            data[i] = abi.encodeWithSignature("someMethod()");
        }
        testContract.multicall(data);
    }

    function testNonPayable() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("someMethod()");
        (bool success, ) = address(testContract).call{value: 1 ether}(abi.encodeWithSignature("multicall(bytes[])", data));
        assert(!success);
    }

    function testReturnDataIntegrity() public {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encodeWithSignature("methodWithReturnData1()");
        data[1] = abi.encodeWithSignature("methodWithReturnData2()");
        bytes[] memory results = testContract.multicall(data);
        assert(results.length == 2);
        assert(keccak256(results[0]) == keccak256(abi.encode("returnData1")));
        assert(keccak256(results[1]) == keccak256(abi.encode("returnData2")));
    }

    function testDelegatecallContext() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("modifyState()");
        testContract.multicall(data);
        assert(testContract.state() == 1);
    }

//    function testReentrancy() public {
//        bytes[] memory data = new bytes[](1);
//        data[0] = abi.encodeWithSignature("reentrantMethod()");
//        try testContract.multicall(data) {
//            assert(false); // Should not reach here
//        } catch (bytes memory reason) {
//            assert(keccak256(reason) == keccak256(abi.encodeWithSignature("Error(string)", "reentrancy detected")));
//        }
//    }

    function testInvalidCalldata() public {
        bytes[] memory data = new bytes[](1);
        data[0] = hex"12345678"; // Invalid calldata
        try testContract.multicall(data) {
            assert(false); // Should not reach here
        } catch (bytes memory reason) {
            // Expecting a revert due to invalid calldata
        }
    }

    function testBoundaryConditions() public {
        bytes[] memory data = new bytes[](256);
        for (uint i = 0; i < 256; i++) {
            data[i] = abi.encodeWithSignature("someMethod()");
        }
        testContract.multicall(data);
    }
}

contract MulticallableTestContract is Multicallable {
    uint256 public state;

    function someMethod() public pure returns (string memory) {
        return "someMethodResult";
    }

    function methodOne() public pure returns (string memory) {
        return "methodOneResult";
    }

    function methodTwo() public pure returns (string memory) {
        return "methodTwoResult";
    }

    function revertingMethod() public pure {
        revert("revert reason");
    }

    function methodWithReturnData1() public pure returns (string memory) {
        return "returnData1";
    }

    function methodWithReturnData2() public pure returns (string memory) {
        return "returnData2";
    }

    function modifyState() public {
        state = 1;
    }

    function reentrantMethod() public {
        bytes[] memory data = new bytes[](1);
        data[0] = abi.encodeWithSignature("someMethod()");
        this.multicall(data);
    }
}