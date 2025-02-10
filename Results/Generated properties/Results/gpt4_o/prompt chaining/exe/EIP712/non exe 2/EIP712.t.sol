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
//        assertEq(initialSeparator, secondSeparator, "Cached domain separator should remain consistent");
//    }

//    // Invariant 2: Domain Separator Recalculation on Chain ID Change
//    function testDomainSeparatorRecalculationOnChainIdChange() public {
//        bytes32 initialSeparator = eip712._domainSeparator();
//        vm.chainId(2); // Simulate chain ID change
//        bytes32 newSeparator = eip712._domainSeparator();
//        assertTrue(initialSeparator != newSeparator, "Domain separator should be recalculated on chain ID change");
//    }

    // Invariant 3: Domain Separator Recalculation on Contract Address Change
//    function testDomainSeparatorRecalculationOnContractAddressChange() public {
//        bytes32 initialSeparator = eip712._domainSeparator();
//        EIP712 newEip712 = new EIP712Mock(); // Simulate contract address change
//        bytes32 newSeparator = newEip712._domainSeparator();
//        assertTrue(initialSeparator != newSeparator, "Domain separator should be recalculated on contract address change");
//    }

    // Invariant 4: Typed Data Hash Consistency
//    function testTypedDataHashConsistency() public {
//        bytes32 structHash = keccak256("TestStruct");
//        bytes32 initialHash = eip712._hashTypedData(structHash);
//        bytes32 secondHash = eip712._hashTypedData(structHash);
//        assertEq(initialHash, secondHash, "Typed data hash should remain consistent for the same input");
//    }

    // Invariant 5: Typed Data Hash Recalculation on Domain Separator Change
    function testTypedDataHashRecalculationOnDomainSeparatorChange() public {
        bytes32 structHash = keccak256("TestStruct");
        bytes32 initialHash = eip712._hashTypedData(structHash);
        vm.chainId(2); // Simulate domain separator change
        bytes32 newHash = eip712._hashTypedData(structHash);
        assertTrue(initialHash != newHash, "Typed data hash should change if the domain separator changes");
    }

    // Invariant 6: EIP-712 Domain Details Consistency
    function testEIP712DomainDetailsConsistency() public {
        (bytes1 fields, string memory name, string memory version, uint256 chainId, address verifyingContract, bytes32 salt, uint256[] memory extensions) = eip712.eip712Domain();
        (string memory expectedName, string memory expectedVersion) = eip712._domainNameAndVersion();
        assertEq(name, expectedName, "Domain name should match");
        assertEq(version, expectedVersion, "Domain version should match");
        assertEq(chainId, block.chainid, "Chain ID should match");
        assertEq(verifyingContract, address(eip712), "Verifying contract should match");
    }

    // Invariant 7: Domain Name and Version Override
    function testDomainNameAndVersionOverride() public {
        EIP712MockDerived derived = new EIP712MockDerived();
        (string memory name, string memory version) = derived._domainNameAndVersion();
        assertEq(name, "DerivedName", "Domain name should be overridden correctly");
        assertEq(version, "2", "Domain version should be overridden correctly");
    }

    // Invariant 8: Domain Name and Version Changeability
    function testDomainNameAndVersionChangeability() public {
        EIP712MockDerivedChangeable derived = new EIP712MockDerivedChangeable();
        derived.setDomainNameAndVersion("NewName", "3");
        (string memory name, string memory version) = derived._domainNameAndVersion();
        assertEq(name, "NewName", "Domain name should be changeable");
        assertEq(version, "3", "Domain version should be changeable");
    }

    // Invariant 9: Cached Domain Separator Invalidated
    function testCachedDomainSeparatorInvalidated() public {
        vm.chainId(2); // Simulate chain ID change
        bool invalidated = eip712._cachedDomainSeparatorInvalidated();
        assertTrue(invalidated, "Cached domain separator should be invalidated if the chain ID changes");
    }
}

contract EIP712Mock is EIP712 {
    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {
        name = "MockName";
        version = "1";
    }
}

contract EIP712MockDerived is EIP712Mock {
    function _domainNameAndVersion() internal pure override returns (string memory name, string memory version) {
        name = "DerivedName";
        version = "2";
    }
}

contract EIP712MockDerivedChangeable is EIP712Mock {
    string private _name = "InitialName";
    string private _version = "1";

    function setDomainNameAndVersion(string memory name, string memory version) public {
        _name = name;
        _version = version;
    }

    function _domainNameAndVersion() internal view override returns (string memory name, string memory version) {
        name = _name;
        version = _version;
    }

    function _domainNameAndVersionMayChange() internal pure override returns (bool) {
        return true;
    }
}