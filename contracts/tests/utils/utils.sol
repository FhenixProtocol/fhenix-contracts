// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";

library Utils {
    function checkResult(euint32 expectedResult, euint32 result, bytes32 pubkey) internal view returns (bytes memory) {
        return TFHE.reencrypt(TFHE.eq(expectedResult, result), pubkey);
    }

    function checkResult(euint8 expectedResult, euint8 result, bytes32 pubkey) internal view returns (bytes memory) {
        return checkResult(TFHE.asEuint32(expectedResult), TFHE.asEuint32(result), pubkey);
    }

    function cmp(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
