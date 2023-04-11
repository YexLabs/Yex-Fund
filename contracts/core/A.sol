// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interfaces/IMintable.sol";

contract A is ERC20("A", "A"), IMintable ,Ownable {
    // 这个币就默认成随便增发就好了，方便开发者给自己打钱
    function mint(address _account, uint256 _amount) public onlyOwner {
        _mint(_account, _amount);
    }

    function faucet() public {
        _mint(msg.sender, 10**18);
    }
}
