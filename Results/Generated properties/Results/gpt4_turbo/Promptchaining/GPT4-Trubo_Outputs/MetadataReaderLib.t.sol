// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/MetadataReaderLib.sol";

contract MetadataReaderLibTest is Test {
    address constant NON_CONTRACT_ADDRESS = address(0x1);
    address mockContract;

    function setUp() public {
        mockContract = address(new MockContract());
    }

    function testReadNameNonReverting() public {
        string memory name = MetadataReaderLib.readName(NON_CONTRACT_ADDRESS);
        assertEq(name, "");
    }

    function testReadNameEmptyReturnData() public {
        string memory name = MetadataReaderLib.readName(mockContract);
        assertEq(name, "");
    }

    function testReadNameDataTruncation(uint256 limit) public {
        vm.assume(limit < 1000);
        string memory name = MetadataReaderLib.readName(mockContract, limit);
        assertTrue(bytes(name).length <= limit);
    }

    function testReadNameCorrectDecoding() public {
        MockContract(mockContract).setReturnData("ValidName");
        string memory name = MetadataReaderLib.readName(mockContract);
        assertEq(name, "ValidName");
    }

    // function testReadNameNullTerminatedString() public {
    //     MockContract(mockContract).setReturnData("Valid\0Invalid");
    //     string memory name = MetadataReaderLib.readName(mockContract);
    //     assertEq(name, "Valid");
    // }

    function testReadNameMaximumGasStipend() public {
        uint256 gasUsed = gasleft();
        MetadataReaderLib.readName(mockContract);
        gasUsed -= gasleft();
        assertTrue(gasUsed <= MetadataReaderLib.GAS_STIPEND_NO_GRIEF);
    }

    function testReadNameCustomGasStipend(uint256 gasStipend) public {
        vm.assume(gasStipend > 0 && gasStipend < 1000000);
        string memory name = MetadataReaderLib.readName(
            mockContract,
            1000,
            gasStipend
        );
        assertEq(name, "");
    }

    function testReadDecimalsNonReverting() public {
        uint8 decimals = MetadataReaderLib.readDecimals(NON_CONTRACT_ADDRESS);
        assertEq(decimals, 0);
    }

    function testReadDecimalsZeroReturn() public {
        uint8 decimals = MetadataReaderLib.readDecimals(mockContract);
        assertEq(decimals, 0);
    }

    function testReadDecimalsCorrectDecoding() public {
        MockContract(mockContract).setReturnUint(18);
        uint8 decimals = MetadataReaderLib.readDecimals(mockContract);
        assertEq(decimals, 18);
    }

    function testReadDecimalsMaximumGasStipend() public {
        uint256 gasUsed = gasleft();
        MetadataReaderLib.readDecimals(mockContract);
        gasUsed -= gasleft();
        assertTrue(gasUsed <= MetadataReaderLib.GAS_STIPEND_NO_GRIEF);
    }

    function testReadDecimalsCustomGasStipend(uint256 gasStipend) public {
        vm.assume(gasStipend > 0 && gasStipend < 1000000);
        uint8 decimals = MetadataReaderLib.readDecimals(
            mockContract,
            gasStipend
        );
        assertEq(decimals, 0);
    }

    function testMemorySafety() public {
        // This test should be designed to check for overflows, underflows or any other memory-related issues.
        // Specific implementation would depend on the internal workings and vulnerabilities considered.
    }

    function testGasUsage() public {
        uint256 gasUsed = gasleft();
        MetadataReaderLib.readName(mockContract);
        gasUsed -= gasleft();
        console2.log("Gas used for readName:", gasUsed);
    }
}

contract MockContract {
    string public name;
    uint256 public decimals;

    function setReturnData(string memory _name) public {
        name = _name;
    }

    function setReturnUint(uint256 _decimals) public {
        decimals = _decimals;
    }
}
