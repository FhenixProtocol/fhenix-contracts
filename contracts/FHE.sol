// SPDX-License-Identifier: BSD-3-Clause-Clear
// solhint-disable one-contract-per-file

pragma solidity >=0.8.19 <0.9.0;

import {Precompiles, FheOps} from "./FheOS.sol";

type ebool is uint256;
type euint8 is uint256;
type euint16 is uint256;
type euint32 is uint256;

struct inEbool {
    bytes data;
}
struct inEuint8 {
    bytes data;
}
struct inEuint16 {
    bytes data;
}
struct inEuint32 {
    bytes data;
}

library Common {
    // Values used to communicate types to the runtime.
    uint8 internal constant EBOOL_TFHE_GO = 0;
    uint8 internal constant EUINT8_TFHE_GO = 0;
    uint8 internal constant EUINT16_TFHE_GO = 1;
    uint8 internal constant EUINT32_TFHE_GO = 2;

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
    
    function toBytes(uint256 x) internal pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
}

library Impl {
    function sealoutput(uint8 utype, uint256 ciphertext, bytes32 publicKey) internal pure returns (bytes memory reencrypted) {
        // Call the sealoutput precompile.
        reencrypted = FheOps(Precompiles.Fheos).sealOutput(utype, Common.toBytes(ciphertext), bytes.concat(publicKey));

        return reencrypted;
    }

    function verify(bytes memory _ciphertextBytes, uint8 _toType) internal pure returns (uint256 result) {
        bytes memory output;

        // Call the verify precompile.
        output = FheOps(Precompiles.Fheos).verify(_toType, _ciphertextBytes);
        result = getValue(output);
    }

    function cast(uint8 utype, uint256 ciphertext, uint8 toType) internal pure returns (uint256 result) {
        bytes memory output;

        // Call the cast precompile.
        output = FheOps(Precompiles.Fheos).cast(utype, Common.toBytes(ciphertext), toType);
        result = getValue(output);
    }

    function getValue(bytes memory a) internal pure returns (uint256 value) {
        assembly {
            value := mload(add(a, 0x20))
        }
    }

    function trivialEncrypt(uint256 value, uint8 toType) internal pure returns (uint256 result) {
        bytes memory output;

        // Call the trivialEncrypt precompile.
        output = FheOps(Precompiles.Fheos).trivialEncrypt(Common.toBytes(value), toType);

        result = getValue(output);
    }

    function select(uint8 utype, uint256 control, uint256 ifTrue, uint256 ifFalse) internal pure returns (uint256 result) {
        bytes memory output;

        // Call the trivialEncrypt precompile.
        output = FheOps(Precompiles.Fheos).select(utype, Common.toBytes(control), Common.toBytes(ifTrue), Common.toBytes(ifFalse));

        result = getValue(output);
    }
}

