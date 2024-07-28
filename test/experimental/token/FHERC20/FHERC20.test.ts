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

        console.log("deploying token"); // todo (eshel): remove
        this.token = await Token.new(name, symbol);

        const encryptedInitialSupply = await fhenixjs.encrypt_uint128(initialSupply);
        await this.token.$_mintEncrypted(initialHolder, encryptedInitialSupply);
        console.log("minted"); // todo (eshel) remove
        console.log("initial holder:", initialHolder); // todo (eshel) remove
      });

      shouldBehaveLikeFHERC20(initialSupply, accounts, { forcedApproval});

      describe('_mintEncrypted', function () {
        const value = new BN(50);
        // this is not implemented:
        // it('rejects a null account', async function () {
        //   await expectRevertCustomError(this.token.$_mintEncrypted(ZERO_ADDRESS, value), 'ERC20InvalidReceiver', [ZERO_ADDRESS]);
        // });

        describe('for a non zero account', function () {
          beforeEach('minting', async function () {
            this.receipt = await this.token.$_mintEncrypted(recipient, value);
          });

          // this is not yet implmeneted:
          // it('increments totalSupply', async function () {
          //   const expectedSupply = initialSupply.add(value);
          //   expect(await this.token.totalSupply()).to.be.bignumber.equal(expectedSupply);
          // });

          it('increments recipient balance', async function () {
            expect(await this.token.balanceOf(recipient)).to.be.bignumber.equal(value);
          });
        });
      });

      // these encrypted functions are commented out as they don't deal with zero-addresses in a special way, like in ERC20
      // describe('_transferImpl', function () {
      //   const value = new BN(1);
      //
      //   it('from is the zero address', async function () {
      //     const balanceBefore = await this.token.balanceOf(initialHolder);
      //
      //     await this.token.$_transferImpl(ZERO_ADDRESS, initialHolder, value);
      //
      //     // total encrypted supply not implemented:
      //     // const totalSupply = await this.token.getEncryptedTotalSupply();
      //     // expect(await this.token.getEncryptedTotalSupply()).to.be.bignumber.equal(totalSupply.add(value));
      //     expect(await this.token.balanceOf(initialHolder)).to.be.bignumber.equal(balanceBefore.add(value));
      //   });
      //
      //   it('to is the zero address', async function () {
      //     const balanceBefore = await this.token.balanceOf(initialHolder);
      //     // const totalSupply = await this.token.getTotalEncryptedSupply();
      //
      //     await this.token.$_transferEncrypted(initialHolder, ZERO_ADDRESS, value)
      //     // expect(await this.token.getTotalEncryptedSupply()).to.be.bignumber.equal(totalSupply.sub(value));
      //     expect(await this.token.balanceOfEncrypted(initialHolder)).to.be.bignumber.equal(balanceBefore.sub(value));
      //   });
      // });

      describe('_transferEncrypted', function () {
        shouldBehaveLikeFHERC20Transfer(initialHolder, recipient, initialSupply, function (from, to, value) {
          return this.token.$_transferEncrypted(from, to, value);
        });

        // describe('when the sender is the zero address', function () {
        //   it('reverts', async function () {
        //     await expectRevertCustomError(
        //       this.token.$_transfer(ZERO_ADDRESS, recipient, initialSupply),
        //       'ERC20InvalidSender',
        //       [ZERO_ADDRESS],
        //     );
        //   });
        // });
      });

      describe('_approve', function () {
        shouldBehaveLikeFHERC20Approve(initialHolder, recipient, initialSupply, function (owner, spender, value) {
          return this.token.$_approve(owner, spender, value);
        });

        describe('when the owner is the zero address', function () {
          it('reverts', async function () {
            await expectRevertCustomError(
              this.token.$_approve(ZERO_ADDRESS, recipient, initialSupply),
              'ERC20InvalidApprover',
              [ZERO_ADDRESS],
            );
          });
        });
      });
    });
  }
});
