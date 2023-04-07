// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IPurchase.sol";
import "../interfaces/IVault.sol";

contract Purchase is IPurchase {
    IVault private vault;

    constructor(IVault _vault) {
        // 先部署vault，再部署场外交易合约
        vault = _vault;
    }

    function purchaseByF(IMintable want_token, uint256 _amount) public {
        // 暂时先给vault mint一些token替代一下效果
        want_token.mint(address(vault), _amount);

        // 假设随便丢一些F给随便地址当花掉了
        vault.transferF(address(want_token), _amount);
    }

    function purchaseByToken(
        IMintable want_token,
        IERC20 use_token,
        uint256 _amount
    ) public {
        // 暂时先给vault mint一些token替代一下效果
        want_token.mint(address(vault), _amount);

        // 假设随便丢一些token给随便地址当花掉了
        vault.transferToken(use_token, address(want_token), _amount);
    }
}
