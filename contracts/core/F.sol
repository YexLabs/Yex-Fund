// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IF.sol";


contract F is ERC20("Fund", "F"), Ownable, IF{
    
    address public vault;

    constructor() {
        // 部署F代币合约后，等vault部署完成，再回来setVault()
    }

    modifier onlyVault() {
        require(msg.sender == vault, "Permission denied");
        _;
    }

    function setVault(address newVault) public onlyOwner {
        address previousVault = vault;
        vault = newVault;
        emit VaultChanged(previousVault, newVault);
    }

    function mint(address _account, uint256 _amount) public onlyVault {
        _mint(_account, _amount);
    }

    // 允许别人烧币
    function burn(address _account, uint256 _amount) public {
        address spender = _msgSender();
        _spendAllowance(_account, spender, _amount);
        _burn(_account, _amount);
    }

    // 自己烧币
    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }
}