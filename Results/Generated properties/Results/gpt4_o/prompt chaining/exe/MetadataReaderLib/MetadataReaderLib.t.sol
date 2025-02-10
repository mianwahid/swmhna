// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/MetadataReaderLib.sol";

contract MetadataReaderLibTest is Test {
    using MetadataReaderLib for address;

    address target;

    function setUp() public {
        target = address(new MockContract());
    }


    // Invariants for readName Functions
    function testReadNameEmptyStringOnRevert() public {
        target = address(0); // EOA or non-contract address
        string memory result = target.readName();
        assertEq(result, "");
    }

    function testReadNameEmptyStringOnNoReturnData() public {
        target = address(new MockNoReturnData());
        string memory result = target.readName();
        assertEq(result, "");
    }

    function testReadNameCorrectStringTruncation() public {
        string memory result = target.readName(4);
        assertEq(result, "Mock");
    }

    function testReadNameCorrectStringWithDefaultLimit() public {
        string memory result = target.readName();
        assertEq(result, "MockName");
    }

    function testReadNameCorrectStringWithCustomLimit() public {
        string memory result = target.readName(8);
        assertEq(result, "MockName");
    }

    function testReadNameCorrectStringWithCustomGasStipend() public {
        string memory result = target.readName(1000, 200000);
        assertEq(result, "MockName");
    }

    // Invariants for readSymbol Functions
    function testReadSymbolEmptyStringOnRevert() public {
        target = address(0); // EOA or non-contract address
        string memory result = target.readSymbol();
        assertEq(result, "");
    }

    function testReadSymbolEmptyStringOnNoReturnData() public {
        target = address(new MockNoReturnData());
        string memory result = target.readSymbol();
        assertEq(result, "");
    }

    function testReadSymbolCorrectStringTruncation() public {
        string memory result = target.readSymbol(4);
        assertEq(result, "Mock");
    }

    function testReadSymbolCorrectStringWithDefaultLimit() public {
        string memory result = target.readSymbol();
        assertEq(result, "MockSymbol");
    }

    function testReadSymbolCorrectStringWithCustomLimit() public {
        string memory result = target.readSymbol(10);
        assertEq(result, "MockSymbol");
    }

    function testReadSymbolCorrectStringWithCustomGasStipend() public {
        string memory result = target.readSymbol(1000, 200000);
        assertEq(result, "MockSymbol");
    }

    // Invariants for readString Functions
    function testReadStringEmptyStringOnRevert() public {
        target = address(0); // EOA or non-contract address
        string memory result = target.readString(abi.encodeWithSignature("name()"));
        assertEq(result, "");
    }

    function testReadStringEmptyStringOnNoReturnData() public {
        target = address(new MockNoReturnData());
        string memory result = target.readString(abi.encodeWithSignature("name()"));
        assertEq(result, "");
    }

    function testReadStringCorrectStringTruncation() public {
        string memory result = target.readString(abi.encodeWithSignature("name()"), 4);
        assertEq(result, "Mock");
    }

    function testReadStringCorrectStringWithDefaultLimit() public {
        string memory result = target.readString(abi.encodeWithSignature("name()"));
        assertEq(result, "MockName");
    }

    function testReadStringCorrectStringWithCustomLimit() public {
        string memory result = target.readString(abi.encodeWithSignature("name()"), 8);
        assertEq(result, "MockName");
    }

    function testReadStringCorrectStringWithCustomGasStipend() public {
        string memory result = target.readString(abi.encodeWithSignature("name()"), 1000, 200000);
        assertEq(result, "MockName");
    }

    // Invariants for readDecimals Functions
    function testReadDecimalsZeroOnRevert() public {
        target = address(0); // EOA or non-contract address
        uint8 result = target.readDecimals();
        assertEq(result, 0);
    }

    function testReadDecimalsZeroOnNoReturnData() public {
        target = address(new MockNoReturnData());
        uint8 result = target.readDecimals();
        assertEq(result, 0);
    }

    function testReadDecimalsCorrectDecimalsWithDefaultGasStipend() public {
        uint8 result = target.readDecimals();
        assertEq(result, 18);
    }

    function testReadDecimalsCorrectDecimalsWithCustomGasStipend() public {
        uint8 result = target.readDecimals(200000);
        assertEq(result, 18);
    }

    // Invariants for readUint Functions
    function testReadUintZeroOnRevert() public {
        target = address(0); // EOA or non-contract address
        uint256 result = target.readUint(abi.encodeWithSignature("decimal()"));
        assertEq(result, 0);
    }

    function testReadUintZeroOnNoReturnData() public {
        target = address(new MockNoReturnData());
        uint256 result = target.readUint(abi.encodeWithSignature("decimal()"));
        assertEq(result, 0);
    }

    function testReadUintCorrectUintWithDefaultGasStipend() public {
        uint256 result = target.readUint(abi.encodeWithSignature("decimal()"));
        assertEq(result, 18);
    }

    function testReadUintCorrectUintWithCustomGasStipend() public {
        uint256 result = target.readUint(abi.encodeWithSignature("decimal()"), 200000);
        assertEq(result, 18);
    }


}

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
    }

  // Mock contract to simulate no return data
    contract MockNoReturnData {
        function name() external pure {}
        function symbol() external pure {}
        function decimal() external pure {}
    }