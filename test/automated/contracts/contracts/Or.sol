// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract OrTest {
    using Utils for *;

     function or(string calldata test, uint256 a, uint256 b) public pure returns (uint256 output) {
        if (Utils.cmp(test, "or(euint8,euint8)")) {
            return TFHE.decrypt(TFHE.or(TFHE.asEuint8(a), TFHE.asEuint8(b)));
        } else if (Utils.cmp(test, "or(euint16,euint16)")) {
            return TFHE.decrypt(TFHE.or(TFHE.asEuint16(a), TFHE.asEuint16(b)));
        } else if (Utils.cmp(test, "or(euint32,euint32)")) {
            return TFHE.decrypt(TFHE.or(TFHE.asEuint32(a), TFHE.asEuint32(b)));
        } else if (Utils.cmp(test, "or(ebool,ebool)")) {
            bool aBool = true;
            bool bBool = true;
            if (a == 0) {
                aBool = false;
            }
            if (b == 0) {
                bBool = false;
            }
            if (TFHE.decrypt(TFHE.or(TFHE.asEbool(aBool), TFHE.asEbool(bBool)))) {
                return 1;
            }

            return 0;
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }

}