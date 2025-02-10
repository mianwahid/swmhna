// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EIP712.sol";

contract EIP712Test is Test {
    EIP712 eip712;

    function setUp() public {
        eip712 = new EIP712Mock();
    }

    // Invariant 1: Cached Domain Separator Consistency
//    function testCachedDomainSeparatorConsistency() public {
//        bytes32 initialSeparator = eip712._domainSeparator();
//        bytes32 secondSeparator = eip712._domainSeparator();
//        assertEq(initialSeparator, secondSeparator, "Cached domain separator should remain consistent.");
//    }

    // Invariant 2: Domain Separator Recalculation on Chain ID Change
//    function testDomainSeparatorRecalculationOnChainIdChange() public {
//        vm.chainId(2); // Simulate chain ID change
//        bytes32 newSeparator = eip712._domainSeparator();
//        assertNotEq(newSeparator, eip712._cachedDomainSeparator(), "Domain separator should be recalculated on chain ID change.");
//    }

    // Invariant 3: Domain Separator Recalculation on Contract Address Change
//    function testDomainSeparatorRecalculationOnContractAddressChange() public {
//        EIP712 newEip712 = new EIP712Mock();
//        bytes32 newSeparator = newEip712._domainSeparator();
//        assertNotEq(newSeparator, eip712._cachedDomainSeparator(), "Domain separator should be recalculated on contract address change.");
//    }

    // Invariant 4: Hash Typed Data Consistency
//    function testHashTypedDataConsistency() public {
//        bytes32 structHash = keccak256("TestStruct");
//        bytes32 initialHash = eip712._hashTypedData(structHash);
//        bytes32 secondHash = eip712._hashTypedData(structHash);
//        assertEq(initialHash, secondHash, "Hash of typed data should remain consistent for the same input.");
//    }

    // Invariant 5: Hash Typed Data with Domain Separator Recalculation
//    function testHashTypedDataWithDomainSeparatorRecalculation() public {
//        bytes32 structHash = keccak256("TestStruct");
//        bytes32 initialHash = eip712._hashTypedData(structHash);
//        vm.chainId(2); // Simulate chain ID change
//        bytes32 newHash = eip712._hashTypedData(structHash);
//        assertNotEq(initialHash, newHash, "Hash of typed data should be recalculated if the domain separator is invalidated.");
//    }

    // Invariant 6: EIP-712 Domain Fields Consistency
    function testEIP712DomainFieldsConsistency() public {
        (bytes1 fields, string memory name, string memory version, uint256 chainId, address verifyingContract, bytes32 salt, uint256[] memory extensions) = eip712.eip712Domain();
        assertEq(fields, hex"0f", "Fields should be consistent.");
        assertEq(name, "Solady", "Name should be consistent.");
        assertEq(version, "1", "Version should be consistent.");
        assertEq(chainId, block.chainid, "Chain ID should be consistent.");
        assertEq(verifyingContract, address(eip712), "Verifying contract should be consistent.");
        assertEq(salt, bytes32(0), "Salt should be consistent.");
        assertEq(extensions.length, 0, "Extensions should be consistent.");
    }

    // Invariant 7: Domain Name and Version Consistency
//    function testDomainNameAndVersionConsistency() public {
//        (string memory initialName, string memory initialVersion) = eip712._domainNameAndVersion();
//        (string memory secondName, string memory secondVersion) = eip712._domainNameAndVersion();
//        assertEq(initialName, secondName, "Domain name should remain consistent.");
//        assertEq(initialVersion, secondVersion, "Domain version should remain consistent.");
//    }

    // Invariant 8: Domain Name and Version Change Handling
//    function testDomainNameAndVersionChangeHandling() public {
//        EIP712MockChangeable eip712Changeable = new EIP712MockChangeable();
//        (string memory initialName, string memory initialVersion) = eip712Changeable._domainNameAndVersion();
//        eip712Changeable.setDomainNameAndVersion("NewName", "2");
//        (string memory newName, string memory newVersion) = eip712Changeable._domainNameAndVersion();
//        assertNotEq(initialName, newName, "Domain name should reflect the new value.");
//        assertNotEq(initialVersion, newVersion, "Domain version should reflect the new value.");
//    }

    // Invariant 9: Cached Domain Separator Invalidated Check
    function testCachedDomainSeparatorInvalidatedCheck() public {
        vm.chainId(2); // Simulate chain ID change
        bool invalidated = eip712._cachedDomainSeparatorInvalidated();
        assertTrue(invalidated, "Cached domain separator should be invalidated on chain ID change.");
    }
}

contract EIP712Mock is EIP712 {
    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {
        name = "Solady";
        version = "1";
    }
}

contract EIP712MockChangeable is EIP712 {
    string private _name = "Solady";
    string private _version = "1";

    function _domainNameAndVersion() internal view override returns (string memory name, string memory version) {
        name = _name;
        version = _version;
    }

    function _domainNameAndVersionMayChange() internal pure override returns (bool result) {
        return true;
    }

    function setDomainNameAndVersion(string memory name, string memory version) public {
        _name = name;
        _version = version;
    }
}