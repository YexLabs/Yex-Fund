import * as React from "react";
import { usePrepareContractWrite, useContractWrite } from "wagmi";
import { MyTokenAbi } from "../config";

export function Exchange() {
  const { config } = usePrepareContractWrite({
    address: "0xeEE680A857679Dec72864c40C3aA521dDFED6b77",
    abi: MyTokenAbi,
    functionName: "Mint",
    args: ["0x36De702a11C07777443093a58226f07dEea6dFc8"],
  });
  const { write } = useContractWrite(config);

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
