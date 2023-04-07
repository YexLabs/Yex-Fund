// SPDX-License-Identifier: GPL-3.0-or-later
// @Taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IF.sol";

interface IVault {
    event PermitAuthorized(address indexed token, address indexed account);
    event PermitRevoked(address indexed token, address indexed account);
    event Receive(IERC20 indexed token, address indexed from, uint256 amount);
    event Transfer(IERC20 indexed token, address indexed to, uint256 amount);

    // 授权使用某token
    function authorizePermit(IERC20 token, address account) external;
    // 取消授权使用某token
    function revokePermit(IERC20 token, address account) external;

    // 支付某token
    function transferToken(IERC20 token, address to, uint256 amount) external;
    // 支付F
    function transferF(address to, uint256 amount) external;

    function f() external view returns (IF);
}
