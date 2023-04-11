// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IVault.sol";
import "../interfaces/IF.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is IVault, Ownable {
    IF public f;
    // 代币地址 => 操作合约地址 => 是否授权
    // V2.0 考虑不是bool而是amount
    mapping(IERC20 => mapping(address => bool)) private _permits; // Token => Accounts who can use this token

    constructor(IF _f) {
        // 先部署代币F，再部署此合约
        f = _f;
    }

    function authorizePermit(IERC20 token, address account) public onlyOwner {
        _permits[token][account] = true;
    }

    function revokePermit(IERC20 token, address account) public onlyOwner {
        _permits[token][account] = false;
    }

    function transferToken(IERC20 token, address to, uint256 amount) public {
        require(
            _permits[token][msg.sender],
            "Vault: caller does not have the permit"
        );
        token.transfer(to, amount);
        emit Transfer(token, to, amount);
    }

    function transferF(address to, uint256 amount) public {
        require(
            _permits[f][msg.sender],
            "Vault: caller does not have the permit"
        );
        f.mint(to, amount);
        emit Transfer(f, to, amount);
    }
}
