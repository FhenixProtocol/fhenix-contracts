import { ethers, ZeroAddress } from 'ethers'
import { concat, hashTypedData, zeroAddress } from 'viem'
import { SealingKey, PermitSigner, EIP712Domain, EIP712Types, SupportedProvider, GenerateSealingKey } from 'fhenixjs'
import { PermissionV2Struct } from '../../types/contracts/access/PermissionedV2.sol/PermissionedV2'

type FhenixJsPermitV2 = {
	issuer: string
	expiration: number
	contracts: string[]
	projects: string[]
	recipient: string
	validatorId: number
	validatorContract: string
	sealingPair: SealingKey
	issuerSignature: string
	recipientSignature: string
}

// Alchemy Account-Kit thing
enum SignatureType {
	EOA = '0x00',
	CONTRACT = '0x01',
	CONTRACT_WITH_ADDR = '0x02',
}

export const sign = async (signer: PermitSigner, domain: EIP712Domain, types: EIP712Types, value: object): Promise<string> => {
	if ('_signTypedData' in signer && typeof signer._signTypedData == 'function') {
		return await signer._signTypedData(domain, types, value)
	} else if ('signTypedData' in signer && typeof signer.signTypedData == 'function') {
		return await signer.signTypedData(domain, types, value)
	}
	throw new Error('Unsupported signer')
}

const determineRequestMethod = (provider: SupportedProvider): Function => {
	if ('request' in provider && typeof provider.request === 'function') {
		return (p: SupportedProvider, method: string, params?: unknown[]) =>
			(p.request as ({ method, params }: { method: string; params?: unknown[] }) => Promise<unknown>)({ method, params })
	} else if ('send' in provider && typeof provider.send === 'function') {
		return (p: SupportedProvider, method: string, params?: unknown[]) => (p.send as (method: string, params?: unknown[]) => Promise<unknown>)(method, params)
	} else {
		throw new Error("Received unsupported provider. 'send' or 'request' method not found")
	}
}

const determineRequestSigner = (provider: SupportedProvider): Function => {
	if ('getSigner' in provider && typeof provider.getSigner === 'function') {
		return (p: SupportedProvider) => (p.getSigner as () => unknown)()
	} else {
		throw new Error('The supplied provider cannot get a signer')
	}
}

