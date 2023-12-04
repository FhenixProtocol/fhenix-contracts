// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Le {
    using Utils for *;

    function le(
        uint32 a,
        uint32 b,
        string calldata test,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "le(euint8,euint8)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint8,euint16)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint8(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint8,euint32)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint8(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint8,uint8)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint8(a), uint8(b)), pubkey);
        } else if (Utils.cmp(test, "le(uint8,euint8)")) {
            return TFHE.reencrypt(TFHE.le(uint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint16,euint8)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint16(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint16,euint16)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint16(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint16,euint32)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint16(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint16,uint16)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint16(a), uint16(b)), pubkey);
        } else if (Utils.cmp(test, "le(uint16,euint16)")) {
            return TFHE.reencrypt(TFHE.le(uint16(b), TFHE.asEuint16(a)), pubkey);
        } else if (Utils.cmp(test, "le(euint32,euint8)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint32(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint32,euint16)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint32(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint32,euint32)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint32(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "le(euint32,uint32)")) {
            return TFHE.reencrypt(TFHE.le(TFHE.asEuint32(a), uint32(b)), pubkey);
        } else if (Utils.cmp(test, "le(uint32,euint32)")) {
            return TFHE.reencrypt(TFHE.le(uint32(b), TFHE.asEuint32(a)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }
}
