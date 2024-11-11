import { expect } from 'chai'
import { ethers } from 'hardhat'

import { getTokensFromFaucet } from '../permitV2/chain-utils'
import { generatePermitV2, extractPermissionV2 } from '../permitV2/permit-v2-utils'
import { TypedSealedOutputsTest__factory } from '../../types'
import { getAddress } from 'ethers'

const EUINT8_TFHE = 0
const EUINT16_TFHE = 1
const EUINT32_TFHE = 2
const EUINT64_TFHE = 3
const EUINT128_TFHE = 4
const EUINT256_TFHE = 5
const EADDRESS_TFHE = 12
const EBOOL_TFHE = 13

const EUINT_TFHE = {
	8: EUINT8_TFHE,
	16: EUINT16_TFHE,
	32: EUINT32_TFHE,
	64: EUINT64_TFHE,
	128: EUINT128_TFHE,
	256: EUINT256_TFHE,
} as const

describe('TypedSealedOutputs', function () {
	async function typedSealedOutputsFixture() {
		const signer = (await ethers.getSigners())[0]
		await getTokensFromFaucet(signer.address)

		const typedSealedOutputsFactory = (await ethers.getContractFactory('TypedSealedOutputsTest')) as TypedSealedOutputsTest__factory
		const typedSealedOutputs = await typedSealedOutputsFactory.deploy()
		await typedSealedOutputs.waitForDeployment()
		const typedSealedOutputsAddress = await typedSealedOutputs.getAddress()

		// Signer permit and permission
		const permit = await generatePermitV2(
			{
				issuer: signer.address,
				projects: ['TEST'],
			},
			ethers.provider,
			signer
		)
		const permission = extractPermissionV2(permit)

		return {
			signer,
			typedSealedOutputs,
			typedSealedOutputsAddress,
			permit,
			permission,
		}
	}

	it('SealedBool', async () => {
		const { typedSealedOutputs, permit, permission } = await typedSealedOutputsFixture()
		const value = true

		const [fheOutput, bindingsOutput] = await typedSealedOutputs.getSealedEBool(permission, value)

		// NOTE: Unsealing a sealed bool returns a BigInt
		// This function converts a bigint into a boolean
		const bnToBoolean = (bn: BigInt) => Boolean(bn).valueOf()

		expect(fheOutput.utype).to.eq(EBOOL_TFHE, 'sealed bool utype (fhe)')
		expect(bnToBoolean(permit.sealingPair.unseal(fheOutput.data))).to.eq(value, 'unsealed bool match (fhe)')

		expect(bindingsOutput.utype).to.eq(EBOOL_TFHE, 'sealed bool utype (bindings)')
		expect(bnToBoolean(permit.sealingPair.unseal(bindingsOutput.data))).to.eq(value, 'unsealed bool match (bindings)')
	})

	describe('SealedUint', async () => {
		;([8, 16, 32, 64, 128, 256] as const).map((value) =>
			it(`euint${value}`, async () => {
				const { typedSealedOutputs, permit, permission } = await typedSealedOutputsFixture()

				const [fheOutput, bindingsOutput] = await typedSealedOutputs[`getSealedEUint${value}`](permission, value)

				expect(fheOutput.utype).to.eq(EUINT_TFHE[value], `sealed uint${value} utype (fhe)`)
				expect(permit.sealingPair.unseal(fheOutput.data)).to.eq(value, `unsealed uint${value} match (fhe)`)

				expect(bindingsOutput.utype).to.eq(EUINT_TFHE[value], `sealed uint${value} utype (bindings)`)
				expect(permit.sealingPair.unseal(bindingsOutput.data)).to.eq(value, `unsealed uint${value} match (bindings)`)
			})
		)
	})

	it('SealedAddress', async () => {
		const { typedSealedOutputs, permit, permission } = await typedSealedOutputsFixture()

		// Random address
		const value = '0x1BDB34f2cEA785317903eD9618F5282BD5Be5c75'

		const [fheOutput, bindingsOutput] = await typedSealedOutputs.getSealedEAddress(permission, value)

		// NOTE: Unsealing a sealed address returns a bigint
		// This function converts a bigint into a checksummed address (dependency:ethers)
		const bnToAddress = (bn: BigInt) => getAddress(`0x${bn.toString(16).slice(-40)}`)

		expect(fheOutput.utype).to.eq(EADDRESS_TFHE, 'sealed address utype (fhe)')
		expect(bnToAddress(permit.sealingPair.unseal(fheOutput.data))).to.eq(value, 'unsealed address match (fhe)')

		expect(bindingsOutput.utype).to.eq(EADDRESS_TFHE, 'sealed address utype (bindings)')
		expect(bnToAddress(permit.sealingPair.unseal(bindingsOutput.data))).to.eq(value, 'unsealed address match (bindings)')
	})
})
