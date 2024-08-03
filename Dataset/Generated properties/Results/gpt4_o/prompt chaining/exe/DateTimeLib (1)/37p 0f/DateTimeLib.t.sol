// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";

contract DateTimeLibTest is Test {
    using DateTimeLib for uint256;

    function testWeekdaysConstants() public {
        assertEq(DateTimeLib.MON, 1);
        assertEq(DateTimeLib.TUE, 2);
        assertEq(DateTimeLib.WED, 3);
        assertEq(DateTimeLib.THU, 4);
        assertEq(DateTimeLib.FRI, 5);
        assertEq(DateTimeLib.SAT, 6);
        assertEq(DateTimeLib.SUN, 7);
    }

    function testMonthsConstants() public {
        assertEq(DateTimeLib.JAN, 1);
        assertEq(DateTimeLib.FEB, 2);
        assertEq(DateTimeLib.MAR, 3);
        assertEq(DateTimeLib.APR, 4);
        assertEq(DateTimeLib.MAY, 5);
        assertEq(DateTimeLib.JUN, 6);
        assertEq(DateTimeLib.JUL, 7);
        assertEq(DateTimeLib.AUG, 8);
        assertEq(DateTimeLib.SEP, 9);
        assertEq(DateTimeLib.OCT, 10);
        assertEq(DateTimeLib.NOV, 11);
        assertEq(DateTimeLib.DEC, 12);
    }

    function testLimitsConstants() public {
        assertEq(DateTimeLib.MAX_SUPPORTED_YEAR, 0xffffffff);
        assertEq(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY, 0x16d3e098039);
        assertEq(DateTimeLib.MAX_SUPPORTED_TIMESTAMP, 0x1e18549868c76ff);
    }

    function testDateToEpochDay() public {
        assertEq(DateTimeLib.dateToEpochDay(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToEpochDay(2000, 2, 29), 11016); // Leap year
        assertEq(DateTimeLib.dateToEpochDay(2023, 10, 1), 19631);
    }

    function testEpochDayToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(0);
        assertEq(year, 1970);
        assertEq(month, 1);
        assertEq(day, 1);

        (year, month, day) = DateTimeLib.epochDayToDate(11016);
        assertEq(year, 2000);
        assertEq(month, 2);
        assertEq(day, 29);

        (year, month, day) = DateTimeLib.epochDayToDate(19652);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 22);
    }

    function testDateToTimestamp() public {
        assertEq(DateTimeLib.dateToTimestamp(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToTimestamp(2000, 2, 29), 951782400); // Leap year
        assertEq(DateTimeLib.dateToTimestamp(2023, 10, 1), 1696118400);
    }

    function testTimestampToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(0);
        assertEq(year, 1970);
        assertEq(month, 1);
        assertEq(day, 1);

        (year, month, day) = DateTimeLib.timestampToDate(951782400);
        assertEq(year, 2000);
        assertEq(month, 2);
        assertEq(day, 29);

        (year, month, day) = DateTimeLib.timestampToDate(1696118400);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 1);
    }

    function testDateTimeToTimestamp() public {
        assertEq(DateTimeLib.dateTimeToTimestamp(1970, 1, 1, 0, 0, 0), 0);
        assertEq(DateTimeLib.dateTimeToTimestamp(2000, 2, 29, 12, 0, 0), 951825600); // Leap year
        assertEq(DateTimeLib.dateTimeToTimestamp(2023, 10, 1, 23, 59, 59), 1696204799);
    }

    function testTimestampToDateTime() public {
        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(0);
        assertEq(year, 1970);
        assertEq(month, 1);
        assertEq(day, 1);
        assertEq(hour, 0);
        assertEq(minute, 0);
        assertEq(second, 0);

        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(951825600);
        assertEq(year, 2000);
        assertEq(month, 2);
        assertEq(day, 29);
        assertEq(hour, 12);
        assertEq(minute, 0);
        assertEq(second, 0);

        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(1696204799);
        assertEq(year, 2023);
        assertEq(month, 10);
        assertEq(day, 1);
        assertEq(hour, 23);
        assertEq(minute, 59);
        assertEq(second, 59);
    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(2000));
        assertFalse(DateTimeLib.isLeapYear(1900));
        assertTrue(DateTimeLib.isLeapYear(2020));
        assertFalse(DateTimeLib.isLeapYear(2021));
    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2020, 2), 29); // Leap year
        assertEq(DateTimeLib.daysInMonth(2021, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2021, 1), 31);
        assertEq(DateTimeLib.daysInMonth(2021, 4), 30);
    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), 4); // Thursday
        assertEq(DateTimeLib.weekday(951782400), 2); // Tuesday
        assertEq(DateTimeLib.weekday(1696118400), 7); // Sunday
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(1970, 1, 1));
        assertTrue(DateTimeLib.isSupportedDate(2023, 10, 1));
        assertFalse(DateTimeLib.isSupportedDate(1969, 12, 31));
        assertFalse(DateTimeLib.isSupportedDate(2023, 2, 30));
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(1970, 1, 1, 0, 0, 0));
        assertTrue(DateTimeLib.isSupportedDateTime(2023, 10, 1, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(1969, 12, 31, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 2, 30, 0, 0, 0));
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(0));
        assertTrue(DateTimeLib.isSupportedEpochDay(19652));
        assertFalse(DateTimeLib.isSupportedEpochDay(0x16d3e09803A)); // Exceeds max supported epoch day
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(0));
        assertTrue(DateTimeLib.isSupportedTimestamp(1696118400));
        assertFalse(DateTimeLib.isSupportedTimestamp(0x1e18549868c7700)); // Exceeds max supported timestamp
    }

    function testNthWeekdayInMonthOfYearTimestamp() public {
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2022, 2, 3, 5), 1645142400); // 3rd Friday of Feb 2022
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 10, 1, 7), 1696118400); // 1st Sunday of Oct 2023
    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(0), 0);
        assertEq(DateTimeLib.mondayTimestamp(1696118400), 1695600000); // Most recent Monday from Oct 1, 2023
    }

    function testIsWeekEnd() public {
        assertTrue(DateTimeLib.isWeekEnd(1696118400)); // Sunday
        assertFalse(DateTimeLib.isWeekEnd(1695686400)); // Monday
    }

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(0, 1), 31536000); // 1 year
        assertEq(DateTimeLib.addYears(951782400, 1), 983318400); // Leap year
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(0, 1), 2678400); // 1 month
        assertEq(DateTimeLib.addMonths(951782400, 1), 954288000); // Leap year
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(0, 1), 86400); // 1 day
        assertEq(DateTimeLib.addDays(951782400, 1), 951868800); // Leap year
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(0, 1), 3600); // 1 hour
        assertEq(DateTimeLib.addHours(951782400, 1), 951786000); // Leap year
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(0, 1), 60); // 1 minute
        assertEq(DateTimeLib.addMinutes(951782400, 1), 951782460); // Leap year
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(0, 1), 1); // 1 second
        assertEq(DateTimeLib.addSeconds(951782400, 1), 951782401); // Leap year
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(31536000, 1), 0); // 1 year
        assertEq(DateTimeLib.subYears(983404800, 1), 951868800); // Leap year
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(2678400, 1), 0); // 1 month
        assertEq(DateTimeLib.subMonths(954374400, 1), 951782400); // Leap year
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(86400, 1), 0); // 1 day
        assertEq(DateTimeLib.subDays(951868800, 1), 951782400); // Leap year
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(3600, 1), 0); // 1 hour
        assertEq(DateTimeLib.subHours(951786000, 1), 951782400); // Leap year
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(60, 1), 0); // 1 minute
        assertEq(DateTimeLib.subMinutes(951782460, 1), 951782400); // Leap year
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(1, 1), 0); // 1 second
        assertEq(DateTimeLib.subSeconds(951782401, 1), 951782400); // Leap year
    }

    function testDiffYears() public {
        assertEq(DateTimeLib.diffYears(0, 31536000), 1); // 1 year
        assertEq(DateTimeLib.diffYears(951782400, 983404800), 1); // Leap year
    }

    function testDiffMonths() public {
        assertEq(DateTimeLib.diffMonths(0, 2678400), 1); // 1 month
        assertEq(DateTimeLib.diffMonths(951782400, 954374400), 1); // Leap year
    }

    function testDiffDays() public {
        assertEq(DateTimeLib.diffDays(0, 86400), 1); // 1 day
        assertEq(DateTimeLib.diffDays(951782400, 951868800), 1); // Leap year
    }

    function testDiffHours() public {
        assertEq(DateTimeLib.diffHours(0, 3600), 1); // 1 hour
        assertEq(DateTimeLib.diffHours(951782400, 951786000), 1); // Leap year
    }

    function testDiffMinutes() public {
        assertEq(DateTimeLib.diffMinutes(0, 60), 1); // 1 minute
        assertEq(DateTimeLib.diffMinutes(951782400, 951782460), 1); // Leap year
    }

    function testDiffSeconds() public {
        assertEq(DateTimeLib.diffSeconds(0, 1), 1); // 1 second
        assertEq(DateTimeLib.diffSeconds(951782400, 951782401), 1); // Leap year
    }
//
//    function testTotalMonths() public {
//        assertEq(DateTimeLib._totalMonths(1, 1), 13); // 1 year and 1 month
//        assertEq(DateTimeLib._totalMonths(0, 12), 12); // 12 months
//    }

//    function testAdd() public {
//        assertEq(DateTimeLib._add(1, 1), 2); // 1 + 1
//        assertEq(DateTimeLib._add(0, 0), 0); // 0 + 0
//    }

//    function testSub() public {
//        assertEq(DateTimeLib._sub(1, 1), 0); // 1 - 1
//        assertEq(DateTimeLib._sub(2, 1), 1); // 2 - 1
//    }

//    function testOffsetted() public {
//        assertEq(DateTimeLib._offsetted(1970, 1, 1, 0), 0); // 1970-01-01
//        assertEq(DateTimeLib._offsetted(2000, 2, 29, 951782400), 951782400); // Leap year
//    }
}