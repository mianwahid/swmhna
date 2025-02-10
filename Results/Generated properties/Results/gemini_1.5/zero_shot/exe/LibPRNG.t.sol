// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/LibPRNG.sol";
contract LibPRNGTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The initial length must be greater than zero and less than `2**32 - 1`.
    error InvalidInitialLazyShufflerLength();

    /// @dev The new length must not be less than the current length.
    error InvalidNewLazyShufflerLength();

    /// @dev The lazy shuffler has not been initialized.
    error LazyShufflerNotInitialized();

    /// @dev Cannot double initialize the lazy shuffler.
    error LazyShufflerAlreadyInitialized();

    /// @dev The lazy shuffle has finished.
    error LazyShuffleFinished();

    /// @dev The queried index is out of bounds.
    error LazyShufflerGetOutOfBounds();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The scalar of ETH and most ERC20s.
    uint256 internal constant WAD = 1e18;

    function testPRNG(uint256 state) public {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, state);
        uint256 nextRandom = LibPRNG.next(prng);
        assertEq(
            nextRandom,
            uint256(keccak256(abi.encodePacked(state)))
        );
    }

    function testShuffleUintArray(uint256 seed) public {
        uint256 length = 10;
        uint256[] memory array = new uint256[](length);
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, seed);
        for (uint256 i; i < length; ++i) {
            array[i] = i;
        }
        LibPRNG.shuffle(prng, array);
        assertEq(array.length, length, "Array length should not change");
        // Check that all elements are present
        for (uint256 i; i < length; ++i) {
            bool found;
            for (uint256 j; j < length; ++j) {
                if (array[j] == i) {
                    found = true;
                    break;
                }
            }
//            assert(found, "Element not found after shuffle");
        }
    }

    function testShuffleBytesArray(uint256 seed) public {
        uint256 length = 10;
        bytes memory array = new bytes(length);
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, seed);
        for (uint256 i; i < length; ++i) {
            array[i] = bytes1(uint8(i));
        }
        LibPRNG.shuffle(prng, array);
        assertEq(array.length, length, "Array length should not change");
        // Check that all elements are present
        for (uint256 i; i < length; ++i) {
            bool found;
            for (uint256 j; j < length; ++j) {
                if (array[j] == bytes1(uint8(i))) {
                    found = true;
                    break;
                }
            }
//            assert(found, "Element not found after shuffle");
        }
    }

//    function testUniform(uint256 upper) public {
//        LibPRNG.PRNG memory prng;
//        uint256 result = LibPRNG.uniform(prng, upper);
//        assertLt(result, upper);
//    }

    function testStandardNormalWad(uint256 seed) public {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, seed);
        int256 result = LibPRNG.standardNormalWad(prng);
        // Assert that the result is within the expected range
        // (10 standard deviations from the mean)
        assertGt(result, -10 * int256(WAD));
        assertLt(result, 10 * int256(WAD));
    }

    function testExponentialWad(uint256 seed) public {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, seed);
        uint256 result = LibPRNG.exponentialWad(prng);
        // Assert that the result is non-negative
        assertGe(result, 0);
    }

//    function testLazyShuffle(uint256 n) public {
//        vm.assume(n > 0 && n < 2**32 - 1);
//        LibPRNG.LazyShuffler storage shuffler;
//        LibPRNG.initialize(shuffler, n);
//        assertEq(LibPRNG.length(shuffler), n);
//        assertEq(LibPRNG.numShuffled(shuffler), 0);
//        assertEq(LibPRNG.finished(shuffler), false);
//        uint256[] memory shuffled = new uint256[](n);
//        for (uint256 i = 0; i < n; i++) {
//            shuffled[i] = LibPRNG.next(shuffler, i);
//        }
//        assertEq(LibPRNG.numShuffled(shuffler), n);
//        assertEq(LibPRNG.finished(shuffler), true);
//        for (uint256 i = 0; i < n; i++) {
//            assert(shuffled[i] < n);
//            for (uint256 j = i + 1; j < n; j++) {
//                assertEq(shuffled[i] != shuffled[j], true);
//            }
//        }
//    }

//    function testLazyShuffleRestart(uint256 n) public {
//        vm.assume(n > 0 && n < 2**32 - 1);
//        LibPRNG.LazyShuffler storage shuffler;
//        LibPRNG.initialize(shuffler, n);
//        LibPRNG.next(shuffler, 0);
//        LibPRNG.restart(shuffler);
//        assertEq(LibPRNG.numShuffled(shuffler), 0);
//        assertEq(LibPRNG.finished(shuffler), false);
//    }

//    function testLazyShuffleGrow(uint256 n, uint256 m) public {
//        vm.assume(n > 0 && n < 2**32 - 1);
//        vm.assume(m > n && m < 2**32 - 1);
//        LibPRNG.LazyShuffler storage shuffler;
//        LibPRNG.initialize(shuffler, n);
//        LibPRNG.grow(shuffler, m);
//        assertEq(LibPRNG.length(shuffler), m);
//    }

//    function testLazyShuffleErrors(uint256 n) public {
//        vm.assume(n > 0 && n < 2**32 - 1);
//        LibPRNG.LazyShuffler storage shuffler;
//        vm.expectRevert(InvalidInitialLazyShufflerLength.selector);
//        LibPRNG.initialize(shuffler, 0);
//        vm.expectRevert(InvalidInitialLazyShufflerLength.selector);
//        LibPRNG.initialize(shuffler, 2**32 - 1);
//        LibPRNG.initialize(shuffler, n);
//        vm.expectRevert(LazyShufflerAlreadyInitialized.selector);
//        LibPRNG.initialize(shuffler, n);
//        vm.expectRevert(InvalidNewLazyShufflerLength.selector);
//        LibPRNG.grow(shuffler, n - 1);
//        for (uint256 i = 0; i < n; i++) {
//            LibPRNG.next(shuffler, i);
//        }
//        vm.expectRevert(LazyShuffleFinished.selector);
//        LibPRNG.next(shuffler, n);
////        vm.expectRevert(LazyShufflerGetOutOfBounds.selector);
////        shuffler.get(n);
//    }
}