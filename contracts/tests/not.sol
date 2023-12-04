// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Not {
    using Utils for *;

    function not(uint32 a, string calldata test, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "not(euint8)")) {
            return TFHE.reencrypt(TFHE.asEuint32(TFHE.not(TFHE.asEuint8(a))), pubkey);
        } else if (Utils.cmp(test, "not(euint16)")) {
            return TFHE.reencrypt(TFHE.asEuint32(TFHE.not(TFHE.asEuint16(a))), pubkey);
        } else if (Utils.cmp(test, "not(euint32)")) {
            return TFHE.reencrypt(TFHE.not(TFHE.asEuint32(a)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }
}
