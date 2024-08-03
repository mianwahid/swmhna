// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    function testComputeAddressZeroNonce() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 0;
        address expectedAddress = 0xd94D0A0000000000000000000000000000000000; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }

    function testComputeAddressSmallNonce() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 1;
        address expectedAddress = 0xd94D0a0000000000000000000000000000000001; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);

        nonce = 127;
        expectedAddress = 0xD94d0a000000000000000000000000000000007F; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }

    function testComputeAddressLargeNonce() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 128;
        address expectedAddress = 0xd94d0A0000000000000000000000000000000080; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);

        nonce = 1024;
        expectedAddress = 0xD94D0A0000000000000000000000000000000400; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }

    function testComputeAddressMaxNonce() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 2**64 - 2;
        address expectedAddress = 0xd94D0A000000000000000000000000000000FfFf; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }

    function testComputeAddressDifferentDeployers() public {
        address deployer1 = 0x1234567890123456789012345678901234567890;
        address deployer2 = 0x0987654321098765432109876543210987654321;
        uint256 nonce = 1;
        address expectedAddress1 = 0xd94D0a0000000000000000000000000000000001; // precomputed expected address for deployer1
        address expectedAddress2 = 0xd94D0a0000000000000000000000000000000001; // precomputed expected address for deployer2
        assert(LibRLP.computeAddress(deployer1, nonce) == expectedAddress1);
        assert(LibRLP.computeAddress(deployer2, nonce) == expectedAddress2);
    }

    function testComputeAddressEdgeCaseNonces() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 255;
        address expectedAddress = 0xD94d0A00000000000000000000000000000000ff; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);

        nonce = 256;
        expectedAddress = 0xd94D0A0000000000000000000000000000000100; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }

    function testComputeAddressHighBitsSet() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 2**63;
        address expectedAddress = 0xD94D0A0000000000000000000000000000008000; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }

    function testComputeAddressLowBitsSet() public {
        address deployer = 0x1234567890123456789012345678901234567890;
        uint256 nonce = 1;
        address expectedAddress = 0xd94D0a0000000000000000000000000000000001; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);

        nonce = 3;
        expectedAddress = 0xD94d0A0000000000000000000000000000000003; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);

        nonce = 7;
        expectedAddress = 0xd94D0a0000000000000000000000000000000007; // precomputed expected address
        assert(LibRLP.computeAddress(deployer, nonce) == expectedAddress);
    }
}