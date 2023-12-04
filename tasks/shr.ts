import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:shr").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Shr", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Shr", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const cases = [
    { a: 0b10101010, b: 1, expectedResult: 0b01010101, name: ">>1" },
    { a: 0b10101010, b: 2, expectedResult: 0b00101010, name: ">>2" },
    { a: 0b10101010, b: 3, expectedResult: 0b00010101, name: ">>3" },
    { a: 0b10101010, b: 4, expectedResult: 0b00001010, name: ">>4" },
    { a: 0b10101010, b: 5, expectedResult: 0b00000101, name: ">>5" },
  ];

  const testCases = [
    {
      function: "shr(euint8,euint8)",
      cases,
    },
    {
      function: "shr(euint8,euint16)",
      cases,
    },
    {
      function: "shr(euint8,euint32)",
      cases,
    },
    {
      function: "shr(euint8,uint8)",
      cases,
    },
    {
      function: "shr(uint8,euint8)",
      cases,
    },
    {
      function: "shr(euint16,euint8)",
      cases,
    },
    {
      function: "shr(euint16,euint16)",
      cases,
    },
    {
      function: "shr(euint16,euint32)",
      cases,
    },
    {
      function: "shr(euint16,uint16)",
      cases,
    },
    {
      function: "shr(uint16,euint16)",
      cases,
    },
    {
      function: "shr(euint32,euint8)",
      cases,
    },
    {
      function: "shr(euint32,euint16)",
      cases,
    },
    {
      function: "shr(euint32,euint32)",
      cases,
    },
    {
      function: "shr(euint32,uint32)",
      cases,
    },
    {
      function: "shr(uint32,euint32)",
      cases,
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).shr(testCase.a, testCase.b, test.function, publicKey);
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
