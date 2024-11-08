import { expect } from 'chai'
import { ethers, fhenixjs } from 'hardhat'
import { time } from '@nomicfoundation/hardhat-network-helpers'

import { createExpiration, getLastBlockTimestamp, getTokensFromFaucet } from './chain-utils'
import { hours } from '@nomicfoundation/hardhat-network-helpers/dist/src/helpers/time/duration'
import { generatePermitV2, extractPermissionV2, reSignSharedPermit } from './permit-v2-utils'
import { PermissionedV2Counter__factory, PermissionedV2RevokableValidator__factory, PermissionedV2TimestampValidator__factory } from '../../types'
import { GenerateSealingKey } from 'fhenixjs'

describe('PermissionedV2', function () {
	async function permissionedV2Fixture() {
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

		// Deploy example revokable validator (id)
		const permissionRevokableValidatorFactory = (await ethers.getContractFactory(
			'PermissionedV2RevokableValidator'
		)) as PermissionedV2RevokableValidator__factory
		const permissionRevokableValidator = await permissionRevokableValidatorFactory.deploy()
		await permissionRevokableValidator.waitForDeployment()
		const permissionRevokableValidatorAddress = await permissionRevokableValidator.getAddress()

		// Deploy example revokable validator (timestamp)
		const permissionTimestampValidatorFactory = (await ethers.getContractFactory(
			'PermissionedV2TimestampValidator'
		)) as PermissionedV2TimestampValidator__factory
		const permissionTimestampValidator = await permissionTimestampValidatorFactory.deploy()
		await permissionTimestampValidator.waitForDeployment()
		const permissionTimestampValidatorAddress = await permissionTimestampValidator.getAddress()

		return {
			signer,
			bob,
			ada,
			counter1,
			counter1Address,
			counter2,
			counter2Address,
			permissionRevokableValidator,
			permissionRevokableValidatorAddress,
			permissionTimestampValidator,
			permissionTimestampValidatorAddress,
		}
	}

	// =================================
	//           GOLDEN PATHS
	// =================================
	describe('Golden paths', async () => {
		it('Multi contract access (`permission.contracts`)', async () => {
			const { bob, counter1, counter1Address, counter2, counter2Address } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
			await counter2.connect(bob).add(await fhenixjs.encrypt_uint32(3))

			expect(await counter1.getCounter(bob.address)).to.eq(5, "Bob's counter1 value should be added")
			expect(await counter2.getCounter(bob.address)).to.eq(3, "Bob's counter2 value should be added")

			// Single permission for multiple contracts
			const permit = await generatePermitV2(
				{
					issuer: bob.address,
					contracts: [counter1Address, counter2Address],
				},
				ethers.provider,
				bob
			)
			const permission = extractPermissionV2(permit)

			const c1sealed = await counter1.connect(bob).getCounterPermitSealed(permission)
			const c1unsealed = permit.sealingPair.unseal(c1sealed)
			expect(c1unsealed).to.eq(5, 'Bobs counter1 unsealed value should match')

			const c2sealed = await counter2.connect(bob).getCounterPermitSealed(permission)
			const c2unsealed = permit.sealingPair.unseal(c2sealed)
			expect(c2unsealed).to.eq(3, 'Bobs counter2 unsealed value should match')
		})

		it('Multi contract access (`permission.projects`)', async () => {
			const { bob, counter1, counter2 } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
			await counter2.connect(bob).add(await fhenixjs.encrypt_uint32(3))

			expect(await counter1.getCounter(bob.address)).to.eq(5, "Bob's counter1 value should be added")
			expect(await counter2.getCounter(bob.address)).to.eq(3, "Bob's counter2 value should be added")

			// Single permission for multiple contracts
			const permit = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
				},
				ethers.provider,
				bob
			)
			const permission = extractPermissionV2(permit)

			const c1sealed = await counter1.connect(bob).getCounterPermitSealed(permission)
			const c1unsealed = permit.sealingPair.unseal(c1sealed)
			expect(c1unsealed).to.eq(5, 'Bobs counter1 unsealed value should match')

			const c2sealed = await counter2.connect(bob).getCounterPermitSealed(permission)
			const c2unsealed = permit.sealingPair.unseal(c2sealed)
			expect(c2unsealed).to.eq(3, 'Bobs counter2 unsealed value should match')
		})

		it('Access can revert', async () => {
			const { bob, counter1 } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			const permit = await generatePermitV2(
				{
					issuer: bob.address,
				},
				ethers.provider,
				bob
			)
			const permission = extractPermissionV2(permit)

			await expect(counter1.connect(bob).getCounterPermitSealed(permission)).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_ContractUnauthorized')
		})

		it('Expiration', async () => {
			const { bob, counter1 } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// Expiration date in future
			const futureExpiration = await createExpiration(hours(24))
			const permitWithFutureExpiration = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					expiration: futureExpiration,
				},
				ethers.provider,
				bob
			)
			const permissionWithFutureExpiration = extractPermissionV2(permitWithFutureExpiration)
			await counter1.connect(bob).getCounterPermitSealed(permissionWithFutureExpiration)

			// Expiration date in past
			const pastExpiration = await createExpiration(-1)
			const permitWithPastExpiration = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					expiration: pastExpiration,
				},
				ethers.provider,
				bob
			)
			const permissionWithPastExpiration = extractPermissionV2(permitWithPastExpiration)

			await expect(counter1.connect(bob).getCounterPermitSealed(permissionWithPastExpiration)).to.be.revertedWithCustomError(
				counter1,
				'PermissionInvalid_Expired'
			)
		})

		it('Sharing', async () => {
			const { bob, ada, counter1 } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// Self
			const bobPermitForSelf = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
				},
				ethers.provider,
				bob
			)
			const bobPermissionForSelf = extractPermissionV2(bobPermitForSelf)
			const bobCallSealed = await counter1.connect(bob).getCounterPermitSealed(bobPermissionForSelf)

			// Sharing
			const bobPermitForSharing = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					recipient: ada.address,
				},
				ethers.provider,
				bob
			)
			const adaPermit = await reSignSharedPermit(bobPermitForSharing, ethers.provider, ada)
			const adaPermission = extractPermissionV2(adaPermit)

			// Expect not to revert
			const adaCallSealed = await counter1.connect(ada).getCounterPermitSealed(adaPermission)

			// Shared and Self results match
			const bobCallUnsealed = bobPermitForSelf.sealingPair.unseal(bobCallSealed)
			const adaCallUnsealed = adaPermit.sealingPair.unseal(adaCallSealed)
			expect(bobCallUnsealed).to.eq(adaCallUnsealed, "Bob and Ada can both use bob's permission")
		})
	})

	// =================================
	//          SIG REVERSIONS
	// =================================
	describe('Signature reversions', async () => {
		it('`permission.issuerSignature` (not shared)', async () => {
			const { bob, ada, counter1, counter1Address, counter2, counter2Address } = await permissionedV2Fixture()

			// Valid permission
			const permit = await generatePermitV2(
				{
					issuer: bob.address,
					contracts: [counter1Address],
				},
				ethers.provider,
				bob
			)
			const permission = extractPermissionV2(permit)

			// Valid (sanity check)
			await counter1.getCounterPermitSealed(permission)

			// Invalid (access Ada's data)
			await expect(
				counter1.getCounterPermitSealed({
					...permission,
					issuer: ada.address,
				})
			).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_IssuerSignature')

			// Invalid (access counter2 data)
			await expect(
				counter2.getCounterPermitSealed({
					...permission,
					contracts: [counter2Address],
				})
			).to.be.revertedWithCustomError(counter2, 'PermissionInvalid_IssuerSignature')
		})

		it('`permission.issuerSignature` (shared)', async () => {
			const { signer, bob, ada, counter1, counter1Address } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// Valid permission
			const bobPermit = await generatePermitV2(
				{
					issuer: bob.address,
					contracts: [counter1Address],
					recipient: signer.address,
				},
				ethers.provider,
				bob
			)
			const signerPermit = await reSignSharedPermit(bobPermit, ethers.provider, signer)
			const signerPermission = extractPermissionV2(signerPermit)

			// Valid (sanity check)
			const bobSealed = await counter1.getCounterPermitSealed(signerPermission)
			expect(signerPermit.sealingPair.unseal(bobSealed)).to.eq(5, "Returns Bob's data")

			// Invalid (Ada attempting to use Bob's permission shared with Signer)
			//     Throws `PermissionInvalid_IssuerSignature` because the Permission data changed
			//     by Ada is included in the fields signed by the original issuer.
			bobPermit.recipient = ada.address
			const adaPermit = await reSignSharedPermit({ ...bobPermit, recipient: ada.address }, ethers.provider, ada)
			const adaPermission = extractPermissionV2(adaPermit)
			await expect(counter1.getCounterPermitSealed(adaPermission)).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_IssuerSignature')
		})

		it('`recipientSignature`', async () => {
			const { signer, bob, counter1, counter1Address } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// Valid permission
			const bobPermit = await generatePermitV2(
				{
					issuer: bob.address,
					contracts: [counter1Address],
					recipient: signer.address,
				},
				ethers.provider,
				bob
			)
			const signerPermit = await reSignSharedPermit(bobPermit, ethers.provider, signer)
			const signerPermission = extractPermissionV2(signerPermit)

			// Valid (sanity check)
			const bobSealed = await counter1.getCounterPermitSealed(signerPermission)
			expect(signerPermit.sealingPair.unseal(bobSealed)).to.eq(5, "Returns Bob's data")

			// Invalid (Ada attempting to use Signer's permission with her own sealingKey)
			//     Throws `PermissionInvalid_RecipientSignature` because `sealingKey` is secured
			//     as part of `recipientSignature`
			const adaKeypair = await GenerateSealingKey()
			await expect(
				counter1.getCounterPermitSealed({
					...signerPermission,
					sealingKey: `0x${adaKeypair.publicKey}`,
				})
			).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_RecipientSignature')
		})
	})

	// =================================
	//       EXTERNAL VALIDATORS
	// =================================

	describe('External validators', async () => {
		it('revokable via id', async () => {
			const { bob, ada, counter1, permissionRevokableValidator, permissionRevokableValidatorAddress } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// BOB: Create revokableId
			await permissionRevokableValidator.connect(bob).createRevokableId()
			const revokableId = 1

			// BOB: Create self and sharable permits with validator
			const bobPermitSelf = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					validatorId: revokableId,
					validatorContract: permissionRevokableValidatorAddress,
				},
				ethers.provider,
				bob
			)
			const bobPermission = extractPermissionV2(bobPermitSelf)
			const bobPermitShared = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					validatorId: revokableId,
					validatorContract: permissionRevokableValidatorAddress,
					recipient: ada.address,
				},
				ethers.provider,
				bob
			)

			// ADA: Re-sign shared permit
			const adaPermit = await reSignSharedPermit(bobPermitShared, ethers.provider, ada)
			const adaPermission = extractPermissionV2(adaPermit)

			// Expect not to revert
			await counter1.connect(bob).getCounterPermitSealed(bobPermission)
			await counter1.connect(ada).getCounterPermitSealed(adaPermission)

			// BOB: Revoke id
			const tx = await permissionRevokableValidator.connect(bob).revokeId(revokableId)
			await tx.wait()

			// Expect reversion
			await expect(counter1.connect(bob).getCounterPermitSealed(bobPermission)).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_Disabled')
			await expect(counter1.connect(ada).getCounterPermitSealed(adaPermission)).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_Disabled')
		})

		it('revokable via timestamp', async () => {
			const { bob, ada, counter1, permissionTimestampValidator, permissionTimestampValidatorAddress } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// BOB: Timestamp to use as validator id
			const timestamp = await getLastBlockTimestamp()

			// BOB: Create sharable permit with validator
			const bobPermitSelf = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					validatorId: timestamp,
					validatorContract: permissionTimestampValidatorAddress,
				},
				ethers.provider,
				bob
			)
			const bobPermission = extractPermissionV2(bobPermitSelf)
			const bobPermitShared = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
					validatorId: timestamp,
					validatorContract: permissionTimestampValidatorAddress,
					recipient: ada.address,
				},
				ethers.provider,
				bob
			)

			// ADA: Re-sign shared permit
			const adaPermit = await reSignSharedPermit(bobPermitShared, ethers.provider, ada)
			const adaPermission = extractPermissionV2(adaPermit)

			// Expect not to revert
			await counter1.connect(bob).getCounterPermitSealed(bobPermission)
			await counter1.connect(ada).getCounterPermitSealed(adaPermission)

			// BOB: Update revoke before timestamp to revoke all existing permissions
			const tx = await permissionTimestampValidator.connect(bob).revokeExisting()
			await tx.wait()

			// Just passing the time
			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))

			// Expect reversion
			await expect(counter1.connect(bob).getCounterPermitSealed(bobPermission)).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_Disabled')
			await expect(counter1.connect(ada).getCounterPermitSealed(adaPermission)).to.be.revertedWithCustomError(counter1, 'PermissionInvalid_Disabled')
		})
	})

	// =================================
	//               MISC
	// =================================

	describe('Misc', async () => {
		it('`msg.sender` irrelevant to returned data', async () => {
			const { signer, bob, ada, counter1, counter1Address } = await permissionedV2Fixture()

			await counter1.connect(bob).add(await fhenixjs.encrypt_uint32(5))
			await counter1.connect(ada).add(await fhenixjs.encrypt_uint32(3))

			// Bob permission - accesses bob's data
			const permit = await generatePermitV2(
				{
					issuer: bob.address,
					contracts: [counter1Address],
				},
				ethers.provider,
				bob
			)
			const permission = extractPermissionV2(permit)

			const sealedNoSigner = await counter1.getCounterPermitSealed(permission)
			expect(permit.sealingPair.unseal(sealedNoSigner)).to.eq(5, "No signer - Returns Bob's data")

			const sealedBobSigner = await counter1.connect(bob).getCounterPermitSealed(permission)
			expect(permit.sealingPair.unseal(sealedBobSigner)).to.eq(5, "Bob signer - Returns Bob's data")

			const sealedAdaSigner = await counter1.connect(ada).getCounterPermitSealed(permission)
			expect(permit.sealingPair.unseal(sealedAdaSigner)).to.eq(5, "Ada signer - Returns Bob's data")

			const sealedSignerSigner = await counter1.connect(signer).getCounterPermitSealed(permission)
			expect(permit.sealingPair.unseal(sealedSignerSigner)).to.eq(5, "Signer signer - Returns Bob's data")
		})

		it('checkPermissionSatisfies', async () => {
			const { bob, counter1, counter1Address, counter2 } = await permissionedV2Fixture()

			const permitCounter1Address = await generatePermitV2(
				{
					issuer: bob.address,
					contracts: [counter1Address],
				},
				ethers.provider,
				bob
			)
			const permissionCounter1Address = extractPermissionV2(permitCounter1Address)

			expect(await counter1.checkPermissionSatisfies(permissionCounter1Address)).to.eq(true, 'Permission satisfies counter1 (`permission.contracts`)')
			expect(await counter2.checkPermissionSatisfies(permissionCounter1Address)).to.eq(false, 'Permission does not satisfy counter2 (`permission.contracts`)')

			const permitCounterProject = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['COUNTER'],
				},
				ethers.provider,
				bob
			)
			const permissionCounterProject = extractPermissionV2(permitCounterProject)

			expect(await counter1.checkPermissionSatisfies(permissionCounterProject)).to.eq(true, 'Permission satisfies counter1 (`permission.projects`)')
			expect(await counter2.checkPermissionSatisfies(permissionCounterProject)).to.eq(true, 'Permission satisfies counter2 (`permission.projects`)')

			const permitUniswapProject = await generatePermitV2(
				{
					issuer: bob.address,
					projects: ['UNISWAP'],
				},
				ethers.provider,
				bob
			)
			const permissionUniswapProject = extractPermissionV2(permitUniswapProject)

			expect(await counter1.checkPermissionSatisfies(permissionUniswapProject)).to.eq(false, 'Permission does not satisfy counter1 (`permission.projects`)')
			expect(await counter2.checkPermissionSatisfies(permissionUniswapProject)).to.eq(false, 'Permission does not satisfy counter2 (`permission.projects`)')
		})
	})
})
