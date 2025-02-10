// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";
contract DateTimeLibTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    uint256 internal constant YEAR_1970 = 1970;
    uint256 internal constant YEAR_1996 = 1996;
    uint256 internal constant YEAR_2000 = 2000;
    uint256 internal constant YEAR_2023 = 2023;
    uint256 internal constant YEAR_2024 = 2024;

    uint256 internal constant MONTH_JAN = 1;
    uint256 internal constant MONTH_FEB = 2;
    uint256 internal constant MONTH_MAR = 3;
    uint256 internal constant MONTH_APR = 4;
    uint256 internal constant MONTH_MAY = 5;
    uint256 internal constant MONTH_JUN = 6;
    uint256 internal constant MONTH_JUL = 7;
    uint256 internal constant MONTH_AUG = 8;
    uint256 internal constant MONTH_SEP = 9;
    uint256 internal constant MONTH_OCT = 10;
    uint256 internal constant MONTH_NOV = 11;
    uint256 internal constant MONTH_DEC = 12;

    uint256 internal constant DAY_1 = 1;
    uint256 internal constant DAY_28 = 28;
    uint256 internal constant DAY_29 = 29;
    uint256 internal constant DAY_30 = 30;
    uint256 internal constant DAY_31 = 31;

    uint256 internal constant HOUR_0 = 0;
    uint256 internal constant HOUR_23 = 23;

    uint256 internal constant MINUTE_0 = 0;
    uint256 internal constant MINUTE_59 = 59;

    uint256 internal constant SECOND_0 = 0;
    uint256 internal constant SECOND_59 = 59;

    uint256 internal constant WEEKDAY_MON = 1;
    uint256 internal constant WEEKDAY_TUE = 2;
    uint256 internal constant WEEKDAY_WED = 3;
    uint256 internal constant WEEKDAY_THU = 4;
    uint256 internal constant WEEKDAY_FRI = 5;
    uint256 internal constant WEEKDAY_SAT = 6;
    uint256 internal constant WEEKDAY_SUN = 7;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    DATE TIME OPERATIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testDateToEpochDay() public {
        assertEq(DateTimeLib.dateToEpochDay(YEAR_1970, MONTH_JAN, DAY_1), 0);
        assertEq(DateTimeLib.dateToEpochDay(YEAR_1996, MONTH_FEB, DAY_29), 9555);
        assertEq(DateTimeLib.dateToEpochDay(YEAR_2000, MONTH_FEB, DAY_29), 11016);
        assertEq(DateTimeLib.dateToEpochDay(YEAR_2023, MONTH_DEC, DAY_31), 19722);
        assertEq(DateTimeLib.dateToEpochDay(YEAR_2024, MONTH_FEB, DAY_29), 19782);
    }

//    function testEpochDayToDate() public {
////        assertEq(DateTimeLib.epochDayToDate(0), (YEAR_1970, MONTH_JAN, DAY_1));
//        assertEq(DateTimeLib.epochDayToDate(9517), (YEAR_1996, MONTH_FEB, DAY_29));
//        assertEq(DateTimeLib.epochDayToDate(11016), (YEAR_2000, MONTH_FEB, DAY_29));
//        assertEq(DateTimeLib.epochDayToDate(19892), (YEAR_2023, MONTH_DEC, DAY_31));
//        assertEq(DateTimeLib.epochDayToDate(19981), (YEAR_2024, MONTH_FEB, DAY_29));
//    }

    function testDateToTimestamp() public {
        assertEq(DateTimeLib.dateToTimestamp(YEAR_1970, MONTH_JAN, DAY_1), 0);
        assertEq(DateTimeLib.dateToTimestamp(YEAR_2024, MONTH_FEB, DAY_29), 1709164800);
    }

//    function testTimestampToDate() public {
//        assertEq(DateTimeLib.timestampToDate(0), (YEAR_1970, MONTH_JAN, DAY_1));
//        assertEq(DateTimeLib.timestampToDate(1714060800), (YEAR_2024, MONTH_FEB, DAY_29));
//    }

    function testDateTimeToTimestamp() public {
        assertEq(
            DateTimeLib.dateTimeToTimestamp(YEAR_1970, MONTH_JAN, DAY_1, HOUR_0, MINUTE_0, SECOND_0),
            0
        );
        assertEq(
            DateTimeLib.dateTimeToTimestamp(
                YEAR_2024,
                MONTH_FEB,
                DAY_29,
                HOUR_23,
                MINUTE_59,
                SECOND_59
            ),
            1709251199
        );
    }

