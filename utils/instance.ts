import { FhevmInstance, createInstance } from "fhevmjs";
import { EIP712 } from "fhevmjs/lib/sdk/token";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";

import { waitForBlock } from "./block";

export interface FheContract {
  instance: FhevmInstance;
  publicKey: Uint8Array;
  token: EIP712;
}

export async function createFheInstance(hre: HardhatRuntimeEnvironment, contractAddress: string): Promise<FheContract> {
  const { ethers } = hre;

  const chainId = await hre.getChainId();

  // workaround for call not working the first time on a fresh chain
  let fhePublicKey;
  try {
    fhePublicKey = await ethers.provider.call({ to: "0x0000000000000000000000000000000000000044" });
  } catch (_) {
    await waitForBlock(hre);
    fhePublicKey = await ethers.provider.call({ to: "0x0000000000000000000000000000000000000044" });
  }
  const instance = createInstance({ chainId: Number(chainId), publicKey: fhePublicKey });
  const genTokenResponse = instance.then((ins) => {
    return ins.generateToken({ verifyingContract: contractAddress });
  });

  return Promise.all([instance, genTokenResponse]).then((arr) => {
    return { instance: arr[0], publicKey: arr[1].publicKey, token: arr[1].token };
  });
}
