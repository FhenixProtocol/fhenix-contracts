import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:shl").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Shl", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Shl", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const cases = [
    { a: 0b10101010, b: 1, expectedResult: 0b101010100, name: "<<1" },
    { a: 0b10101010, b: 2, expectedResult: 0b1010101000, name: "<<2" },
    { a: 0b10101010, b: 3, expectedResult: 0b10101010000, name: "<<3" },
    { a: 0b10101010, b: 4, expectedResult: 0b101010100000, name: "<<4" },
    { a: 0b10101010, b: 5, expectedResult: 0b1010101000000, name: "<<5" },
  ];

  const testCases = [
    {
      function: "shl(euint8,euint8)",
      cases,
    },
    {
      function: "shl(euint8,euint16)",
      cases,
    },
    {
      function: "shl(euint8,euint32)",
      cases,
    },
    {
      function: "shl(euint8,uint8)",
      cases,
    },
    {
      function: "shl(uint8,euint8)",
      cases,
    },
    {
      function: "shl(euint16,euint8)",
      cases,
    },
    {
      function: "shl(euint16,euint16)",
      cases,
    },
    {
      function: "shl(euint16,euint32)",
      cases,
    },
    {
      function: "shl(euint16,uint16)",
      cases,
    },
    {
      function: "shl(uint16,euint16)",
      cases,
    },
    {
      function: "shl(euint32,euint8)",
      cases,
    },
    {
      function: "shl(euint32,euint16)",
      cases,
    },
    {
      function: "shl(euint32,euint32)",
      cases,
    },
    {
      function: "shl(euint32,uint32)",
      cases,
    },
    {
      function: "shl(uint32,euint32)",
      cases,
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).shl(testCase.a, testCase.b, test.function, publicKey);
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
