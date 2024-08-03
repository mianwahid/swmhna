// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/utils/LibPRNG.sol";

contract LibPRNGTest is Test {
    using LibPRNG for LibPRNG.PRNG;
    using LibPRNG for LibPRNG.LazyShuffler;

    LibPRNG.PRNG prng;
    LibPRNG.LazyShuffler lazyShuffler;

    function setUp() public {
        prng.seed(123456789); // Seed with a known value for reproducibility
    }

    function testSeed() public {
        prng.seed(987654321);
        uint256 state = prng.state;
        assertEq(state, 987654321, "PRNG state should be set correctly");
    }

    function testNext() public {
        uint256 first = prng.next();
        uint256 second = prng.next();
        assertNotEq(first, second, "Subsequent calls to next() should produce different outputs");
    }

    function testUniform() public {
        uint256 upper = 100;
        uint256 result = prng.uniform(upper);
        assertTrue(result < upper, "Result should be less than upper bound");
    }

    function testShuffleArray() public {
        uint256[] memory array = new uint256[](5);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        array[3] = 4;
        array[4] = 5;
        prng.shuffle(array);

        // Check that the array is permuted
        uint256 sumOriginal = 15; // 1+2+3+4+5
        uint256 sumShuffled = array[0] + array[1] + array[2] + array[3] + array[4];
        assertEq(sumOriginal, sumShuffled, "Sum of elements should remain the same after shuffling");
    }

    function testShuffleBytes() public {
        bytes memory data = "abcdef";
        prng.shuffle(data);

        // Check that the bytes are permuted
        bytes memory expected = "abcdef";
        uint256 sumOriginal = uint256(uint8(expected[0])) + uint256(uint8(expected[1])) + uint256(uint8(expected[2])) + uint256(uint8(expected[3])) + uint256(uint8(expected[4])) + uint256(uint8(expected[5]));
        uint256 sumShuffled = uint256(uint8(data[0])) + uint256(uint8(data[1])) + uint256(uint8(data[2])) + uint256(uint8(data[3])) + uint256(uint8(data[4])) + uint256(uint8(data[5]));
        assertEq(sumOriginal, sumShuffled, "Sum of bytes should remain the same after shuffling");
    }

    function testStandardNormalWad() public {
        int256 result = prng.standardNormalWad();
        // This is a statistical property, hard to test exactly, but we can check type
        assertTrue(result != 0, "Standard normal should not be zero");
    }

    function testExponentialWad() public {
        uint256 result = prng.exponentialWad();
        assertTrue(result > 0, "Exponential distribution should be positive");
    }

    function testLazyShufflerInitialization() public {
        uint256 length = 10;
        lazyShuffler.initialize(length);
        assertTrue(lazyShuffler.initialized(), "LazyShuffler should be initialized");
        assertEq(lazyShuffler.length(), length, "Length should be set correctly");
    }

    function testLazyShufflerGrow() public {
        uint256 initialLength = 10;
        uint256 newLength = 20;
        lazyShuffler.initialize(initialLength);
        lazyShuffler.grow(newLength);
        assertEq(lazyShuffler.length(), newLength, "Length should be updated correctly");
    }

    function testLazyShufflerNext() public {
        uint256 length = 10;
        lazyShuffler.initialize(length);
        uint256 first = lazyShuffler.next(123);
        uint256 second = lazyShuffler.next(456);
        assertNotEq(first, second, "Subsequent calls to next() should produce different outputs");
    }

    function testLazyShufflerRestart() public {
        uint256 length = 10;
        lazyShuffler.initialize(length);
        lazyShuffler.next(123);
        lazyShuffler.restart();
        assertEq(lazyShuffler.numShuffled(), 0, "numShuffled should be reset to zero");
    }
}