// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity >=0.8.13 <0.9.0;

import "./FheOS.sol";

type ebool is uint256;
type euint8 is uint256;
type euint16 is uint256;
type euint32 is uint256;

library Common {
    // Values used to communicate types to the runtime.
    uint8 internal constant ebool_tfhe_go = 0;
    uint8 internal constant euint8_tfhe_go = 0;
    uint8 internal constant euint16_tfhe_go = 1;
    uint8 internal constant euint32_tfhe_go = 2;
    
    function bigIntToBool(uint256 i) internal pure returns (bool) {
        return (i > 0);
    }
    
    function bigIntToUint8(uint256 i) internal pure returns (uint8) {
        return uint8(i);
    }
    
    function bigIntToUint16(uint256 i) internal pure returns (uint16) {
        return uint16(i);
    }
    
    function bigIntToUint32(uint256 i) internal pure returns (uint32) {
        return uint32(i);
    }
    
    function bigIntToUint64(uint256 i) internal pure returns (uint64) {
        return uint64(i);
    }
    
    function bigIntToUint128(uint256 i) internal pure returns (uint128) {
        return uint128(i);
    }
    
    function bigIntToUint256(uint256 i) internal pure returns (uint256) {
        return i;
    }
}

library Impl {
    function reencrypt(uint256 ciphertext, bytes32 publicKey) internal pure returns (bytes memory reencrypted) {
        bytes32[2] memory input;
        input[0] = bytes32(ciphertext);
        input[1] = publicKey;

        // Call the reencrypt precompile.
        reencrypted = FheOps(Precompiles.Fheos).reencrypt(bytes.concat(input[0], input[1]));

        return reencrypted;
    }

    function verify(bytes memory _ciphertextBytes, uint8 _toType) internal pure returns (uint256 result) {
        bytes memory input = bytes.concat(_ciphertextBytes, bytes1(_toType));

        bytes memory output;

        // Call the verify precompile.
        output = FheOps(Precompiles.Fheos).verify(input);
        result = getValue(output);
    }

    function cast(uint256 ciphertext, uint8 toType) internal pure returns (uint256 result) {
        bytes memory input = bytes.concat(bytes32(ciphertext), bytes1(toType));

        bytes memory output;

        // Call the cast precompile.
        output = FheOps(Precompiles.Fheos).cast(input);
        result = getValue(output);
    }
    
    function getValue(bytes memory a) internal pure returns (uint256 value) {
        assembly {
            value := mload(add(a, 0x20))
        }
    }
    
    function trivialEncrypt(uint256 value, uint8 toType) internal pure returns (uint256 result) {
        bytes memory input = bytes.concat(bytes32(value), bytes1(toType));

        bytes memory output;

        // Call the trivialEncrypt precompile.
        output = FheOps(Precompiles.Fheos).trivialEncrypt(input);

        result = getValue(output);
    }
    
    function select(uint256 control, uint256 ifTrue, uint256 ifFalse) internal pure returns (uint256 result) {
        bytes memory input = bytes.concat(bytes32(control), bytes32(ifTrue), bytes32(ifFalse));

        bytes memory output;

        // Call the trivialEncrypt precompile.
        output = FheOps(Precompiles.Fheos).select(input);

        result = getValue(output);
    }

}

