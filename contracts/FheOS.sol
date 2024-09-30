// SPDX-License-Identifier: BSD-3-Clause-Clear
// solhint-disable one-contract-per-file
pragma solidity >=0.8.13 <0.9.0;

library Precompiles {
    //solhint-disable const-name-snakecase
    address public constant Fheos = address(128);
}

interface FheOps {
    function log(string memory s) external pure;
    function add(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function verify(uint8 utype, bytes memory input, int32 securityZone) external pure returns (bytes memory);
    function sealOutput(uint8 utype, bytes memory ctHash, bytes memory pk) external pure returns (string memory);
    function decrypt(uint8 utype, bytes memory input, uint256 defaultValue) external pure returns (uint256);
    function lte(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function sub(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function mul(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function lt(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function select(uint8 utype, bytes memory controlHash, bytes memory ifTrueHash, bytes memory ifFalseHash) external pure returns (bytes memory);
    function req(uint8 utype, bytes memory input) external pure returns (bytes memory);
    function cast(uint8 utype, bytes memory input, uint8 toType) external pure returns (bytes memory);
    function trivialEncrypt(bytes memory input, uint8 toType, int32 securityZone) external pure returns (bytes memory);
    function div(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function gt(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function gte(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function rem(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function and(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function or(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function xor(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function eq(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function ne(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function min(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function max(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function shl(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function shr(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function rol(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function ror(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory);
    function not(uint8 utype, bytes memory value) external pure returns (bytes memory);
    function random(uint8 utype, uint64 seed, int32 securityZone) external pure returns (bytes memory);
    function getNetworkPublicKey(int32 securityZone) external pure returns (bytes memory);
    function square(uint8 utype, bytes memory value) external pure returns (bytes memory);
}