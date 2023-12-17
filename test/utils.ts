import { FhevmInstance, createInstance } from "fhevmjs";
import { EIP712 } from "fhevmjs/lib/sdk/token";
import { ethers } from 'hardhat';

export interface FheContract {
    instance: FhevmInstance;
    publicKey: Uint8Array;
    token: EIP712;
}

export async function createFheInstance(contractAddress: string): Promise<FheContract> {
    const provider = ethers.provider;

    // Get the chainId
    const fhenix = await provider.getNetwork();
    const chainId = fhenix.chainId;

    // workaround for call not working the first time on a fresh chain
    let fhePublicKey = await ethers.provider.send("eth_getNetworkPublicKey");
    const instance = createInstance({ chainId: Number(chainId), publicKey: fhePublicKey });
    const genTokenResponse = instance.then((ins) => {
        return ins.generateToken({ verifyingContract: contractAddress });
    });

    return Promise.all([instance, genTokenResponse]).then((arr) => {
        return { instance: arr[0], publicKey: arr[1].publicKey, token: arr[1].token };
    });
}