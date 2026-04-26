import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('FHE precompile output decoding', function () {
	it('decodes a 32-byte output word', async () => {
		const decoder = await ethers.deployContract('FheValueDecoderTest')

		expect(await decoder.decode(ethers.toBeHex(42, 32))).to.eq(42)
	})

	it('reverts when the output is shorter than one word', async () => {
		const decoder = await ethers.deployContract('FheValueDecoderTest')

		await expect(decoder.decode('0x1234')).to.be.revertedWithCustomError(decoder, 'InvalidPrecompileOutput')
	})
})
