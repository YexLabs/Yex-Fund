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
        uint256 _amountIn,
        address[] calldata _path,
        address _to
    ) public {
        require(_path.length >= 2, "Pools: invalid path");
        IERC20 inputToken = IERC20(_path[0]);

        if (inputToken != f) {
            inputToken.transferFrom(msg.sender, address(vault), _amountIn);
        } else {
            vault.f().burn(msg.sender, _amountIn);
        }

        uint256 amountToSwap = _amountIn;

        for (uint256 i = 0; i < _path.length - 1; i++) {
            IERC20 outputToken = IERC20(_path[i + 1]);
            uint256 poolId = getPoolId[inputToken][outputToken];
            require(poolId != 0, "Pools: pool not exists");

            Pool storage pool = getPool[poolId];
            uint256 inputReserve = pool.token_amount;
            uint256 outputReserve = pool.f_amount;

            uint256 amountOut = (amountToSwap *
                outputReserve *
                (10 ** 18 - pool.feeRate)) /
                ((inputReserve * 10 ** 18) +
                    (amountToSwap * (10 ** 18 - pool.feeRate)));
            require(amountOut > 0, "Pools: insufficient output amount");

            pool.token_amount = inputReserve + amountToSwap;
            pool.f_amount = outputReserve - amountOut;

            amountToSwap = amountOut;
            inputToken = outputToken;
        }
        IERC20 outToken = IERC20(_path[_path.length - 1]);
        if (outToken != f) {
            vault.transferF(_to, amountToSwap);
        } else {
            vault.transferToken(outToken, _to, amountToSwap);
        }
    }
}
