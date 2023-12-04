// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract OptReq {
    using Utils for *;

    function optReq(bytes memory encOption) external view {
        TFHE.optReq(TFHE.asEuint8(encOption));
    }
}
