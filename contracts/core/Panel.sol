// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;
// 最终希望把所有的Owner转移到这个面板上，统一操作会比较好

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IVault.sol";
import "../interfaces/IOTC.sol";
import "../interfaces/IPools.sol";
import "../interfaces/IPurchase.sol";

contract Panel is Ownable {
    IVault vault;
    IOTC otc;
    IPools pools;
    IPurchase purchase;

    constructor(IVault _vault, IOTC _otc, IPools _pools, IPurchase _purchase) {
        // 最后部署面板合约
        vault = _vault;
        otc = _otc;
        pools = _pools;
        purchase = _purchase;
    }

    // example 操作开放申购: otc开放申购，vault给token授权

    // 开放申购
    // @xiaochen
    function otc_openSubscribe() public onlyOwner {
        otc.openSubscribe();
    }

    // 开放赎回
    // @xiaochen
    function otc_openRedeem() public onlyOwner {
        otc.openRedeem();
    }

    // 关闭申购
    // @xiaochen
    function otc_closeSubscribe() public onlyOwner {
        otc.closeSubscribe();
    }

    // 关闭赎回
    // @xiaochen
    function otc_closeRedeem() public onlyOwner {
        otc.closeRedeem();
    }

    // vault给token授权
    // @xiaochen
    function vault_authorizePermit(
        IERC20 token,
        address account
    ) public onlyOwner {
        vault.authorizePermit(token, account);
    }

    // vault取消token授权
    // @xiaochen
    function vault_revokePermit(
        IERC20 token,
        address account
    ) public onlyOwner {
        vault.revokePermit(token, account);
    }

    // example 操作创建pool: pool创建，vault给token授权

    // 创建pool
    // @xiaochen
    function pools_create(
        IERC20 token,
        uint256 _amount,
        uint256 _f_amount,
        uint256 _feeRate
    ) public onlyOwner {
        pools.createLiquidity(token, _amount, _f_amount, _feeRate);
    }

    // 销毁pool
    // @xiaochen
    function pools_destroy(IERC20 token) public onlyOwner {
        pools.destroyLiquidity(token);
    }
}
