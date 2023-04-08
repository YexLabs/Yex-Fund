describe("NFTMarkettest", function() {
    it("Should list another sales", async function() {
      console.log("start")
      const [dev] = await ethers.getSigners()
      const vaultAddress = '0xd11fF339a9C407Bb690Bd3dBA4e38157EfE9ac90'
      const OTCAddress = '0xd11fF339a9C407Bb690Bd3dBA4e38157EfE9ac90'
      const aAddress = "0x8F393015E1Bbea61e41c808E560942292D104386"
      const abi = [ "function authorizePermit(IERC20 token, address account) "
    ];

      const vault = new ethers.Contract(vaultAddress, abi, dev)
     await vault.authorizePermit(aAddress, OTCAddress)
      console.log("set success")


  })
})