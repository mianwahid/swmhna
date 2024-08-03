// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;
    LibBitmap.Bitmap bitmap;

    // 1. `get` Function
    function testGetUnsetBit() public {
        assert(!bitmap.get(0));
    }

    function testGetSetBit() public {
        bitmap.set(0);
        assert(bitmap.get(0));
    }

    function testGetOutOfRangeBit() public {
        assert(!bitmap.get(type(uint256).max));
    }

    // 2. `set` Function
    function testSetBit() public {
        bitmap.set(1);
        assert(bitmap.get(1));
    }

    function testSetAlreadySetBit() public {
        bitmap.set(2);
        bitmap.set(2);
        assert(bitmap.get(2));
    }

    function testSetBitDoesNotAffectOthers() public {
        bitmap.set(3);
        assert(!bitmap.get(4));
    }

    // 3. `unset` Function
    function testUnsetBit() public {
        bitmap.set(5);
        bitmap.unset(5);
        assert(!bitmap.get(5));
    }

    function testUnsetAlreadyUnsetBit() public {
        bitmap.unset(6);
        assert(!bitmap.get(6));
    }

    function testUnsetBitDoesNotAffectOthers() public {
        bitmap.set(7);
        bitmap.unset(8);
        assert(bitmap.get(7));
    }

    // 4. `toggle` Function
    function testToggleBit() public {
        bool newIsSet = bitmap.toggle(9);
        assert(newIsSet);
        newIsSet = bitmap.toggle(9);
        assert(!newIsSet);
    }

    function testToggleBitTwice() public {
        bitmap.toggle(10);
        bitmap.toggle(10);
        assert(!bitmap.get(10));
    }

    function testToggleBitDoesNotAffectOthers() public {
        bitmap.set(11);
        bitmap.toggle(12);
        assert(bitmap.get(11));
    }

    // 5. `setTo` Function
    function testSetToTrue() public {
        bitmap.setTo(13, true);
        assert(bitmap.get(13));
    }

    function testSetToFalse() public {
        bitmap.set(14);
        bitmap.setTo(14, false);
        assert(!bitmap.get(14));
    }

    function testSetToCurrentState() public {
        bitmap.set(15);
        bitmap.setTo(15, true);
        assert(bitmap.get(15));
    }

    function testSetToDoesNotAffectOthers() public {
        bitmap.set(16);
        bitmap.setTo(17, true);
        assert(bitmap.get(16));
    }

    // 6. `setBatch` Function
    function testSetBatch() public {
        bitmap.setBatch(18, 5);
        for (uint256 i = 18; i < 23; i++) {
            assert(bitmap.get(i));
        }
    }

    function testSetBatchDoesNotAffectOthers() public {
        bitmap.setBatch(24, 5);
        assert(!bitmap.get(23));
        assert(!bitmap.get(29));
    }

    function testSetBatchAlreadySet() public {
        bitmap.setBatch(30, 5);
        bitmap.setBatch(30, 5);
        for (uint256 i = 30; i < 35; i++) {
            assert(bitmap.get(i));
        }
    }

    // 7. `unsetBatch` Function
    function testUnsetBatch() public {
        bitmap.setBatch(36, 5);
        bitmap.unsetBatch(36, 5);
        for (uint256 i = 36; i < 41; i++) {
            assert(!bitmap.get(i));
        }
    }

    function testUnsetBatchDoesNotAffectOthers() public {
        bitmap.setBatch(42, 5);
        bitmap.unsetBatch(42, 5);
        assert(!bitmap.get(41));
        assert(!bitmap.get(47));
    }

    function testUnsetBatchAlreadyUnset() public {
        bitmap.unsetBatch(48, 5);
        for (uint256 i = 48; i < 53; i++) {
            assert(!bitmap.get(i));
        }
    }

    // 8. `popCount` Function
    function testPopCountAccurate() public {
        bitmap.setBatch(54, 5);
        assert(bitmap.popCount(54, 5) == 5);
    }

    function testPopCountZero() public {
        assert(bitmap.popCount(59, 5) == 0);
    }

    function testPopCountAllSet() public {
        bitmap.setBatch(64, 5);
        assert(bitmap.popCount(64, 5) == 5);
    }

    // 9. `findLastSet` Function
    function testFindLastSet() public {
        bitmap.set(69);
        bitmap.set(70);
        assert(bitmap.findLastSet(70) == 70);
    }

    function testFindLastSetNotFound() public {
        assert(bitmap.findLastSet(75) == LibBitmap.NOT_FOUND);
    }

    function testFindLastSetBoundary() public {
        bitmap.set(79);
        assert(bitmap.findLastSet(79) == 79);
    }

    // Additional Edge Cases
    function testEmptyBitmapOperations() public {
        assert(!bitmap.get(0));
        bitmap.set(0);
        bitmap.unset(0);
        assert(!bitmap.get(0));
    }

    function testMaxIndexOperations() public {
        bitmap.set(type(uint256).max);
        assert(bitmap.get(type(uint256).max));
        bitmap.unset(type(uint256).max);
        assert(!bitmap.get(type(uint256).max));
    }

    function testZeroLengthRangeOperations() public {
        bitmap.setBatch(0, 0);
        assert(!bitmap.get(0));
        bitmap.unsetBatch(0, 0);
        assert(!bitmap.get(0));
    }
}