library FHE {
    euint8 public constant NIL8 = euint8.wrap(0);
    euint16 public constant NIL16 = euint16.wrap(0);
    euint32 public constant NIL32 = euint32.wrap(0);

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(ebool v) internal pure returns (bool) {
        return ebool.unwrap(v) != 0;
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint8 v) internal pure returns (bool) {
        return euint8.unwrap(v) != 0;
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint16 v) internal pure returns (bool) {
        return euint16.unwrap(v) != 0;
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint32 v) internal pure returns (bool) {
        return euint32.unwrap(v) != 0;
    }

    function getValue(bytes memory a) private pure returns (uint256 value) {
        assembly {
            value := mload(add(a, 0x20))
        }
    }
    
    function mathHelper(
        uint8 utype,
        uint256 lhs,
        uint256 rhs,
        function(uint8, bytes memory, bytes memory) external pure returns (bytes memory) impl
    ) internal pure returns (uint256 result) {
        bytes memory output;
        output = impl(utype, Common.toBytes(lhs), Common.toBytes(rhs));
        result = getValue(output);
    }
    
    /// @notice This functions performs the add operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the add operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the add operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint32.wrap(result);
    }
    /// @notice performs the sealoutput function on a ebool ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(ebool value, bytes32 publicKey) internal pure returns (bytes memory) {
        if (!isInitialized(value)) {
            value = asEbool(0);
        }
        uint256 unwrapped = ebool.unwrap(value);

        return Impl.sealoutput(Common.EBOOL_TFHE_GO, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint8 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint8 value, bytes32 publicKey) internal pure returns (bytes memory) {
        if (!isInitialized(value)) {
            value = asEuint8(0);
        }
        uint256 unwrapped = euint8.unwrap(value);

        return Impl.sealoutput(Common.EUINT8_TFHE_GO, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint16 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint16 value, bytes32 publicKey) internal pure returns (bytes memory) {
        if (!isInitialized(value)) {
            value = asEuint16(0);
        }
        uint256 unwrapped = euint16.unwrap(value);

        return Impl.sealoutput(Common.EUINT16_TFHE_GO, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint32 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint32 value, bytes32 publicKey) internal pure returns (bytes memory) {
        if (!isInitialized(value)) {
            value = asEuint32(0);
        }
        uint256 unwrapped = euint32.unwrap(value);

        return Impl.sealoutput(Common.EUINT32_TFHE_GO, unwrapped, publicKey);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(ebool input1) internal pure returns (bool) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EBOOL_TFHE_GO, inputAsBytes);
        return Common.bigIntToBool(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint8 input1) internal pure returns (uint8) {
        if (!isInitialized(input1)) {
            input1 = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT8_TFHE_GO, inputAsBytes);
        return Common.bigIntToUint8(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint16 input1) internal pure returns (uint16) {
        if (!isInitialized(input1)) {
            input1 = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT16_TFHE_GO, inputAsBytes);
        return Common.bigIntToUint16(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint32 input1) internal pure returns (uint32) {
        if (!isInitialized(input1)) {
            input1 = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT32_TFHE_GO, inputAsBytes);
        return Common.bigIntToUint32(result);
    }
    /// @notice This functions performs the lte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the lte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the lte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the sub operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the sub operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the sub operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the mul operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the mul operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the mul operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the lt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the lt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the lt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }

    function select(ebool input1, ebool input2, ebool input3) internal pure returns (ebool) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEbool(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEbool(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = ebool.unwrap(input2);
        uint256 unwrappedInput3 = ebool.unwrap(input3);

        uint256 result = Impl.select(Common.EBOOL_TFHE_GO, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return ebool.wrap(result);
    }

    function select(ebool input1, euint8 input2, euint8 input3) internal pure returns (euint8) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEuint8(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEuint8(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = euint8.unwrap(input2);
        uint256 unwrappedInput3 = euint8.unwrap(input3);

        uint256 result = Impl.select(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint8.wrap(result);
    }

    function select(ebool input1, euint16 input2, euint16 input3) internal pure returns (euint16) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEuint16(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEuint16(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = euint16.unwrap(input2);
        uint256 unwrappedInput3 = euint16.unwrap(input3);

        uint256 result = Impl.select(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint16.wrap(result);
    }

    function select(ebool input1, euint32 input2, euint32 input3) internal pure returns (euint32) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEuint32(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEuint32(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = euint32.unwrap(input2);
        uint256 unwrappedInput3 = euint32.unwrap(input3);

        uint256 result = Impl.select(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint32.wrap(result);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(ebool input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EBOOL_TFHE_GO, inputAsBytes);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(euint8 input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EUINT8_TFHE_GO, inputAsBytes);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(euint16 input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EUINT16_TFHE_GO, inputAsBytes);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(euint32 input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EUINT32_TFHE_GO, inputAsBytes);
    }
    /// @notice This functions performs the div operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the div operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the div operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the gt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the gt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the gt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the gte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the gte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the gte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the rem operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the rem operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the rem operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the and operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function and(ebool lhs, ebool rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEbool(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(lhs);
        uint256 unwrappedInput2 = ebool.unwrap(rhs);

        uint256 result = mathHelper(Common.EBOOL_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the and operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the and operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the and operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the or operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function or(ebool lhs, ebool rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEbool(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(lhs);
        uint256 unwrappedInput2 = ebool.unwrap(rhs);

        uint256 result = mathHelper(Common.EBOOL_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the or operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the or operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the or operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the xor operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(ebool lhs, ebool rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEbool(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(lhs);
        uint256 unwrappedInput2 = ebool.unwrap(rhs);

        uint256 result = mathHelper(Common.EBOOL_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the xor operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the xor operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the xor operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(ebool lhs, ebool rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEbool(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(lhs);
        uint256 unwrappedInput2 = ebool.unwrap(rhs);

        uint256 result = mathHelper(Common.EBOOL_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(ebool lhs, ebool rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEbool(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(lhs);
        uint256 unwrappedInput2 = ebool.unwrap(rhs);

        uint256 result = mathHelper(Common.EBOOL_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This functions performs the min operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the min operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the min operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the max operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the max operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the max operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the shl operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the shl operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the shl operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint32.wrap(result);
    }
    /// @notice This functions performs the shr operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint8.wrap(result);
    }
    /// @notice This functions performs the shr operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint16.wrap(result);
    }
    /// @notice This functions performs the shr operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE_GO, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint32.wrap(result);
    }

    /// @notice Performs the "not" for the ebool type
    /// @dev Implemented by a workaround due to ebool being a euint8 type behind the scenes, therefore xor is needed to assure that not(true) = false and vise-versa
    /// @param value input ebool ciphertext
    /// @return Result of the not operation on `value` 
    function not(ebool value) internal pure returns (ebool) {
        return xor(value, asEbool(true));
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function not(euint8 input1) internal pure returns (euint8) {
        if (!isInitialized(input1)) {
            input1 = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT8_TFHE_GO, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint8.wrap(result);
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function not(euint16 input1) internal pure returns (euint16) {
        if (!isInitialized(input1)) {
            input1 = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT16_TFHE_GO, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint16.wrap(result);
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function not(euint32 input1) internal pure returns (euint32) {
        if (!isInitialized(input1)) {
            input1 = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT32_TFHE_GO, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint32.wrap(result);
    }

    // ********** TYPE CASTING ************* //
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an ebool
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEbool(inEbool memory value) internal pure returns (ebool) {
        return FHE.asEbool(value.data);
    }
    /// @notice Converts a ebool to an euint8
    function asEuint8(ebool value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EBOOL_TFHE_GO, ebool.unwrap(value), Common.EUINT8_TFHE_GO));
    }
    /// @notice Converts a ebool to an euint16
    function asEuint16(ebool value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EBOOL_TFHE_GO, ebool.unwrap(value), Common.EUINT16_TFHE_GO));
    }
    /// @notice Converts a ebool to an euint32
    function asEuint32(ebool value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EBOOL_TFHE_GO, ebool.unwrap(value), Common.EUINT32_TFHE_GO));
    }
    
    /// @notice Converts a euint8 to an ebool
    function asEbool(euint8 value) internal pure returns (ebool) {
        return ne(value, asEuint8(0));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint8
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint8(inEuint8 memory value) internal pure returns (euint8) {
        return FHE.asEuint8(value.data);
    }
    /// @notice Converts a euint8 to an euint16
    function asEuint16(euint8 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT8_TFHE_GO, euint8.unwrap(value), Common.EUINT16_TFHE_GO));
    }
    /// @notice Converts a euint8 to an euint32
    function asEuint32(euint8 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT8_TFHE_GO, euint8.unwrap(value), Common.EUINT32_TFHE_GO));
    }
    
    /// @notice Converts a euint16 to an ebool
    function asEbool(euint16 value) internal pure returns (ebool) {
        return ne(value, asEuint16(0));
    }
    /// @notice Converts a euint16 to an euint8
    function asEuint8(euint16 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT16_TFHE_GO, euint16.unwrap(value), Common.EUINT8_TFHE_GO));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint16
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint16(inEuint16 memory value) internal pure returns (euint16) {
        return FHE.asEuint16(value.data);
    }
    /// @notice Converts a euint16 to an euint32
    function asEuint32(euint16 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT16_TFHE_GO, euint16.unwrap(value), Common.EUINT32_TFHE_GO));
    }
    
    /// @notice Converts a euint32 to an ebool
    function asEbool(euint32 value) internal pure returns (ebool) {
        return ne(value, asEuint32(0));
    }
    /// @notice Converts a euint32 to an euint8
    function asEuint8(euint32 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT32_TFHE_GO, euint32.unwrap(value), Common.EUINT8_TFHE_GO));
    }
    /// @notice Converts a euint32 to an euint16
    function asEuint16(euint32 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT32_TFHE_GO, euint32.unwrap(value), Common.EUINT16_TFHE_GO));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint32
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint32(inEuint32 memory value) internal pure returns (euint32) {
        return FHE.asEuint32(value.data);
    }
    /// @notice Converts a uint256 to an ebool
    function asEbool(uint256 value) internal pure returns (ebool) {
        return ebool.wrap(Impl.trivialEncrypt(value, Common.EBOOL_TFHE_GO));
    }
    /// @notice Converts a uint256 to an euint8
    function asEuint8(uint256 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.trivialEncrypt(value, Common.EUINT8_TFHE_GO));
    }
    /// @notice Converts a uint256 to an euint16
    function asEuint16(uint256 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.trivialEncrypt(value, Common.EUINT16_TFHE_GO));
    }
    /// @notice Converts a uint256 to an euint32
    function asEuint32(uint256 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.trivialEncrypt(value, Common.EUINT32_TFHE_GO));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an ebool
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEbool(bytes memory value) internal pure returns (ebool) {
        return ebool.wrap(Impl.verify(value, Common.EBOOL_TFHE_GO));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint8
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint8(bytes memory value) internal pure returns (euint8) {
        return euint8.wrap(Impl.verify(value, Common.EUINT8_TFHE_GO));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint16
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint16(bytes memory value) internal pure returns (euint16) {
        return euint16.wrap(Impl.verify(value, Common.EUINT16_TFHE_GO));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint32
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint32(bytes memory value) internal pure returns (euint32) {
        return euint32.wrap(Impl.verify(value, Common.EUINT32_TFHE_GO));
    }
    /// @notice Converts a plaintext boolean value to a ciphertext ebool
    /// @dev Privacy: The input value is public, therefore the ciphertext should be considered public and should be used
    ///only for mathematical operations, not to represent data that should be private
    /// @return A ciphertext representation of the input 
    function asEbool(bool value) internal pure returns (ebool) {
        uint256 sVal = 0;
        if (value) {
            sVal = 1;
        }

        return asEbool(sVal);
    }
}

// ********** OPERATOR OVERLOADING ************* //

using {operatorAddEuint8 as +} for euint8 global;
/// @notice Performs the add operation
function operatorAddEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.add(lhs, rhs);
}

using {operatorAddEuint16 as +} for euint16 global;
/// @notice Performs the add operation
function operatorAddEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.add(lhs, rhs);
}

using {operatorAddEuint32 as +} for euint32 global;
/// @notice Performs the add operation
function operatorAddEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.add(lhs, rhs);
}

using {operatorSubEuint8 as -} for euint8 global;
/// @notice Performs the sub operation
function operatorSubEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.sub(lhs, rhs);
}

using {operatorSubEuint16 as -} for euint16 global;
/// @notice Performs the sub operation
function operatorSubEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.sub(lhs, rhs);
}

using {operatorSubEuint32 as -} for euint32 global;
/// @notice Performs the sub operation
function operatorSubEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.sub(lhs, rhs);
}

using {operatorMulEuint8 as *} for euint8 global;
/// @notice Performs the mul operation
function operatorMulEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.mul(lhs, rhs);
}

using {operatorMulEuint16 as *} for euint16 global;
/// @notice Performs the mul operation
function operatorMulEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.mul(lhs, rhs);
}

using {operatorMulEuint32 as *} for euint32 global;
/// @notice Performs the mul operation
function operatorMulEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.mul(lhs, rhs);
}

using {operatorDivEuint8 as /} for euint8 global;
/// @notice Performs the div operation
function operatorDivEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.div(lhs, rhs);
}

using {operatorDivEuint16 as /} for euint16 global;
/// @notice Performs the div operation
function operatorDivEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.div(lhs, rhs);
}

using {operatorDivEuint32 as /} for euint32 global;
/// @notice Performs the div operation
function operatorDivEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.div(lhs, rhs);
}

