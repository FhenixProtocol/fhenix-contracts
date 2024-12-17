// SPDX-License-Identifier: BSD-3-Clause-Clear
// solhint-disable one-contract-per-file

pragma solidity >=0.8.19 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./CoproDefs.sol";

struct ebool {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct euint8 {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct euint16 {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct euint32 {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct euint64 {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct euint128 {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct euint256 {
    bool     isTriviallyEncrypted;
    uint8    uintType;
    int32    securityZone;
    uint256  hash;
}

struct eaddress {
    bool     isTriviallyEncrypted;
    uint32   uintType;
    int32    securityZone;
    uint256  hash;
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

// ================================
// \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/
// TODO : CHANGE ME AFTER DEPLOYING
// /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\
// ================================
//solhint-disable const-name-snakecase
address constant TASK_MANAGER_ADDRESS = 0xbeb4eF1fcEa618C6ca38e3828B00f8D481EC2CC2;

library Common {
    // Default value for temp hash calculation in unary operations
    string private constant DEFAULT_VALUE = "0";
    
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

    function bytesToUint256(bytes memory b) internal pure returns (uint256) {
        require(b.length == 32, string(abi.encodePacked("Input bytes length must be 32, but got ", Strings.toString(b.length))));

        uint256 result;
        assembly {
            result := mload(add(b, 32))
        }
        return result;
    }

    function hexCharToUint8(bytes1 char) internal pure returns (uint8) {
        if (char >= "0" && char <= "9") {
            return uint8(char) - uint8(bytes1("0"));
        } else if (char >= "a" && char <= "f") {
            return uint8(char) - uint8(bytes1("a")) + 10;
        } else if (char >= "A" && char <= "F") {
            return uint8(char) - uint8(bytes1("A")) + 10;
        } else {
            revert("Invalid hex character");
        }
    }

    function hexStringToUint(string memory hexString) internal pure returns (uint8) {
        require(bytes(hexString).length == 2, "Invalid hex string length");

        uint8 value = 0;
        for (uint8 i = 0; i < 2; i++) {
            value = value * 16 + hexCharToUint8(bytes(hexString)[i]);
        }

        return value;
    }

    function hexStringToBytes32(string memory hexString) internal pure returns (bytes memory) {
        bytes memory hexBytes = bytes(hexString);
        // Ensure the string has the correct length (64 characters for 32 bytes)
        require(hexBytes.length == 64, "Invalid hex string length");

        // Iterate every 2 bytes in string, consider them as 1 byte
        bytes memory bb = new bytes(32);
        string memory l = "";
        for (uint i = 0; i < 32; i++) {
            l = string(abi.encodePacked("", hexBytes[i * 2], hexBytes[i * 2 + 1]));
            bb[i] = bytes1(hexStringToUint(l));
        }

        return bb;
    }

    function bytesArrayToString(bytes memory a) internal pure returns (string memory) {
        string memory b = "[";
        for (uint i = 0; i < a.length; i++) {
            b = string(abi.encodePacked(b, Strings.toHexString(uint8(a[i])), " "));
        }

        b = string(abi.encodePacked(b, "]"));
        return b;
    }

    function functionCodeToBytes1(string memory functionCode) internal pure returns (bytes memory) {
        // Convert the hex string to bytes
        bytes memory result = new bytes(1);
        assembly {
            result := mload(add(functionCode, 1)) // Load the bytes directly from memory
        }

        return result;
    }

    function bytesToHexString(bytes memory buffer) internal pure returns (string memory) {
        // Each byte takes 2 characters
        bytes memory hexChars = new bytes(buffer.length * 2);

        for(uint i = 0; i < buffer.length; i++) {
            uint8 value = uint8(buffer[i]);
            hexChars[i * 2] = byteToChar(value / 16);
            hexChars[i * 2 + 1] = byteToChar(value % 16);
        }

        return string(hexChars);
    }

    // Helper function for bytesToHexString
    function byteToChar(uint8 value) internal pure returns (bytes1) {
        if (value < 10) {
            return bytes1(uint8(48 + value)); // 0-9
        } else {
            return bytes1(uint8(87 + value)); // a-f
        }
    }

    function uint256ToBytes32(uint256 value) internal pure returns (bytes memory) {
        bytes memory result = new bytes(32);
        assembly {
            mstore(add(result, 32), value)
        }
        return result;
    }

    function convertInt32ToUint256(int32 value) internal pure returns (uint256) {
        require(value >= 0, "Value must be non-negative");
        return uint256(uint32(value));
    }

    function keyAsEbool(CiphertextKey memory key) internal pure returns (ebool memory) {
        require(key.uintType == Utils.EBOOL_TFHE, "Key type mismatch");
        return ebool({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EBOOL_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEuint8(CiphertextKey memory key) internal pure returns (euint8 memory) {
        require(key.uintType == Utils.EUINT8_TFHE, "Key type mismatch");
        return euint8({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EUINT8_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEuint16(CiphertextKey memory key) internal pure returns (euint16 memory) {
        require(key.uintType == Utils.EUINT16_TFHE, "Key type mismatch");
        return euint16({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EUINT16_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEuint32(CiphertextKey memory key) internal pure returns (euint32 memory) {
        require(key.uintType == Utils.EUINT32_TFHE, "Key type mismatch");
        return euint32({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EUINT32_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEuint64(CiphertextKey memory key) internal pure returns (euint64 memory) {
        require(key.uintType == Utils.EUINT64_TFHE, "Key type mismatch");
        return euint64({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EUINT64_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEuint128(CiphertextKey memory key) internal pure returns (euint128 memory) {
        require(key.uintType == Utils.EUINT128_TFHE, "Key type mismatch");
        return euint128({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EUINT128_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEuint256(CiphertextKey memory key) internal pure returns (euint256 memory) {
        require(key.uintType == Utils.EUINT256_TFHE, "Key type mismatch");
        return euint256({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EUINT256_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function keyAsEaddress(CiphertextKey memory key) internal pure returns (eaddress memory) {
        require(key.uintType == Utils.EADDRESS_TFHE, "Key type mismatch");
        return eaddress({
            isTriviallyEncrypted: key.isTriviallyEncrypted,
            uintType: Utils.EADDRESS_TFHE,
            securityZone: key.securityZone,
            hash: key.hash
        });
    }

    function eboolAsKey(ebool memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EBOOL_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function euint8AsKey(euint8 memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EUINT8_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function euint16AsKey(euint16 memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EUINT16_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function euint32AsKey(euint32 memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EUINT32_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function euint64AsKey(euint64 memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EUINT64_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function euint128AsKey(euint128 memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EUINT128_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function euint256AsKey(euint256 memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EUINT256_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function eaddressAsKey(eaddress memory value) internal pure returns (CiphertextKey memory) {
        return CiphertextKey({
            isTriviallyEncrypted: value.isTriviallyEncrypted,
            uintType: Utils.EADDRESS_TFHE,
            securityZone: value.securityZone,
            hash: value.hash
        });
    }

    function isInitialized(uint256 hash) internal pure returns (bool) {
        return hash != 0;
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(ebool memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint8 memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint16 memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint32 memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint64 memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint128 memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    // Return true if the encrypted integer is initialized and false otherwise.
    function isInitialized(euint256 memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }

    function isInitialized(eaddress memory v) internal pure returns (bool) {
        return isInitialized(v.hash);
    }


    function getValue(bytes memory a) internal pure returns (uint256 value) {
        assembly {
            value := mload(add(a, 0x20))
        }
    }

    function createCiphertextKeyInputs(CiphertextKey memory input1) internal pure returns (CiphertextKey[] memory) {
        CiphertextKey[] memory inputs = new CiphertextKey[](1);
        inputs[0] = input1;
        return inputs;
    }

    function createCiphertextKeyInputs(CiphertextKey memory input1, CiphertextKey memory input2) internal pure returns (CiphertextKey[] memory) {
        CiphertextKey[] memory inputs = new CiphertextKey[](2);
        inputs[0] = input1;
        inputs[1] = input2;
        return inputs;
    }

    function createCiphertextKeyInputs(CiphertextKey memory input1, CiphertextKey memory input2, CiphertextKey memory input3) internal pure returns (CiphertextKey[] memory) {
        CiphertextKey[] memory inputs = new CiphertextKey[](3);
        inputs[0] = input1;
        inputs[1] = input2;
        inputs[2] = input3;
        return inputs;
    }

    function createUint256Inputs(uint256 input1) internal pure returns (uint256[] memory) {
        uint256[] memory inputs = new uint256[](1);
        inputs[0] = input1;
        return inputs;
    }

    function createUint256Inputs(uint256 input1, uint256 input2) internal pure returns (uint256[] memory) {
        uint256[] memory inputs = new uint256[](2);
        inputs[0] = input1;
        inputs[1] = input2;
        return inputs;
    }

    function createUint256Inputs(uint256 input1, uint256 input2, uint256 input3) internal pure returns (uint256[] memory) {
        uint256[] memory inputs = new uint256[](3);
        inputs[0] = input1;
        inputs[1] = input2;
        inputs[2] = input3;
        return inputs;
    }
}

library Impl {
    function trivialEncrypt(uint256 value, uint8 toType, int32 securityZone) internal returns (CiphertextKey memory) {
        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(toType, securityZone, FunctionId.trivialEncrypt, new CiphertextKey[](0), Common.createUint256Inputs(value, toType, Common.convertInt32ToUint256(securityZone)));
    }

    function cast(CiphertextKey memory key, uint8 toType) internal returns (CiphertextKey memory) {
        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(toType, key.securityZone, FunctionId.cast, Common.createCiphertextKeyInputs(key), Common.createUint256Inputs(toType));
    }

    function select(ebool memory control, CiphertextKey memory ifTrue, CiphertextKey memory ifFalse) internal returns (CiphertextKey memory result) {
        require(ifTrue.uintType == ifFalse.uintType, "Mismatched types");
        require(ifTrue.securityZone == ifFalse.securityZone, "Mismatched security zones");

        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(ifTrue.uintType,
            ifTrue.securityZone,
            FunctionId.select,
            Common.createCiphertextKeyInputs(Common.eboolAsKey(control), ifTrue, ifFalse),
            new uint256[](0));
    }

    function mathOp(CiphertextKey memory lhs, CiphertextKey memory rhs, FunctionId functionId) internal returns (CiphertextKey memory) {
        require(lhs.uintType == rhs.uintType, "Mismatched types");
        require(lhs.securityZone == rhs.securityZone, "Mismatched security zones");

        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(lhs.uintType, lhs.securityZone, functionId, Common.createCiphertextKeyInputs(lhs, rhs), new uint256[](0));
    }

    function sealOutput(CiphertextKey memory value, bytes32 publicKey) internal returns (string memory) {
        ITaskManager(TASK_MANAGER_ADDRESS).createSealOutputTask(value, publicKey);
        return Common.bytesToHexString(abi.encodePacked(bytes32(value.hash)));
    }

    function decrypt(CiphertextKey memory input) internal returns (CiphertextKey memory) {
        ITaskManager(TASK_MANAGER_ADDRESS).createDecryptTask(input);
        return input;
    }

    function not(CiphertextKey memory input) internal returns (CiphertextKey memory) {
        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(input.uintType, input.securityZone, FunctionId.not, Common.createCiphertextKeyInputs(input), new uint256[](0));
    }

    function square(CiphertextKey memory input) internal returns (CiphertextKey memory) {
        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(input.uintType, input.securityZone, FunctionId.square, Common.createCiphertextKeyInputs(input), new uint256[](0));
    }

    /// @notice Generates a random value of a given type with the given seed, for the provided securityZone
    /// @dev Calls the desired function
    /// @param uintType the type of the random value to generate
    /// @param seed the seed to use to create a random value from
    /// @param securityZone the security zone to use for the random value
    function random(uint8 uintType, uint64 seed, int32 securityZone) internal returns (CiphertextKey memory) {
        return ITaskManager(TASK_MANAGER_ADDRESS).createTask(uintType, securityZone, FunctionId.random, new CiphertextKey[](0), Common.createUint256Inputs(seed, Common.convertInt32ToUint256(securityZone)));
    }

    /// @notice Generates a random value of a given type with the given seed
    /// @dev Calls the desired function
    /// @param uintType the type of the random value to generate
    /// @param seed the seed to use to create a random value from
    function random(uint8 uintType, uint32 seed) internal returns (CiphertextKey memory) {
        return random(uintType, seed, 0);
    }

    /// @notice Generates a random value of a given type
    /// @dev Calls the desired function
    /// @param uintType the type of the random value to generate
    function random(uint8 uintType) internal returns (CiphertextKey memory) {
        return random(uintType, 0, 0);
    }

}

library FHE {
    /// @notice This function performs the add async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.add));
    }

    /// @notice This function performs the add async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.add));
    }

    /// @notice This function performs the add async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.add));
    }

    /// @notice This function performs the add async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.add));
    }

    /// @notice This function performs the add async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.add));
    }

    /// @notice This function performs the add async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function add(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.add));
    }

    /// @notice This function performs the lte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.lte));
    }

    /// @notice This function performs the lte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.lte));
    }

    /// @notice This function performs the lte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.lte));
    }

    /// @notice This function performs the lte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.lte));
    }

    /// @notice This function performs the lte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.lte));
    }

    /// @notice This function performs the lte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lte(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.lte));
    }

    /// @notice This function performs the sub async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.sub));
    }

    /// @notice This function performs the sub async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.sub));
    }

    /// @notice This function performs the sub async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.sub));
    }

    /// @notice This function performs the sub async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.sub));
    }

    /// @notice This function performs the sub async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.sub));
    }

    /// @notice This function performs the sub async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function sub(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.sub));
    }

    /// @notice This function performs the mul async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.mul));
    }

    /// @notice This function performs the mul async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.mul));
    }

    /// @notice This function performs the mul async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.mul));
    }

    /// @notice This function performs the mul async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.mul));
    }

    /// @notice This function performs the mul async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.mul));
    }

    /// @notice This function performs the mul async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function mul(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.mul));
    }

    /// @notice This function performs the lt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.lt));
    }

    /// @notice This function performs the lt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.lt));
    }

    /// @notice This function performs the lt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.lt));
    }

    /// @notice This function performs the lt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.lt));
    }

    /// @notice This function performs the lt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.lt));
    }

    /// @notice This function performs the lt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function lt(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.lt));
    }

    /// @notice This function performs the div async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.div));
    }

