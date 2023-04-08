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
          <div>
            <div className="ml-4">
              <Card
                style={{
                  width: 220,
                  height: 250,
                  marginTop: 16,
                }}
                hoverable
                loading={loading}
              >
                <Meta
                  avatar={
                    <div>
                      <Badge size="small" count={5}>
                        <Avatar src={ethicon} />
                      </Badge>
                    </div>
                  }
                  title={
                    <Button type="primary" ghost>
                      采购
                    </Button>
                  }
                  // description={
                  // }
                />
              </Card>
            </div>
          </div>
        </section>
      </div>
  );
}
