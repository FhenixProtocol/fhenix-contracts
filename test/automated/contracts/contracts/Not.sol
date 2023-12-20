// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract NotTest {
    using Utils for *;

    function not(string calldata test, uint256 a) public pure returns (uint256 output) {
        if (Utils.cmp(test, "not(euint8)")) {
            return TFHE.decrypt(TFHE.not(TFHE.asEuint8(a)));
        } else if (Utils.cmp(test, "not(euint16)")) {
            return TFHE.decrypt(TFHE.not(TFHE.asEuint16(a)));
        } else if (Utils.cmp(test, "not(euint32)")) {
            return TFHE.decrypt(TFHE.not(TFHE.asEuint32(a)));
        } else if (Utils.cmp(test, "not(ebool)")) {
            bool aBool = true;
            if (a == 0) {
                aBool = false;
            }
            
            if (TFHE.decrypt(TFHE.not(TFHE.asEbool(aBool)))) {
                return 1;
            }
            
            return 0;
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }

}