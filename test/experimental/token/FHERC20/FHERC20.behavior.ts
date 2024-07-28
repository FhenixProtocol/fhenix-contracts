import {defineGetterMemoized} from "solidity-docgen/dist/utils/memoized-getter";

const { BN, constants, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ZERO_ADDRESS, MAX_UINT256 } = constants;

const { expectRevertCustomError } = require('../../../helpers/customError');

function shouldBehaveLikeFHERC20(initialSupply, accounts, opts = {}) {
  const [initialHolder, recipient, anotherAccount] = accounts;
  const { forcedApproval } = opts;

  // todo (eshel) remove
  describe('balanceOfEncrypted', function () {
    describe('when the requested account has no tokens', function () {
      it('returns zero', async function () {
        const balanceEnc = await this.token.balanceOfEncrypted(anotherAccount, await this.getPermission(anotherAccount))
        const balance = fhenixjs.unseal(this.token.address, balanceEnc);
        expect(balance).to.equal(0n);
      });
    });

    describe('when the requested account has some tokens', function () {
      it('returns the total token value', async function () {
        const balanceEnc = await this.token.balanceOfEncrypted(initialHolder, await this.getPermission(initialHolder))
        const balance = fhenixjs.unseal(this.token.address, balanceEnc);
        expect(balance).to.equal(initialSupply);
      });
    });
  });

  describe('transferEncrypted', function () {
    shouldBehaveLikeFHERC20Transfer(initialHolder, recipient, initialSupply, async function (from, to, value) {
      const encryptedValue = await fhenixjs.encrypt_uint128(100n);
      return this.token.transferEncrypted(to, encryptedValue, { from });
    });
  });

  describe('transfer from encrypted', function () {
    const spender = recipient;

    describe('when the token owner is not the zero address', function () {
      const tokenOwner = initialHolder;

      describe('when the recipient is not the zero address', function () {
        const to = anotherAccount;

        describe('when the spender has enough allowance', function () {
          beforeEach(async function () {
            await this.token.approveEncrypted(spender, initialSupply, { from: initialHolder });
          });

          describe('when the token owner has enough balance', function () {
            const value = initialSupply;

            it('transfers the requested value', async function () {
              await this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender });

              expect(await this.token.balanceOfEncrypted(tokenOwner)).to.be.bignumber.equal('0');

              expect(await this.token.balanceOfEncrypted(to)).to.be.bignumber.equal(value);
            });

            it('decreases the spender allowance', async function () {
              await this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender });

              expect(await this.token.allowanceEncrypted(tokenOwner, spender)).to.be.bignumber.equal('0');
            });

            it('emits a transfer event', async function () {
              expectEvent(await this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender }), 'Transfer', {
                from: tokenOwner,
                to: to,
                value: value,
              });
            });
          });

          describe('when the token owner does not have enough balance', function () {
            const value = initialSupply;

            beforeEach('reducing balance', async function () {
              await this.token.transfer(to, 1, { from: tokenOwner });
            });

            it('reverts', async function () {
              await expectRevertCustomError(
                this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender }),
                'ERC20InsufficientBalance',
                [tokenOwner, value - 1n, value],
              );
            });
          });
        });

        describe('when the spender does not have enough allowance', function () {
          const allowance = initialSupply - 1n;

          beforeEach(async function () {
            await this.token.approveEncrypted(spender, allowance, { from: tokenOwner });
          });

          describe('when the token owner has enough balance', function () {
            const value = initialSupply;

            it('reverts', async function () {
              await expectRevertCustomError(
                this.token.transferFrom(tokenOwner, to, value, { from: spender }),
                'ERC20InsufficientAllowance',
                [spender, allowance, value],
              );
            });
          });

          describe('when the token owner does not have enough balance', function () {
            const value = allowance;

            beforeEach('reducing balance', async function () {
              await this.token.transferEncrypted(to, 2, { from: tokenOwner });
            });

            it('reverts', async function () {
              await expectRevertCustomError(
                this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender }),
                'ERC20InsufficientBalance',
                [tokenOwner, value - 1n, value],
              );
            });
          });
        });

        describe('when the spender has unlimited allowance', function () {
          beforeEach(async function () {
            await this.token.approve(spender, MAX_UINT256, { from: initialHolder });
          });

          it('does not decrease the spender allowance', async function () {
            await this.token.transferFromEncrypted(tokenOwner, to, 1, { from: spender });

            expect(await this.token.allowanceEncrypted(tokenOwner, spender)).to.be.bignumber.equal(MAX_UINT256);
          });
        });
      });

      describe('when the recipient is the zero address', function () {
        const value = initialSupply;
        const to = ZERO_ADDRESS;

        beforeEach(async function () {
          await this.token.approveEncrypted(spender, value, { from: tokenOwner });
        });

        it('reverts', async function () {
          await expectRevertCustomError(
            this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender }),
            'ERC20InvalidReceiver',
            [ZERO_ADDRESS],
          );
        });
      });
    });

    describe('when the token owner is the zero address', function () {
      const value = 0;
      const tokenOwner = ZERO_ADDRESS;
      const to = recipient;

      it('reverts', async function () {
        await expectRevertCustomError(
          this.token.transferFromEncrypted(tokenOwner, to, value, { from: spender }),
          'ERC20InvalidApprover',
          [ZERO_ADDRESS],
        );
      });
    });
  });

  describe('approve', function () {
    shouldBehaveLikeFHERC20Approve(initialHolder, recipient, initialSupply, function (owner, spender, value) {
      return this.token.approveEncrypted(spender, value, { from: owner });
    });
  });
}

