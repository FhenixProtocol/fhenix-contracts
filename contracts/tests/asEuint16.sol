// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";

contract AsEuint16 {
    function asEuint16Euint8(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint16(TFHE.asEuint8(a)), pubkey);
    }

    function asEuint16Euint32(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint16(TFHE.asEuint32(a)), pubkey);
    }

    function asEuint16Uint256(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint16(uint256(a)), pubkey);
    }

    function asEuint16Bytes(
        bytes calldata ciphertext,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint16(ciphertext), pubkey);
    }
}
