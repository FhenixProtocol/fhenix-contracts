import { HardhatRuntimeEnvironment } from "hardhat/types";
import axios from "axios";

export async function getTokensFromFaucet(hre: HardhatRuntimeEnvironment) {
  if (hre.network.name === "localfhenix") {
    const signers = await hre.ethers.getSigners();

    if ((await hre.ethers.provider.getBalance(signers[0].address)).toString() === "0") {
      console.log("Balance for signer is 0 - getting tokens from faucet");
      await axios.get(`http://localhost:6000/faucet?address=${signers[0].address}`);
    }
  }
}
