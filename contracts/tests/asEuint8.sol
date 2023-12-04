// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";

contract AsEuint8 {
    function asEuint8Uint8(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint8(a), pubkey);
    }

    function asEuint8Uint256(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint8(uint256(a)), pubkey);
    }

    function asEuint8Euint16(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint8(TFHE.asEuint16(uint256(a))), pubkey);
    }

    function asEuint8Euint32(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEuint8(TFHE.asEuint32(uint256(a))), pubkey);
    }
}
