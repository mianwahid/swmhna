// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;

import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    ERC20 token;

    receive() external payable {}

    function setUp() public {
        token = new ERC20();
        token.mint(address(this), 10000e18);
    }

    function testSafeTransferETH() public {
        address to = address(0x123);
        uint256 amount = 1e18;

        vm.deal(address(this), amount);
        SafeTransferLib.safeTransferETH(to, amount);

        assertEq(address(to).balance, amount);
    }

    function testSafeTransferAllETH() public {
        address to = address(0x123);
        uint256 amount = 1e18;

        vm.deal(address(this), amount);
        SafeTransferLib.safeTransferAllETH(to);

        assertEq(address(to).balance, amount);
    }

    function testForceSafeTransferETH() public {
        address to = address(0x123);
        uint256 amount = 1e18;

        vm.deal(address(this), amount);
        SafeTransferLib.forceSafeTransferETH(to, amount);

        assertEq(address(to).balance, amount);
    }

    function testForceSafeTransferAllETH() public {
        address to = address(0x123);
        uint256 amount = 1e18;

        vm.deal(address(this), amount);
        SafeTransferLib.forceSafeTransferAllETH(to);

        assertEq(address(to).balance, amount);
    }

    function testTrySafeTransferETH() public {
        address to = address(0x123);
        uint256 amount = 1e18;

        vm.deal(address(this), amount);
        assertTrue(SafeTransferLib.trySafeTransferETH(to, amount, gasleft()));

        assertEq(address(to).balance, amount);
    }

    function testTrySafeTransferAllETH() public {
        address to = address(0x123);
        uint256 amount = 1e18;

        vm.deal(address(this), amount);
        assertTrue(SafeTransferLib.trySafeTransferAllETH(to, gasleft()));

        assertEq(address(to).balance, amount);
    }

   function testSafeTransferFrom() public {
    address to = address(0x123);
    uint256 amount = 100e18;

    // Ensure the contract has the necessary allowance to transfer the tokens
    token.approve(address(this), amount);

    // Expect the Transfer event to be emitted
    vm.expectEmit(true, true, true, true);
    emit Transfer(address(this), to, amount);

    // Perform the transfer
    SafeTransferLib.safeTransferFrom(address(token), address(this), to, amount);

    // Check that the balance of the recipient is as expected
    assertEq(token.balanceOf(to), amount);
}


   function testTrySafeTransferFrom() public {
    address to = address(0x123);
    uint256 amount = 100e18;

    // Ensure the contract has the necessary allowance to transfer the tokens
    token.approve(address(this), amount);

    // Attempt the transfer and assert it is successful
    bool success = SafeTransferLib.trySafeTransferFrom(address(token), address(this), to, amount);
    assertTrue(success);

    // Check that the balance of the recipient is as expected
    assertEq(token.balanceOf(to), amount);
}


   function testSafeTransferAllFrom() public {
    address to = address(0x123);
    uint256 amount = token.balanceOf(address(this));

    // Ensure the contract has the necessary allowance to transfer the tokens
    token.approve(address(this), amount);

    // Expect the Transfer event to be emitted
    vm.expectEmit(true, true, true, true);
    emit Transfer(address(this), to, amount);

    // Perform the transfer
    SafeTransferLib.safeTransferAllFrom(address(token), address(this), to);

    // Check that the balance of the recipient is as expected
    assertEq(token.balanceOf(to), amount);
}


    function testSafeTransfer() public {
        address to = address(0x123);
        uint256 amount = 100e18;

        vm.expectEmit(true, true, true, true);
        emit Transfer(address(this), to, amount);
        SafeTransferLib.safeTransfer(address(token), to, amount);

        assertEq(token.balanceOf(to), amount);
    }

    function testSafeTransferAll() public {
        address to = address(0x123);
        uint256 amount = token.balanceOf(address(this));

        vm.expectEmit(true, true, true, true);
        emit Transfer(address(this), to, amount);
        SafeTransferLib.safeTransferAll(address(token), to);

        assertEq(token.balanceOf(to), amount);
    }

    function testSafeApprove() public {
        address to = address(0x123);
        uint256 amount = 100e18;

        vm.expectEmit(true, true, true, true);
        emit Approval(address(this), to, amount);
        SafeTransferLib.safeApprove(address(token), to, amount);

        assertEq(token.allowance(address(this), to), amount);
    }

    function testSafeApproveWithRetry() public {
        address to = address(0x123);
        uint256 amount = 100e18;

        vm.expectEmit(true, true, true, true);
        emit Approval(address(this), to, amount);
        SafeTransferLib.safeApproveWithRetry(address(token), to, amount);

        assertEq(token.allowance(address(this), to), amount);
    }

    function testBalanceOf() public {
        uint256 amount = 10000e18;

        assertEq(SafeTransferLib.balanceOf(address(token), address(this)), amount);
    }

//   function testSafeTransferFrom2() public {
//    address to = address(0x123);
//    uint256 amount = 100e18;
//
//    // Ensure the contract has the necessary allowance to transfer the tokens
//    token.approve(address(SafeTransferLib), amount);
//
//    // Expect the Transfer event to be emitted
//    vm.expectEmit(true, true, true, true);
//    emit Transfer(address(this), to, amount);
//
//    // Perform the transfer
//    SafeTransferLib.safeTransferFrom2(address(token), address(this), to, amount);
//
//    // Check that the balance of the recipient is as expected
//    assertEq(token.balanceOf(to), amount);
//}


//    function testPermit2TransferFrom() public {
//        address to = address(0x123);
//        uint256 amount = 100e18;
//
//        vm.expectEmit(true, true, true, true);
//        emit Transfer(address(this), to, amount);
//        SafeTransferLib.permit2TransferFrom(address(token), address(this), to, amount);
//
//        assertEq(token.balanceOf(to), amount);
//    }

//    function testPermit2() public {
//        address owner = address(this);
//        address spender = address(0x123);
//        uint256 amount = 100e18;
//        uint256 deadline = block.timestamp + 1000;
//        (uint8 v, bytes32 r, bytes32 s) =
//            vm.sign(vm.getEthSignKey(owner), keccak256(abi.encode(owner, spender, amount, deadline)));
//
//        vm.expectEmit(true, true, true, true);
//        emit Approval(owner, spender, amount);
//        SafeTransferLib.permit2(address(token), owner, spender, amount, deadline, v, r, s);
//
//        assertEq(token.allowance(owner, spender), amount);
//    }

//    function testSimplePermit2() public {
//        address owner = address(this);
//        address spender = address(0x123);
//        uint256 amount = 100e18;
//        uint256 deadline = block.timestamp + 1000;
//        (uint8 v, bytes32 r, bytes32 s) =
//            vm.sign(vm.getEthSignKey(owner), keccak256(abi.encode(owner, spender, amount, deadline)));
//
//        vm.expectEmit(true, true, true, true);
//        emit Approval(owner, spender, amount);
//        SafeTransferLib.simplePermit2(address(token), owner, spender, amount, deadline, v, r, s);
//
//        assertEq(token.allowance(owner, spender), amount);
//    }
}

contract ERC20 {
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) public {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit SafeTransferLibTest.Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) public {
        balanceOf[from] -= amount;
        totalSupply -= amount;
        emit SafeTransferLibTest.Transfer(from, address(0), amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit SafeTransferLibTest.Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit SafeTransferLibTest.Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit SafeTransferLibTest.Transfer(from, to, amount);
        return true;
    }

    function DOMAIN_SEPARATOR() external view returns (bytes32) {
        return SafeTransferLib.DAI_DOMAIN_SEPARATOR;
    }
}