library TFHE {
    euint8 constant NIL8 = euint8.wrap(0);
    euint16 constant NIL16 = euint16.wrap(0);
    euint32 constant NIL32 = euint32.wrap(0);

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(ebool v) internal pure returns (bool) {
        return ebool.unwrap(v) != 0;
    }

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(euint8 v) internal pure returns (bool) {
        return euint8.unwrap(v) != 0;
    }

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(euint16 v) internal pure returns (bool) {
        return euint16.unwrap(v) != 0;
    }

    // Return true if the enrypted integer is initialized and false otherwise.
    function isInitialized(euint32 v) internal pure returns (bool) {
        return euint32.unwrap(v) != 0;
    }
    
    function getValue(bytes memory a) internal pure returns (uint256 value) {
        assembly {
            value := mload(add(a, 0x20))
        }
    }

    function mathHelper(
        uint256 lhs,
        uint256 rhs,
        function(bytes memory) external pure returns (bytes memory) impl
    ) internal pure returns (uint256 result) {
        bytes memory input = bytes.concat(bytes32(lhs), bytes32(rhs));

        bytes memory output;
        // Call the add precompile.

        output = impl(input);
        result = getValue(output);
    }

function add(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
    return euint8.wrap(result);

}
function add(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
    return euint16.wrap(result);

}
function add(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
    return euint32.wrap(result);

}
function reencrypt(ebool value, bytes32 publicKey) internal pure returns (bytes memory) {
    uint256 unwrapped = ebool.unwrap(value);

    return Impl.reencrypt(unwrapped, publicKey);

}
function reencrypt(euint8 value, bytes32 publicKey) internal pure returns (bytes memory) {
    uint256 unwrapped = euint8.unwrap(value);

    return Impl.reencrypt(unwrapped, publicKey);

}
function reencrypt(euint16 value, bytes32 publicKey) internal pure returns (bytes memory) {
    uint256 unwrapped = euint16.unwrap(value);

    return Impl.reencrypt(unwrapped, publicKey);

}
function reencrypt(euint32 value, bytes32 publicKey) internal pure returns (bytes memory) {
    uint256 unwrapped = euint32.unwrap(value);

    return Impl.reencrypt(unwrapped, publicKey);

}
function decrypt(ebool input1) internal pure  returns (bool) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    uint256 result = FheOps(Precompiles.Fheos).decrypt(inputAsBytes);
    return Common.bigIntToBool(result);
}

function decrypt(euint8 input1) internal pure  returns (uint8) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    uint256 result = FheOps(Precompiles.Fheos).decrypt(inputAsBytes);
    return Common.bigIntToUint8(result);
}

function decrypt(euint16 input1) internal pure  returns (uint16) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    uint256 result = FheOps(Precompiles.Fheos).decrypt(inputAsBytes);
    return Common.bigIntToUint16(result);
}

function decrypt(euint32 input1) internal pure  returns (uint32) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    uint256 result = FheOps(Precompiles.Fheos).decrypt(inputAsBytes);
    return Common.bigIntToUint32(result);
}

function lte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
    return ebool.wrap(result);

}
function lte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
    return ebool.wrap(result);

}
function lte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
    return ebool.wrap(result);

}
function sub(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
    return euint8.wrap(result);

}
function sub(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
    return euint16.wrap(result);

}
function sub(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
    return euint32.wrap(result);

}
function mul(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
    return euint8.wrap(result);

}
function mul(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
    return euint16.wrap(result);

}
function mul(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
    return euint32.wrap(result);

}
function lt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
    return ebool.wrap(result);

}
function lt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
    return ebool.wrap(result);

}
function lt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
    return ebool.wrap(result);

}
function select(ebool input1, ebool input2, ebool input3) internal pure returns (ebool) {
    if(!isInitialized(input1) || !isInitialized(input2) || !isInitialized(input3)) {
        revert("One or more inputs are not initialized.");
    }

    uint256 unwrappedInput1 = ebool.unwrap(input1);
    uint256 unwrappedInput2 = ebool.unwrap(input2);
    uint256 unwrappedInput3 = ebool.unwrap(input3);

    uint256 result = Impl.select(unwrappedInput1, unwrappedInput2, unwrappedInput3);
    return ebool.wrap(result);
    }
function select(ebool input1, euint8 input2, euint8 input3) internal pure returns (euint8) {
    if(!isInitialized(input1) || !isInitialized(input2) || !isInitialized(input3)) {
        revert("One or more inputs are not initialized.");
    }

    uint256 unwrappedInput1 = ebool.unwrap(input1);
    uint256 unwrappedInput2 = euint8.unwrap(input2);
    uint256 unwrappedInput3 = euint8.unwrap(input3);

    uint256 result = Impl.select(unwrappedInput1, unwrappedInput2, unwrappedInput3);
    return euint8.wrap(result);
    }
