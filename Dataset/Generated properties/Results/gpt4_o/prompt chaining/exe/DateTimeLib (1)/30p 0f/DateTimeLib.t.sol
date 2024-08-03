// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";

contract DateTimeLibTest is Test {
    using DateTimeLib for uint256;

    function testDateToEpochDay() public {
        assertEq(DateTimeLib.dateToEpochDay(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToEpochDay(2020, 2, 29), 18321);
        assertEq(DateTimeLib.dateToEpochDay(2023, 12, 31), 19722);
        // Invalid date should be handled gracefully
        // This will revert due to undefined behavior in the library
        // assertEq(DateTimeLib.dateToEpochDay(2023, 2, 30), 0);
    }

//    function testEpochDayToDate() public {
//        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(0);
////        assertEq((year, month, day), (1970, 1, 1));
//        (year, month, day) = DateTimeLib.epochDayToDate(18321);
//        assertEq((year, month, day), (2020, 2, 29));
//        (year, month, day) = DateTimeLib.epochDayToDate(19688);
//        assertEq((year, month, day), (2023, 12, 31));
//    }

    function testDateToTimestamp() public {
        assertEq(DateTimeLib.dateToTimestamp(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToTimestamp(2020, 2, 29), 1582934400);
        assertEq(DateTimeLib.dateToTimestamp(2023, 12, 31), 1703980800);
    }

//    function testTimestampToDate() public {
//        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(0);
//        assertEq((year, month, day), (1970, 1, 1));
//        (year, month, day) = DateTimeLib.timestampToDate(1582934400);
//        assertEq((year, month, day), (2020, 2, 29));
//        (year, month, day) = DateTimeLib.timestampToDate(1703980800);
//        assertEq((year, month, day), (2023, 12, 31));
//    }

    function testDateTimeToTimestamp() public {
        assertEq(DateTimeLib.dateTimeToTimestamp(1970, 1, 1, 0, 0, 0), 0);
        assertEq(DateTimeLib.dateTimeToTimestamp(2020, 2, 29, 12, 0, 0), 1582977600);
        assertEq(DateTimeLib.dateTimeToTimestamp(2023, 12, 31, 23, 59, 59), 1704067199);
    }

//    function testTimestampToDateTime() public {
//        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(0);
//        assertEq((year, month, day, hour, minute, second), (1970, 1, 1, 0, 0, 0));
//        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(1582977600);
//        assertEq((year, month, day, hour, minute, second), (2020, 2, 29, 12, 0, 0));
//        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(1704067199);
//        assertEq((year, month, day, hour, minute, second), (2023, 12, 31, 23, 59, 59));
//    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(2020));
        assertFalse(DateTimeLib.isLeapYear(2019));
        assertFalse(DateTimeLib.isLeapYear(1900));
        assertTrue(DateTimeLib.isLeapYear(2000));
    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2020, 2), 29);
        assertEq(DateTimeLib.daysInMonth(2019, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2023, 4), 30);
        assertEq(DateTimeLib.daysInMonth(2023, 1), 31);
    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), 4); // Thursday
        assertEq(DateTimeLib.weekday(1582934400), 6); // Saturday
        assertEq(DateTimeLib.weekday(1703980800), 7); // Sunday
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(1970, 1, 1));
        assertTrue(DateTimeLib.isSupportedDate(0xffffffff, 12, 31));
        assertFalse(DateTimeLib.isSupportedDate(2023, 2, 30));
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(1970, 1, 1, 0, 0, 0));
        assertTrue(DateTimeLib.isSupportedDateTime(0xffffffff, 12, 31, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 2, 30, 25, 61, 61));
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(0));
        assertTrue(DateTimeLib.isSupportedEpochDay(0x16d3e098039));
        assertFalse(DateTimeLib.isSupportedEpochDay(0x16d3e09803a));
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(0));
        assertTrue(DateTimeLib.isSupportedTimestamp(0x1e18549868c76ff));
        assertFalse(DateTimeLib.isSupportedTimestamp(0x1e18549868c7700));
    }

    function testNthWeekdayInMonthOfYearTimestamp() public {
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 1, 1, 1), 1672617600); // 1st Monday of January 2023
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2022, 2, 3, 5), 1645142400); // 3rd Friday of February 2022
        // Invalid weekday should be handled gracefully
        // This will revert due to undefined behavior in the library
        // assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 1, 1, 8), 0);
    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(1672617600), 1672617600); // Monday, January 2, 2023
        assertEq(DateTimeLib.mondayTimestamp(1672876800), 1672617600); // Wednesday, January 4, 2023
    }

