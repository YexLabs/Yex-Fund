// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
import "./tokenF.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract vault {
    address swap; //swap合约地址
    address dev; //项目方地址
    address AddrF; //tokenF合约地址
    address subscribe; //申购赎回合约地址

    constructor(address _dev) {
        dev = _dev;
    }

    modifier onlyDev() {
        require(msg.sender == dev);
        _;
    }

    //swap转账功能实现
    function swapTransfer(
        address XOwner,
        address tokenX,
        uint256 amountX,
        uint256 amountF,
        bool isXToF
    ) external {
        require(msg.sender == swap, "Not Swap");
        tokenF tokenFContract = tokenF(AddrF);
        if (isXToF == true) {
            require(
                IERC20(tokenX).balanceOf(XOwner) >= amountX,
                "Insufficient Token"
            );
            require(
                IERC20(tokenX).allowance(XOwner, address(this)) >= amountX,
                "Insufficient Allowance"
            );
            IERC20(tokenX).transferFrom(XOwner, address(this), amountX);
            tokenFContract.mint(XOwner, amountF);
        } else {
            require(
                IERC20(AddrF).balanceOf(XOwner) >= amountF,
                "Insufficient TokenF"
            );
            require(
                IERC20(tokenX).balanceOf(address(this)) >= amountX,
                "Insufficient Token"
            );
            tokenFContract.burn(XOwner, amountX);
            IERC20(tokenX).transfer(XOwner, amountX);
        }
    }

    //申购转账
    function depositTransfer(
        uint256 amountIn,
        uint256 amountOut,
        address XOwner,
        address tokenX
    ) public {
        require(msg.sender == subscribe, "Not subscribe");
        require(
            IERC20(tokenX).balanceOf(XOwner) >= amountIn,
            "Insufficient fund"
        );
        IERC20(tokenX).transferFrom(XOwner, address(this), amountIn);
        tokenF tokenFContract = tokenF(AddrF);
        tokenFContract.mint(XOwner, amountOut);
    }

    //赎回转账
    function withdrawTransfer(
        uint256 amountIn,
        uint256 amountOut,
        address XOwner,
        address tokenX
    ) public {
        require(msg.sender == subscribe, "Not subscribe");
        tokenF tokenFContract = tokenF(AddrF);
        tokenFContract.burn(XOwner, amountIn);
        IERC20(tokenX).transfer(XOwner, amountOut);
    }

    //设置swap合约
    function setSwap(address _swap) external onlyDev {
        swap = _swap;
    }

    function setDev(address _newdev) public {
        require(msg.sender == dev, "Permission denied");
        dev = _newdev;
    }

    function setSubscribe(address _subscribe) public {
        require(msg.sender == dev, "Permission denied");
        subscribe = _subscribe;
    }

    function setFAddr(address _AddrF) public {
        require(msg.sender == dev, "Permission denied");
        AddrF = _AddrF;
    }
}
