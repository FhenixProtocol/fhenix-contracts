import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

import { createFheInstance } from "../utils/instance";

task("task:cmux").setAction(async function (taskArguments: TaskArguments, hre) {
  const { ethers, deployments } = hre;

  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = deployments;

  const deployResuand = await deploy("Cmux", {
    from: deployer,
    args: [],
    log: true,
    skipIfAlreadyDeployed: false,
  });

  console.log("contract:", deployResuand.address);

  const [signer] = await ethers.getSigners();

  const contract = await ethers.getContractAt("Cmux", deployResuand.address);

  const { instance, publicKey } = await createFheInstance(hre, deployResuand.address);

  const cases = [
    { control: true, a: 2, b: 3, expectedResuand: 2, name: "true" },
    { control: false, a: 2, b: 3, expectedResuand: 3, name: "false" },
  ];

  const testCases = [
    {
      function: "cmux(ebool,euint8,euint8)",
      cases,
    },
    {
      function: "cmux(ebool,euint16,euint16)",
      cases,
    },
    {
      function: "cmux(ebool,euint32,euint32)",
      cases,
    },
  ];

  for (const test of testCases) {
    for (const testCase of test.cases) {
      try {
        const encryptedOutput = await contract
          .connect(signer)
          .cmux(testCase.control, testCase.a, testCase.b, test.function, publicKey);
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
