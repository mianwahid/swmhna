// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";

contract DateTimeLibTest is Test {
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
        assertEq(DateTimeLib.dateToEpochDay(2023, 10, 27), 19723);
    }



    function testDateToTimestamp() public {
        assertEq(DateTimeLib.dateToTimestamp(1970, 1, 1), 0);
        assertEq(DateTimeLib.dateToTimestamp(2023, 10, 27), 1703814400);
    }

    function testTimestampToDate() public {
//        assertEq(DateTimeLib.timestampToDate(0), (1970, 1, 1));
//        assertEq(DateTimeLib.timestampToDate(1703814400), (2023, 10, 27));
    }

    function testDateTimeToTimestamp() public {
        assertEq(DateTimeLib.dateTimeToTimestamp(1970, 1, 1, 0, 0, 0), 0);
        assertEq(
            DateTimeLib.dateTimeToTimestamp(2023, 10, 27, 12, 34, 56),
            1703859296
        );
    }

    function testTimestampToDateTime() public {
//        assertEq(
//            DateTimeLib.timestampToDateTime(0),
//            (1970, 1, 1, 0, 0, 0)
//        );
        assertEq(
            DateTimeLib.timestampToDateTime(1703859296),
            (2023, 10, 27, 12, 34, 56)
        );
    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), 4); // Thursday
        assertEq(DateTimeLib.weekday(1703814400), 5); // Friday
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(1970, 1, 1));
        assertTrue(DateTimeLib.isSupportedDate(2023, 10, 27));
        assertFalse(DateTimeLib.isSupportedDate(1969, 12, 31));
        assertFalse(
            DateTimeLib.isSupportedDate(
                DateTimeLib.MAX_SUPPORTED_YEAR + 1,
                12,
                31
            )
        );
    }

    function testIsSupportedDateTime() public {
        assertTrue(DateTimeLib.isSupportedDateTime(1970, 1, 1, 0, 0, 0));
        assertTrue(DateTimeLib.isSupportedDateTime(2023, 10, 27, 23, 59, 59));
        assertFalse(DateTimeLib.isSupportedDateTime(1969, 12, 31, 0, 0, 0));
        assertFalse(
            DateTimeLib.isSupportedDateTime(
                DateTimeLib.MAX_SUPPORTED_YEAR + 1,
                12,
                31,
                0,
                0,
                0
            )
        );
    }

    function testIsSupportedEpochDay() public {
        assertTrue(DateTimeLib.isSupportedEpochDay(0));
        assertTrue(DateTimeLib.isSupportedEpochDay(19723));
        assertFalse(
            DateTimeLib.isSupportedEpochDay(
                DateTimeLib.MAX_SUPPORTED_EPOCH_DAY + 1
            )
        );
    }

    function testIsSupportedTimestamp() public {
        assertTrue(DateTimeLib.isSupportedTimestamp(0));
        assertTrue(DateTimeLib.isSupportedTimestamp(1703859296));
        assertFalse(
            DateTimeLib.isSupportedTimestamp(
                DateTimeLib.MAX_SUPPORTED_TIMESTAMP + 1
            )
        );
    }

    function testNthWeekdayInMonthOfYearTimestamp() public {
        assertEq(
            DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 10, 3, 5),
            1703641600
        ); // 3rd Friday of Oct 2023
        assertEq(
            DateTimeLib.nthWeekdayInMonthOfYearTimestamp(2023, 10, 5, 7),
            0
        ); // 5th Sunday of Oct 2023 (does not exist)
    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(1703859296), 1703497600); // Monday of the week of timestamp 1703859296
    }

    function testIsWeekEnd() public {
        assertTrue(DateTimeLib.isWeekEnd(1704118400)); // Saturday, October 28, 2023
        assertTrue(DateTimeLib.isWeekEnd(1704204800)); // Sunday, October 29, 2023
        assertFalse(DateTimeLib.isWeekEnd(1703859296)); // Friday, October 27, 2023
    }

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(0, 1), 31536000);
        assertEq(DateTimeLib.addYears(1703814400, 10), 2028814400);
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(0, 1), 2678400);
        assertEq(DateTimeLib.addMonths(1703814400, 5), 1716892800);
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(0, 1), 86400);
        assertEq(DateTimeLib.addDays(1703814400, 10), 1704678400);
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(0, 1), 3600);
        assertEq(DateTimeLib.addHours(1703814400, 10), 1703850400);
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(0, 1), 60);
        assertEq(DateTimeLib.addMinutes(1703814400, 10), 1703815000);
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(0, 1), 1);
        assertEq(DateTimeLib.addSeconds(1703814400, 10), 1703814410);
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(31536000, 1), 0);
        assertEq(DateTimeLib.subYears(1703814400, 10), 1388714400);
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(2678400, 1), 0);
        assertEq(DateTimeLib.subMonths(1703814400, 5), 1690732800);
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(86400, 1), 0);
        assertEq(DateTimeLib.subDays(1703814400, 10), 1702950400);
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(3600, 1), 0);
        assertEq(DateTimeLib.subHours(1703814400, 10), 1703778400);
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(60, 1), 0);
        assertEq(DateTimeLib.subMinutes(1703814400, 10), 1703813800);
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(1, 1), 0);
        assertEq(DateTimeLib.subSeconds(1703814400, 10), 1703814390);
    }

    function testDiffYears() public {
        assertEq(DateTimeLib.diffYears(0, 31536000), 1);
        assertEq(DateTimeLib.diffYears(1703814400, 2028814400), 10);
    }

    function testDiffMonths() public {
        assertEq(DateTimeLib.diffMonths(0, 2678400), 1);
        assertEq(DateTimeLib.diffMonths(1703814400, 1716892800), 5);
    }

    function testDiffDays() public {
        assertEq(DateTimeLib.diffDays(0, 86400), 1);
        assertEq(DateTimeLib.diffDays(1703814400, 1704678400), 10);
    }

    function testDiffHours() public {
        assertEq(DateTimeLib.diffHours(0, 3600), 1);
        assertEq(DateTimeLib.diffHours(1703814400, 1703850400), 10);
    }

    function testDiffMinutes() public {
        assertEq(DateTimeLib.diffMinutes(0, 60), 1);
        assertEq(DateTimeLib.diffMinutes(1703814400, 1703815000), 10);
    }

    function testDiffSeconds() public {
        assertEq(DateTimeLib.diffSeconds(0, 1), 1);
        assertEq(DateTimeLib.diffSeconds(1703814400, 1703814410), 10);
    }
}
