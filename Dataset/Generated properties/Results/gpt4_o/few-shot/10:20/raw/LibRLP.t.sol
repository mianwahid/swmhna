// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    function testComputeAddressZeroNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 0;
        address expected = address(0x5c5e5d8b5b5b5b5b5b5b5b5b5b5b5b5b5b5b5b5b);
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(computed, expected);
    }

    function testComputeAddressNonZeroNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 1;
        address expected = address(0x6c6e6d8b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b6b);
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(computed, expected);
    }

    function testComputeAddressLargeNonce() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 2**64 - 2;
        address expected = address(0x7c7e7d8b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b);
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(computed, expected);
    }

    function testComputeAddressFuzz(address deployer, uint256 nonce) public {
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertTrue(computed != address(0));
    }

    function testComputeAddressDirtyBits() public {
        address deployer = address(0x1234567890abcdef1234567890abcdef12345678);
        uint256 nonce = 1;
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(uint160(computed) >> 96, 0);
    }
}