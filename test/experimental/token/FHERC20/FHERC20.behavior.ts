import {defineGetterMemoized} from "solidity-docgen/dist/utils/memoized-getter";

const { constants, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { ZERO_ADDRESS, MAX_UINT256 } = constants;

const { expectRevertCustomError } = require('../../../helpers/customError');

function shouldBehaveLikeFHERC20(initialSupply, accounts, opts = {}) {
  const [initialHolder, recipient, anotherAccount] = accounts;
  const { forcedApproval } = opts;

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
      const encryptedValue = await fhenixjs.encrypt_uint128(value);
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
            const initialSupplyEnc = await fhenixjs.encrypt_uint128(initialSupply);
            await this.token.approveEncrypted(spender, initialSupplyEnc, { from: initialHolder });
          });

          describe('when the token owner has enough balance', function () {
            const value = initialSupply;

            it('transfers the requested value', async function () {
              const valueEnc = await fhenixjs.encrypt_uint128(value);
              await this.token.transferFromEncrypted(tokenOwner, to, valueEnc, { from: spender });

              const balanceEnc = await this.token.balanceOfEncrypted(tokenOwner, await this.getPermission(tokenOwner))
              const balance = fhenixjs.unseal(this.token.address, balanceEnc);
              expect(balance).to.equal(0n);

              const balanceEncTo = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
              const balanceTo = fhenixjs.unseal(this.token.address, balanceEncTo);
              expect(balanceTo).to.equal(value);
            });

            it('decreases the spender allowance', async function () {
              const valueEnc = await fhenixjs.encrypt_uint128(value);
              await this.token.transferFromEncrypted(tokenOwner, to, valueEnc, { from: spender });

              const balanceEnc = await this.token.balanceOfEncrypted(tokenOwner, await this.getPermission(tokenOwner))
              const balance = fhenixjs.unseal(this.token.address, balanceEnc);
              expect(balance).to.equal(0n);
            });
          });

          describe('when the token owner does not have enough balance', function () {
            const value = initialSupply;

            beforeEach('reducing balance', async function () {
              const valueEnc = await fhenixjs.encrypt_uint128(1n);
              await this.token.transferEncrypted(to, valueEnc, { from: tokenOwner });
            });

            it("doesn't transfer the requested value", async function () {
              const valueEnc = await fhenixjs.encrypt_uint128(value);
              this.token.transferFromEncrypted(tokenOwner, to, valueEnc, { from: spender });

              const balanceEnc = await this.token.balanceOfEncrypted(tokenOwner, await this.getPermission(tokenOwner))
              const balance = fhenixjs.unseal(this.token.address, balanceEnc);
              expect(balance).to.equal(value - 1n);

              const balanceEncTo = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
              const balanceTo = fhenixjs.unseal(this.token.address, balanceEncTo);
              expect(balanceTo).to.equal(1n);
            });
          });
        });

        describe('when the spender does not have enough allowance', function () {
          const allowance = initialSupply - 1n;

          beforeEach(async function () {
            const allowanceEnc = await fhenixjs.encrypt_uint128(allowance);
            await this.token.approveEncrypted(spender, allowanceEnc, { from: tokenOwner });
          });

          describe('when the token owner has enough balance', function () {
            const value = initialSupply;

            it("doesn't transfer the requested value", async function () {
              const valueEnc = await fhenixjs.encrypt_uint128(value);
              this.token.transferFromEncrypted(tokenOwner, to, valueEnc, { from: spender });

              const balanceEnc = await this.token.balanceOfEncrypted(tokenOwner, await this.getPermission(tokenOwner))
              const balance = fhenixjs.unseal(this.token.address, balanceEnc);
              expect(balance).to.equal(value);

              const balanceEncTo = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
              const balanceTo = fhenixjs.unseal(this.token.address, balanceEncTo);
              expect(balanceTo).to.equal(0n);
            });
          });

          describe('when the token owner does not have enough balance', function () {
            const value = allowance;

            beforeEach('reducing balance', async function () {
              const reductionEnc = await fhenixjs.encrypt_uint128(2n);
              await this.token.transferEncrypted(to, reductionEnc, { from: tokenOwner });
            });

            it("doesn't transfer the requested value", async function () {
              const valueEnc = await fhenixjs.encrypt_uint128(value);
              this.token.transferFromEncrypted(tokenOwner, to, valueEnc, { from: spender });

              const balanceEnc = await this.token.balanceOfEncrypted(tokenOwner, await this.getPermission(tokenOwner))
              const balance = fhenixjs.unseal(this.token.address, balanceEnc);
              expect(balance).to.equal(value - 1n);

              const balanceEncTo = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
              const balanceTo = fhenixjs.unseal(this.token.address, balanceEncTo);
              expect(balanceTo).to.equal(2n); // because we sent 2 tokens here when lowering balance
            });
          });
        });

        // FHERC20 does not have this functionality
        describe.skip('when the spender has unlimited allowance', function () {
          beforeEach(async function () {
            // todo if unskipped - encrypt amount
            await this.token.approve(spender, MAX_UINT256, { from: initialHolder });
          });

          it('does not decrease the spender allowance', async function () {
            const encryptedValue = await fhenixjs.encrypt_uint128(1n);
            await this.token.transferFromEncrypted(tokenOwner, to, encryptedValue, { from: spender });

            expect(await this.token.allowanceEncrypted(tokenOwner, spender)).to.equal(MAX_UINT256);
          });
        });
      });

      // FHERC20 does not have this functionality
      describe.skip('when the recipient is the zero address', function () {
        const value = initialSupply;
        const to = ZERO_ADDRESS;

        beforeEach(async function () {
          const encryptedValue = await fhenixjs.encrypt_uint128(value);
          await this.token.approveEncrypted(spender, encryptedValue, { from: tokenOwner });
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

    // FHERC20 does not have this functionality
    describe.skip('when the token owner is the zero address', function () {
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
    shouldBehaveLikeFHERC20Approve(initialHolder, recipient, initialSupply, async function (owner, spender, value) {
      const encryptedValue = await fhenixjs.encrypt_uint128(value);
      return this.token.approveEncrypted(spender, encryptedValue, { from: owner });
    });
  });
}

function shouldBehaveLikeFHERC20Transfer(from, to, balance, transfer) {
  describe('when the recipient is not the zero address', function () {
    describe('when the sender does not have enough balance', function () {
      const value = balance + 1n;

      it("doesn't transfer value", async function () {
        await transfer.call(this, from, to, value);

        const balanceToEnc = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
        const balanceToAfter = fhenixjs.unseal(this.token.address, balanceToEnc);
        expect(balanceToAfter).to.equal(0n);

        const balanceEnc = await this.token.balanceOfEncrypted(from, await this.getPermission(from))
        const balanceAfter = fhenixjs.unseal(this.token.address, balanceEnc);
        expect(balanceAfter).to.equal(balance);
      });
    });

    describe('when the sender transfers all balance', function () {
      const value = balance;

      it('transfers the requested value', async function () {
        await transfer.call(this, from, to, value);

        const balanceToEnc = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
        const balanceToAfter = fhenixjs.unseal(this.token.address, balanceToEnc);
        expect(balanceToAfter).to.equal(value);

        const balanceEnc = await this.token.balanceOfEncrypted(from, await this.getPermission(from))
        const balanceAfter = fhenixjs.unseal(this.token.address, balanceEnc);
        expect(balanceAfter).to.equal(0n);
      });
    });

    describe('when the sender transfers zero tokens', function () {
      const value = 0n;

      it('transfers the requested value', async function () {
        await transfer.call(this, from, to, value);

        const balanceToEnc = await this.token.balanceOfEncrypted(to, await this.getPermission(to))
        const balanceToAfter = fhenixjs.unseal(this.token.address, balanceToEnc);
        expect(balanceToAfter).to.equal(0n);

        const balanceEnc = await this.token.balanceOfEncrypted(from, await this.getPermission(from))
        const balanceAfter = fhenixjs.unseal(this.token.address, balanceEnc);
        expect(balanceAfter).to.equal(balance);
      });
    });
  });

  // currently not dealing with zero-addresses
  describe.skip('when the recipient is the zero address', function () {
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

      describe('when there was no approved value before', function () {
        it('approves the requested value', async function () {
          await approve.call(this, owner, spender, value);

          const balanceEnc = await this.token.allowanceEncrypted(owner, spender, await this.getPermission(spender))
          const balance = fhenixjs.unseal(this.token.address, balanceEnc);
          expect(balance).to.equal(value);
        });
      });

      describe('when the spender had an approved value', function () {
        beforeEach(async function () {
          await approve.call(this, owner, spender, 1n);
        });

        it('approves the requested value and replaces the previous one', async function () {
          await approve.call(this, owner, spender, value);

          const balanceEnc = await this.token.allowanceEncrypted(owner, spender, await this.getPermission(spender))
          const balance = fhenixjs.unseal(this.token.address, balanceEnc);
          expect(balance).to.equal(value);
        });
      });
    });

    describe('when the sender does not have enough balance', function () {
      const value = supply + 1n;

      describe('when there was no approved value before', function () {
        it('approves the requested value', async function () {
          await approve.call(this, owner, spender, value);

          const balanceEnc = await this.token.allowanceEncrypted(owner, spender, await this.getPermission(spender))
          const balance = fhenixjs.unseal(this.token.address, balanceEnc);
          expect(balance).to.equal(value);
        });
      });

      describe('when the spender had an approved value', function () {
        beforeEach(async function () {
          await approve.call(this, owner, spender, 1n);
        });

        it('approves the requested value and replaces the previous one', async function () {
          await approve.call(this, owner, spender, value);

          const balanceEnc = await this.token.allowanceEncrypted(owner, spender, await this.getPermission(spender))
          const balance = fhenixjs.unseal(this.token.address, balanceEnc);
          expect(balance).to.equal(value);
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
