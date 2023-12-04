import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:asEbool").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("AsEbool", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("AsEbool", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const tests = ["asEboolEuint8", "asEboolEuint16", "asEboolEuint32", "asEboolBool"];
  for (const test of tests) {
    for (const input of [0, 1]) {
      try {
        let plaintextInput = input;

        //@ts-expect-error
        let encryptedOutput = await contract.connect(signer)[test](plaintextInput, publicKey);
        let decryptedOutput = instance.decrypt(deployResult.address, encryptedOutput);

        if (decryptedOutput === plaintextInput) {
          console.log(`${test}(${input}): OK`);
        } else {
          console.log(`${test}(${input}): FAIL - ${decryptedOutput} != ${plaintextInput}`);
        }
      } catch (error) {
        console.log(`${test}(${input}): FAIL - ${error}`);
      }
    }
  }

  for (const input of [0, 1]) {
    try {
      let plaintextInput = input;

      const ciphertextInput = instance.encrypt32(plaintextInput);

      let encryptedOutput = await contract.connect(signer).asEboolBytes(ciphertextInput, publicKey);
      let decryptedOutput = instance.decrypt(deployResult.address, encryptedOutput);

      if (decryptedOutput === plaintextInput) {
        console.log(`asEboolBytes(${input}): OK`);
      } else {
        console.log(`asEboolBytes(${input}): FAIL - ${decryptedOutput} != ${plaintextInput}`);
      }
    } catch (error) {
      console.log(`asEboolBytes(${input}): FAIL - ${error}`);
    }
  }
});
