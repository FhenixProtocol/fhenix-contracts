// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Reencrypt {
    using Utils for *;

    function reencrypt(
        uint8 value,
        string calldata test,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        bytes memory result;
        if (Utils.cmp(test, "reencrypt(euint8)")) {
            result = TFHE.reencrypt(TFHE.asEuint8(uint256(value)), pubkey);
        } else if (Utils.cmp(test, "reencrypt(euint16)")) {
            result = TFHE.reencrypt(TFHE.asEuint16(uint256(value)), pubkey);
        } else if (Utils.cmp(test, "reencrypt(euint32)")) {
            result = TFHE.reencrypt(TFHE.asEuint32(uint256(value)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }

        return result;
    }
}