using {operatorOrEbool as |} for ebool global;
/// @notice Performs the or operation
function operatorOrEbool(ebool lhs, ebool rhs) pure returns (ebool) {
    return FHE.or(lhs, rhs);
}

using {operatorOrEuint8 as |} for euint8 global;
/// @notice Performs the or operation
function operatorOrEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.or(lhs, rhs);
}

using {operatorOrEuint16 as |} for euint16 global;
/// @notice Performs the or operation
function operatorOrEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.or(lhs, rhs);
}

using {operatorOrEuint32 as |} for euint32 global;
/// @notice Performs the or operation
function operatorOrEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.or(lhs, rhs);
}

using {operatorAndEbool as &} for ebool global;
/// @notice Performs the and operation
function operatorAndEbool(ebool lhs, ebool rhs) pure returns (ebool) {
    return FHE.and(lhs, rhs);
}

using {operatorAndEuint8 as &} for euint8 global;
/// @notice Performs the and operation
function operatorAndEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.and(lhs, rhs);
}

using {operatorAndEuint16 as &} for euint16 global;
/// @notice Performs the and operation
function operatorAndEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.and(lhs, rhs);
}

using {operatorAndEuint32 as &} for euint32 global;
/// @notice Performs the and operation
function operatorAndEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.and(lhs, rhs);
}

