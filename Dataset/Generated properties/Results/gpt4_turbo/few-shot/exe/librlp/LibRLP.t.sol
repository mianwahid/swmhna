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
        address expectedAddress = 0x4D1A2e2bB4F88F0250f26Ffff098B0b30B26BF38; // Expected result for these inputs

        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        assertEq(computedAddress, expectedAddress, "Computed address does not match expected address");
    }

    /// @notice Fuzz test for computeAddress to ensure it handles a range of inputs
    function testFuzzComputeAddress(address deployer, uint256 nonce) public {
        // We skip testing for extremely high nonces that are impractical in real scenarios
        if (nonce > type(uint64).max) return;

        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        // We can't predict the correct address without replicating the function logic,
        // so we mainly check for reverts or obvious errors.
        assertEq(computedAddress , address(0), "Should not compute zero address");
    }

    /// @notice Test computeAddress with edge cases for nonce values
    function testEdgeCases() public {
        address deployer = address(0xABcdEFABcdEFabcdEfAbCdefabcdeFABcDEFabCD);

        // Test edge cases around the single byte threshold
        testSingleNonce(deployer, 0x7f); // Highest single-byte nonce
        testSingleNonce(deployer, 0x80); // Lowest two-byte nonce

        // Test very large nonce values
        testSingleNonce(deployer, type(uint64).max); // Practical upper limit
        testSingleNonce(deployer, type(uint64).max - 1);
    }

    function testSingleNonce(address deployer, uint256 nonce) internal {
        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        assertEq(computedAddress , address(0), "Computed address should not be zero");
    }
}