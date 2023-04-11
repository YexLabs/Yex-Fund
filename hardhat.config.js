/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
module.exports = {
  solidity: "0.8.18",
  networks: {
    hardhat:{
      timeout:60000,
    },
    scrollAlpha: {
      setTimeout:60000,
      url: "https://alpha-rpc.scroll.io/l2" || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
};
