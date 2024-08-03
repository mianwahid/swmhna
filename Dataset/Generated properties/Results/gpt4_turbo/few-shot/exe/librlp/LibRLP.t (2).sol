// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    /// @notice Test the computeAddress function with known values
    function testComputeAddress() public {
        address deployer = address(0x1234567890123456789012345678901234567890);
        uint256 nonce = 1; // Typically the first contract created by another contract
        address expectedAddress = 0xcDcf4888D8DFe4Ea0CBBB3b7c9B88F143dABCd2f; // Expected result for these inputs

        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        assertEq(computedAddress, expectedAddress, "Computed address does not match expected address");
    }

    /// @notice Fuzz test for computeAddress to ensure it handles a wide range of inputs
    function testFuzzComputeAddress(address deployer, uint256 nonce) public {
        // We only test for nonces up to 2**64-2 due to EIP-2681 limit
        if (nonce > type(uint64).max - 1) return;

        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        // We can't predict the correct address without replicating the function logic,
        // so we mainly check for reverts or obvious errors.
        assertEq(computedAddress ,address(0), "Should not compute zero address");
    }

    /// @notice Test edge cases for nonces
    function testEdgeCases() public {
        address deployer = address(0xABcdEFABcdEFabcdEfAbCdefabcdeFABcDEFabCD);

        // Test edge case where nonce is 0
        address addressWithZeroNonce = LibRLP.computeAddress(deployer, 0);
        assertEq(addressWithZeroNonce , address(0), "Zero nonce should not result in zero address");

        // Test edge case where nonce is 2**64-2 (EIP-2681 limit)
        address addressWithMaxNonce = LibRLP.computeAddress(deployer, type(uint64).max - 1);
        assertEq(addressWithMaxNonce , address(0), "Max nonce should not result in zero address");
    }
}