// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../FHE.sol";
import "./utils/Utils.sol";

contract CmuxTest {
    using Utils for *;

    function cmux(string calldata test, bool c, uint256 a, uint256 b) public pure returns (uint256 output) {
        ebool condition = TFHE.asEbool(c);
        if (Utils.cmp(test, "cmux: euint8")) {
            return TFHE.decrypt(TFHE.cmux(condition, TFHE.asEuint8(a), TFHE.asEuint8(b)));
        } else if (Utils.cmp(test, "cmux: euint16")) {
            return TFHE.decrypt(TFHE.cmux(condition, TFHE.asEuint16(a), TFHE.asEuint16(b)));
        } else if (Utils.cmp(test, "cmux: euint32")) {
            return TFHE.decrypt(TFHE.cmux(condition, TFHE.asEuint32(a), TFHE.asEuint32(b)));
        } else if (Utils.cmp(test, "cmux: ebool")) {
            bool aBool = true;
            bool bBool = true;
            
            if (a == 0) {
                aBool = false;
            }
            if (b == 0) {
                bBool = false;
            }
            
            if(TFHE.decrypt(TFHE.cmux(condition, TFHE.asEbool(aBool), TFHE.asEbool(bBool)))) {
                return 1;
            }
            
            return 0;
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }

}