function select(ebool input1, euint16 input2, euint16 input3) internal pure returns (euint16) {
    if(!isInitialized(input1) || !isInitialized(input2) || !isInitialized(input3)) {
        revert("One or more inputs are not initialized.");
    }

    uint256 unwrappedInput1 = ebool.unwrap(input1);
    uint256 unwrappedInput2 = euint16.unwrap(input2);
    uint256 unwrappedInput3 = euint16.unwrap(input3);

    uint256 result = Impl.select(unwrappedInput1, unwrappedInput2, unwrappedInput3);
    return euint16.wrap(result);
    }
function select(ebool input1, euint32 input2, euint32 input3) internal pure returns (euint32) {
    if(!isInitialized(input1) || !isInitialized(input2) || !isInitialized(input3)) {
        revert("One or more inputs are not initialized.");
    }

    uint256 unwrappedInput1 = ebool.unwrap(input1);
    uint256 unwrappedInput2 = euint32.unwrap(input2);
    uint256 unwrappedInput3 = euint32.unwrap(input3);

    uint256 result = Impl.select(unwrappedInput1, unwrappedInput2, unwrappedInput3);
    return euint32.wrap(result);
    }
function req(ebool input1) internal pure {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    FheOps(Precompiles.Fheos).req(inputAsBytes);
}

function req(euint8 input1) internal pure {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    FheOps(Precompiles.Fheos).req(inputAsBytes);
}

function req(euint16 input1) internal pure {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    FheOps(Precompiles.Fheos).req(inputAsBytes);
}

function req(euint32 input1) internal pure {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    FheOps(Precompiles.Fheos).req(inputAsBytes);
}

function div(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
    return euint8.wrap(result);

}
function div(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
    return euint16.wrap(result);

}
function div(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
    return euint32.wrap(result);

}
function gt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
    return ebool.wrap(result);

}
function gt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
    return ebool.wrap(result);

}
function gt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
    return ebool.wrap(result);

}
function gte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
    return ebool.wrap(result);

}
function gte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
    return ebool.wrap(result);

}
function gte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
    return ebool.wrap(result);

}
function rem(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
    return euint8.wrap(result);

}
function rem(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
    return euint16.wrap(result);

}
function rem(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
    return euint32.wrap(result);

}
function and(ebool lhs, ebool rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(lhs);
    uint256 unwrappedInput2 = ebool.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
    return ebool.wrap(result);

}
function and(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
    return euint8.wrap(result);

}
function and(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
    return euint16.wrap(result);

}
function and(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
    return euint32.wrap(result);

}
function or(ebool lhs, ebool rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(lhs);
    uint256 unwrappedInput2 = ebool.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
    return ebool.wrap(result);

}
function or(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
    return euint8.wrap(result);

}
function or(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
    return euint16.wrap(result);

}
function or(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
    return euint32.wrap(result);

}
function xor(ebool lhs, ebool rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(lhs);
    uint256 unwrappedInput2 = ebool.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
    return ebool.wrap(result);

}
function xor(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
    return euint8.wrap(result);

}
function xor(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
    return euint16.wrap(result);

}
function xor(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
    return euint32.wrap(result);

}
function eq(ebool lhs, ebool rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(lhs);
    uint256 unwrappedInput2 = ebool.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
    return ebool.wrap(result);

}
function eq(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
    return ebool.wrap(result);

}
function eq(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
    return ebool.wrap(result);

}
function eq(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
    return ebool.wrap(result);

}
function ne(ebool lhs, ebool rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = ebool.unwrap(lhs);
    uint256 unwrappedInput2 = ebool.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
    return ebool.wrap(result);

}
function ne(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
    return ebool.wrap(result);

}
function ne(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
    return ebool.wrap(result);

}
function ne(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
    return ebool.wrap(result);

}
function min(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
    return euint8.wrap(result);

}
function min(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
    return euint16.wrap(result);

}
function min(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
    return euint32.wrap(result);

}
function max(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
    return euint8.wrap(result);

}
function max(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
    return euint16.wrap(result);

}
function max(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
    return euint32.wrap(result);

}
function shl(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
    return euint8.wrap(result);

}
function shl(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
    return euint16.wrap(result);

}
function shl(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
    return euint32.wrap(result);

}
function shr(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(lhs);
    uint256 unwrappedInput2 = euint8.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
    return euint8.wrap(result);

}
function shr(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(lhs);
    uint256 unwrappedInput2 = euint16.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
    return euint16.wrap(result);

}
function shr(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
    if(!isInitialized(lhs) || !isInitialized(rhs)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(lhs);
    uint256 unwrappedInput2 = euint32.unwrap(rhs);

    uint256 result = mathHelper(unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
    return euint32.wrap(result);

}
// "not" for ebool not working in the traditional way as it is converting ebool to euint8
// Ebool(true) is Euint8(1) so !Ebool(true) is !Euint8(1) which is Euint8(254) which is still Ebool(true)
function not(ebool value) internal pure returns (ebool) {
    return xor(value,  asEbool(true));
}

function not(euint8 input1) internal pure  returns (euint8) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint8.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    bytes memory b = FheOps(Precompiles.Fheos).not(inputAsBytes);
    uint256 result = Impl.getValue(b);
    return euint8.wrap(result);
}

function not(euint16 input1) internal pure  returns (euint16) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint16.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    bytes memory b = FheOps(Precompiles.Fheos).not(inputAsBytes);
    uint256 result = Impl.getValue(b);
    return euint16.wrap(result);
}

