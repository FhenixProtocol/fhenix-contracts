// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Min {
    using Utils for *;

    function min(
        uint32 a,
        uint32 b,
        string calldata test,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "min(euint8,euint8)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint8,euint16)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint8(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint8,euint32)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint8(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint8,uint8)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint8(a), uint8(b)), pubkey);
        } else if (Utils.cmp(test, "min(uint8,euint8)")) {
            return TFHE.reencrypt(TFHE.min(uint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint16,euint8)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint16(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint16,euint16)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint16(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint16,euint32)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint16(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint16,uint16)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint16(a), uint16(b)), pubkey);
        } else if (Utils.cmp(test, "min(uint16,euint16)")) {
            return TFHE.reencrypt(TFHE.min(uint16(b), TFHE.asEuint16(a)), pubkey);
        } else if (Utils.cmp(test, "min(euint32,euint8)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint32(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint32,euint16)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint32(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint32,euint32)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint32(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "min(euint32,uint32)")) {
            return TFHE.reencrypt(TFHE.min(TFHE.asEuint32(a), uint32(b)), pubkey);
        } else if (Utils.cmp(test, "min(uint32,euint32)")) {
            return TFHE.reencrypt(TFHE.min(uint32(b), TFHE.asEuint32(a)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }
}
