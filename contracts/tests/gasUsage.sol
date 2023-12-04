// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract GasUsage {
    using Utils for *;

    function gasUsage(string calldata fn, bytes32 publicKey) external {
        if (Utils.cmp(fn, "add")) {
            TFHE.add(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "and")) {
            TFHE.and(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "asEbool")) {
            TFHE.asEbool(true);
        } else if (Utils.cmp(fn, "asEuint16")) {
            TFHE.asEuint16(1);
        } else if (Utils.cmp(fn, "asEuint32")) {
            TFHE.asEuint32(1);
        } else if (Utils.cmp(fn, "asEuint8")) {
            TFHE.asEuint8(1);
        } else if (Utils.cmp(fn, "cmux")) {
            TFHE.cmux(TFHE.asEbool(true), TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "eq")) {
            TFHE.eq(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "ge")) {
            TFHE.ge(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "gt")) {
            TFHE.gt(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "le")) {
            TFHE.le(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "lt")) {
            TFHE.lt(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "max")) {
            TFHE.max(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "min")) {
            TFHE.min(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "mul")) {
            TFHE.mul(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "ne")) {
            TFHE.ne(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "neg")) {
            TFHE.neg(TFHE.asEuint8(1));
        } else if (Utils.cmp(fn, "not")) {
            TFHE.not(TFHE.asEuint8(1));
        } else if (Utils.cmp(fn, "optReq")) {
            TFHE.optReq(TFHE.asEuint8(1));
        } else if (Utils.cmp(fn, "or")) {
            TFHE.or(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "reencrypt")) {
            TFHE.reencrypt(TFHE.asEuint8(1), publicKey);
        } else if (Utils.cmp(fn, "shl")) {
            TFHE.shl(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "shr")) {
            TFHE.shr(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "sub")) {
            TFHE.sub(TFHE.asEuint8(1), TFHE.asEuint8(2));
        } else if (Utils.cmp(fn, "xor")) {
            TFHE.xor(TFHE.asEuint8(1), TFHE.asEuint8(2));
        }
    }
}
