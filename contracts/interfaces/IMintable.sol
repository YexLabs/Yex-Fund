// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMintable is IERC20 {
    function mint(address _account, uint256 _amount) external;
}
