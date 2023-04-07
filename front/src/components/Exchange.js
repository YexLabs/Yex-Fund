import { ethers } from "ethers";
import * as React from "react";
import {
  useContractRead,
  usePrepareContractWrite,
  useContractWrite,
  erc20ABI,
  useAccount,
} from "wagmi";
import { MyTokenAbi } from "../config";
import { tokenD_address, exchange_address } from "../contracts/addresses";

export function Exchange() {
  const { address } = useAccount();
  const [approvedAmount, setApprovedAmount] = React.useState(0);
  // 获取已授权的token数量
  const getUsdtApproved = useContractRead({
    address: tokenD_address,
    abi: erc20ABI,
    functionName: "allowance",
    args: [address, exchange_address],
    watch: true,
    onSuccess(data) {
      console.log("GetUsdtApproved", data);
      const amount = ethers.utils.formatUnits(data, "ether");
      setApprovedAmount(amount);
    },
  });
  // tokenD授权config
  const { config: approveConfig } = usePrepareContractWrite({
    address: tokenD_address,
    abi: erc20ABI,
    functionName: "approve",
    args: [exchange_address, ethers.utils.parseEther("100")],
  });
  // tokenD授权
  const {
    data: approveData,
    isLoading,
    isSuccess,
    writeAsync: approveWrite,
  } = useContractWrite({
    ...approveConfig,
    onError(error) {
      console.log("Error", error);
    },
  });

  return (
    <div className="flex  content-center  justify-center h-full">
      <div class="card w-96 glass h-72 mt-36">
        {/* <figure>
          <img
            src="/images/stock/photo-1606107557195-0e29a4b5b4aa.jpg"
            alt="car!"
          />
        </figure> */}

        <div class="card-body">
          <label className="label">
            <span className="label-text text-black">SWAP</span>
          </label>
          <div className="rounded-lg bg-[#F0F0F0] relative">
            <input
              type="password"
              placeholder="1"
              className="input input-bordered border-none  w-full bg-[#F0F0F0]"
            />
            <span className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-black">
              ↓
            </span>
            <hr className="mx-4 "></hr>
            <input
              type="password"
              placeholder="1"
              className="input input-bordered border-none w-full bg-[#F0F0F0]"
            />
          </div>
          <h2 class="card-title">Life hack</h2>
          <p>How to park your car at your garage?</p>
          <div class="card-actions justify-end">
            <button class="btn btn-primary">Learn now!</button>
          </div>
        </div>
      </div>
    </div>
  );
}
