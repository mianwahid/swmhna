// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import {LibBitmap} from "../src/utils/LibBitmap.sol";
import {LibBit} from "../src/utils/LibBit.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;

    LibBitmap.Bitmap private bitmap;

    function testGetAndSet() public {
        uint256 index = 123;
        assertFalse(bitmap.get(index));
        bitmap.set(index);
        assertTrue(bitmap.get(index));
    }

    function testUnset() public {
        uint256 index = 123;
        bitmap.set(index);
        assertTrue(bitmap.get(index));
        bitmap.unset(index);
        assertFalse(bitmap.get(index));
    }

    function testToggle() public {
        uint256 index = 123;
        assertFalse(bitmap.get(index));
        bool newIsSet = bitmap.toggle(index);
        assertTrue(newIsSet);
        assertTrue(bitmap.get(index));
        newIsSet = bitmap.toggle(index);
        assertFalse(newIsSet);
        assertFalse(bitmap.get(index));
    }

    function testSetTo() public {
        uint256 index = 123;
        bitmap.setTo(index, true);
        assertTrue(bitmap.get(index));
        bitmap.setTo(index, false);
        assertFalse(bitmap.get(index));
    }

    function testSetBatch() public {
        uint256 start = 100;
        uint256 amount = 50;
        bitmap.setBatch(start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertTrue(bitmap.get(i));
        }
    }

    function testUnsetBatch() public {
        uint256 start = 100;
        uint256 amount = 50;
        bitmap.setBatch(start, amount);
        bitmap.unsetBatch(start, amount);
        for (uint256 i = start; i < start + amount; i++) {
            assertFalse(bitmap.get(i));
        }
    }

    function testPopCount() public {
        uint256 start = 100;
        uint256 amount = 50;
        bitmap.setBatch(start, amount);
        assertEq(bitmap.popCount(start, amount), amount);
    }

    function testFindLastSet() public {
        uint256 index = 123;
        bitmap.set(index);
        assertEq(bitmap.findLastSet(index), index);
        assertEq(bitmap.findLastSet(index - 1), LibBitmap.NOT_FOUND);
    }

    function testFindLastSetWithMultipleBits() public {
        uint256 index1 = 123;
        uint256 index2 = 150;
        bitmap.set(index1);
        bitmap.set(index2);
        assertEq(bitmap.findLastSet(index2), index2);
        assertEq(bitmap.findLastSet(index1), index1);
        assertEq(bitmap.findLastSet(index1 - 1), LibBitmap.NOT_FOUND);
    }

    function testFindLastSetWithUnsetBits() public {
        uint256 index1 = 123;
        uint256 index2 = 150;
        bitmap.set(index1);
        bitmap.set(index2);
        bitmap.unset(index2);
        assertEq(bitmap.findLastSet(index2), index1);
    }
}