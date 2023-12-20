// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract MulTest {
    using Utils for *;

     function mul(string calldata test, uint256 a, uint256 b) public pure returns (uint256 output) {
        if (Utils.cmp(test, "mul(euint8,euint8)")) {
            return TFHE.decrypt(TFHE.mul(TFHE.asEuint8(a), TFHE.asEuint8(b)));
        } else if (Utils.cmp(test, "mul(euint16,euint16)")) {
            return TFHE.decrypt(TFHE.mul(TFHE.asEuint16(a), TFHE.asEuint16(b)));
        } else if (Utils.cmp(test, "mul(euint32,euint32)")) {
            return TFHE.decrypt(TFHE.mul(TFHE.asEuint32(a), TFHE.asEuint32(b)));
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }

}