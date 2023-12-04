import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:reencrypt").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Reencrypt", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Reencrypt", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const tests = ["reencrypt(euint8)", "reencrypt(euint16)", "reencrypt(euint32)"];
  for (const test of tests) {
    try {
      let plaintextInput = Math.floor(Math.random() * 1000) % 256;

      let encryptedOutput = await contract.connect(signer).reencrypt(plaintextInput, test, publicKey);
      let decryptedOutput = instance.decrypt(deployResult.address, encryptedOutput);

      if (decryptedOutput === plaintextInput) {
        console.log(`${test}: OK`);
      } else {
        console.log(`${test}: FAIL - ${decryptedOutput} != ${plaintextInput}`);
      }
    } catch (error) {
      console.log(`${test}: FAIL - ${error}`);
    }
  }
});
