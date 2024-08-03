// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {SafeTransferLib} from "../src/utils/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    address payable private recipient;
    address private constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        recipient = payable(address(0x1));
    }

//    function testSafeTransferETH() public {
//        uint256 amount = 1 ether;
//        payable(address(this)).transfer(amount);
//        uint256 recipientBalanceBefore = recipient.balance;
//
//        SafeTransferLib.safeTransferETH(recipient, amount);
//
//        assertEq(recipient.balance, recipientBalanceBefore + amount);
//    }

    function testSafeTransferAllETH() public {
        uint256 amount = address(this).balance;
        uint256 recipientBalanceBefore = recipient.balance;

        SafeTransferLib.safeTransferAllETH(recipient);

        assertEq(recipient.balance, recipientBalanceBefore + amount);
    }

//    function testForceSafeTransferETH() public {
//        uint256 amount = 1 ether;
//        payable(address(this)).transfer(amount);
//        uint256 recipientBalanceBefore = recipient.balance;
//
//        SafeTransferLib.forceSafeTransferETH(recipient, amount);
//
//        assertEq(recipient.balance, recipientBalanceBefore + amount);
//    }

    function testForceSafeTransferAllETH() public {
        uint256 amount = address(this).balance;
        uint256 recipientBalanceBefore = recipient.balance;

        SafeTransferLib.forceSafeTransferAllETH(recipient);

        assertEq(recipient.balance, recipientBalanceBefore + amount);
    }

//    function testTrySafeTransferETH() public {
//        uint256 amount = 1 ether;
//        payable(address(this)).transfer(amount);
//        uint256 recipientBalanceBefore = recipient.balance;
//
//        bool success = SafeTransferLib.trySafeTransferETH(recipient, amount, 2300);
//
//        assertTrue(success);
//        assertEq(recipient.balance, recipientBalanceBefore + amount);
//    }

    function testTrySafeTransferAllETH() public {
        uint256 amount = address(this).balance;
        uint256 recipientBalanceBefore = recipient.balance;

        bool success = SafeTransferLib.trySafeTransferAllETH(recipient, 2300);

        assertTrue(success);
        assertEq(recipient.balance, recipientBalanceBefore + amount);
    }

    function testSafeTransferFromERC20() public {
        // Mock ERC20 token setup
        address token = address(new MockERC20());
        address from = address(this);
        uint256 amount = 1000 * 1e18;

        // Mint tokens to this contract
        MockERC20(token).mint(address(this), amount);

        // Approve tokens to be spent by this contract
        MockERC20(token).approve(address(this), amount);

        // Transfer tokens to recipient
        SafeTransferLib.safeTransferFrom(token, from, recipient, amount);

        assertEq(MockERC20(token).balanceOf(recipient), amount);
    }

    function testSafeTransferERC20() public {
        // Mock ERC20 token setup
        address token = address(new MockERC20());
        uint256 amount = 1000 * 1e18;

        // Mint tokens to this contract
        MockERC20(token).mint(address(this), amount);

        // Transfer tokens to recipient
        SafeTransferLib.safeTransfer(token, recipient, amount);

        assertEq(MockERC20(token).balanceOf(recipient), amount);
    }

    function testSafeApproveERC20() public {
        // Mock ERC20 token setup
        address token = address(new MockERC20());
        uint256 amount = 1000 * 1e18;

        // Approve tokens to be spent by recipient
        SafeTransferLib.safeApprove(token, recipient, amount);

        assertEq(MockERC20(token).allowance(address(this), recipient), amount);
    }
}

// Mock ERC20 token for testing purposes
contract MockERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) public {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) public {
        allowance[msg.sender][spender] = amount;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        return true;
    }
}