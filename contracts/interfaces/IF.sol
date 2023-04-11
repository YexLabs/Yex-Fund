// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IF is IERC20 {
    event VaultChanged(address indexed previousVault, address indexed newVault);

    function mint(address _account, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;

    function burn(uint256 _amount) external;

    function setVault(address newVault) external;
}
