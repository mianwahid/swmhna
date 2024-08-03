// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/SSTORE2.sol";

contract SSTORE2Test is Test {
    bytes sampleData = "Hello, world!";
    bytes32 sampleSalt = keccak256("sampleSalt");
    address deployer = address(this);

    function testSuccessfulWrite() public {
        address pointer = SSTORE2.write(sampleData);
        assertNotEq(pointer, address(0), "Pointer should not be zero");
        bytes memory storedData = SSTORE2.read(pointer);
        assertEq(
            storedData,
            sampleData,
            "Stored data does not match input data"
        );
    }

    // function testRevertOnDeploymentFailure() public {
    //     bytes memory largeData = new bytes(24577); // Exceeds max contract size
    //     vm.expectRevert(SSTORE2.DeploymentFailed.selector);
    //     SSTORE2.write(largeData);
    // }

    // function testWriteDeterministic() public {
    //     address pointer1 = SSTORE2.writeDeterministic(sampleData, sampleSalt);
    //     address pointer2 = SSTORE2.writeDeterministic(sampleData, sampleSalt);
    //     assertEq(
    //         pointer1,
    //         pointer2,
    //         "Addresses should match for the same data and salt"
    //     );
    //     bytes memory storedData = SSTORE2.read(pointer1);
    //     assertEq(
    //         storedData,
    //         sampleData,
    //         "Stored data does not match input data"
    //     );
    // }

    function testInitCodeHashConsistency() public {
        bytes32 hash1 = SSTORE2.initCodeHash(sampleData);
        bytes32 hash2 = SSTORE2.initCodeHash(sampleData);
        assertEq(hash1, hash2, "Hashes should be consistent for the same data");
    }

    function testPredictDeterministicAddress() public {
        address predicted = SSTORE2.predictDeterministicAddress(
            sampleData,
            sampleSalt,
            deployer
        );
        address actual = SSTORE2.writeDeterministic(sampleData, sampleSalt);
        assertEq(
            predicted,
            actual,
            "Predicted and actual address should match"
        );
    }

    function testReadFullData() public {
        address pointer = SSTORE2.write(sampleData);
        bytes memory data = SSTORE2.read(pointer);
        assertEq(data, sampleData, "Read data should match the written data");
    }

    function testReadWithInvalidPointer() public {
        vm.expectRevert(SSTORE2.InvalidPointer.selector);
        SSTORE2.read(address(0));
    }

    // function testReadPartialData() public {
    //     address pointer = SSTORE2.write(sampleData);
    //     uint256 start = 5;
    //     bytes memory data = SSTORE2.read(pointer, start);
    //     bytes memory expectedData = bytes(sampleData[start:]);
    //     assertEq(
    //         data,
    //         expectedData,
    //         "Partial read data should match expected slice"
    //     );
    // }

    function testReadOutOfBounds() public {
        address pointer = SSTORE2.write(sampleData);
        uint256 start = sampleData.length + 1;
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, start);
    }

    // function testReadRangeData() public {
    //     address pointer = SSTORE2.write(sampleData);
    //     uint256 start = 3;
    //     uint256 end = 8;
    //     bytes memory data = SSTORE2.read(pointer, start, end);
    //     bytes memory expectedData = bytes(sampleData[start:end]);
    //     assertEq(
    //         data,
    //         expectedData,
    //         "Range read data should match expected slice"
    //     );
    // }

    function testReadInvalidRange() public {
        address pointer = SSTORE2.write(sampleData);
        uint256 start = 8;
        uint256 end = 3;
        vm.expectRevert(SSTORE2.ReadOutOfBounds.selector);
        SSTORE2.read(pointer, start, end);
    }
}
