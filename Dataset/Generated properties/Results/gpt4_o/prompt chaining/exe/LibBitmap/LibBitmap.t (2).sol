// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibBitmap.sol";
import "../src/utils/LibBit.sol";

contract LibBitmapTest is Test {
    using LibBitmap for LibBitmap.Bitmap;

    LibBitmap.Bitmap bitmap;

    function testGet() public {
        assert(!bitmap.get(0)); // Never set
        bitmap.set(0);
        assert(bitmap.get(0)); // Set
        bitmap.unset(0);
        assert(!bitmap.get(0)); // Unset
    }

    function testSet() public {
        bitmap.set(1);
        assert(bitmap.get(1)); // Set
        bitmap.set(1);
        assert(bitmap.get(1)); // Already set
    }

    function testUnset() public {
        bitmap.unset(2);
        assert(!bitmap.get(2)); // Already unset
        bitmap.set(2);
        bitmap.unset(2);
        assert(!bitmap.get(2)); // Unset
    }

    function testToggle() public {
        bool newIsSet = bitmap.toggle(3);
        assert(newIsSet == true); // Toggled to true
        newIsSet = bitmap.toggle(3);
        assert(newIsSet == false); // Toggled back to false
    }

    function testSetTo() public {
        bitmap.setTo(4, true);
        assert(bitmap.get(4)); // Set to true
        bitmap.setTo(4, false);
        assert(!bitmap.get(4)); // Set to false
        bitmap.setTo(4, false);
        assert(!bitmap.get(4)); // Already false
    }

    function testSetBatch() public {
        bitmap.setBatch(5, 10);
        for (uint256 i = 5; i < 15; i++) {
            assert(bitmap.get(i)); // All set to true
        }
        bitmap.setBatch(255, 10);
        for (uint256 i = 255; i < 265; i++) {
            assert(bitmap.get(i)); // All set to true
        }
    }

    function testUnsetBatch() public {
        bitmap.setBatch(6, 10);
        bitmap.unsetBatch(6, 10);
        for (uint256 i = 6; i < 16; i++) {
            assert(!bitmap.get(i)); // All unset to false
        }
        bitmap.setBatch(255, 10);
        bitmap.unsetBatch(255, 10);
        for (uint256 i = 255; i < 265; i++) {
            assert(!bitmap.get(i)); // All unset to false
        }
    }

    function testPopCount() public {
        bitmap.setBatch(7, 10);
        assert(bitmap.popCount(7, 10) == 10); // 10 bits set
        bitmap.setBatch(255, 10);
        assert(bitmap.popCount(255, 10) == 10); // 10 bits set
    }

    function testFindLastSet() public {
        assert(bitmap.findLastSet(100) == LibBitmap.NOT_FOUND); // No set bit
        bitmap.set(50);
        assert(bitmap.findLastSet(100) == 50); // Last set bit at 50
        bitmap.set(75);
        assert(bitmap.findLastSet(100) == 75); // Last set bit at 75
    }
}

contract LibBitTest is Test {
    function testFls() public {
        assert(LibBit.fls(0) == 256); // No set bit
        assert(LibBit.fls(1) == 0); // Last set bit at 0
        assert(LibBit.fls(2) == 1); // Last set bit at 1
        assert(LibBit.fls(3) == 1); // Last set bit at 1
    }

    function testClz() public {
        assert(LibBit.clz(0) == 256); // All zeros
        assert(LibBit.clz(1) == 255); // 255 leading zeros
        assert(LibBit.clz(2) == 254); // 254 leading zeros
        assert(LibBit.clz(3) == 254); // 254 leading zeros
    }

    function testFfs() public {
        assert(LibBit.ffs(0) == 256); // No set bit
        assert(LibBit.ffs(1) == 0); // First set bit at 0
        assert(LibBit.ffs(2) == 1); // First set bit at 1
        assert(LibBit.ffs(3) == 0); // First set bit at 0
    }

    function testPopCount() public {
        assert(LibBit.popCount(0) == 0); // No set bits
        assert(LibBit.popCount(1) == 1); // 1 set bit
        assert(LibBit.popCount(3) == 2); // 2 set bits
        assert(LibBit.popCount(255) == 8); // 8 set bits
    }

    function testIsPo2() public {
        assert(!LibBit.isPo2(0)); // Not a power of 2
        assert(LibBit.isPo2(1)); // Power of 2
        assert(LibBit.isPo2(2)); // Power of 2
        assert(!LibBit.isPo2(3)); // Not a power of 2
    }

    function testReverseBits() public {
        assert(LibBit.reverseBits(0) == 0); // All zeros
        assert(LibBit.reverseBits(1) == 2**255); // Reversed 1
        assert(LibBit.reverseBits(2**255) == 1); // Reversed 2**255
        assert(LibBit.reverseBits(type(uint256).max) == type(uint256).max); // All bits set
    }

    function testReverseBytes() public {
        assert(LibBit.reverseBytes(0) == 0); // All zeros
        assert(LibBit.reverseBytes(1) == 2**248); // Reversed 1
        assert(LibBit.reverseBytes(2**248) == 1); // Reversed 2**248
        assert(LibBit.reverseBytes(type(uint256).max) == type(uint256).max); // All bytes set
    }

    function testRawAnd() public {
        assert(!LibBit.rawAnd(false, false)); // false & false
        assert(!LibBit.rawAnd(false, true)); // false & true
        assert(!LibBit.rawAnd(true, false)); // true & false
        assert(LibBit.rawAnd(true, true)); // true & true
    }

    function testAnd() public {
        assert(!LibBit.and(false, false)); // false & false
        assert(!LibBit.and(false, true)); // false & true
        assert(!LibBit.and(true, false)); // true & false
        assert(LibBit.and(true, true)); // true & true
    }

    function testRawOr() public {
        assert(!LibBit.rawOr(false, false)); // false | false
        assert(LibBit.rawOr(false, true)); // false | true
        assert(LibBit.rawOr(true, false)); // true | false
        assert(LibBit.rawOr(true, true)); // true | true
    }

    function testOr() public {
        assert(!LibBit.or(false, false)); // false | false
        assert(LibBit.or(false, true)); // false | true
        assert(LibBit.or(true, false)); // true | false
        assert(LibBit.or(true, true)); // true | true
    }

    function testRawToUint() public {
        assert(LibBit.rawToUint(false) == 0); // false to uint
        assert(LibBit.rawToUint(true) == 1); // true to uint
    }

    function testToUint() public {
        assert(LibBit.toUint(false) == 0); // false to uint
        assert(LibBit.toUint(true) == 1); // true to uint
    }
}