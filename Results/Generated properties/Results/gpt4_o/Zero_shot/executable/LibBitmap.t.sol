// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;

    LibBitmap.Bitmap private bitmap;

    function setUp() public {
        // Initial setup if needed
    }

    function testGetUnsetBit() public {
        assertFalse(bitmap.get(0));
    }

    function testSetAndGetBit() public {
        bitmap.set(0);
        assertTrue(bitmap.get(0));
    }

    function testUnsetBit() public {
        bitmap.set(0);
        bitmap.unset(0);
        assertFalse(bitmap.get(0));
    }

    function testToggleBit() public {
        bool newIsSet = bitmap.toggle(0);
        assertTrue(newIsSet);
        newIsSet = bitmap.toggle(0);
        assertFalse(newIsSet);
    }

    function testSetTo() public {
        bitmap.setTo(0, true);
        assertTrue(bitmap.get(0));
        bitmap.setTo(0, false);
        assertFalse(bitmap.get(0));
    }

    function testSetBatch() public {
        bitmap.setBatch(0, 256);
        for (uint256 i = 0; i < 256; i++) {
            assertTrue(bitmap.get(i));
        }
    }

    function testUnsetBatch() public {
        bitmap.setBatch(0, 256);
        bitmap.unsetBatch(0, 256);
        for (uint256 i = 0; i < 256; i++) {
            assertFalse(bitmap.get(i));
        }
    }

    function testPopCount() public {
        bitmap.setBatch(0, 128);
        assertEq(bitmap.popCount(0, 256), 128);
    }

    function testFindLastSet() public {
        bitmap.set(255);
        assertEq(bitmap.findLastSet(255), 255);
        assertEq(bitmap.findLastSet(254), LibBitmap.NOT_FOUND);
    }

    function testFuzzSetAndGet(uint256 index) public {
        bitmap.set(index);
        assertTrue(bitmap.get(index));
    }

    function testFuzzUnset(uint256 index) public {
        bitmap.set(index);
        bitmap.unset(index);
        assertFalse(bitmap.get(index));
    }

    function testFuzzToggle(uint256 index) public {
        bool newIsSet = bitmap.toggle(index);
        assertTrue(newIsSet);
        newIsSet = bitmap.toggle(index);
        assertFalse(newIsSet);
    }

    function testFuzzSetTo(uint256 index, bool shouldSet) public {
        bitmap.setTo(index, shouldSet);
        assertEq(bitmap.get(index), shouldSet);
    }

    function testFuzzSetBatch(uint256 start, uint256 amount) public {
        start=start%100;
        amount=amount%10000;
        bitmap.setBatch(start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertTrue(bitmap.get(i));
        }
    }

    function testFuzzUnsetBatch(uint256 start, uint256 amount) public {
        start=start%100;
        amount=amount%10000;
        bitmap.setBatch(start, amount);
        bitmap.unsetBatch(start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertFalse(bitmap.get(i));
        }
    }

    function testFuzzPopCount(uint256 start, uint256 amount) public {
        start=start%100;
        amount=amount%10000;
        bitmap.setBatch(start, amount);
        assertEq(bitmap.popCount(start, amount), amount);
    }

    function testFuzzFindLastSet(uint256 upTo) public {
        if (upTo > 0) {
            bitmap.set(upTo - 1);
            assertEq(bitmap.findLastSet(upTo - 1), upTo - 1);
        }
    }
}