// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibPRNG.sol";

contract LibPRNGTest is Test {
    using LibPRNG for LibPRNG.PRNG;
    using LibPRNG for LibPRNG.LazyShuffler;

    LibPRNG.PRNG prng;
    LibPRNG.LazyShuffler lazyShuffler;

    function setUp() public {
        prng.seed(12345);
    }

    // Custom Errors Tests

    function testInvalidInitialLazyShufflerLength() public {
        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
        lazyShuffler.initialize(0);

        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
        lazyShuffler.initialize(2**32 - 1);
    }

    function testInvalidNewLazyShufflerLength() public {
        lazyShuffler.initialize(10);
        vm.expectRevert(LibPRNG.InvalidNewLazyShufflerLength.selector);
        lazyShuffler.grow(5);
    }

    function testLazyShufflerNotInitialized() public {
        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        lazyShuffler.grow(10);

        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        lazyShuffler.restart();

        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        lazyShuffler.finished();

        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        lazyShuffler.get(0);

        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        lazyShuffler.next(12345);
    }

    function testLazyShufflerAlreadyInitialized() public {
        lazyShuffler.initialize(10);
        vm.expectRevert(LibPRNG.LazyShufflerAlreadyInitialized.selector);
        lazyShuffler.initialize(10);
    }

    function testLazyShuffleFinished() public {
        lazyShuffler.initialize(1);
        lazyShuffler.next(12345);
        vm.expectRevert(LibPRNG.LazyShuffleFinished.selector);
        lazyShuffler.next(12345);
    }

    function testLazyShufflerGetOutOfBounds() public {
        lazyShuffler.initialize(10);
        vm.expectRevert(LibPRNG.LazyShufflerGetOutOfBounds.selector);
        lazyShuffler.get(10);
    }

    // Operations Tests

//    function testSeed() public {
//        prng.seed(0);
//        assertEq(prng.state, 0);
//
//        prng.seed(2**256 - 1);
//        assertEq(prng.state, 2**256 - 1);
//    }

    function testNext1() public {
        uint256 initialState = prng.state;
        uint256 nextValue = prng.next();
        assertTrue(nextValue != initialState);
    }

    function testUniform() public {
        uint256 upper = 100;
        uint256 result = prng.uniform(upper);
        assertTrue(result < upper);

        upper = 1;
        result = prng.uniform(upper);
        assertEq(result, 0);

        upper = 2**256 - 1;
        result = prng.uniform(upper);
        assertTrue(result < upper);
    }

    function testShuffleUintArray() public {
        uint256[] memory array = new uint256[](5);
        for (uint256 i = 0; i < 5; i++) {
            array[i] = i;
        }
        prng.shuffle(array);
        // Check that the array is shuffled
        bool isShuffled = false;
        for (uint256 i = 0; i < 5; i++) {
            if (array[i] != i) {
                isShuffled = true;
                break;
            }
        }
        assertTrue(isShuffled);
    }

    function testShuffleBytesArray() public {
        bytes memory array = new bytes(5);
        for (uint256 i = 0; i < 5; i++) {
            array[i] = bytes1(uint8(i));
        }
        prng.shuffle(array);
        // Check that the array is shuffled
        bool isShuffled = false;
        for (uint256 i = 0; i < 5; i++) {
            if (array[i] != bytes1(uint8(i))) {
                isShuffled = true;
                break;
            }
        }
        assertTrue(isShuffled);
    }

    function testStandardNormalWad() public {
        int256 result = prng.standardNormalWad();
        // Check that the result is within a reasonable range
        assertTrue(result > -10 * int256(LibPRNG.WAD) && result < 10 * int256(LibPRNG.WAD));
    }

    function testExponentialWad() public {
        uint256 result = prng.exponentialWad();
        // Check that the result is within a reasonable range
        assertTrue(result > 0);
    }

    // Storage-Based Range Lazy Shuffling Operations Tests

    function testInitialize() public {
        lazyShuffler.initialize(10);
        assertEq(lazyShuffler.length(), 10);
    }

    function testGrow() public {
        lazyShuffler.initialize(10);
        lazyShuffler.grow(20);
        assertEq(lazyShuffler.length(), 20);
    }

    function testRestart() public {
        lazyShuffler.initialize(10);
        lazyShuffler.next(12345);
        lazyShuffler.restart();
        assertEq(lazyShuffler.numShuffled(), 0);
    }

    function testNumShuffled() public {
        lazyShuffler.initialize(10);
        assertEq(lazyShuffler.numShuffled(), 0);
        lazyShuffler.next(12345);
        assertEq(lazyShuffler.numShuffled(), 1);
    }

    function testLength() public {
        assertEq(lazyShuffler.length(), 0);
        lazyShuffler.initialize(10);
        assertEq(lazyShuffler.length(), 10);
        lazyShuffler.grow(20);
        assertEq(lazyShuffler.length(), 20);
    }

    function testInitialized() public {
        assertFalse(lazyShuffler.initialized());
        lazyShuffler.initialize(10);
        assertTrue(lazyShuffler.initialized());
    }

    function testFinished() public {
        lazyShuffler.initialize(1);
        assertFalse(lazyShuffler.finished());
        lazyShuffler.next(12345);
        assertTrue(lazyShuffler.finished());
    }

    function testGet() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.get(0);
        assertEq(value, 0);
    }

    function testNext() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.next(12345);
        assertTrue(value < 10);
    }
}