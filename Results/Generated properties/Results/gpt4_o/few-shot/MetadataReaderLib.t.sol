// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";

contract MetadataReaderLibTest is Test {
    using MetadataReaderLib for address;

    address testContract;

    function setUp() public {
        // Deploy a test contract with name, symbol, and decimals functions
        testContract = address(new TestToken());
    }

    function testReadName() public {
        string memory name = testContract.readName();
        assertEq(name, "TestToken");
    }

    function testReadNameWithLimit() public {
        string memory name = testContract.readName(4);
        assertEq(name, "Test");
    }

    function testReadNameWithLimitAndGasStipend() public {
        string memory name = testContract.readName(4, 50000);
        assertEq(name, "Test");
    }

    function testReadSymbol() public {
        string memory symbol = testContract.readSymbol();
        assertEq(symbol, "TTK");
    }

    function testReadSymbolWithLimit() public {
        string memory symbol = testContract.readSymbol(2);
        assertEq(symbol, "TT");
    }

    function testReadSymbolWithLimitAndGasStipend() public {
        string memory symbol = testContract.readSymbol(2, 50000);
        assertEq(symbol, "TT");
    }

    function testReadDecimals() public {
        uint8 decimals = testContract.readDecimals();
        assertEq(decimals, 18);
    }

    function testReadDecimalsWithGasStipend() public {
        uint8 decimals = testContract.readDecimals(50000);
        assertEq(decimals, 18);
    }

    function testReadString() public {
        string memory name = testContract.readString(abi.encodeWithSignature("name()"));
        assertEq(name, "TestToken");
    }

    function testReadStringWithLimit() public {
        string memory name = testContract.readString(abi.encodeWithSignature("name()"), 4);
        assertEq(name, "Test");
    }

    function testReadStringWithLimitAndGasStipend() public {
        string memory name = testContract.readString(abi.encodeWithSignature("name()"), 4, 50000);
        assertEq(name, "Test");
    }

    function testReadUint() public {
        uint256 decimals = testContract.readUint(abi.encodeWithSignature("decimals()"));
        assertEq(decimals, 18);
    }

    function testReadUintWithGasStipend() public {
        uint256 decimals = testContract.readUint(abi.encodeWithSignature("decimals()"), 50000);
        assertEq(decimals, 18);
    }
}

contract TestToken {
    function name() public pure returns (string memory) {
        return "TestToken";
    }

    function symbol() public pure returns (string memory) {
        return "TTK";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }
}