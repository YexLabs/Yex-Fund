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
  );
}
