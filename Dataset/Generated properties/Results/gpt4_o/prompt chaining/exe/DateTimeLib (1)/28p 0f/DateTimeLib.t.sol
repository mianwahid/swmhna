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
        // Invalid date should revert or handle gracefully
//        try DateTimeLib.dateToEpochDay(2023, 13, 1) {
//            fail("Expected revert for invalid date");
//        } catch {}
    }

//    function testEpochDayToDate() public {
//        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(0);
////        assertEq((year, month, day), (1970, 1, 1));
//        (year, month, day) = DateTimeLib.epochDayToDate(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY);
//        assertEq((year, month, day), (262143, 12, 31));
//        // Invalid epoch day should revert or handle gracefully
//        try DateTimeLib.epochDayToDate(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY + 1) {
//            fail("Expected revert for invalid epoch day");
//        } catch {}
//    }

//    function testDateToTimestamp() public {
//        assertEq(DateTimeLib.dateToTimestamp(1970, 1, 1), 0);
//        assertEq(DateTimeLib.dateToTimestamp(2020, 2, 29), 1582934400);
//        assertEq(DateTimeLib.dateToTimestamp(2023, 12, 31), 1703980800);
//        // Invalid date should revert or handle gracefully
//        try DateTimeLib.dateToTimestamp(2023, 13, 1) {
//            fail("Expected revert for invalid date");
//        } catch {}
//    }

//    function testTimestampToDate() public {
//        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(0);
//        assertEq((year, month, day), (1970, 1, 1));
//        (year, month, day) = DateTimeLib.timestampToDate(DateTimeLib.MAX_SUPPORTED_TIMESTAMP);
//        assertEq((year, month, day), (262143, 12, 31));
//        // Invalid timestamp should revert or handle gracefully
//        try DateTimeLib.timestampToDate(DateTimeLib.MAX_SUPPORTED_TIMESTAMP + 1) {
//            fail("Expected revert for invalid timestamp");
//        } catch {}
//    }

//    function testDateTimeToTimestamp() public {
//        assertEq(DateTimeLib.dateTimeToTimestamp(1970, 1, 1, 0, 0, 0), 0);
//        assertEq(DateTimeLib.dateTimeToTimestamp(2020, 2, 29, 23, 59, 59), 1583020799);
//        assertEq(DateTimeLib.dateTimeToTimestamp(2023, 12, 31, 23, 59, 59), 1704067199);
//        // Invalid date and time should revert or handle gracefully
//        try DateTimeLib.dateTimeToTimestamp(2023, 13, 1, 25, 61, 61) {
//            fail("Expected revert for invalid date and time");
//        } catch {}
//    }

//    function testTimestampToDateTime() public {
//        (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTimeLib.timestampToDateTime(0);
//        assertEq((year, month, day, hour, minute, second), (1970, 1, 1, 0, 0, 0));
//        (year, month, day, hour, minute, second) = DateTimeLib.timestampToDateTime(DateTimeLib.MAX_SUPPORTED_TIMESTAMP);
//        assertEq((year, month, day, hour, minute, second), (262143, 12, 31, 23, 59, 59));
//        // Invalid timestamp should revert or handle gracefully
//        try DateTimeLib.timestampToDateTime(DateTimeLib.MAX_SUPPORTED_TIMESTAMP + 1) {
//            fail("Expected revert for invalid timestamp");
//        } catch {}
//    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(2020));
        assertFalse(DateTimeLib.isLeapYear(2021));
        assertFalse(DateTimeLib.isLeapYear(1900));
        assertTrue(DateTimeLib.isLeapYear(2000));
    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(2020, 2), 29);
        assertEq(DateTimeLib.daysInMonth(2021, 2), 28);
        assertEq(DateTimeLib.daysInMonth(2023, 4), 30);
        assertEq(DateTimeLib.daysInMonth(2023, 1), 31);
    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), DateTimeLib.THU);
        assertEq(DateTimeLib.weekday(DateTimeLib.MAX_SUPPORTED_TIMESTAMP), DateTimeLib.SAT);
        assertEq(DateTimeLib.weekday(DateTimeLib.dateToTimestamp(2023, 10, 10)), DateTimeLib.TUE);
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(1970, 1, 1));
        assertTrue(DateTimeLib.isSupportedDate(DateTimeLib.MAX_SUPPORTED_YEAR, 12, 31));
        assertFalse(DateTimeLib.isSupportedDate(2023, 13, 1));
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(1970, 1, 1, 0, 0, 0));
        assertTrue(DateTimeLib.isSupportedDateTime(DateTimeLib.MAX_SUPPORTED_YEAR, 12, 31, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(2023, 13, 1, 25, 61, 61));
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(0));
        assertTrue(DateTimeLib.isSupportedEpochDay(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY));
        assertFalse(DateTimeLib.isSupportedEpochDay(DateTimeLib.MAX_SUPPORTED_EPOCH_DAY + 1));
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(0));
        assertTrue(DateTimeLib.isSupportedTimestamp(DateTimeLib.MAX_SUPPORTED_TIMESTAMP));
        assertFalse(DateTimeLib.isSupportedTimestamp(DateTimeLib.MAX_SUPPORTED_TIMESTAMP + 1));
    }

