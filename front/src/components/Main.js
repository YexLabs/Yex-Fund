//@xiaochen
import React from "react";
import bg from "./images/intro/bg.png";
import curve from "./images/intro/curve.png";
import honypot from "./images/intro/honypot.png";
import scroll from "./images/intro/scroll.png";
import berachain from "./images/intro/berachain.png";

export default function Main() {
  return (
    <div class="box-border mx-auto mb-7 min-h-screen md:min-h-auto md:h-auto md:pt-7">
      <div className="mb-[100px]">
        <img
          className="absolute flex justify-center  w-full top-20 z-negative mt-48"
          src={curve}
          alt=""
        />
        <div className="flex flex-col box-border mx-auto w-full max-w-screen-lg pt-40">
          <div className="flex flex-col cursor-default">
            <div className="flex flex-col ml-24 text-left m-2 gap-8">
              <div className="flex flex-col max-w-1/2">
                <div>
                  <p class="font-medium text-4xl">
                    DeFi Fund for Improved Liquidity{" "}
                  </p>
                </div>
                <div>
                  <p class="font-medium text-4xl">
                    Trading on{" "}
                    <span className="scrollTextGradient">Scroll Testnet</span>
                  </p>
                </div>
              </div>
              <div className="flex flex-col fade-in  gap-1">
                <p className="text-lg font-medium">
                  Seamless and efficient trading experience
                </p>
                <p className=" w-1/2 text-left text-gray-500 mt-2">
                  Our DeFi fund provides LPers with improved survival
                  conditions, alpha mining opportunities, beta hedging tools,
                  stable, deep, low-cost liquidity for the community.
                </p>
              </div>
            </div>
          </div>

          <div className="flex flex-col items-center mt-96 mx-2">
            <div className="flex flex-col gap-6 items-center">
              <p className=" text-4xl font-semibold">An Aligned Mission</p>
              <p className=" w-5/6 text-center">
                y=e^x Lab aligns with the mission of Scroll to accelerate the
                mass adoption of crypto for personal sovereignty.
              </p>
              <a href="https://drive.google.com/file/d/1Z2si06OLwnOxRGRVQE9BlF58nrCpWKHe/view">
                <button className="btn  btn-outline">
                  White Paper
                  <span className="ml-2">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="#5155a6"
                      stroke-width="2"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    >
                      <line x1="7" y1="17" x2="17" y2="7"></line>
                      <polyline points="7 7 17 7 17 17"></polyline>
                    </svg>
                  </span>
                </button>
              </a>
            </div>
          </div>

          <div className="flex flex-col items-center mt-2 mx-2">
            <div className="px-12">
              <img src={curve} />
            </div>
          </div>

          <div className="flex flex-col items-center mt-16 mx-2">
            <div className="flex flex-col gap-2 items-center">
              <p className=" text-4xl font-semibold">Built with the Best</p>
              <p className="  text-center">
                Thanks to our partners and the best builders in Web3 industry
              </p>
              <div>
                {" "}
                <div class=" grid grid-cols-3 grid-gap-4 grid-flow-row mt-8">
                  <img src={honypot} className=" mx-4 w-52 h-16" />
                  <img src={scroll} className=" mx-4 w-52 h-16" />{" "}
                  <img src={berachain} className=" mx-4 w-52 h-16" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}