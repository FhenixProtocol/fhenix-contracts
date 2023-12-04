import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:sub").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResult = await deploy("Sub", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResult.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Sub", deployResult.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResult.address);

  const aUnderflow = 1;
  const bUnderflow = 4;

  const testCases = [
    {
      function: "sub(euint8,euint8)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(8, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint8,euint16)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint8,euint32)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint8,uint8)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(8, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(uint8,euint8)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(8, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint16,euint8)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint16,euint16)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint16,euint32)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint16,uint16)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(uint16,euint16)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(16, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint32,euint8)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint32,euint16)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint32,euint32)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(euint32,uint32)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
    {
      function: "sub(uint32,euint32)",
      cases: [
        { a: 9, b: 4, expectedResult: 5, name: "noraml" },
        {
          a: aUnderflow,
          b: bUnderflow,
          expectedResult: Number(BigInt.asUintN(32, BigInt(aUnderflow - bUnderflow))),
          name: "underflow",
        },
      ],
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract.connect(signer).sub(testCase.a, testCase.b, test.function, publicKey);
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
