//// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.4;
//pragma abicoder v2;
//import {Test, console2,console} from "forge-std/Test.sol";
//import "../src/utils/Base64.sol";
//
//contract Base64Test is Test {
//    function testBase64Encode() public {
//        bytes memory data = "Hello, World!";
//        string memory encoded = Base64.encode(data);
//        console.log(encoded);
//    }
//
//    function testBase64Decode() public {
//        string memory encoded = "SGVsbG8sIFdvcmxkIQ==";
//        bytes memory decoded = Base64.decode(encoded);
//        console.logBytes(decoded);
//    }
//}