function not(euint32 input1) internal pure  returns (euint32) {
    if(!isInitialized(input1)) {
        revert("One or more inputs are not initialized.");
    }
    uint256 unwrappedInput1 = euint32.unwrap(input1);
    bytes memory inputAsBytes = bytes.concat(bytes32(unwrappedInput1));
    bytes memory b = FheOps(Precompiles.Fheos).not(inputAsBytes);
    uint256 result = Impl.getValue(b);
    return euint32.wrap(result);
}

// ********** TYPE CASTING ************* //
function asEuint8(ebool value) internal pure returns (euint8) {
    return euint8.wrap(Impl.cast(ebool.unwrap(value), Common.euint8_tfhe_go));
}
function asEuint16(ebool value) internal pure returns (euint16) {
    return euint16.wrap(Impl.cast(ebool.unwrap(value), Common.euint16_tfhe_go));
}
function asEuint32(ebool value) internal pure returns (euint32) {
    return euint32.wrap(Impl.cast(ebool.unwrap(value), Common.euint32_tfhe_go));
}
function asEbool(euint8 value) internal pure returns (ebool) {
    return ne(value,  asEuint8(0));
}
function asEuint16(euint8 value) internal pure returns (euint16) {
    return euint16.wrap(Impl.cast(euint8.unwrap(value), Common.euint16_tfhe_go));
}
function asEuint32(euint8 value) internal pure returns (euint32) {
    return euint32.wrap(Impl.cast(euint8.unwrap(value), Common.euint32_tfhe_go));
}
function asEbool(euint16 value) internal pure returns (ebool) {
    return ne(value,  asEuint16(0));
}
function asEuint8(euint16 value) internal pure returns (euint8) {
    return euint8.wrap(Impl.cast(euint16.unwrap(value), Common.euint8_tfhe_go));
}
function asEuint32(euint16 value) internal pure returns (euint32) {
    return euint32.wrap(Impl.cast(euint16.unwrap(value), Common.euint32_tfhe_go));
}
function asEbool(euint32 value) internal pure returns (ebool) {
    return ne(value,  asEuint32(0));
}
function asEuint8(euint32 value) internal pure returns (euint8) {
    return euint8.wrap(Impl.cast(euint32.unwrap(value), Common.euint8_tfhe_go));
}
function asEuint16(euint32 value) internal pure returns (euint16) {
    return euint16.wrap(Impl.cast(euint32.unwrap(value), Common.euint16_tfhe_go));
}
function asEbool(uint256 value) internal pure returns (ebool) {
    return ebool.wrap(Impl.trivialEncrypt(value, Common.ebool_tfhe_go));
}
function asEuint8(uint256 value) internal pure returns (euint8) {
    return euint8.wrap(Impl.trivialEncrypt(value, Common.euint8_tfhe_go));
}
function asEuint16(uint256 value) internal pure returns (euint16) {
    return euint16.wrap(Impl.trivialEncrypt(value, Common.euint16_tfhe_go));
}
function asEuint32(uint256 value) internal pure returns (euint32) {
    return euint32.wrap(Impl.trivialEncrypt(value, Common.euint32_tfhe_go));
}
function asEbool(bytes memory value) internal pure returns (ebool) {
    return ebool.wrap(Impl.verify(value, Common.ebool_tfhe_go));
}
function asEuint8(bytes memory value) internal pure returns (euint8) {
    return euint8.wrap(Impl.verify(value, Common.euint8_tfhe_go));
}
function asEuint16(bytes memory value) internal pure returns (euint16) {
    return euint16.wrap(Impl.verify(value, Common.euint16_tfhe_go));
}
function asEuint32(bytes memory value) internal pure returns (euint32) {
    return euint32.wrap(Impl.verify(value, Common.euint32_tfhe_go));
}
function asEbool(bool value) internal pure returns (ebool) {
    uint256 sVal = 0;
    if (value) {
        sVal = 1;
    }

    return asEbool(sVal);
}

}
// ********** OPERATOR OVERLOADING ************* //

