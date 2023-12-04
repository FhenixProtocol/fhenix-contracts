import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:or").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResuand = await deploy("Or", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResuand.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Or", deployResuand.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResuand.address);

  const cases = [
    { a: 9, b: 15, expectedResuand: 9 | 15, name: "noraml" },
    { a: 7, b: 0, expectedResuand: 7, name: "a | 0" },
    { a: 0, b: 5, expectedResuand: 5, name: "0 | b" },
  ];

  const testCases = [
    {
      function: "or(euint8,euint8)",
      cases,
    },
    {
      function: "or(euint8,euint16)",
      cases,
    },
    {
      function: "or(euint8,euint32)",
      cases,
    },
    {
      function: "or(euint16,euint8)",
      cases,
    },
    {
      function: "or(euint16,euint16)",
      cases,
    },
    {
      function: "or(euint16,euint32)",
      cases,
    },
    {
      function: "or(euint32,euint8)",
      cases,
    },
    {
      function: "or(euint32,euint16)",
      cases,
    },
    {
      function: "or(euint32,euint32)",
      cases,
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).or(testCase.a, testCase.b, test.function, publicKey);
        const decryptedOutput = instance.decrypt(deployResuand.address, encryptedOutput);

        if (decryptedOutput === testCase.expectedResuand) {
          console.log(`${test.function} ${testCase.name}: OK`);
        } else {
          console.log(
            `${test.function} ${testCase.name}: FAIL - got: ${decryptedOutput} != expected: ${testCase.expectedResuand}`,
          );
        }
      } catch (error) {
        console.log(`${test.function} ${testCase.name}: FAIL - ${error}`);
      }
    }
  }
});
