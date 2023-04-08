// SPDX-License-Identifier: GPL-3.0-or-later
// @Taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPools {
    // 创建流动性池
    function createLiquidity(
        IERC20 token,
        uint256 _amount,
        uint256 _f_amount,
        uint256 _feeRate
    ) external;

    // 修改流动性
    function updateLiquidity(
        IERC20 token,
        uint256 _amount,
        uint256 _f_amount
    ) external;

    // 销毁流动性池
    function destroyLiquidity(IERC20 token) external;

    // swap
    function swap(
        uint256 amountIn,
        address[] calldata path,
        address to
    ) external;
}
