// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

library Precompiles {
    address public constant Fheos = address(128);
}

contract MockFheOps {
    using CTR for uint8;
    using CTR for uint256;
    using CTR for bool;
    using CTR for bytes;
    using CTR for bytes32;

    function trivialEncrypt(
        bytes memory input,
        uint8 toType,
        int32
    ) external pure returns (bytes memory) {
        uint256 result = input.bytesToUint() % toType.maxValue();
        return result.ctrEncrypt();
    }

    function add(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = (lhsHash.ctrDecrypt() + rhsHash.ctrDecrypt()) % utype.maxValue();
        return result.ctrEncrypt();
    }

    function sealOutput(
        uint8,
        bytes memory ctHash,
        bytes memory pk
    ) external pure returns (string memory) {
        string memory result = ctHash.ctrSeal(pk);
        return result;
    }

    function verify(
        uint8,
        bytes memory input,
        int32
    ) external pure returns (bytes memory) {
        return input;
    }

    function cast(
        uint8,
        bytes memory input,
        uint8 toType
    ) external pure returns (bytes memory) {
        uint256 result = input.ctrDecrypt() % toType.maxValue();
        return result.ctrEncrypt();
    }

    function log(string memory s) external pure {}

    function decrypt(
        uint8,
        bytes memory input,
        uint256
    ) external pure returns (uint256) {
        return input.ctrDecrypt();
    }

    function lte(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) <= rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function sub(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = (lhsHash.ctrDecrypt() - rhsHash.ctrDecrypt()) % utype.maxValue();
        return result.ctrEncrypt();
    }

    function mul(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = (lhsHash.ctrDecrypt() * rhsHash.ctrDecrypt()) % utype.maxValue();
        return result.ctrEncrypt();
    }

    function lt(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) < rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function select(
        uint8 utype,
        bytes memory controlHash,
        bytes memory ifTrueHash,
        bytes memory ifFalseHash
    ) external pure returns (bytes memory) {
        bool control = controlHash.ctrDecrypt(utype) == 1 ? true : false;
        return control ? ifTrueHash : ifFalseHash;
    }

    function req(
        uint8 utype,
        bytes memory input
    ) external pure returns (bytes memory) {
        require(input.ctrDecrypt(utype) != 0);
        return input;
    }

    function div(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = (lhsHash.ctrDecrypt() / rhsHash.ctrDecrypt()) % utype.maxValue();
        return result.ctrEncrypt();
    }

    function gt(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) > rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function gte(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) >= rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function rem(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = (lhsHash.ctrDecrypt() % rhsHash.ctrDecrypt()) % utype.maxValue();
        return result.ctrEncrypt();
    }

    function and(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bytes32 result = bytes32(lhsHash.ctrDecrypt(utype)) & bytes32(rhsHash.ctrDecrypt(utype));
        return result.ctrEncrypt();
    }

    function or(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bytes32 result = bytes32(lhsHash.ctrDecrypt(utype)) | bytes32(rhsHash.ctrDecrypt(utype));
        return result.ctrEncrypt();
    }

    function xor(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bytes32 result = bytes32(lhsHash.ctrDecrypt(utype)) ^ bytes32(rhsHash.ctrDecrypt(utype));
        return result.ctrEncrypt();
    }

    function eq(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) == rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function ne(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) != rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function min(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) >= rhsHash.ctrDecrypt(utype);
        return result ? rhsHash : lhsHash;
    }

    function max(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        bool result = lhsHash.ctrDecrypt(utype) >= rhsHash.ctrDecrypt(utype);
        return result ? lhsHash : rhsHash;
    }

    function shl(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = lhsHash.ctrDecrypt(utype) << rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function shr(
        uint8 utype,
        bytes memory lhsHash,
        bytes memory rhsHash
    ) external pure returns (bytes memory) {
        uint256 result = lhsHash.ctrDecrypt(utype) >> rhsHash.ctrDecrypt(utype);
        return result.ctrEncrypt();
    }

    function not(
        uint8 utype,
        bytes memory value
    ) external pure returns (bytes memory) {
        bytes32 result = ~bytes32(value.ctrDecrypt(utype));
        return result.ctrEncrypt();
    }

    function getNetworkPublicKey(int32) external pure returns (bytes memory) {
        return CTR.key();
    }

    function random(
        uint8 utype,
        uint64,
        int32
    ) external view returns (bytes memory) {
        uint256 result = uint256(keccak256(abi.encode(block.timestamp))) % utype.maxValue();
        return result.ctrEncrypt();
    }
}

