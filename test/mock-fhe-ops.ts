import { ethers } from 'hardhat'

import { MockFheOps__factory } from '../types'
import { getTokensFromFaucet } from './permitV2/chain-utils'

describe('MockFheOps', function () {
	async function mockFheOpsFixture() {
		const signer = (await ethers.getSigners())[0]

		await getTokensFromFaucet(signer.address)

		const mockFheOpsFactory = (await ethers.getContractFactory('MockFheOps')) as MockFheOps__factory
		const ops = await mockFheOpsFactory.deploy()
		await ops.waitForDeployment()
		const opsAddress = await ops.getAddress()

		return {
			signer,
			ops,
		}
	}

	it('deploy', async () => {
		const { ops } = await mockFheOpsFixture()

		console.log({ ops })
	})
})
