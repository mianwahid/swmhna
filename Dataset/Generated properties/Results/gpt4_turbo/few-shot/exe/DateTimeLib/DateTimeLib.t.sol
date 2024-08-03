// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import "../src/utils/DateTimeLib.sol";

contract DateTimeLibTest is Test {
    function testDateToEpochDay() public {
        uint256 epochDay = DateTimeLib.dateToEpochDay(1970, 1, 1);
        assertEq(epochDay, 0, "1970-01-01 should be epoch day 0");

        epochDay = DateTimeLib.dateToEpochDay(2023, 3, 15);
        assertEq(epochDay, 19431, "2023-03-15 should be epoch day 19426");
    }

    function testEpochDayToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(0);
        assertEq(year, 1970, "Epoch day 0 should be year 1970");
        assertEq(month, 1, "Epoch day 0 should be month 1");
        assertEq(day, 1, "Epoch day 0 should be day 1");

        (year, month, day) = DateTimeLib.epochDayToDate(19426);
        assertEq(year, 2023, "Epoch day 19426 should be year 2023");
        assertEq(month, 3, "Epoch day 19426 should be month 3");
        assertEq(day, 10, "Epoch day 19426 should be day 10");
    }

    function testDateToTimestamp() public {
        uint256 timestamp = DateTimeLib.dateToTimestamp(1970, 1, 1);
        assertEq(timestamp, 0, "1970-01-01 should be timestamp 0");

        timestamp = DateTimeLib.dateToTimestamp(2023, 3, 15);
        assertEq(timestamp, 1678838400, "2023-03-15 should be timestamp 1678857600");
    }

    function testTimestampToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(0);
        assertEq(year, 1970, "Timestamp 0 should be year 1970");
        assertEq(month, 1, "Timestamp 0 should be month 1");
        assertEq(day, 1, "Timestamp 0 should be day 1");

        (year, month, day) = DateTimeLib.timestampToDate(1678857600);
        assertEq(year, 2023, "Timestamp 1678857600 should be year 2023");
        assertEq(month, 3, "Timestamp 1678857600 should be month 3");
        assertEq(day, 15, "Timestamp 1678857600 should be day 15");
    }

    function testIsLeapYear() public {
        bool leap = DateTimeLib.isLeapYear(2020);
        assertTrue(leap, "2020 should be a leap year");

        leap = DateTimeLib.isLeapYear(2021);
        assertFalse(leap, "2021 should not be a leap year");
    }

    function testDaysInMonth() public {
        uint256 day = DateTimeLib.daysInMonth(2021, 2);
        assertEq(day, 28, "February 2021 should have 28 days");

        day = DateTimeLib.daysInMonth(2020, 2);
        assertEq(day, 29, "February 2020 should have 29 days");
    }

    function testWeekday() public {
        uint256 wd = DateTimeLib.weekday(1678857600); // 2023-03-15
        assertEq(wd, 3, "2023-03-15 should be a Wednesday");
    }

    function testIsSupportedDate() public {
        bool supported = DateTimeLib.isSupportedDate(2023, 2, 29);
        assertFalse(supported, "2023-02-29 should not be supported");

        supported = DateTimeLib.isSupportedDate(2024, 2, 29);
        assertTrue(supported, "2024-02-29 should be supported");
    }

    function testAddYears() public {
        uint256 timestamp = DateTimeLib.dateToTimestamp(2020, 2, 29);
        uint256 newTimestamp = DateTimeLib.addYears(timestamp, 4);
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(newTimestamp);
        assertEq(year, 2024, "Adding 4 years to 2020-02-29 should result in 2024");
        assertEq(month, 2, "Adding 4 years to 2020-02-29 should result in February");
        assertEq(day, 29, "Adding 4 years to 2020-02-29 should result in 29th");
    }

    function testSubYears() public {
        uint256 timestamp = DateTimeLib.dateToTimestamp(2024, 2, 29);
        uint256 newTimestamp = DateTimeLib.subYears(timestamp, 4);
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(newTimestamp);
        assertEq(year, 2020, "Subtracting 4 years from 2024-02-29 should result in 2020");
        assertEq(month, 2, "Subtracting 4 years from 2024-02-29 should result in February");
        assertEq(day, 29, "Subtracting 4 years from 2024-02-29 should result in 29th");
    }

    function testDiffYears() public {
        uint256 fromTimestamp = DateTimeLib.dateToTimestamp(2020, 1, 1);
        uint256 toTimestamp = DateTimeLib.dateToTimestamp(2023, 1, 1);
        uint256 diff = DateTimeLib.diffYears(fromTimestamp, toTimestamp);
        assertEq(diff, 3, "Difference between 2020-01-01 and 2023-01-01 should be 3 years");
    }
}