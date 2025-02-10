// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import {Test} from "forge-std/Test.sol";
import {LibBitmap} from "../src/utils/LibBitmap.sol";

contract LibBitmapTest is Test {
    LibBitmap.Bitmap private bitmap;

    function setUp() public {
        // Initialize the bitmap or any other setup before each test
    }

    function testSetAndGet() public {
        uint256 index = 123;
        LibBitmap.set(bitmap, index);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should be set");

        LibBitmap.unset(bitmap, index);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should be unset");
    }

    function testToggle() public {
        uint256 index = 456;
        bool initialValue = LibBitmap.get(bitmap, index);
        bool toggledValue = LibBitmap.toggle(bitmap, index);

        assertEq(toggledValue, !initialValue, "Toggled value should be the opposite of initial value");
        assertEq(LibBitmap.get(bitmap, index), !initialValue, "Bit should be toggled in the bitmap");
    }

    function testSetTo() public {
        uint256 index = 789;
        LibBitmap.setTo(bitmap, index, true);
        assertTrue(LibBitmap.get(bitmap, index), "Bit should be set");

        LibBitmap.setTo(bitmap, index, false);
        assertFalse(LibBitmap.get(bitmap, index), "Bit should be unset");
    }

    function testSetBatch() public {
        uint256 start = 100;
        uint256 amount = 64;
        LibBitmap.setBatch(bitmap, start, amount);

        for (uint256 i = start; i < start + amount; i++) {
            assertTrue(LibBitmap.get(bitmap, i), "All bits in the batch should be set");
        }
    }

    function testUnsetBatch() public {
        uint256 start = 200;
        uint256 amount = 64;
        LibBitmap.setBatch(bitmap, start, amount);
        LibBitmap.unsetBatch(bitmap, start, amount);

        for (uint256 i = start; i < start + amount; i++) {
            assertFalse(LibBitmap.get(bitmap, i), "All bits in the batch should be unset");
        }
    }

    function testPopCount() public {
        uint256 start = 300;
        uint256 amount = 128;
        LibBitmap.setBatch(bitmap, start, amount);
        uint256 count = LibBitmap.popCount(bitmap, start, amount);

        assertEq(count, amount, "Pop count should equal the number of set bits");
    }

    function testFindLastSet() public {
        uint256 index = 1023;
        LibBitmap.set(bitmap, index);
        uint256 foundIndex = LibBitmap.findLastSet(bitmap, index);

        assertEq(foundIndex, index, "Should find the last set bit at the correct index");

        LibBitmap.unset(bitmap, index);
        foundIndex = LibBitmap.findLastSet(bitmap, index);
        assertEq(foundIndex, LibBitmap.NOT_FOUND, "Should not find any set bit");
    }

    function testNotFound() public {
        uint256 upTo = 2048;
        uint256 foundIndex = LibBitmap.findLastSet(bitmap, upTo);
        assertEq(foundIndex, LibBitmap.NOT_FOUND, "Should return NOT_FOUND when no bits are set");
    }
}