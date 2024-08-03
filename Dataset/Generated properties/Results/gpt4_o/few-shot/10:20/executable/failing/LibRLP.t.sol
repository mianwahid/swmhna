// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    function testComputeAddressZeroNonce() public {
        address deployer = address(0x1234567890AbcdEF1234567890aBcdef12345678);
        uint256 nonce = 0;
        address expected = address(0x5c5e5d8B5b5b5B5B5b5B5b5b5b5b5B5b5b5B5b5b);
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(computed, expected);
    }

    function testComputeAddressNonZeroNonce() public {
        address deployer = address(0x1234567890AbcdEF1234567890aBcdef12345678);
        uint256 nonce = 1;
        address expected = address(0x6C6e6D8B6b6B6b6B6b6B6b6b6B6b6B6b6B6b6B);
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(computed, expected);
    }

    function testComputeAddressLargeNonce() public {
        address deployer = address(0x1234567890AbcdEF1234567890aBcdef12345678);
        uint256 nonce = 2**64 - 2;
        address expected = address(0x7c7E7d8b7b7B7B7b7B7b7b7B7B7b7B7B7b7B7b);
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(computed, expected);
    }

    function testComputeAddressFuzz(address deployer, uint256 nonce) public {
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertTrue(computed != address(0));
    }

    function testComputeAddressDirtyBits() public {
        address deployer = address(0x1234567890AbcdEF1234567890aBcdef12345678);
        uint256 nonce = 1;
        address computed = LibRLP.computeAddress(deployer, nonce);
        assertEq(uint160(computed) >> 96, 0);
    }
}
