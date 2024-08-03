// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";
contract MetadataReaderLibTest is Test {
    address internal constant _TEST_CONTRACT = 0x10C0f93F64E3c8A1a2E2D2771ffC51054E4D7d7c;
    function testReadName(address target) public view {
        string memory name = MetadataReaderLib.readName(target);
        console2.logString(name);
    }
    function testReadNameWithLimit(address target, uint256 limit) public view {
        vm.assume(limit <= 10000 && limit > 0);
        string memory name = MetadataReaderLib.readName(target, limit);
        console2.logString(name);
    }
    function testReadNameWithLimitAndGasStipend(address target, uint256 limit, uint256 gasStipend)
        public
        view
    {
        vm.assume(limit <= 10000 && limit > 0);
        string memory name = MetadataReaderLib.readName(target, limit, gasStipend);
        console2.logString(name);
    }
    function testReadSymbol(address target) public view {
        string memory symbol = MetadataReaderLib.readSymbol(target);
        console2.logString(symbol);
    }
    function testReadSymbolWithLimit(address target, uint256 limit) public view {
        vm.assume(limit <= 10000 && limit > 0);
        string memory symbol = MetadataReaderLib.readSymbol(target, limit);
        console2.logString(symbol);
    }
    function testReadSymbolWithLimitAndGasStipend(address target, uint256 limit, uint256 gasStipend)
        public
        view
    {
        vm.assume(limit <= 10000 && limit > 0);
        string memory symbol = MetadataReaderLib.readSymbol(target, limit, gasStipend);
        console2.logString(symbol);
    }
    function testReadString(address target, bytes calldata data) public view {
        string memory result = MetadataReaderLib.readString(target, data);
        console2.logString(result);
    }
    function testReadStringWithLimit(address target, bytes calldata data, uint256 limit)
        public
        view
    {
        vm.assume(limit <= 10000 && limit > 0);
        string memory result = MetadataReaderLib.readString(target, data, limit);
        console2.logString(result);
    }
    function testReadStringWithLimitAndGasStipend(
        address target,
        bytes calldata data,
        uint256 limit,
        uint256 gasStipend
    ) public view {
        vm.assume(limit <= 10000 && limit > 0);
        string memory result = MetadataReaderLib.readString(target, data, limit, gasStipend);
        console2.logString(result);
    }
    function testReadDecimals(address target) public {
        uint8 decimals = MetadataReaderLib.readDecimals(target);
        console2.logUint(decimals);
    }
    function testReadDecimalsWithGasStipend(address target, uint256 gasStipend) public {
        uint8 decimals = MetadataReaderLib.readDecimals(target, gasStipend);
        console2.logUint(decimals);
    }
    function testReadUint(address target, bytes calldata data) public {
        uint256 result = MetadataReaderLib.readUint(target, data);
        console2.logUint(result);
    }
    function testReadUintWithGasStipend(address target, bytes calldata data, uint256 gasStipend)
        public
    {
        uint256 result = MetadataReaderLib.readUint(target, data, gasStipend);
        console2.logUint(result);
    }
}