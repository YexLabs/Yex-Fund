
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// SPDX-License-Identifier: GPL-3.0
contract tokenA is ERC20, Ownable  {
    uint256 public TotalSupply;

    constructor(uint256 initialSupply) ERC20("TEST", "TST") {
        TotalSupply = initialSupply;
    }

    uint256 public CurrentAmount = 0;

    mapping(address => bool) public AccessJudgeForMint;
    // mapping(address => bool) public AccessJudgeForBurn;

    function mint(address _account, uint256 _amount) public {
        require(AccessJudgeForMint[_account]);
        _mint(_account, _amount);
        require(CurrentAmount + _amount <= TotalSupply);
        CurrentAmount = CurrentAmount + _amount;
    }

    function burn(address _account, uint256 _amount) public {
        // require(AccessJudgeForBurn[_account]);
        _burn(_account, _amount);
        require(CurrentAmount > _amount);
        CurrentAmount = CurrentAmount - _amount;
    }

    function setMint(address _account) external onlyOwner {
        AccessJudgeForMint[_account] = true;
    }
}