import axios from "axios";
import { ethers } from "hardhat";
import hre from "hardhat";

import type { Add } from "../../types";
import { waitForBlock } from "../../utils/block";

export async function deployAddFixture(): Promise<{ add: Add; address: string }> {
  const signers = await ethers.getSigners();
  const admin = signers[0];

  const addFactory = await ethers.getContractFactory("Add");
  const add = await addFactory.connect(admin).deploy();
  // await greeter.waitForDeployment();
  const address = await add.getAddress();
  return { add, address };
}
