import hre from 'hardhat'

export async function getTokensFromFaucet(address: string) {
	if (hre.network.name === 'localfhenix') {
		if ((await hre.ethers.provider.getBalance(address)).toString() === '0') {
			await hre.fhenixjs.getFunds(address)
		}
	}
}

export const getLastBlockTimestamp = async () => {
	return (await hre.ethers.provider.getBlock('latest'))!.timestamp
}

export const createExpiration = async (duration: number) => {
	const timestamp = await getLastBlockTimestamp()
	return timestamp + duration
}

// = Fhenix =
export const unsealMockFheOpsSealed = (sealed: string): bigint => {
	const byteArray = new Uint8Array(sealed.split('').map((c) => c.charCodeAt(0)))

	// Step 2: Convert the Uint8Array to BigInt
	let result = BigInt(0)
	for (let i = 0; i < byteArray.length; i++) {
		result = (result << BigInt(8)) + BigInt(byteArray[i]) // Shift and add each byte
	}

	return result
}
