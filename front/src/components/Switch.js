import * as React from "react";
import { useDebounce } from "use-debounce";
import {
  usePrepareSendTransaction,
  useSendTransaction,
  useWaitForTransaction,
} from "wagmi";
import { utils } from "ethers";
import { useNetwork } from "wagmi";

import './Switch.css'

export function Switch() {
  const { chain, chains } = useNetwork();

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
    if (networkname == "Ethereum") {
      return false;
    } else {
      return true;
    }
  };

  return (
    <div id="Switch-body" className="h-full justify-center items-center flex">
      <div class="card w-96 bg-base-100 shadow-xl">
        <div class="card-body">
          <form
            onSubmit={(e) => {
              e.preventDefault();
              sendTransaction?.();
            }}
          >
            <div class="btn-group">
              <button className="btn btn-active">Button</button>
              <button className="btn">Button</button>
            </div>
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
            <button
              className="btn w-full"
              disabled={isLoading || !sendTransaction || !to || !amount}
            >
              {isLoading ? "Sending..." : "Send"}
            </button>
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
