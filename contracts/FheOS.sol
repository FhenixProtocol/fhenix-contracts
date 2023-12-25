// SPDX-License-Identifier: BSD-3-Clause-Clear
// solhint-disable one-contract-per-file
pragma solidity >=0.8.13 <0.9.0;

library Precompiles {
    //solhint-disable const-name-snakecase
    address public constant Fheos = address(128);
    uint256 public constant FhePubKey = 68;
}

interface FheOps {
    function add(bytes memory input) external pure returns (bytes memory);
    function verify(bytes memory input) external pure returns (bytes memory);
    function reencrypt(bytes memory input) external pure returns (bytes memory);
    function decrypt(bytes memory input) external pure returns (uint256);
    function lte(bytes memory input) external pure returns (bytes memory);
    function sub(bytes memory input) external pure returns (bytes memory);
    function mul(bytes memory input) external pure returns (bytes memory);
    function lt(bytes memory input) external pure returns (bytes memory);
    function select(bytes memory input) external pure returns (bytes memory);
    function req(bytes memory input) external pure returns (bytes memory);
    function cast(bytes memory input) external pure returns (bytes memory);
    function trivialEncrypt(bytes memory input) external pure returns (bytes memory);
    function div(bytes memory input) external pure returns (bytes memory);
    function gt(bytes memory input) external pure returns (bytes memory);
    function gte(bytes memory input) external pure returns (bytes memory);
    function rem(bytes memory input) external pure returns (bytes memory);
    function and(bytes memory input) external pure returns (bytes memory);
    function or(bytes memory input) external pure returns (bytes memory);
    function xor(bytes memory input) external pure returns (bytes memory);
    function eq(bytes memory input) external pure returns (bytes memory);
    function ne(bytes memory input) external pure returns (bytes memory);
    function min(bytes memory input) external pure returns (bytes memory);
    function max(bytes memory input) external pure returns (bytes memory);
    function shl(bytes memory input) external pure returns (bytes memory);
    function shr(bytes memory input) external pure returns (bytes memory);
    function not(bytes memory input) external pure returns (bytes memory);
    function getNetworkPublicKey() external pure returns (bytes memory);
}