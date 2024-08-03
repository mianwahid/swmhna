// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/EnumerableSetLib.sol";

contract EnumerableSetLibTest is Test {
    using EnumerableSetLib for EnumerableSetLib.AddressSet;
    using EnumerableSetLib for EnumerableSetLib.Bytes32Set;
    using EnumerableSetLib for EnumerableSetLib.Uint256Set;
    using EnumerableSetLib for EnumerableSetLib.Int256Set;

    EnumerableSetLib.AddressSet private addressSet;
    EnumerableSetLib.Bytes32Set private bytes32Set;
    EnumerableSetLib.Uint256Set private uint256Set;
    EnumerableSetLib.Int256Set private int256Set;

    address private constant _ZERO_SENTINEL = address(0xfbb67fda52d4bfb8bf);

    // Invariants for `length` Function
    function testLengthEmptySet() public {
        assert(addressSet.length() == 0);
    }

    function testLengthSingleElement() public {
        address value = address(0x1);
        addressSet.add(value);
        assert(addressSet.length() == 1);
    }

    function testLengthMultipleElements() public {
        address value1 = address(0x1);
        address value2 = address(0x2);
        addressSet.add(value1);
        addressSet.add(value2);
        assert(addressSet.length() == 2);
    }

    function testLengthDuplicateElements() public {
        address value = address(0x1);
        addressSet.add(value);
        addressSet.add(value);
        assert(addressSet.length() == 1);
    }

    function testLengthRemoveElements() public {
        address value = address(0x1);
        addressSet.add(value);
        addressSet.remove(value);
        assert(addressSet.length() == 0);
    }

    // Invariants for `contains` Function
    function testContainsEmptySet() public {
        address value = address(0x1);
        assert(!addressSet.contains(value));
    }

    function testContainsSingleElement() public {
        address value = address(0x1);
        addressSet.add(value);
        assert(addressSet.contains(value));
    }

    function testContainsMultipleElements() public {
        address value1 = address(0x1);
        address value2 = address(0x2);
        addressSet.add(value1);
        addressSet.add(value2);
        assert(addressSet.contains(value1));
        assert(addressSet.contains(value2));
    }

    function testContainsNonExistentElement() public {
        address value1 = address(0x1);
        address value2 = address(0x2);
        addressSet.add(value1);
        assert(!addressSet.contains(value2));
    }

    function testContainsRemoveElement() public {
        address value = address(0x1);
        addressSet.add(value);
        addressSet.remove(value);
        assert(!addressSet.contains(value));
    }

    // Invariants for `add` Function
    function testAddElement() public {
        address value = address(0x1);
        assert(addressSet.add(value) == true);
    }

    function testAddDuplicate() public {
        address value = address(0x1);
        addressSet.add(value);
        assert(addressSet.add(value) == false);
    }

//    function testAddZeroSentinel() public {
//        try addressSet.add(_ZERO_SENTINEL) {
//            assert(false);
//        } catch {
//            assert(true);
//        }
//    }

    // Invariants for `remove` Function
    function testRemoveElement() public {
        address value = address(0x1);
        addressSet.add(value);
        assert(addressSet.remove(value) == true);
    }

    function testRemoveNonExistentElement() public {
        address value = address(0x1);
        assert(addressSet.remove(value) == false);
    }

//    function testRemoveZeroSentinel() public {
//        try addressSet.remove(_ZERO_SENTINEL) {
//            assert(false);
//        } catch {
//            assert(true);
//        }
//    }

    // Invariants for `values` Function
    function testValuesEmptySet() public {
        assert(addressSet.values().length == 0);
    }

    function testValuesSingleElement() public {
        address value = address(0x1);
        addressSet.add(value);
        address[] memory vals = addressSet.values();
        assert(vals.length == 1);
        assert(vals[0] == value);
    }

    function testValuesMultipleElements() public {
        address value1 = address(0x1);
        address value2 = address(0x2);
        addressSet.add(value1);
        addressSet.add(value2);
        address[] memory vals = addressSet.values();
        assert(vals.length == 2);
        assert(vals[0] == value1 || vals[1] == value1);
    }

    function testValuesRemoveElement() public {
        address value = address(0x1);
        addressSet.add(value);
        addressSet.remove(value);
        assert(addressSet.values().length == 0);
    }

    // Invariants for `at` Function
//    function testAtIndexOutOfBounds() public {
//        try addressSet.at(0) {
//            assert(false);
//        } catch {
//            assert(true);
//        }
//    }

    function testAtValidIndex() public {
        address value = address(0x1);
        addressSet.add(value);
        assert(addressSet.at(0) == value);
    }

    function testAtMultipleElements() public {
        address value1 = address(0x1);
        address value2 = address(0x2);
        addressSet.add(value1);
        addressSet.add(value2);
        assert(addressSet.at(0) == value1 || addressSet.at(1) == value1);
    }

    // General Edge Cases
//    function testZeroSentinelHandling() public {
//        try addressSet.add(_ZERO_SENTINEL) {
//            assert(false);
//        } catch {
//            assert(true);
//        }
//    }

    function testLargeSets() public {
        for (uint256 i = 0; i < 1000; i++) {
            addressSet.add(address(uint160(i)));
        }
        assert(addressSet.length() == 1000);
    }
}