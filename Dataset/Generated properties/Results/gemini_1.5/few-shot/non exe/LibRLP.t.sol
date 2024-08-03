// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibRLP.sol";

contract LibRLPTest is Test {
    function testComputeAddress(address deployer, uint256 nonce) public {
        address result = LibRLP.computeAddress(deployer, nonce);


        vm.assume(nonce < type(uint64).max);
        bytes memory rlpEncoded = abi.encodePacked(deployer, abi.encodePacked(uint64(nonce)));
        address expected = address(uint160(uint256(keccak256(rlpEncoded))));
        assertEq(result, expected);
    }

    function testComputeAddressZeroNonce(address deployer) public {
        address result = LibRLP.computeAddress(deployer, 0);

        bytes memory rlpEncoded = abi.encodePacked(deployer, bytes1(0x80));
        address expected = address(uint160(uint256(keccak256(rlpEncoded))));
        assertEq(result, expected);
    }

    function testComputeAddressBatch(address deployer, uint256 nonce) public {
        uint256 targetNonce = nonce;
        for (uint256 i = 0; i < 32; i++) {
            testComputeAddress(deployer, targetNonce);
            targetNonce++;
        }
    }

    function testComputeAddressConsistent(address deployer, uint256 nonce) public {
        vm.assume(nonce < type(uint64).max);
        address a = LibRLP.computeAddress(deployer, nonce);
        address b = LibRLP.computeAddress(deployer, nonce);
        assertEq(a, b);
    }
}