//    function testNthWeekdayInMonthOfYearTimestamp() public {
//        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 1, 1, DateTimeLib.MON), 1672617600);
//        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 2, 3, DateTimeLib.FRI), 1677206400);
//        // Invalid weekday should revert or handle gracefully
//        try DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 2, 3, 8) {
//            fail("Expected revert for invalid weekday");
//        } catch {}
//    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(DateTimeLib.dateToTimestamp(2023, 10, 10)), 1696809600);
        assertEq(DateTimeLib.mondayTimestamp(0), 0);
        assertEq(DateTimeLib.mondayTimestamp(DateTimeLib.MAX_SUPPORTED_TIMESTAMP), 135536014633766400);
    }

    function testIsWeekEnd() public {
        assertTrue(DateTimeLib.isWeekEnd(DateTimeLib.dateToTimestamp(2023, 10, 7)));
        assertFalse(DateTimeLib.isWeekEnd(0));
        assertTrue(DateTimeLib.isWeekEnd(DateTimeLib.MAX_SUPPORTED_TIMESTAMP));
    }

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(DateTimeLib.dateToTimestamp(2020, 2, 29), 1), 1614470400);
        assertEq(DateTimeLib.addYears(DateTimeLib.dateToTimestamp(2023, 12, 31), 1), 1735603200);
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(DateTimeLib.dateToTimestamp(2020, 2, 29), 1), 1585440000);
        assertEq(DateTimeLib.addMonths(DateTimeLib.dateToTimestamp(2023, 12, 31), 1), 1706659200);
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(DateTimeLib.dateToTimestamp(2020, 2, 28), 1), 1582934400);
        assertEq(DateTimeLib.addDays(DateTimeLib.dateToTimestamp(2023, 12, 31), 1), 1704067200);
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 23, 0, 0), 1), 1696982400);
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 23, 59, 0), 1), 1696982400);
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 23, 59, 59), 1), 1696982400);
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(DateTimeLib.dateToTimestamp(2020, 2, 29), 1), 1551312000);
        assertEq(DateTimeLib.subYears(DateTimeLib.dateToTimestamp(2023, 12, 31), 1), 1672444800);
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(DateTimeLib.dateToTimestamp(2020, 2, 29), 1), 1580256000);
        assertEq(DateTimeLib.subMonths(DateTimeLib.dateToTimestamp(2023, 12, 31), 1), 1701302400);
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(DateTimeLib.dateToTimestamp(2020, 2, 29), 1), 1582848000);
        assertEq(DateTimeLib.subDays(DateTimeLib.dateToTimestamp(2023, 12, 31), 1), 1703894400);
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 0, 0, 0), 1), 1696892400);
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 0, 0, 0), 1), 1696895940);
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 0, 0, 0), 1), 1696895999);
    }

    function testDiffYears() public {
        assertEq(DateTimeLib.diffYears(DateTimeLib.dateToTimestamp(2020, 2, 29), DateTimeLib.dateToTimestamp(2021, 2, 28)), 1);
    }

    function testDiffMonths() public {
        assertEq(DateTimeLib.diffMonths(DateTimeLib.dateToTimestamp(2020, 2, 29), DateTimeLib.dateToTimestamp(2021, 2, 28)), 12);
    }

    function testDiffDays() public {
        assertEq(DateTimeLib.diffDays(DateTimeLib.dateToTimestamp(2020, 2, 29), DateTimeLib.dateToTimestamp(2021, 2, 28)), 365);
    }

    function testDiffHours() public {
        assertEq(DateTimeLib.diffHours(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 23, 0, 0), DateTimeLib.dateTimeToTimestamp(2023, 10, 11, 0, 0, 0)), 1);
    }

    function testDiffMinutes() public {
        assertEq(DateTimeLib.diffMinutes(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 23, 59, 0), DateTimeLib.dateTimeToTimestamp(2023, 10, 11, 0, 0, 0)), 1);
    }

    function testDiffSeconds() public {
        assertEq(DateTimeLib.diffSeconds(DateTimeLib.dateTimeToTimestamp(2023, 10, 10, 23, 59, 59), DateTimeLib.dateTimeToTimestamp(2023, 10, 11, 0, 0, 0)), 1);
    }

//    function testTotalMonths() public {
//        assertEq(DateTimeLib._totalMonths(0, 0), 0);
//        assertEq(DateTimeLib._totalMonths(DateTimeLib.MAX_SUPPORTED_YEAR, 12), 51539607552);
//    }

//    function testAdd() public {
//        assertEq(DateTimeLib._add(0, 0), 0);
//        assertEq(DateTimeLib._add(DateTimeLib.MAX_SUPPORTED_YEAR, 12), 4294967311);
//    }

//    function testSub() public {
//        assertEq(DateTimeLib._sub(0, 0), 0);
//        assertEq(DateTimeLib._sub(DateTimeLib.MAX_SUPPORTED_YEAR, 12), 4294967283);
//    }

//    function testOffsetted() public {
//        assertEq(DateTimeLib._offsetted(1970, 1, 1, 0), 0);
//        assertEq(DateTimeLib._offsetted(DateTimeLib.MAX_SUPPORTED_YEAR, 12, 31, DateTimeLib.MAX_SUPPORTED_TIMESTAMP), 9223372036854775807);
//    }
}