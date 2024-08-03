// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/LibBitmap.sol";

contract LibBitmapTest is Test {
    LibBitmap.Bitmap private bitmap;

    function testGetUnsetBits() public {
        for (uint256 i = 0; i < 1024; i++) {
            assertFalse(LibBitmap.get(bitmap, i), "Unset bit should return false");
        }
    }

    function testSetAndGet() public {
        uint256 index = 500;
        LibBitmap.set(bitmap, index);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should be set");
    }

    function testSetEdgeCase() public {
        uint256 index = 500;
        LibBitmap.set(bitmap, index);
        LibBitmap.set(bitmap, index);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should remain true");
    }

    function testUnsetAndGet() public {
        uint256 index = 500;
        LibBitmap.set(bitmap, index);
        LibBitmap.unset(bitmap, index);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should be unset");
    }

    function testUnsetEdgeCase() public {
        uint256 index = 500;
        LibBitmap.unset(bitmap, index);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should remain false");
    }

    function testToggleAndGet() public {
        uint256 index = 500;
        bool newState = LibBitmap.toggle(bitmap, index);
        assertTrue(newState == LibBitmap.get(bitmap, index), "Toggled state should match get result");
    }

    function testToggleTwice() public {
        uint256 index = 500;
        LibBitmap.toggle(bitmap, index);
        LibBitmap.toggle(bitmap, index);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should return to original state");
    }

    function testSetToAndGet() public {
        uint256 index = 500;
        LibBitmap.setTo(bitmap, index, true);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should be set to true");
        LibBitmap.setTo(bitmap, index, false);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should be set to false");
    }

    function testSetBatch() public {
        uint256 start = 256;
        uint256 amount = 512;
        LibBitmap.setBatch(bitmap, start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertTrue(LibBitmap.get(bitmap, i), "All bits in batch should be set");
        }
    }

    function testUnsetBatch() public {
        uint256 start = 256;
        uint256 amount = 512;
        LibBitmap.setBatch(bitmap, start, amount);
        LibBitmap.unsetBatch(bitmap, start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertFalse(LibBitmap.get(bitmap, i), "All bits in batch should be unset");
        }
    }

    function testPopCount() public {
        uint256 start = 100;
        uint256 amount = 200;
        LibBitmap.setBatch(bitmap, start, amount);
        uint256 count = LibBitmap.popCount(bitmap, start, amount);
        assertEq(count, amount, "Pop count should match the number of set bits");
    }

    function testFindLastSet() public {
        uint256 index = 1023;
        LibBitmap.set(bitmap, index);
        assertEq(LibBitmap.findLastSet(bitmap, index), index, "Should find the last set bit");
    }

    function testFindLastSetNotFound() public {
        uint256 upTo = 1023;
        uint256 result = LibBitmap.findLastSet(bitmap, upTo);
        assertEq(result, LibBitmap.NOT_FOUND, "Should return NOT_FOUND when no bits are set");
    }
}
