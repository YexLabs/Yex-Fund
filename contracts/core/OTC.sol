// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IOTC.sol";
import "../interfaces/IVault.sol";

contract OTC is IOTC{
    IVault private vault;

    constructor(IVault _vault) {
        // 先部署F代币和vault，再部署场外交易合约
        vault = _vault;
    }

    // 申购
    function subscribe(IERC20 token, uint256 _amount) external override {
        // TODO 检查是否允许申购
        // 收款到vault
        token.transferFrom(msg.sender, address(vault), _amount);
        // TODO 计算价格
        // 发送代币
        vault.transferF(msg.sender, _amount);
    }

    // 赎回
    function redeem(IERC20 token, uint256 _amount) external override {
        // TODO 检查是否允许赎回
        // 收款到F
        // vault.f.transferFrom(msg.sender, address(vault), _amount);
        vault.f().burn(msg.sender, _amount);
        // TODO 计算价格
        // 发送代币
        vault.transferToken(token, msg.sender, _amount*99/100);
    }
}