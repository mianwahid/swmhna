// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";
contract LibBitmapTest is Test {
    LibBitmap.Bitmap testBitmap;

    function testGetSet() public {
        // Zero index
        assertFalse(LibBitmap.get(testBitmap, 0), "Index 0 should initialize false");
        LibBitmap.set(testBitmap, 0);
        assertTrue(LibBitmap.get(testBitmap, 0), "Index 0 should be set");

        // Arbitrary index
        uint256 index = 12345;
        assertFalse(LibBitmap.get(testBitmap, index), "Arbitrary index should initialize false");
        LibBitmap.set(testBitmap, index);
        assertTrue(LibBitmap.get(testBitmap, index), "Arbitrary index should be set");
    }

    function testUnset() public {
        uint256 index = 5678;
        LibBitmap.set(testBitmap, index);
        assertTrue(LibBitmap.get(testBitmap, index), "Index should be set");

        LibBitmap.unset(testBitmap, index);
        assertFalse(LibBitmap.get(testBitmap, index), "Index should be unset");
    }

    function testToggle() public {
        uint256 index = 9012;
        assertFalse(LibBitmap.get(testBitmap, index), "Index should initialize false");

        assertTrue(LibBitmap.toggle(testBitmap, index), "Toggle should return true");
        assertTrue(LibBitmap.get(testBitmap, index), "Index should be set");

        assertFalse(LibBitmap.toggle(testBitmap, index), "Toggle should return false");
        assertFalse(LibBitmap.get(testBitmap, index), "Index should be unset");
    }

    function testSetTo() public {
        uint256 index = 3456;

        LibBitmap.setTo(testBitmap, index, true);
        assertTrue(LibBitmap.get(testBitmap, index), "setTo(true) should set the bit");

        LibBitmap.setTo(testBitmap, index, false);
        assertFalse(LibBitmap.get(testBitmap, index), "setTo(false) should unset the bit");
    }

    function testSetBatch() public {
        uint256 start = 7890;
        uint256 amount = 50;

        LibBitmap.setBatch(testBitmap, start, amount);
        for (uint256 i = start; i < start + amount; ++i) {
            assertTrue(LibBitmap.get(testBitmap, i), "Bits in batch should be set");
        }
    }

    function testUnsetBatch() public {
        uint256 start = 12345;
        uint256 amount = 25;

        LibBitmap.setBatch(testBitmap, start, amount);
        LibBitmap.unsetBatch(testBitmap, start, amount);

        for (uint256 i = start; i < start + amount; ++i) {
            assertFalse(LibBitmap.get(testBitmap, i), "Bits in batch should be unset");
        }
    }

    function testPopCount() public {
        uint256 start = 24680;
        uint256 amount = 100;

        // Test with all bits unset
        assertEq(LibBitmap.popCount(testBitmap, start, amount), 0, "Popcount should be 0");

        // Set every other bit
        for (uint256 i = start; i < start + amount; i += 2) {
            LibBitmap.set(testBitmap, i);
        }

        assertEq(LibBitmap.popCount(testBitmap, start, amount), amount / 2, "Popcount should be half of amount");
    }

    function testFindLastSet() public {
        assertEq(LibBitmap.findLastSet(testBitmap, 1000), LibBitmap.NOT_FOUND, "Should return NOT_FOUND for empty bitmap");

        LibBitmap.set(testBitmap, 555);
        assertEq(LibBitmap.findLastSet(testBitmap, 1000), 555, "Should find the last set bit");

        LibBitmap.set(testBitmap, 777);
        assertEq(LibBitmap.findLastSet(testBitmap, 1000), 777, "Should find the last set bit");

        // Test edge case with upTo at a bit boundary
        LibBitmap.unset(testBitmap, 777);
        assertEq(LibBitmap.findLastSet(testBitmap, 777), 555, "Should handle upTo at bit boundary");
    }

    function testEdgeCases() public {
        // Test setting and unsetting bits at the edges of uint256 boundaries
        uint256 boundary = 256;
        LibBitmap.set(testBitmap, boundary - 1);
        assertTrue(LibBitmap.get(testBitmap, boundary - 1), "Bit at boundary - 1 should be set");
        LibBitmap.unset(testBitmap, boundary - 1);
        assertFalse(LibBitmap.get(testBitmap, boundary - 1), "Bit at boundary - 1 should be unset");

        LibBitmap.set(testBitmap, boundary);
        assertTrue(LibBitmap.get(testBitmap, boundary), "Bit at boundary should be set");
        LibBitmap.unset(testBitmap, boundary);
        assertFalse(LibBitmap.get(testBitmap, boundary), "Bit at boundary should be unset");

        // Test setting and unsetting a large batch
        uint256 largeBatchStart = 1000;
        uint256 largeBatchAmount = 2000;
        LibBitmap.setBatch(testBitmap, largeBatchStart, largeBatchAmount);
        for (uint256 i = largeBatchStart; i < largeBatchStart + largeBatchAmount; ++i) {
            assertTrue(LibBitmap.get(testBitmap, i), "Bits in large batch should be set");
        }
        LibBitmap.unsetBatch(testBitmap, largeBatchStart, largeBatchAmount);
        for (uint256 i = largeBatchStart; i < largeBatchStart + largeBatchAmount; ++i) {
            assertFalse(LibBitmap.get(testBitmap, i), "Bits in large batch should be unset");
        }
    }

    function testFuzzGetSet(uint256 index) public {
        bool initialState = LibBitmap.get(testBitmap, index);
        LibBitmap.set(testBitmap, index);
        assertTrue(LibBitmap.get(testBitmap, index));
        LibBitmap.unset(testBitmap, index);
        assertEq(LibBitmap.get(testBitmap, index), initialState);
    }

    function testFuzzToggle(uint256 index) public {
        bool initialState = LibBitmap.get(testBitmap, index);
        LibBitmap.toggle(testBitmap, index);
        assertEq(LibBitmap.get(testBitmap, index), !initialState);
    }

//    function testFuzzSetTo(uint256 index, bool shouldSet) public {
//        LibBitmap.setTo(testBitmap, index, shouldSet);
//        assertEq(LibBitmap.get(testBitmap, index), shouldSet);
//    }

//    function testFuzzSetBatch(uint256 start, uint256 amount) public {
//        vm.assume(start < 2**256 - amount); // Ensure no overflow
//        LibBitmap.setBatch(testBitmap, start, amount);
//        for (uint256 i = start; i < start + amount; ++i) {
//            assertTrue(LibBitmap.get(testBitmap, i));
//        }
//    }
//
//    function testFuzzUnsetBatch(uint256 start, uint256 amount) public {
//        vm.assume(start < 2**256 - amount); // Ensure no overflow
//        LibBitmap.setBatch(testBitmap, start, amount);
//        LibBitmap.unsetBatch(testBitmap, start, amount);
//        for (uint256 i = start; i < start + amount; ++i) {
//            assertFalse(LibBitmap.get(testBitmap, i));
//        }
//    }

//    function testFuzzPopCount(uint256 start, uint256 amount) public {
//        vm.assume(start < 2**256 - amount); // Ensure no overflow
//        uint256 count = LibBitmap.popCount(testBitmap, start, amount);
//        assertTrue(count <= amount);
//    }

//    function testFuzzFindLastSet(uint256 upTo) public {
//        uint256 result = LibBitmap.findLastSet(testBitmap, upTo);
//        assertTrue(result == LibBitmap.NOT_FOUND || (result <= upTo));
//    }
}