//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2} from "forge-std/Test.sol";
//import "../src/utils/LibPRNG.sol";
//
//contract LibPRNGTest is Test {
//    using LibPRNG for *;
//
//    function testSeed() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        assertEq(prng.state, 12345);
//    }
//
//    function testNext() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        uint256 result = prng.next();
//        assertTrue(result != 0);
//    }
//
//    function testUniform() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        uint256 upper = 100;
//        uint256 result = prng.uniform(upper);
//        assertTrue(result < upper);
//    }
//
//    function testShuffleArray() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        uint256[] memory array = new uint256[](5);
//        for (uint256 i = 0; i < 5; i++) {
//            array[i] = i;
//        }
//        prng.shuffle(array);
//        for (uint256 i = 0; i < 5; i++) {
//            console2.log(array[i]);
//        }
//    }
//
//    function testShuffleBytes() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        bytes memory data = "hello";
//        prng.shuffle(data);
//        console2.log(string(data));
//    }
//
//    function testStandardNormalWad() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        int256 result = prng.standardNormalWad();
//        console2.logInt(result);
//    }
//
//    function testExponentialWad() public {
//        LibPRNG.PRNG memory prng;
//        prng.seed(12345);
//        uint256 result = prng.exponentialWad();
//        console2.log(result);
//    }
//
//    function testLazyShufflerInitialize() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        assertEq(shuffler.length(), 10);
//    }
//
//    function testLazyShufflerGrow() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        shuffler.grow(20);
//        assertEq(shuffler.length(), 20);
//    }
//
//    function testLazyShufflerRestart() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        shuffler.next(12345);
//        shuffler.restart();
//        assertEq(shuffler.numShuffled(), 0);
//    }
//
//    function testLazyShufflerNumShuffled() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        shuffler.next(12345);
//        assertEq(shuffler.numShuffled(), 1);
//    }
//
//    function testLazyShufflerLength() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        assertEq(shuffler.length(), 10);
//    }
//
//    function testLazyShufflerInitialized() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        assertTrue(shuffler.initialized());
//    }
//
//    function testLazyShufflerFinished() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(1);
//        shuffler.next(12345);
//        assertTrue(shuffler.finished());
//    }
//
//    function testLazyShufflerGet() public {
//        LibPRNG.LazyShuffler storage shuffler;
//        shuffler.initialize(10);
//        uint256 value = shuffler.get(5);
//        assertEq(value, 5);
//    }
//
////    function testLazyShufflerNext() public {
////        LibPRNG.LazyShuffler storage shuffler;
////        shuffler.initialize(10);
////        uint256 value = shuffler.next(12345);
////        assertTrue(value < 10);
////    }
//}