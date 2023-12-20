// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../../FHE.sol";

library Utils {
    function cmp(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
