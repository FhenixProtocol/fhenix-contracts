// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Shr {
    using Utils for *;

    function shr(
        uint32 a,
        uint32 b,
        string calldata test,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "shr(euint8,euint8)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint8,euint16)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint8(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint8,euint32)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint8(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint8,uint8)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint8(a), uint8(b)), pubkey);
        } else if (Utils.cmp(test, "shr(uint8,euint8)")) {
            return TFHE.reencrypt(TFHE.shr(uint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint16,euint8)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint16(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint16,euint16)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint16(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint16,euint32)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint16(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint16,uint16)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint16(a), uint16(b)), pubkey);
        } else if (Utils.cmp(test, "shr(uint16,euint16)")) {
            return TFHE.reencrypt(TFHE.shr(uint16(b), TFHE.asEuint16(a)), pubkey);
        } else if (Utils.cmp(test, "shr(euint32,euint8)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint32(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint32,euint16)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint32(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint32,euint32)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint32(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "shr(euint32,uint32)")) {
            return TFHE.reencrypt(TFHE.shr(TFHE.asEuint32(a), uint32(b)), pubkey);
        } else if (Utils.cmp(test, "shr(uint32,euint32)")) {
            return TFHE.reencrypt(TFHE.shr(uint32(b), TFHE.asEuint32(a)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }
}