    /// @notice This function performs the div async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.div));
    }

    /// @notice This function performs the div async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.div));
    }

    /// @notice This function performs the div async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.div));
    }

    /// @notice This function performs the div async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.div));
    }

    /// @notice This function performs the div async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function div(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.div));
    }

    /// @notice This function performs the gt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.gt));
    }

    /// @notice This function performs the gt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.gt));
    }

    /// @notice This function performs the gt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.gt));
    }

    /// @notice This function performs the gt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.gt));
    }

    /// @notice This function performs the gt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.gt));
    }

    /// @notice This function performs the gt async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gt(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.gt));
    }

    /// @notice This function performs the gte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.gte));
    }

    /// @notice This function performs the gte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.gte));
    }

    /// @notice This function performs the gte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.gte));
    }

    /// @notice This function performs the gte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.gte));
    }

    /// @notice This function performs the gte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.gte));
    }

    /// @notice This function performs the gte async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function gte(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.gte));
    }

    /// @notice This function performs the rem async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.rem));
    }

    /// @notice This function performs the rem async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.rem));
    }

    /// @notice This function performs the rem async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.rem));
    }

    /// @notice This function performs the rem async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.rem));
    }

    /// @notice This function performs the rem async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.rem));
    }

    /// @notice This function performs the rem async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rem(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.rem));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEbool(true);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEbool(true);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eboolAsKey(lhs), Common.eboolAsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the and async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function and(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.and));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEbool(true);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEbool(true);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eboolAsKey(lhs), Common.eboolAsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the or async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function or(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.or));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEbool(true);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEbool(true);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eboolAsKey(lhs), Common.eboolAsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the xor async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function xor(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.xor));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEbool(true);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEbool(true);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eboolAsKey(lhs), Common.eboolAsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the eq async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function eq(eaddress memory lhs, eaddress memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEaddress(address(0));
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEaddress(address(0));
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eaddressAsKey(lhs), Common.eaddressAsKey(rhs), FunctionId.eq));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEbool(true);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEbool(true);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eboolAsKey(lhs), Common.eboolAsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEbool(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the ne async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ne(eaddress memory lhs, eaddress memory rhs) internal returns (ebool memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEaddress(address(0));
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEaddress(address(0));
        }

        return Common.keyAsEbool(Impl.mathOp(Common.eaddressAsKey(lhs), Common.eaddressAsKey(rhs), FunctionId.ne));
    }

    /// @notice This function performs the min async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.min));
    }

    /// @notice This function performs the min async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.min));
    }

    /// @notice This function performs the min async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.min));
    }

    /// @notice This function performs the min async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.min));
    }

    /// @notice This function performs the min async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.min));
    }

    /// @notice This function performs the min async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function min(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.min));
    }

    /// @notice This function performs the max async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.max));
    }

    /// @notice This function performs the max async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.max));
    }

    /// @notice This function performs the max async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.max));
    }

    /// @notice This function performs the max async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.max));
    }

    /// @notice This function performs the max async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.max));
    }

    /// @notice This function performs the max async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function max(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.max));
    }

    /// @notice This function performs the shl async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.shl));
    }

    /// @notice This function performs the shl async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.shl));
    }

    /// @notice This function performs the shl async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.shl));
    }

    /// @notice This function performs the shl async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.shl));
    }

    /// @notice This function performs the shl async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.shl));
    }

    /// @notice This function performs the shl async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shl(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.shl));
    }

    /// @notice This function performs the shr async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.shr));
    }

    /// @notice This function performs the shr async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.shr));
    }

    /// @notice This function performs the shr async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.shr));
    }

    /// @notice This function performs the shr async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.shr));
    }

    /// @notice This function performs the shr async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.shr));
    }

    /// @notice This function performs the shr async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function shr(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.shr));
    }

    /// @notice This function performs the rol async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.rol));
    }

    /// @notice This function performs the rol async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.rol));
    }

    /// @notice This function performs the rol async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.rol));
    }

    /// @notice This function performs the rol async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.rol));
    }

    /// @notice This function performs the rol async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.rol));
    }

    /// @notice This function performs the rol async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function rol(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.rol));
    }

    /// @notice This function performs the ror async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint8(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.mathOp(Common.euint8AsKey(lhs), Common.euint8AsKey(rhs), FunctionId.ror));
    }

    /// @notice This function performs the ror async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint16(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.mathOp(Common.euint16AsKey(lhs), Common.euint16AsKey(rhs), FunctionId.ror));
    }

    /// @notice This function performs the ror async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint32(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.mathOp(Common.euint32AsKey(lhs), Common.euint32AsKey(rhs), FunctionId.ror));
    }

    /// @notice This function performs the ror async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint64(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.mathOp(Common.euint64AsKey(lhs), Common.euint64AsKey(rhs), FunctionId.ror));
    }

    /// @notice This function performs the ror async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint128(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.mathOp(Common.euint128AsKey(lhs), Common.euint128AsKey(rhs), FunctionId.ror));
    }

    /// @notice This function performs the ror async operation
    /// @dev It verifies that the value matches a valid ciphertext
    /// @param lhs The first input
    /// @param rhs The second input
    /// @return The result of the operation
    function ror(euint256 memory lhs, euint256 memory rhs) internal returns (euint256 memory) {
        if (!Common.isInitialized(lhs)) {
            lhs = asEuint256(0);
        }
        if (!Common.isInitialized(rhs)) {
            lhs = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.mathOp(Common.euint256AsKey(lhs), Common.euint256AsKey(rhs), FunctionId.ror));
    }

    /// @notice performs the sealoutput async function on a ebool ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(ebool memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEbool(false);
        }

        return Impl.sealOutput(Common.eboolAsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a euint8 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint8 memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEuint8(0);
        }

        return Impl.sealOutput(Common.euint8AsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a euint16 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint16 memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEuint16(0);
        }

        return Impl.sealOutput(Common.euint16AsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a euint32 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint32 memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEuint32(0);
        }

        return Impl.sealOutput(Common.euint32AsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a euint64 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint64 memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEuint64(0);
        }

        return Impl.sealOutput(Common.euint64AsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a euint128 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint128 memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEuint128(0);
        }

        return Impl.sealOutput(Common.euint128AsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a euint256 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(euint256 memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEuint256(0);
        }

        return Impl.sealOutput(Common.euint256AsKey(value), publicKey);
    }
    /// @notice performs the sealoutput async function on a eaddress ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return Plaintext input, sealed for the owner of `publicKey`
    function sealoutput(eaddress memory value, bytes32 publicKey) internal returns (string memory) {
        if (!Common.isInitialized(value)) {
            value = asEaddress(address(0));
        }

        return Impl.sealOutput(Common.eaddressAsKey(value), publicKey);
    }
    /// @notice performs the sealoutputTyped async function on a ebool ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedBool({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EBOOL_TFHE })
    function sealoutputTyped(ebool memory value, bytes32 publicKey) internal returns (SealedBool memory) {
        return SealedBool({ data: sealoutput(value, publicKey), utype: Utils.EBOOL_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a euint8 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EUINT8_TFHE })
    function sealoutputTyped(euint8 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Utils.EUINT8_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a euint16 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EUINT16_TFHE })
    function sealoutputTyped(euint16 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Utils.EUINT16_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a euint32 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EUINT32_TFHE })
    function sealoutputTyped(euint32 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Utils.EUINT32_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a euint64 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EUINT64_TFHE })
    function sealoutputTyped(euint64 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Utils.EUINT64_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a euint128 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EUINT128_TFHE })
    function sealoutputTyped(euint128 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Utils.EUINT128_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a euint256 ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedUint({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EUINT256_TFHE })
    function sealoutputTyped(euint256 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return SealedUint({ data: sealoutput(value, publicKey), utype: Utils.EUINT256_TFHE });
    }
    /// @notice performs the sealoutputTyped async function on a eaddress ciphertext. This operation returns the plaintext value, sealed for the public key provided
    /// @param value Ciphertext to decrypt and seal
    /// @param publicKey Public Key that will receive the sealed plaintext
    /// @return SealedAddress({ data: Plaintext input, sealed for the owner of `publicKey`, utype: Utils.EADDRESS_TFHE })
    function sealoutputTyped(eaddress memory value, bytes32 publicKey) internal returns (SealedAddress memory) {
        return SealedAddress({ data: sealoutput(value, publicKey), utype: Utils.EADDRESS_TFHE });
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(ebool memory input1) internal returns (ebool memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }

        return Common.keyAsEbool(Impl.decrypt(Common.eboolAsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(euint8 memory input1) internal returns (euint8 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.decrypt(Common.euint8AsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(euint16 memory input1) internal returns (euint16 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.decrypt(Common.euint16AsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(euint32 memory input1) internal returns (euint32 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.decrypt(Common.euint32AsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(euint64 memory input1) internal returns (euint64 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.decrypt(Common.euint64AsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(euint128 memory input1) internal returns (euint128 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.decrypt(Common.euint128AsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(euint256 memory input1) internal returns (euint256 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.decrypt(Common.euint256AsKey(input1)));
    }
    /// @notice Performs the async decrypt operation on a ciphertext
    /// @dev The decrypted output should be asynchronously handled by the IAsyncFHEReceiver implementation
    /// @param input1 the input ciphertext
    /// @return the input ciphertext
    function decrypt(eaddress memory input1) internal returns (eaddress memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEaddress(address(0));
        }

        return Common.keyAsEaddress(Impl.decrypt(Common.eaddressAsKey(input1)));
    }

    function select(ebool memory input1, ebool memory input2, ebool memory input3) internal returns (ebool memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEbool(false);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEbool(false);
        }

        return Common.keyAsEbool(Impl.select(input1, Common.eboolAsKey(input2), Common.eboolAsKey(input3)));
    }

    function select(ebool memory input1, euint8 memory input2, euint8 memory input3) internal returns (euint8 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEuint8(0);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.select(input1, Common.euint8AsKey(input2), Common.euint8AsKey(input3)));
    }

    function select(ebool memory input1, euint16 memory input2, euint16 memory input3) internal returns (euint16 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEuint16(0);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.select(input1, Common.euint16AsKey(input2), Common.euint16AsKey(input3)));
    }

    function select(ebool memory input1, euint32 memory input2, euint32 memory input3) internal returns (euint32 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEuint32(0);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.select(input1, Common.euint32AsKey(input2), Common.euint32AsKey(input3)));
    }

    function select(ebool memory input1, euint64 memory input2, euint64 memory input3) internal returns (euint64 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEuint64(0);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.select(input1, Common.euint64AsKey(input2), Common.euint64AsKey(input3)));
    }

    function select(ebool memory input1, euint128 memory input2, euint128 memory input3) internal returns (euint128 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEuint128(0);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.select(input1, Common.euint128AsKey(input2), Common.euint128AsKey(input3)));
    }

    function select(ebool memory input1, euint256 memory input2, euint256 memory input3) internal returns (euint256 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEuint256(0);
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.select(input1, Common.euint256AsKey(input2), Common.euint256AsKey(input3)));
    }

    function select(ebool memory input1, eaddress memory input2, eaddress memory input3) internal returns (eaddress memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }
        if (!Common.isInitialized(input2)) {
            input2 = asEaddress(address(0));
        }
        if (!Common.isInitialized(input3)) {
            input3 = asEaddress(address(0));
        }

        return Common.keyAsEaddress(Impl.select(input1, Common.eaddressAsKey(input2), Common.eaddressAsKey(input3)));
    }

    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function not(ebool memory input1) internal returns (ebool memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEbool(false);
        }

        return Common.keyAsEbool(Impl.not(Common.eboolAsKey(input1)));
    }

    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function not(euint8 memory input1) internal returns (euint8 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.not(Common.euint8AsKey(input1)));
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function not(euint16 memory input1) internal returns (euint16 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.not(Common.euint16AsKey(input1)));
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function not(euint32 memory input1) internal returns (euint32 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.not(Common.euint32AsKey(input1)));
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function not(euint64 memory input1) internal returns (euint64 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.not(Common.euint64AsKey(input1)));
    }
    /// @notice Performs the not operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function not(euint128 memory input1) internal returns (euint128 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.not(Common.euint128AsKey(input1)));
    }

    function not(euint256 memory input1) internal returns (euint256 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.not(Common.euint256AsKey(input1)));
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function square(euint8 memory input1) internal returns (euint8 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint8(0);
        }

        return Common.keyAsEuint8(Impl.square(Common.euint8AsKey(input1)));
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function square(euint16 memory input1) internal returns (euint16 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint16(0);
        }

        return Common.keyAsEuint16(Impl.square(Common.euint16AsKey(input1)));
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function square(euint32 memory input1) internal returns (euint32 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint32(0);
        }

        return Common.keyAsEuint32(Impl.square(Common.euint32AsKey(input1)));
    }
    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function square(euint64 memory input1) internal returns (euint64 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint64(0);
        }

        return Common.keyAsEuint64(Impl.square(Common.euint64AsKey(input1)));
    }

    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function square(euint128 memory input1) internal returns (euint128 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint128(0);
        }

        return Common.keyAsEuint128(Impl.square(Common.euint128AsKey(input1)));
    }

    /// @notice Performs the square operation on a ciphertext
    /// @dev Verifies that the input value matches a valid ciphertext.
    /// @param input1 the input ciphertext
    function square(euint256 memory input1) internal returns (euint256 memory) {
        if (!Common.isInitialized(input1)) {
            input1 = asEuint256(0);
        }

        return Common.keyAsEuint256(Impl.square(Common.euint256AsKey(input1)));
    }

    /// @notice Generates a random value of a euint8 type for provided securityZone
    /// @dev Calls the desired function
    /// @param securityZone the security zone to use for the random value
    function randomEuint8(int32 securityZone) internal returns (euint8 memory) {
        CiphertextKey memory ctKey = Impl.random(Utils.EUINT8_TFHE, 0, securityZone);
        return Common.keyAsEuint8(ctKey);
    }
    /// @notice Generates a random value of a euint8 type
    /// @dev Calls the desired function
    function randomEuint8() internal returns (euint8 memory) {
        return randomEuint8(0);
    }
    /// @notice Generates a random value of a euint16 type for provided securityZone
    /// @dev Calls the desired function
    /// @param securityZone the security zone to use for the random value
    function randomEuint16(int32 securityZone) internal returns (euint16 memory) {
        CiphertextKey memory ctKey = Impl.random(Utils.EUINT16_TFHE, 0, securityZone);
        return Common.keyAsEuint16(ctKey);
    }
    /// @notice Generates a random value of a euint16 type
    /// @dev Calls the desired function
    function randomEuint16() internal returns (euint16 memory) {
        return randomEuint16(0);
    }
    /// @notice Generates a random value of a euint32 type for provided securityZone
    /// @dev Calls the desired function
    /// @param securityZone the security zone to use for the random value
    function randomEuint32(int32 securityZone) internal returns (euint32 memory) {
        CiphertextKey memory ctKey = Impl.random(Utils.EUINT32_TFHE, 0, securityZone);
        return Common.keyAsEuint32(ctKey);
    }
    /// @notice Generates a random value of a euint32 type
    /// @dev Calls the desired function
    function randomEuint32() internal returns (euint32 memory) {
        return randomEuint32(0);
    }
    /// @notice Generates a random value of a euint64 type for provided securityZone
    /// @dev Calls the desired function
    /// @param securityZone the security zone to use for the random value
    function randomEuint64(int32 securityZone) internal returns (euint64 memory) {
        CiphertextKey memory ctKey = Impl.random(Utils.EUINT64_TFHE, 0, securityZone);
        return Common.keyAsEuint64(ctKey);
    }
    /// @notice Generates a random value of a euint64 type
    /// @dev Calls the desired function
    function randomEuint64() internal returns (euint64 memory) {
        return randomEuint64(0);
    }
    /// @notice Generates a random value of a euint128 type for provided securityZone
    /// @dev Calls the desired function
    /// @param securityZone the security zone to use for the random value
    function randomEuint128(int32 securityZone) internal returns (euint128 memory) {
        CiphertextKey memory ctKey = Impl.random(Utils.EUINT128_TFHE, 0, securityZone);
        return Common.keyAsEuint128(ctKey);
    }
    /// @notice Generates a random value of a euint128 type
    /// @dev Calls the desired function
    function randomEuint128() internal returns (euint128 memory) {
        return randomEuint128(0);
    }
    /// @notice Generates a random value of a euint256 type for provided securityZone
    /// @dev Calls the desired function
    /// @param securityZone the security zone to use for the random value
    function randomEuint256(int32 securityZone) internal returns (euint256 memory) {
        CiphertextKey memory ctKey = Impl.random(Utils.EUINT256_TFHE, 0, securityZone);
        return Common.keyAsEuint256(ctKey);
    }
    /// @notice Generates a random value of a euint256 type
    /// @dev Calls the desired function
    function randomEuint256() internal returns (euint256 memory) {
        return randomEuint256(0);
    }

    // ********** TYPE CASTING ************* //
    /// @notice Converts a ebool to an euint8
    function asEuint8(ebool memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.eboolAsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a ebool to an euint16
    function asEuint16(ebool memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.eboolAsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a ebool to an euint32
    function asEuint32(ebool memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.eboolAsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a ebool to an euint64
    function asEuint64(ebool memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.eboolAsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a ebool to an euint128
    function asEuint128(ebool memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.eboolAsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a ebool to an euint256
    function asEuint256(ebool memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.eboolAsKey(value), Utils.EUINT256_TFHE));
    }

    /// @notice Converts a euint8 to an ebool
    function asEbool(euint8 memory value) internal returns (ebool memory) {
        return ne(value, asEuint8(0));
    }
    /// @notice Converts a euint8 to an euint16
    function asEuint16(euint8 memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.euint8AsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a euint8 to an euint32
    function asEuint32(euint8 memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.euint8AsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a euint8 to an euint64
    function asEuint64(euint8 memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.euint8AsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a euint8 to an euint128
    function asEuint128(euint8 memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.euint8AsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a euint8 to an euint256
    function asEuint256(euint8 memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.euint8AsKey(value), Utils.EUINT256_TFHE));
    }

    /// @notice Converts a euint16 to an ebool
    function asEbool(euint16 memory value) internal returns (ebool memory) {
        return ne(value, asEuint16(0));
    }
    /// @notice Converts a euint16 to an euint8
    function asEuint8(euint16 memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.euint16AsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a euint16 to an euint32
    function asEuint32(euint16 memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.euint16AsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a euint16 to an euint64
    function asEuint64(euint16 memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.euint16AsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a euint16 to an euint128
    function asEuint128(euint16 memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.euint16AsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a euint16 to an euint256
    function asEuint256(euint16 memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.euint16AsKey(value), Utils.EUINT256_TFHE));
    }

    /// @notice Converts a euint32 to an ebool
    function asEbool(euint32 memory value) internal returns (ebool memory) {
        return ne(value, asEuint32(0));
    }
    /// @notice Converts a euint32 to an euint8
    function asEuint8(euint32 memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.euint32AsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a euint32 to an euint16
    function asEuint16(euint32 memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.euint32AsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a euint32 to an euint64
    function asEuint64(euint32 memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.euint32AsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a euint32 to an euint128
    function asEuint128(euint32 memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.euint32AsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a euint32 to an euint256
    function asEuint256(euint32 memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.euint32AsKey(value), Utils.EUINT256_TFHE));
    }

    /// @notice Converts a euint64 to an ebool
    function asEbool(euint64 memory value) internal returns (ebool memory) {
        return ne(value, asEuint64(0));
    }
    /// @notice Converts a euint64 to an euint8
    function asEuint8(euint64 memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.euint64AsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a euint64 to an euint16
    function asEuint16(euint64 memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.euint64AsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a euint64 to an euint32
    function asEuint32(euint64 memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.euint64AsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a euint64 to an euint128
    function asEuint128(euint64 memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.euint64AsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a euint64 to an euint256
    function asEuint256(euint64 memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.euint64AsKey(value), Utils.EUINT256_TFHE));
    }

    /// @notice Converts a euint128 to an ebool
    function asEbool(euint128 memory value) internal returns (ebool memory) {
        return ne(value, asEuint128(0));
    }
    /// @notice Converts a euint128 to an euint8
    function asEuint8(euint128 memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.euint128AsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a euint128 to an euint16
    function asEuint16(euint128 memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.euint128AsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a euint128 to an euint32
    function asEuint32(euint128 memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.euint128AsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a euint128 to an euint64
    function asEuint64(euint128 memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.euint128AsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a euint128 to an euint256
    function asEuint256(euint128 memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.euint128AsKey(value), Utils.EUINT256_TFHE));
    }

    /// @notice Converts a euint256 to an ebool
    function asEbool(euint256 memory value) internal returns (ebool memory) {
        return ne(value, asEuint256(0));
    }
    /// @notice Converts a euint256 to an euint8
    function asEuint8(euint256 memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.euint256AsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a euint256 to an euint16
    function asEuint16(euint256 memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.euint256AsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a euint256 to an euint32
    function asEuint32(euint256 memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.euint256AsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a euint256 to an euint64
    function asEuint64(euint256 memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.euint256AsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a euint256 to an euint128
    function asEuint128(euint256 memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.euint256AsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a euint256 to an eaddress
    function asEaddress(euint256 memory value) internal returns (eaddress memory) {
        return Common.keyAsEaddress(Impl.cast(Common.euint256AsKey(value), Utils.EADDRESS_TFHE));
    }

    /// @notice Converts a eaddress to an ebool
    function asEbool(eaddress memory value) internal returns (ebool memory) {
        return ne(value, asEaddress(address(0)));
    }
    /// @notice Converts a eaddress to an euint8
    function asEuint8(eaddress memory value) internal returns (euint8 memory) {
        return Common.keyAsEuint8(Impl.cast(Common.eaddressAsKey(value), Utils.EUINT8_TFHE));
    }
    /// @notice Converts a eaddress to an euint16
    function asEuint16(eaddress memory value) internal returns (euint16 memory) {
        return Common.keyAsEuint16(Impl.cast(Common.eaddressAsKey(value), Utils.EUINT16_TFHE));
    }
    /// @notice Converts a eaddress to an euint32
    function asEuint32(eaddress memory value) internal returns (euint32 memory) {
        return Common.keyAsEuint32(Impl.cast(Common.eaddressAsKey(value), Utils.EUINT32_TFHE));
    }
    /// @notice Converts a eaddress to an euint64
    function asEuint64(eaddress memory value) internal returns (euint64 memory) {
        return Common.keyAsEuint64(Impl.cast(Common.eaddressAsKey(value), Utils.EUINT64_TFHE));
    }
    /// @notice Converts a eaddress to an euint128
    function asEuint128(eaddress memory value) internal returns (euint128 memory) {
        return Common.keyAsEuint128(Impl.cast(Common.eaddressAsKey(value), Utils.EUINT128_TFHE));
    }
    /// @notice Converts a eaddress to an euint256
    function asEuint256(eaddress memory value) internal returns (euint256 memory) {
        return Common.keyAsEuint256(Impl.cast(Common.eaddressAsKey(value), Utils.EUINT256_TFHE));
    }
    /// @notice Converts a plaintext boolean value to a ciphertext ebool
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// @return A ciphertext representation of the input
    function asEbool(bool value) internal returns (ebool memory) {
        return asEbool(value, 0);
    }
    /// @notice Converts a plaintext boolean value to a ciphertext ebool, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// @return A ciphertext representation of the input
    function asEbool(bool value, int32 securityZone) internal returns (ebool memory) {
        uint256 sVal = 0;
        if (value) {
            sVal = 1;
        }
        CiphertextKey memory ct = Impl.trivialEncrypt(sVal, Utils.EBOOL_TFHE, securityZone);
        return Common.keyAsEbool(ct);
    }
    /// @notice Converts a uint256 to an euint8
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint8(uint256 value) internal returns (euint8 memory) {
        return asEuint8(value, 0);
    }
    /// @notice Converts a uint256 to an euint8, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint8(uint256 value, int32 securityZone) internal returns (euint8 memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(value, Utils.EUINT8_TFHE, securityZone);
        return Common.keyAsEuint8(ct);
    }
    /// @notice Converts a uint256 to an euint16
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint16(uint256 value) internal returns (euint16 memory) {
        return asEuint16(value, 0);
    }
    /// @notice Converts a uint256 to an euint16, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint16(uint256 value, int32 securityZone) internal returns (euint16 memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(value, Utils.EUINT16_TFHE, securityZone);
        return Common.keyAsEuint16(ct);
    }
    /// @notice Converts a uint256 to an euint32
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint32(uint256 value) internal returns (euint32 memory) {
        return asEuint32(value, 0);
    }
    /// @notice Converts a uint256 to an euint32, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint32(uint256 value, int32 securityZone) internal returns (euint32 memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(value, Utils.EUINT32_TFHE, securityZone);
        return Common.keyAsEuint32(ct);
    }
    /// @notice Converts a uint256 to an euint64
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint64(uint256 value) internal returns (euint64 memory) {
        return asEuint64(value, 0);
    }
    /// @notice Converts a uint256 to an euint64, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint64(uint256 value, int32 securityZone) internal returns (euint64 memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(value, Utils.EUINT64_TFHE, securityZone);
        return Common.keyAsEuint64(ct);
    }
    /// @notice Converts a uint256 to an euint128
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint128(uint256 value) internal returns (euint128 memory) {
        return asEuint128(value, 0);
    }
    /// @notice Converts a uint256 to an euint128, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint128(uint256 value, int32 securityZone) internal returns (euint128 memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(value, Utils.EUINT128_TFHE, securityZone);
        return Common.keyAsEuint128(ct);
    }
    /// @notice Converts a uint256 to an euint256
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint256(uint256 value) internal returns (euint256 memory) {
        return asEuint256(value, 0);
    }
    /// @notice Converts a uint256 to an euint256, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    function asEuint256(uint256 value, int32 securityZone) internal returns (euint256 memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(value, Utils.EUINT256_TFHE, securityZone);
        return Common.keyAsEuint256(ct);
    }
    /// @notice Converts a address to an eaddress
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// Allows for a better user experience when working with eaddresses
    function asEaddress(address value) internal returns (eaddress memory) {
        return asEaddress(value, 0);
    }
    /// @notice Converts a address to an eaddress, specifying security zone
    /// @dev Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
    /// Allows for a better user experience when working with eaddresses
    function asEaddress(address value, int32 securityZone) internal returns (eaddress memory) {
        CiphertextKey memory ct = Impl.trivialEncrypt(uint256(uint160(value)), Utils.EADDRESS_TFHE, securityZone);
        return Common.keyAsEaddress(ct);
    }
}
// ********** BINDING DEFS ************* //

    using BindingsEbool for ebool global;
library BindingsEbool {

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the eq
    function eq(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the ne
    function ne(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }

    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @return the result of the not
    function not(ebool memory lhs) internal returns (ebool memory) {
        return FHE.not(lhs);
    }

    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the and
    function and(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        return FHE.and(lhs, rhs);
    }

    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the or
    function or(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        return FHE.or(lhs, rhs);
    }

    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type ebool
    /// @param rhs second input of type ebool
    /// @return the result of the xor
    function xor(ebool memory lhs, ebool memory rhs) internal returns (ebool memory) {
        return FHE.xor(lhs, rhs);
    }
    function toU8(ebool memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU16(ebool memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU32(ebool memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU64(ebool memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU128(ebool memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toU256(ebool memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(ebool memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(ebool memory value, bytes32 publicKey) internal returns (SealedBool memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(ebool memory value) internal returns (ebool memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEuint8 for euint8 global;
library BindingsEuint8 {

    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the add
    function add(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.add(lhs, rhs);
    }

    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the mul
    function mul(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.mul(lhs, rhs);
    }

    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the div
    function div(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.div(lhs, rhs);
    }

    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the sub
    function sub(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.sub(lhs, rhs);
    }

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the eq
    function eq(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the ne
    function ne(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }

    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the not
    function not(euint8 memory lhs) internal returns (euint8 memory) {
        return FHE.not(lhs);
    }

    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the and
    function and(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.and(lhs, rhs);
    }

    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the or
    function or(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.or(lhs, rhs);
    }

    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the xor
    function xor(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.xor(lhs, rhs);
    }

    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the gt
    function gt(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        return FHE.gt(lhs, rhs);
    }

    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the gte
    function gte(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        return FHE.gte(lhs, rhs);
    }

    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the lt
    function lt(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        return FHE.lt(lhs, rhs);
    }

    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the lte
    function lte(euint8 memory lhs, euint8 memory rhs) internal returns (ebool memory) {
        return FHE.lte(lhs, rhs);
    }

    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the rem
    function rem(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.rem(lhs, rhs);
    }

    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the max
    function max(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.max(lhs, rhs);
    }

    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the min
    function min(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.min(lhs, rhs);
    }

    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the shl
    function shl(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.shl(lhs, rhs);
    }

    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the shr
    function shr(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.shr(lhs, rhs);
    }

    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the rol
    function rol(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.rol(lhs, rhs);
    }

    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @param rhs second input of type euint8
    /// @return the result of the ror
    function ror(euint8 memory lhs, euint8 memory rhs) internal returns (euint8 memory) {
        return FHE.ror(lhs, rhs);
    }

    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint8
    /// @return the result of the square
    function square(euint8 memory lhs) internal returns (euint8 memory) {
        return FHE.square(lhs);
    }
    function toBool(euint8 memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU16(euint8 memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU32(euint8 memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU64(euint8 memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU128(euint8 memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toU256(euint8 memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(euint8 memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint8 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint8 memory value) internal returns (euint8 memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEuint16 for euint16 global;
library BindingsEuint16 {

    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the add
    function add(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.add(lhs, rhs);
    }

    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the mul
    function mul(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.mul(lhs, rhs);
    }

    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the div
    function div(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.div(lhs, rhs);
    }

    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the sub
    function sub(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.sub(lhs, rhs);
    }

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the eq
    function eq(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the ne
    function ne(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }

    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the not
    function not(euint16 memory lhs) internal returns (euint16 memory) {
        return FHE.not(lhs);
    }

    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the and
    function and(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.and(lhs, rhs);
    }

    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the or
    function or(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.or(lhs, rhs);
    }

    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the xor
    function xor(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.xor(lhs, rhs);
    }

    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the gt
    function gt(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        return FHE.gt(lhs, rhs);
    }

    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the gte
    function gte(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        return FHE.gte(lhs, rhs);
    }

    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the lt
    function lt(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        return FHE.lt(lhs, rhs);
    }

    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the lte
    function lte(euint16 memory lhs, euint16 memory rhs) internal returns (ebool memory) {
        return FHE.lte(lhs, rhs);
    }

    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the rem
    function rem(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.rem(lhs, rhs);
    }

    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the max
    function max(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.max(lhs, rhs);
    }

    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the min
    function min(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.min(lhs, rhs);
    }

    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the shl
    function shl(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.shl(lhs, rhs);
    }

    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the shr
    function shr(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.shr(lhs, rhs);
    }

    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the rol
    function rol(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.rol(lhs, rhs);
    }

    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @param rhs second input of type euint16
    /// @return the result of the ror
    function ror(euint16 memory lhs, euint16 memory rhs) internal returns (euint16 memory) {
        return FHE.ror(lhs, rhs);
    }

    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint16
    /// @return the result of the square
    function square(euint16 memory lhs) internal returns (euint16 memory) {
        return FHE.square(lhs);
    }
    function toBool(euint16 memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU8(euint16 memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU32(euint16 memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU64(euint16 memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU128(euint16 memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toU256(euint16 memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(euint16 memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint16 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint16 memory value) internal returns (euint16 memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEuint32 for euint32 global;
library BindingsEuint32 {

    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the add
    function add(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.add(lhs, rhs);
    }

    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the mul
    function mul(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.mul(lhs, rhs);
    }

    /// @notice Performs the div operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the div
    function div(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.div(lhs, rhs);
    }

    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the sub
    function sub(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.sub(lhs, rhs);
    }

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the eq
    function eq(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the ne
    function ne(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }

    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the not
    function not(euint32 memory lhs) internal returns (euint32 memory) {
        return FHE.not(lhs);
    }

    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the and
    function and(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.and(lhs, rhs);
    }

    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the or
    function or(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.or(lhs, rhs);
    }

    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the xor
    function xor(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.xor(lhs, rhs);
    }

    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the gt
    function gt(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        return FHE.gt(lhs, rhs);
    }

    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the gte
    function gte(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        return FHE.gte(lhs, rhs);
    }

    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the lt
    function lt(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        return FHE.lt(lhs, rhs);
    }

    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the lte
    function lte(euint32 memory lhs, euint32 memory rhs) internal returns (ebool memory) {
        return FHE.lte(lhs, rhs);
    }

    /// @notice Performs the rem operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the rem
    function rem(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.rem(lhs, rhs);
    }

    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the max
    function max(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.max(lhs, rhs);
    }

    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the min
    function min(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.min(lhs, rhs);
    }

    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the shl
    function shl(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.shl(lhs, rhs);
    }

    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the shr
    function shr(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.shr(lhs, rhs);
    }

    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the rol
    function rol(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.rol(lhs, rhs);
    }

    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @param rhs second input of type euint32
    /// @return the result of the ror
    function ror(euint32 memory lhs, euint32 memory rhs) internal returns (euint32 memory) {
        return FHE.ror(lhs, rhs);
    }

    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint32
    /// @return the result of the square
    function square(euint32 memory lhs) internal returns (euint32 memory) {
        return FHE.square(lhs);
    }
    function toBool(euint32 memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU8(euint32 memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU16(euint32 memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU64(euint32 memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU128(euint32 memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toU256(euint32 memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(euint32 memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint32 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint32 memory value) internal returns (euint32 memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEuint64 for euint64 global;
library BindingsEuint64 {

    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the add
    function add(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.add(lhs, rhs);
    }

    /// @notice Performs the mul operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the mul
    function mul(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.mul(lhs, rhs);
    }

    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the sub
    function sub(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.sub(lhs, rhs);
    }

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the eq
    function eq(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the ne
    function ne(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }

    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @return the result of the not
    function not(euint64 memory lhs) internal returns (euint64 memory) {
        return FHE.not(lhs);
    }

    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the and
    function and(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.and(lhs, rhs);
    }

    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the or
    function or(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.or(lhs, rhs);
    }

    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the xor
    function xor(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.xor(lhs, rhs);
    }

    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the gt
    function gt(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        return FHE.gt(lhs, rhs);
    }

    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the gte
    function gte(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        return FHE.gte(lhs, rhs);
    }

    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the lt
    function lt(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        return FHE.lt(lhs, rhs);
    }

    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the lte
    function lte(euint64 memory lhs, euint64 memory rhs) internal returns (ebool memory) {
        return FHE.lte(lhs, rhs);
    }

    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the max
    function max(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.max(lhs, rhs);
    }

    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the min
    function min(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.min(lhs, rhs);
    }

    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the shl
    function shl(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.shl(lhs, rhs);
    }

    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the shr
    function shr(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.shr(lhs, rhs);
    }

    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the rol
    function rol(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.rol(lhs, rhs);
    }

    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @param rhs second input of type euint64
    /// @return the result of the ror
    function ror(euint64 memory lhs, euint64 memory rhs) internal returns (euint64 memory) {
        return FHE.ror(lhs, rhs);
    }

    /// @notice Performs the square operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint64
    /// @return the result of the square
    function square(euint64 memory lhs) internal returns (euint64 memory) {
        return FHE.square(lhs);
    }
    function toBool(euint64 memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU8(euint64 memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU16(euint64 memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU32(euint64 memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU128(euint64 memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toU256(euint64 memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(euint64 memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint64 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint64 memory value) internal returns (euint64 memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEuint128 for euint128 global;
library BindingsEuint128 {

    /// @notice Performs the add operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the add
    function add(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.add(lhs, rhs);
    }

    /// @notice Performs the sub operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the sub
    function sub(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.sub(lhs, rhs);
    }

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the eq
    function eq(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the ne
    function ne(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }

    /// @notice Performs the not operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @return the result of the not
    function not(euint128 memory lhs) internal returns (euint128 memory) {
        return FHE.not(lhs);
    }

    /// @notice Performs the and operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the and
    function and(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.and(lhs, rhs);
    }

    /// @notice Performs the or operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the or
    function or(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.or(lhs, rhs);
    }

    /// @notice Performs the xor operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the xor
    function xor(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.xor(lhs, rhs);
    }

    /// @notice Performs the gt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the gt
    function gt(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        return FHE.gt(lhs, rhs);
    }

    /// @notice Performs the gte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the gte
    function gte(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        return FHE.gte(lhs, rhs);
    }

    /// @notice Performs the lt operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the lt
    function lt(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        return FHE.lt(lhs, rhs);
    }

    /// @notice Performs the lte operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the lte
    function lte(euint128 memory lhs, euint128 memory rhs) internal returns (ebool memory) {
        return FHE.lte(lhs, rhs);
    }

    /// @notice Performs the max operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the max
    function max(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.max(lhs, rhs);
    }

    /// @notice Performs the min operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the min
    function min(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.min(lhs, rhs);
    }

    /// @notice Performs the shl operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the shl
    function shl(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.shl(lhs, rhs);
    }

    /// @notice Performs the shr operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the shr
    function shr(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.shr(lhs, rhs);
    }

    /// @notice Performs the rol operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the rol
    function rol(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.rol(lhs, rhs);
    }

    /// @notice Performs the ror operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint128
    /// @param rhs second input of type euint128
    /// @return the result of the ror
    function ror(euint128 memory lhs, euint128 memory rhs) internal returns (euint128 memory) {
        return FHE.ror(lhs, rhs);
    }
    function toBool(euint128 memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU8(euint128 memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU16(euint128 memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU32(euint128 memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU64(euint128 memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU256(euint128 memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(euint128 memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint128 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint128 memory value) internal returns (euint128 memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEuint256 for euint256 global;
library BindingsEuint256 {

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint256
    /// @param rhs second input of type euint256
    /// @return the result of the eq
    function eq(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type euint256
    /// @param rhs second input of type euint256
    /// @return the result of the ne
    function ne(euint256 memory lhs, euint256 memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }
    function toBool(euint256 memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU8(euint256 memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU16(euint256 memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU32(euint256 memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU64(euint256 memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU128(euint256 memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toEaddress(euint256 memory value) internal returns (eaddress memory) {
        return FHE.asEaddress(value);
    }
    function seal(euint256 memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(euint256 memory value, bytes32 publicKey) internal returns (SealedUint memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(euint256 memory value) internal returns (euint256 memory) {
        return FHE.decrypt(value);
    }
}

    using BindingsEaddress for eaddress global;
library BindingsEaddress {

    /// @notice Performs the eq operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type eaddress
    /// @param rhs second input of type eaddress
    /// @return the result of the eq
    function eq(eaddress memory lhs, eaddress memory rhs) internal returns (ebool memory) {
        return FHE.eq(lhs, rhs);
    }

    /// @notice Performs the ne operation
    /// @dev Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access
    /// @param lhs input of type eaddress
    /// @param rhs second input of type eaddress
    /// @return the result of the ne
    function ne(eaddress memory lhs, eaddress memory rhs) internal returns (ebool memory) {
        return FHE.ne(lhs, rhs);
    }
    function toBool(eaddress memory value) internal  returns (ebool memory) {
        return FHE.asEbool(value);
    }
    function toU8(eaddress memory value) internal returns (euint8 memory) {
        return FHE.asEuint8(value);
    }
    function toU16(eaddress memory value) internal returns (euint16 memory) {
        return FHE.asEuint16(value);
    }
    function toU32(eaddress memory value) internal returns (euint32 memory) {
        return FHE.asEuint32(value);
    }
    function toU64(eaddress memory value) internal returns (euint64 memory) {
        return FHE.asEuint64(value);
    }
    function toU128(eaddress memory value) internal returns (euint128 memory) {
        return FHE.asEuint128(value);
    }
    function toU256(eaddress memory value) internal returns (euint256 memory) {
        return FHE.asEuint256(value);
    }
    function seal(eaddress memory value, bytes32 publicKey) internal returns (string memory) {
        return FHE.sealoutput(value, publicKey);
    }
    function sealTyped(eaddress memory value, bytes32 publicKey) internal returns (SealedAddress memory) {
        return FHE.sealoutputTyped(value, publicKey);
    }
    function decrypt(eaddress memory value) internal returns (eaddress memory) {
        return FHE.decrypt(value);
    }
}