using {operatorAddEuint8 as +, BindingsEuint8.add} for euint8 global;

function operatorAddEuint8(euint8 lhs, euint8  rhs) pure returns (euint8) {
    return TFHE.add(lhs, rhs);
}

using {operatorAddEuint16 as +, BindingsEuint16.add} for euint16 global;

function operatorAddEuint16(euint16 lhs, euint16  rhs) pure returns (euint16) {
    return TFHE.add(lhs, rhs);
}

using {operatorAddEuint32 as +, BindingsEuint32.add} for euint32 global;

function operatorAddEuint32(euint32 lhs, euint32  rhs) pure returns (euint32) {
    return TFHE.add(lhs, rhs);
}

using {operatorSubEuint8 as -, BindingsEuint8.sub} for euint8 global;

function operatorSubEuint8(euint8 lhs, euint8  rhs) pure returns (euint8) {
    return TFHE.sub(lhs, rhs);
}

using {operatorSubEuint16 as -, BindingsEuint16.sub} for euint16 global;

function operatorSubEuint16(euint16 lhs, euint16  rhs) pure returns (euint16) {
    return TFHE.sub(lhs, rhs);
}

using {operatorSubEuint32 as -, BindingsEuint32.sub} for euint32 global;

function operatorSubEuint32(euint32 lhs, euint32  rhs) pure returns (euint32) {
    return TFHE.sub(lhs, rhs);
}

using {operatorMulEuint8 as *, BindingsEuint8.mul} for euint8 global;

function operatorMulEuint8(euint8 lhs, euint8  rhs) pure returns (euint8) {
    return TFHE.mul(lhs, rhs);
}

using {operatorMulEuint16 as *, BindingsEuint16.mul} for euint16 global;

function operatorMulEuint16(euint16 lhs, euint16  rhs) pure returns (euint16) {
    return TFHE.mul(lhs, rhs);
}

using {operatorMulEuint32 as *, BindingsEuint32.mul} for euint32 global;

function operatorMulEuint32(euint32 lhs, euint32  rhs) pure returns (euint32) {
    return TFHE.mul(lhs, rhs);
}

using {operatorDivEuint8 as /, BindingsEuint8.div} for euint8 global;

function operatorDivEuint8(euint8 lhs, euint8  rhs) pure returns (euint8) {
    return TFHE.div(lhs, rhs);
}

using {operatorDivEuint16 as /, BindingsEuint16.div} for euint16 global;

function operatorDivEuint16(euint16 lhs, euint16  rhs) pure returns (euint16) {
    return TFHE.div(lhs, rhs);
}

using {operatorDivEuint32 as /, BindingsEuint32.div} for euint32 global;

function operatorDivEuint32(euint32 lhs, euint32  rhs) pure returns (euint32) {
    return TFHE.div(lhs, rhs);
}

using {operatorOrEuint8 as |, BindingsEuint8.or} for euint8 global;

function operatorOrEuint8(euint8 lhs, euint8  rhs) pure returns (euint8) {
    return TFHE.or(lhs, rhs);
}

using {operatorOrEuint16 as |, BindingsEuint16.or} for euint16 global;

