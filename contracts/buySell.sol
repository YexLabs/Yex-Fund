// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./tokenF.sol";
import"./values.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract buySell {
    // 变量
    address tokenFAddr;
    address dev;
    address vAddr;
    uint256 public feePercent; // 手续费的百分比
    mapping(address => uint256) public tokens; // 记录

//    // 事件
//    event Deposit(address token, address user, uint256 amount, uint256 balance);
//    event Withdraw(address token, address user, uint256 amount, uint256 balance);

    // 设置存储手续费的账户, 及手续费率(这里默认为0.01)
    constructor(uint256 _feePercent,address _FAddr,address _dev,address _vAddr) {
        tokenFAddr=_FAddr;
        feePercent = _feePercent;
        dev = _dev;
        vAddr=_vAddr;
    }
    function setDev(address _newdev) public{
        require(msg.sender==dev,"Not dev");
        dev=_newdev;
    }
    function withdraw(address _tokenX, uint256 _amount) public {
        // 赎回;
        require(tokens[msg.sender] >= _amount,"Insufficient tokenF");
        tokens[msg.sender] = tokens[msg.sender] - _amount;
        uint256 amountBack = _amount * (100 - feePercent)/100;
        values vContract = values(vAddr);
        vContract.withdrawTransfer(_amount,amountBack,msg.sender,_tokenX);
    }
    
    function deposit(address _tokenX,uint256 _amount)  public { 
        // 申购
        require( IERC20(_tokenX).balanceOf(msg.sender)>= _amount,"Insufficient fund");
        values vContract = values(vAddr);
        vContract.depositTransfer(_amount,_amount,msg.sender,_tokenX); // 发给用户
        tokens[msg.sender] = tokens[msg.sender] + _amount;
    }
    
}
