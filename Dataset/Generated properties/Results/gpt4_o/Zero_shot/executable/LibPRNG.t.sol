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
//        prng.seed(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))));
    }

//    function testSeed() public {
//        uint256 initialState = prng.state;
//        prng.seed(12345);
//        assert(prng.state == 12345);
//        prng.seed(initialState);
//    }

//    function testNext() public {
//        uint256 randomValue1 = prng.next();
//        uint256 randomValue2 = prng.next();
//        assertTrue(randomValue1 != randomValue2);
//    }

    function testUniform() public {
        uint256 upper = 100;
        uint256 randomValue = prng.uniform(upper);
        assert(randomValue < upper);
    }

    function testShuffleArray() public {
        uint256[] memory array = new uint256[](10);
        for (uint256 i = 0; i < array.length; i++) {
            array[i] = i;
        }
        prng.shuffle(array);
        bool isShuffled = false;
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] != i) {
                isShuffled = true;
                break;
            }
        }
        assert(isShuffled);
    }

    function testShuffleBytes() public {
        bytes memory data = "abcdefghij";
        prng.shuffle(data);
        bool isShuffled = false;
        for (uint256 i = 0; i < data.length; i++) {
            if (data[i] != bytes("abcdefghij")[i]) {
                isShuffled = true;
                break;
            }
        }
        assert(isShuffled);
    }

    function testStandardNormalWad() public {
        int256 result = prng.standardNormalWad();
        assert(result != 0);
    }

    function testExponentialWad() public {
        uint256 result = prng.exponentialWad();
        assert(result != 0);
    }

    function testLazyShufflerInitialize() public {
        lazyShuffler.initialize(10);
        assert(lazyShuffler.length() == 10);
    }

    function testLazyShufflerGrow() public {
        lazyShuffler.initialize(10);
        lazyShuffler.grow(20);
        assert(lazyShuffler.length() == 20);
    }

    function testLazyShufflerRestart() public {
        lazyShuffler.initialize(10);
        lazyShuffler.next(prng.next());
        lazyShuffler.restart();
        assert(lazyShuffler.numShuffled() == 0);
    }

    function testLazyShufflerGet() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.get(5);
        assert(value == 5);
    }

    function testLazyShufflerNext() public {
        lazyShuffler.initialize(10);
        uint256 value = lazyShuffler.next(prng.next());
        assert(value < 10);
    }

    function testLazyShufflerFinished() public {
        lazyShuffler.initialize(10);
        for (uint256 i = 0; i < 10; i++) {
            lazyShuffler.next(prng.next());
        }
        assert(lazyShuffler.finished());
    }

//    function testLazyShufflerNotInitialized() public {
//        try lazyShuffler.next(prng.next()) {
//            assert(false);
//        } catch Error(string memory reason) {
//            assertEq(reason, "LazyShufflerNotInitialized()");
//        }
//    }

//    function testLazyShufflerInvalidInitialLength() public {
//        try lazyShuffler.initialize(0) {
//            assert(false);
//        } catch Error(string memory reason) {
//            assertEq(reason, "InvalidInitialLazyShufflerLength()");
//        }
//    }

//    function testLazyShufflerInvalidNewLength() public {
//        lazyShuffler.initialize(10);
//        try lazyShuffler.grow(5) {
//            assert(false);
//        } catch Error(string memory reason) {
//            assertEq(reason, "InvalidNewLazyShufflerLength()");
//        }
//    }

//    function testLazyShufflerGetOutOfBounds() public {
//        lazyShuffler.initialize(10);
//        try lazyShuffler.get(10) {
//            assert(false);
//        } catch Error(string memory reason) {
//            assertEq(reason, "LazyShufflerGetOutOfBounds()");
//        }
//    }

//    function testLazyShufflerAlreadyInitialized() public {
//        lazyShuffler.initialize(10);
//        try lazyShuffler.initialize(10) {
//            assert(false);
//        } catch Error(string memory reason) {
//            assertEq(reason, "LazyShufflerAlreadyInitialized()");
//        }
//    }

//    function testLazyShuffleFinished() public {
//        lazyShuffler.initialize(10);
//        for (uint256 i = 0; i < 10; i++) {
//            lazyShuffler.next(prng.next());
//        }
//        try lazyShuffler.next(prng.next()) {
//            assert(false);
//        } catch Error(string memory reason) {
//            assertEq(reason, "LazyShuffleFinished()");
//        }
//    }
}