import React, { useEffect, useState } from "react";
import { Card, Avatar } from "antd";
import {
  AppstoreOutlined,
  MailOutlined,
  SettingOutlined,
} from "@ant-design/icons"; // 给导航菜单用
import ethicon from "./images/pools/eth.png";
import { useContractRead, erc20ABI, useAccount } from "wagmi";

import {
  pools_address,
  tokenD_address,
  tokenF_address,
} from "../contracts/addresses";
import { pools_abi } from "../contracts/abis";
import { ethers } from "ethers";

// For Css
import stars from "./images/switch/stars.png";
import moon from "./images/switch/moon.png";
import "./Pools.css";
import { type } from "@testing-library/user-event/dist/type";
// Css Over

const { Meta } = Card;

export function Pools() {
  const [loading, setLoading] = useState(true);
  const { address } = useAccount();
  const [tokenA, setTokenA] = useState("");
  const [tokenB, setTokenB] = useState("");
  const [tokenASymbol, setTokenASymbol] = useState("");
  const [tokenBSymbol, setTokenBSymbol] = useState("");
  const [tokenAAmount, setTokenAAmount] = useState("0.0");
  const [tokenBAmount, setTokenBAmount] = useState("0.0");
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

  // 定位的循环数组
  let set = [null, "left-[28%]", "right-[28%]", "right-[6%]"];

  // 循环显示你的流动池
  let FundsData = [
    {
      Id: 0,
      set: set[0],
      FundName: "FortuneFunds",
      FundContent:
        "Our latest Web3 liquidity pool feature the dynamic duo of TST and GLD virtual currencies! This cutting-edge platform offers investors the opportunity to dive into the world of decentralized finance, with the added benefit of our carefully curated and highly liquid asset pool. Investors seeking to maximize their returns in the Web3 space need look no further than our TST/GLD liquidity pool.  Our robust and secure infrastructure ensures smooth and efficient trading, while our team of expert analysts and traders works tirelessly to optimize returns and minimize risk.",
      TokenNO1: tokenASymbol,
      TokenNO1Amount: tokenAAmount,
      TokenNO2: tokenBSymbol,
      TokenNO2Amount: tokenBAmount,
    },
  ];

  return (
    <div id="Switch-body" className="h-full justify-center items-center flex">
      <section className="justify-center w-full">
        <img src={stars} alt="" id="stars" />
        <img src={moon} alt="" id="moon" />
        <div id="all-content" className="w-full">
          <div className="card">
            <div className="card-body">
              <div
                id="title_show_top"
                className="card-title italic flex flex-col w-full justify-center text-3xl"
              >
                <h1>
                  Explore liquidity pools with potential for future development
                </h1>
                <div className="text-2xl">Or</div>
                <button className="rounded-full bg-primary text-xl text-white px-4 py-1">
                  Create Pool
                </button>
              </div>
              {/*<div id="title_show_content" className="flex justify-center">123456</div>*/}
            </div>
          </div>
          <div id="boxs" className="flex flex-row mt-20 justify-start w-[100%]">
            {FundsData.map((onepool) => (
              <div
                id="box1"
                className={`bg-white rounded-lg ${onepool.set} h-[49%] w-[20%] absolute`}
              >
                <div id="box1_body" className="p-6 h-full">
                  <div id="box1_title" className="mb-2 text-2xl flex flex-row">
                    <Avatar className="h-6 w-6 self-center" src={ethicon} />
                    <div className="ml-2 font-bold">{onepool.FundName}</div>
                    <div className="ml-3 font-light text-sm self-center dropdown dropdown-hover dropdown-right dropdown-end">
                      {tokenASymbol} - {tokenBSymbol}
                      <ul className="dropdown-content card card-compact ml-2 h-20 w-32 shadow bg-[#3d4451] text-white text-1xl justify-center">
                        <p className="px-4 self-center">
                          <div>TokenAmount↓</div>
                          <div>
                            <div>
                              {onepool.TokenNO1} -{" "}
                              {onepool.TokenNO1Amount.slice(0, 3)}
                            </div>
                            <div>
                              {onepool.TokenNO2} -{" "}
                              {onepool.TokenNO2Amount.slice(0, 3)}
                            </div>
                          </div>
                        </p>
                      </ul>
                    </div>
                  </div>
                  <div id="box1_content" className="h-[315px]">
                    <p className="text-ellipsis overflow-hidden h-full">
                      {onepool.FundContent}
                    </p>
                    <div className="mt-2">
                      <a href="#" className="font-bold hover:underline">
                        Click to exit
                      </a>
                      <i class="fa-solid fa-arrow-right"></i>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  );
}