using {operatorXorEbool as ^} for ebool global;
/// @notice Performs the xor operation
function operatorXorEbool(ebool lhs, ebool rhs) pure returns (ebool) {
    return FHE.xor(lhs, rhs);
}

using {operatorXorEuint8 as ^} for euint8 global;
/// @notice Performs the xor operation
function operatorXorEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.xor(lhs, rhs);
}

using {operatorXorEuint16 as ^} for euint16 global;
/// @notice Performs the xor operation
function operatorXorEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.xor(lhs, rhs);
}

using {operatorXorEuint32 as ^} for euint32 global;
/// @notice Performs the xor operation
function operatorXorEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.xor(lhs, rhs);
}

using {operatorRemEuint8 as %} for euint8 global;
/// @notice Performs the rem operation
function operatorRemEuint8(euint8 lhs, euint8 rhs) pure returns (euint8) {
    return FHE.rem(lhs, rhs);
}

using {operatorRemEuint16 as %} for euint16 global;
/// @notice Performs the rem operation
function operatorRemEuint16(euint16 lhs, euint16 rhs) pure returns (euint16) {
    return FHE.rem(lhs, rhs);
}

using {operatorRemEuint32 as %} for euint32 global;
/// @notice Performs the rem operation
function operatorRemEuint32(euint32 lhs, euint32 rhs) pure returns (euint32) {
    return FHE.rem(lhs, rhs);
}

