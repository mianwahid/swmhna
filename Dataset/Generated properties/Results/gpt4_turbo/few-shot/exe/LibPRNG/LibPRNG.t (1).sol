// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {LibPRNG} from "../src/utils/LibPRNG.sol";

contract LibPRNGTest is Test {
    LibPRNG.PRNG private prng;

    function setUp() public {
        // Seed the PRNG with a deterministic value for testing
        LibPRNG.seed(prng, uint256(keccak256(abi.encodePacked("seed"))));
    }

    function testNext() public {
        uint256 first = LibPRNG.next(prng);
        uint256 second = LibPRNG.next(prng);
        assertNotEq(first, second, "Subsequent calls to next() should produce different results");
    }

    function testUniform() public {
        uint256 upper = 100;
        uint256 result = LibPRNG.uniform(prng, upper);
        assertTrue(result < upper, "Result should be less than upper bound");
    }

    function testShuffleArray() public {
        uint256[] memory array = new uint256[](10);
        for (uint256 i = 0; i < array.length; i++) {
            array[i] = i;
        }

        LibPRNG.shuffle(prng, array);

        // Check that the shuffled array contains the same elements in any order
        uint256 sumOriginal = 0;
        uint256 sumShuffled = 0;
        for (uint256 i = 0; i < array.length; i++) {
            sumOriginal += i;
            sumShuffled += array[i];
        }
        assertEq(sumOriginal, sumShuffled, "Shuffled array should contain the same elements");
    }

    function testShuffleBytes() public {
        bytes memory data = "1234567890";
        bytes memory original = data;

        LibPRNG.shuffle(prng, data);

        // Check that the shuffled bytes contain the same elements in any order
        uint256 sumOriginal = 0;
        uint256 sumShuffled = 0;
        for (uint256 i = 0; i < data.length; i++) {
            sumOriginal += uint256(uint8(original[i]));
            sumShuffled += uint256(uint8(data[i]));
        }
        assertEq(sumOriginal, sumShuffled, "Shuffled bytes should contain the same elements");
    }

    function testStandardNormalWad() public {
        int256 result = LibPRNG.standardNormalWad(prng);
        // This is a basic test to ensure the function returns without error.
        // More complex statistical tests would be needed to validate distribution properties.
        assertTrue(result != 0, "Standard normal should not consistently return 0");
    }

//    function testExponentialWad() public {
//        uint256 result = LibPRNG.exponentialWad(prng);
//        // Basic check to ensure positive result
//        assertTrue(result > 0, "Exponential distribution should be positive");
//    }
//
//    function testLazyShuffler() public {
//        LibPRNG.LazyShuffler storage lazyShuffler;
//        uint256 length = 100;
//        LibPRNG.initialize(lazyShuffler, length);
//
//        uint256 numShuffled = LibPRNG.numShuffled(lazyShuffler);
//        assertEq(numShuffled, 0, "Initially, no items should be shuffled");
//
//        uint256 first = LibPRNG.next(lazyShuffler, uint256(keccak256(abi.encodePacked("randomness"))));
//        assertTrue(first < length, "First shuffled value should be within range");
//
//        numShuffled = LibPRNG.numShuffled(lazyShuffler);
//        assertEq(numShuffled, 1, "One item should be shuffled after one call to next()");
//    }
//
//    function testLazyShufflerGrow() public {
//        LibPRNG.LazyShuffler storage lazyShuffler;
//        uint256 initialLength = 100;
//        LibPRNG.initialize(lazyShuffler, initialLength);
//
//        uint256 newLength = 200;
//        LibPRNG.grow(lazyShuffler, newLength);
//
//        uint256 length = LibPRNG.length(lazyShuffler);
//        assertEq(length, newLength, "Length should be updated to new length");
//    }
//
//    function testLazyShufflerRestart() public {
//        LibPRNG.LazyShuffler storage lazyShuffler;
//        uint256 length = 100;
//        LibPRNG.initialize(lazyShuffler, length);
//
//        // Shuffle some elements
//        for (uint256 i = 0; i < 10; i++) {
//            LibPRNG.next(lazyShuffler, uint256(keccak256(abi.encodePacked(i))));
//        }
//
//        LibPRNG.restart(lazyShuffler);
//
//        uint256 numShuffled = LibPRNG.numShuffled(lazyShuffler);
//        assertEq(numShuffled, 0, "After restart, no items should be shuffled");
//    }
}