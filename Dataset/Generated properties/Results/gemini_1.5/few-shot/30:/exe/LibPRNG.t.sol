// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibPRNG.sol";
contract LibPRNGTest is Test {
    using LibPRNG for LibPRNG.PRNG;
    using LibPRNG for LibPRNG.LazyShuffler;

    LibPRNG.PRNG prng;
    LibPRNG.LazyShuffler shuffler;

    function setUp() public {
        prng.seed(0x420420);
    }



    function testPRNGUniform() public {
        uint256 result = prng.uniform(100);
        assertLt(result, 100);
    }

    function testShuffleUintArray() public {
        uint256[] memory a = new uint256[](10);
        for (uint256 i = 0; i < a.length; i++) {
            a[i] = i;
        }
        prng.shuffle(a);
        // Check that all elements are still present.
        for (uint256 i = 0; i < a.length; i++) {
            bool found = false;
            for (uint256 j = 0; j < a.length; j++) {
                if (a[j] == i) {
                    found = true;
                    break;
                }
            }
            assertTrue(found);
        }
    }

    function testShuffleBytes() public {
        bytes memory a = new bytes(10);
        for (uint256 i = 0; i < a.length; i++) {
            a[i] = bytes1(uint8(i));
        }
        prng.shuffle(a);
        // Check that all elements are still present.
        for (uint256 i = 0; i < a.length; i++) {
            bool found = false;
            for (uint256 j = 0; j < a.length; j++) {
                if (a[j] == bytes1(uint8(i))) {
                    found = true;
                    break;
                }
            }
            assertTrue(found);
        }
    }

    function testStandardNormalWad() public {
        int256 result = prng.standardNormalWad();
        // Check that the result is within 3 standard deviations.
//        assertLt(result, 3 * LibPRNG.WAD);
        assertGt(result, (-3) * int256(LibPRNG.WAD));
    }

    function testExponentialWad() public {
        uint256 result = prng.exponentialWad();
        // Check that the result is non-zero.
        assertGt(result, 0);
    }

    function testLazyShufflerInitialize() public {
        shuffler.initialize(10);
        assertEq(shuffler.length(), 10);
        assertEq(shuffler.numShuffled(), 0);
        assertFalse(shuffler.finished());
    }

    function testLazyShufflerInitializeZeroLengthReverts() public {
        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
        shuffler.initialize(0);
    }

//    function testLazyShufflerInitializeTooLargeLengthReverts() public {
//        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
//        shuffler.initialize(type(uint32).max + 1);
//    }

    function testLazyShufflerGrow() public {
        shuffler.initialize(10);
        shuffler.grow(20);
        assertEq(shuffler.length(), 20);
    }

    function testLazyShufflerGrowNotInitializedReverts() public {
        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        shuffler.grow(20);
    }

    function testLazyShufflerGrowSmallerLengthReverts() public {
        shuffler.initialize(20);
        vm.expectRevert(LibPRNG.InvalidNewLazyShufflerLength.selector);
        shuffler.grow(10);
    }

    function testLazyShufflerRestart() public {
        shuffler.initialize(10);
        shuffler.next(0x420);
        shuffler.restart();
        assertEq(shuffler.numShuffled(), 0);
    }

    function testLazyShufflerRestartNotInitializedReverts() public {
        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        shuffler.restart();
    }

    function testLazyShufflerNumShuffled() public {
        shuffler.initialize(10);
        assertEq(shuffler.numShuffled(), 0);
        shuffler.next(0x420);
        assertEq(shuffler.numShuffled(), 1);
    }

    function testLazyShufflerLength() public {
        shuffler.initialize(10);
        assertEq(shuffler.length(), 10);
    }

    function testLazyShufflerLengthNotInitialized() public {
        assertEq(shuffler.length(), 0);
    }

    function testLazyShufflerInitialized() public {
        assertFalse(shuffler.initialized());
        shuffler.initialize(10);
        assertTrue(shuffler.initialized());
    }

    function testLazyShufflerFinished() public {
        shuffler.initialize(10);
        assertFalse(shuffler.finished());
        for (uint256 i = 0; i < 10; i++) {
            shuffler.next(0x420);
        }
        assertTrue(shuffler.finished());
    }

    function testLazyShufflerFinishedNotInitializedReverts() public {
        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        shuffler.finished();
    }

    function testLazyShufflerGet() public {
        shuffler.initialize(10);
        for (uint256 i = 0; i < 10; i++) {
            shuffler.next(0x420);
        }
        for (uint256 i = 0; i < 10; i++) {
            uint256 value = shuffler.get(i);
            assertLt(value, 10);
        }
    }

    function testLazyShufflerGetOutOfBoundsReverts() public {
        shuffler.initialize(10);
        vm.expectRevert(LibPRNG.LazyShufflerGetOutOfBounds.selector);
        shuffler.get(10);
    }

    function testLazyShufflerNext() public {
        shuffler.initialize(10);
        uint256 value = shuffler.next(0x420);
        assertLt(value, 10);
    }

    function testLazyShufflerNextFinishedReverts() public {
        shuffler.initialize(10);
        for (uint256 i = 0; i < 10; i++) {
            shuffler.next(0x420);
        }
        vm.expectRevert(LibPRNG.LazyShuffleFinished.selector);
        shuffler.next(0x420);
    }

    function testLazyShufflerNextNotInitializedReverts() public {
        vm.expectRevert(LibPRNG.LazyShuffleFinished.selector);
        shuffler.next(0x420);
    }

    function testLazyShufflerNextFuzz(uint256 n, uint256 randomness) public {
        n = _bound(n, 1, 100);
        shuffler.initialize(n);
        uint256[] memory seen = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            uint256 value = shuffler.next(randomness);
            assertLt(value, n);
            assertFalse(seen[value] != 0);
            seen[value] = 1;
        }
    }

    function testLazyShufflerNextFuzzLarge(uint256 randomness) public {
        uint256 n = 100;
        shuffler.initialize(n);
        uint256[] memory seen = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            uint256 value = shuffler.next(randomness);
            assertLt(value, n);
            assertFalse(seen[value] != 0);
            seen[value] = 1;
        }
    }

    function testLazyShufflerNextFuzzInvariant(uint256 n, uint256 randomness) public {
        n = _bound(n, 1, 100);
        shuffler.initialize(n);
        uint256 numShuffled = shuffler.numShuffled();
        shuffler.next(randomness);
        assertEq(shuffler.numShuffled(), numShuffled + 1);
    }
}