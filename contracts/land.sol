// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Lending {
    IERC20 public collateralToken; // 抵押品代币 D
    IERC20 public loanToken; // 贷款代币 F
    uint256 public constant MIN_COLLATERAL_RATIO = 150; // 最低抵押率，单位：百分比
    uint256 public constant INTEREST_RATE = 5; // 利率，单位：百分比

    struct Loan {
        uint256 collateralAmount; // 抵押品数量
        uint256 loanAmount; // 贷款数量
        uint256 interestAmount; // 利息数量
        uint256 lastBorrowTimestamp; // 上次借款时间戳
    }

    mapping(address => Loan) public loans;

    constructor(IERC20 _collateralToken, IERC20 _loanToken) {
        collateralToken = _collateralToken;
        loanToken = _loanToken;
    }

    function depositCollateral(uint256 amount) public {
        require(amount > 0, "Amount should be greater than 0");
        collateralToken.transferFrom(msg.sender, address(this), amount);
        loans[msg.sender].collateralAmount += amount;
    }

    function borrow(uint256 loanAmount) public {
        uint256 collateralAmount = loans[msg.sender].collateralAmount;
        uint256 price = getPrice();
        require(
            collateralAmount * price * 100 >= loanAmount * MIN_COLLATERAL_RATIO,
            "Insufficient collateral"
        );

        loans[msg.sender].lastBorrowTimestamp = block.timestamp;
        loans[msg.sender].interestAmount = calculateInterest(loans[msg.sender]);
        loanToken.transfer(msg.sender, loanAmount);
        loans[msg.sender].loanAmount += loanAmount;
    }

    function calculateInterest(
        Loan storage _loan
    ) internal view returns (uint256) {
        uint256 timeElapsed = block.timestamp - _loan.lastBorrowTimestamp;
        uint256 interestAmount = (((_loan.loanAmount * INTEREST_RATE) / 100) *
            timeElapsed) / (365 days);
        return interestAmount;
    }

    function repay(uint256 loanAmount) public {
        require(
            loans[msg.sender].loanAmount >= loanAmount,
            "Invalid loan amount"
        );
        loans[msg.sender].interestAmount = calculateInterest(loans[msg.sender]);
        loanToken.transferFrom(msg.sender, address(this), loanAmount);
        loans[msg.sender].loanAmount -= loanAmount;
    }

    function withdrawCollateral(uint256 collateralAmount) public {
        uint256 availableCollateral = getAvailableCollateral(msg.sender);
        require(
            collateralAmount <= availableCollateral,
            "Insufficient available collateral"
        );
        collateralToken.transfer(msg.sender, collateralAmount);
        loans[msg.sender].collateralAmount -= collateralAmount;
    }

    function getAvailableCollateral(
        address borrower
    ) public view returns (uint256) {
        uint256 price = getPrice();
        uint256 totalCollateralValue = loans[borrower].collateralAmount * price;
        uint256 loanValue = loans[borrower].loanAmount;
        uint256 requiredCollateralValue = (loanValue * MIN_COLLATERAL_RATIO) /
            100;

        if (totalCollateralValue <= requiredCollateralValue) {
            return 0;
        }

        uint256 availableCollateralValue = totalCollateralValue -
            requiredCollateralValue;
        return availableCollateralValue / price;
    }

    function isLiquidatable(address borrower) public view returns (bool) {
        uint256 price = getPrice(); // 获取D-F代币对的实时价格
        uint256 collateralValue = loans[borrower].collateralAmount * price;
        uint256 loanValue = loans[borrower].loanAmount;
        return collateralValue < (loanValue * MIN_COLLATERAL_RATIO) / 100;
    }

    function liquidate(address borrower) public {
        Loan storage loan = loans[borrower];
        uint256 collateralAmount = loan.collateralAmount;
        uint256 loanAmount = loan.loanAmount;
        uint256 interestAmount = calculateInterest(loan);
        uint256 totalLoanAmount = loanAmount + interestAmount;

        uint256 price = getPrice();
        require(
            collateralAmount * price * 100 <
                totalLoanAmount * MIN_COLLATERAL_RATIO,
            "Collateral ratio is not below minimum"
        );

        collateralToken.transfer(msg.sender, collateralAmount);
        loanToken.transferFrom(msg.sender, address(this), totalLoanAmount);

        delete loans[borrower];
    }

    // 获取D-F代币对的价格
    function getPrice() public view returns (uint256) {
        // 在这里实现获取D-F代币对的实时价格的逻辑
        // 可以通过调用链上预言机如Chainlink等来获取价格
    }
}
