// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";

contract DateTimeLibTest is Test {
    using DateTimeLib for uint256;

    function testDateToEpochDay() public {
        uint256 year = 2023;
        uint256 month = 10;
        uint256 day = 5;
        uint256 expectedEpochDay = 19635; // Example value, calculate the correct one
        uint256 epochDay = DateTimeLib.dateToEpochDay(year, month, day);
        assertEq(epochDay, expectedEpochDay);
    }

    function testEpochDayToDate() public {
        uint256 epochDay = 19683; // Example value, calculate the correct one
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(epochDay);
        assertEq(year, 2023);
        assertEq(month, 11);
        assertEq(day, 22);
    }

    function testDateToTimestamp() public {
        uint256 year = 2023;
        uint256 month = 10;
        uint256 day = 5;
        uint256 expectedTimestamp = 1696464000; // Example value, calculate the correct one
        uint256 timestamp = DateTimeLib.dateToTimestamp(year, month, day);
        assertEq(timestamp, expectedTimestamp);
    }

    function testTimestampToDate() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(timestamp);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 5);
    }

    function testDateTimeToTimestamp() public {
        uint256 year = 2023;
        uint256 month = 10;
        uint256 day = 5;
        uint256 hour = 12;
        uint256 minute = 30;
        uint256 second = 45;
        uint256 expectedTimestamp = 1696509045; // Example value, calculate the correct one
        uint256 timestamp = DateTimeLib.dateTimeToTimestamp(year, month, day, hour, minute, second);
        assertEq(timestamp, expectedTimestamp);
    }

    function testTimestampToDateTime() public {
        uint256 timestamp = 1696511445; // Example value, calculate the correct one
        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(timestamp);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 5);
        assertEq(hour, 13);
        assertEq(minute, 10);
        assertEq(second, 45);
    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(2020));
        assertFalse(DateTimeLib.isLeapYear(2021));
    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2023, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2020, 2), 29);
        assertEq(DateTimeLib.daysInMonth(2023, 1), 31);
    }

    function testWeekday() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedWeekday = 4; // Example value, calculate the correct one
        uint256 weekday = DateTimeLib.weekday(timestamp);
        assertEq(weekday, expectedWeekday);
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(2023, 10, 5));
        assertFalse(DateTimeLib.isSupportedDate(2023, 13, 5));
        assertFalse(DateTimeLib.isSupportedDate(2023, 2, 30));
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(2023, 10, 5, 12, 30, 45));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 13, 5, 12, 30, 45));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 2, 30, 12, 30, 45));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 10, 5, 25, 30, 45));
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(19683));
        assertFalse(DateTimeLib.isSupportedEpochDay(0x16d3e09803A));
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(1696464000));
        assertFalse(DateTimeLib.isSupportedTimestamp(0x1e18549868c7700));
    }

    function testNthWeekdayInMonthOfYearTimestamp() public {
        uint256 year = 2023;
        uint256 month = 10;
        uint256 n = 1;
        uint256 wd = 4;
        uint256 expectedTimestamp = 1696464000; // Example value, calculate the correct one
        uint256 timestamp = DateTimeLib.nthWeekdayInMonthOfYearTimestamp(year, month, n, wd);
        assertEq(timestamp, expectedTimestamp);
    }

    function testMondayTimestamp() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedMondayTimestamp = 1696204800; // Example value, calculate the correct one
        uint256 mondayTimestamp = DateTimeLib.mondayTimestamp(timestamp);
        assertEq(mondayTimestamp, expectedMondayTimestamp);
    }

    function testIsWeekEnd() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        assertFalse(DateTimeLib.isWeekEnd(timestamp));
        timestamp = 1696636800; // Example value, calculate the correct one
        assertTrue(DateTimeLib.isWeekEnd(timestamp));
    }

    function testAddYears() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1759622400; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.addYears(timestamp, 2);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testAddMonths() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1704412800; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.addMonths(timestamp, 3);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testAddDays() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1697068800; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.addDays(timestamp, 7);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testAddHours() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1696485600; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.addHours(timestamp, 6);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testAddMinutes() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1696467600; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.addMinutes(timestamp, 60);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testAddSeconds() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1696464060; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.addSeconds(timestamp, 60);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testSubYears() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1633392000; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.subYears(timestamp, 2);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testSubMonths() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1688515200; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.subMonths(timestamp, 3);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testSubDays() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1695859200; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.subDays(timestamp, 7);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testSubHours() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1696442400; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.subHours(timestamp, 6);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testSubMinutes() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1696460400; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.subMinutes(timestamp, 60);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testSubSeconds() public {
        uint256 timestamp = 1696464000; // Example value, calculate the correct one
        uint256 expectedTimestamp = 1696463940; // Example value, calculate the correct one
        uint256 newTimestamp = DateTimeLib.subSeconds(timestamp, 60);
        assertEq(newTimestamp, expectedTimestamp);
    }

    function testDiffYears() public {
        uint256 fromTimestamp = 1609459200; // Example value, calculate the correct one
        uint256 toTimestamp = 1672444800; // Example value, calculate the correct one
        uint256 expectedDiff = 1; // Example value, calculate the correct one
        uint256 diff = DateTimeLib.diffYears(fromTimestamp, toTimestamp);
        assertEq(diff, expectedDiff);
    }

    function testDiffMonths() public {
        uint256 fromTimestamp = 1609459200; // Example value, calculate the correct one
        uint256 toTimestamp = 1640995200; // Example value, calculate the correct one
        uint256 expectedDiff = 12; // Example value, calculate the correct one
        uint256 diff = DateTimeLib.diffMonths(fromTimestamp, toTimestamp);
        assertEq(diff, expectedDiff);
    }

    function testDiffDays() public {
        uint256 fromTimestamp = 1609459200; // Example value, calculate the correct one
        uint256 toTimestamp = 1612137600; // Example value, calculate the correct one
        uint256 expectedDiff = 31; // Example value, calculate the correct one
        uint256 diff = DateTimeLib.diffDays(fromTimestamp, toTimestamp);
        assertEq(diff, expectedDiff);
    }

    function testDiffHours() public {
        uint256 fromTimestamp = 1609459200; // Example value, calculate the correct one
        uint256 toTimestamp = 1609545600; // Example value, calculate the correct one
        uint256 expectedDiff = 24; // Example value, calculate the correct one
        uint256 diff = DateTimeLib.diffHours(fromTimestamp, toTimestamp);
        assertEq(diff, expectedDiff);
    }

    function testDiffMinutes() public {
        uint256 fromTimestamp = 1609459200; // Example value, calculate the correct one
        uint256 toTimestamp = 1609462800; // Example value, calculate the correct one
        uint256 expectedDiff = 60; // Example value, calculate the correct one
        uint256 diff = DateTimeLib.diffMinutes(fromTimestamp, toTimestamp);
        assertEq(diff, expectedDiff);
    }

    function testDiffSeconds() public {
        uint256 fromTimestamp = 1609459200; // Example value, calculate the correct one
        uint256 toTimestamp = 1609459260; // Example value, calculate the correct one
        uint256 expectedDiff = 60; // Example value, calculate the correct one
        uint256 diff = DateTimeLib.diffSeconds(fromTimestamp, toTimestamp);
        assertEq(diff, expectedDiff);
    }
}