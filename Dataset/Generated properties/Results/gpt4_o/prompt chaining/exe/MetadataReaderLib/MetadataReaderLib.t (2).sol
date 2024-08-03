// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";

contract MetadataReaderLibTest is Test {
    using MetadataReaderLib for address;

    address testContract;
    address eoa;

    function setUp() public {
        // Deploy a test contract with name, symbol, and decimals functions
        testContract = address(new TestToken());
        eoa = address(0x1234567890123456789012345678901234567890);
    }

    // General Invariants
    function testGasStipendInvariant() public {
        string memory name = testContract.readName();
        assert(bytes(name).length > 0);
    }

    function testStringLengthLimitInvariant() public {
        string memory name = testContract.readName();
        assert(bytes(name).length <= MetadataReaderLib.STRING_LIMIT_DEFAULT);
    }

    // String Reading Functions
    // readName(address target)
    function testReadName() public {
        string memory name = testContract.readName();
        assertEq(name, "TestToken");

        name = eoa.readName();
        assertEq(name, "");
    }

    // readName(address target, uint256 limit)
    function testReadNameWithLimit() public {
        string memory name = testContract.readName(5);
        assertEq(name, "TestT");

        name = testContract.readName(100);
        assertEq(name, "TestToken");
    }

    // readName(address target, uint256 limit, uint256 gasStipend)
    function testReadNameWithLimitAndGasStipend() public {
        string memory name = testContract.readName(5, 50000);
        assertEq(name, "TestT");

        name = testContract.readName(100, 50000);
        assertEq(name, "TestToken");

        name = testContract.readName(100, 1000);
        assertEq(name, "");
    }

    // readSymbol(address target)
    function testReadSymbol() public {
        string memory symbol = testContract.readSymbol();
        assertEq(symbol, "TT");

        symbol = eoa.readSymbol();
        assertEq(symbol, "");
    }

    // readSymbol(address target, uint256 limit)
    function testReadSymbolWithLimit() public {
        string memory symbol = testContract.readSymbol(1);
        assertEq(symbol, "T");

        symbol = testContract.readSymbol(10);
        assertEq(symbol, "TT");
    }

    // readSymbol(address target, uint256 limit, uint256 gasStipend)
    function testReadSymbolWithLimitAndGasStipend() public {
        string memory symbol = testContract.readSymbol(1, 50000);
        assertEq(symbol, "T");

        symbol = testContract.readSymbol(10, 50000);
        assertEq(symbol, "TT");

        symbol = testContract.readSymbol(10, 1000);
        assertEq(symbol, "");
    }

    // readString(address target, bytes memory data)
    function testReadString() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = testContract.readString(data);
        assertEq(result, "TestToken");

        result = eoa.readString(data);
        assertEq(result, "");
    }

    // readString(address target, bytes memory data, uint256 limit)
    function testReadStringWithLimit() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = testContract.readString(data, 5);
        assertEq(result, "TestT");

        result = testContract.readString(data, 100);
        assertEq(result, "TestToken");
    }

    // readString(address target, bytes memory data, uint256 limit, uint256 gasStipend)
    function testReadStringWithLimitAndGasStipend() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = testContract.readString(data, 5, 50000);
        assertEq(result, "TestT");

        result = testContract.readString(data, 100, 50000);
        assertEq(result, "TestToken");

        result = testContract.readString(data, 100, 1000);
        assertEq(result, "");
    }

    // Unsigned Integer Reading Functions
    // readDecimals(address target)
    function testReadDecimals() public {
        uint8 decimals = testContract.readDecimals();
        assertEq(decimals, 18);

        decimals = eoa.readDecimals();
        assertEq(decimals, 0);
    }

    // readDecimals(address target, uint256 gasStipend)
    function testReadDecimalsWithGasStipend() public {
        uint8 decimals = testContract.readDecimals(50000);
        assertEq(decimals, 18);

        decimals = testContract.readDecimals(1000);
        assertEq(decimals, 0);
    }

    // readUint(address target, bytes memory data)
    function testReadUint() public {
        bytes memory data = abi.encodeWithSignature("decimals()");
        uint256 result = testContract.readUint(data);
        assertEq(result, 18);

        result = eoa.readUint(data);
        assertEq(result, 0);
    }

    // readUint(address target, bytes memory data, uint256 gasStipend)
    function testReadUintWithGasStipend() public {
        bytes memory data = abi.encodeWithSignature("decimals()");
        uint256 result = testContract.readUint(data, 50000);
        assertEq(result, 18);

        result = testContract.readUint(data, 1000);
        assertEq(result, 0);
    }
}

contract TestToken {
    function name() public pure returns (string memory) {
        return "TestToken";
    }

    function symbol() public pure returns (string memory) {
        return "TT";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }
}