import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:not").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResuand = await deploy("Not", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResuand.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Not", deployResuand.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResuand.address);

  const testCases = [
    {
      function: "not(euint8)",
      cases: [{ value: 0b11110000, expectedResuand: ~0b11110000 }],
    },
    {
      function: "not(euint16)",
      cases: [{ value: 0b0101010111110000, expectedResuand: ~0b0101010111110000 }],
    },
    {
      function: "not(euint32)",
      cases: [{ value: 0b10101010101011000101010111110000, expectedResuand: ~0b10101010101011000101010111110000 }],
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).not(testCase.value, test.function, publicKey);
        const decryptedOutput = instance.decrypt(deployResuand.address, encryptedOutput);

        if (decryptedOutput === testCase.expectedResuand) {
          console.log(`${test.function}: OK`);
        } else {
          console.log(`${test.function}: FAIL - got: ${decryptedOutput} != expected: ${testCase.expectedResuand}`);
        }
      } catch (error) {
        console.log(`${test.function}: FAIL - ${error}`);
      }
    }
  }
});
