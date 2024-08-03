// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/LibPRNG.sol";

contract LibPRNGTest is Test {
    using LibPRNG for LibPRNG.PRNG;
    using LibPRNG for LibPRNG.LazyShuffler;

    LibPRNG.PRNG prng;
    LibPRNG.LazyShuffler lazyShuffler;

    function setUp() public {
        prng.seed(123456789); // Arbitrary seed for consistency in tests
    }

    // function testSeed() public {
    //     prng.seed(0xabcdef);
    //     assertEq(
    //         prng.state,
    //         0xabcdef,
    //         "Seed should set the PRNG state correctly"
    //     );
    // }

    // function testNext() public {
    //     uint256 first = prng.next();
    //     uint256 second = prng.next();
    //     assertNotEq(
    //         first,
    //         second,
    //         "Subsequent calls to next() should produce different outputs"
    //     );
    // }

    function testUniform() public {
        uint256 upper = 100;
        for (uint256 i = 0; i < 10; i++) {
            uint256 value = prng.uniform(upper);
            assertTrue(value < upper, "Value should be less than upper");
        }
    }

    function testUniformEdgeCase() public {
        uint256 value = prng.uniform(1);
        assertEq(value, 0, "Uniform with upper 1 should always return 0");
    }

    function testShuffleArray() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        arr[3] = 4;
        arr[4] = 5;
        uint256[] memory original = new uint256[](5);
        for (uint256 i = 0; i < arr.length; i++) {
            original[i] = arr[i];
        }
        prng.shuffle(arr);
        assertEq(
            arr.length,
            original.length,
            "Shuffled array should have the same length as original"
        );
        assertHasSameElements(
            arr,
            original,
            "Shuffled array should have the same elements as original"
        );
    }

    function testStandardNormalWad() public {
        int256 sum = 0;
        uint256 count = 1000;
        for (uint256 i = 0; i < count; i++) {
            sum += prng.standardNormalWad();
        }
        int256 mean = sum / int256(count);

        // Check if mean is approximately zero considering WAD scaling
        assertTrue(
            mean > -int256(LibPRNG.WAD),
            "Mean should be greater than -WAD"
        );
        assertTrue(mean < int256(LibPRNG.WAD), "Mean should be less than WAD");
    }

    function testExponentialWad() public {
        for (uint256 i = 0; i < 10; i++) {
            uint256 value = prng.exponentialWad();
            assertTrue(
                value >= 0,
                "Values from exponentialWad should be non-negative"
            );
        }
    }

    function testInitialize() public {
        lazyShuffler.initialize(10);
        assertTrue(
            lazyShuffler.initialized(),
            "LazyShuffler should be initialized"
        );
    }

    function testInitializeEdgeCase() public {
        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
        lazyShuffler.initialize(0);
        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
        lazyShuffler.initialize(2 ** 32);
    }

    function testGrow() public {
        lazyShuffler.initialize(10);
        lazyShuffler.grow(20);
        assertEq(
            lazyShuffler.length(),
            20,
            "Length should be updated to new value"
        );
    }

    function testGrowEdgeCase() public {
        lazyShuffler.initialize(10);
        vm.expectRevert(LibPRNG.InvalidNewLazyShufflerLength.selector);
        lazyShuffler.grow(5);
    }

    function testRestart() public {
        lazyShuffler.initialize(10);
        lazyShuffler.next(123);
        lazyShuffler.restart();
        assertEq(
            lazyShuffler.numShuffled(),
            0,
            "numShuffled should be reset to 0 after restart"
        );
    }

    function testNumShuffled() public {
        lazyShuffler.initialize(10);
        lazyShuffler.next(123);
        assertEq(
            lazyShuffler.numShuffled(),
            1,
            "numShuffled should increment correctly"
        );
    }

    function testLength() public {
        lazyShuffler.initialize(10);
        assertEq(
            lazyShuffler.length(),
            10,
            "Length should return the correct value"
        );
    }

    function testInitialized() public {
        lazyShuffler.initialize(10);
        assertTrue(
            lazyShuffler.initialized(),
            "Initialized should return true after initialization"
        );
    }

    function testFinished() public {
        lazyShuffler.initialize(1);
        lazyShuffler.next(123);
        assertTrue(
            lazyShuffler.finished(),
            "Finished should return true when all elements are shuffled"
        );
    }

    function testGet() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.get(0);
        assertTrue(value < 10, "Get should return a valid index value");
    }

    function testNextLazyShuffler() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.next(123);
        assertTrue(value < 10, "Next should return a valid shuffled value");
    }

    function assertHasSameElements(
        uint256[] memory a,
        uint256[] memory b,
        string memory message
    ) private {
        bool[] memory found = new bool[](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            bool elementFound = false;
            for (uint256 j = 0; j < b.length; j++) {
                if (a[i] == b[j] && !found[j]) {
                    found[j] = true;
                    elementFound = true;
                    break;
                }
            }
            require(elementFound, message);
        }
    }
}
