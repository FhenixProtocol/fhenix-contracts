import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:gasUsage").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResuand = await deploy("GasUsage", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResuand.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("GasUsage", deployResuand.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResuand.address);

  const functions = [
    "add",
    "and",
    "asEbool",
    "asEuint16",
    "asEuint32",
    "asEuint8",
    "cmux",
    "eq",
    "ge",
    "gt",
    "le",
    "lt",
    "max",
    "min",
    "mul",
    "ne",
    "neg",
    "not",
    "optReq",
    "or",
    "reencrypt",
    "shl",
    "shr",
    "sub",
    "xor",
  ];

  for (const fn of functions) {
    try {
      const encryptedOutput = await contract.connect(signer).gasUsage(fn, publicKey);
      console.log(`${fn}: GAS - ${encryptedOutput.gasLimit}`);
    } catch (error) {
      console.log(`${fn}: FAIL - ${error}`);
    }
  }
});
