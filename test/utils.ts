import { getBytes, hexlify, solidityPacked, solidityPackedKeccak256 } from 'ethers'

export function ctrSymmetricEncrypt(data: string, key: string): string {
	const dataBytes = getBytes(data) // Ensure data is in byte format

	const length = dataBytes.length
	const resultBytes: Uint8Array = new Uint8Array(length)

	for (let i = 0; i < length; i += 32) {
		const hash = solidityPackedKeccak256(['bytes', 'uint256'], [key, i])
		const hashBytes = getBytes(hash)

		// XOR data chunk with the hash chunk
		for (let j = 0; j < 32 && i + j < length; j++) {
			resultBytes[i + j] = dataBytes[i + j] ^ hashBytes[j]
		}
	}

	return hexlify(resultBytes) // Convert the result back to a hex string
}

export function ctrKey() {
	return solidityPacked(['string'], ['deadbeef'])
}
