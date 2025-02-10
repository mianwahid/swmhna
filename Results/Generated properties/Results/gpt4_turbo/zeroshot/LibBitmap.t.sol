// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {LibBitmap} from "../src/LibBitmap.sol";
import {LibBit} from "../LibBit.sol";

contract LibBitmapTest is Test {
    LibBitmap.Bitmap private bitmap;

    /// @dev Test setting and getting a bit.
    function testSetAndGet() public {
        uint256 index = 123;
        LibBitmap.set(bitmap, index);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should be set");
    }

    /// @dev Test unsetting a bit.
    function testUnset() public {
        uint256 index = 456;
        LibBitmap.set(bitmap, index);
        LibBitmap.unset(bitmap, index);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should be unset");
    }

    /// @dev Test toggling a bit.
    function testToggle() public {
        uint256 index = 789;
        bool initialState = LibBitmap.get(bitmap, index);
        bool newState = LibBitmap.toggle(bitmap, index);
        assertEq(newState, !initialState, "Bit should be toggled");
    }

    /// @dev Test setting a bit to a specific state.
    function testSetTo() public {
        uint256 index = 101112;
        LibBitmap.setTo(bitmap, index, true);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should be set to true");
        LibBitmap.setTo(bitmap, index, false);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should be set to false");
    }

    /// @dev Test setting a batch of bits.
    function testSetBatch() public {
        uint256 start = 200;
        uint256 amount = 64;
        LibBitmap.setBatch(bitmap, start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertTrue(
                LibBitmap.get(bitmap, i),
                "All bits in batch should be set"
            );
        }
    }

    /// @dev Test unsetting a batch of bits.
    function testUnsetBatch() public {
        uint256 start = 300;
        uint256 amount = 64;
        LibBitmap.setBatch(bitmap, start, amount);
        LibBitmap.unsetBatch(bitmap, start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertFalse(
                LibBitmap.get(bitmap, i),
                "All bits in batch should be unset"
            );
        }
    }

    /// @dev Test counting set bits in a range.
    function testPopCount() public {
        uint256 start = 400;
        uint256 amount = 128;
        LibBitmap.setBatch(bitmap, start, amount);
        uint256 count = LibBitmap.popCount(bitmap, start, amount);
        assertEq(count, amount, "All bits in range should be counted as set");
    }

    /// @dev Test finding the last set bit.
    function testFindLastSet() public {
        uint256 index = 500;
        LibBitmap.set(bitmap, index);
        uint256 foundIndex = LibBitmap.findLastSet(bitmap, 1000);
        assertEq(foundIndex, index, "Should find the last set bit correctly");
    }

    /// @dev Test edge cases for bit operations.
    function testEdgeCases() public {
        // Test boundary conditions
        LibBitmap.set(bitmap, 0);
        assertTrue(LibBitmap.get(bitmap, 0), "Bit at index 0 should be set");

        uint256 maxIndex = type(uint256).max;
        LibBitmap.set(bitmap, maxIndex);
        assertTrue(
            LibBitmap.get(bitmap, maxIndex),
            "Bit at max index should be set"
        );

        // Test overflow conditions
        LibBitmap.set(bitmap, maxIndex);
        LibBitmap.unset(bitmap, maxIndex);
        assertFalse(
            LibBitmap.get(bitmap, maxIndex),
            "Bit at max index should be unset after overflow"
        );
    }

    /// @dev Fuzz testing for random bit setting and getting.
    function testFuzzSetAndGet(uint256 index) public {
        LibBitmap.set(bitmap, index);
        assertTrue(
            LibBitmap.get(bitmap, index),
            "Randomly set bit should be set"
        );
    }

    /// @dev Fuzz testing for random bit toggling.
    function testFuzzToggle(uint256 index) public {
        bool initialState = LibBitmap.get(bitmap, index);
        bool toggledState = LibBitmap.toggle(bitmap, index);
        assertEq(
            toggledState,
            !initialState,
            "Randomly toggled bit should toggle state"
        );
    }
}