export const generatePermitV2 = async (
	options: {
		isSCA?: boolean
		issuer: string
		contracts?: string[]
		projects?: string[]
		expiration?: number
		recipient?: string
		validatorId?: number
		validatorContract?: string
	},
	provider: SupportedProvider,
	customSigner?: PermitSigner
): Promise<FhenixJsPermitV2> => {
	const {
		isSCA = false,
		issuer,
		contracts = [],
		projects = [],
		expiration = 1000000000000,
		recipient = ZeroAddress,
		validatorId = 0,
		validatorContract = ZeroAddress,
	} = options

	const isSharing = recipient !== ZeroAddress

	if (!provider) {
		throw new Error('Provider is undefined')
	}

	const requestMethod = determineRequestMethod(provider)

	let signer: PermitSigner
	if (!customSigner) {
		const getSigner = determineRequestSigner(provider)
		signer = await getSigner(provider)
	} else {
		signer = customSigner
	}

	const chainId = await requestMethod(provider, 'eth_chainId', [])

	const keypair = await GenerateSealingKey()

	const domain = {
		name: 'Fhenix Permission v2.0.0',
		version: 'v2.0.0',
		chainId,
		verifyingContract: zeroAddress,
	}

	let types: EIP712Types = {
		PermissionedV2IssuerSelf: [
			{ name: 'issuer', type: 'address' },
			{ name: 'expiration', type: 'uint64' },
			{ name: 'contracts', type: 'address[]' },
			{ name: 'projects', type: 'string[]' },
			{ name: 'recipient', type: 'address' },
			{ name: 'validatorId', type: 'uint256' },
			{ name: 'validatorContract', type: 'address' },
			{ name: 'sealingKey', type: 'bytes32' },
		],
	}
	let message: object = {
		issuer,
		sealingKey: `0x${keypair.publicKey}`,
		expiration: expiration.toString(),
		contracts,
		projects,
		recipient,
		validatorId,
		validatorContract,
	}

	if (isSharing) {
		types = {
			PermissionedV2IssuerShared: [
				{ name: 'issuer', type: 'address' },
				{ name: 'expiration', type: 'uint64' },
				{ name: 'contracts', type: 'address[]' },
				{ name: 'projects', type: 'string[]' },
				{ name: 'recipient', type: 'address' },
				{ name: 'validatorId', type: 'uint256' },
				{ name: 'validatorContract', type: 'address' },
			],
		}
		message = {
			issuer,
			expiration: expiration.toString(),
			contracts,
			projects,
			recipient,
			validatorId,
			validatorContract,
		}
	}

	const messageHash = hashTypedData({
		domain,
		types,
		message: message as Record<string, unknown>,
		primaryType: Object.keys(types)[0],
	})

	const ethersMsgHash = ethers.TypedDataEncoder.hash(domain, types, message)

	console.log({ messageHash, ethersMsgHash })

	let msgSig = ''
	if (isSCA) {
		msgSig = await sign(
			signer,
			// EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)
			// https://github.com/alchemyplatform/light-account/blob/main/src/LightAccount.sol#L236
			{
				name: 'LightAccount',
				version: '2',
				chainId,
				verifyingContract: issuer,
			},
			{
				LightAccountMessage: [{ name: 'message', type: 'bytes' }],
			},
			{
				message: ethersMsgHash,
			}
		)

		msgSig = concat([SignatureType.EOA, msgSig as `0x${string}`]) as string

		console.log({ primaryType: Object.keys(types)[0], ethersMsgHash, msgSig })
	} else {
		msgSig = await sign(signer, domain, types, message)
	}

	const permit: FhenixJsPermitV2 = {
		issuer,
		expiration,
		sealingPair: keypair,
		contracts,
		projects,
		recipient: recipient,
		validatorId,
		validatorContract,
		issuerSignature: msgSig,
		recipientSignature: '0x',
	}

	return permit
}

export const reSignSharedPermit = async (
	sharedPermit: FhenixJsPermitV2,
	provider: SupportedProvider,
	customSigner?: PermitSigner
): Promise<FhenixJsPermitV2> => {
	if (!provider) {
		throw new Error('Provider is undefined')
	}

	const requestMethod = determineRequestMethod(provider)

	let signer: PermitSigner
	if (!customSigner) {
		const getSigner = determineRequestSigner(provider)
		signer = await getSigner(provider)
	} else {
		signer = customSigner
	}

	const chainId = await requestMethod(provider, 'eth_chainId', [])

	const keypair = await GenerateSealingKey()

	const recipientSignature = await sign(
		signer,
		// Domain
		{
			name: 'Fhenix Permission v2.0.0',
			version: 'v2.0.0',
			chainId,
			verifyingContract: ZeroAddress,
		},
		// Types
		{
			PermissionedV2Recipient: [
				{ name: 'sealingKey', type: 'bytes32' },
				{ name: 'issuerSignature', type: 'bytes' },
			],
		},
		// Message
		{
			sealingKey: `0x${keypair.publicKey}`,
			issuerSignature: sharedPermit.issuerSignature,
		}
	)

	const permit: FhenixJsPermitV2 = {
		...sharedPermit,
		sealingPair: keypair,
		recipientSignature,
	}

	return permit
}

export const extractPermissionV2 = ({ sealingPair, ...permission }: FhenixJsPermitV2): PermissionV2Struct => {
	return {
		...permission,
		sealingKey: `0x${sealingPair.publicKey}`,
	}
}
