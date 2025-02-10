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
        uint256 expectedEpochDay = 19431; // Calculated from an external source
        assertEq(epochDay, expectedEpochDay, "Mismatch in calculated epoch days for 2023-03-15");
    }

    function testEpochDayToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.epochDayToDate(0);
        assertEq(year, 1970, "Year should be 1970 for epoch day 0");
        assertEq(month, 1, "Month should be 1 for epoch day 0");
        assertEq(day, 1, "Day should be 1 for epoch day 0");

        (year, month, day) = DateTimeLib.epochDayToDate(19448);
        assertEq(year, 2023, "Year should be 2023 for epoch day 19448");
        assertEq(month, 4, "Month should be 3 for epoch day 19448");
        assertEq(day, 1, "Day should be 15 for epoch day 19448");
    }

    function testDateToTimestamp() public {
        uint256 timestamp = DateTimeLib.dateToTimestamp(1970, 1, 1);
        assertEq(timestamp, 0, "1970-01-01 should be timestamp 0");

        timestamp = DateTimeLib.dateToTimestamp(2023, 3, 15);
        uint256 expectedTimestamp = 1678838400; // Calculated from an external source
        assertEq(timestamp, expectedTimestamp, "Mismatch in calculated timestamp for 2023-03-15");
    }

    function testTimestampToDate() public {
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(0);
        assertEq(year, 1970, "Year should be 1970 for timestamp 0");
        assertEq(month, 1, "Month should be 1 for timestamp 0");
        assertEq(day, 1, "Day should be 1 for timestamp 0");

        (year, month, day) = DateTimeLib.timestampToDate(1678857600);
        assertEq(year, 2023, "Year should be 2023 for timestamp 1678857600");
        assertEq(month, 3, "Month should be 3 for timestamp 1678857600");
        assertEq(day, 15, "Day should be 15 for timestamp 1678857600");
    }

    function testIsLeapYear() public {
        bool isLeap = DateTimeLib.isLeapYear(2020);
        assertTrue(isLeap, "2020 should be a leap year");

        isLeap = DateTimeLib.isLeapYear(2023);
        assertFalse(isLeap, "2023 should not be a leap year");
    }

    function testDaysInMonth() public {
        uint256 day = DateTimeLib.daysInMonth(2023, 2);
        assertEq(day, 28, "February 2023 should have 28 days");

        day = DateTimeLib.daysInMonth(2024, 2);
        assertEq(day, 29, "February 2024 should have 29 days");
    }

    function testWeekday() public {
        uint256 wd = DateTimeLib.weekday(1678857600); // 2023-03-15
        assertEq(wd, 3, "2023-03-15 should be a Wednesday");
    }

    function testIsSupportedDate() public {
        bool isSupported = DateTimeLib.isSupportedDate(2023, 2, 29);
        assertFalse(isSupported, "2023-02-29 should not be supported");

        isSupported = DateTimeLib.isSupportedDate(2024, 2, 29);
        assertTrue(isSupported, "2024-02-29 should be supported");
    }

    function testAddYears() public {
        uint256 timestamp = DateTimeLib.dateToTimestamp(2023, 3, 15);
        uint256 newTimestamp = DateTimeLib.addYears(timestamp, 2);
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(newTimestamp);
        assertEq(year, 2025, "Adding 2 years to 2023 should result in 2025");
        assertEq(month, 3, "Month should remain the same");
        assertEq(day, 15, "Day should remain the same");
    }

    function testSubYears() public {
        uint256 timestamp = DateTimeLib.dateToTimestamp(2023, 3, 15);
        uint256 newTimestamp = DateTimeLib.subYears(timestamp, 2);
        (uint256 year, uint256 month, uint256 day) = DateTimeLib.timestampToDate(newTimestamp);
        assertEq(year, 2021, "Subtracting 2 years from 2023 should result in 2021");
        assertEq(month, 3, "Month should remain the same");
        assertEq(day, 15, "Day should remain the same");
    }

    function testDiffYears() public {
        uint256 timestamp1 = DateTimeLib.dateToTimestamp(2023, 3, 15);
        uint256 timestamp2 = DateTimeLib.dateToTimestamp(2025, 3, 15);
        uint256 diff = DateTimeLib.diffYears(timestamp1, timestamp2);
        assertEq(diff, 2, "Difference between 2023 and 2025 should be 2 years");
    }
}