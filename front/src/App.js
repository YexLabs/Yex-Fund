import { WagmiConfig, createClient } from "wagmi";
import {
  ConnectKitProvider,
  ConnectKitButton,
  getDefaultClient,
} from "connectkit";
import { mainnet, goerli, scrollTestnet } from "@wagmi/chains";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import logo from "./components/images/scroll.png";
import "./App.css";
import { useEffect } from "react";
import AppHeader from "./components/AppHeader";
import Network from "./components/Network";
import Footer from "./components/Footer";

const alchemyId = process.env.REACT_APP_ALCHEMY_ID;

const chains = [scrollTestnet, goerli, mainnet];

const client = createClient(
  getDefaultClient({
    appName: "GLD DeFi",
    alchemyId,
    chains,
  })
);

const App = () => {
  const location = useLocation();
  const navigate = useNavigate();
  // const BuySell = () => {
  //   navigate("/Switch");
  // };
  // const ExchangeClick = () => {
  //   navigate("/Exchange");
  // };
  // const PoolsClick = () => {
  //   navigate("/Pools");
  // };
  // const FoundClick = () => {
  //   navigate("/Found");
  // };
  const LogoClick = () => {
    navigate("/main");
  };
  useEffect(() => {
    if (location.pathname === "/") {
      navigate("/main");
    }
  }, []);

  return (
    <div className="h-screen">
      <WagmiConfig client={client}>
        <div className="fixed top-0 left-0 w-full h-full z-0 bg-gradient-to-r from-purple-100 to-blue-100 overflow-y-auto overflow-x-hidden">
          <AppHeader />
          {/* <div id="" className="flex justify-between h-16">
          <div className="flex flex-row">
            <div className="ml-2 flex justify-center flex-col">
              <img className="h-12 ml-1" src={logo} />
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
            <div className="justify-center flex flex-col ml-1 text-white">
              <div
                className="btn btn-sm btn-ghost text-xl"
                onClick={() => PoolsClick()}
              >
                POOLS
              </div>
            </div>
            <div className="justify-center flex flex-col ml-1 text-white">
              <div
                className="btn btn-sm btn-ghost text-xl"
                onClick={() => FoundClick()}
              >
                FUND
              </div>
            </div>
          </div>
          <div className="mr-5 justify-center flex flex-col">
            <ConnectKitProvider>
              <ConnectKitButton />
            </ConnectKitProvider>
          </div>
        </div> */}
          <Network />
          <Outlet />
          <Footer />
        </div>
      </WagmiConfig>
    </div>
  );
};

export default App;
