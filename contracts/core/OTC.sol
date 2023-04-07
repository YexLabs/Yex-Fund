// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IOTC.sol";
import "../interfaces/IVault.sol";

contract OTC is IOTC, Ownable {
    IVault private vault;
    bool public subscribable;
    bool public redeemable;

    constructor(IVault _vault) {
        // 先部署vault，再部署场外交易合约
        vault = _vault;
    }

    // 申购
    function subscribe(IERC20 token, uint256 _amount) external override {
        // 检查是否允许申购
        require(subscribable, "OTC: currently unsubscribed");
        // 收款到vault
        token.transferFrom(msg.sender, address(vault), _amount);
        // TODO 计算价格
        // 发送代币
        vault.transferF(msg.sender, _amount);
    }

    // 赎回
    function redeem(IERC20 token, uint256 _amount) external override {
        // 检查是否允许赎回
        require(redeemable, "OTC: currently not convertible");
        // 收款到F
        // vault.f.transferFrom(msg.sender, address(vault), _amount);
        vault.f().burn(msg.sender, _amount);
        // TODO 计算价格
        // 发送代币
        vault.transferToken(token, msg.sender, (_amount * 99) / 100);
    }

    // 开放申购
    function openSubscribe() public onlyOwner {
        subscribable = true;
    }

    // 开放赎回
    function openRedeem() public onlyOwner {
        redeemable = true;
    }

    // 关闭申购
    function closeSubscribe() public onlyOwner {
        subscribable = false;
    }

    // 开放赎回
    function closeRedeem() public onlyOwner {
        redeemable = false;
    }
}