library CTR {
    function key() internal pure returns (bytes memory) {
        return abi.encodePacked("deadbeef");
    }

    function maxValue(uint8 utype) internal pure returns (uint256) {
        uint256 result = 0;
        if (utype == 0) {
            result = uint256(type(uint8).max) + 1;
        } else if (utype == 1) {
            result = uint256(type(uint16).max) + 1;
        } else if (utype == 2) {
            result = uint256(type(uint32).max) + 1;
        } else if (utype == 3) {
            result = uint256(type(uint64).max) + 1;
        } else if (utype == 4) {
            result = uint256(type(uint128).max) + 1;
        } else if (utype == 5) {
            result = 1;
        } else if (utype == 12) {
            result = uint256(type(uint160).max) + 1; //address
        } else if (utype == 13) {
            result = 1; //bool (we want anything non-zero to be true)
        } else {
            revert("Unsupported type");
        }

        return result;
    }

    // CTR ENCRYPTION

    // Mock encryption using CTR Encryption
    // https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_(CTR)
    // ctrSymmetricEncrypt(ctrSymmetricEncrypt(5, key), key) = 5
    function ctrSymmetricEncrypt(
        bytes memory data,
        bytes memory _key
    ) internal pure returns (bytes memory result) {
        // Store data length on stack for later use
        uint256 length = data.length;

        assembly {
            // Set result to free memory pointer
            result := mload(0x40)
            // Increase free memory pointer by length + 32
            mstore(0x40, add(add(result, length), 32))
            // Set result length
            mstore(result, length)
        }

        // Iterate over the data stepping by 32 bytes
        for (uint256 i = 0; i < length; i += 32) {

        // Generate hash of the key and offset
        bytes memory packed = abi.encodePacked(_key, i);
        bytes32 hash = keccak256(packed);

        bytes32 chunk;
        assembly {
            // Read 32-bytes data chunk
            chunk := mload(add(data, add(i, 32)))
        }
        // XOR the chunk with hash
        chunk ^= hash;
        assembly {
            // Write 32-byte encrypted chunk
            mstore(add(result, add(i, 32)), chunk)
        }
        }
    }
    
    function ctrEncrypt(
        uint256 data
    ) internal pure returns (bytes memory) {
        return ctrSymmetricEncrypt(uint256ToBytes(data), key());
    }

    function ctrEncrypt(
        bool data
    ) internal pure returns (bytes memory) {
        return ctrEncrypt(data ? 1 : 0);
    }

    function ctrEncrypt(
        bytes memory data
    ) internal pure returns (bytes memory) {
        return ctrSymmetricEncrypt(data, key());
    }

    function ctrEncrypt(
        bytes32 data
    ) internal pure returns (bytes memory) {
        return ctrSymmetricEncrypt(bytes32ToBytes(data), key());
    }
    
    function ctrDecrypt(
        bytes memory data
    ) internal pure returns (uint256) {
        return bytesToUint(ctrSymmetricEncrypt(data, key()));
    }

    function ctrDecrypt(
        bytes memory data,
        uint8 utype
    ) internal pure returns (uint256) {
        return ctrDecrypt(data) % maxValue(utype);
    }

    function ctrSeal(
        bytes memory data,
        bytes memory pk
    ) internal pure returns (string memory) {
        bytes memory decrypted = ctrSymmetricEncrypt(data, key());
        bytes memory reencrypted = ctrSymmetricEncrypt(decrypted, pk);
        return bytesToHexString(reencrypted);
    }

    // Conversion utils

    function bytes32ToBytes(
        bytes32 input
    ) internal pure returns (bytes memory) {
        return bytes.concat(input);
    }

    //For converting back to bytes
    function uint256ToBytes(uint256 value) internal pure returns (bytes memory) {
        bytes memory result = new bytes(32);

        assembly {
            mstore(add(result, 32), value)
        }

        return result;
    }

    //for unknown size of bytes - we could instead just encode it as bytes32 because it's always uint256 but for now lets keep it like this
    function bytesToUint(
        bytes memory b
    ) internal pure returns (uint256) {
        require(b.length <= 32, "Bytes length exceeds 32.");
        return abi.decode(
            abi.encodePacked(new bytes(32 - b.length), b),
            (uint256)
        );
    }

    function bytesToHexString(bytes memory data) public pure returns (string memory) {
        bytes memory converted = new bytes(data.length * 2);

        bytes memory _base = "0123456789abcdef";

        for (uint256 i = 0; i < data.length; i++) {
            converted[i * 2] = _base[uint8(data[i]) / _base.length];
            converted[i * 2 + 1] = _base[uint8(data[i]) % _base.length];
        }

        return string(abi.encodePacked("0x", converted));
    }
}
