// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { EIP712 } from "./LA_EIP712.sol";

/// Inlined ERC1271 library for testing
abstract contract ERC1271 is EIP712 {
    /// @dev bytes4(keccak256("isValidSignature(bytes32,bytes)"))
    bytes4 internal constant _1271_MAGIC_VALUE_SUCCESS = 0x1626ba7e;
    bytes4 internal constant _1271_MAGIC_VALUE_FAILURE = 0xffffffff;
    bytes32 internal constant _MESSAGE_TYPEHASH = keccak256("LightAccountMessage(bytes message)");

    /// @notice Returns the replay-safe hash of a message that can be signed by owners.
    /// @param message Message that should be hashed.
    /// @return The replay-safe message hash.
    function getMessageHash(bytes memory message) public view returns (bytes32) {
        bytes32 structHash = keccak256(abi.encode(_MESSAGE_TYPEHASH, keccak256(message)));
        return _hashTypedData(structHash);
    }

    /// @dev The signature is valid if it is signed by the owner's private key (if the owner is an EOA) or if it is
    /// a valid ERC-1271 signature from the owner (if the owner is a contract).
    /// @param hash Hash of the data to be signed.
    /// @param signature Signature byte array associated with the data.
    /// @return Magic value `0x1626ba7e` if validation succeeded, else `0xffffffff`.
    function isValidSignature(bytes32 hash, bytes calldata signature) public view virtual returns (bytes4) {
        if (_isValidSignature(getMessageHash(abi.encode(hash)), signature)) {
            return _1271_MAGIC_VALUE_SUCCESS;
        }
        return _1271_MAGIC_VALUE_FAILURE;
    }

    /// @dev Must override to provide the signature verification logic.
    /// @param replaySafeHash The replay-safe hash that is derived from the original message.
    /// @param signature The signature passed to `isValidSignature`.
    /// @return Whether the signature is valid.
    function _isValidSignature(bytes32 replaySafeHash, bytes calldata signature) internal view virtual returns (bool);
}
