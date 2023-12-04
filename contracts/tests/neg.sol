// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Neg {
    using Utils for *;

    function neg(uint32 a, string calldata test, bytes32 pubkey) external view returns (bytes memory reencrypted) {
        euint32 expectedResult = TFHE.asEuint32((~a) + 1);
        euint32 result;

        if (Utils.cmp(test, "neg(euint8)")) {
            return TFHE.reencrypt(TFHE.neg(TFHE.asEuint8(a)), pubkey);
        } else if (Utils.cmp(test, "neg(euint16)")) {
            return TFHE.reencrypt(TFHE.neg(TFHE.asEuint16(a)), pubkey);
        } else if (Utils.cmp(test, "neg(euint32)")) {
            return TFHE.reencrypt(TFHE.neg(TFHE.asEuint32(a)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }

        return Utils.checkResult(expectedResult, result, pubkey);
    }
}
