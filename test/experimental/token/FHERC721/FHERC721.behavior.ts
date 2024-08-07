const { BN } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

const { shouldSupportInterfaces } = require('../../../helpers/SupportsInterface.behavior');
const { expectRevertCustomError } = require('../../../helpers/customError');

const firstTokenId = new BN('5042');
const secondTokenId = new BN('79217');
const nonExistentTokenId = new BN('13');

function shouldBehaveLikeFHERC721(owner, newOwner, approved, anotherApproved, operator, other) {
  shouldSupportInterfaces(['ERC165', 'ERC721']);

  context('with minted tokens', function () {
    beforeEach(async function () {
      const privateData1 = await fhenixjs.encrypt_uint128(111n);
      const privateData2 = await fhenixjs.encrypt_uint128(222n);
      await this.token.$_mint(owner, firstTokenId, privateData1);
      await this.token.$_mint(newOwner, secondTokenId, privateData2);
      this.toWhom = other; // default to other for toWhom in context-dependent tests
    });

    describe('tokenPrivateData', function () {
      context('when the given address owns the token', function () {
        it('returns the private data of tokens owned by the given address', async function () {
          const encPrivData = await this.token.tokenPrivateData(firstTokenId, await this.getPermission(owner))
          const privateData = fhenixjs.unseal(this.token.address, encPrivData);
          expect(privateData).to.equal(111n);
        });
      });

      context('when the given address does not own the token', function () {
        it('reverts', async function () {
          await expectRevertCustomError(
            this.token.tokenPrivateData(secondTokenId, await this.getPermission(owner)),
            'SignerNotOwner',
            []
          );
        });
      });

      context('when the token does not exist', function () {
        it('reverts', async function () {
          await expectRevertCustomError(
            this.token.tokenPrivateData(nonExistentTokenId, await this.getPermission(owner)),
            'SignerNotOwner',
            []
          );
        });
      });
    });
  });
};

module.exports = {
  shouldBehaveLikeFHERC721,
};
