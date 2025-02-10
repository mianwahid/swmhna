// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EIP712.sol";

contract TestEIP712 is EIP712 {
    constructor() EIP712() {}

    function _domainNameAndVersion()
        internal
        pure
        override
        returns (string memory name, string memory version)
    {
        name = "Solady";
        version = "1";
    }

    function testHashTypedData(bytes32 structHash) public view returns (bytes32) {
        return _hashTypedData(structHash);
    }
}

contract EIP712Test is Test {
    TestEIP712 public eip712;

    bytes32 internal constant _MAIL_TYPEHASH =
        keccak256("Mail(address to,string contents)");

    function setUp() public {
        eip712 = new TestEIP712();
    }

    function testEIP712Domain() public {
        (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        ) = eip712.eip712Domain();

        assertEq(fields, hex"0f");
        assertEq(name, "Solady");
        assertEq(version, "1");
        assertEq(chainId, block.chainid);
        assertEq(verifyingContract, address(eip712));
        assertEq(salt, bytes32(0));
        assertEq(extensions.length, 0);
    }

    function testHashTypedData() public {
        address mailTo = address(0x1234);
        string memory mailContents = "Hello, world!";

        bytes32 structHash = keccak256(
            abi.encode(_MAIL_TYPEHASH, mailTo, keccak256(bytes(mailContents)))
        );
        bytes32 digest = eip712.testHashTypedData(structHash);

        console2.logBytes32(digest);
    }
}