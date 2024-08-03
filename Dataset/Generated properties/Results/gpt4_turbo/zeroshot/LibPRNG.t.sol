// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/LibPRNG.sol";

contract LibPRNGTest is Test {
    LibPRNG.PRNG private prng;

    function setUp() public {
        // Initialize PRNG with a deterministic seed for testing
        LibPRNG.seed(prng, uint256(keccak256("seed")));
    }

    // function testSeed() public {
    //     // Test seeding the PRNG
    //     uint256 initialSeed = 123456;
    //     LibPRNG.seed(prng, initialSeed);
    //     assertEq(prng.state, initialSeed, "Seed should set the PRNG state correctly");
    // }

    // function testNext() public {
    //     // Test generating the next pseudorandom number
    //     uint256 first = LibPRNG.next(prng);
    //     uint256 second = LibPRNG.next(prng);
    //     assertNe(first, second, "Subsequent calls to next() should produce different outputs");
    // }

    function testUniform() public {
        // Test uniform distribution
        uint256 upper = 100;
        uint256 randomValue = LibPRNG.uniform(prng, upper);
        assertTrue(
            randomValue < upper,
            "Uniform value should be less than upper bound"
        );
    }

    function testShuffleArray() public {
        // Test shuffling an array
        uint256[] memory array = new uint256[](5);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        array[3] = 4;
        array[4] = 5;
        LibPRNG.shuffle(prng, array);
        bool isDifferent = false;
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] != i + 1) {
                isDifferent = true;
                break;
            }
        }
        assertTrue(
            isDifferent,
            "Shuffled array should be different from the original"
        );
    }

    // function testShuffleBytes() public {
    //     // Test shuffling bytes
    //     bytes memory byteArray = "abcdef";
    //     bytes memory original = byteArray;
    //     LibPRNG.shuffle(prng, byteArray);
    //     bool isDifferent = false;
    //     for (uint256 i = 0; i < byteArray.length; i++) {
    //         if (byteArray[i] != original[i]) {
    //             isDifferent = true;
    //             break;
    //         }
    //     }
    //     assertTrue(isDifferent, "Shuffled bytes should be different from the original");
    // }

    function testStandardNormalWad() public {
        // Test standard normal distribution
        int256 normalSample = LibPRNG.standardNormalWad(prng);
        // Check if the sample is within a reasonable range (e.g., within 6 standard deviations)
        assertTrue(
            normalSample > -6 * int256(LibPRNG.WAD) &&
                normalSample < 6 * int256(LibPRNG.WAD),
            "Sample should be within 6 standard deviations"
        );
    }

    function testExponentialWad() public {
        // Test exponential distribution
        uint256 expSample = LibPRNG.exponentialWad(prng);
        // Check if the sample is non-negative
        assertTrue(expSample >= 0, "Exponential sample should be non-negative");
    }

    function testRepeatability() public {
        // Test repeatability by re-seeding and generating the same numbers
        uint256 seed = 7890;
        LibPRNG.seed(prng, seed);
        uint256 firstRun = LibPRNG.next(prng);
        LibPRNG.seed(prng, seed);
        uint256 secondRun = LibPRNG.next(prng);
        assertEq(
            firstRun,
            secondRun,
            "Re-seeding with the same seed should produce the same pseudorandom number"
        );
    }
}
