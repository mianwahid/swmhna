// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;

    LibBitmap.Bitmap private bitmap;

    function testEdgeCasesGet() public {
        // Index 0: Should be false initially
        assertFalse(bitmap.get(0), "Index 0 should be false initially");

        // Last index in a bucket: Set and check bits at the end of buckets
        bitmap.set(255);
        assertTrue(bitmap.get(255), "Index 255 should be true");
        bitmap.set(511);
        assertTrue(bitmap.get(511), "Index 511 should be true");

        // Index out of bounds: Should be false
        assertFalse(bitmap.get(1024), "Out of bounds index should be false");
    }

    function testEdgeCasesSet() public {
        // Index 0: Set and check
        bitmap.set(0);
        assertTrue(bitmap.get(0), "Index 0 should be true after setting");

        // Last index in a bucket
        bitmap.set(255);
        assertTrue(bitmap.get(255), "Index 255 should be true after setting");

        // Setting an already set bit
        bitmap.set(255); // Setting again
        assertTrue(bitmap.get(255), "Index 255 should remain true");

        // Index out of bounds: Should expand the bitmap
        uint256 largeIndex = 1024;
        bitmap.set(largeIndex);
        assertTrue(bitmap.get(largeIndex), "Out of bounds index should be set to true");
    }

    function testEdgeCasesUnset() public {
        // Index 0
        bitmap.set(0);
        bitmap.unset(0);
        assertFalse(bitmap.get(0), "Index 0 should be false after unsetting");

        // Last index in a bucket
        bitmap.set(511);
        bitmap.unset(511);
        assertFalse(bitmap.get(511), "Index 511 should be false after unsetting");

        // Unsetting an already unset bit
        bitmap.unset(511);
        assertFalse(bitmap.get(511), "Index 511 should remain false");

        // Index out of bounds: Should have no effect
        bitmap.unset(1024);
        assertFalse(bitmap.get(1024), "Out of bounds index should remain false");
    }

    function testEdgeCasesToggle() public {
        // Index 0
        assertTrue(bitmap.toggle(0), "Index 0 should be true after first toggle");
        assertFalse(bitmap.toggle(0), "Index 0 should be false after second toggle");

        // Last index in a bucket
        assertTrue(bitmap.toggle(255), "Index 255 should be true after first toggle");
        assertFalse(bitmap.toggle(255), "Index 255 should be false after second toggle");

        // Toggling multiple times
        uint256 index = 100;
        for (uint256 i = 0; i < 5; ++i) {
            bool expectedValue = (i % 2 == 0); // True, False, True...
            assertEq(bitmap.toggle(index), expectedValue, "Toggle value incorrect");
        }

        // Index out of bounds: Should expand and set to true
        uint256 outOfBoundsIndex = 1024;
        assertTrue(
            bitmap.toggle(outOfBoundsIndex),
            "Out of bounds index should be true after toggle"
        );
    }

    function testEdgeCasesSetTo() public {
        // Combinations of index and shouldSet
        bitmap.setTo(0, true);
        assertTrue(bitmap.get(0), "Index 0 should be true");
        bitmap.setTo(0, false);
        assertFalse(bitmap.get(0), "Index 0 should be false");

        bitmap.setTo(255, true);
        assertTrue(bitmap.get(255), "Index 255 should be true");
        bitmap.setTo(255, false);
        assertFalse(bitmap.get(255), "Index 255 should be false");

        // Index out of bounds
        uint256 outOfBoundsIndex = 1024;
        bitmap.setTo(outOfBoundsIndex, true);
        assertTrue(bitmap.get(outOfBoundsIndex), "Out of bounds index should be true");
        bitmap.setTo(outOfBoundsIndex, false);
        assertFalse(bitmap.get(outOfBoundsIndex), "Out of bounds index should be false");
    }

    function testEdgeCasesSetBatch() public {
        // Start at 0, amount 10
        bitmap.setBatch(0, 10);
        for (uint256 i = 0; i < 10; ++i) {
            assertTrue(bitmap.get(i), "Bits in batch should be set");
        }

        // Amount 1 (effectively same as set)
        bitmap.unset(15);
        bitmap.setBatch(15, 1);
        assertTrue(bitmap.get(15), "Single bit should be set");

        // Amount spanning multiple buckets
        bitmap.setBatch(250, 12);
        for (uint256 i = 250; i < 262; ++i) {
            assertTrue(bitmap.get(i), "Bits across buckets should be set");
        }

        // Amount exceeding bitmap size (test for correct expansion)
        bitmap.setBatch(2040, 10);
        for (uint256 i = 2040; i < 2050; ++i) {
            assertTrue(bitmap.get(i), "Bits in expanded bitmap should be set");
        }
    }

    function testEdgeCasesUnsetBatch() public {
        // Set some bits for testing
        bitmap.setBatch(0, 300);

        // Start at 0, amount 10
        bitmap.unsetBatch(0, 10);
        for (uint256 i = 0; i < 10; ++i) {
            assertFalse(bitmap.get(i), "Bits in batch should be unset");
        }

        // Amount 1 (effectively same as unset)
        bitmap.set(20);
        bitmap.unsetBatch(20, 1);
        assertFalse(bitmap.get(20), "Single bit should be unset");

        // Amount spanning multiple buckets
        bitmap.unsetBatch(250, 12);
        for (uint256 i = 250; i < 262; ++i) {
            assertFalse(bitmap.get(i), "Bits across buckets should be unset");
        }

        // Amount exceeding bitmap size - should not have unintended effects
        bitmap.unsetBatch(500, 1000);
        for (uint256 i = 500; i < 800; ++i) {
            assertFalse(bitmap.get(i), "Bits beyond the bitmap size should remain unset");
        }
    }

    function testEdgeCasesPopCount() public {
        // Empty bitmap
        assertEq(bitmap.popCount(0, 100), 0, "Empty bitmap should have a popCount of 0");

        // Set some bits for testing
        bitmap.setBatch(0, 10); // Set bits 0-9
        bitmap.setBatch(20, 5); // Set bits 20-24

        // Start at 0, amount 10
        assertEq(bitmap.popCount(0, 10), 10, "Incorrect popCount for range 0-9");

        // Amount 1
        assertEq(bitmap.popCount(5, 1), 1, "Incorrect popCount for a single bit");

        // Amount spanning multiple buckets
        assertEq(bitmap.popCount(5, 20), 10, "Incorrect popCount across buckets");

        // Amount exceeding bitmap size
        assertEq(
            bitmap.popCount(0, 1000),
            15,
            "Incorrect popCount when amount exceeds bitmap size"
        );
    }

    function testEdgeCasesFindLastSet() public {
        // Empty bitmap
        assertEq(
            bitmap.findLastSet(100),
            LibBitmap.NOT_FOUND,
            "findLastSet should return NOT_FOUND for empty bitmap"
        );

        // UpTo 0
        assertEq(
            bitmap.findLastSet(0),
            LibBitmap.NOT_FOUND,
            "findLastSet should return NOT_FOUND when upTo is 0"
        );

        // Single bit set
        bitmap.set(10);
        assertEq(bitmap.findLastSet(100), 10, "findLastSet should find the single set bit");

        // Multiple bits set
        bitmap.set(5);
        bitmap.set(25);
        assertEq(bitmap.findLastSet(100), 25, "findLastSet should find the most significant bit");

        // UpTo exceeding bitmap size
        assertEq(
            bitmap.findLastSet(200),
            25,
            "findLastSet should limit search to the bitmap size"
        );

        // No set bit found within the range
        bitmap.unsetBatch(0, 30);
        assertEq(
            bitmap.findLastSet(20),
            LibBitmap.NOT_FOUND,
            "findLastSet should return NOT_FOUND when no bit is set within the range"
        );
    }
}
