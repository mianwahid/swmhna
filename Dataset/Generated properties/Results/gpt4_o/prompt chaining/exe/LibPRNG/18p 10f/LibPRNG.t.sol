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

    // PRNG Operations

    function testSeed() public {
        prng.seed(98765);
        assertEq(prng.state, 98765);
    }

    function testSeedMaxUint() public {
        prng.seed(type(uint256).max);
        assertEq(prng.state, type(uint256).max);
    }

    function testNext1() public {
        uint256 initialState = prng.state;
        prng.next();
        assert(prng.state != initialState);
    }

    function testNextMultiple() public {
        uint256 initialState = prng.state;
        prng.next();
        uint256 stateAfterFirstNext = prng.state;
        prng.next();
        assert(prng.state != initialState);
        assert(prng.state != stateAfterFirstNext);
    }

    function testUniform() public {
        uint256 upper = 100;
        uint256 result = prng.uniform(upper);
        assert(result < upper);
    }

    function testUniformEdgeCases() public {
        uint256 result = prng.uniform(1);
        assertEq(result, 0);

        result = prng.uniform(type(uint256).max);
        assert(result < type(uint256).max);
    }

    function testShuffleUintArray() public {
        uint256[] memory array = new uint256[](5);
        for (uint256 i = 0; i < 5; i++) {
            array[i] = i;
        }
        prng.shuffle(array);
        uint256 sum = 0;
        for (uint256 i = 0; i < 5; i++) {
            sum += array[i];
        }
        assertEq(sum, 10);
    }

    function testShuffleUintArrayEdgeCases() public {
        uint256[] memory emptyArray = new uint256[](0);
        prng.shuffle(emptyArray);
        assertEq(emptyArray.length, 0);

        uint256[] memory singleElementArray = new uint256[](1);
        singleElementArray[0] = 1;
        prng.shuffle(singleElementArray);
        assertEq(singleElementArray[0], 1);

        uint256[] memory largeArray = new uint256[](1000);
        for (uint256 i = 0; i < 1000; i++) {
            largeArray[i] = i;
        }
        prng.shuffle(largeArray);
        uint256 sum = 0;
        for (uint256 i = 0; i < 1000; i++) {
            sum += largeArray[i];
        }
        assertEq(sum, 499500);
    }

    function testShuffleBytes() public {
        bytes memory array = "abcdef";
        prng.shuffle(array);
        assertEq(array.length, 6);
    }

    function testShuffleBytesEdgeCases() public {
        bytes memory emptyArray = "";
        prng.shuffle(emptyArray);
        assertEq(emptyArray.length, 0);

        bytes memory singleByteArray = "a";
        prng.shuffle(singleByteArray);
        assertEq(singleByteArray[0], "a");

        bytes memory largeArray = new bytes(1000);
        for (uint256 i = 0; i < 1000; i++) {
            largeArray[i] = bytes1(uint8(i % 256));
        }
        prng.shuffle(largeArray);
        assertEq(largeArray.length, 1000);
    }

    function testStandardNormalWad() public {
        int256 result = prng.standardNormalWad();
        assert(result != 0);
    }

    function testExponentialWad() public {
        uint256 result = prng.exponentialWad();
        assert(result != 0);
    }

    // Lazy Shuffler Operations

    function testInitialize() public {
        lazyShuffler.initialize(10);
        assertEq(lazyShuffler.length(), 10);
    }

    function testInitializeEdgeCases() public {
        vm.expectRevert("InvalidInitialLazyShufflerLength()");
        lazyShuffler.initialize(0);

        vm.expectRevert("InvalidInitialLazyShufflerLength()");
        lazyShuffler.initialize(type(uint32).max);
    }

    function testGrow() public {
        lazyShuffler.initialize(10);
        lazyShuffler.grow(20);
        assertEq(lazyShuffler.length(), 20);
    }

    function testGrowEdgeCases() public {
        lazyShuffler.initialize(10);
        vm.expectRevert("InvalidNewLazyShufflerLength()");
        lazyShuffler.grow(5);

        lazyShuffler.grow(type(uint32).max - 1);
        assertEq(lazyShuffler.length(), type(uint32).max - 1);
    }

    function testRestart() public {
        lazyShuffler.initialize(10);
        lazyShuffler.next(12345);
        lazyShuffler.restart();
        assertEq(lazyShuffler.numShuffled(), 0);
    }

    function testRestartEdgeCases() public {
        vm.expectRevert("LazyShufflerNotInitialized()");
        lazyShuffler.restart();
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

    function testLengthEdgeCases() public {
        assertEq(lazyShuffler.length(), 0);
    }

    function testInitialized() public {
        assertFalse(lazyShuffler.initialized());
        lazyShuffler.initialize(10);
        assertTrue(lazyShuffler.initialized());
    }

    function testFinished() public {
        lazyShuffler.initialize(10);
        assertFalse(lazyShuffler.finished());
        for (uint256 i = 0; i < 10; i++) {
            lazyShuffler.next(12345);
        }
        assertTrue(lazyShuffler.finished());
    }

    function testFinishedEdgeCases() public {
        vm.expectRevert("LazyShufflerNotInitialized()");
        lazyShuffler.finished();
    }

    function testGet() public {
        lazyShuffler.initialize(10);
        for (uint256 i = 0; i < 10; i++) {
            assertEq(lazyShuffler.get(i), i);
        }
    }

    function testGetEdgeCases() public {
        lazyShuffler.initialize(10);
        vm.expectRevert("LazyShufflerGetOutOfBounds()");
        lazyShuffler.get(10);
    }

    function testNext() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.next(12345);
        assert(value < 10);
    }

    function testNextEdgeCases() public {
        lazyShuffler.initialize(10);
        for (uint256 i = 0; i < 10; i++) {
            lazyShuffler.next(12345);
        }
        vm.expectRevert("LazyShuffleFinished()");
        lazyShuffler.next(12345);

        vm.expectRevert("LazyShufflerNotInitialized()");
        lazyShuffler.next(12345);
    }
}