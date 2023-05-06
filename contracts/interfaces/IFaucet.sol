// SPDX-License-Identifier: GPL-3.0-or-later
// @taki
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFaucet is IERC20 {
    function faucet() external;
}

abstract contract Faucet {
    constructor() {
        
    }

   
    mapping(address => uint256) private _lastBlocks;

    function faucet() public {
        if _lastBlocks[msg.sender] == 0 {
            _mint(msg.sender, 100**18);
        }else {
            amount = (block.number - _lastBlocks[msg.sender]);
            // 每25600个块(不到天)可以领取100个测试币，即领取delta_blocks/256
            _mint(msg.sender, amount**10);
        }
        _lastBlocks[msg.sender] = block.number;
    }
}
