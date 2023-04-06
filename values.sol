// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
import"./tokenF.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract values {
    address swap;
    address dev;
    address AddrF;
    constructor(address _dev){
        dev = _dev;
    }
    modifier onlyDev {
      require(msg.sender == dev);
      _; 
   }
    
    function swapTransfer(address XOwner,address tokenX, uint256 amountX , uint256 amountF,bool isXToF) external {
        require(msg.sender==swap,"Not Swap");
        tokenF tokenFContract= tokenF(AddrF);
        if( isXToF == true){
        require(IERC20(tokenX).balanceOf(XOwner) >= amountX,"Insufficient Token");
        require(IERC20(tokenX).allowance(XOwner,address(this))>= amountX,"Insufficient Allowance");
        IERC20(tokenX).transferFrom(XOwner,address(this),amountX);
        tokenFContract.mint(XOwner,amountF);
        }
    else{
        require(IERC20(AddrF).balanceOf(XOwner) >= amountF,"Insufficient TokenF");
        require(IERC20(tokenX).balanceOf(address(this)) >= amountX,"Insufficient Token");
        tokenFContract.burn(XOwner,amountX);
        IERC20(tokenX).transferFrom(address(this),XOwner,amountX);
    }
    }
    function setSwap(address _swap) external onlyDev{
        swap=_swap;
    }
}