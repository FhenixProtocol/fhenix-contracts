// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import {Common} from "../FHE.sol";

contract FheValueDecoderTest {
    function decode(bytes memory output) public pure returns (uint256) {
        return Common.getValue(output);
    }
}
