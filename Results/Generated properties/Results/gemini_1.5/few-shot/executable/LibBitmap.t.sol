// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;

    LibBitmap.Bitmap map;

    function testGet(uint256 index, bool shouldSet) public {
        if (shouldSet) {
            map.set(index);
        }
        assertEq(map.get(index), shouldSet);
    }

    function testSet(uint256 index) public {
        assertFalse(map.get(index));
        map.set(index);
        assertTrue(map.get(index));
    }

    function testUnset(uint256 index) public {
        map.set(index);
        assertTrue(map.get(index));
        map.unset(index);
        assertFalse(map.get(index));
    }

    function testToggle(uint256 index) public {
        bool before = map.get(index);
        assertEq(map.toggle(index), !before);
        assertEq(map.get(index), !before);
        assertEq(map.toggle(index), before);
        assertEq(map.get(index), before);
    }

    function testSetTo(uint256 index, bool shouldSet) public {
        map.setTo(index, shouldSet);
        assertEq(map.get(index), shouldSet);
    }

    function testSetBatch() public {
        uint256 start=0;
        uint256 amount=10000;
        uint256 max = amount + start < 256 ? amount : 256 - (start & 0xff);
        map.setBatch(start, amount);
        for (uint256 i; i < max; ++i) {
            assertTrue(map.get(start + i));
        }
        if (amount + (start & 0xff) >= 256) {
            assertTrue(map.map[start >> 8] == type(uint256).max);
        }
    }

    function testUnsetBatch() public {
        uint256 start=0;
        uint256 amount=10000;
        map.setBatch(0, 256);
        uint256 max = amount + start < 256 ? amount : 256 - (start & 0xff);
        map.unsetBatch(start, amount);
        for (uint256 i; i < max; ++i) {
            assertFalse(map.get(start + i));
        }
        if (amount + (start & 0xff) >= 256) {
            assertTrue(map.map[start >> 8] == 0);
        }
    }

    function testPopCount() public {
        uint256 start=0;
        uint256 amount=10000;
        uint256 count;
        for (uint256 i; i < amount; ++i) {
            if (map.get(start + i)) {
                ++count;
            }
            map.toggle(start + i);
            if (map.get(start + i)) {
                ++count;
            }
        }
        assertEq(map.popCount(start, amount), count);
    }

    function testFindLastSet(uint256 n) public {
        n = n % 256;
        LibBitmap.Bitmap storage bitmap = map;
        uint256 expected = LibBitmap.NOT_FOUND;
        bitmap.set(n);
        for (uint256 i; i <= n; ++i) {
            if (bitmap.get(i)) {
                expected = i;
            }
        }
        assertEq(bitmap.findLastSet(n), expected);
    }

    function testFindLastSetBatch(uint256 n) public {
        n = n % 256;
        LibBitmap.Bitmap storage bitmap = map;
        uint256 expected = LibBitmap.NOT_FOUND;
        for (uint256 i; i <= n; ++i) {
            bitmap.set(i);
            expected = i;
        }
        assertEq(bitmap.findLastSet(n), expected);
    }

    function testFindLastSetNotFound() public {
        assertEq(map.findLastSet(255), LibBitmap.NOT_FOUND);
    }
}
