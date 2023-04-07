// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./vault.sol";

contract Swap {
    //vault合约地址
    address vAddr;
    //tokenF的地址
    address tokenFAddr;
    // 交换池的结构体
    struct Pool {
        address tokenA; // 代币A的地址
        address tokenB; // 代币B的地址
        uint256 tokenA_amount; // 代币A的数量
        uint256 tokenB_amount; // 代币B的数量
        uint256 feeRate; // 手续费费率（万分之一）
    }

    mapping(address => mapping(address => uint)) public findAtoB;
    Pool[] public pools; //交换池数组
    address public dev; //开发者地址

    constructor(address _dev, address _vAddr) {
        vAddr = _vAddr;
        dev = _dev;
    }

    function setTokenFAddr(address _tokenFAddr) public {
        require(msg.sender == dev, "Permission denied");
        tokenFAddr = _tokenFAddr;
    }

    function setDev(address _newdev) public {
        require(msg.sender == dev, "Not dev");
        dev = _newdev;
    }

    // 初始化池子
    function initNewPool(
        address _tokenA,
        address _tokenB,
        uint256 _tokenA_amount,
        uint256 _tokenB_amount,
        uint256 _feeRate
    ) public {
        require(msg.sender == dev, "Permission denied");
        // if(_tokenA!=)
        Pool memory pool = Pool(
            _tokenA,
            _tokenB,
            _tokenA_amount,
            _tokenB_amount,
            _feeRate
        );
        uint lpIndex = getLpIndex(_tokenA, _tokenB);
        uint poolsLen = pools.length;
        if (poolsLen == 0) {
            findAtoB[_tokenA][_tokenB] = 1;
            findAtoB[_tokenB][_tokenA] = 1;
            pools.push(pool);
        } else {
            require(lpIndex == 0, "Lp has been exist");
            findAtoB[_tokenA][_tokenB] = poolsLen + 1;
            findAtoB[_tokenB][_tokenA] = poolsLen + 1;
            pools.push(pool);
        }
    }

    // 计算代币价格，返回代币B对代币A的价格
    function getPrice(
        address _tokenA,
        address _tokenB
    ) public view returns (uint256) {
        uint256 lpIndex = getLpIndex(_tokenA, _tokenB);
        require(lpIndex != 0, "Pool doesn't exist");

        Pool memory pool = pools[lpIndex - 1];
        return (pool.tokenB_amount * (10 ** 18)) / pool.tokenA_amount;
    }

    // 获取Lp池子的Index
    function getLpIndex(
        address _tokenA,
        address _tokenB
    ) public view returns (uint256) {
        uint AtoB = findAtoB[_tokenA][_tokenB];
        uint BtoA = findAtoB[_tokenB][_tokenA];
        if (AtoB == 0 && BtoA == 0) {
            return 0;
        } else {
            return AtoB;
        }
    }

    // 根据恒定K算法计算收到的代币A和付出的代币B
    function swap(
        uint256 amountIn,
        address[] calldata path,
        address to
    ) public payable {
        bool isXToF;
        uint256 netAmountOut;
        require(path.length >= 2, "Invalid path");

        if (path[0] != tokenFAddr) {
            require(path[1] == tokenFAddr, "No tokenF");
            isXToF = true;
        } else {
            require(path[1] != tokenFAddr, "Both tokenF");
        }
        require(
            IERC20(path[0]).allowance(msg.sender, vAddr) >= amountIn,
            "Not enough allowance"
        );
        vault vContract = vault(vAddr);

        // tokenA.transferFrom(msg.sender, address(this), amountIn);

        //  uint256 lpIndex = getLpIndex(path[0], path[1]);
        //  require(lpIndex != 0, "Pool doesn't exist");
        require(getLpIndex(path[0], path[1]) != 0, "Pool doesn't exist");

        Pool storage pool = pools[getLpIndex(path[0], path[1]) - 1];
        // tokenB.transfer(to, netAmountOut);
        if (isXToF == true) {
            netAmountOut = computeXToF(pool, amountIn);
            vContract.swapTransfer(to, path[0], amountIn, netAmountOut, isXToF);
        } else {
            netAmountOut = computeFToX(pool, amountIn);
            vContract.swapTransfer(to, path[0], netAmountOut, amountIn, isXToF);
        }
    }

    function computeXToF(
        Pool storage pool,
        uint256 amountIn
    ) internal returns (uint256 netAmountOut) {
        uint256 k = pool.tokenA_amount * pool.tokenB_amount; // x * y = k
        uint256 tokenAAmountAfter = pool.tokenA_amount + amountIn;
        uint256 tokenBAmountAfter = k / tokenAAmountAfter;
        uint256 amountOut = pool.tokenB_amount - tokenBAmountAfter;
        uint256 fee = (amountOut * pool.feeRate) / 10000;
        netAmountOut = amountOut - fee;
        pool.tokenA_amount = tokenAAmountAfter;
        pool.tokenB_amount = tokenBAmountAfter;
    }

    function computeFToX(
        Pool storage pool,
        uint256 amountIn
    ) internal returns (uint256 netAmountOut) {
        uint256 k = pool.tokenA_amount * pool.tokenB_amount; // x * y = k
        uint256 tokenBAmountAfter = pool.tokenB_amount + amountIn;
        uint256 tokenAAmountAfter = k / tokenBAmountAfter;
        uint256 amountOut = pool.tokenA_amount - tokenAAmountAfter;
        uint256 fee = (amountOut * pool.feeRate) / 10000;
        netAmountOut = amountOut - fee;
        pool.tokenA_amount = tokenAAmountAfter;
        pool.tokenB_amount = tokenBAmountAfter;
    }

    // 计算可拿到的带滑点的数量
    function calculateNetAmountOut(
        uint256 amountIn,
        address[] calldata path
    ) public view returns (uint256) {
        uint256 pathLength = path.length;
        require(pathLength >= 2, "Invalid path");

        IERC20 tokenA = IERC20(path[0]);

        for (uint256 i; i < pathLength - 1; i++) {
            IERC20 tokenB = IERC20(path[i + 1]);

            uint256 lpIndex = getLpIndex(path[i], path[i + 1]);
            require(lpIndex != 0, "Pool doesn't exist");

            Pool storage pool = pools[lpIndex - 1];

            uint256 k = pool.tokenA_amount * pool.tokenB_amount; // x * y = k
            uint256 tokenAAmountAfter = pool.tokenA_amount + amountIn;
            uint256 tokenBAmountAfter = k / tokenAAmountAfter;
            uint256 amountOut = pool.tokenB_amount - tokenBAmountAfter;

            uint256 fee = (amountOut * pool.feeRate) / 10000;
            uint256 netAmountOut = amountOut - fee;

            amountIn = netAmountOut;
            tokenA = tokenB;
        }
        return amountIn;
    }
}
