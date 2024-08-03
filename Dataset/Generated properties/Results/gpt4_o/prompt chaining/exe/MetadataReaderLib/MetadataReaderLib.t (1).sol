// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";



    // Mock contract to simulate different behaviors
    contract MockContract {
        function name() external pure returns (string memory) {
            return "MockName";
        }

        function symbol() external pure returns (string memory) {
            return "MockSymbol";
        }

        function decimal() external pure returns (uint8) {
            return 18;
        }

        function revertName() external pure {
            revert("Revert");
        }

        function emptyName() external pure returns (string memory) {
            return "";
        }

        function longName() external pure returns (string memory) {
            return "ThisIsAVeryLongNameThatExceedsTheLimit";
        }

        function nullByteName() external pure returns (string memory) {
            return string(abi.encodePacked("NullByte", bytes1(0), "Name"));
        }
    }


contract MetadataReaderLibTest is Test {
    using MetadataReaderLib for address;

    address target;

    function setUp() public {
        target = address(new MockContract());
    }

    // Invariants for readName Functions
//    function testReadNameEmptyStringOnRevert() public {
//        string memory result = address(target).readName();
//        assertEq(result, "MockName");
//
//        result = address(target).readName(address(new MockContract()).revertName.selector);
//        assertEq(result, "");
//    }
//
//    function testReadNameEmptyStringOnNoReturnData() public {
//        string memory result = address(target).readName(address(new MockContract()).emptyName.selector);
//        assertEq(result, "");
//    }

//    function testReadNameCorrectStringTruncation() public {
//        string memory result = address(target).readName(address(new MockContract()).longName.selector, 10);
//        assertEq(result, "ThisIsAVer");
//    }

//    function testReadNameCorrectStringWithNullByte() public {
//        string memory result = address(target).readName(address(new MockContract()).nullByteName.selector);
//        assertEq(result, "NullByte");
//    }

//    function testReadNameCorrectGasStipendHandling() public {
//        string memory result = address(target).readName(address(new MockContract()).name.selector, 1000, 50000);
//        assertEq(result, "MockName");
//    }
//
//    // Invariants for readSymbol Functions
//    function testReadSymbolEmptyStringOnRevert() public {
//        string memory result = address(target).readSymbol();
//        assertEq(result, "MockSymbol");
//
//        result = address(target).readSymbol(address(new MockContract()).revertName.selector);
//        assertEq(result, "");
//    }
//
//    function testReadSymbolEmptyStringOnNoReturnData() public {
//        string memory result = address(target).readSymbol(address(new MockContract()).emptyName.selector);
//        assertEq(result, "");
//    }
//
//    function testReadSymbolCorrectStringTruncation() public {
//        string memory result = address(target).readSymbol(address(new MockContract()).longName.selector, 10);
//        assertEq(result, "ThisIsAVer");
//    }
//
//    function testReadSymbolCorrectStringWithNullByte() public {
//        string memory result = address(target).readSymbol(address(new MockContract()).nullByteName.selector);
//        assertEq(result, "NullByte");
//    }
//
//    function testReadSymbolCorrectGasStipendHandling() public {
//        string memory result = address(target).readSymbol(address(new MockContract()).symbol.selector, 1000, 50000);
//        assertEq(result, "MockSymbol");
//    }

    // Invariants for readString Functions
    function testReadStringEmptyStringOnRevert() public {
        string memory result = address(target).readString(abi.encodeWithSignature("name()"));
        assertEq(result, "MockName");

        result = address(target).readString(abi.encodeWithSignature("revertName()"));
        assertEq(result, "");
    }

    function testReadStringEmptyStringOnNoReturnData() public {
        string memory result = address(target).readString(abi.encodeWithSignature("emptyName()"));
        assertEq(result, "");
    }

    function testReadStringCorrectStringTruncation() public {
        string memory result = address(target).readString(abi.encodeWithSignature("longName()"), 10);
        assertEq(result, "ThisIsAVer");
    }

    function testReadStringCorrectStringWithNullByte() public {
        string memory result = address(target).readString(abi.encodeWithSignature("nullByteName()"));
        assertEq(result, "NullByte");
    }

    function testReadStringCorrectGasStipendHandling() public {
        string memory result = address(target).readString(abi.encodeWithSignature("name()"), 1000, 50000);
        assertEq(result, "MockName");
    }

    // Invariants for readDecimals Functions
//    function testReadDecimalsZeroOnRevert() public {
//        uint8 result = address(target).readDecimals();
//        assertEq(result, 18);
//
//        result = address(target).readDecimals(address(new MockContract()).revertName.selector);
//        assertEq(result, 0);
//    }

//    function testReadDecimalsZeroOnNoReturnData() public {
//        uint8 result = address(target).readDecimals(address(new MockContract()).emptyName.selector);
//        assertEq(result, 0);
//    }

//    function testReadDecimalsCorrectGasStipendHandling() public {
//        uint8 result = address(target).readDecimals(address(new MockContract()).decimal.selector, 50000);
//        assertEq(result, 18);
//    }

    // Invariants for readUint Functions
    function testReadUintZeroOnRevert() public {
        uint256 result = address(target).readUint(abi.encodeWithSignature("decimal()"));
        assertEq(result, 18);

        result = address(target).readUint(abi.encodeWithSignature("revertName()"));
        assertEq(result, 0);
    }

    function testReadUintZeroOnNoReturnData() public {
        uint256 result = address(target).readUint(abi.encodeWithSignature("emptyName()"));
        assertEq(result, 0);
    }

    function testReadUintCorrectGasStipendHandling() public {
        uint256 result = address(target).readUint(abi.encodeWithSignature("decimal()"), 50000);
        assertEq(result, 18);
    }

    // General Invariants
//    function testMemorySafety() public {
//        // This test ensures that the functions do not cause memory corruption or access out-of-bounds memory.
//        // We will call the functions with large data sizes and invalid memory access to check for memory safety.
//        string memory result = address(target).readName(address(new MockContract()).longName.selector, 1000000);
//        assertEq(result, "ThisIsAVeryLongNameThatExceedsTheLimit");
//
//        result = address(target).readSymbol(address(new MockContract()).longName.selector, 1000000);
//        assertEq(result, "ThisIsAVeryLongNameThatExceedsTheLimit");
//
//        result = address(target).readString(abi.encodeWithSignature("longName()"), 1000000);
//        assertEq(result, "ThisIsAVeryLongNameThatExceedsTheLimit");
//    }

//    function testGasEfficiency() public {
//        // This test ensures that the functions are gas-efficient and do not consume excessive gas for typical use cases.
//        // We will call the functions with large data sizes and complex calldata to check for gas efficiency.
//        uint256 gasStart = gasleft();
//        string memory result = address(target).readName(address(new MockContract()).longName.selector, 1000000);
//        uint256 gasUsed = gasStart - gasleft();
//        console2.log("Gas used for readName with large data size:", gasUsed);
//
//        gasStart = gasleft();
//        result = address(target).readSymbol(address(new MockContract()).longName.selector, 1000000);
//        gasUsed = gasStart - gasleft();
//        console2.log("Gas used for readSymbol with large data size:", gasUsed);
//
//        gasStart = gasleft();
//        result = address(target).readString(abi.encodeWithSignature("longName()"), 1000000);
//        gasUsed = gasStart - gasleft();
//        console2.log("Gas used for readString with large data size:", gasUsed);
//    }
}