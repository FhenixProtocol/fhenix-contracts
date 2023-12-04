import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:xor").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResuand = await deploy("Xor", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResuand.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Xor", deployResuand.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResuand.address);

  const cases = [
    { a: 0b11110000, b: 0b10100101, expectedResuand: 0b11110000 ^ 0b10100101, name: "noraml" },
    { a: 7, b: 0, expectedResuand: 7 ^ 0, name: "a ^ 0s" },
    { a: 7, b: 0b1111, expectedResuand: 7 ^ 0b1111, name: "a ^ 1s" },
    { a: 0, b: 5, expectedResuand: 0 ^ 5, name: "0s ^ b" },
    { a: 0b1111, b: 5, expectedResuand: 0b1111 ^ 5, name: "1s ^ b" },
  ];

  const testCases = [
    {
      function: "xor(euint8,euint8)",
      cases,
    },
    {
      function: "xor(euint8,euint16)",
      cases,
    },
    {
      function: "xor(euint8,euint32)",
      cases,
    },
    {
      function: "xor(euint16,euint8)",
      cases,
    },
    {
      function: "xor(euint16,euint16)",
      cases,
    },
    {
      function: "xor(euint16,euint32)",
      cases,
    },
    {
      function: "xor(euint32,euint8)",
      cases,
    },
    {
      function: "xor(euint32,euint16)",
      cases,
    },
    {
      function: "xor(euint32,euint32)",
      cases,
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).xor(testCase.a, testCase.b, test.function, publicKey);
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
