// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EIP712.sol";
import {ECDSA} from "../src/utils/ECDSA.sol";

 contract MockEIP712 is EIP712 {
        function _domainNameAndVersion()
            internal
            pure
            override
            returns (string memory name, string memory version)
        {
            name = "MockEIP712";
            version = "1";
        }

        function hashTypedData(bytes32 structHash) external view returns (bytes32) {
            return _hashTypedData(structHash);
        }

        function domainSeparator() external view returns (bytes32) {
            return _domainSeparator();
        }
    }
contract EIP712Test is Test {
    // Mock implementation of EIP712 to test the abstract contract


    MockEIP712 mockEIP712;

    function setUp() public {
        mockEIP712 = new MockEIP712();
    }

    function testDomainSeparator() public {
        bytes32 expectedDomainSeparator = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes("MockEIP712")),
                keccak256(bytes("1")),
                block.chainid,
                address(mockEIP712)
            )
        );
        assertEq(mockEIP712.domainSeparator(), expectedDomainSeparator);
    }

//    function testHashTypedData() public {
//        bytes32 structHash = keccak256(abi.encode(
//            keccak256("Mail(address to,string contents)"),
//            address(this),
//            keccak256(bytes("Hello, EIP712!"))
//        ));
//        bytes32 expectedDigest = ECDSA.toEthSignedMessageHash(
//            keccak256(
//                abi.encodePacked(
//                    "\x19\x01",
//                    mockEIP712.domainSeparator(),
//                    structHash
//                )
//            )
//        );
//        assertEq(mockEIP712.hashTypedData(structHash), expectedDigest);
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
        ) = mockEIP712.eip712Domain();

        assertEq(fields, hex"0f");
        assertEq(name, "MockEIP712");
        assertEq(version, "1");
        assertEq(chainId, block.chainid);
        assertEq(verifyingContract, address(mockEIP712));
        assertEq(salt, bytes32(0));
        assertEq(extensions.length, 0);
    }

    function testCachedDomainSeparatorInvalidation() public {
        // Simulate a chain ID change
        vm.chainId(block.chainid + 1);
        bytes32 newDomainSeparator = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes("MockEIP712")),
                keccak256(bytes("1")),
                block.chainid,
                address(mockEIP712)
            )
        );
        assertEq(mockEIP712.domainSeparator(), newDomainSeparator);
    }
}