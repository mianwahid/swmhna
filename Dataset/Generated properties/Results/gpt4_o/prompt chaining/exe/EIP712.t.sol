// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EIP712.sol";

contract EIP712Test is Test {
    EIP712TestContract eip712;

    function setUp() public {
        eip712 = new EIP712TestContract();
    }

    // Invariant 1: Cached Domain Separator Consistency
    function testCachedDomainSeparatorConsistency() public {
        bytes32 initialSeparator = eip712.domainSeparator();
        bytes32 secondSeparator = eip712.domainSeparator();
        assertEq(initialSeparator, secondSeparator, "Cached domain separator should remain consistent");
    }

    // Invariant 2: Domain Separator Recalculation on Chain ID Change
    function testDomainSeparatorRecalculationOnChainIdChange() public {
        bytes32 initialSeparator = eip712.domainSeparator();
        vm.chainId(2); // Simulate chain ID change
        bytes32 newSeparator = eip712.domainSeparator();
        assertTrue(initialSeparator != newSeparator, "Domain separator should be recalculated on chain ID change");
    }

    // Invariant 3: Domain Separator Recalculation on Contract Address Change
    function testDomainSeparatorRecalculationOnContractAddressChange() public {
        bytes32 initialSeparator = eip712.domainSeparator();
        EIP712TestContract newEip712 = new EIP712TestContract(); // Simulate contract address change
        bytes32 newSeparator = newEip712.domainSeparator();
        assertTrue(initialSeparator != newSeparator, "Domain separator should be recalculated on contract address change");
    }

    // Invariant 4: Typed Data Hash Consistency
    function testTypedDataHashConsistency() public {
        bytes32 structHash = keccak256("TestStruct");
        bytes32 initialHash = eip712.hashTypedData(structHash);
        bytes32 secondHash = eip712.hashTypedData(structHash);
        assertEq(initialHash, secondHash, "Typed data hash should remain consistent for the same input");
    }

    // Invariant 5: Typed Data Hash Recalculation on Domain Separator Change
    function testTypedDataHashRecalculationOnDomainSeparatorChange() public {
        bytes32 structHash = keccak256("TestStruct");
        bytes32 initialHash = eip712.hashTypedData(structHash);
        vm.chainId(2); // Simulate domain separator change
        bytes32 newHash = eip712.hashTypedData(structHash);
        assertTrue(initialHash != newHash, "Typed data hash should change if the domain separator changes");
    }

    // Invariant 6: EIP-712 Domain Details Consistency
    function testEIP712DomainDetailsConsistency() public {
        (bytes1 initialFields, string memory initialName, string memory initialVersion, uint256 initialChainId, address initialVerifyingContract, bytes32 initialSalt, uint256[] memory initialExtensions) = eip712.eip712Domain();
        (bytes1 secondFields, string memory secondName, string memory secondVersion, uint256 secondChainId, address secondVerifyingContract, bytes32 secondSalt, uint256[] memory secondExtensions) = eip712.eip712Domain();
        assertEq(initialFields, secondFields, "EIP-712 domain fields should remain consistent");
        assertEq(keccak256(bytes(initialName)), keccak256(bytes(secondName)), "EIP-712 domain name should remain consistent");
        assertEq(keccak256(bytes(initialVersion)), keccak256(bytes(secondVersion)), "EIP-712 domain version should remain consistent");
        assertEq(initialChainId, secondChainId, "EIP-712 domain chain ID should remain consistent");
        assertEq(initialVerifyingContract, secondVerifyingContract, "EIP-712 domain verifying contract should remain consistent");
        assertEq(initialSalt, secondSalt, "EIP-712 domain salt should remain consistent");
        assertEq(initialExtensions.length, secondExtensions.length, "EIP-712 domain extensions should remain consistent");
    }

    // Invariant 7: Cached Domain Separator Invalidated Correctly
//    function testCachedDomainSeparatorInvalidatedCorrectly() public {
//        bool initialInvalidation = eip712.cachedDomainSeparatorInvalidated();
//        assertFalse(initialInvalidation, "Cached domain separator should not be invalidated initially");
//        vm.chainId(2); // Simulate chain ID change
//        bool newInvalidation = eip712.cachedDomainSeparatorInvalidated();
//        assertTrue(newInvalidation, "Cached domain separator should be invalidated on chain ID change");
//    }

    // Invariant 8: Domain Name and Version Override
//    function testDomainNameAndVersionOverride() public {
//        EIP712DerivedContract derivedEip712 = new EIP712DerivedContract();
//        (string memory name, string memory version) = derivedEip712.domainNameAndVersion();
//        assertEq(name, "DerivedName", "Domain name should be correctly overridden");
//        assertEq(version, "1.0", "Domain version should be correctly overridden");
//    }

    // Invariant 9: Domain Name and Version Changeability
//    function testDomainNameAndVersionChangeability() public {
//        EIP712DerivedContract derivedEip712 = new EIP712DerivedContract();
//        bool changeability = derivedEip712.domainNameAndVersionMayChange();
//        assertTrue(changeability, "Domain name and version changeability should be correctly indicated");
//    }
}

contract EIP712TestContract is EIP712 {
    function domainSeparator() public view returns (bytes32) {
        return _domainSeparator();
    }

    function hashTypedData(bytes32 structHash) public view returns (bytes32) {
        return _hashTypedData(structHash);
    }

//    function cachedDomainSeparatorInvalidated() public view returns (bool) {
//        return _cachedDomainSeparatorInvalidated();
//    }

    function _domainNameAndVersion()  virtual internal pure override returns (string memory name, string memory version) {
        name = "TestName";
        version = "1";
    }
}

contract EIP712DerivedContract is EIP712TestContract {
    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {
        name = "DerivedName";
        version = "1.0";
    }

    function _domainNameAndVersionMayChange() internal pure override returns (bool) {
        return true;
    }
}