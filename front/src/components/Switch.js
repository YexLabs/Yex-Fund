import * as React from "react";
import {useEffect, useState} from "react";
import {useDebounce} from "use-debounce";
import {useNetwork, usePrepareSendTransaction, useSendTransaction, useWaitForTransaction,} from "wagmi";
import {utils} from "ethers";

import './Switch.css'

export function Switch() {
  const { chain } = useNetwork();

  const [to, setTo] = React.useState("");
  const [debouncedTo] = useDebounce(to, 500);

  const [amount, setAmount] = React.useState("");
  const [debouncedAmount] = useDebounce(amount, 500);

  const { config } = usePrepareSendTransaction({
    request: {
      to: debouncedTo,
      value: debouncedAmount ? utils.parseEther(debouncedAmount) : undefined,
    },
  });
  const { data, sendTransaction } = useSendTransaction(config);

  const { isLoading, isSuccess } = useWaitForTransaction({
    hash: data?.hash,
  });
  const checknetwork = (networkname) => {
    if (networkname === "Ethereum") {
      return false;
    } else {
      return true;
    }
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
      <div className="card w-96 bg-base-100 shadow-xl">
        <div className="card-body p-7" >
          <div id="button-group" className="mb-3">
            <button id="buy" className="h-11 w-16 bg-indigo-600 rounded-l-lg text-white text-xl pl-0.5 duration-100" onClick={() => ToBuy()}>Buy</button>
            <button id="sell" className="h-11 w-16 bg-[#3d4451] rounded-r-lg text-white text-xl pr-0.5 duration-100" onClick={() => ToSell()}>Sell</button>
          </div>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              sendTransaction?.();
            }}
          >
            <input
              type="text"
              className="input bg-slate-100 min-h-16 w-full max-w-xs mb-5"
              aria-label="Recipient"
              onChange={(e) => setTo(e.target.value)}
              placeholder="0xA0Cf…251e"
              value={to}
            />
            <input
              type="text"
              className="input bg-slate-100 min-h-16 w-full max-w-xs mb-5"
              aria-label="Amount (ether)"
              onChange={(e) => setAmount(e.target.value)}
              placeholder="0.05"
              value={amount}
            />
            {Buyon
                ? <button
                    className="btn w-full"
                    disabled={isLoading || !sendTransaction || !to || !amount}
                    >
                    {isLoading ? "Buying..." : "Buy"}
                  </button>
                : <button
                    className="btn w-full"
                    disabled={isLoading || !sendTransaction || !to || !amount}
                >
                  {isLoading ? "Selling..." : "Sell"}
                </button> }
            {isSuccess && (
              <div>
                Successfully sent {amount} ether to {to}
                <div>
                  {checknetwork(chain.name) ? (
                    <a href={`https://${chain.name}.etherscan.io/tx/${data?.hash}`}>
                      Etherscan
                    </a>
                  ) : (
                    <a href={`https://etherscan.io/tx/${data?.hash}`}>Etherscan</a>
                  )}
                </div>
              </div>
            )}
          </form>
        </div>
      </div>
    </div>
  );
}
