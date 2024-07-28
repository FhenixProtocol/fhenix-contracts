const { shouldBehaveLikeERC721, shouldBehaveLikeERC721Metadata } = require('./ERC721.behavior');
const { shouldBehaveLikeFHERC721 } = require('./FHERC721.behavior');

const ERC721 = artifacts.require('$FHERC721');

contract('FHERC721 as ERC721', function (accounts) {
  const name = 'Non Fungible Token';
  const symbol = 'NFT';

  before(async function () {
    this.signers = (await ethers.getSigners()).slice(0, 6);
    this.getPermission = async address => {
      const signer = this.signers.find(s => s.address === address);
      const permit = await fhenixjs.generatePermit(this.token.address, undefined, signer)
      return fhenixjs.extractPermitPermission(permit);
    }

    // fund first account: owner
    if ((await ethers.provider.getBalance(this.signers[0].address)).toString() === "0") {
      await fhenixjs.getFunds(this.signers[0].address);
    }

    // fund sixth account: other
    if ((await ethers.provider.getBalance(this.signers[5].address)).toString() === "0") {
      await fhenixjs.getFunds(this.signers[5].address);
    }
  });

  beforeEach(async function () {
    this.token = await ERC721.new(name, symbol);
  });

  shouldBehaveLikeERC721(...accounts);
  shouldBehaveLikeFHERC721(...accounts);
  shouldBehaveLikeERC721Metadata(name, symbol, ...accounts);
});
