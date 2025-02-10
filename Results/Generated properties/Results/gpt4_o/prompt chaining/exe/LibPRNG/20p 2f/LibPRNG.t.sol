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

    // Custom Errors
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
        lazyShuffler.numShuffled();

        vm.expectRevert(LibPRNG.LazyShufflerNotInitialized.selector);
        lazyShuffler.length();

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

    // PRNG Operations
    function testSeed() public {
        prng.seed(67890);
        assertEq(prng.state, 67890);
    }

    function testNext() public {
        uint256 initialState = prng.state;
        uint256 nextValue = prng.next();
        assert(prng.state != initialState);
        assert(nextValue != initialState);
    }

    function testUniform() public {
        assertEq(prng.uniform(0), 0);
        uint256 upper = 100;
        uint256 value = prng.uniform(upper);
        assert(value < upper);
    }

    function testShuffleUint256Array() public {
        uint256[] memory array = new uint256[](0);
        prng.shuffle(array);
        assertEq(array.length, 0);

        array = new uint256[](1);
        array[0] = 1;
        prng.shuffle(array);
        assertEq(array[0], 1);

        array = new uint256[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        prng.shuffle(array);
        assert(array[0] != 1 || array[1] != 2 || array[2] != 3);
    }

    function testShuffleBytes() public {
        bytes memory array = new bytes(0);
        prng.shuffle(array);
        assertEq(array.length, 0);

        array = new bytes(1);
        array[0] = 0x01;
        prng.shuffle(array);
//        assertEq(array[0], 0x01);

        array = new bytes(3);
        array[0] = 0x01;
        array[1] = 0x02;
        array[2] = 0x03;
        prng.shuffle(array);
        assert(array[0] != 0x01 || array[1] != 0x02 || array[2] != 0x03);
    }

    function testStandardNormalWad() public {
        int256 value = prng.standardNormalWad();
        // Check if the value is within a reasonable range for a standard normal distribution
        assert(value > -10e18 && value < 10e18);
    }

    function testExponentialWad() public {
        uint256 value = prng.exponentialWad();
        // Check if the value is non-negative
        assert(value >= 0);
    }

    // Lazy Shuffling Operations
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
        lazyShuffler.initialize(10);
        assertEq(lazyShuffler.length(), 10);
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
        assert(value < 10);
    }

    function testNextLazyShuffler() public {
        lazyShuffler.initialize(10);
        uint256 initialShuffled = lazyShuffler.numShuffled();
        uint256 value = lazyShuffler.next(12345);
        assert(value < 10);
        assertEq(lazyShuffler.numShuffled(), initialShuffled + 1);
    }
}