// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";

contract MetadataReaderLibTest is Test {
    address target;

    function setUp() public {
        target = address(new TestContract());
    }

    function testReadName() public {
        string memory name = MetadataReaderLib.readName(target);
        assertEq(name, "TestContract");
    }

    function testReadSymbol() public {
        string memory symbol = MetadataReaderLib.readSymbol(target);
        assertEq(symbol, "TC");
    }

    function testReadDecimals() public {
        uint8 decimals = MetadataReaderLib.readDecimals(target);
        assertEq(decimals, 18);
    }

    function testReadString() public {
        string memory customData = MetadataReaderLib.readString(target, abi.encodeWithSignature("customData()"));
        assertEq(customData, "Custom Data");
    }

    function testReadUint() public {
        uint256 totalSupply = MetadataReaderLib.readUint(target, abi.encodeWithSignature("totalSupply()"));
        assertEq(totalSupply, 1000000);
    }

//    function testFailReadInvalidFunction() public {
//        MetadataReaderLib.readString(target, abi.encodeWithSignature("nonExistentFunction()"));
//    }

//    function testFailReadInvalidUintFunction() public {
//        MetadataReaderLib.readUint(target, abi.encodeWithSignature("nonExistentFunction()"));
//    }

    function testReadNameWithLimit() public {
        string memory name = MetadataReaderLib.readName(target, 5);
        assertEq(name, "TestC"); // Expected to be truncated
    }

    function testReadSymbolWithGasStipend() public {
        string memory symbol = MetadataReaderLib.readSymbol(target, 3, 50000);
        assertEq(symbol, "TC"); // Not truncated, within limit
    }
}

contract TestContract {
    function name() external pure returns (string memory) {
        return "TestContract";
    }

    function symbol() external pure returns (string memory) {
        return "TC";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() external pure returns (uint256) {
        return 1000000;
    }

    function customData() external pure returns (string memory) {
        return "Custom Data";
    }
}