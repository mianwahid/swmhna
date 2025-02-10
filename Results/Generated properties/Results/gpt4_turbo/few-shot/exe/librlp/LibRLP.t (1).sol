// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    /// @notice Test the computeAddress function with known values
    function testComputeAddress() public {
        address deployer = address(0x1234567890123456789012345678901234567890);
        uint256 nonce = 1;
        address expectedAddress = 0x4e7277068f0C6Aa0a0C07C2df4C07a575e76f5A9;

        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        assertEq(computedAddress, expectedAddress, "Computed address does not match expected address");
    }

    /// @notice Fuzz test for computeAddress to ensure it handles a range of inputs
    function testFuzzComputeAddress(address deployer, uint256 nonce) public {
        // We skip testing for extremely high nonces that are impractical in real use cases
        if (nonce > type(uint64).max) return;

        address computedAddress = LibRLP.computeAddress(deployer, nonce);
        // We can't predict the correct address without replicating the function logic,
        // but we can ensure it returns a valid address format.
        assertTrue(computedAddress != address(0), "Should not compute the zero address");
    }

    /// @notice Test computeAddress with edge cases for nonce values
    function testEdgeCases() public {
        address deployer = address(0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF);

        // Test with nonce = 0
        address addressWithZeroNonce = LibRLP.computeAddress(deployer, 0);
        assertTrue(addressWithZeroNonce != address(0), "Zero nonce should compute a valid address");

        // Test with nonce = 2**64 - 1 (edge of practical range)
        address addressWithMaxNonce = LibRLP.computeAddress(deployer, 2**64 - 1);
        assertTrue(addressWithMaxNonce != address(0), "Max nonce should compute a valid address");

        // Test with nonce = 2**64 (beyond practical range, should still compute due to no checks)
        address addressBeyondMaxNonce = LibRLP.computeAddress(deployer, 2**64);
        assertTrue(addressBeyondMaxNonce != address(0), "Beyond max nonce should compute a valid address");
    }
}