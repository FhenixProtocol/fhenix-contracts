// SPDX-License-Identifier: BSD-3-Clause-Clear
// solhint-disable one-contract-per-file

pragma solidity >=0.8.19 <0.9.0;

import {Precompiles, FheOps} from "./FheOS.sol";

type ebool is uint256;
type euint8 is uint256;
type euint16 is uint256;
type euint32 is uint256;
type euint64 is uint256;
type euint128 is uint256;
type euint256 is uint256;
type eaddress is uint256;

struct inEbool {
    bytes data;
    int32 securityZone;
}
struct inEuint8 {
    bytes data;
    int32 securityZone;
}
struct inEuint16 {
    bytes data;
    int32 securityZone;
}
struct inEuint32 {
    bytes data;
    int32 securityZone;
}
struct inEuint64 {
    bytes data;
    int32 securityZone;
}
struct inEuint128 {
    bytes data;
    int32 securityZone;
}
struct inEuint256 {
    bytes data;
    int32 securityZone;
}
struct inEaddress {
    bytes data;
    int32 securityZone;
}

struct SealedArray {
    bytes[] data;
}


/// @dev Utility structure providing clients with type context of a sealed output string.
/// Return type of `FHE.sealoutputTyped` and `sealTyped` within the binding libraries.
/// `utype` representing Bool is 13. See `FHE.sol` for more.
struct SealedBool {
    string data;
    uint8 utype;
}

/// @dev Utility structure providing clients with type context of a sealed output string.
/// Return type of `FHE.sealoutputTyped` and `sealTyped` within the binding libraries.
/// `utype` representing Uints is 0-5. See `FHE.sol` for more.
/// `utype` map: {uint8: 0} {uint16: 1} {uint32: 2} {uint64: 3} {uint128: 4} {uint256: 5}.
struct SealedUint {
    string data;
    uint8 utype;
}

/// @dev Utility structure providing clients with type context of a sealed output string.
/// Return type of `FHE.sealoutputTyped` and `sealTyped` within the binding libraries.
/// `utype` representing Address is 12. See `FHE.sol` for more.
struct SealedAddress {
    string data;
    uint8 utype;
}


library Common {
    // Values used to communicate types to the runtime.
    // Must match values defined in warp-drive protobufs for everything to 
    // make sense
    uint8 internal constant EUINT8_TFHE = 0;
    uint8 internal constant EUINT16_TFHE = 1;
    uint8 internal constant EUINT32_TFHE = 2;
    uint8 internal constant EUINT64_TFHE = 3;
    uint8 internal constant EUINT128_TFHE = 4;
    uint8 internal constant EUINT256_TFHE = 5;
    uint8 internal constant EADDRESS_TFHE = 12;
    // uint8 internal constant INT_BGV = 12;
    uint8 internal constant EBOOL_TFHE = 13;
    
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

    function bigIntToAddress(uint256 i) internal pure returns (address) {
        return address(uint160(i));
    }
    
    function toBytes(uint256 x) internal pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}

