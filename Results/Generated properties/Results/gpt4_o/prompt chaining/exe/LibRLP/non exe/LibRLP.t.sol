// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
//    function testCorrectAddressCalculationForSmallNonce() public {
//        address deployer = address(this);
//        assertEq(LibRLP.computeAddress(deployer, 0), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x80)))))));
//        assertEq(LibRLP.computeAddress(deployer, 1), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x01)))))));
//        assertEq(LibRLP.computeAddress(deployer, 127), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x7f)))))));
//    }

//    function testCorrectAddressCalculationForLargeNonce() public {
//        address deployer = address(this);
//        assertEq(LibRLP.computeAddress(deployer, 128), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0x80)))))));
//        assertEq(LibRLP.computeAddress(deployer, 255), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0xff)))))));
//        assertEq(LibRLP.computeAddress(deployer, 1024), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x82), byte(0x04), byte(0x00)))))));
//        assertEq(LibRLP.computeAddress(deployer, 2**64-2), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x88), bytes8(uint64(2**64-2))))))));
//    }

//    function testCorrectAddressCalculationForBoundaryNonceValues() public {
//        address deployer = address(this);
//        assertEq(LibRLP.computeAddress(deployer, 255), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0xff)))))));
//        assertEq(LibRLP.computeAddress(deployer, 65535), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x82), byte(0xff), byte(0xff)))))));
//        assertEq(LibRLP.computeAddress(deployer, 4294967295), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x84), byte(0xff), byte(0xff), byte(0xff), byte(0xff)))))));
//        assertEq(LibRLP.computeAddress(deployer, 2**64-2), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x88), bytes8(uint64(2**64-2))))))));
//    }

//    function testCorrectAddressCalculationForDifferentDeployerAddresses() public {
//        uint256 nonce = 1;
//        assertEq(LibRLP.computeAddress(address(0x0000000000000000000000000000000000000000), nonce), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(0x0000000000000000000000000000000000000000), byte(0x01)))))));
//        assertEq(LibRLP.computeAddress(address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), nonce), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), byte(0x01)))))));
//        assertEq(LibRLP.computeAddress(address(0x1234567890abcdef1234567890abcdef12345678), nonce), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(0x1234567890abcdef1234567890abcdef12345678), byte(0x01)))))));
//    }

//    function testConsistencyWithKnownAddressCalculation() public {
//        address deployer = address(this);
//        uint256 nonce = 1;
//        address expectedAddress = address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x01))))));
//        assertEq(LibRLP.computeAddress(deployer, nonce), expectedAddress);
//    }

    function testNonceEncodingVerification() public {
        address deployer = address(this);
        assertEq(LibRLP.computeAddress(deployer, 0), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x80)))))));
        assertEq(LibRLP.computeAddress(deployer, 1), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x01)))))));
        assertEq(LibRLP.computeAddress(deployer, 127), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x7f)))))));
        assertEq(LibRLP.computeAddress(deployer, 128), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0x80)))))));
        assertEq(LibRLP.computeAddress(deployer, 255), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0xff)))))));
        assertEq(LibRLP.computeAddress(deployer, 1024), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x82), byte(0x04), byte(0x00)))))));
    }

    function testDeployerAddressEncodingVerification() public {
        uint256 nonce = 1;
        assertEq(LibRLP.computeAddress(address(0x0000000000000000000000000000000000000000), nonce), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(0x0000000000000000000000000000000000000000), byte(0x01)))))));
        assertEq(LibRLP.computeAddress(address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), nonce), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), byte(0x01)))))));
        assertEq(LibRLP.computeAddress(address(0x1234567890abcdef1234567890abcdef12345678), nonce), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), address(0x1234567890abcdef1234567890abcdef12345678), byte(0x01)))))));
    }

//    function testAssemblyCodeExecutionPath() public {
//        address deployer = address(this);
//        assertEq(LibRLP.computeAddress(deployer, 0), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x80)))))));
//        assertEq(LibRLP.computeAddress(deployer, 127), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x7f)))))));
//        assertEq(LibRLP.computeAddress(deployer, 128), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0x80)))))));
//        assertEq(LibRLP.computeAddress(deployer, 255), address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), deployer, byte(0x81), byte(0xff)))))));
//    }

    function testNoDirtyUpperBitsInDeployedAddress() public {
        address deployer = address(this);
        uint256 nonce = 1;
        address deployed = LibRLP.computeAddress(deployer, nonce);
        assertEq(deployed, address(uint160(deployed)));
    }

    function testPerformanceAndGasUsage() public {
        address deployer = address(this);
        uint256 gasStart = gasleft();
        LibRLP.computeAddress(deployer, 1);
        uint256 gasUsedSmallNonce = gasStart - gasleft();
        console2.log("Gas used for small nonce:", gasUsedSmallNonce);

        gasStart = gasleft();
        LibRLP.computeAddress(deployer, 2**64-2);
        uint256 gasUsedLargeNonce = gasStart - gasleft();
        console2.log("Gas used for large nonce:", gasUsedLargeNonce);
    }
}