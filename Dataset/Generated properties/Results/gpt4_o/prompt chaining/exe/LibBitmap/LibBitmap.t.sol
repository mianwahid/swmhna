// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;
    LibBitmap.Bitmap private bitmap;

    // 1. `get` Function
    function testGetNeverSetBit() public {
        assertFalse(bitmap.get(0));
    }

    function testGetSetBit() public {
        bitmap.set(1);
        assertTrue(bitmap.get(1));
    }

    function testGetUnsetBit() public {
        bitmap.set(2);
        bitmap.unset(2);
        assertFalse(bitmap.get(2));
    }

    function testGetMaxIndex() public {
        uint256 maxIndex = type(uint256).max;
        assertFalse(bitmap.get(maxIndex));
    }

    // 2. `set` Function
    function testSetBit() public {
        bitmap.set(3);
        assertTrue(bitmap.get(3));
    }

    function testSetAlreadySetBit() public {
        bitmap.set(4);
        bitmap.set(4);
        assertTrue(bitmap.get(4));
    }

    function testSetMaxIndex() public {
        uint256 maxIndex = type(uint256).max;
        bitmap.set(maxIndex);
        assertTrue(bitmap.get(maxIndex));
    }

    // 3. `unset` Function
    function testUnsetBit() public {
        bitmap.set(5);
        bitmap.unset(5);
        assertFalse(bitmap.get(5));
    }

    function testUnsetAlreadyUnsetBit() public {
        bitmap.unset(6);
        assertFalse(bitmap.get(6));
    }

    function testUnsetMaxIndex() public {
        uint256 maxIndex = type(uint256).max;
        bitmap.set(maxIndex);
        bitmap.unset(maxIndex);
        assertFalse(bitmap.get(maxIndex));
    }

    // 4. `toggle` Function
    function testToggleBit() public {
        bitmap.toggle(7);
        assertTrue(bitmap.get(7));
        bitmap.toggle(7);
        assertFalse(bitmap.get(7));
    }

    function testToggleTwice() public {
        bitmap.toggle(8);
        bitmap.toggle(8);
        assertFalse(bitmap.get(8));
    }

    function testToggleMaxIndex() public {
        uint256 maxIndex = type(uint256).max;
        bitmap.toggle(maxIndex);
        assertTrue(bitmap.get(maxIndex));
        bitmap.toggle(maxIndex);
        assertFalse(bitmap.get(maxIndex));
    }

    // 5. `setTo` Function
    function testSetToTrue() public {
        bitmap.setTo(9, true);
        assertTrue(bitmap.get(9));
    }

    function testSetToFalse() public {
        bitmap.setTo(10, true);
        bitmap.setTo(10, false);
        assertFalse(bitmap.get(10));
    }

    function testSetToCurrentState() public {
        bitmap.setTo(11, true);
        bitmap.setTo(11, true);
        assertTrue(bitmap.get(11));
    }

    function testSetToMaxIndex() public {
        uint256 maxIndex = type(uint256).max;
        bitmap.setTo(maxIndex, true);
        assertTrue(bitmap.get(maxIndex));
        bitmap.setTo(maxIndex, false);
        assertFalse(bitmap.get(maxIndex));
    }

    // 6. `setBatch` Function
    function testSetBatch() public {
        bitmap.setBatch(12, 5);
        for (uint256 i = 12; i < 17; i++) {
            assertTrue(bitmap.get(i));
        }
    }

    function testSetBatchMultipleSlots() public {
        bitmap.setBatch(250, 10);
        for (uint256 i = 250; i < 260; i++) {
            assertTrue(bitmap.get(i));
        }
    }

    function testSetBatchMaxIndex() public {
        uint256 maxIndex = type(uint256).max - 4;
        bitmap.setBatch(maxIndex, 5);
        for (uint256 i = maxIndex; i < maxIndex + 5; i++) {
            assertTrue(bitmap.get(i));
        }
    }

    // 7. `unsetBatch` Function
    function testUnsetBatch() public {
        bitmap.setBatch(18, 5);
        bitmap.unsetBatch(18, 5);
        for (uint256 i = 18; i < 23; i++) {
            assertFalse(bitmap.get(i));
        }
    }

    function testUnsetBatchMultipleSlots() public {
        bitmap.setBatch(260, 10);
        bitmap.unsetBatch(260, 10);
        for (uint256 i = 260; i < 270; i++) {
            assertFalse(bitmap.get(i));
        }
    }

    function testUnsetBatchMaxIndex() public {
        uint256 maxIndex = type(uint256).max - 4;
        bitmap.setBatch(maxIndex, 5);
        bitmap.unsetBatch(maxIndex, 5);
        for (uint256 i = maxIndex; i < maxIndex + 5; i++) {
            assertFalse(bitmap.get(i));
        }
    }

    // 8. `popCount` Function
    function testPopCountEmpty() public {
        assertEq(bitmap.popCount(0, 256), 0);
    }

    function testPopCountFull() public {
        bitmap.setBatch(0, 256);
        assertEq(bitmap.popCount(0, 256), 256);
    }

    function testPopCountRange() public {
        bitmap.setBatch(20, 10);
        assertEq(bitmap.popCount(20, 10), 10);
    }

    function testPopCountMaxIndex() public {
        uint256 maxIndex = type(uint256).max - 4;
        bitmap.setBatch(maxIndex, 5);
        assertEq(bitmap.popCount(maxIndex, 5), 5);
    }

    // 9. `findLastSet` Function
    function testFindLastSetEmpty() public {
        assertEq(bitmap.findLastSet(256), LibBitmap.NOT_FOUND);
    }

    function testFindLastSetSingleBit() public {
        bitmap.set(30);
        assertEq(bitmap.findLastSet(256), 30);
    }

    function testFindLastSetFull() public {
        bitmap.setBatch(0, 256);
        assertEq(bitmap.findLastSet(256), 255);
    }

    function testFindLastSetMaxIndex() public {
        uint256 maxIndex = type(uint256).max;
        bitmap.set(maxIndex);
        assertEq(bitmap.findLastSet(maxIndex), maxIndex);
    }
}