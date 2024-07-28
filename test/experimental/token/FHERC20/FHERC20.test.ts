const { BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

import hre from "hardhat";
const { ZERO_ADDRESS } = constants;

const {
  shouldBehaveLikeFHERC20,
  shouldBehaveLikeFHERC20Transfer,
  shouldBehaveLikeFHERC20Approve,
} = require('./FHERC20.behavior');
const { expectRevertCustomError } = require('../../../helpers/customError');

const TOKENS = [
  { Token: artifacts.require('$FHERC20') },
];

contract('FHERC20 encrypted', function (accounts) {
  const [initialHolder, recipient] = accounts;

  const name = 'My Token';
  const symbol = 'MTKN';
  const initialSupply = 100n;

  for (const { Token, forcedApproval } of TOKENS) {
    describe(`using ${Token._json.contractName}`, function () {
      before(async function () {
        this.signers = (await ethers.getSigners()).slice(0, 3);
        this.getPermission = async address => {
          const signer = this.signers.find(s => s.address === address);
          const permit = await fhenixjs.generatePermit(this.token.address, undefined, signer)
          return fhenixjs.extractPermitPermission(permit);
        }
      });

      beforeEach(async function () {
        // get sufficient funds
        const { ethers, deployments } = hre;
        const [signer, spender] = this.signers;

        // fund first account: owner
        if ((await ethers.provider.getBalance(signer.address)).toString() === "0") {
          await fhenixjs.getFunds(signer.address);
        }

        // fund second account as it is sometimes an allowed spender
        if ((await ethers.provider.getBalance(spender.address)).toString() === "0") {
          await fhenixjs.getFunds(spender.address);
        }

        this.token = await Token.new(name, symbol);

        const encryptedInitialSupply = await fhenixjs.encrypt_uint128(initialSupply);
        await this.token.$_mintEncrypted(initialHolder, encryptedInitialSupply);
      });

      shouldBehaveLikeFHERC20(initialSupply, accounts, { forcedApproval});

      describe('_mintEncrypted', function () {
        const value = 50n;
        // FHERC20 doesn't have a special case for the zero address
        it.skip('rejects a null account', async function () {
          await expectRevertCustomError(this.token.$_mintEncrypted(ZERO_ADDRESS, value), 'ERC20InvalidReceiver', [ZERO_ADDRESS]);
        });

        describe('for a non zero account', function () {
          beforeEach('minting', async function () {
            const encryptedValue = await fhenixjs.encrypt_uint128(value);
            this.receipt = await this.token.$_mintEncrypted(recipient, encryptedValue);
          });

          // Not yet implmeneted:
          it.skip('increments totalSupply', async function () {
            const expectedSupply = initialSupply.add(value);
            expect(await this.token.totalSupply()).to.be.bignumber.equal(expectedSupply);
          });

          it('increments recipient balance', async function () {
            const balanceEnc = await this.token.balanceOfEncrypted(recipient, await this.getPermission(recipient))
            const balance = fhenixjs.unseal(this.token.address, balanceEnc);
            expect(balance).to.equal(value);
          });
        });
      });

      // FHERC20 doesn't have a special case for the zero address
      describe.skip('_transferImpl', function () {
        const value = 1n;

        it('from is the zero address', async function () {
          const balanceBefore = await this.token.balanceOf(initialHolder);

          await this.token.$_transferImpl(ZERO_ADDRESS, initialHolder, value);

          // total encrypted supply not implemented:
          // const totalSupply = await this.token.getEncryptedTotalSupply();
          // expect(await this.token.getEncryptedTotalSupply()).to.be.bignumber.equal(totalSupply.add(value));
          // expect(await this.token.balanceOf(initialHolder)).to.be.bignumber.equal(balanceBefore.add(value));
        });

        it('to is the zero address', async function () {
          const balanceBefore = await this.token.balanceOf(initialHolder);
          // const totalSupply = await this.token.getTotalEncryptedSupply();

          await this.token.$_transferImpl(initialHolder, ZERO_ADDRESS, value)
          // expect(await this.token.getTotalEncryptedSupply()).to.be.bignumber.equal(totalSupply.sub(value));
          expect(await this.token.balanceOfEncrypted(initialHolder)).to.be.bignumber.equal(balanceBefore.sub(value));
        });
      });
    });
  }
});
