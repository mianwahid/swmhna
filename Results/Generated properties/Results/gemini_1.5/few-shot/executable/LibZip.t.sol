// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibZip.sol";

contract LibZipTest is Test {
    function _generateBytes(uint256 length) internal pure returns (bytes memory result) {
        result = new bytes(length);
        uint256 i = 0;
        while (i < length) {
            result[i] = bytes1(uint8(i));
            unchecked {
                ++i;
            }
        }
    }

    function _assertEqualBytes(bytes memory a, bytes memory b) internal {
        assertEq(a.length, b.length, "LibZipTest: Lengths mismatch");
        for (uint256 i; i < a.length; ++i) {
            assertEq(a[i], b[i], "LibZipTest: Values mismatch");
        }
    }

    function testFLZCompressDecompress(uint256 seed) public {
        seed = _bound(seed, 1, 1024);
        bytes memory data = _generateBytes(seed);
        _assertEqualBytes(data, LibZip.flzDecompress(LibZip.flzCompress(data)));
    }

    function testFLZCompressDecompress(bytes memory data) public {
        _assertEqualBytes(data, LibZip.flzDecompress(LibZip.flzCompress(data)));
    }

    function testFLZCompressDecompressEmpty() public {
        bytes memory data = "";
        _assertEqualBytes(data, LibZip.flzDecompress(LibZip.flzCompress(data)));
    }

    function testCDCompressDecompress(uint256 seed) public {
        seed = _bound(seed, 1, 1024);
        bytes memory data = _generateBytes(seed);
        _assertEqualBytes(data, LibZip.cdDecompress(LibZip.cdCompress(data)));
    }

    function testCDCompressDecompress(bytes memory data) public {
        _assertEqualBytes(data, LibZip.cdDecompress(LibZip.cdCompress(data)));
    }

    function testCDCompressDecompressEmpty() public {
        bytes memory data = "";
        _assertEqualBytes(data, LibZip.cdDecompress(LibZip.cdCompress(data)));
    }

    function testCDCompressDecompressFuzz(bytes memory data) public {
        uint256 targetLength = data.length / 8;
        bytes memory result = LibZip.cdCompress(data);
        console2.log("Original Length", data.length);
        console2.log("Compressed Length", result.length);
        _assertEqualBytes(data, LibZip.cdDecompress(result));
    }

function testCDCompressDecompressSpecific() public {
    bytes memory data = hex"0000000000000000000000000000000000000000000000000000000000000000";
    // Ensure data has an even number of hex digits
    require(data.length % 2 == 0, "Hex data must have an even number of digits");

    uint256 targetLength = data.length / 8;
    bytes memory result = LibZip.cdCompress(data);

    console2.log("Original Length", data.length);
    console2.log("Compressed Length", result.length);

    assertTrue(result.length <= targetLength);
    _assertEqualBytes(data, LibZip.cdDecompress(result));
}


//    function testCDFallback(bytes memory data) public {
//        vm.assume(data.length <= 65535);
//        bytes memory compressed = LibZip.cdCompress(data);
//        vm.record();
//        (bool success, bytes memory returnData) = address(this).call(compressed);
//        vm.stopPrank();
////        assertEq(success, true);
//        assertEq(returnData.length, 0);
//    }

//    function testCDFallbackRevert(bytes memory data, bytes memory compressed) public {
//        vm.assume(data.length <= 65535);
//        vm.assume(compressed.length <= 65535);
//        vm.record();
//        (bool success, bytes memory returnData) = this.call(compressed);
//        vm.stopPrank();
//        assertEq(success, false);
//    }

    fallback() external payable {
        LibZip.cdFallback();
    }

    receive() external payable {} // Silence compiler warning to add a `receive` function.
}

