// SPDX-License-Identifier: GPL-3.0-or-later
// @xiaochen
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IVault.sol";
import "../interfaces/IF.sol";
import "../interfaces/IPools.sol";

contract Pools is IPools, Ownable {
    IVault vault;
    IERC20 public f;
    uint pool_id;
    struct Pool {
        IERC20 token;
        IERC20 f;
        uint256 token_amount;
        uint256 f_amount;
        uint256 feeRate;
    }
    // v2.0 把uint256改成address，用Factory实现
    mapping(IERC20 => mapping(IERC20 => uint256)) public getPoolId;
    mapping(uint256 => Pool) public getPool;

    constructor(IVault _vault, IERC20 _f) {
        // 先部署vault和代币F，再部署此合约
        vault = _vault;
        f = _f;
    }

    function _initialize(
        IERC20 token,
        uint256 _amount,
        uint256 _f_amount,
        uint256 _feeRate
    ) private {
        Pool memory pool = Pool(token, f, _amount, _f_amount, _feeRate);
        pool_id++;
        getPoolId[token][f] = pool_id;
        getPool[pool_id] = pool;
    }

    function createLiquidity(
        IERC20 token,
        uint256 _amount,
        uint256 _f_amount,
        uint256 _feeRate
    ) public onlyOwner {
        require(token != f, "Pools: identical addresses");
        require(address(token) != address(0), "Pools: zero address");
        require(getPoolId[token][f] == 0, "Pools: pool exists");
        // TODO 判断token的数量是否超过vault的限制

        _initialize(token, _amount, _f_amount, _feeRate);
    }

    function updateLiquidity(
        IERC20 token,
        uint256 _amount,
        uint256 _f_amount
    ) public onlyOwner {
        require(getPoolId[token][f] != 0, "Pools: pool not exists");
        getPool[getPoolId[token][f]].token_amount = _amount;
        getPool[getPoolId[token][f]].f_amount = _f_amount;
    }

    function destroyLiquidity(IERC20 token) public onlyOwner {
        require(getPoolId[token][f] != 0, "Pools: pool not exists");
        getPoolId[token][f] = 0;
    }

    // 根据恒定K算法计算收到的代币A和付出的代币B
    function swap(
        uint256 amountIn,
        address[] calldata path,
        address to
    ) public {
        bool isXToF;
        uint256 netAmountOut;
        require(path.length >= 2, "Invalid path");

        // if (path[0] != tokenFAddr) {
        //     require(path[1] == tokenFAddr, "No tokenF");
        //     isXToF = true;
        // } else {
        //     require(path[1] != tokenFAddr, "Both tokenF");
        // }
        // require(
        //     IERC20(path[0]).allowance(msg.sender, vAddr) >= amountIn,
        //     "Not enough allowance"
        // );
        // vault vContract = vault(vAddr);

        // // tokenA.transferFrom(msg.sender, address(this), amountIn);

        // //  uint256 lpIndex = getLpIndex(path[0], path[1]);
        // //  require(lpIndex != 0, "Pool doesn't exist");
        // require(getLpIndex(path[0], path[1]) != 0, "Pool doesn't exist");

        // Pool storage pool = pools[getLpIndex(path[0], path[1]) - 1];
        // // tokenB.transfer(to, netAmountOut);
        // if (isXToF == true) {
        //     netAmountOut = computeXToF(pool, amountIn);
        //     vContract.swapTransfer(to, path[0], amountIn, netAmountOut, isXToF);
        // } else {
        //     netAmountOut = computeFToX(pool, amountIn);
        //     vContract.swapTransfer(to, path[0], netAmountOut, amountIn, isXToF);
        // }
    }
}
