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
    /*                         UINT8 MAP                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetUint8Map(uint256 index, uint8 value) public {
        LibMap.Uint8Map storage map;
        map.set(index, value);
        assertEq(map.get(index), value);
    }

    function testSearchSortedUint8Map(uint8[] memory values) public {
        uint256 length = values.length;
        LibMap.Uint8Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedUint8Map(uint8[8] memory input) public {
        uint8[8] memory values = input;
        uint256 length = values.length;
        LibMap.Uint8Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         UINT16 MAP                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetUint16Map(uint256 index, uint16 value) public {
        LibMap.Uint16Map storage map;
        map.set(index, value);
        assertEq(map.get(index), value);
    }

    function testSearchSortedUint16Map(uint16[] memory values) public {
        uint256 length = values.length;
        LibMap.Uint16Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedUint16Map(uint16[8] memory input) public {
        uint16[8] memory values = input;
        uint256 length = values.length;
        LibMap.Uint16Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         UINT32 MAP                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetUint32Map(uint256 index, uint32 value) public {
        LibMap.Uint32Map storage map;
        map.set(index, value);
        assertEq(map.get(index), value);
    }

    function testSearchSortedUint32Map(uint32[] memory values) public {
        uint256 length = values.length;
        LibMap.Uint32Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedUint32Map(uint32[8] memory input) public {
        uint32[8] memory values = input;
        uint256 length = values.length;
        LibMap.Uint32Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         UINT40 MAP                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetUint40Map(uint256 index, uint40 value) public {
        LibMap.Uint40Map storage map;
        map.set(index, value);
        assertEq(map.get(index), value);
    }

    function testSearchSortedUint40Map(uint40[] memory values) public {
        uint256 length = values.length;
        LibMap.Uint40Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedUint40Map(uint40[8] memory input) public {
        uint40[8] memory values = input;
        uint256 length = values.length;
        LibMap.Uint40Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         UINT64 MAP                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetUint64Map(uint256 index, uint64 value) public {
        LibMap.Uint64Map storage map;
        map.set(index, value);
        assertEq(map.get(index), value);
    }

    function testSearchSortedUint64Map(uint64[] memory values) public {
        uint256 length = values.length;
        LibMap.Uint64Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedUint64Map(uint64[8] memory input) public {
        uint64[8] memory values = input;
        uint256 length = values.length;
        LibMap.Uint64Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        UINT128 MAP                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetUint128Map(uint256 index, uint128 value) public {
        LibMap.Uint128Map storage map;
        map.set(index, value);
        assertEq(map.get(index), value);
    }

    function testSearchSortedUint128Map(uint128[] memory values) public {
        uint256 length = values.length;
        LibMap.Uint128Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedUint128Map(uint128[8] memory input) public {
        uint128[8] memory values = input;
        uint256 length = values.length;
        LibMap.Uint128Map storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i]);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          GENERIC                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testGetSetGeneric(
        uint256 index,
        uint256 value,
        uint256 bitWidth
    ) public {
        mapping(uint256 => uint256) storage map;
        map.set(index, value, bitWidth);
        assertEq(map.get(index, bitWidth), value);
    }

    function testSearchSortedGeneric(uint256[] memory values, uint256 bitWidth)
        public
    {
        require(bitWidth != 0 && bitWidth <= 256);
        uint256 length = values.length;
        mapping(uint256 => uint256) storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i], bitWidth);
        }
        for (uint256 i; i <= length; ++i) {
            (bool found, uint256 index) = map.searchSorted(i, 0, length, bitWidth);
            assertEq(found, i < length && values[i] == i);
            assertEq(index, i);
        }
    }

    function testFuzzSearchSortedGeneric(
        uint256[8] memory input,
        uint256 bitWidth
    ) public {
        require(bitWidth != 0 && bitWidth <= 256);
        uint256[8] memory values = input;
        uint256 length = values.length;
        mapping(uint256 => uint256) storage map;
        for (uint256 i; i < length; ++i) {
            map.set(i, values[i], bitWidth);
        }
        for (uint256 i = length; i != 0; i >>= 1) {
            for (uint256 j; j < length - i; ++j) {
                if (values[j] > values[j + i]) {
                    (values[j], values[j + i]) = (values[j + i], values[j]);
                }
            }
        }
        uint256 needle = input[0];
        (bool found, uint256 index) = map.searchSorted(needle, 0, length, bitWidth);
        uint256 expectedIndex;
        for (uint256 i; i < length; ++i) {
            if (values[i] >= needle) {
                expectedIndex = i;
                break;
            }
        }
        assertEq(found, expectedIndex < length && values[expectedIndex] == needle);
        assertEq(index, expectedIndex);
    }
}