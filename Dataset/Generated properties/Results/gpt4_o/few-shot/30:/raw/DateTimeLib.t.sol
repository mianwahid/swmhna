// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";

contract DateTimeLibTest is Test {
    using DateTimeLib for uint256;

    function testDateToEpochDay() public {
        assertEq(DateTimeLib.dateToEpochDay(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToEpochDay(2000, 1, 1), 10957);
        assertEq(DateTimeLib.dateToEpochDay(2023, 10, 1), 19654);
    }

    function testEpochDayToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(0);
        assertEq(year, 1970);
        assertEq(month, 1);
        assertEq(day, 1);

        (year, month, day) = DateTimeLib.epochDayToDate(10957);
        assertEq(year, 2000);
        assertEq(month, 1);
        assertEq(day, 1);

        (year, month, day) = DateTimeLib.epochDayToDate(19654);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 1);
    }

    function testDateToTimestamp() public {
        assertEq(DateTimeLib.dateToTimestamp(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToTimestamp(2000, 1, 1), 946684800);
        assertEq(DateTimeLib.dateToTimestamp(2023, 10, 1), 1696118400);
    }

    function testTimestampToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(0);
        assertEq(year, 1970);
        assertEq(month, 1);
        assertEq(day, 1);

        (year, month, day) = DateTimeLib.timestampToDate(946684800);
        assertEq(year, 2000);
        assertEq(month, 1);
        assertEq(day, 1);

        (year, month, day) = DateTimeLib.timestampToDate(1696118400);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 1);
    }

    function testDateTimeToTimestamp() public {
        assertEq(DateTimeLib.dateTimeToTimestamp(1970, 1, 1, 0, 0, 0), 0);
        assertEq(DateTimeLib.dateTimeToTimestamp(2000, 1, 1, 0, 0, 0), 946684800);
        assertEq(DateTimeLib.dateTimeToTimestamp(2023, 10, 1, 0, 0, 0), 1696118400);
    }

    function testTimestampToDateTime() public {
        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(0);
        assertEq(year, 1970);
        assertEq(month, 1);
        assertEq(day, 1);
        assertEq(hour, 0);
        assertEq(minute, 0);
        assertEq(second, 0);

        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(946684800);
        assertEq(year, 2000);
        assertEq(month, 1);
        assertEq(day, 1);
        assertEq(hour, 0);
        assertEq(minute, 0);
        assertEq(second, 0);

        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(1696118400);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 1);
        assertEq(hour, 0);
        assertEq(minute, 0);
        assertEq(second, 0);
    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(2000));
        assertFalse(DateTimeLib.isLeapYear(1900));
        assertTrue(DateTimeLib.isLeapYear(2020));
        assertFalse(DateTimeLib.isLeapYear(2021));
    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2020, 2), 29);
        assertEq(DateTimeLib.daysInMonth(2021, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2021, 1), 31);
        assertEq(DateTimeLib.daysInMonth(2021, 4), 30);
    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), DateTimeLib.THU);
        assertEq(DateTimeLib.weekday(946684800), DateTimeLib.SAT);
        assertEq(DateTimeLib.weekday(1696118400), DateTimeLib.SUN);
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(1970, 1, 1));
        assertTrue(DateTimeLib.isSupportedDate(2023, 10, 1));
        assertFalse(DateTimeLib.isSupportedDate(1969, 12, 31));
        assertFalse(DateTimeLib.isSupportedDate(2023, 13, 1));
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(1970, 1, 1, 0, 0, 0));
        assertTrue(DateTimeLib.isSupportedDateTime(2023, 10, 1, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(1969, 12, 31, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 13, 1, 0, 0, 0));
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(0));
        assertTrue(DateTimeLib.isSupportedEpochDay(19654));
        assertFalse(DateTimeLib.isSupportedEpochDay(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY + 1));
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(0));
        assertTrue(DateTimeLib.isSupportedTimestamp(1696118400));
        assertFalse(DateTimeLib.isSupportedTimestamp(DateTimeLib.MAX_SUPPORTED_TIMESTAMP + 1));
    }

    function testNthWeekdayInMonthOfYearTimestamp() public {
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2022, 2, 3, DateTimeLib.FRI), 1645833600);
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 10, 1, DateTimeLib.SUN), 1696118400);
    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(1696118400), 1695686400);
        assertEq(DateTimeLib.mondayTimestamp(946684800), 946598400);
    }

    function testIsWeekEnd() public {
        assertTrue(DateTimeLib.isWeekEnd(1696118400));
        assertFalse(DateTimeLib.isWeekEnd(1695686400));
    }

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(946684800, 1), 978307200);
        assertEq(DateTimeLib.addYears(1696118400, 2), 1767225600);
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(946684800, 1), 949363200);
        assertEq(DateTimeLib.addMonths(1696118400, 2), 1701388800);
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(946684800, 1), 946771200);
        assertEq(DateTimeLib.addDays(1696118400, 2), 1696281600);
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(946684800, 1), 946688400);
        assertEq(DateTimeLib.addHours(1696118400, 2), 1696125600);
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(946684800, 1), 946684860);
        assertEq(DateTimeLib.addMinutes(1696118400, 2), 1696118520);
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(946684800, 1), 946684801);
        assertEq(DateTimeLib.addSeconds(1696118400, 2), 1696118402);
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(978307200, 1), 946684800);
        assertEq(DateTimeLib.subYears(1767225600, 2), 1696118400);
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(949363200, 1), 946684800);
        assertEq(DateTimeLib.subMonths(1701388800, 2), 1696118400);
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(946771200, 1), 946684800);
        assertEq(DateTimeLib.subDays(1696281600, 2), 1696118400);
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(946688400, 1), 946684800);
        assertEq(DateTimeLib.subHours(1696125600, 2), 1696118400);
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(946684860, 1), 946684800);
        assertEq(DateTimeLib.subMinutes(1696118520, 2), 1696118400);
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(946684801, 1), 946684800);
        assertEq(DateTimeLib.subSeconds(1696118402, 2), 1696118400);
    }

    function testDiffYears() public {
        assertEq(DateTimeLib.diffYears(946684800, 978307200), 1);
        assertEq(DateTimeLib.diffYears(1696118400, 1767225600), 2);
    }

    function testDiffMonths() public {
        assertEq(DateTimeLib.diffMonths(946684800, 949363200), 1);
        assertEq(DateTimeLib.diffMonths(1696118400, 1701388800), 2);
    }

    function testDiffDays() public {
        assertEq(DateTimeLib.diffDays(946684800, 946771200), 1);
        assertEq(DateTimeLib.diffDays(1696118400, 1696281600), 2);
    }

    function testDiffHours() public {
        assertEq(DateTimeLib.diffHours(946684800, 946688400), 1);
        assertEq(DateTimeLib.diffHours(1696118400, 1696125600), 2);
    }

    function testDiffMinutes() public {
        assertEq(DateTimeLib.diffMinutes(946684800, 946684860), 1);
        assertEq(DateTimeLib.diffMinutes(1696118400, 1696118520), 2);
    }

    function testDiffSeconds() public {
        assertEq(DateTimeLib.diffSeconds(946684800, 946684801), 1);
        assertEq(DateTimeLib.diffSeconds(1696118400, 1696118402), 2);
    }
}