import React, { useEffect, useState } from "react";
import { Card, Avatar } from "antd";
import ethicon from "./images/pools/eth.png";

const { Meta } = Card;

export function Pools() {
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    setTimeout(() => {
      setLoading(false);
    }, 2000);
  }, []);
  return (
    <div>
      <div className="ml-4">
        <Card
          style={{
            width: 220,
            height: 270,
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
            title="TWT-GLP  LP"
            description={
              <div className="mt-4">
                <p>TWT: 1000</p>
                <p>GLP: 1000</p>
              </div>
            }
          />
        </Card>
      </div>
    </div>
  );
}