library Impl {
    function sealoutput(uint8 utype, uint256 ciphertext, bytes32 publicKey) internal pure returns (string memory reencrypted) {
        // Call the sealoutput precompile.
        reencrypted = FheOps(Precompiles.Fheos).sealOutput(utype, Common.toBytes(ciphertext), bytes.concat(publicKey));

        return reencrypted;
    }

    function verify(bytes memory _ciphertextBytes, uint8 _toType, int32 securityZone) internal pure returns (uint256 result) {
        bytes memory output;

        // Call the verify precompile.
        output = FheOps(Precompiles.Fheos).verify(_toType, _ciphertextBytes, securityZone);
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

    function trivialEncrypt(uint256 value, uint8 toType, int32 securityZone) internal pure returns (uint256 result) {
        bytes memory output;

        // Call the trivialEncrypt precompile.
        output = FheOps(Precompiles.Fheos).trivialEncrypt(Common.toBytes(value), toType, securityZone);

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
    
    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint64 v) internal pure returns (bool) {
        return euint64.unwrap(v) != 0;
    }
    
        // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint128 v) internal pure returns (bool) {
        return euint128.unwrap(v) != 0;
    }
    
        // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint256 v) internal pure returns (bool) {
        return euint256.unwrap(v) != 0;
    }

    function isInitialized(eaddress v) internal pure returns (bool) {
        return eaddress.unwrap(v) != 0;
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
    
    /// @notice This function performs the add operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint8.wrap(result);
    }
    /// @notice This function performs the add operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint16.wrap(result);
    }
    /// @notice This function performs the add operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint32.wrap(result);
    }
    /// @notice This function performs the add operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint64.wrap(result);
    }
    /// @notice This function performs the add operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).add);
        return euint128.wrap(result);
    }
    /// @notice performs the sealoutput function on a ebool ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(ebool value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEbool(0);
        }
        uint256 unwrapped = ebool.unwrap(value);

        return Impl.sealoutput(Common.EBOOL_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint8 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint8 value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEuint8(0);
        }
        uint256 unwrapped = euint8.unwrap(value);

        return Impl.sealoutput(Common.EUINT8_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint16 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint16 value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEuint16(0);
        }
        uint256 unwrapped = euint16.unwrap(value);

        return Impl.sealoutput(Common.EUINT16_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint32 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint32 value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEuint32(0);
        }
        uint256 unwrapped = euint32.unwrap(value);

        return Impl.sealoutput(Common.EUINT32_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint64 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint64 value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEuint64(0);
        }
        uint256 unwrapped = euint64.unwrap(value);

        return Impl.sealoutput(Common.EUINT64_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint128 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint128 value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEuint128(0);
        }
        uint256 unwrapped = euint128.unwrap(value);

        return Impl.sealoutput(Common.EUINT128_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a euint256 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint256 value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEuint256(0);
        }
        uint256 unwrapped = euint256.unwrap(value);

        return Impl.sealoutput(Common.EUINT256_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutput function on a eaddress ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(eaddress value, bytes32 publicKey) internal pure returns (string memory) {
        if (!isInitialized(value)) {
            value = asEaddress(0);
        }
        uint256 unwrapped = eaddress.unwrap(value);

        return Impl.sealoutput(Common.EADDRESS_TFHE, unwrapped, publicKey);
    }
    /// @notice performs the sealoutputTyped function on a ebool ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedBool({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EBOOL_TFHE })
    function sealoutputTyped(ebool value, bytes32 publicKey) internal pure returns (SealedBool memory) {
        return SealedBool({ data: sealoutput(value, publicKey), utype: Common.EBOOL_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a euint8 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EUINT8_TFHE })
    function sealoutputTyped(euint8 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Common.EUINT8_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a euint16 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EUINT16_TFHE })
    function sealoutputTyped(euint16 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Common.EUINT16_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a euint32 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EUINT32_TFHE })
    function sealoutputTyped(euint32 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Common.EUINT32_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a euint64 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EUINT64_TFHE })
    function sealoutputTyped(euint64 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Common.EUINT64_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a euint128 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EUINT128_TFHE })
    function sealoutputTyped(euint128 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Common.EUINT128_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a euint256 ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EUINT256_TFHE })
    function sealoutputTyped(euint256 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Common.EUINT256_TFHE });
    }
    /// @notice performs the sealoutputTyped function on a eaddress ciphertext. This operation returns the plaintext value, sealed for the public key provided 
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedAddress({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Common.EADDRESS_TFHE })
    function sealoutputTyped(eaddress value, bytes32 publicKey) internal pure returns (SealedAddress memory) {
        return SealedAddress({ data: sealoutput(value, publicKey), utype: Common.EADDRESS_TFHE });
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(ebool input1) internal pure returns (bool) {
        return FHE.decrypt(input1, false);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(ebool input1, bool defaultValue) internal pure returns (bool) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        uint256 gasDefaultValue;
    
        if (defaultValue) {
            gasDefaultValue = 1;
        } else {
            gasDefaultValue = 0;
        }
        
        uint256 unwrappedInput1 = ebool.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EBOOL_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToBool(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint8 input1) internal pure returns (uint8) {
        return FHE.decrypt(input1, (2 ** 8) / 2);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(euint8 input1, uint8 defaultValue) internal pure returns (uint8) {
        if (!isInitialized(input1)) {
            input1 = asEuint8(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(defaultValue);

        uint256 unwrappedInput1 = euint8.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT8_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToUint8(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint16 input1) internal pure returns (uint16) {
        return FHE.decrypt(input1, (2 ** 16) / 2);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(euint16 input1, uint16 defaultValue) internal pure returns (uint16) {
        if (!isInitialized(input1)) {
            input1 = asEuint16(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(defaultValue);

        uint256 unwrappedInput1 = euint16.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT16_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToUint16(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint32 input1) internal pure returns (uint32) {
        return FHE.decrypt(input1, (2 ** 32) / 2);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(euint32 input1, uint32 defaultValue) internal pure returns (uint32) {
        if (!isInitialized(input1)) {
            input1 = asEuint32(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(defaultValue);

        uint256 unwrappedInput1 = euint32.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT32_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToUint32(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint64 input1) internal pure returns (uint64) {
        return FHE.decrypt(input1, (2 ** 64) / 2);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(euint64 input1, uint64 defaultValue) internal pure returns (uint64) {
        if (!isInitialized(input1)) {
            input1 = asEuint64(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(defaultValue);

        uint256 unwrappedInput1 = euint64.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT64_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToUint64(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint128 input1) internal pure returns (uint128) {
        return FHE.decrypt(input1, (2 ** 128) / 2);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(euint128 input1, uint128 defaultValue) internal pure returns (uint128) {
        if (!isInitialized(input1)) {
            input1 = asEuint128(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(defaultValue);

        uint256 unwrappedInput1 = euint128.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT128_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToUint128(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(euint256 input1) internal pure returns (uint256) {
        return FHE.decrypt(input1, (2 ** 256) / 2);
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(euint256 input1, uint256 defaultValue) internal pure returns (uint256) {
        if (!isInitialized(input1)) {
            input1 = asEuint256(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(defaultValue);

        uint256 unwrappedInput1 = euint256.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EUINT256_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToUint256(result);
    }
    /// @notice Performs the decrypt operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function decrypt(eaddress input1) internal pure returns (address) {
        return FHE.decrypt(input1, address(0));
    }
    /// @notice Performs the decrypt operation on a ciphertext with default value for gas estimation
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    /// @param defaultValue default value to be returned on gas estimation
    function decrypt(eaddress input1, address defaultValue) internal pure returns (address) {
        if (!isInitialized(input1)) {
            input1 = asEaddress(0);
        }
        uint256 gasDefaultValue;
    
        gasDefaultValue = uint256(uint160(defaultValue));

        uint256 unwrappedInput1 = eaddress.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        uint256 result = FheOps(Precompiles.Fheos).decrypt(Common.EADDRESS_TFHE, inputAsBytes, gasDefaultValue);
        return Common.bigIntToAddress(result);
    }
    /// @notice This function performs the lte operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lte operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lte operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the sub operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint8.wrap(result);
    }
    /// @notice This function performs the sub operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint16.wrap(result);
    }
    /// @notice This function performs the sub operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint32.wrap(result);
    }
    /// @notice This function performs the sub operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint64.wrap(result);
    }
    /// @notice This function performs the sub operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).sub);
        return euint128.wrap(result);
    }
    /// @notice This function performs the mul operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint8.wrap(result);
    }
    /// @notice This function performs the mul operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint16.wrap(result);
    }
    /// @notice This function performs the mul operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint32.wrap(result);
    }
    /// @notice This function performs the mul operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).mul);
        return euint64.wrap(result);
    }
    /// @notice This function performs the lt operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lt operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lt operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the lt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).lt);
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

        uint256 result = Impl.select(Common.EBOOL_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
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

        uint256 result = Impl.select(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
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

        uint256 result = Impl.select(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
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

        uint256 result = Impl.select(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint32.wrap(result);
    }

    function select(ebool input1, euint64 input2, euint64 input3) internal pure returns (euint64) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEuint64(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEuint64(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = euint64.unwrap(input2);
        uint256 unwrappedInput3 = euint64.unwrap(input3);

        uint256 result = Impl.select(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint64.wrap(result);
    }

    function select(ebool input1, euint128 input2, euint128 input3) internal pure returns (euint128) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEuint128(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEuint128(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = euint128.unwrap(input2);
        uint256 unwrappedInput3 = euint128.unwrap(input3);

        uint256 result = Impl.select(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint128.wrap(result);
    }

    function select(ebool input1, euint256 input2, euint256 input3) internal pure returns (euint256) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEuint256(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEuint256(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = euint256.unwrap(input2);
        uint256 unwrappedInput3 = euint256.unwrap(input3);

        uint256 result = Impl.select(Common.EUINT256_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return euint256.wrap(result);
    }

    function select(ebool input1, eaddress input2, eaddress input3) internal pure returns (eaddress) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        if (!isInitialized(input2)) {
            input2 = asEaddress(0);
        }
        if (!isInitialized(input3)) {
            input3 = asEaddress(0);
        }

        uint256 unwrappedInput1 = ebool.unwrap(input1);
        uint256 unwrappedInput2 = eaddress.unwrap(input2);
        uint256 unwrappedInput3 = eaddress.unwrap(input3);

        uint256 result = Impl.select(Common.EADDRESS_TFHE, unwrappedInput1, unwrappedInput2, unwrappedInput3);
        return eaddress.wrap(result);
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
        FheOps(Precompiles.Fheos).req(Common.EBOOL_TFHE, inputAsBytes);
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
        FheOps(Precompiles.Fheos).req(Common.EUINT8_TFHE, inputAsBytes);
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
        FheOps(Precompiles.Fheos).req(Common.EUINT16_TFHE, inputAsBytes);
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
        FheOps(Precompiles.Fheos).req(Common.EUINT32_TFHE, inputAsBytes);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(euint64 input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EUINT64_TFHE, inputAsBytes);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(euint128 input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EUINT128_TFHE, inputAsBytes);
    }
    /// @notice Performs the req operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function req(euint256 input1) internal pure  {
        if (!isInitialized(input1)) {
            input1 = asEuint256(0);
        }
        uint256 unwrappedInput1 = euint256.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        FheOps(Precompiles.Fheos).req(Common.EUINT256_TFHE, inputAsBytes);
    }
    /// @notice This function performs the div operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
        return euint8.wrap(result);
    }
    /// @notice This function performs the div operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
        return euint16.wrap(result);
    }
    /// @notice This function performs the div operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).div);
        return euint32.wrap(result);
    }
    /// @notice This function performs the gt operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gt operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gt operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gt operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gt);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gte operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gte operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gte operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the gte operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).gte);
        return ebool.wrap(result);
    }
    /// @notice This function performs the rem operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
        return euint8.wrap(result);
    }
    /// @notice This function performs the rem operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
        return euint16.wrap(result);
    }
    /// @notice This function performs the rem operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rem);
        return euint32.wrap(result);
    }
    /// @notice This function performs the and operation
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

        uint256 result = mathHelper(Common.EBOOL_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return ebool.wrap(result);
    }
    /// @notice This function performs the and operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint8.wrap(result);
    }
    /// @notice This function performs the and operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint16.wrap(result);
    }
    /// @notice This function performs the and operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint32.wrap(result);
    }
    /// @notice This function performs the and operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint64.wrap(result);
    }
    /// @notice This function performs the and operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).and);
        return euint128.wrap(result);
    }
    /// @notice This function performs the or operation
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

        uint256 result = mathHelper(Common.EBOOL_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return ebool.wrap(result);
    }
    /// @notice This function performs the or operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint8.wrap(result);
    }
    /// @notice This function performs the or operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint16.wrap(result);
    }
    /// @notice This function performs the or operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint32.wrap(result);
    }
    /// @notice This function performs the or operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint64.wrap(result);
    }
    /// @notice This function performs the or operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).or);
        return euint128.wrap(result);
    }
    /// @notice This function performs the xor operation
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

        uint256 result = mathHelper(Common.EBOOL_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return ebool.wrap(result);
    }
    /// @notice This function performs the xor operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint8.wrap(result);
    }
    /// @notice This function performs the xor operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint16.wrap(result);
    }
    /// @notice This function performs the xor operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint32.wrap(result);
    }
    /// @notice This function performs the xor operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint64.wrap(result);
    }
    /// @notice This function performs the xor operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).xor);
        return euint128.wrap(result);
    }
    /// @notice This function performs the eq operation
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

        uint256 result = mathHelper(Common.EBOOL_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint256 lhs, euint256 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint256(0);
        }
        uint256 unwrappedInput1 = euint256.unwrap(lhs);
        uint256 unwrappedInput2 = euint256.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT256_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the eq operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(eaddress lhs, eaddress rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEaddress(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEaddress(0);
        }
        uint256 unwrappedInput1 = eaddress.unwrap(lhs);
        uint256 unwrappedInput2 = eaddress.unwrap(rhs);

        uint256 result = mathHelper(Common.EADDRESS_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).eq);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
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

        uint256 result = mathHelper(Common.EBOOL_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint256 lhs, euint256 rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint256(0);
        }
        uint256 unwrappedInput1 = euint256.unwrap(lhs);
        uint256 unwrappedInput2 = euint256.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT256_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the ne operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(eaddress lhs, eaddress rhs) internal pure returns (ebool) {
        if (!isInitialized(lhs)) {
            lhs = asEaddress(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEaddress(0);
        }
        uint256 unwrappedInput1 = eaddress.unwrap(lhs);
        uint256 unwrappedInput2 = eaddress.unwrap(rhs);

        uint256 result = mathHelper(Common.EADDRESS_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ne);
        return ebool.wrap(result);
    }
    /// @notice This function performs the min operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint8.wrap(result);
    }
    /// @notice This function performs the min operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint16.wrap(result);
    }
    /// @notice This function performs the min operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint32.wrap(result);
    }
    /// @notice This function performs the min operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint64.wrap(result);
    }
    /// @notice This function performs the min operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).min);
        return euint128.wrap(result);
    }
    /// @notice This function performs the max operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint8.wrap(result);
    }
    /// @notice This function performs the max operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint16.wrap(result);
    }
    /// @notice This function performs the max operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint32.wrap(result);
    }
    /// @notice This function performs the max operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint64.wrap(result);
    }
    /// @notice This function performs the max operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).max);
        return euint128.wrap(result);
    }
    /// @notice This function performs the shl operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint8.wrap(result);
    }
    /// @notice This function performs the shl operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint16.wrap(result);
    }
    /// @notice This function performs the shl operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint32.wrap(result);
    }
    /// @notice This function performs the shl operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint64.wrap(result);
    }
    /// @notice This function performs the shl operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shl);
        return euint128.wrap(result);
    }
    /// @notice This function performs the shr operation
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

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint8.wrap(result);
    }
    /// @notice This function performs the shr operation
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

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint16.wrap(result);
    }
    /// @notice This function performs the shr operation
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

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint32.wrap(result);
    }
    /// @notice This function performs the shr operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint64.wrap(result);
    }
    /// @notice This function performs the shr operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).shr);
        return euint128.wrap(result);
    }
    /// @notice This function performs the rol operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rol);
        return euint8.wrap(result);
    }
    /// @notice This function performs the rol operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rol);
        return euint16.wrap(result);
    }
    /// @notice This function performs the rol operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rol);
        return euint32.wrap(result);
    }
    /// @notice This function performs the rol operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rol);
        return euint64.wrap(result);
    }
    /// @notice This function performs the rol operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).rol);
        return euint128.wrap(result);
    }
    /// @notice This function performs the ror operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        if (!isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(lhs);
        uint256 unwrappedInput2 = euint8.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT8_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ror);
        return euint8.wrap(result);
    }
    /// @notice This function performs the ror operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        if (!isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(lhs);
        uint256 unwrappedInput2 = euint16.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT16_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ror);
        return euint16.wrap(result);
    }
    /// @notice This function performs the ror operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        if (!isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(lhs);
        uint256 unwrappedInput2 = euint32.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT32_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ror);
        return euint32.wrap(result);
    }
    /// @notice This function performs the ror operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        if (!isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(lhs);
        uint256 unwrappedInput2 = euint64.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT64_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ror);
        return euint64.wrap(result);
    }
    /// @notice This function performs the ror operation
    /// @dev If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
    ///Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs The first input 
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        if (!isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!isInitialized(rhs)) {
            rhs = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(lhs);
        uint256 unwrappedInput2 = euint128.unwrap(rhs);

        uint256 result = mathHelper(Common.EUINT128_TFHE, unwrappedInput1, unwrappedInput2, FheOps(Precompiles.Fheos).ror);
        return euint128.wrap(result);
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function not(ebool input1) internal pure returns (ebool) {
        if (!isInitialized(input1)) {
            input1 = asEbool(0);
        }
        uint256 unwrappedInput1 = ebool.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EBOOL_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return ebool.wrap(result);
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
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT8_TFHE, inputAsBytes);
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
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT16_TFHE, inputAsBytes);
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
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT32_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint32.wrap(result);
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function not(euint64 input1) internal pure returns (euint64) {
        if (!isInitialized(input1)) {
            input1 = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT64_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint64.wrap(result);
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function not(euint128 input1) internal pure returns (euint128) {
        if (!isInitialized(input1)) {
            input1 = asEuint128(0);
        }
        uint256 unwrappedInput1 = euint128.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).not(Common.EUINT128_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint128.wrap(result);
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function square(euint8 input1) internal pure returns (euint8) {
        if (!isInitialized(input1)) {
            input1 = asEuint8(0);
        }
        uint256 unwrappedInput1 = euint8.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).square(Common.EUINT8_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint8.wrap(result);
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function square(euint16 input1) internal pure returns (euint16) {
        if (!isInitialized(input1)) {
            input1 = asEuint16(0);
        }
        uint256 unwrappedInput1 = euint16.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).square(Common.EUINT16_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint16.wrap(result);
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function square(euint32 input1) internal pure returns (euint32) {
        if (!isInitialized(input1)) {
            input1 = asEuint32(0);
        }
        uint256 unwrappedInput1 = euint32.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).square(Common.EUINT32_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint32.wrap(result);
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param input1 the input ciphertext
    function square(euint64 input1) internal pure returns (euint64) {
        if (!isInitialized(input1)) {
            input1 = asEuint64(0);
        }
        uint256 unwrappedInput1 = euint64.unwrap(input1);
        bytes memory inputAsBytes = Common.toBytes(unwrappedInput1);
        bytes memory b = FheOps(Precompiles.Fheos).square(Common.EUINT64_TFHE, inputAsBytes);
        uint256 result = Impl.getValue(b);
        return euint64.wrap(result);
    }
    /// @notice Generates a random value of a given type with the given seed, for the provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param uintType the type of the random value to generate
    /// @param seed the seed to use to create a random value from
    /// @param securityZone the security zone to use for the random value
    function random(uint8 uintType, uint64 seed, int32 securityZone) internal pure returns (uint256) {
        bytes memory b = FheOps(Precompiles.Fheos).random(uintType, seed, securityZone);
        return Impl.getValue(b);
    }
    /// @notice Generates a random value of a given type with the given seed
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param uintType the type of the random value to generate
    /// @param seed the seed to use to create a random value from
    function random(uint8 uintType, uint32 seed) internal pure returns (uint256) {
        return random(uintType, seed, 0);
    }
    /// @notice Generates a random value of a given type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param uintType the type of the random value to generate
    function random(uint8 uintType) internal pure returns (uint256) {
        return random(uintType, 0, 0);
    }
    /// @notice Generates a random value of a euint8 type for provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param securityZone the security zone to use for the random value
    function randomEuint8(int32 securityZone) internal pure returns (euint8) {
        uint256 result = random(Common.EUINT8_TFHE, 0, securityZone);
        return euint8.wrap(result);
    }
    /// @notice Generates a random value of a euint8 type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    function randomEuint8() internal pure returns (euint8) {
        return randomEuint8(0);
    }
    /// @notice Generates a random value of a euint16 type for provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param securityZone the security zone to use for the random value
    function randomEuint16(int32 securityZone) internal pure returns (euint16) {
        uint256 result = random(Common.EUINT16_TFHE, 0, securityZone);
        return euint16.wrap(result);
    }
    /// @notice Generates a random value of a euint16 type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    function randomEuint16() internal pure returns (euint16) {
        return randomEuint16(0);
    }
    /// @notice Generates a random value of a euint32 type for provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param securityZone the security zone to use for the random value
    function randomEuint32(int32 securityZone) internal pure returns (euint32) {
        uint256 result = random(Common.EUINT32_TFHE, 0, securityZone);
        return euint32.wrap(result);
    }
    /// @notice Generates a random value of a euint32 type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    function randomEuint32() internal pure returns (euint32) {
        return randomEuint32(0);
    }
    /// @notice Generates a random value of a euint64 type for provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param securityZone the security zone to use for the random value
    function randomEuint64(int32 securityZone) internal pure returns (euint64) {
        uint256 result = random(Common.EUINT64_TFHE, 0, securityZone);
        return euint64.wrap(result);
    }
    /// @notice Generates a random value of a euint64 type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    function randomEuint64() internal pure returns (euint64) {
        return randomEuint64(0);
    }
    /// @notice Generates a random value of a euint128 type for provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param securityZone the security zone to use for the random value
    function randomEuint128(int32 securityZone) internal pure returns (euint128) {
        uint256 result = random(Common.EUINT128_TFHE, 0, securityZone);
        return euint128.wrap(result);
    }
    /// @notice Generates a random value of a euint128 type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    function randomEuint128() internal pure returns (euint128) {
        return randomEuint128(0);
    }
    /// @notice Generates a random value of a euint256 type for provided securityZone
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    /// @param securityZone the security zone to use for the random value
    function randomEuint256(int32 securityZone) internal pure returns (euint256) {
        uint256 result = random(Common.EUINT256_TFHE, 0, securityZone);
        return euint256.wrap(result);
    }
    /// @notice Generates a random value of a euint256 type
    /// @dev Calls the desired precompile and returns the hash of the ciphertext
    function randomEuint256() internal pure returns (euint256) {
        return randomEuint256(0);
    }
    

    // ********** TYPE CASTING ************* //
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an ebool
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEbool(inEbool memory value) internal pure returns (ebool) {
        return FHE.asEbool(value.data, value.securityZone);
    }
    /// @notice Converts a ebool to an euint8
    function asEuint8(ebool value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EBOOL_TFHE, ebool.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Converts a ebool to an euint16
    function asEuint16(ebool value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EBOOL_TFHE, ebool.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Converts a ebool to an euint32
    function asEuint32(ebool value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EBOOL_TFHE, ebool.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Converts a ebool to an euint64
    function asEuint64(ebool value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EBOOL_TFHE, ebool.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Converts a ebool to an euint128
    function asEuint128(ebool value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EBOOL_TFHE, ebool.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Converts a ebool to an euint256
    function asEuint256(ebool value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EBOOL_TFHE, ebool.unwrap(value), Common.EUINT256_TFHE));
    }
    
    /// @notice Converts a euint8 to an ebool
    function asEbool(euint8 value) internal pure returns (ebool) {
        return ne(value, asEuint8(0));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint8
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint8(inEuint8 memory value) internal pure returns (euint8) {
        return FHE.asEuint8(value.data, value.securityZone);
    }
    /// @notice Converts a euint8 to an euint16
    function asEuint16(euint8 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT8_TFHE, euint8.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Converts a euint8 to an euint32
    function asEuint32(euint8 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT8_TFHE, euint8.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Converts a euint8 to an euint64
    function asEuint64(euint8 value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EUINT8_TFHE, euint8.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Converts a euint8 to an euint128
    function asEuint128(euint8 value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EUINT8_TFHE, euint8.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Converts a euint8 to an euint256
    function asEuint256(euint8 value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EUINT8_TFHE, euint8.unwrap(value), Common.EUINT256_TFHE));
    }
    
    /// @notice Converts a euint16 to an ebool
    function asEbool(euint16 value) internal pure returns (ebool) {
        return ne(value, asEuint16(0));
    }
    /// @notice Converts a euint16 to an euint8
    function asEuint8(euint16 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT16_TFHE, euint16.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint16
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint16(inEuint16 memory value) internal pure returns (euint16) {
        return FHE.asEuint16(value.data, value.securityZone);
    }
    /// @notice Converts a euint16 to an euint32
    function asEuint32(euint16 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT16_TFHE, euint16.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Converts a euint16 to an euint64
    function asEuint64(euint16 value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EUINT16_TFHE, euint16.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Converts a euint16 to an euint128
    function asEuint128(euint16 value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EUINT16_TFHE, euint16.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Converts a euint16 to an euint256
    function asEuint256(euint16 value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EUINT16_TFHE, euint16.unwrap(value), Common.EUINT256_TFHE));
    }
    
    /// @notice Converts a euint32 to an ebool
    function asEbool(euint32 value) internal pure returns (ebool) {
        return ne(value, asEuint32(0));
    }
    /// @notice Converts a euint32 to an euint8
    function asEuint8(euint32 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT32_TFHE, euint32.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Converts a euint32 to an euint16
    function asEuint16(euint32 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT32_TFHE, euint32.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint32
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint32(inEuint32 memory value) internal pure returns (euint32) {
        return FHE.asEuint32(value.data, value.securityZone);
    }
    /// @notice Converts a euint32 to an euint64
    function asEuint64(euint32 value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EUINT32_TFHE, euint32.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Converts a euint32 to an euint128
    function asEuint128(euint32 value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EUINT32_TFHE, euint32.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Converts a euint32 to an euint256
    function asEuint256(euint32 value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EUINT32_TFHE, euint32.unwrap(value), Common.EUINT256_TFHE));
    }
    
    /// @notice Converts a euint64 to an ebool
    function asEbool(euint64 value) internal pure returns (ebool) {
        return ne(value, asEuint64(0));
    }
    /// @notice Converts a euint64 to an euint8
    function asEuint8(euint64 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT64_TFHE, euint64.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Converts a euint64 to an euint16
    function asEuint16(euint64 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT64_TFHE, euint64.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Converts a euint64 to an euint32
    function asEuint32(euint64 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT64_TFHE, euint64.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint64
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint64(inEuint64 memory value) internal pure returns (euint64) {
        return FHE.asEuint64(value.data, value.securityZone);
    }
    /// @notice Converts a euint64 to an euint128
    function asEuint128(euint64 value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EUINT64_TFHE, euint64.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Converts a euint64 to an euint256
    function asEuint256(euint64 value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EUINT64_TFHE, euint64.unwrap(value), Common.EUINT256_TFHE));
    }
    
    /// @notice Converts a euint128 to an ebool
    function asEbool(euint128 value) internal pure returns (ebool) {
        return ne(value, asEuint128(0));
    }
    /// @notice Converts a euint128 to an euint8
    function asEuint8(euint128 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT128_TFHE, euint128.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Converts a euint128 to an euint16
    function asEuint16(euint128 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT128_TFHE, euint128.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Converts a euint128 to an euint32
    function asEuint32(euint128 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT128_TFHE, euint128.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Converts a euint128 to an euint64
    function asEuint64(euint128 value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EUINT128_TFHE, euint128.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint128
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint128(inEuint128 memory value) internal pure returns (euint128) {
        return FHE.asEuint128(value.data, value.securityZone);
    }
    /// @notice Converts a euint128 to an euint256
    function asEuint256(euint128 value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EUINT128_TFHE, euint128.unwrap(value), Common.EUINT256_TFHE));
    }
    
    /// @notice Converts a euint256 to an ebool
    function asEbool(euint256 value) internal pure returns (ebool) {
        return ne(value, asEuint256(0));
    }
    /// @notice Converts a euint256 to an euint8
    function asEuint8(euint256 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EUINT256_TFHE, euint256.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Converts a euint256 to an euint16
    function asEuint16(euint256 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EUINT256_TFHE, euint256.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Converts a euint256 to an euint32
    function asEuint32(euint256 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EUINT256_TFHE, euint256.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Converts a euint256 to an euint64
    function asEuint64(euint256 value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EUINT256_TFHE, euint256.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Converts a euint256 to an euint128
    function asEuint128(euint256 value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EUINT256_TFHE, euint256.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint256
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint256(inEuint256 memory value) internal pure returns (euint256) {
        return FHE.asEuint256(value.data, value.securityZone);
    }
    /// @notice Converts a euint256 to an eaddress
    function asEaddress(euint256 value) internal pure returns (eaddress) {
        return eaddress.wrap(Impl.cast(Common.EUINT256_TFHE, euint256.unwrap(value), Common.EADDRESS_TFHE));
    }
    
    /// @notice Converts a eaddress to an ebool
    function asEbool(eaddress value) internal pure returns (ebool) {
        return ne(value, asEaddress(0));
    }
    /// @notice Converts a eaddress to an euint8
    function asEuint8(eaddress value) internal pure returns (euint8) {
        return euint8.wrap(Impl.cast(Common.EADDRESS_TFHE, eaddress.unwrap(value), Common.EUINT8_TFHE));
    }
    /// @notice Converts a eaddress to an euint16
    function asEuint16(eaddress value) internal pure returns (euint16) {
        return euint16.wrap(Impl.cast(Common.EADDRESS_TFHE, eaddress.unwrap(value), Common.EUINT16_TFHE));
    }
    /// @notice Converts a eaddress to an euint32
    function asEuint32(eaddress value) internal pure returns (euint32) {
        return euint32.wrap(Impl.cast(Common.EADDRESS_TFHE, eaddress.unwrap(value), Common.EUINT32_TFHE));
    }
    /// @notice Converts a eaddress to an euint64
    function asEuint64(eaddress value) internal pure returns (euint64) {
        return euint64.wrap(Impl.cast(Common.EADDRESS_TFHE, eaddress.unwrap(value), Common.EUINT64_TFHE));
    }
    /// @notice Converts a eaddress to an euint128
    function asEuint128(eaddress value) internal pure returns (euint128) {
        return euint128.wrap(Impl.cast(Common.EADDRESS_TFHE, eaddress.unwrap(value), Common.EUINT128_TFHE));
    }
    /// @notice Converts a eaddress to an euint256
    function asEuint256(eaddress value) internal pure returns (euint256) {
        return euint256.wrap(Impl.cast(Common.EADDRESS_TFHE, eaddress.unwrap(value), Common.EUINT256_TFHE));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an eaddress
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEaddress(inEaddress memory value) internal pure returns (eaddress) {
        return FHE.asEaddress(value.data, value.securityZone);
    }
    /// @notice Converts a uint256 to an ebool
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEbool(uint256 value) internal pure returns (ebool) {
        return ebool.wrap(Impl.trivialEncrypt(value, Common.EBOOL_TFHE, 0));
    }
    /// @notice Converts a uint256 to an ebool, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEbool(uint256 value, int32 securityZone) internal pure returns (ebool) {
        return ebool.wrap(Impl.trivialEncrypt(value, Common.EBOOL_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an euint8
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint8(uint256 value) internal pure returns (euint8) {
        return euint8.wrap(Impl.trivialEncrypt(value, Common.EUINT8_TFHE, 0));
    }
    /// @notice Converts a uint256 to an euint8, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint8(uint256 value, int32 securityZone) internal pure returns (euint8) {
        return euint8.wrap(Impl.trivialEncrypt(value, Common.EUINT8_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an euint16
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint16(uint256 value) internal pure returns (euint16) {
        return euint16.wrap(Impl.trivialEncrypt(value, Common.EUINT16_TFHE, 0));
    }
    /// @notice Converts a uint256 to an euint16, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint16(uint256 value, int32 securityZone) internal pure returns (euint16) {
        return euint16.wrap(Impl.trivialEncrypt(value, Common.EUINT16_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an euint32
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint32(uint256 value) internal pure returns (euint32) {
        return euint32.wrap(Impl.trivialEncrypt(value, Common.EUINT32_TFHE, 0));
    }
    /// @notice Converts a uint256 to an euint32, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint32(uint256 value, int32 securityZone) internal pure returns (euint32) {
        return euint32.wrap(Impl.trivialEncrypt(value, Common.EUINT32_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an euint64
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint64(uint256 value) internal pure returns (euint64) {
        return euint64.wrap(Impl.trivialEncrypt(value, Common.EUINT64_TFHE, 0));
    }
    /// @notice Converts a uint256 to an euint64, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint64(uint256 value, int32 securityZone) internal pure returns (euint64) {
        return euint64.wrap(Impl.trivialEncrypt(value, Common.EUINT64_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an euint128
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint128(uint256 value) internal pure returns (euint128) {
        return euint128.wrap(Impl.trivialEncrypt(value, Common.EUINT128_TFHE, 0));
    }
    /// @notice Converts a uint256 to an euint128, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint128(uint256 value, int32 securityZone) internal pure returns (euint128) {
        return euint128.wrap(Impl.trivialEncrypt(value, Common.EUINT128_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an euint256
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint256(uint256 value) internal pure returns (euint256) {
        return euint256.wrap(Impl.trivialEncrypt(value, Common.EUINT256_TFHE, 0));
    }
    /// @notice Converts a uint256 to an euint256, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint256(uint256 value, int32 securityZone) internal pure returns (euint256) {
        return euint256.wrap(Impl.trivialEncrypt(value, Common.EUINT256_TFHE, securityZone));
    }
    /// @notice Converts a uint256 to an eaddress
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEaddress(uint256 value) internal pure returns (eaddress) {
        return eaddress.wrap(Impl.trivialEncrypt(value, Common.EADDRESS_TFHE, 0));
    }
    /// @notice Converts a uint256 to an eaddress, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEaddress(uint256 value, int32 securityZone) internal pure returns (eaddress) {
        return eaddress.wrap(Impl.trivialEncrypt(value, Common.EADDRESS_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an ebool
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEbool(bytes memory value, int32 securityZone) internal pure returns (ebool) {
        return ebool.wrap(Impl.verify(value, Common.EBOOL_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint8
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint8(bytes memory value, int32 securityZone) internal pure returns (euint8) {
        return euint8.wrap(Impl.verify(value, Common.EUINT8_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint16
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint16(bytes memory value, int32 securityZone) internal pure returns (euint16) {
        return euint16.wrap(Impl.verify(value, Common.EUINT16_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint32
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint32(bytes memory value, int32 securityZone) internal pure returns (euint32) {
        return euint32.wrap(Impl.verify(value, Common.EUINT32_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint64
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint64(bytes memory value, int32 securityZone) internal pure returns (euint64) {
        return euint64.wrap(Impl.verify(value, Common.EUINT64_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint128
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint128(bytes memory value, int32 securityZone) internal pure returns (euint128) {
        return euint128.wrap(Impl.verify(value, Common.EUINT128_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint256
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEuint256(bytes memory value, int32 securityZone) internal pure returns (euint256) {
        return euint256.wrap(Impl.verify(value, Common.EUINT256_TFHE, securityZone));
    }
    /// @notice Parses input ciphertexts from the user. Converts from encrypted raw bytes to an eaddress
    /// @dev Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key
    /// @return a ciphertext representation of the input
    function asEaddress(bytes memory value, int32 securityZone) internal pure returns (eaddress) {
        return eaddress.wrap(Impl.verify(value, Common.EADDRESS_TFHE, securityZone));
    }
    /// @notice Converts a address to an eaddress
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// Allows for a better user experience when working with eaddresses
    function asEaddress(address value) internal pure returns (eaddress) {
        return eaddress.wrap(Impl.trivialEncrypt(uint256(uint160(value)), Common.EADDRESS_TFHE, 0));
    }
    /// @notice Converts a address to an eaddress, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// Allows for a better user experience when working with eaddresses
    function asEaddress(address value, int32 securityZone) internal pure returns (eaddress) {
        return eaddress.wrap(Impl.trivialEncrypt(uint256(uint160(value)), Common.EADDRESS_TFHE, securityZone));
    }
    /// @notice Converts a plaintext boolean value to a ciphertext ebool
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// @return A ciphertext representation of the input
    function asEbool(bool value) internal pure returns (ebool) {
        uint256 sVal = 0;
        if (value) {
            sVal = 1;
        }
        return asEbool(sVal);
    }
    /// @notice Converts a plaintext boolean value to a ciphertext ebool, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// @return A ciphertext representation of the input
    function asEbool(bool value, int32 securityZone) internal pure returns (ebool) {
        uint256 sVal = 0;
        if (value) {
            sVal = 1;
        }
        return asEbool(sVal, securityZone);
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

using {operatorAddEuint64 as +} for euint64 global;
/// @notice Performs the add operation
function operatorAddEuint64(euint64 lhs, euint64 rhs) pure returns (euint64) {
    return FHE.add(lhs, rhs);
}

using {operatorAddEuint128 as +} for euint128 global;
/// @notice Performs the add operation
function operatorAddEuint128(euint128 lhs, euint128 rhs) pure returns (euint128) {
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

using {operatorSubEuint64 as -} for euint64 global;
/// @notice Performs the sub operation
function operatorSubEuint64(euint64 lhs, euint64 rhs) pure returns (euint64) {
    return FHE.sub(lhs, rhs);
}

using {operatorSubEuint128 as -} for euint128 global;
/// @notice Performs the sub operation
function operatorSubEuint128(euint128 lhs, euint128 rhs) pure returns (euint128) {
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

using {operatorMulEuint64 as *} for euint64 global;
/// @notice Performs the mul operation
function operatorMulEuint64(euint64 lhs, euint64 rhs) pure returns (euint64) {
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

using {operatorOrEuint64 as |} for euint64 global;
/// @notice Performs the or operation
function operatorOrEuint64(euint64 lhs, euint64 rhs) pure returns (euint64) {
    return FHE.or(lhs, rhs);
}

using {operatorOrEuint128 as |} for euint128 global;
/// @notice Performs the or operation
function operatorOrEuint128(euint128 lhs, euint128 rhs) pure returns (euint128) {
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

using {operatorAndEuint64 as &} for euint64 global;
/// @notice Performs the and operation
function operatorAndEuint64(euint64 lhs, euint64 rhs) pure returns (euint64) {
    return FHE.and(lhs, rhs);
}

using {operatorAndEuint128 as &} for euint128 global;
/// @notice Performs the and operation
function operatorAndEuint128(euint128 lhs, euint128 rhs) pure returns (euint128) {
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

using {operatorXorEuint64 as ^} for euint64 global;
/// @notice Performs the xor operation
function operatorXorEuint64(euint64 lhs, euint64 rhs) pure returns (euint64) {
    return FHE.xor(lhs, rhs);
}

using {operatorXorEuint128 as ^} for euint128 global;
/// @notice Performs the xor operation
function operatorXorEuint128(euint128 lhs, euint128 rhs) pure returns (euint128) {
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
    /// @param rhs second input of type ebool
    /// @return the result of the eq
    function eq(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the ne
    function ne(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the not
    function not(ebool lhs) internal pure returns (ebool) {
        return FHE.not(lhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the and
    function and(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the or
    function or(ebool lhs, ebool rhs) internal pure returns (ebool) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
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
    function toU64(ebool value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU128(ebool value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toU256(ebool value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(ebool value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(ebool value, bytes32 publicKey) internal pure returns (SealedBool memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(ebool value) internal pure returns (bool) {
        return FHE.decrypt(value);
    }
    function decrypt(ebool value, bool defaultValue) internal pure returns (bool) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEuint8 for euint8 global;
library BindingsEuint8 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the add
    function add(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the mul
    function mul(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the div
    function div(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.div(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the sub
    function sub(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the eq
    function eq(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the ne
    function ne(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the not
    function not(euint8 lhs) internal pure returns (euint8) {
        return FHE.not(lhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the and
    function and(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the or
    function or(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the xor
    function xor(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the gt
    function gt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the gte
    function gte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the lt
    function lt(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the lte
    function lte(euint8 lhs, euint8 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the rem
    function rem(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.rem(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the max
    function max(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the min
    function min(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the shl
    function shl(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the shr
    function shr(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.shr(lhs, rhs);
    }
    
    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the rol
    function rol(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.rol(lhs, rhs);
    }
    
    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the ror
    function ror(euint8 lhs, euint8 rhs) internal pure returns (euint8) {
        return FHE.ror(lhs, rhs);
    }
    
    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the square
    function square(euint8 lhs) internal pure returns (euint8) {
        return FHE.square(lhs);
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
    function toU64(euint8 value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU128(euint8 value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toU256(euint8 value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(euint8 value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint8 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint8 value) internal pure returns (uint8) {
        return FHE.decrypt(value);
    }
    function decrypt(euint8 value, uint8 defaultValue) internal pure returns (uint8) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEuint16 for euint16 global;
library BindingsEuint16 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the add
    function add(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the mul
    function mul(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the div
    function div(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.div(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the sub
    function sub(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the eq
    function eq(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the ne
    function ne(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the not
    function not(euint16 lhs) internal pure returns (euint16) {
        return FHE.not(lhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the and
    function and(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the or
    function or(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the xor
    function xor(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the gt
    function gt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the gte
    function gte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the lt
    function lt(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the lte
    function lte(euint16 lhs, euint16 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the rem
    function rem(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.rem(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the max
    function max(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the min
    function min(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the shl
    function shl(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the shr
    function shr(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.shr(lhs, rhs);
    }
    
    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the rol
    function rol(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.rol(lhs, rhs);
    }
    
    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the ror
    function ror(euint16 lhs, euint16 rhs) internal pure returns (euint16) {
        return FHE.ror(lhs, rhs);
    }
    
    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the square
    function square(euint16 lhs) internal pure returns (euint16) {
        return FHE.square(lhs);
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
    function toU64(euint16 value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU128(euint16 value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toU256(euint16 value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(euint16 value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint16 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint16 value) internal pure returns (uint16) {
        return FHE.decrypt(value);
    }
    function decrypt(euint16 value, uint16 defaultValue) internal pure returns (uint16) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEuint32 for euint32 global;
library BindingsEuint32 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the add
    function add(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the mul
    function mul(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the div
    function div(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.div(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the sub
    function sub(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the eq
    function eq(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the ne
    function ne(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the not
    function not(euint32 lhs) internal pure returns (euint32) {
        return FHE.not(lhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the and
    function and(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the or
    function or(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the xor
    function xor(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the gt
    function gt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the gte
    function gte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the lt
    function lt(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the lte
    function lte(euint32 lhs, euint32 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the rem
    function rem(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.rem(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the max
    function max(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the min
    function min(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the shl
    function shl(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the shr
    function shr(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.shr(lhs, rhs);
    }
    
    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the rol
    function rol(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.rol(lhs, rhs);
    }
    
    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the ror
    function ror(euint32 lhs, euint32 rhs) internal pure returns (euint32) {
        return FHE.ror(lhs, rhs);
    }
    
    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the square
    function square(euint32 lhs) internal pure returns (euint32) {
        return FHE.square(lhs);
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
    function toU64(euint32 value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU128(euint32 value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toU256(euint32 value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(euint32 value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint32 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint32 value) internal pure returns (uint32) {
        return FHE.decrypt(value);
    }
    function decrypt(euint32 value, uint32 defaultValue) internal pure returns (uint32) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEuint64 for euint64 global;
library BindingsEuint64 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the add
    function add(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the mul
    function mul(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.mul(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the sub
    function sub(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the eq
    function eq(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the ne
    function ne(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @return the result of the not
    function not(euint64 lhs) internal pure returns (euint64) {
        return FHE.not(lhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the and
    function and(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the or
    function or(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the xor
    function xor(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the gt
    function gt(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the gte
    function gte(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the lt
    function lt(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the lte
    function lte(euint64 lhs, euint64 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the max
    function max(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the min
    function min(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the shl
    function shl(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the shr
    function shr(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.shr(lhs, rhs);
    }
    
    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the rol
    function rol(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.rol(lhs, rhs);
    }
    
    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the ror
    function ror(euint64 lhs, euint64 rhs) internal pure returns (euint64) {
        return FHE.ror(lhs, rhs);
    }
    
    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @return the result of the square
    function square(euint64 lhs) internal pure returns (euint64) {
        return FHE.square(lhs);
    }
    function toBool(euint64 value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU8(euint64 value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU16(euint64 value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function toU32(euint64 value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function toU128(euint64 value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toU256(euint64 value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(euint64 value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint64 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint64 value) internal pure returns (uint64) {
        return FHE.decrypt(value);
    }
    function decrypt(euint64 value, uint64 defaultValue) internal pure returns (uint64) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEuint128 for euint128 global;
library BindingsEuint128 {
    
    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the add
    function add(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.add(lhs, rhs);
    }
    
    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the sub
    function sub(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.sub(lhs, rhs);
    }
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the eq
    function eq(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the ne
    function ne(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    
    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @return the result of the not
    function not(euint128 lhs) internal pure returns (euint128) {
        return FHE.not(lhs);
    }
    
    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the and
    function and(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.and(lhs, rhs);
    }
    
    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the or
    function or(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.or(lhs, rhs);
    }
    
    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the xor
    function xor(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.xor(lhs, rhs);
    }
    
    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the gt
    function gt(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        return FHE.gt(lhs, rhs);
    }
    
    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the gte
    function gte(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        return FHE.gte(lhs, rhs);
    }
    
    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the lt
    function lt(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        return FHE.lt(lhs, rhs);
    }
    
    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the lte
    function lte(euint128 lhs, euint128 rhs) internal pure returns (ebool) {
        return FHE.lte(lhs, rhs);
    }
    
    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the max
    function max(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.max(lhs, rhs);
    }
    
    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the min
    function min(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.min(lhs, rhs);
    }
    
    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the shl
    function shl(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.shl(lhs, rhs);
    }
    
    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the shr
    function shr(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.shr(lhs, rhs);
    }
    
    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the rol
    function rol(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.rol(lhs, rhs);
    }
    
    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the ror
    function ror(euint128 lhs, euint128 rhs) internal pure returns (euint128) {
        return FHE.ror(lhs, rhs);
    }
    function toBool(euint128 value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU8(euint128 value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU16(euint128 value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function toU32(euint128 value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function toU64(euint128 value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU256(euint128 value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(euint128 value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint128 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint128 value) internal pure returns (uint128) {
        return FHE.decrypt(value);
    }
    function decrypt(euint128 value, uint128 defaultValue) internal pure returns (uint128) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEuint256 for euint256 global;
library BindingsEuint256 {
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint256
    /// @param rhs second input of type euint256
    /// @return the result of the eq
    function eq(euint256 lhs, euint256 rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint256
    /// @param rhs second input of type euint256
    /// @return the result of the ne
    function ne(euint256 lhs, euint256 rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    function toBool(euint256 value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU8(euint256 value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU16(euint256 value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function toU32(euint256 value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function toU64(euint256 value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU128(euint256 value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toEaddress(euint256 value) internal pure returns (eaddress) {
        return FHE.asEaddress(value);
    }
    function seal(euint256 value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint256 value, bytes32 publicKey) internal pure returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint256 value) internal pure returns (uint256) {
        return FHE.decrypt(value);
    }
    function decrypt(euint256 value, uint256 defaultValue) internal pure returns (uint256) {
        return FHE.decrypt(value, defaultValue);
    }
}

using BindingsEaddress for eaddress global;
library BindingsEaddress {
    
    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type eaddress
    /// @param rhs second input of type eaddress
    /// @return the result of the eq
    function eq(eaddress lhs, eaddress rhs) internal pure returns (ebool) {
        return FHE.eq(lhs, rhs);
    }
    
    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type eaddress
    /// @param rhs second input of type eaddress
    /// @return the result of the ne
    function ne(eaddress lhs, eaddress rhs) internal pure returns (ebool) {
        return FHE.ne(lhs, rhs);
    }
    function toBool(eaddress value) internal pure returns (ebool) {
        return FHE.asEbool(value);
    }
    function toU8(eaddress value) internal pure returns (euint8) {
        return FHE.asEuint8(value);
    }
    function toU16(eaddress value) internal pure returns (euint16) {
        return FHE.asEuint16(value);
    }
    function toU32(eaddress value) internal pure returns (euint32) {
        return FHE.asEuint32(value);
    }
    function toU64(eaddress value) internal pure returns (euint64) {
        return FHE.asEuint64(value);
    }
    function toU128(eaddress value) internal pure returns (euint128) {
        return FHE.asEuint128(value);
    }
    function toU256(eaddress value) internal pure returns (euint256) {
        return FHE.asEuint256(value);
    }
    function seal(eaddress value, bytes32 publicKey) internal pure returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(eaddress value, bytes32 publicKey) internal pure returns (SealedAddress memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(eaddress value) internal pure returns (address) {
        return FHE.decrypt(value);
    }
    function decrypt(eaddress value, address defaultValue) internal pure returns (address) {
        return FHE.decrypt(value, defaultValue);
    }
}