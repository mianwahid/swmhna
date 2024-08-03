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
        uint256 day = 14;

        uint256 epochDay = DateTimeLib.dateToEpochDay(year, month, day);
        (uint256 y, uint256 m, uint256 d) = DateTimeLib.epochDayToDate(epochDay);

        assertEq(year, y);
        assertEq(month, m);
        assertEq(day, d);
    }

    /// @dev Test conversion from timestamp to date and back.
    function testTimestampToDateAndBack() public {
        uint256 timestamp = block.timestamp; // Current block timestamp

        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(timestamp);
        uint256 resultTimestamp = DateTimeLib.dateToTimestamp(year, month, day);

        // Check if the converted timestamp is on the same day (ignoring time within the day)
        assertEq(resultTimestamp / 86400, timestamp / 86400);
    }

    /// @dev Test leap year detection.
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

    /// @dev Test date boundary conditions.
    function testDateBoundaries() public {
        assert(DateTimeLib.isSupportedDate(1970, 1, 1));
        assert(DateTimeLib.isSupportedDate(DateTimeLib.MAX_SUPPORTED_YEAR, 12, 31));
        assert(!DateTimeLib.isSupportedDate(DateTimeLib.MAX_SUPPORTED_YEAR + 1, 1, 1));
        assert(!DateTimeLib.isSupportedDate(1969, 12, 31));
    }

    /// @dev Test date arithmetic operations.
    function testDateArithmetic() public {
        uint256 timestamp = block.timestamp;

        uint256 addedYears = DateTimeLib.addYears(timestamp, 1);
        assertEq(DateTimeLib.diffYears(timestamp, addedYears), 1);

        uint256 addedMonths = DateTimeLib.addMonths(timestamp, 12); // Adding 12 months should be roughly a year
        assertEq(DateTimeLib.diffMonths(timestamp, addedMonths), 12);

        uint256 addedDays = DateTimeLib.addDays(timestamp, 365);
        assertEq(DateTimeLib.diffDays(timestamp, addedDays), 365);

        uint256 addedHours = DateTimeLib.addHours(timestamp, 24);
        assertEq(DateTimeLib.diffHours(timestamp, addedHours), 24);

        uint256 addedMinutes = DateTimeLib.addMinutes(timestamp, 60);
        assertEq(DateTimeLib.diffMinutes(timestamp, addedMinutes), 60);

        uint256 addedSeconds = DateTimeLib.addSeconds(timestamp, 60);
        assertEq(DateTimeLib.diffSeconds(timestamp, addedSeconds), 60);
    }

    /// @dev Test weekday calculation.
    function testWeekday() public {
        // Known fixed date: 2023-03-14 is a Tuesday
        uint256 timestamp = DateTimeLib.dateToTimestamp(2023, 3, 14);
        assertEq(DateTimeLib.weekday(timestamp), 2); // Tuesday
    }

    /// @dev Test nth weekday calculation.
    function testNthWeekdayInMonthOfYear() public {
        // Known fixed date: 3rd Friday of March 2023
        uint256 timestamp = DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 3, 3, 5);
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(timestamp);
        assertEq(year, 2023);
        assertEq(month, 3);
        assertEq(day, 17); // Should be the 17th
    }

    /// @dev Test edge cases for date and time conversions.
    function testExtremeDates() public {
        // Test the maximum supported date
        uint256 maxDateTimestamp = DateTimeLib.dateToTimestamp(DateTimeLib.MAX_SUPPORTED_YEAR, 12, 31);
        (uint256 maxY, uint256 maxM, uint256 maxD) = DateTimeLib.timestampToDate(maxDateTimestamp);
        assertEq(maxY, DateTimeLib.MAX_SUPPORTED_YEAR);
        assertEq(maxM, 12);
        assertEq(maxD, 31);

        // Test the minimum supported date
        uint256 minDateTimestamp = DateTimeLib.dateToTimestamp(1970, 1, 1);
        (uint256 minY, uint256 minM, uint256 minD) = DateTimeLib.timestampToDate(minDateTimestamp);
        assertEq(minY, 1970);
        assertEq(minM, 1);
        assertEq(minD, 1);
    }
}
