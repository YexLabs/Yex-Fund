// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;
// 最终希望把所有的Owner转移到这个面板上，统一操作会比较好

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IVault.sol";
import "../interfaces/IOTC.sol";
import "../interfaces/IPools.sol";

contract Panel is Ownable{
    IVault vault;
    IOTC otc;
    IPools pools;

    constructor(IVault _vault, IOTC _otc, IPools _pools) {
        // 最后部署面板合约
        vault = _vault;
        otc = _otc;
        pools = _pools;
    }

    // example 操作开放申购: otc开放申购，vault给token授权
    // example 操作创建pool: pool创建，vault给token授权
}