// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";
contract DateTimeLibTest is Test {

//    function testNthWeekdayInMonthOfYearTimestamp(uint256 year, uint256 month, uint256 n, uint256 wd) public {
//        vm.assume(DateTimeLib.isSupportedDate(year, month, 1));
//        vm.assume(wd > 0 && wd <= 7);
//        DateTimeLib.nthWeekdayInMonthOfYearTimestamp(year, month, n, wd);
//    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2023, 1), 31);
        assertEq(DateTimeLib.daysInMonth(2023, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2024, 2), 29);
        assertEq(DateTimeLib.daysInMonth(2023, 3), 31);
        assertEq(DateTimeLib.daysInMonth(2023, 4), 30);
        assertEq(DateTimeLib.daysInMonth(2023, 5), 31);
        assertEq(DateTimeLib.daysInMonth(2023, 6), 30);
        assertEq(DateTimeLib.daysInMonth(2023, 7), 31);
        assertEq(DateTimeLib.daysInMonth(2023, 8), 31);
        assertEq(DateTimeLib.daysInMonth(2023, 9), 30);
        assertEq(DateTimeLib.daysInMonth(2023, 10), 31);
        assertEq(DateTimeLib.daysInMonth(2023, 11), 30);
        assertEq(DateTimeLib.daysInMonth(2023, 12), 31);
    }

    function testIsLeapYear() public {
        assertFalse(DateTimeLib.isLeapYear(2023));
        assertTrue(DateTimeLib.isLeapYear(2024));
        assertFalse(DateTimeLib.isLeapYear(2100));
        assertTrue(DateTimeLib.isLeapYear(2000));
    }

    function testDateToEpochDay() public {
        assertEq(DateTimeLib.dateToEpochDay(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToEpochDay(2023, 10, 27), 19657);
    }

//    function testEpochDayToDate() public {
//        assertEq(DateTimeLib.epochDayToDate(0), (1970, 1, 1));
//        assertEq(DateTimeLib.epochDayToDate(19999), (2023, 10, 27));
//    }

    function testDateToTimestamp() public {
        assertEq(DateTimeLib.dateToTimestamp(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToTimestamp(2023, 10, 27), 1698364800);
    }

//    function testTimestampToDate() public {
//        assertEq(DateTimeLib.timestampToDate(0), (1970, 1, 1));
//        assertEq(DateTimeLib.timestampToDate(1727424000), (2023, 10, 27));
//    }

    function testDateTimeToTimestamp() public {
        assertEq(DateTimeLib.dateTimeToTimestamp(1970, 1, 1, 0, 0, 0), 0);
        assertEq(DateTimeLib.dateTimeToTimestamp(2023, 10, 27, 12, 34, 56), 1698410096);
    }

//    function testTimestampToDateTime() public {
//        assertEq(DateTimeLib.timestampToDateTime(0), (1970, 1, 1, 0, 0, 0));
//        assertEq(DateTimeLib.timestampToDateTime(1727468956), (2023, 10, 27, 12, 34, 56));
//    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), 4);
        assertEq(DateTimeLib.weekday(1727424000), 5);
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(1970, 1, 1));
        assertTrue(DateTimeLib.isSupportedDate(2023, 10, 27));
        assertFalse(DateTimeLib.isSupportedDate(1969, 12, 31));
        assertFalse(DateTimeLib.isSupportedDate(2023, 10, 32));
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(1970, 1, 1, 0, 0, 0));
        assertTrue(DateTimeLib.isSupportedDateTime(2023, 10, 27, 12, 34, 56));
        assertFalse(DateTimeLib.isSupportedDateTime(1969, 12, 31, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 10, 27, 24, 0, 0));
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(0));
        assertTrue(DateTimeLib.isSupportedEpochDay(19999));
        assertFalse(DateTimeLib.isSupportedEpochDay(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY + 1));
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(0));
        assertTrue(DateTimeLib.isSupportedTimestamp(1727424000));
        assertFalse(DateTimeLib.isSupportedTimestamp(DateTimeLib.MAX_SUPPORTED_TIMESTAMP + 1));
    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(1727424000), 1727049600);
    }

    function testIsWeekEnd() public {
        assertFalse(DateTimeLib.isWeekEnd(1727424000));
        assertTrue(DateTimeLib.isWeekEnd(1727510400));
    }

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(1727424000, 1), 1758960000);
        assertEq(DateTimeLib.addYears(1727424000, 10), 2042956800);
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(1727424000, 1), 1730016000);
        assertEq(DateTimeLib.addMonths(1727424000, 12), 1758960000);
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(1727424000, 1), 1727510400);
        assertEq(DateTimeLib.addDays(1727424000, 365), 1758960000);
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(1727424000, 1), 1727427600);
        assertEq(DateTimeLib.addHours(1727424000, 24), 1727510400);
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(1727424000, 1), 1727424060);
        assertEq(DateTimeLib.addMinutes(1727424000, 60), 1727427600);
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(1727424000, 1), 1727424001);
        assertEq(DateTimeLib.addSeconds(1727424000, 60), 1727424060);
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(1727424000, 1), 1695801600);
        assertEq(DateTimeLib.subYears(1727424000, 10), 1411804800);
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(1727424000, 1), 1724745600);
        assertEq(DateTimeLib.subMonths(1727424000, 12), 1695801600);
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(1727424000, 1), 1727337600);
        assertEq(DateTimeLib.subDays(1727424000, 365), 1695888000);
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(1727424000, 1), 1727420400);
        assertEq(DateTimeLib.subHours(1727424000, 24), 1727337600);
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(1727424000, 1), 1727423940);
        assertEq(DateTimeLib.subMinutes(1727424000, 60), 1727420400);
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(1727424000, 1), 1727423999);
        assertEq(DateTimeLib.subSeconds(1727424000, 60), 1727423940);
    }

//    function testDiffYears() public {
//        assertEq(DateTimeLib.diffYears(1727424000, 1758854400), 1);
//        assertEq(DateTimeLib.diffYears(1727424000, 1706009600), 1);
//    }

//    function testDiffMonths() public {
//        assertEq(DateTimeLib.diffMonths(1727424000, 1730016000), 1);
//        assertEq(DateTimeLib.diffMonths(1727424000, 1724832000), 1);
//    }

//    function testDiffDays() public {
//        assertEq(DateTimeLib.diffDays(1727424000, 1727510400), 1);
//        assertEq(DateTimeLib.diffDays(1727424000, 1727337600), 1);
//    }
//
//    function testDiffHours() public {
//        assertEq(DateTimeLib.diffHours(1727424000, 1727427600), 1);
//        assertEq(DateTimeLib.diffHours(1727424000, 1727420400), 1);
//    }

//    function testDiffMinutes() public {
//        assertEq(DateTimeLib.diffMinutes(1727424000, 1727424060), 1);
//        assertEq(DateTimeLib.diffMinutes(1727424000, 1727423940), 1);
//    }
//
//    function testDiffSeconds() public {
//        assertEq(DateTimeLib.diffSeconds(1727424000, 1727424001), 1);
//        assertEq(DateTimeLib.diffSeconds(1727424000, 1727423999), 1);
//    }
}