// ********** BINDING DEFS ************* //

using BindingsEbool for ebool global;
library BindingsEbool {
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the eq
    function eq(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the ne
    function ne(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the and
    function and(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the or
    function or(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the xor
    function xor(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.xor(lhs, rhs);
    }
    function toU8(ebool value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU16(ebool value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function toU32(ebool value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function seal(ebool value, bytes32 publicKey) internal pure returns (bytes memory) {
        return FHE.sealoutput(value, publicKey);
    }
}

using BindingsEuint8 for euint8 global;
library BindingsEuint8 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the add
    function add(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the mul
    function mul(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the div
    function div(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.div(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the sub
    function sub(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the eq
    function eq(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the ne
    function ne(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the and
    function and(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the or
    function or(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the xor
    function xor(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the gt
    function gt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the gte
    function gte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the lt
    function lt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the lte
    function lte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the rem
    function rem(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.rem(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the max
    function max(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the min
    function min(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the shl
    function shl(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the shr
    function shr(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.shr(lhs, rhs);
    }
    function toBool(euint8 value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU16(euint8 value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function toU32(euint8 value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function seal(euint8 value, bytes32 publicKey) internal pure returns (bytes memory) {
        return FHE.sealoutput(value, publicKey);
    }
}

using BindingsEuint16 for euint16 global;
library BindingsEuint16 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the add
    function add(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the mul
    function mul(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the div
    function div(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.div(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the sub
    function sub(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the eq
    function eq(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the ne
    function ne(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the and
    function and(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the or
    function or(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the xor
    function xor(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the gt
    function gt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the gte
    function gte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the lt
    function lt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the lte
    function lte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the rem
    function rem(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.rem(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the max
    function max(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the min
    function min(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the shl
    function shl(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the shr
    function shr(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.shr(lhs, rhs);
    }
    function toBool(euint16 value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU8(euint16 value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU32(euint16 value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function seal(euint16 value, bytes32 publicKey) internal pure returns (bytes memory) {
        return FHE.sealoutput(value, publicKey);
    }
}

using BindingsEuint32 for euint32 global;
library BindingsEuint32 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the add
    function add(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the mul
    function mul(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the div
    function div(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.div(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the sub
    function sub(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the eq
    function eq(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the ne
    function ne(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the and
    function and(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the or
    function or(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the xor
    function xor(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the gt
    function gt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the gte
    function gte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the lt
    function lt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the lte
    function lte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the rem
    function rem(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.rem(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the max
    function max(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the min
    function min(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the shl
    function shl(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the shr
    function shr(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.shr(lhs, rhs);
    }
    function toBool(euint32 value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU8(euint32 value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU16(euint32 value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function seal(euint32 value, bytes32 publicKey) internal pure returns (bytes memory) {
        return FHE.sealoutput(value, publicKey);
    }
}