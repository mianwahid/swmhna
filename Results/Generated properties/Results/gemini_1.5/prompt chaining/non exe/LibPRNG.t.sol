// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibPRNG.sol";
contract LibPRNGTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       TEST CONSTANTS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    uint256 internal constant ITERATION = 100;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  FUNCTIONS - PRNG IN MEMORY                 */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function testSeed(uint256 state) public {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, state);
        assertEq(prng.state, state);
    }

    function testNext(uint256 state) public {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, state);
        uint256 previousResult = LibPRNG.next(prng);
        for (uint256 i = 0; i < ITERATION; i++) {
            uint256 result = LibPRNG.next(prng);
            assertNotEq(result, previousResult);
            previousResult = result;
        }
    }

    function testUniform(uint256 state, uint256 upper) public {
        vm.assume(upper > 0);
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, state);
        for (uint256 i = 0; i < ITERATION; i++) {
            uint256 result = LibPRNG.uniform(prng, upper);
            assertGe(result, 0);
            assertLt(result, upper);
        }
    }

    function testShuffleUint(uint256 state, uint256 length) public {
        vm.assume(length > 0 && length < 20);
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, state);
        uint256[] memory arr = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            arr[i] = i;
        }
        LibPRNG.shuffle(prng, arr);
        assertEq(arr.length, length);
        for (uint256 i = 0; i < length; i++) {
            assert(contains(arr, i));
        }
    }

    function testShuffleBytes(uint256 state, uint256 length) public {
        vm.assume(length > 0 && length < 20);
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, state);
        bytes memory arr = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            arr[i] = bytes1(uint8(i));
        }
        LibPRNG.shuffle(prng, arr);
        assertEq(arr.length, length);
        for (uint256 i = 0; i < length; i++) {
            assert(contains(arr, bytes1(uint8(i))));
        }
    }

    function contains(uint256[] memory arr, uint256 value) internal pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return true;
            }
        }
        return false;
    }

    function contains(bytes memory arr, bytes1 value) internal pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return true;
            }
        }
        return false;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*           FUNCTIONS - LAZY SHUFFLING IN STORAGE            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    function testInitialize(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        assertEq(LibPRNG.length(shuffler), n);
        assertEq(LibPRNG.numShuffled(shuffler), 0);
    }

    function testInitializeFailAlreadyInitialized(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        vm.expectRevert(LibPRNG.LazyShufflerAlreadyInitialized.selector);
        LibPRNG.initialize(shuffler, n);
    }

    function testInitializeFailInvalidLength(uint256 n) public {
        vm.assume(n == 0 || n >= type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        vm.expectRevert(LibPRNG.InvalidInitialLazyShufflerLength.selector);
        LibPRNG.initialize(shuffler, n);
    }

    function testGrow(uint256 n, uint256 newN) public {
        vm.assume(n > 0 && n < type(uint32).max && newN > n && newN < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        LibPRNG.grow(shuffler, newN);
        assertEq(LibPRNG.length(shuffler), newN);
        assertEq(LibPRNG.numShuffled(shuffler), 0);
    }

    function testGrowFailInvalidLength(uint256 n, uint256 newN) public {
        vm.assume(n > 0 && n < type(uint32).max && newN < n);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        vm.expectRevert(LibPRNG.InvalidNewLazyShufflerLength.selector);
        LibPRNG.grow(shuffler, newN);
    }

    function testRestart(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        LibPRNG.restart(shuffler);
        assertEq(LibPRNG.numShuffled(shuffler), 0);
        assertEq(LibPRNG.length(shuffler), n);
    }

    function testNumShuffled(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        assertLe(LibPRNG.numShuffled(shuffler), LibPRNG.length(shuffler));
    }

    function testLength(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        assertEq(LibPRNG.length(shuffler), n);
    }

    function testInitialized(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        assertEq(LibPRNG.initialized(shuffler), false);
        LibPRNG.initialize(shuffler, n);
        assertEq(LibPRNG.initialized(shuffler), true);
    }

    function testFinished(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        assertEq(LibPRNG.finished(shuffler), false);
        for (uint256 i = 0; i < n; i++) {
            LibPRNG.next(shuffler, i);
        }
        assertEq(LibPRNG.finished(shuffler), true);
    }

    function testGet(uint256 n) public {
        vm.assume(n > 0 && n < type(uint32).max);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        for (uint256 i = 0; i < n; i++) {
            LibPRNG.next(shuffler, i);
        }
        for (uint256 i = 0; i < n; i++) {
            uint256 result = LibPRNG.get(shuffler, i);
            assertGe(result, 0);
            assertLt(result, n);
        }
    }

    function testGetFailOutOfBounds(uint256 n, uint256 index) public {
        vm.assume(n > 0 && n < type(uint32).max && index >= n);
        LibPRNG.LazyShuffler storage shuffler;
        LibPRNG.initialize(shuffler, n);
        vm.expectRevert(LibPRNG.LazyShufflerGetOutOfBounds.selector);
        LibPRNG.get(shuffler, index);
    }

//    function testNext(uint256 n) public {
//        vm.assume(n > 0 && n < type(uint32).max);
//        LibPRNG.LazyShuffler storage shuffler;
//        LibPRNG.initialize(shuffler, n);
//        for (uint256 i = 0; i < n; i++) {
//            uint256 result = LibPRNG.next(shuffler, i);
//            assertGe(result, 0);
//            assertLt(result, n);
//        }
//    }

//    function testNextFailFinished(uint256 n) public {
//        vm.assume(n > 0 && n < type(uint32).max);
//        LibPRNG.LazyShuffler storage shuffler;
//        LibPRNG.initialize(shuffler, n);
//        for (uint256 i = 0; i < n; i++) {
//            LibPRNG.next(shuffler, i);
//        }
//        vm.expectRevert(LibPRNG.LazyShuffleFinished.selector);
//        LibPRNG.next(shuffler, 0);
//    }
}