import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:min").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Min", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Min", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const cases = [
    { a: 1, b: 2, expectedResult: 2, name: "a < b" },
    { a: 2, b: 1, expectedResult: 1, name: "a > b" },
    { a: 3, b: 3, expectedResult: 3, name: "a == b" },
  ];

  const testCases = [
    {
      function: "min(euint8,euint8)",
      cases,
    },
    {
      function: "min(euint8,euint16)",
      cases,
    },
    {
      function: "min(euint8,euint32)",
      cases,
    },
    {
      function: "min(euint8,uint8)",
      cases,
    },
    {
      function: "min(uint8,euint8)",
      cases,
    },
    {
      function: "min(euint16,euint8)",
      cases,
    },
    {
      function: "min(euint16,euint16)",
      cases,
    },
    {
      function: "min(euint16,euint32)",
      cases,
    },
    {
      function: "min(euint16,uint16)",
      cases,
    },
    {
      function: "min(uint16,euint16)",
      cases,
    },
    {
      function: "min(euint32,euint8)",
      cases,
    },
    {
      function: "min(euint32,euint16)",
      cases,
    },
    {
      function: "min(euint32,euint32)",
      cases,
    },
    {
      function: "min(euint32,uint32)",
      cases,
    },
    {
      function: "min(uint32,euint32)",
      cases,
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).min(testCase.a, testCase.b, test.function, publicKey);
        const decryptedOutput = instance.decrypt(deployResult.address, encryptedOutput);

        if (decryptedOutput === testCase.expectedResult) {
          console.log(`${test.function} ${testCase.name}: OK`);
        } else {
          console.log(
            `${test.function} ${testCase.name}: FAIL - got: ${decryptedOutput} != expected: ${testCase.expectedResult}`,
          );
        }
      } catch (error) {
        console.log(`${test.function} ${testCase.name}: FAIL - ${error}`);
      }
    }
  }
});
