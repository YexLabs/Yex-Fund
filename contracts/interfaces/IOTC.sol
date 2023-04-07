// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IOTC {
    // 申购 token => F
    function subscribe(IERC20 token, uint256 _amount) external;
    
    // 赎回 F => token
    function redeem(IERC20 token, uint256 _amount) external;

    // 开放申购
    // 开放赎回
    // 关闭申购
    // 关闭赎回
}