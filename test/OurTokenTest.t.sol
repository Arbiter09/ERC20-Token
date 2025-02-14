// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {console} from "forge-std/console.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
        console.log(ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 inititalAllowance = 1000;
        console.log(inititalAllowance);
        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, inititalAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTokenDetails() public {
        assertEq(ourToken.name(), "OurToken");
        assertEq(ourToken.symbol(), "OT");
        assertEq(ourToken.decimals(), 18);
    }

    function testTotalSupply() public {
        uint256 totalSupply = ourToken.totalSupply();
        uint256 sumBalances = ourToken.balanceOf(address(this)) + ourToken.balanceOf(msg.sender)
            + ourToken.balanceOf(bob) + ourToken.balanceOf(alice);
        assertEq(totalSupply, sumBalances);
    }

    function testDefaultAllowanceIsZero() public {
        assertEq(ourToken.allowance(bob, alice), 0);
    }

    function testSuccessfulTransfer() public {
        uint256 amount = 10 ether;
        vm.prank(bob);
        bool success = ourToken.transfer(alice, amount);
        assertTrue(success);
        assertEq(ourToken.balanceOf(alice), amount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - amount);
    }

    function testTransferInsufficientBalance() public {
        uint256 amount = STARTING_BALANCE + 1;
        // Alice starts with 0 tokens so this should revert.
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transfer(bob, amount);
    }

    function testApproveAllowance() public {
        uint256 allowanceAmount = 2000;
        vm.prank(bob);
        bool success = ourToken.approve(alice, allowanceAmount);
        assertTrue(success);
        assertEq(ourToken.allowance(bob, alice), allowanceAmount);
    }

    function testTransferFromExceedsAllowance() public {
        uint256 allowanceAmount = 500;
        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);
        uint256 transferAmount = allowanceAmount + 1;
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    function testTransferFromUpdatesAllowance() public {
        uint256 allowanceAmount = 500;
        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);
        uint256 transferAmount = 200;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.allowance(bob, alice), allowanceAmount - transferAmount);
    }

    function testTransferToZeroAddress() public {
        uint256 amount = 10 ether;
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(address(0), amount);
    }

    function testTransferToSelf() public {
        uint256 amount = 5 ether;
        uint256 initialBalance = ourToken.balanceOf(bob);
        vm.prank(bob);
        bool success = ourToken.transfer(bob, amount);
        assertTrue(success);
        // Bob's balance remains the same after transferring to himself.
        assertEq(ourToken.balanceOf(bob), initialBalance);
    }
}
