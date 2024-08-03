// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";
contract LibRLPTest is Test {
    function testComputeAddressDeterminism() public {
        address deployer = address(0x1234);
        uint256 nonce = 1;
        address address1 = LibRLP.computeAddress(deployer, nonce);
        address address2 = LibRLP.computeAddress(deployer, nonce);
        assertEq(address1, address2, "Address should be deterministic");
    }
    function testComputeAddressNonceIncrement() public {
        address deployer = address(0x1234);
        uint256 nonce = 0;
        address address1 = LibRLP.computeAddress(deployer, nonce);
        nonce++;
        address address2 = LibRLP.computeAddress(deployer, nonce);
        assertNotEq(address1, address2, "Different nonces should result in different addresses");
    }
    function testComputeAddressDeployerVariation() public {
        uint256 nonce = 1;
        address deployer1 = address(0x1234);
        address deployer2 = address(0x5678);
        address address1 = LibRLP.computeAddress(deployer1, nonce);
        address address2 = LibRLP.computeAddress(deployer2, nonce);
        assertNotEq(address1, address2, "Different deployers should result in different addresses");
    }
    function testComputeAddressZeroNonce() public {
        address deployer = address(0x1234);
        uint256 nonce = 0;
        address address1 = LibRLP.computeAddress(deployer, nonce);
        // You might want to compare address1 with a reference implementation here
        console2.log("Address with zero nonce:", address1);
        assertTrue(address1 != address(0), "Address should not be zero");
    }
    function testComputeAddressLargeNonce() public {
        address deployer = address(0x1234);
        uint256 nonce = 2**32 - 1;
        address address1 = LibRLP.computeAddress(deployer, nonce);
        console2.log("Address with large nonce:", address1);
        assertTrue(address1 != address(0), "Address should not be zero");
    }
}
