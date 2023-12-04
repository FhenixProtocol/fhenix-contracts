import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:optReq").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResuand = await deploy("OptReq", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResuand.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("OptReq", deployResuand.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResuand.address);

  const one = instance.encrypt8(1);

  console.log("tryingn one...");
  await contract.connect(signer).optReq(one);

  const zero = instance.encrypt8(1);

  console.log("tryingn zero...");
  await contract.connect(signer).optReq(zero);
});
