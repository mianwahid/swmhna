// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/DateTimeLib.sol";

contract DateTimeLibTest is Test {
    using DateTimeLib for uint256;

    /// @dev Test conversion from date to epoch day and back.
    function testDateToEpochDayAndBack() public {
        uint256 year = 2023;
        uint256 month = 3;
        uint256 day = 15;

        uint256 epochDay = DateTimeLib.dateToEpochDay(year, month, day);
        (uint256 y, uint256 m, uint256 d) = DateTimeLib.epochDayToDate(
            epochDay
        );

        assertEq(year, y);
        assertEq(month, m);
        assertEq(day, d);
    }

    /// @dev Test conversion from timestamp to date and back.
    function testTimestampToDateAndBack() public {
        uint256 timestamp = block.timestamp; // Current block timestamp

        (uint256 year, uint256 month, uint256 day) = DateTimeLib
            .timestampToDate(timestamp);
        uint256 newTimestamp = DateTimeLib.dateToTimestamp(year, month, day);

        // Check if the converted timestamp is at the start of the day (00:00:00)
        assertEq(newTimestamp, timestamp - (timestamp % 86400));
    }

    /// @dev Test leap year calculation.
    function testLeapYear() public {
        assert(DateTimeLib.isLeapYear(2020));
        assert(!DateTimeLib.isLeapYear(2021));
        assert(DateTimeLib.isLeapYear(2024));
        assert(!DateTimeLib.isLeapYear(2100)); // 2100 is not a leap year
    }

    /// @dev Test days in month calculation.
    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2021, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2020, 2), 29); // Leap year
        assertEq(DateTimeLib.daysInMonth(2021, 1), 31);
        assertEq(DateTimeLib.daysInMonth(2021, 4), 30);
    }

    /// @dev Test date validation.
    function testDateValidation() public {
        assert(DateTimeLib.isSupportedDate(2021, 12, 31));
        assert(!DateTimeLib.isSupportedDate(2021, 2, 30)); // Invalid day
        assert(!DateTimeLib.isSupportedDate(1969, 12, 31)); // Year before 1970
        assert(
            !DateTimeLib.isSupportedDate(
                DateTimeLib.MAX_SUPPORTED_YEAR + 1,
                1,
                1
            )
        ); // Exceeding max year
    }

    /// @dev Test adding and subtracting years.
    function testAddSubYears() public {
        uint256 timestamp = block.timestamp;
        uint256 addedYears = DateTimeLib.addYears(timestamp, 10);
        uint256 subtractedYears = DateTimeLib.subYears(timestamp, 0);

        assertEq(DateTimeLib.diffYears(timestamp, addedYears), 10);
        assertEq(DateTimeLib.diffYears(subtractedYears, timestamp), 0);
    }

    /// @dev Test adding and subtracting months.
    function testAddSubMonths() public {
        uint256 timestamp = block.timestamp;
        uint256 addedMonths = DateTimeLib.addMonths(timestamp, 12);
        uint256 subtractedMonths = DateTimeLib.subMonths(timestamp, 0);

        assertEq(DateTimeLib.diffMonths(timestamp, addedMonths), 12);
        assertEq(DateTimeLib.diffMonths(subtractedMonths, timestamp), 0);
    }

    /// @dev Test adding and subtracting days.
    function testAddSubDays() public {
        uint256 timestamp = block.timestamp;
        uint256 addedDays = DateTimeLib.addDays(timestamp, 365);
        uint256 subtractedDays = DateTimeLib.subDays(timestamp, 0);

        assertEq(DateTimeLib.diffDays(timestamp, addedDays), 365);
        assertEq(DateTimeLib.diffDays(subtractedDays, timestamp), 0);
    }

    /// @dev Test edge cases for date and time calculations.
    function testEdgeCases() public {
        // Test maximum supported timestamp
        (uint256 year, uint256 month, uint256 day) = DateTimeLib
            .timestampToDate(DateTimeLib.MAX_SUPPORTED_TIMESTAMP);
        assert(DateTimeLib.isSupportedDate(year, month, day));

        // Test minimum supported timestamp (start of Unix epoch)
        (year, month, day) = DateTimeLib.timestampToDate(0);
        assert(DateTimeLib.isSupportedDate(year, month, day));

        // // Test overflow of dateToEpochDay
        // try DateTimeLib.dateToEpochDay(DateTimeLib.MAX_SUPPORTED_YEAR + 1, 1, 1) {
        //     fail("dateToEpochDay should fail with year overflow");
        // } catch {}

        // // Test underflow of epochDayToDate
        // try DateTimeLib.epochDayToDate(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY + 1) {
        //     fail("epochDayToDate should fail with epoch day overflow");
        // } catch {}
    }
}