//    function testTimestampToDateTime() public {
//        assertEq(
//            DateTimeLib.timestampToDateTime(0),
//            (YEAR_1970, MONTH_JAN, DAY_1, HOUR_0, MINUTE_0, SECOND_0)
//        );
//        assertEq(
//            DateTimeLib.timestampToDateTime(1714147199),
//            (YEAR_2024, MONTH_FEB, DAY_29, HOUR_23, MINUTE_59, SECOND_59)
//        );
//    }

    function testIsLeapYear() public {
        assertTrue(DateTimeLib.isLeapYear(YEAR_1996));
        assertTrue(DateTimeLib.isLeapYear(YEAR_2000));
        assertFalse(DateTimeLib.isLeapYear(YEAR_1970));
        assertFalse(DateTimeLib.isLeapYear(YEAR_2023));
    }

    function testDaysInMonth() public {
        assertEq(DateTimeLib.daysInMonth(YEAR_2024, MONTH_FEB), 29);
        assertEq(DateTimeLib.daysInMonth(YEAR_2023, MONTH_FEB), 28);
        assertEq(DateTimeLib.daysInMonth(YEAR_2023, MONTH_APR), 30);
        assertEq(DateTimeLib.daysInMonth(YEAR_2023, MONTH_JAN), 31);
    }

    function testWeekday() public {
        assertEq(DateTimeLib.weekday(0), WEEKDAY_THU);
        assertEq(DateTimeLib.weekday(1714060800), WEEKDAY_THU);
    }

    function testIsSupportedDate() public {
        assertTrue(DateTimeLib.isSupportedDate(YEAR_1970, MONTH_JAN, DAY_1));
        assertTrue(DateTimeLib.isSupportedDate(YEAR_2024, MONTH_FEB, DAY_29));
        assertFalse(DateTimeLib.isSupportedDate(1969, MONTH_DEC, DAY_31));
        assertFalse(DateTimeLib.isSupportedDate(DateTimeLib.MAX_SUPPORTED_YEAR + 1, 1, 1));
    }

    function testIsSupportedDateTime() public {
        assertTrue(
            DateTimeLib.isSupportedDateTime(
                YEAR_1970,
                MONTH_JAN,
                DAY_1,
                HOUR_0,
                MINUTE_0,
                SECOND_0
            )
        );
        assertTrue(
            DateTimeLib.isSupportedDateTime(
                YEAR_2024,
                MONTH_FEB,
                DAY_29,
                HOUR_23,
                MINUTE_59,
                SECOND_59
            )
        );
        assertFalse(
            DateTimeLib.isSupportedDateTime(
                1969,
                MONTH_DEC,
                DAY_31,
                HOUR_0,
                MINUTE_0,
                SECOND_0
            )
        );
        assertFalse(
            DateTimeLib.isSupportedDateTime(
                DateTimeLib.MAX_SUPPORTED_YEAR + 1,
                1,
                1,
                HOUR_0,
                MINUTE_0,
                SECOND_0
            )
        );
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

    function testNthWeekdayInMonthOfYearTimestamp() public {
        assertEq(
            DateTimeLib.nthWeekdayInMonthOfYearTimestamp(YEAR_2024, MONTH_FEB, 3, WEEKDAY_FRI),
            1708041600
        );
        assertEq(DateTimeLib.nthWeekdayInMonthOfYearTimestamp(YEAR_2024, MONTH_MAR, 5, WEEKDAY_FRI), 1711670400);
    }

    function testMondayTimestamp() public {
        assertEq(DateTimeLib.mondayTimestamp(1714060800), 1713744000);
    }

//    function testIsWeekEnd() public {
//        assertTrue(DateTimeLib.isWeekEnd(1714147200));
////        assertFalse(DateTimeLib.isWeekEnd(1714060800));
//    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              DATE TIME ARITHMETIC OPERATIONS               */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testAddYears() public {
        assertEq(DateTimeLib.addYears(1714060800, 10), 2029593600);
    }

    function testAddMonths() public {
        assertEq(DateTimeLib.addMonths(1714060800, 1), 1716652800);
    }

    function testAddDays() public {
        assertEq(DateTimeLib.addDays(1714060800, 10), 1714924800);
    }

    function testAddHours() public {
        assertEq(DateTimeLib.addHours(1714060800, 10), 1714096800);
    }

    function testAddMinutes() public {
        assertEq(DateTimeLib.addMinutes(1714060800, 10), 1714061400);
    }

    function testAddSeconds() public {
        assertEq(DateTimeLib.addSeconds(1714060800, 10), 1714060810);
    }

    function testSubYears() public {
        assertEq(DateTimeLib.subYears(1714060800, 10), 1398441600);
    }

    function testSubMonths() public {
        assertEq(DateTimeLib.subMonths(1714060800, 1), 1711382400);
    }

    function testSubDays() public {
        assertEq(DateTimeLib.subDays(1714060800, 10), 1713196800);
    }

    function testSubHours() public {
        assertEq(DateTimeLib.subHours(1714060800, 10), 1714024800);
    }

    function testSubMinutes() public {
        assertEq(DateTimeLib.subMinutes(1714060800, 10), 1714060200);
    }

    function testSubSeconds() public {
        assertEq(DateTimeLib.subSeconds(1714060800, 10), 1714060790);
    }

    function testDiffYears() public {
        assertEq(DateTimeLib.diffYears(1714060800, 1945366400), 7);
    }

    function testDiffMonths() public {
        assertEq(DateTimeLib.diffMonths(1714060800, 1716652800), 1);
    }

    function testDiffDays() public {
        assertEq(DateTimeLib.diffDays(1714060800, 1714924800), 10);
    }

    function testDiffHours() public {
        assertEq(DateTimeLib.diffHours(1714060800, 1714096800), 10);
    }

    function testDiffMinutes() public {
        assertEq(DateTimeLib.diffMinutes(1714060800, 1714061400), 10);
    }

    function testDiffSeconds() public {
        assertEq(DateTimeLib.diffSeconds(1714060800, 1714060810), 10);
    }
}