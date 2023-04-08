import React, { useEffect, useState } from "react";
import { Card, Avatar, Badge, Button } from "antd";
import {
  useContractRead,
  usePrepareContractWrite,
  useContractWrite,
  useWaitForTransaction,
  erc20ABI,
  useAccount,
} from "wagmi";
import ethicon from "./images/pools/eth.png";
import { DownloadOutlined } from "@ant-design/icons";

// For Css
import './Found.css';
import stars from "./images/switch/stars.png";
import moon from "./images/switch/moon.png";
import m_front from "./images/switch/mountains_front.png";
import m_behind from "./images/switch/mountains_behind.png";
// Css Over

const { Meta } = Card;

export function Found() {
  const [loading, setLoading] = useState(true);
  const { address } = useAccount();
  useEffect(() => {
    setTimeout(() => {
      setLoading(false);
    }, 500);
  }, []);
  return (
      <div id="Switch-body" className="h-full justify-center items-center flex">
        <section>
          <img src={stars} alt="" id="stars" />
          <img src={moon} alt="" id="moon" />
          <img src={m_behind} alt="" id="mountain_behind" />
          <div id="fund" className="card w-96 bg-base-100 shadow-xl h-24 mt-24">
            <div className="card-body p-7">
              <button
                  className="btn w-full"
              >
                Purchase
              </button>
            </div>
          </div>
          <img src={m_front} alt="" id="mountain_front" />
        </section>
      </div>
  );
}
