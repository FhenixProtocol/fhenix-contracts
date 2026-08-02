// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

library Precompiles {
    address public constant Fheos = address(128);
}

contract MockFheOps {
    function maxValue(uint8 utype) public pure returns (uint256) {
        if (utype == 0)  return uint256(type(uint8).max)   + 1;
        if (utype == 1)  return uint256(type(uint16).max)  + 1;
        if (utype == 2)  return uint256(type(uint32).max)  + 1;
        if (utype == 3)  return uint256(type(uint64).max)  + 1;
        if (utype == 4)  return uint256(type(uint128).max) + 1;
        if (utype == 5)  return 0;
        if (utype == 12) return uint256(type(uint160).max) + 1;
        if (utype == 13) return 1;
        revert("Unsupported type");
    }
    function bytes32ToBytes(bytes32 input, uint8) internal pure returns (bytes memory) { return bytes.concat(input); }
    function uint256ToBytes(uint256 value) public pure returns (bytes memory) { bytes memory r = new bytes(32); assembly { mstore(add(r, 32), value) } return r; }
    function boolToBytes(bool value) public pure returns (bytes memory) { bytes memory r = new bytes(1); if (value) r[0] = 0x01; return r; }
    function bytesToUint(bytes memory b) internal pure virtual returns (uint256) { require(b.length <= 32, "Bytes length exceeds 32."); return abi.decode(abi.encodePacked(new bytes(32 - b.length), b), (uint256)); }
    function bytesToBool(bytes memory b) internal pure virtual returns (bool) { require(b.length <= 32, "Bytes length exceeds 32."); return uint8(b[0]) != 0; }
    function _mod(uint256 v, uint8 utype) internal pure returns (uint256) { uint256 mv = maxValue(utype); return mv != 0 ? v % mv : v; }
    function trivialEncrypt(bytes memory input, uint8 toType, int32) external pure returns (bytes memory) { return bytes32ToBytes(bytes32(input), toType); }
    function add(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); uint256 r = bytesToUint(lhsHash) + bytesToUint(rhsHash); return uint256ToBytes(mv != 0 ? r % mv : r); }
    function sub(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); uint256 r = bytesToUint(lhsHash) - bytesToUint(rhsHash); return uint256ToBytes(mv != 0 ? r % mv : r); }
    function mul(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); uint256 r = bytesToUint(lhsHash) * bytesToUint(rhsHash); return uint256ToBytes(mv != 0 ? r % mv : r); }
    function div(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); uint256 r = bytesToUint(lhsHash) / bytesToUint(rhsHash); return uint256ToBytes(mv != 0 ? r % mv : r); }
    function rem(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); uint256 r = bytesToUint(lhsHash) % bytesToUint(rhsHash); return uint256ToBytes(mv != 0 ? r % mv : r); }
    function lte(uint8 utype, bytes memory l, bytes memory r) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return boolToBytes((mv!=0?bytesToUint(l)%mv:bytesToUint(l)) <= (mv!=0?bytesToUint(r)%mv:bytesToUint(r))); }
    function lt(uint8 utype, bytes memory l, bytes memory r) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return boolToBytes((mv!=0?bytesToUint(l)%mv:bytesToUint(l)) < (mv!=0?bytesToUint(r)%mv:bytesToUint(r))); }
    function gt(uint8 utype, bytes memory l, bytes memory r) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return boolToBytes((mv!=0?bytesToUint(l)%mv:bytesToUint(l)) > (mv!=0?bytesToUint(r)%mv:bytesToUint(r))); }
    function gte(uint8 utype, bytes memory l, bytes memory r) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return boolToBytes((mv!=0?bytesToUint(l)%mv:bytesToUint(l)) >= (mv!=0?bytesToUint(r)%mv:bytesToUint(r))); }
    function eq(uint8 utype, bytes memory l, bytes memory r) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return boolToBytes((mv!=0?bytesToUint(l)%mv:bytesToUint(l)) == (mv!=0?bytesToUint(r)%mv:bytesToUint(r))); }
    function ne(uint8 utype, bytes memory l, bytes memory r) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return boolToBytes((mv!=0?bytesToUint(l)%mv:bytesToUint(l)) != (mv!=0?bytesToUint(r)%mv:bytesToUint(r))); }
    function min(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return (mv!=0?bytesToUint(lhsHash)%mv:bytesToUint(lhsHash)) >= (mv!=0?bytesToUint(rhsHash)%mv:bytesToUint(rhsHash)) ? rhsHash : lhsHash; }
    function max(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { uint256 mv = maxValue(utype); return (mv!=0?bytesToUint(lhsHash)%mv:bytesToUint(lhsHash)) >= (mv!=0?bytesToUint(rhsHash)%mv:bytesToUint(rhsHash)) ? lhsHash : rhsHash; }
    function and(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { bytes32 a; bytes32 b; assembly { a := mload(add(lhsHash,32)) b := mload(add(rhsHash,32)) } return bytes32ToBytes(a & b, utype); }
    function or(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { bytes32 a; bytes32 b; assembly { a := mload(add(lhsHash,32)) b := mload(add(rhsHash,32)) } return bytes32ToBytes(a | b, utype); }
    function xor(uint8 utype, bytes memory lhsHash, bytes memory rhsHash) external pure returns (bytes memory) { bytes32 a; bytes32 b; assembly { a := mload(add(lhsHash,32)) b := mload(add(rhsHash,32)) } return bytes32ToBytes(a ^ b, utype); }
    function not(uint8 utype, bytes memory value) external pure returns (bytes memory) { bytes32 v; assembly { v := mload(add(value,32)) } return bytes32ToBytes(~v, utype); }
    function shl(uint8, bytes memory l, bytes memory r) external pure returns (bytes memory) { return uint256ToBytes(bytesToUint(l) << bytesToUint(r)); }
    function shr(uint8, bytes memory l, bytes memory r) external pure returns (bytes memory) { return uint256ToBytes(bytesToUint(l) >> bytesToUint(r)); }
    function select(uint8, bytes memory ctrl, bytes memory t, bytes memory f) external pure returns (bytes memory) { return bytesToBool(ctrl) ? t : f; }
    function req(uint8, bytes memory input) external pure returns (bytes memory) { require(bytesToUint(input) != 0); return input; }
    function cast(uint8, bytes memory input, uint8 toType) external pure returns (bytes memory) { return bytes32ToBytes(bytes32(input), toType); }
    function sealOutput(uint8, bytes memory ctHash, bytes memory) external pure returns (string memory) { return string(ctHash); }
    function verify(uint8, bytes memory input, int32) external pure returns (bytes memory) { return input; }
    function decrypt(uint8, bytes memory input, uint256) external pure returns (uint256) { return bytesToUint(input); }
    function log(string memory) external pure {}
    function getNetworkPublicKey(int32) external pure returns (bytes memory) { return bytes("((-(-_(-_-)_-)-)) You've stepped into the wrong neighborhood pal."); }
    function random(uint8 utype, uint64, int32) external view returns (bytes memory) { uint256 mv = maxValue(utype); uint256 r = uint(keccak256(abi.encode(block.timestamp))); return uint256ToBytes(mv != 0 ? r % mv : r); }
}
