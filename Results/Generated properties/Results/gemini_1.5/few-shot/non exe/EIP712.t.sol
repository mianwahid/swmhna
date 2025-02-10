// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EIP712.sol";

contract EIP712Test is Test {
    TestEIP712 internal t;

    function setUp() public {
        t = new TestEIP712();
    }

//    function testDomainSeparator() public {
//        bytes32 expectedDomainSeparator = keccak256(
//            abi.encode(
//                0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
//                keccak256(bytes("Solady")),
//                keccak256(bytes("1")),
//                block.chainid,
//                address(t)
//            )
//        );
//        assertEq(t._domainSeparator(), expectedDomainSeparator);
//    }

//    function testHashTypedData() public {
//        bytes32 structHash = keccak256(abi.encode(keccak256("Test(uint256 foo)"), 1));
//        bytes32 expectedDigest = keccak256(
//            abi.encodePacked(
//                bytes1(0x19),
//                bytes1(0x01),
//                t._domainSeparator(),
//                structHash
//            )
//        );
//        assertEq(t._hashTypedData(structHash), expectedDigest);
//    }

    function testEIP712Domain() public {
        (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        ) = t.eip712Domain();

        assertEq(fields, hex"0f");
        assertEq(name, "Solady");
        assertEq(version, "1");
        assertEq(chainId, block.chainid);
        assertEq(verifyingContract, address(t));
        assertEq(salt, bytes32(0));
        assertEq(extensions.length, 0);
    }
}

contract TestEIP712 is EIP712 {
    function _domainNameAndVersion()
        internal
        pure
        override
        returns (string memory name, string memory version)
    {
        name = "Solady";
        version = "1";
    }

    function _domainSeparator() internal view override returns (bytes32 separator) {
        separator = super._domainSeparator();
    }

    function _hashTypedData(bytes32 structHash)
        internal
        view
        override
        returns (bytes32 digest)
    {
        digest = super._hashTypedData(structHash);
    }
}