pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// SPDX-License-Identifier: GPL-3.0
contract tokenF is ERC20 {
    uint256 public TotalSupply;
    address dev;

    constructor(uint256 initialSupply, address _dev) ERC20("Gold", "GLD") {
        TotalSupply = initialSupply;
        dev = _dev;
    }

    uint256 public CurrentAmount = 0;

    mapping(address => bool) public AccessJudgeForMint;

    function mint(address _account, uint256 _amount) public {
        require(AccessJudgeForMint[msg.sender]);
        _mint(_account, _amount);
        require(CurrentAmount + _amount <= TotalSupply);
        CurrentAmount = CurrentAmount + _amount;
    }

    function burn(address _account, uint256 _amount) public {
        require(AccessJudgeForMint[msg.sender]);
        require(CurrentAmount >= _amount);
        _burn(_account, _amount);
        CurrentAmount = CurrentAmount - _amount;
    }

    function setMint(address _account) public {
        require(msg.sender == dev, "Permission denied");
        AccessJudgeForMint[_account] = true;
    }
}
