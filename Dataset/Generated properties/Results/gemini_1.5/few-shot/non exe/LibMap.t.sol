// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import {LibMap} from "../src/utils/LibMap.sol";
import {LibBit} from "../src/utils/LibBit.sol";

contract LibMapTest is Test {
    using LibMap for *;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    LibMap.Uint8Map u8m;
    LibMap.Uint16Map u16m;
    LibMap.Uint32Map u32m;
    LibMap.Uint40Map u40m;
    LibMap.Uint64Map u64m;
    LibMap.Uint128Map u128m;

    mapping(uint256 => uint256) _m;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           HELPERS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _bound(uint256 x, uint256 min, uint256 max) internal pure returns (uint256 result) {
        require(min <= max, "Invalid bounds");
        if (x < min) return min;
        if (x > max) return max;
        return x;
    }

    function _checkGet(uint256 x, uint256 bitWidth) internal view {
        assertEq(_m.get(x, bitWidth), x);
    }

    function _checkSet(uint256 x, uint256 bitWidth) internal {
        _m.set(x, x, bitWidth);
        _checkGet(x, bitWidth);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           TESTS                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGet(uint256 x) public {
        x = _bound(x, 0, 255);
        assertEq(u8m.get(x), 0);
        u8m.set(x, uint8(x));
        assertEq(u8m.get(x), x);
    }

    function testSet(uint256 x) public {
        x = _bound(x, 0, 255);
        u8m.set(x, uint8(x));
        assertEq(u8m.get(x), x);
    }

    function testGet(uint256 x, uint256 y) public {
        x = _bound(x, 0, 65535);
        y = _bound(y, 0, 65535);
        assertEq(u16m.get(x), 0);
        u16m.set(x, uint16(x));
        u16m.set(y, uint16(y));
        assertEq(u16m.get(x), x);
        assertEq(u16m.get(y), y);
    }

    function testSet(uint256 x, uint256 y) public {
        x = _bound(x, 0, 65535);
        y = _bound(y, 0, 65535);
        u16m.set(x, uint16(x));
        u16m.set(y, uint16(y));
        assertEq(u16m.get(x), x);
        assertEq(u16m.get(y), y);
    }

    function testGet(uint256 x, uint256 y, uint256 z) public {
        x = _bound(x, 0, type(uint32).max);
        y = _bound(y, 0, type(uint32).max);
        z = _bound(z, 0, type(uint32).max);
        assertEq(u32m.get(x), 0);
        u32m.set(x, uint32(x));
        u32m.set(y, uint32(y));
        u32m.set(z, uint32(z));
        assertEq(u32m.get(x), x);
        assertEq(u32m.get(y), y);
        assertEq(u32m.get(z), z);
    }

    function testSet(uint256 x, uint256 y, uint256 z) public {
        x = _bound(x, 0, type(uint32).max);
        y = _bound(y, 0, type(uint32).max);
        z = _bound(z, 0, type(uint32).max);
        u32m.set(x, uint32(x));
        u32m.set(y, uint32(y));
        u32m.set(z, uint32(z));
        assertEq(u32m.get(x), x);
        assertEq(u32m.get(y), y);
        assertEq(u32m.get(z), z);
    }

    function testGet(uint256 x, uint256 y, uint256 z, uint256 a) public {
        x = _bound(x, 0, type(uint40).max);
        y = _bound(y, 0, type(uint40).max);
        z = _bound(z, 0, type(uint40).max);
        a = _bound(a, 0, type(uint40).max);
        assertEq(u40m.get(x), 0);
        u40m.set(x, uint40(x));
        u40m.set(y, uint40(y));
        u40m.set(z, uint40(z));
        u40m.set(a, uint40(a));
        assertEq(u40m.get(x), x);
        assertEq(u40m.get(y), y);
        assertEq(u40m.get(z), z);
        assertEq(u40m.get(a), a);
    }

    function testSet(uint256 x, uint256 y, uint256 z, uint256 a) public {
        x = _bound(x, 0, type(uint40).max);
        y = _bound(y, 0, type(uint40).max);
        z = _bound(z, 0, type(uint40).max);
        a = _bound(a, 0, type(uint40).max);
        u40m.set(x, uint40(x));
        u40m.set(y, uint40(y));
        u40m.set(z, uint40(z));
        u40m.set(a, uint40(a));
        assertEq(u40m.get(x), x);
        assertEq(u40m.get(y), y);
        assertEq(u40m.get(z), z);
        assertEq(u40m.get(a), a);
    }

    function testGet(uint256 x, uint256 y, uint256 z, uint256 a, uint256 b) public {
        x = _bound(x, 0, type(uint64).max);
        y = _bound(y, 0, type(uint64).max);
        z = _bound(z, 0, type(uint64).max);
        a = _bound(a, 0, type(uint64).max);
        b = _bound(b, 0, type(uint64).max);
        assertEq(u64m.get(x), 0);
        u64m.set(x, uint64(x));
        u64m.set(y, uint64(y));
        u64m.set(z, uint64(z));
        u64m.set(a, uint64(a));
        u64m.set(b, uint64(b));
        assertEq(u64m.get(x), x);
        assertEq(u64m.get(y), y);
        assertEq(u64m.get(z), z);
        assertEq(u64m.get(a), a);
        assertEq(u64m.get(b), b);
    }

    function testSet(uint256 x, uint256 y, uint256 z, uint256 a, uint256 b) public {
        x = _bound(x, 0, type(uint64).max);
        y = _bound(y, 0, type(uint64).max);
        z = _bound(z, 0, type(uint64).max);
        a = _bound(a, 0, type(uint64).max);
        b = _bound(b, 0, type(uint64).max);
        u64m.set(x, uint64(x));
        u64m.set(y, uint64(y));
        u64m.set(z, uint64(z));
        u64m.set(a, uint64(a));
        u64m.set(b, uint64(b));
        assertEq(u64m.get(x), x);
        assertEq(u64m.get(y), y);
        assertEq(u64m.get(z), z);
        assertEq(u64m.get(a), a);
        assertEq(u64m.get(b), b);
    }

    function testGet(uint256 x, uint256 y, uint256 z, uint256 a, uint256 b, uint256 c)
        public
    {
        x = _bound(x, 0, type(uint128).max);
        y = _bound(y, 0, type(uint128).max);
        z = _bound(z, 0, type(uint128).max);
        a = _bound(a, 0, type(uint128).max);
        b = _bound(b, 0, type(uint128).max);
        c = _bound(c, 0, type(uint128).max);
        assertEq(u128m.get(x), 0);
        u128m.set(x, uint128(x));
        u128m.set(y, uint128(y));
        u128m.set(z, uint128(z));
        u128m.set(a, uint128(a));
        u128m.set(b, uint128(b));
        u128m.set(c, uint128(c));
        assertEq(u128m.get(x), x);
        assertEq(u128m.get(y), y);
        assertEq(u128m.get(z), z);
        assertEq(u128m.get(a), a);
        assertEq(u128m.get(b), b);
        assertEq(u128m.get(c), c);
    }

    function testSet(uint256 x, uint256 y, uint256 z, uint256 a, uint256 b, uint256 c)
        public
    {
        x = _bound(x, 0, type(uint128).max);
        y = _bound(y, 0, type(uint128).max);
        z = _bound(z, 0, type(uint128).max);
        a = _bound(a, 0, type(uint128).max);
        b = _bound(b, 0, type(uint128).max);
        c = _bound(c, 0, type(uint128).max);
        u128m.set(x, uint128(x));
        u128m.set(y, uint128(y));
        u128m.set(z, uint128(z));
        u128m.set(a, uint128(a));
        u128m.set(b, uint128(b));
        u128m.set(c, uint128(c));
        assertEq(u128m.get(x), x);
        assertEq(u128m.get(y), y);
        assertEq(u128m.get(z), z);
        assertEq(u128m.get(a), a);
        assertEq(u128m.get(b), b);
        assertEq(u128m.get(c), c);
    }

    function testGet(uint256 x, uint256 bitWidth) public {
        unchecked {
            bitWidth = _bound(bitWidth, 1, 256);
            x = _bound(x, 0, (1 << bitWidth) - 1);
            _checkGet(x, bitWidth);
        }
    }

    function testSet(uint256 x, uint256 bitWidth) public {
        unchecked {
            bitWidth = _bound(bitWidth, 1, 256);
            x = _bound(x, 0, (1 << bitWidth) - 1);
            _checkSet(x, bitWidth);
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        FUZZ INVARIANTS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function invariantGetUint8Map(uint256 index, uint256 value) public {
        index = _bound(index, 0, 255);
        value = _bound(value, 0, 255);
        u8m.set(index, uint8(value));
        assertEq(u8m.get(index), value);
    }

    function invariantGetUint16Map(uint256 index, uint256 value) public {
        index = _bound(index, 0, 65535);
        value = _bound(value, 0, 65535);
        u16m.set(index, uint16(value));
        assertEq(u16m.get(index), value);
    }

    function invariantGetUint32Map(uint256 index, uint256 value) public {
        index = _bound(index, 0, type(uint32).max);
        value = _bound(value, 0, type(uint32).max);
        u32m.set(index, uint32(value));
        assertEq(u32m.get(index), value);
    }

    function invariantGetUint40Map(uint256 index, uint256 value) public {
        index = _bound(index, 0, type(uint40).max);
        value = _bound(value, 0, type(uint40).max);
        u40m.set(index, uint40(value));
        assertEq(u40m.get(index), value);
    }

    function invariantGetUint64Map(uint256 index, uint256 value) public {
        index = _bound(index, 0, type(uint64).max);
        value = _bound(value, 0, type(uint64).max);
        u64m.set(index, uint64(value));
        assertEq(u64m.get(index), value);
    }

    function invariantGetUint128Map(uint256 index, uint256 value) public {
        index = _bound(index, 0, type(uint128).max);
        value = _bound(value, 0, type(uint128).max);
        u128m.set(index, uint128(value));
        assertEq(u128m.get(index), value);
    }

    function invariantGet(uint256 index, uint256 value, uint256 bitWidth) public {
        unchecked {
            bitWidth = _bound(bitWidth, 1, 256);
            uint256 max = (1 << bitWidth) - 1;
            index = _bound(index, 0, max);
            value = _bound(value, 0, max);
            _m.set(index, value, bitWidth);
            assertEq(_m.get(index, bitWidth), value);
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       BINARY SEARCH                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function _searchSorted(
        function(uint256) internal view returns (uint256) get,
        function(uint256, uint256) internal view returns (bool, uint256) searchSorted,
        uint256 n,
        uint256 needle
    ) internal view {
        unchecked {
            uint256[] memory a = new uint256[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = get(i);
            }
            (bool found, uint256 index) = searchSorted(needle);
            if (found) {
                if (index >= n || a[index] != needle) {
                    console2.log("Found needle at wrong index.");
                    console2.log("Needle:", needle);
                    console2.log("Index:", index);
                    console2.log("Value at index:", a[index]);
                    assert(false);
                }
            } else {
                if (n == 0) return;
                if (needle <= a[0]) {
                    require(index == 0, "Needle too small.");
                } else if (needle >= a[n - 1]) {
                    require(index == n, "Needle too big.");
                } else {
                    require(needle > a[index], "Needle in between.");
                    require(index == 0 || needle <= a[index - 1], "Needle in between.");
                }
            }
        }
    }

    function _testSearchSortedUint8Map(uint256 n, uint256 needle) internal view {
        unchecked {
            delete u8m;
            n = _bound(n, 0, 256);
            needle = _bound(needle, 0, 255);
            uint8[] memory a = new uint8[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = uint8(i);
                u8m.set(i, a[i]);
            }
            _searchSorted(
                u8m.get,
                u8m.searchSorted,
                n,
                needle
            );
        }
    }

    function testSearchSortedUint8Map(uint256 n, uint256 needle) public {
        _testSearchSortedUint8Map(n, needle);
    }

    function testSearchSortedUint8MapSimple() public {
        _testSearchSortedUint8Map(3, 1);
    }

//    function invariantSearchSortedUint8Map(uint8 needle) public {
//        unchecked {
//            uint256 n = _bound(_random() % 257, 0, 256);
//            delete u8m;
//            for (uint256 i; i != n; ++i) {
//                u8m.set(i, uint8(i));
//            }
//            (bool found, uint256 index) = u8m.searchSorted(needle, 0, n);
//            if (found) {
//                assert(index < n);
//                assertEq(u8m.get(index), needle);
//            } else {
//                if (n == 0) return;
//                if (needle <= u8m.get(0)) {
//                    assertEq(index, 0);
//                } else if (needle >= u8m.get(n - 1)) {
//                    assertEq(index, n);
//                } else {
//                    assert(needle > u8m.get(index));
//                    assert(index == 0 || needle <= u8m.get(index - 1));
//                }
//            }
//        }
//    }

    function _testSearchSortedUint16Map(uint256 n, uint256 needle) internal view {
        unchecked {
            delete u16m;
            n = _bound(n, 0, 256);
            needle = _bound(needle, 0, 65535);
            uint16[] memory a = new uint16[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = uint16(i * 257);
                u16m.set(i, a[i]);
            }
            _searchSorted(
                u16m.get,
                u16m.searchSorted,
                n,
                needle
            );
        }
    }

    function testSearchSortedUint16Map(uint256 n, uint256 needle) public {
        _testSearchSortedUint16Map(n, needle);
    }

    function testSearchSortedUint16MapSimple() public {
        _testSearchSortedUint16Map(3, 1);
    }

//    function invariantSearchSortedUint16Map(uint16 needle) public {
//        unchecked {
//            uint256 n = _bound(_random() % 257, 0, 256);
//            delete u16m;
//            for (uint256 i; i != n; ++i) {
//                u16m.set(i, uint16(i * 257));
//            }
//            (bool found, uint256 index) = u16m.searchSorted(needle, 0, n);
//            if (found) {
//                assert(index < n);
//                assertEq(u16m.get(index), needle);
//            } else {
//                if (n == 0) return;
//                if (needle <= u16m.get(0)) {
//                    assertEq(index, 0);
//                } else if (needle >= u16m.get(n - 1)) {
//                    assertEq(index, n);
//                } else {
//                    assert(needle > u16m.get(index));
//                    assert(index == 0 || needle <= u16m.get(index - 1));
//                }
//            }
//        }
//    }

    function _testSearchSortedUint32Map(uint256 n, uint256 needle) internal view {
        unchecked {
            delete u32m;
            n = _bound(n, 0, 256);
            needle = _bound(needle, 0, type(uint32).max);
            uint32[] memory a = new uint32[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = uint32(i * 65537);
                u32m.set(i, a[i]);
            }
            _searchSorted(
                u32m.get,
                u32m.searchSorted,
                n,
                needle
            );
        }
    }

    function testSearchSortedUint32Map(uint256 n, uint256 needle) public {
        _testSearchSortedUint32Map(n, needle);
    }

    function testSearchSortedUint32MapSimple() public {
        _testSearchSortedUint32Map(3, 1);
    }

//    function invariantSearchSortedUint32Map(uint32 needle) public {
//        unchecked {
//            uint256 n = _bound(_random() % 257, 0, 256);
//            delete u32m;
//            for (uint256 i; i != n; ++i) {
//                u32m.set(i, uint32(i * 65537));
//            }
//            (bool found, uint256 index) = u32m.searchSorted(needle, 0, n);
//            if (found) {
//                assert(index < n);
//                assertEq(u32m.get(index), needle);
//            } else {
//                if (n == 0) return;
//                if (needle <= u32m.get(0)) {
//                    assertEq(index, 0);
//                } else if (needle >= u32m.get(n - 1)) {
//                    assertEq(index, n);
//                } else {
//                    assert(needle > u32m.get(index));
//                    assert(index == 0 || needle <= u32m.get(index - 1));
//                }
//            }
//        }
//    }

    function _testSearchSortedUint40Map(uint256 n, uint256 needle) internal view {
        unchecked {
            delete u40m;
            n = _bound(n, 0, 256);
            needle = _bound(needle, 0, type(uint40).max);
            uint40[] memory a = new uint40[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = uint40(i * 16_777_217);
                u40m.set(i, a[i]);
            }
            _searchSorted(
                u40m.get,
                u40m.searchSorted,
                n,
                needle
            );
        }
    }

    function testSearchSortedUint40Map(uint256 n, uint256 needle) public {
        _testSearchSortedUint40Map(n, needle);
    }

    function testSearchSortedUint40MapSimple() public {
        _testSearchSortedUint40Map(3, 1);
    }

//    function invariantSearchSortedUint40Map(uint40 needle) public {
//        unchecked {
//            uint256 n = _bound(_random() % 257, 0, 256);
//            delete u40m;
//            for (uint256 i; i != n; ++i) {
//                u40m.set(i, uint40(i * 16_777_217));
//            }
//            (bool found, uint256 index) = u40m.searchSorted(needle, 0, n);
//            if (found) {
//                assert(index < n);
//                assertEq(u40m.get(index), needle);
//            } else {
//                if (n == 0) return;
//                if (needle <= u40m.get(0)) {
//                    assertEq(index, 0);
//                } else if (needle >= u40m.get(n - 1)) {
//                    assertEq(index, n);
//                } else {
//                    assert(needle > u40m.get(index));
//                    assert(index == 0 || needle <= u40m.get(index - 1));
//                }
//            }
//        }
//    }

    function _testSearchSortedUint64Map(uint256 n, uint256 needle) internal view {
        unchecked {
            delete u64m;
            n = _bound(n, 0, 256);
            needle = _bound(needle, 0, type(uint64).max);
            uint64[] memory a = new uint64[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = uint64(i) * 4_294_967_297;
                u64m.set(i, a[i]);
            }
            _searchSorted(
                u64m.get,
                u64m.searchSorted,
                n,
                needle
            );
        }
    }

    function testSearchSortedUint64Map(uint256 n, uint256 needle) public {
        _testSearchSortedUint64Map(n, needle);
    }

    function testSearchSortedUint64MapSimple() public {
        _testSearchSortedUint64Map(3, 1);
    }

//    function invariantSearchSortedUint64Map(uint64 needle) public {
//        unchecked {
//            uint256 n = _bound(_random() % 257, 0, 256);
//            delete u64m;
//            for (uint256 i; i != n; ++i) {
//                u64m.set(i, uint64(i) * 4_294_967_297);
//            }
//            (bool found, uint256 index) = u64m.searchSorted(needle, 0, n);
//            if (found) {
//                assert(index < n);
//                assertEq(u64m.get(index), needle);
//            } else {
//                if (n == 0) return;
//                if (needle <= u64m.get(0)) {
//                    assertEq(index, 0);
//                } else if (needle >= u64m.get(n - 1)) {
//                    assertEq(index, n);
//                } else {
//                    assert(needle > u64m.get(index));
//                    assert(index == 0 || needle <= u64m.get(index - 1));
//                }
//            }
//        }
//    }

    function _testSearchSortedUint128Map(uint256 n, uint256 needle) internal view {
        unchecked {
            delete u128m;
            n = _bound(n, 0, 256);
            needle = _bound(needle, 0, type(uint128).max);
            uint128[] memory a = new uint128[](n);
            for (uint256 i; i != n; ++i) {
                a[i] = uint128(i) * 18_446_744_073_709_551_617;
                u128m.set(i, a[i]);
            }
            _searchSorted(
                u128m.get,
                u128m,
                n,
                needle
            );
        }
    }

    function testSearchSortedUint128Map(uint256 n, uint256 needle) public {
        _testSearchSortedUint128Map(n, needle);
    }

    function testSearchSortedUint128MapSimple() public {
        _testSearchSortedUint128Map(3, 1);
    }

}