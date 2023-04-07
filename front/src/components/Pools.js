import React, { useEffect, useState } from "react";
import { Card, Avatar } from "antd";
import ethicon from "./images/pools/eth.png";
import {
  useContractRead,
  usePrepareContractWrite,
  useContractWrite,
  useWaitForTransaction,
  erc20ABI,
  useAccount,
} from "wagmi";

import { pools_address } from "../contracts/addresses";
import { pools_abi } from "../contracts/abis";
import { ethers } from "ethers";

const { Meta } = Card;

export function Pools() {
  const [loading, setLoading] = useState(true);
  const { address } = useAccount();
  const [tokenA, setTokenA] = useState("");
  const [tokenB, setTokenB] = useState("");
  const [tokenASymbol, setTokenASymbol] = useState("");
  const [tokenBSymbol, setTokenBSymbol] = useState("");
  const [tokenAAmount, setTokenAAmount] = useState(0);
  const [tokenBAmount, setTokenBAmount] = useState(0);
  // 获取vault已授权的tokenD数量
  const getTokenDApproved = useContractRead({
    address: pools_address,
    abi: pools_abi,
    functionName: "pools",
    args: [0],
    watch: true,
    onSuccess(data) {
      console.log("GetLp", data);
      setTokenA(data[0]);
      setTokenB(data[1]);
      setTokenAAmount(ethers.utils.formatUnits(data[2], "ether"));
      setTokenBAmount(ethers.utils.formatUnits(data[3], "ether"));
      // const amount = ethers.utils.formatUnits(data, "ether");
      // setApprovedAmount(amount);
    },
  });

  // 获取tokenA的symbol
  const getTokenASymbol = useContractRead({
    address: tokenA,
    abi: erc20ABI,
    functionName: "symbol",
    onSuccess(data) {
      console.log("TokenA name:", data);
      setTokenASymbol(data);
    },
  });
  // 获取tokenB的symbol
  const getTokenBSymbol = useContractRead({
    address: tokenB,
    abi: erc20ABI,
    functionName: "symbol",
    onSuccess(data) {
      console.log("TokenB name:", data);
      setTokenBSymbol(data);
      setLoading(false);
    },
  });

  // useEffect(() => {
  //   if (
  //     tokenA != "" &&
  //     tokenB != "" &&
  //     tokenASymbol != "" &&
  //     tokenBSymbol != ""
  //   ) {
  //     setLoading(false);
  //   }
  // }, [tokenASymbol]);

  return (
    <div>
      <div className="ml-4">
        <Card
          style={{
            width: 220,
            height: 250,
            marginTop: 16,
          }}
          cover={
            <img
              alt="example"
              src="https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png"
            />
          }
          hoverable
          loading={loading}
        >
          <Meta
            avatar={<Avatar src={ethicon} />}
            title={`${tokenASymbol} - ${tokenBSymbol}`}
            description={
              <div className="mt-2">
                <p>{`${tokenASymbol}: ${tokenAAmount * 10 ** 18}`}</p>
                <p>{`${tokenBSymbol}: ${tokenBAmount * 10 ** 18}`}</p>
              </div>
            }
          />
        </Card>
      </div>
    </div>
  );
}
