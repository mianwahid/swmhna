// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";

contract MetadataReaderLibTest is Test {
    using MetadataReaderLib for address;

    address target;

    function setUp() public {
        // Deploy a mock contract or use a known contract address for testing
        target = address(new MockContract());
    }

    function testReadName() public {
        string memory name = target.readName();
        console2.log("Name:", name);
        assert(bytes(name).length > 0);
    }

    function testReadNameWithLimit() public {
        string memory name = target.readName(10);
        console2.log("Name with limit:", name);
        assert(bytes(name).length <= 10);
    }

    function testReadNameWithLimitAndGasStipend() public {
        string memory name = target.readName(10, 50000);
        console2.log("Name with limit and gas stipend:", name);
        assert(bytes(name).length <= 10);
    }

    function testReadSymbol() public {
        string memory symbol = target.readSymbol();
        console2.log("Symbol:", symbol);
        assert(bytes(symbol).length > 0);
    }

    function testReadSymbolWithLimit() public {
        string memory symbol = target.readSymbol(5);
        console2.log("Symbol with limit:", symbol);
        assert(bytes(symbol).length <= 5);
    }

    function testReadSymbolWithLimitAndGasStipend() public {
        string memory symbol = target.readSymbol(5, 50000);
        console2.log("Symbol with limit and gas stipend:", symbol);
        assert(bytes(symbol).length <= 5);
    }

    function testReadString() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = target.readString(data);
        console2.log("String result:", result);
        assert(bytes(result).length > 0);
    }

    function testReadStringWithLimit() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = target.readString(data, 10);
        console2.log("String result with limit:", result);
        assert(bytes(result).length <= 10);
    }

    function testReadStringWithLimitAndGasStipend() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = target.readString(data, 10, 50000);
        console2.log("String result with limit and gas stipend:", result);
        assert(bytes(result).length <= 10);
    }

    function testReadDecimals() public {
        uint8 decimals = target.readDecimals();
        console2.log("Decimals:", decimals);
        assert(decimals > 0);
    }

    function testReadDecimalsWithGasStipend() public {
        uint8 decimals = target.readDecimals(50000);
        console2.log("Decimals with gas stipend:", decimals);
        assert(decimals > 0);
    }

    function testReadUint() public {
        bytes memory data = abi.encodeWithSignature("totalSupply()");
        uint256 result = target.readUint(data);
        console2.log("Uint result:", result);
        assert(result > 0);
    }

    function testReadUintWithGasStipend() public {
        bytes memory data = abi.encodeWithSignature("totalSupply()");
        uint256 result = target.readUint(data, 50000);
        console2.log("Uint result with gas stipend:", result);
        assert(result > 0);
    }

    // Edge case tests
    function testReadNameFromEOA() public {
        address eoa = address(0x123);
        string memory name = eoa.readName();
        console2.log("Name from EOA:", name);
        assert(bytes(name).length == 0);
    }

    function testReadSymbolFromEOA() public {
        address eoa = address(0x123);
        string memory symbol = eoa.readSymbol();
        console2.log("Symbol from EOA:", symbol);
        assert(bytes(symbol).length == 0);
    }

    function testReadStringFromEOA() public {
        address eoa = address(0x123);
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = eoa.readString(data);
        console2.log("String result from EOA:", result);
        assert(bytes(result).length == 0);
    }

    function testReadUintFromEOA() public {
        address eoa = address(0x123);
        bytes memory data = abi.encodeWithSignature("totalSupply()");
        uint256 result = eoa.readUint(data);
        console2.log("Uint result from EOA:", result);
        assert(result == 0);
    }

    function testReadDecimalsFromEOA() public {
        address eoa = address(0x123);
        uint8 decimals = eoa.readDecimals();
        console2.log("Decimals from EOA:", decimals);
        assert(decimals == 0);
    }
}

contract MockContract {
    function name() external pure returns (string memory) {
        return "MockToken";
    }

    function symbol() external pure returns (string memory) {
        return "MTK";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() external pure returns (uint256) {
        return 1000000;
    }
}