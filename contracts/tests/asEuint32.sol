// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";

contract AsEuint32 {
    function asEuint32Euint8(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint32(TFHE.asEuint8(a)), pubkey);
    }

    function asEuint32Euint16(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint32(TFHE.asEuint16(a)), pubkey);
    }

    function asEuint32Uint256(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint32(uint256(a)), pubkey);
    }

    function asEuint32Bytes(
        bytes calldata ciphertext,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint32(ciphertext), pubkey);
    }
}