function shouldBehaveLikeFHERC20Transfer(from, to, balance, transfer) {
  describe('when the recipient is not the zero address', function () {
    describe('when the sender does not have enough balance', function () {
      const value = balance + 1n;

      it.only("doesn't tranfer value", async function () {
        console.log("calling transferEncrypted");
        await transfer.call(this, from, to, value);
        console.log("called transferEncrypted");

        // const balanceEnc = await this.token.balanceOfEncrypted(from, await this.getPermission(from))
        // const balanceAfter = fhenixjs.unseal(this.token.address, balanceEnc);
        // console.log("balanceAfterFrom:", balanceAfter);
        // expect(balanceAfter).to.equal(balance);
        //
        // const balanceToEnc = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
        // const balanceToAfter = fhenixjs.unseal(this.token.address, balanceToEnc);
        // console.log("balanceAfterTo:", balanceAfter);
        // expect(balanceToAfter).to.equal(0n);
      });
    });

    describe('when the sender transfers all balance', function () {
      const value = balance;

      it('transfers the requested value', async function () {
        await transfer.call(this, from, to, value);

        expect(await this.token.balanceOfEncrypted(from)).to.be.bignumber.equal('0');

        expect(await this.token.balanceOfEncrypted(to)).to.be.bignumber.equal(value);
      });
    });

    describe('when the sender transfers zero tokens', function () {
      const value = new BN('0');

      it('transfers the requested value', async function () {
        await transfer.call(this, from, to, value);

        expect(await this.token.balanceOfEncrypted(from)).to.be.bignumber.equal(balance);

        expect(await this.token.balanceOfEncrypted(to)).to.be.bignumber.equal('0');
      });
    });
  });

  describe('when the recipient is the zero address', function () {
    it('reverts', async function () {
      await expectRevertCustomError(transfer.call(this, from, ZERO_ADDRESS, balance), 'ERC20InvalidReceiver', [
        ZERO_ADDRESS,
      ]);
    });
  });
}

function shouldBehaveLikeFHERC20Approve(owner, spender, supply, approve) {
  describe('when the spender is not the zero address', function () {
    describe('when the sender has enough balance', function () {
      const value = supply;

      it('emits an approval event', async function () {
        expectEvent(await approve.call(this, owner, spender, value), 'Approval', {
          owner: owner,
          spender: spender,
          value: value,
        });
      });

      describe('when there was no approved value before', function () {
        it('approves the requested value', async function () {
          await approve.call(this, owner, spender, value);

          expect(await this.token.allowanceEncrypted(owner, spender)).to.be.bignumber.equal(value);
        });
      });

      describe('when the spender had an approved value', function () {
        beforeEach(async function () {
          await approve.call(this, owner, spender, new BN(1));
        });

        it('approves the requested value and replaces the previous one', async function () {
          await approve.call(this, owner, spender, value);

          expect(await this.token.allowanceEncrypted(owner, spender)).to.be.bignumber.equal(value);
        });
      });
    });

    describe('when the sender does not have enough balance', function () {
      const value = supply + 1n;

      describe('when there was no approved value before', function () {
        it('approves the requested value', async function () {
          await approve.call(this, owner, spender, value);

          expect(await this.token.allowanceEncrypted(owner, spender)).to.be.bignumber.equal(value);
        });
      });

      describe('when the spender had an approved value', function () {
        beforeEach(async function () {
          await approve.call(this, owner, spender, new BN(1));
        });

        it('approves the requested value and replaces the previous one', async function () {
          await approve.call(this, owner, spender, value);

          expect(await this.token.allowanceEncrypted(owner, spender)).to.be.bignumber.equal(value);
        });
      });
    });
  });

  describe('when the spender is the zero address', function () {
    it('reverts', async function () {
      await expectRevertCustomError(approve.call(this, owner, ZERO_ADDRESS, supply), `ERC20InvalidSpender`, [
        ZERO_ADDRESS,
      ]);
    });
  });
}

module.exports = {
  shouldBehaveLikeFHERC20,
  shouldBehaveLikeFHERC20Transfer,
  shouldBehaveLikeFHERC20Approve,
};
