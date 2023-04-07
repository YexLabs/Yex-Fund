import { WagmiConfig, createClient, configureChains } from "wagmi";
import {
  ConnectKitProvider,
  ConnectKitButton,
  getDefaultClient,
} from "connectkit";
import { mainnet, goerli, InjectedConnector } from "@wagmi/core";
import { publicProvider } from "wagmi/providers/public";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import logo from "./logo.svg";
import "./App.css";
import { useEffect } from "react";

const alchemyId = process.env.ALCHEMY_ID;

const { chains, provider } = configureChains(
  [goerli],
  [
    // alchemyProvider({ apiKey: process.env.ALCHEMY_ID }),
    publicProvider(),
  ]
);

const client = createClient({
  autoConnect: true,
  connectors: [new InjectedConnector({ chains })],
  provider,
});

const App = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const BuySell = () => {
    navigate("/Switch");
  };
  const ExchangeClick = () => {
    navigate("/Exchange");
  };
  useEffect(() => {
    if (location.pathname === "/") {
      navigate("/Switch");
    }
  }, []);

  return (
    <WagmiConfig client={client}>
      <div className="flex flex-col h-screen">
        <div id="Top-line" className="flex justify-between h-16">
          <div className="flex flex-row">
            <div className="ml-2 flex justify-center flex-col">
              <img className="h-8" src={logo} />
            </div>
            <div className="justify-center flex flex-col ml-1 text-white">
              <div
                className="btn btn-sm btn-ghost text-xl"
                onClick={() => BuySell()}
              >
                Switch
              </div>
            </div>
            <div className="justify-center flex flex-col ml-1 text-white">
              <div
                className="btn btn-sm btn-ghost text-xl"
                onClick={() => ExchangeClick()}
              >
                Exchange
              </div>
            </div>
          </div>
          <div className="mr-5 justify-center flex flex-col">
            <ConnectKitProvider>
              <ConnectKitButton />
            </ConnectKitProvider>
          </div>
        </div>
        <div className=" flex-grow">
          <Outlet />
        </div>
      </div>
    </WagmiConfig>
  );
};

export default App;
