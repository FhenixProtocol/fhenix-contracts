import { ethers } from "hardhat";
import hre from "hardhat";

import { waitForBlock, getTokensFromFaucet } from "../../utils/block";
import { createFheInstance } from "../../utils/instance";
import type { Signers } from "../types";
import { shouldBehaveLikeAdd } from "./Add.behavior";
import { deployAddFixture } from "./Add.fixture";

describe("Unit tests", function () {
  before(async function () {
    this.signers = {} as Signers;

    // get tokens from faucet if we're on localfhenix and don't have a balance
    await getTokensFromFaucet(hre);

    // deploy test contract
    const { add, address } = await deployAddFixture();
    this.add = add;

    // initiate fhevmjs
    this.instance = await createFheInstance(hre, address);

    // set admin account/signer
    const signers = await ethers.getSigners();
    this.signers.admin = signers[0];

    // wait for deployment block to finish
    await waitForBlock(hre);
  });

  describe("Add", function () {
    shouldBehaveLikeAdd();
  });
});
