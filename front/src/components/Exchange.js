import { ethers } from "ethers";
import * as React from "react";
import {
  useContractRead,
  usePrepareContractWrite,
  useContractWrite,
  useWaitForTransaction,
  erc20ABI,
  useAccount,
} from "wagmi";

import {
  tokenD_address,
  buysell_address,
  vault_address,
} from "../contracts/addresses";

// For Css
import './Exchange.css'
import stars from "./images/switch/stars.png";
import moon from "./images/switch/moon.png";
import m_behind from "./images/switch/mountains_behind.png";
import m_front from "./images/switch/mountains_front.png";
import {useEffect, useState} from "react";

export function Exchange() {
  const { address } = useAccount();
  const [hash, setHash] = React.useState("");
  const [approvedAmount, setApprovedAmount] = React.useState(0);

  const confirmation = useWaitForTransaction({
    hash: hash,
    onSuccess(data) {
      console.log("Success", data);
      alert("交易成功");
      window.location.reload();
      // alert('交易成功')
    },
  });

  // 获取vault已授权的tokenD数量
  const getTokenDApproved = useContractRead({
    address: tokenD_address,
    abi: erc20ABI,
    functionName: "allowance",
    args: [address, vault_address],
    watch: true,
    onSuccess(data) {
      console.log("GetTokenDApproved", data);
      const amount = ethers.utils.formatUnits(data, "ether");
      setApprovedAmount(amount);
    },
  });
  // tokenD授权config
  const { config: approveTokenDConfig } = usePrepareContractWrite({
    address: tokenD_address,
    abi: erc20ABI,
    functionName: "approve",
    args: [buysell_address, ethers.utils.parseEther("100")],
  });
  // tokenD授权
  const {
    data: approveTokenDData,
    isLoading,
    isSuccess,
    writeAsync: approveTokenDWrite,
  } = useContractWrite({
    ...approveTokenDConfig,
    onError(error) {
      console.log("Error", error);
    },
  });

  const approveTokenDClick = () => {
    approveTokenDWrite?.().then((res) => {
      console.log(res);
      setHash(res.hash);
    });
  };

  // 切换状态栏的按钮组件
  const [Buyon, setBuyon] = useState(true); // 设置默认值, 'true'为买, 'false'为卖

  useEffect(() => {
    document.getElementById('buy').style.background = Buyon ? 'rgb(79 70 229)' : 'rgb(61,68,81)'
    document.getElementById('sell').style.background = Buyon ? 'rgb(61,68,81)' : 'rgb(79 70 229)'
  }, [Buyon])

  const ToSell = () => {
    setBuyon(false);
  }
  const ToBuy = () => {
    setBuyon(true);
    // console.log('AfterBuy', Buyon)
  }

  return (
    <div id="Switch-body" className="h-full justify-center items-center flex">
      <section>
        <img src={stars} alt="" id="stars" />
        <img src={moon} alt="" id="moon" />
        <img src={m_behind} alt="" id="mountain_behind" />
        <div className="flex  content-center  justify-center h-full">
          <div id="exchange" class="card w-96 h-96 bg-base-100 shadow-xl">
            <div class="card-body p-7">
              <div id="button-group" className="mb-2">
                <button id="buy" className="h-9 w-20 bg-indigo-600 rounded-l-lg text-white text-xl pl-0.5 duration-100" onClick={() => ToBuy()}>Buy</button>
                <button id="sell" className="h-9 w-20 bg-[#3d4451] rounded-r-lg text-white text-xl pr-0.5 duration-100" onClick={() => ToSell()}>Sell</button>
              </div>
              <div className="rounded-lg relative">
                <input
                    id="ChangeFrom"
                    type="password"
                    placeholder="Token you have"
                    className="input input-bordered border-none h-16 w-full bg-[#F0F0F0] mb-2"
                />
                <div id="From-To-Change">
                  <button className="absolute transform -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2 h-8 w-8 border-4 bg-[#F0F0F0] border-white rounded-lg border-color text-slate-400">
                    ↓
                  </button>
                </div>
                {/*<hr className="mx-4 "></hr>*/}
                <input
                    id="ChangeTo"
                    className="input input-bordered border-none h-16 w-full bg-[#F0F0F0] focus:outline-none"
                    type="password"
                    placeholder="Token you want"/>
              </div>
              <div className="card-actions justify-end mt-2">
                <button
                    className="btn btn-primary w-full"
                    onClick={() => approveTokenDClick()}
                >
                  Approve!
                </button>
              </div>
            </div>
          </div>
        </div>
        <img src={m_front} alt="" id="mountain_front" />
      </section>
    </div>
  );
}
