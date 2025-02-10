// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";
contract LibRLPTest is Test {

    function testComputeAddress() public {
        address deployer = address(0x1234567890123456789012345678901234567890);
        uint256 nonce = 1;
        address expectedAddress = address(0x72aB56651C7A3f1e77c37033f3A3B4e5FB15A12A);
        assertEq(LibRLP.computeAddress(deployer, nonce), expectedAddress);
    }

    function testComputeAddressZeroNonce() public {
        address deployer = address(0x1234567890123456789012345678901234567890);
        uint256 nonce = 0;
        address expectedAddress = address(0x4466142A019A7aDBd590e42983001313C2780a71);
        assertEq(LibRLP.computeAddress(deployer, nonce), expectedAddress);
    }

    function testComputeAddressMaxNonce() public {
        address deployer = address(0x1234567890123456789012345678901234567890);
        uint256 nonce = 2**64 - 2;
        address expectedAddress = address(0x9e26Ce9D1eD49968cA0ea96ea7e70c1206526e92);
        assertEq(LibRLP.computeAddress(deployer, nonce), expectedAddress);
    }

    function testComputeAddressLargeNonce() public {
        address deployer = address(0x1234567890123456789012345678901234567890);
        uint256 nonce = 2**128 - 1;
        address expectedAddress = address(0x689206834720907E779DC028aF682C702e7E8244);
        assertEq(LibRLP.computeAddress(deployer, nonce), expectedAddress);
    }

    function testFuzzComputeAddress(address deployer, uint256 nonce) public {
        LibRLP.computeAddress(deployer, nonce);
    }
}
