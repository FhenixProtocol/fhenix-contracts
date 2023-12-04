// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";

contract AsEbool {
    function asEboolEuint8(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEbool(TFHE.asEuint8(a)), pubkey);
    }

    function asEboolEuint16(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEbool(TFHE.asEuint16(a)), pubkey);
    }

    function asEboolEuint32(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEbool(TFHE.asEuint32(a)), pubkey);
    }

    function asEboolBool(uint8 a, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        bool asBool = true;
        if (a == 0) {
            asBool = false;
        }
        return TFHE.reencrypt(TFHE.asEbool(asBool), pubkey);
    }

    function asEboolBytes(bytes calldata ciphertext, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        return TFHE.reencrypt(TFHE.asEbool(ciphertext), pubkey);
    }
}
