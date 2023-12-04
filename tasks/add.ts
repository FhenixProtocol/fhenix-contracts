import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:add").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Add", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Add", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const aOverflow8 = 2 ** 8 - 1;
  const aOverflow16 = 2 ** 16 - 1;
  const aOverflow32 = 2 ** 32 - 1;

  const bOverflow8 = aOverflow8 - 1;
  const bOverflow16 = aOverflow16 - 1;
  const bOverflow32 = aOverflow32 - 1;

  const testCases = [
    {
      function: "add(euint8,euint8)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow8,
          b: bOverflow8,
          expectedResult: Number(BigInt.asUintN(8, BigInt(aOverflow8 + bOverflow8))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint8,euint16)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow8,
          b: bOverflow16,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aOverflow8 + bOverflow16))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint8,euint32)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow8,
          b: bOverflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow8 + bOverflow32))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint8,uint8)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow8,
          b: bOverflow8,
          expectedResult: Number(BigInt.asUintN(8, BigInt(aOverflow8 + bOverflow8))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(uint8,euint8)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow8,
          b: bOverflow8,
          expectedResult: Number(BigInt.asUintN(8, BigInt(aOverflow8 + bOverflow8))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint16,euint8)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow16,
          b: bOverflow8,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aOverflow16 + bOverflow8))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint16,euint16)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow16,
          b: bOverflow16,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aOverflow16 + bOverflow16))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint16,euint32)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow16,
          b: bOverflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow16 + bOverflow32))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint16,uint16)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow16,
          b: bOverflow16,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aOverflow16 + bOverflow16))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(uint16,euint16)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow16,
          b: bOverflow16,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aOverflow16 + bOverflow16))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint32,euint8)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow32,
          b: bOverflow8,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow32 + bOverflow8))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint32,euint16)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow32,
          b: bOverflow16,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow32 + bOverflow16))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint32,euint32)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow32,
          b: bOverflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow32 + bOverflow32))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(euint32,uint32)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow32,
          b: bOverflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow32 + bOverflow32))),
          name: "overflow",
        },
      ],
    },
    {
      function: "add(uint32,euint32)",
      cases: [
        { a: 1, b: 2, expectedResult: 3, name: "noraml" },
        {
          a: aOverflow32,
          b: bOverflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aOverflow32 + bOverflow32))),
          name: "overflow",
        },
      ],
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).add(testCase.a, testCase.b, test.function, publicKey);
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
