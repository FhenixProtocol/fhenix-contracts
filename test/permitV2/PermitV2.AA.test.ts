import { expect } from 'chai'
import { ethers, fhenixjs } from 'hardhat'

import { getTokensFromFaucet, unsealMockFheOpsSealed } from './chain-utils'
import { generatePermitV2, extractPermissionV2 } from './permit-v2-utils'
import { LightAccount__factory, PermissionedV2Counter__factory } from '../../types'

// Testing a mock LightAccount (Alchemy's default smart wallet) with PermitV2
// Primary testing is the permission signatures, both issuer and recipient
// Ensuring that EIP1271 signatures for a smart wallet are generated and consumed correctly

describe.only('PermitV2 Account Abstraction', function () {
	async function permitV2AAFixture() {
		const signer = (await ethers.getSigners())[0]
		const bob = (await ethers.getSigners())[1]
		const ada = (await ethers.getSigners())[2]

		await getTokensFromFaucet(signer.address)
		await getTokensFromFaucet(bob.address)
		await getTokensFromFaucet(ada.address)

		// Deploy Counter1
		const counterFactory = (await ethers.getContractFactory('PermissionedV2Counter')) as PermissionedV2Counter__factory
		const counter1 = await counterFactory.deploy()
		await counter1.waitForDeployment()
		const counter1Address = await counter1.getAddress()

		// Deploy Counter2
		const counter2 = await counterFactory.deploy()
		await counter2.waitForDeployment()
		const counter2Address = await counter2.getAddress()

		// Deploy Bob Light Wallet
		const lightAccountFactory = (await ethers.getContractFactory('LightAccount')) as LightAccount__factory
		const bobLightAccount = await lightAccountFactory.deploy(bob.address)
		await bobLightAccount.waitForDeployment()
		const bobLightAccountAddress = await bobLightAccount.getAddress()

		// Deploy Ada Light Wallet
		const adaLightAccount = await lightAccountFactory.deploy(ada.address)
		await adaLightAccount.waitForDeployment()
		const adaLightAccountAddress = await adaLightAccount.getAddress()

		return {
			signer,
			bob,
			ada,
			counter1,
			counter1Address,
			counter2,
			counter2Address,
			bobLightAccount,
			bobLightAccountAddress,
			adaLightAccount,
			adaLightAccountAddress,
		}
	}

	it('Smart wallet access', async () => {
		const { bob, counter1, counter1Address, counter2, counter2Address, bobLightAccount, bobLightAccountAddress } = await permitV2AAFixture()

		console.log({
			bobAddy: bob.address,
		})

		await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
		await counter1.addTo(bobLightAccountAddress, await fhenixjs.encrypt_uint32(3))

		expect(await counter1.getCounter(bob.address)).to.eq(5, "Bob's value should be added")
		expect(await counter1.getCounter(bobLightAccountAddress)).to.eq(3, "Bob's light account value should be added")

		const bobPermit = await generatePermitV2(
			{
				issuer: bob.address,
				contracts: [counter1Address, counter2Address],
			},
			ethers.provider,
			bob
		)
		const bobPermission = extractPermissionV2(bobPermit)
		const bobSealed = await counter1.getCounterPermitSealed(bobPermission)
		const bobUnsealed = unsealMockFheOpsSealed(bobSealed)
		expect(bobUnsealed).to.eq(5, 'Bob unsealed value should match')

		const bobLightAccountPermit = await generatePermitV2(
			{
				isSCA: true,
				issuer: bobLightAccountAddress,
				contracts: [counter1Address, counter2Address],
			},
			ethers.provider,
			bob
		)
		const bobLightAccountPermission = extractPermissionV2(bobLightAccountPermit)

		console.log(bobLightAccountAddress, bobLightAccountPermit, bobLightAccountPermission)

		const c1sealed = await counter1.getCounterPermitSealed(bobLightAccountPermission)
		const c1unsealed = unsealMockFheOpsSealed(c1sealed)
		expect(c1unsealed).to.eq(3, 'BobLightAccount unsealed value should match')
	})
})
