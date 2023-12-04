import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:mul").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Mul", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Mul", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const overflow8 = 2 ** 8 / 2 + 1;
  const overflow16 = 2 ** 16 / 2 + 1;
  const overflow32 = 2 ** 32 / 2 + 1;

  const testCases = [
    {
      function: "mul(euint8,euint8)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow8,
          b: 2,
          expectedResult: Number(BigInt.asUintN(8, BigInt(overflow8 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint8,euint16)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: 2,
          b: overflow16,
          expectedResult: Number(BigInt.asUintN(16, BigInt(overflow16 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint8,euint32)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: 2,
          b: overflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint8,uint8)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow8,
          b: 2,
          expectedResult: Number(BigInt.asUintN(8, BigInt(overflow8 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(uint8,euint8)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow8,
          b: 2,
          expectedResult: Number(BigInt.asUintN(8, BigInt(overflow8 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint16,euint8)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow16,
          b: 2,
          expectedResult: Number(BigInt.asUintN(16, BigInt(overflow16 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint16,euint16)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow16,
          b: 2,
          expectedResult: Number(BigInt.asUintN(16, BigInt(overflow16 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint16,euint32)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: 2,
          b: overflow32,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint16,uint16)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow16,
          b: 2,
          expectedResult: Number(BigInt.asUintN(16, BigInt(overflow16 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(uint16,euint16)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow16,
          b: 2,
          expectedResult: Number(BigInt.asUintN(16, BigInt(overflow16 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint32,euint8)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow32,
          b: 2,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint32,euint16)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow32,
          b: 2,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint32,euint32)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow32,
          b: 2,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(euint32,uint32)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow32,
          b: 2,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
    {
      function: "mul(uint32,euint32)",
      cases: [
        { a: 2, b: 3, expectedResult: 6, name: "noraml" },
        {
          a: overflow32,
          b: 2,
          expectedResult: Number(BigInt.asUintN(32, BigInt(overflow32 * 2))),
          name: "overflow",
        },
      ],
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).mul(testCase.a, testCase.b, test.function, publicKey);
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
