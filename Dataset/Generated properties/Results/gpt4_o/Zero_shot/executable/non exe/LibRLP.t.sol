// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    function testComputeAddressWithZeroNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 0;
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with zero nonce failed");
    }

    function testComputeAddressWithSmallNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 1;
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with small nonce failed");
    }

    function testComputeAddressWithLargeNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 2**64 - 2;
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with large nonce failed");
    }

    function testComputeAddressWithMaxUint256Nonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = type(uint256).max;
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with max uint256 nonce failed");
    }

    function testComputeAddressWithRandomNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with random nonce failed");
    }

    function testComputeAddressWithZeroAddress() public {
        address deployer = address(0);
        uint256 nonce = 1;
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with zero address failed");
    }

    function testComputeAddressWithMaxAddress() public {
        address deployer = address(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        uint256 nonce = 1;
        address expected = address(0x5b38da6a701c568545dcfcb03fcb875f56beddc4); // Replace with the actual expected address
        address result = LibRLP.computeAddress(deployer, nonce);
        assertEq(result, expected, "Address computation with max address failed");
    }

    function testFuzzComputeAddress(address deployer, uint256 nonce) public {
        address result = LibRLP.computeAddress(deployer, nonce);
        // Perform some basic checks
        assert(result != address(0), "Computed address should not be zero");
        assert(result != deployer, "Computed address should not be the same as deployer");
    }
}