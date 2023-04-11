// SPDX-License-Identifier: GPL-3.0-or-later
// @xiaochen supredu
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
        uint256 amountOut;
        IERC20 outputToken = IERC20(_path[1]);
        uint256 poolId = getPoolId[inputToken][outputToken];
        require(poolId != 0, "Pools: pool not exists");

        Pool storage pool = getPool[poolId];
        if (inputToken != f) {
            inputToken.transferFrom(msg.sender, address(vault), _amountIn);
            amountOut=computeXToF(pool,_amountIn);
            vault.transferF(_to,amountOut);
        } else {
            vault.f().burn(msg.sender, _amountIn);
            amountOut=computeFToX(pool,_amountIn);
            vault.transferToken(inputToken,_to,amountOut);
        }
    }
       
    function computeXToF(
        Pool storage pool,
        uint256 amountIn
    ) internal returns (uint256 amountOut) {
        uint256 k = pool.token_amount * pool.f_amount; // x * y = k
        uint256 tokenAmountAfter = pool.f_amount + amountIn;
        uint256 fAmountAfter = k / tokenAmountAfter;
        uint256 amountOutBeforeFee = pool.f_amount - fAmountAfter;
        uint256 fee = (amountOutBeforeFee * pool.feeRate) / 10000;
        amountOut = amountOutBeforeFee - fee;
        pool.token_amount = tokenAmountAfter;
        pool.f_amount = fAmountAfter;
    }

    function computeFToX(
        Pool storage pool,
        uint256 amountIn
    ) internal returns (uint256 amountOut) {
        uint256 k = pool.token_amount * pool.f_amount; // x * y = k
        uint256 fAmountAfter = pool.f_amount + amountIn;
        uint256 tokenAmountAfter = k / fAmountAfter;
        uint256 amountOutBeforeFee = pool.token_amount - tokenAmountAfter;
        uint256 fee = (amountOutBeforeFee * pool.feeRate) / 10000;
        amountOut = amountOutBeforeFee - fee;
        pool.token_amount = tokenAmountAfter;
        pool.f_amount = fAmountAfter;
    }

}
