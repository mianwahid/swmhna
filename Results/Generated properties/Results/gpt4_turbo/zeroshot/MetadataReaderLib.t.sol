// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/MetadataReaderLib.sol";

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

    function testReadNameWithLimit() public {
        string memory name = MetadataReaderLib.readName(target, 4);
        assertEq(name, "Test");
    }

    function testReadSymbolWithLimit() public {
        string memory symbol = MetadataReaderLib.readSymbol(target, 1);
        assertEq(symbol, "T");
    }

    function testReadNameWithLimitAndGas() public {
        string memory name = MetadataReaderLib.readName(target, 4, 200000);
        assertEq(name, "Test");
    }

    function testReadSymbolWithLimitAndGas() public {
        string memory symbol = MetadataReaderLib.readSymbol(target, 1, 200000);
        assertEq(symbol, "T");
    }

    function testReadDecimalsWithGas() public {
        uint8 decimals = MetadataReaderLib.readDecimals(target, 200000);
        assertEq(decimals, 18);
    }

    function testReadString() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = MetadataReaderLib.readString(target, data);
        assertEq(result, "TestContract");
    }

    function testReadUint() public {
        bytes memory data = abi.encodeWithSignature("decimals()");
        uint256 result = MetadataReaderLib.readUint(target, data);
        assertEq(result, 18);
    }

    function testReadStringWithLimit() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = MetadataReaderLib.readString(target, data, 4);
        assertEq(result, "Test");
    }

    function testReadUintWithGas() public {
        bytes memory data = abi.encodeWithSignature("decimals()");
        uint256 result = MetadataReaderLib.readUint(target, data, 200000);
        assertEq(result, 18);
    }

    // function testFailReadStringNoReturnData() public {
    //     address invalidTarget = address(0x1);
    //     bytes memory data = abi.encodeWithSignature("name()");
    //     MetadataReaderLib.readString(invalidTarget, data);
    // }

    // function testFailReadUintNoReturnData() public {
    //     address invalidTarget = address(0x1);
    //     bytes memory data = abi.encodeWithSignature("decimals()");
    //     MetadataReaderLib.readUint(invalidTarget, data);
    // }
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
}
