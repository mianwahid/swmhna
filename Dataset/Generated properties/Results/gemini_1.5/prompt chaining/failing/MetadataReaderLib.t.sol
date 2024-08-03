// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";
contract MetadataReaderLibTest is Test {
    address internal constant mockAddress = address(0x1234);

    function testReadName() public {
        string memory name = MetadataReaderLib.readName(address(this));
        assertEq(name, "MetadataReaderLibTest");
    }

    function testReadName_WithLimit() public {
        uint256 limit = 10;
        string memory name = MetadataReaderLib.readName(address(this), limit);
        assertEq(name, "MetadataRea");
    }

    function testReadName_WithGasStipend() public {
        uint256 gasStipend = 200000;
        string memory name = MetadataReaderLib.readName(address(this), 1000, gasStipend);
        assertEq(name, "MetadataReaderLibTest");
    }

    function testReadName_ContractWithoutName() public {
        string memory name = MetadataReaderLib.readName(mockAddress);
        assertEq(name, "");
    }

    function testReadSymbol() public {
        string memory symbol = MetadataReaderLib.readSymbol(address(this));
        assertEq(symbol, "MRLT");
    }

    function testReadSymbol_WithLimit() public {
        uint256 limit = 2;
        string memory symbol = MetadataReaderLib.readSymbol(address(this), limit);
        assertEq(symbol, "MR");
    }

    function testReadSymbol_WithGasStipend() public {
        uint256 gasStipend = 200000;
        string memory symbol = MetadataReaderLib.readSymbol(address(this), 1000, gasStipend);
        assertEq(symbol, "MRLT");
    }

    function testReadSymbol_ContractWithoutSymbol() public {
        string memory symbol = MetadataReaderLib.readSymbol(mockAddress);
        assertEq(symbol, "");
    }

    function testReadString() public {
        bytes memory data = abi.encodeWithSignature("name()");
        string memory result = MetadataReaderLib.readString(address(this), data);
        assertEq(result, "MetadataReaderLibTest");
    }

    function testReadString_WithLimit() public {
        bytes memory data = abi.encodeWithSignature("name()");
        uint256 limit = 10;
        string memory result = MetadataReaderLib.readString(address(this), data, limit);
        assertEq(result, "MetadataRea");
    }

    function testReadString_WithGasStipend() public {
        bytes memory data = abi.encodeWithSignature("name()");
        uint256 gasStipend = 200000;
        string memory result = MetadataReaderLib.readString(
            address(this),
            data,
            1000,
            gasStipend
        );
        assertEq(result, "MetadataReaderLibTest");
    }

    function testReadString_InvalidCalldata() public {
        bytes memory data = abi.encodeWithSignature("invalidFunction()");
        string memory result = MetadataReaderLib.readString(address(this), data);
        assertEq(result, "");
    }

    function testReadDecimals() public {
        uint8 decimals = MetadataReaderLib.readDecimals(address(this));
        assertEq(decimals, 18);
    }

    function testReadDecimals_WithGasStipend() public {
        uint256 gasStipend = 200000;
        uint8 decimals = MetadataReaderLib.readDecimals(address(this), gasStipend);
        assertEq(decimals, 18);
    }

    function testReadDecimals_ContractWithoutDecimals() public {
        uint8 decimals = MetadataReaderLib.readDecimals(mockAddress);
        assertEq(decimals, 0);
    }

    function testReadUint() public {
        bytes memory data = abi.encodeWithSignature("totalSupply()");
        uint256 result = MetadataReaderLib.readUint(address(this), data);
        assertEq(result, 0);
    }

    function testReadUint_WithGasStipend() public {
        bytes memory data = abi.encodeWithSignature("totalSupply()");
        uint256 gasStipend = 200000;
        uint256 result = MetadataReaderLib.readUint(address(this), data, gasStipend);
        assertEq(result, 0);
    }

    function testReadUint_InvalidCalldata() public {
        bytes memory data = abi.encodeWithSignature("invalidFunction()");
        uint256 result = MetadataReaderLib.readUint(address(this), data);
        assertEq(result, 0);
    }
}