function operatorOrEuint16(euint16 lhs, euint16  rhs) pure returns (euint16) {
    return TFHE.or(lhs, rhs);
}

using {operatorOrEuint32 as |, BindingsEuint32.or} for euint32 global;

function operatorOrEuint32(euint32 lhs, euint32  rhs) pure returns (euint32) {
    return TFHE.or(lhs, rhs);
}

using {operatorAndEuint8 as &, BindingsEuint8.and} for euint8 global;

function operatorAndEuint8(euint8 lhs, euint8  rhs) pure returns (euint8) {
    return TFHE.and(lhs, rhs);
}

using {operatorAndEuint16 as &, BindingsEuint16.and} for euint16 global;

function operatorAndEuint16(euint16 lhs, euint16  rhs) pure returns (euint16) {
    return TFHE.and(lhs, rhs);
}

using {operatorAndEuint32 as &, BindingsEuint32.and} for euint32 global;

function operatorAndEuint32(euint32 lhs, euint32  rhs) pure returns (euint32) {
    return TFHE.and(lhs, rhs);
}

// ********** BINDING DEFS ************* //

using {BindingsEuint8.eq} for euint8 global;

library BindingsEuint8 {
function add(euint8 lhs, euint8  rhs) pure internal returns (euint8) {
    return TFHE.add(lhs, rhs);
}
function mul(euint8 lhs, euint8  rhs) pure internal returns (euint8) {
    return TFHE.mul(lhs, rhs);
}
function div(euint8 lhs, euint8  rhs) pure internal returns (euint8) {
    return TFHE.div(lhs, rhs);
}
function sub(euint8 lhs, euint8  rhs) pure internal returns (euint8) {
    return TFHE.sub(lhs, rhs);
}
function eq(euint8 lhs, euint8  rhs) pure internal returns (ebool) {
    return TFHE.eq(lhs, rhs);
}
function and(euint8 lhs, euint8  rhs) pure internal returns (euint8) {
    return TFHE.and(lhs, rhs);
}
function or(euint8 lhs, euint8  rhs) pure internal returns (euint8) {
    return TFHE.or(lhs, rhs);
}
}
using {BindingsEuint16.eq} for euint16 global;

library BindingsEuint16 {
function add(euint16 lhs, euint16  rhs) pure internal returns (euint16) {
    return TFHE.add(lhs, rhs);
}
function mul(euint16 lhs, euint16  rhs) pure internal returns (euint16) {
    return TFHE.mul(lhs, rhs);
}
function div(euint16 lhs, euint16  rhs) pure internal returns (euint16) {
    return TFHE.div(lhs, rhs);
}
function sub(euint16 lhs, euint16  rhs) pure internal returns (euint16) {
    return TFHE.sub(lhs, rhs);
}
function eq(euint16 lhs, euint16  rhs) pure internal returns (ebool) {
    return TFHE.eq(lhs, rhs);
}
function and(euint16 lhs, euint16  rhs) pure internal returns (euint16) {
    return TFHE.and(lhs, rhs);
}
function or(euint16 lhs, euint16  rhs) pure internal returns (euint16) {
    return TFHE.or(lhs, rhs);
}
}
using {BindingsEuint32.eq} for euint32 global;

library BindingsEuint32 {
function add(euint32 lhs, euint32  rhs) pure internal returns (euint32) {
    return TFHE.add(lhs, rhs);
}
function mul(euint32 lhs, euint32  rhs) pure internal returns (euint32) {
    return TFHE.mul(lhs, rhs);
}
function div(euint32 lhs, euint32  rhs) pure internal returns (euint32) {
    return TFHE.div(lhs, rhs);
}
function sub(euint32 lhs, euint32  rhs) pure internal returns (euint32) {
    return TFHE.sub(lhs, rhs);
}
function eq(euint32 lhs, euint32  rhs) pure internal returns (ebool) {
    return TFHE.eq(lhs, rhs);
}
function and(euint32 lhs, euint32  rhs) pure internal returns (euint32) {
    return TFHE.and(lhs, rhs);
}
function or(euint32 lhs, euint32  rhs) pure internal returns (euint32) {
    return TFHE.or(lhs, rhs);
}
}