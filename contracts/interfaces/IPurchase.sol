// SPDX-License-Identifier: GPL-3.0-or-later
// @Taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IMintable.sol";

interface IPurchase {
    // 采购某个token，暂时没实现，先mint替代效果
    function purchaseByF(IMintable want_token, uint256 _amount) external;

    function purchaseByToken(
        IMintable want_token,
        IERC20 use_token,
        uint256 _amount
    ) external;
}
