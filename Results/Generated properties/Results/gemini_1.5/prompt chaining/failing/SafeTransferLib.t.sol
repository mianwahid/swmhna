// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
pragma abicoder v2;
import {Test, console2} from "forge-std/Test.sol";
import "../src/utils/SafeTransferLib.sol";

contract SafeTransferLibTest is Test {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          ADDRESSES                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    address constant ALICE = address(0x11ce);
    address constant BOB = address(0x10b);
    address constant INVALID_ADDRESS = address(0xdead);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         TEST ERC20                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    ERC20Mock internal foo;
    ERC20Mock internal bar;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       OTHER HELPERS                         */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // Helper function to set up ERC20 tokens before each test.
    function setUp() public virtual {
        foo = new ERC20Mock("Foo", "FOO");
        bar = new ERC20Mock("Bar", "BAR");
        foo.mint(ALICE, 100 ether);
        bar.mint(ALICE, 100 ether);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       ETH OPERATIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSafeTransferETH() public {
        uint256 aliceBalance = ALICE.balance;
        uint256 bobBalance = BOB.balance;
        vm.deal(ALICE, 10 ether);
        SafeTransferLib.safeTransferETH(BOB, 5 ether);
        assertEq(ALICE.balance, aliceBalance + 5 ether);
        assertEq(BOB.balance, bobBalance + 5 ether);
    }

    function testSafeTransferAllETH() public {
        uint256 bobBalance = BOB.balance;
        vm.deal(ALICE, 10 ether);
        vm.startPrank(ALICE);
        SafeTransferLib.safeTransferAllETH(BOB);
        vm.stopPrank();
        assertEq(ALICE.balance, 0);
        assertEq(BOB.balance, bobBalance + 10 ether);
    }

    function testSafeTransferETHInsufficientBalance() public {
        vm.deal(ALICE, 10 ether);
        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
        SafeTransferLib.safeTransferETH(BOB, 11 ether);
    }

    function testSafeTransferETHToZeroAddress() public {
        vm.deal(ALICE, 10 ether);
        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
        SafeTransferLib.safeTransferETH(address(0), 5 ether);
    }

    function testForceSafeTransferETHToContractThatReverts() public {
        uint256 aliceBalance = ALICE.balance;
        vm.deal(ALICE, 10 ether);
        RevertContract revertContract = new RevertContract();
        SafeTransferLib.forceSafeTransferETH(address(revertContract), 5 ether, 2300);
        assertEq(ALICE.balance, aliceBalance + 5 ether);
    }

    function testForceSafeTransferETHWithZeroGasStipend() public {
        uint256 aliceBalance = ALICE.balance;
        uint256 bobBalance = BOB.balance;
        vm.deal(ALICE, 10 ether);
        SafeTransferLib.forceSafeTransferETH(BOB, 5 ether, 0);
        assertEq(ALICE.balance, aliceBalance + 5 ether);
        assertEq(BOB.balance, bobBalance + 5 ether);
    }

    function testForceSafeTransferETHInsufficientBalance() public {
        vm.deal(ALICE, 10 ether);
        vm.expectRevert(SafeTransferLib.ETHTransferFailed.selector);
        SafeTransferLib.forceSafeTransferETH(BOB, 11 ether, 2300);
    }

    function testTrySafeTransferETHSuccess() public {
        uint256 aliceBalance = ALICE.balance;
        uint256 bobBalance = BOB.balance;
        vm.deal(ALICE, 10 ether);
        bool success = SafeTransferLib.trySafeTransferETH(BOB, 5 ether, 2300);
        assert(success);
        assertEq(ALICE.balance, aliceBalance + 5 ether);
        assertEq(BOB.balance, bobBalance + 5 ether);
    }

    function testTrySafeTransferETHFail() public {
        vm.deal(ALICE, 10 ether);
        RevertContract revertContract = new RevertContract();
        bool success = SafeTransferLib.trySafeTransferETH(
            address(revertContract),
            5 ether,
            2300
        );
        assert(!success);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ERC20 OPERATIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    function testSafeTransferFrom() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 50 ether);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, BOB, 50 ether);
        assertEq(foo.balanceOf(ALICE), 50 ether);
        assertEq(foo.balanceOf(BOB), 50 ether);
        vm.stopPrank();
    }

    function testSafeTransferFromInsufficientAllowance() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 40 ether);
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, BOB, 50 ether);
        vm.stopPrank();
    }

    function testSafeTransferFromInsufficientBalance() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 150 ether);
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, BOB, 150 ether);
        vm.stopPrank();
    }

    function testSafeTransferFromToZeroAddress() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 50 ether);
        vm.expectRevert(SafeTransferLib.TransferFromFailed.selector);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, address(0), 50 ether);
        vm.stopPrank();
    }

    function testTrySafeTransferFromSuccess() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 50 ether);
        bool success = SafeTransferLib.trySafeTransferFrom(
            address(foo),
            ALICE,
            BOB,
            50 ether
        );
        assert(success);
        assertEq(foo.balanceOf(ALICE), 50 ether);
        assertEq(foo.balanceOf(BOB), 50 ether);
        vm.stopPrank();
    }

    function testTrySafeTransferFromFail() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 40 ether);
        bool success = SafeTransferLib.trySafeTransferFrom(
            address(foo),
            ALICE,
            BOB,
            50 ether
        );
        assert(!success);
        vm.stopPrank();
    }

    function testSafeTransferAllFrom() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 100 ether);
        uint256 amount = SafeTransferLib.safeTransferAllFrom(address(foo), ALICE, BOB);
        assertEq(amount, 100 ether);
        assertEq(foo.balanceOf(ALICE), 0);
        assertEq(foo.balanceOf(BOB), 100 ether);
        vm.stopPrank();
    }

    function testSafeTransfer() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 50 ether);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, address(this), 50 ether);
        SafeTransferLib.safeTransfer(address(foo), BOB, 50 ether);
        assertEq(foo.balanceOf(address(this)), 0);
        assertEq(foo.balanceOf(BOB), 50 ether);
        vm.stopPrank();
    }

    function testSafeTransferInsufficientBalance() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 50 ether);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, address(this), 50 ether);
        vm.expectRevert(SafeTransferLib.TransferFailed.selector);
        SafeTransferLib.safeTransfer(address(foo), BOB, 60 ether);
        vm.stopPrank();
    }

    function testSafeTransferToZeroAddress() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 50 ether);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, address(this), 50 ether);
        vm.expectRevert(SafeTransferLib.TransferFailed.selector);
        SafeTransferLib.safeTransfer(address(foo), address(0), 50 ether);
        vm.stopPrank();
    }

    function testSafeTransferAll() public {
        vm.startPrank(ALICE);
        foo.approve(address(this), 100 ether);
        SafeTransferLib.safeTransferFrom(address(foo), ALICE, address(this), 50 ether);
        uint256 amount = SafeTransferLib.safeTransferAll(address(foo), BOB);
        assertEq(amount, 50 ether);
        assertEq(foo.balanceOf(address(this)), 0);
        assertEq(foo.balanceOf(BOB), 50 ether);
        vm.stopPrank();
    }

    function testSafeApprove() public {
        SafeTransferLib.safeApprove(address(foo), BOB, 50 ether);
        assertEq(foo.allowance(address(this), BOB), 50 ether);
    }

    function testSafeApproveZeroAmount() public {
        SafeTransferLib.safeApprove(address(foo), BOB, 0);
        assertEq(foo.allowance(address(this), BOB), 0);
    }

    function testSafeApproveMaxAmount() public {
        SafeTransferLib.safeApprove(address(foo), BOB, type(uint256).max);
        assertEq(foo.allowance(address(this), BOB), type(uint256).max);
    }

    // Add tests for `safeApproveWithRetry` with a mock token that requires a two-step approval process.

    function testBalanceOf() public {
        uint256 balance = SafeTransferLib.balanceOf(address(foo), ALICE);
        assertEq(balance, 100 ether);
    }

    function testBalanceOfZeroAddress() public {
        uint256 balance = SafeTransferLib.balanceOf(address(foo), address(0));
        assertEq(balance, 0);
    }

    // Add tests for `safeTransferFrom2`, `permit2TransferFrom`, `permit2`, and `simplePermit2` with mock tokens and Permit2 setup.
}

contract ERC20Mock {
    string public name;
    string public symbol;
    uint8 public decimals;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }

    function mint(address _to, uint256 _amount) public {
        totalSupply += _amount;
        balanceOf[_to] += _amount;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(balanceOf[_from] >= _value && allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        return true;
    }
}

contract RevertContract {
    function testRevert() public pure {
        revert("Function reverted");
    }
}
