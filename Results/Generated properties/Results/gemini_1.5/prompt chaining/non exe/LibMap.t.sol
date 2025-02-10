// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibMap.sol";
contract LibMapTest is Test {
    using LibMap for LibMap.Uint8Map;
    using LibMap for LibMap.Uint16Map;
    using LibMap for LibMap.Uint32Map;
    using LibMap for LibMap.Uint40Map;
    using LibMap for LibMap.Uint64Map;
    using LibMap for LibMap.Uint128Map;
    using LibMap for mapping(uint256 => uint256);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 internal constant MAX_UINT8 = 2**8 - 1;
    uint256 internal constant MAX_UINT16 = 2**16 - 1;
    uint256 internal constant MAX_UINT32 = 2**32 - 1;
    uint256 internal constant MAX_UINT40 = 2**40 - 1;
    uint256 internal constant MAX_UINT64 = 2**64 - 1;
    uint256 internal constant MAX_UINT128 = 2**128 - 1;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        TEST STRUCTS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    struct Uint8Map {
        mapping(uint256 => uint256) map;
    }

    struct Uint16Map {
        mapping(uint256 => uint256) map;
    }

    struct Uint32Map {
        mapping(uint256 => uint256) map;
    }

    struct Uint40Map {
        mapping(uint256 => uint256) map;
    }

    struct Uint64Map {
        mapping(uint256 => uint256) map;
    }

    struct Uint128Map {
        mapping(uint256 => uint256) map;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           TESTS                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testUint8Map_ZeroInitialization() public {
        LibMap.Uint8Map storage map;
        for (uint256 i; i < 32; ++i) {
            assertEq(map.get(i), 0);
        }
    }

    function testUint16Map_ZeroInitialization() public {
        LibMap.Uint16Map storage map;
        for (uint256 i; i < 16; ++i) {
            assertEq(map.get(i), 0);
        }
    }

    function testUint32Map_ZeroInitialization() public {
        LibMap.Uint32Map storage map;
        for (uint256 i; i < 8; ++i) {
            assertEq(map.get(i), 0);
        }
    }

    function testUint40Map_ZeroInitialization() public {
        LibMap.Uint40Map storage map;
        for (uint256 i; i < 6; ++i) {
            assertEq(map.get(i), 0);
        }
    }

    function testUint64Map_ZeroInitialization() public {
        LibMap.Uint64Map storage map;
        for (uint256 i; i < 4; ++i) {
            assertEq(map.get(i), 0);
        }
    }

    function testUint128Map_ZeroInitialization() public {
        LibMap.Uint128Map storage map;
        for (uint256 i; i < 2; ++i) {
            assertEq(map.get(i), 0);
        }
    }

    function testUint8Map_OutOfBounds() public {
        LibMap.Uint8Map storage map;
        vm.expectRevert();
        map.get(32);
    }

    function testUint16Map_OutOfBounds() public {
        LibMap.Uint16Map storage map;
        vm.expectRevert();
        map.get(16);
    }

    function testUint32Map_OutOfBounds() public {
        LibMap.Uint32Map storage map;
        vm.expectRevert();
        map.get(8);
    }

    function testUint40Map_OutOfBounds() public {
        LibMap.Uint40Map storage map;
        vm.expectRevert();
        map.get(6);
    }

    function testUint64Map_OutOfBounds() public {
        LibMap.Uint64Map storage map;
        vm.expectRevert();
        map.get(4);
    }

    function testUint128Map_OutOfBounds() public {
        LibMap.Uint128Map storage map;
        vm.expectRevert();
        map.get(2);
    }

    function testUint8Map_SingleValueSetGet() public {
        LibMap.Uint8Map storage map;
        for (uint256 i = 0; i < 256; ++i) {
            map.set(0, uint8(i));
            assertEq(map.get(0), i);
        }
    }

    function testUint8Map_MultipleValueSetGet() public {
        LibMap.Uint8Map storage map;
        for (uint256 i = 0; i < 32; ++i) {
            map.set(i, uint8(i * 10));
        }
        for (uint256 i = 0; i < 32; ++i) {
            assertEq(map.get(i), i * 10);
        }
    }

//    function testUint8Map_OverwritingValues() public {
//        LibMap.Uint8Map storage map;
//        map.set(0, 10);
//        assertEq(map.get(0), 10);
//        map.set(0, 20);
//        assertEq(map.get(0), 20);
//    }
//
//    function testUint16Map_ValueRange() public {
//        LibMap.Uint16Map storage map;
//        for (uint256 i = 0; i < 10; ++i) {
//            uint256 value = bound(i, 0, MAX_UINT16);
//            map.set(i, uint16(value));
//            assertEq(map.get(i), value);
//        }
//    }
//
//    function testUint32Map_ValueRange() public {
//        LibMap.Uint32Map storage map;
//        for (uint256 i = 0; i < 10; ++i) {
//            uint256 value = bound(i, 0, MAX_UINT32);
//            map.set(i, uint32(value));
//            assertEq(map.get(i), value);
//        }
//    }
//
//    function testUint40Map_ValueRange() public {
//        LibMap.Uint40Map storage map;
//        for (uint256 i = 0; i < 10; ++i) {
//            uint256 value = bound(i, 0, MAX_UINT40);
//            map.set(i, uint40(value));
//            assertEq(map.get(i), value);
//        }
//    }
//
//    function testUint64Map_ValueRange() public {
//        LibMap.Uint64Map storage map;
//        for (uint256 i = 0; i < 10; ++i) {
//            uint256 value = bound(i, 0, MAX_UINT64);
//            map.set(i, uint64(value));
//            assertEq(map.get(i), value);
//        }
//    }
//
//    function testUint128Map_ValueRange() public {
//        LibMap.Uint128Map storage map;
//        for (uint256 i = 0; i < 10; ++i) {
//            uint256 value = bound(i, 0, MAX_UINT128);
//            map.set(i, uint128(value));
//            assertEq(map.get(i), value);
//        }
//    }
//
//    function testUint16Map_BoundaryAlignment() public {
//        LibMap.Uint16Map storage map;
//        map.set(1, 0x1234);
//        assertEq(map.get(0), 0);
//        assertEq(map.get(1), 0x1234);
//        assertEq(map.get(2), 0);
//    }
//
//    function testUint32Map_BoundaryAlignment() public {
//        LibMap.Uint32Map storage map;
//        map.set(1, 0x12345678);
//        assertEq(map.get(0), 0);
//        assertEq(map.get(1), 0x12345678);
//        assertEq(map.get(2), 0);
//    }
//
//    function testUint40Map_BoundaryAlignment() public {
//        LibMap.Uint40Map storage map;
//        map.set(1, 0x1234567890);
//        assertEq(map.get(0), 0);
//        assertEq(map.get(1), 0x1234567890);
//        assertEq(map.get(2), 0);
//    }
//
//    function testUint64Map_BoundaryAlignment() public {
//        LibMap.Uint64Map storage map;
//        map.set(1, 0x1234567890abcdef);
//        assertEq(map.get(0), 0);
//        assertEq(map.get(1), 0x1234567890abcdef);
//        assertEq(map.get(2), 0);
//    }
//
//    function testUint128Map_BoundaryAlignment() public {
//        LibMap.Uint128Map storage map;
//        map.set(
//            1,
//            0x1234567890abcdef1234567890abcdef
//        );
//        assertEq(map.get(0), 0);
//        assertEq(
//            map.get(1),
//            0x1234567890abcdef1234567890abcdef
//        );
//        assertEq(map.get(2), 0);
//    }

//    function testGeneric_ArbitraryBitWidth() public {
//        mapping(uint256 => uint256) storage map;
//        map.set(0, 0x12345678, 32);
//        assertEq(map.get(0, 32), 0x12345678);
//        map.set(1, 0xabcdef, 20);
//        assertEq(map.get(1, 20), 0xabcdef);
//        map.set(10, 0x1, 1);
//        assertEq(map.get(10, 1), 0x1);
//    }

//    function testGeneric_ValueMasking() public {
//        mapping(uint256 => uint256) storage map;
//        map.set(0, 0x12345678, 32);
//        assertEq(map.get(0, 16), 0x5678);
//        assertEq(map.get(0, 8), 0x78);
//    }

//    function testSearchSorted_EmptyRange() public {
//        LibMap.Uint8Map storage map;
//        (bool found, uint256 index) = map.searchSorted(100, 10, 10);
//        assertFalse(found);
//        assertEq(index, 10);
//    }

//    function testSearchSorted_SingleElementRange() public {
//        LibMap.Uint8Map storage map;
//        map.set(0, 50);
//        (bool found, uint256 index) = map.searchSorted(40, 0, 1);
//        assertFalse(found);
//        assertEq(index, 0);
//        (found, index) = map.searchSorted(50, 0, 1);
//        assertTrue(found);
//        assertEq(index, 0);
//        (found, index) = map.searchSorted(60, 0, 1);
//        assertFalse(found);
//        assertEq(index, 0);
//    }
//
//    function testSearchSorted_NeedleFound() public {
//        LibMap.Uint8Map storage map;
//        map.set(0, 10);
//        map.set(1, 20);
//        map.set(2, 30);
//        (bool found, uint256 index) = map.searchSorted(20, 0, 3);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testSearchSorted_NeedleNotFound_NearestBefore() public {
//        LibMap.Uint8Map storage map;
//        map.set(0, 10);
//        map.set(1, 20);
//        map.set(2, 30);
//        (bool found, uint256 index) = map.searchSorted(15, 0, 3);
//        assertFalse(found);
//        assertEq(index, 0);
//    }
//
//    function testSearchSorted_NeedleNotFound_NearestAfter() public {
//        LibMap.Uint8Map storage map;
//        map.set(0, 10);
//        map.set(1, 20);
//        map.set(2, 30);
//        (bool found, uint256 index) = map.searchSorted(35, 0, 3);
//        assertFalse(found);
//        assertEq(index, 2);
//    }


//    function testSearchSorted_DuplicateValues() public {
//        LibMap.Uint8Map storage map;
//        map.set(0, 10);
//        map.set(1, 20);
//        map.set(2, 20);
//        map.set(3, 30);
//        (bool found, uint256 index) = map.searchSorted(20, 0, 4);
//        assertTrue(found);
//        assertEq(index, 1);
//    }
//
//    function testEdgeCase_MaximumIndex() public {
//        LibMap.Uint8Map storage map1;
//        map1.set(31, 255);
//        assertEq(map1.get(31), 255);
//
//        LibMap.Uint16Map storage map2;
//        map2.set(15, 65535);
//        assertEq(map2.get(15), 65535);
//
//        LibMap.Uint32Map storage map3;
//        map3.set(7, 4294967295);
//        assertEq(map3.get(7), 4294967295);
//
//        LibMap.Uint40Map storage map4;
//        map4.set(5, 1099511627775);
//        assertEq(map4.get(5), 1099511627775);
//
//        LibMap.Uint64Map storage map5;
//        map5.set(3, 18446744073709551615);
//        assertEq(map5.get(3), 18446744073709551615);
//
//        LibMap.Uint128Map storage map6;
//        map6.set(1, 340282366920938463463374607431768211455);
//        assertEq(map6.get(1), 340282366920938463463374607431768211455);
//    }

//    function testEdgeCase_ZeroBitWidth() public {
//        mapping(uint256 => uint256) storage map;
//        vm.expectRevert();
//        map.set(0, 100, 0);
//        vm.expectRevert();
//        map.get(0, 0);
//    }

//    function testEdgeCase_OverflowingValues() public {
//        LibMap.Uint8Map storage map1;
//        vm.expectRevert();
//        map1.set(0, 255);
//
//        LibMap.Uint16Map storage map2;
//        vm.expectRevert();
//        map2.set(0, 65535);
//
//        LibMap.Uint32Map storage map3;
//        vm.expectRevert();
//        map3.set(0, 4294967295);
//
//        LibMap.Uint40Map storage map4;
//        vm.expectRevert();
//        map4.set(0, 1099511627775);
//
//        LibMap.Uint64Map storage map5;
//        vm.expectRevert();
//        map5.set(0, 18446744073709551615);
//
//        LibMap.Uint128Map storage map6;
//        vm.expectRevert();
//        map6.set(0, 340282366920938463463374607431768211455);
//    }
}
