// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract Cmux {
    using Utils for *;

    function cmux(
        bool control,
        uint32 a,
        uint32 b,
        string calldata test,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "cmux(ebool,euint8,euint8)")) {
            return TFHE.reencrypt(TFHE.cmux(TFHE.asEbool(control), TFHE.asEuint8(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "cmux(ebool,euint16,euint16)")) {
            return TFHE.reencrypt(TFHE.cmux(TFHE.asEbool(control), TFHE.asEuint16(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "cmux(ebool,euint32,euint32)")) {
            return TFHE.reencrypt(TFHE.cmux(TFHE.asEbool(control), TFHE.asEuint32(a), TFHE.asEuint32(b)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }
}