//    function testIsWeekEnd() public {
//        assertFalse(DateTimeLib.isWeekEnd(1672876800)); // Wednesday, January 4, 2023
//        assertTrue(DateTimeLib.isWeekEnd(1672876800)); // Wednesday, January 4, 2023
//    }

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(1582934400, 1), 1614470400); // February 29, 2020 + 1 year
        assertEq(DateTimeLib.addYears(1703980800, 1), 1735603200); // December 31, 2023 + 1 year
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(1582934400, 1), 1585440000); // February 29, 2020 + 1 month
        assertEq(DateTimeLib.addMonths(1703980800, 1), 1706659200); // December 31, 2023 + 1 month
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(1582934400, 1), 1583020800); // February 29, 2020 + 1 day
        assertEq(DateTimeLib.addDays(1703980800, 1), 1704067200); // December 31, 2023 + 1 day
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(1582934400, 1), 1582938000); // February 29, 2020 + 1 hour
        assertEq(DateTimeLib.addHours(1703980800, 1), 1703984400); // December 31, 2023 + 1 hour
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(1582934400, 1), 1582934460); // February 29, 2020 + 1 minute
        assertEq(DateTimeLib.addMinutes(1703980800, 1), 1703980860); // December 31, 2023 + 1 minute
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(1582934400, 1), 1582934401); // February 29, 2020 + 1 second
        assertEq(DateTimeLib.addSeconds(1703980800, 1), 1703980801); // December 31, 2023 + 1 second
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(1582934400, 1), 1551312000); // February 29, 2020 - 1 year
        assertEq(DateTimeLib.subYears(1703980800, 1), 1672444800); // December 31, 2023 - 1 year
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(1582934400, 1), 1580256000); // February 29, 2020 - 1 month
        assertEq(DateTimeLib.subMonths(1703980800, 1), 1701302400); // December 31, 2023 - 1 month
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(1582934400, 1), 1582848000); // February 29, 2020 - 1 day
        assertEq(DateTimeLib.subDays(1703980800, 1), 1703894400); // December 31, 2023 - 1 day
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(1582934400, 1), 1582930800); // February 29, 2020 - 1 hour
        assertEq(DateTimeLib.subHours(1703980800, 1), 1703977200); // December 31, 2023 - 1 hour
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(1582934400, 1), 1582934340); // February 29, 2020 - 1 minute
        assertEq(DateTimeLib.subMinutes(1703980800, 1), 1703980740); // December 31, 2023 - 1 minute
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(1582934400, 1), 1582934399); // February 29, 2020 - 1 second
        assertEq(DateTimeLib.subSeconds(1703980800, 1), 1703980799); // December 31, 2023 - 1 second
    }

    function testDiffYears() public {
        assertEq(DateTimeLib.diffYears(1582934400, 1614470400), 1); // February 29, 2020 to February 28, 2021
        assertEq(DateTimeLib.diffYears(1703980800, 1735516800), 1); // December 31, 2023 to December 31, 2024
    }

    function testDiffMonths() public {
        assertEq(DateTimeLib.diffMonths(1582934400, 1585612800), 1); // February 29, 2020 to March 29, 2020
        assertEq(DateTimeLib.diffMonths(1703980800, 1706659200), 1); // December 31, 2023 to January 31, 2024
    }

    function testDiffDays() public {
        assertEq(DateTimeLib.diffDays(1582934400, 1583020800), 1); // February 29, 2020 to March 1, 2020
        assertEq(DateTimeLib.diffDays(1703980800, 1704067200), 1); // December 31, 2023 to January 1, 2024
    }

    function testDiffHours() public {
        assertEq(DateTimeLib.diffHours(1582934400, 1582938000), 1); // February 29, 2020, 00:00 to February 29, 2020, 01:00
        assertEq(DateTimeLib.diffHours(1703980800, 1703984400), 1); // December 31, 2023, 00:00 to December 31, 2023, 01:00
    }

    function testDiffMinutes() public {
        assertEq(DateTimeLib.diffMinutes(1582934400, 1582934460), 1); // February 29, 2020, 00:00 to February 29, 2020, 00:01
        assertEq(DateTimeLib.diffMinutes(1703980800, 1703980860), 1); // December 31, 2023, 00:00 to December 31, 2023, 00:01
    }

    function testDiffSeconds() public {
        assertEq(DateTimeLib.diffSeconds(1582934400, 1582934401), 1); // February 29, 2020, 00:00:00 to February 29, 2020, 00:00:01
        assertEq(DateTimeLib.diffSeconds(1703980800, 1703980801), 1); // December 31, 2023, 00:00:00 to December 31, 2023, 00:00:01
    }

//    function testTotalMonths() public {
//        assertEq(DateTimeLib._totalMonths(0, 0), 0);
//        assertEq(DateTimeLib._totalMonths(0xffffffff, 12), 0xffffffff * 12 + 12);
//    }
}