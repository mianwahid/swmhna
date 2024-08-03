// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/DeploylessPredeployQueryer.sol";

contract DeploylessPredeployQueryerTest is Test {
    function testDeploylessPredeployQueryer() public {
        address precompile = address(1);
        bytes[] memory targetQueryCalldata = new bytes[](1);
        targetQueryCalldata[0] = abi.encodeWithSignature("gasprice()");

        bytes memory data = abi.encodeWithSelector(
            DeploylessPredeployQueryer.constructor.selector,
            precompile,
            targetQueryCalldata,
            address(0),
            ""
        );

        (bool success, bytes memory result) = address(this).staticcall(data);
        assertTrue(success);

        bytes[] memory decodedResult = abi.decode(result, (bytes[]));
        assertEq(decodedResult.length, 1);

        uint256 gasPrice = abi.decode(decodedResult[0], (uint256));
        console2.logUint(gasPrice);
        assertGt(gasPrice, 0);
    }
}
