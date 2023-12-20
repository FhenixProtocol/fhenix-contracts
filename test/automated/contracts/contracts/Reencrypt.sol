// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract ReencryptTest {
    using Utils for *;

    function reencrypt(string calldata test, uint256 a, bytes32 pubkey) public pure returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "reencrypt(euint8)")) {
            return TFHE.reencrypt(TFHE.asEuint8(a), pubkey);
        } else if (Utils.cmp(test, "reencrypt(euint16)")) {
            return TFHE.reencrypt(TFHE.asEuint16(a), pubkey);
        } else if (Utils.cmp(test, "reencrypt(euint32)")) {
            return TFHE.reencrypt(TFHE.asEuint32(a), pubkey);
        } else if (Utils.cmp(test, "reencrypt(ebool)")) {
            bool b = true;
            if (a == 0) {
                b = false;
            }
            
            return TFHE.reencrypt(TFHE.asEbool(b), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }

}