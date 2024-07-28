// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity >=0.8.19 <0.9.0;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

/// @title Permissioned Access Control Contract
/// @notice Abstract contract that provides EIP-712 based signature verification for access control
/// @dev This contract should be inherited by other contracts to provide EIP-712 signature validated access control
abstract contract Permissioned is EIP712 {
    /// @notice Emitted when the signer is not the message sender
    error SignerNotMessageSender();

    /// @notice Emitted when the signer is not the specified owner
    error SignerNotOwner();

    /// @dev Constructor that initializes EIP712 domain separator with a name and version
    /// solhint-disable-next-line func-visibility, no-empty-blocks
    constructor() EIP712("Fhenix Permission", "1.0") {} 

    /// @notice Modifier that requires the provided signature to be signed by the message sender
    /// @param permission Data structure containing the public key and the signature to be verified
    modifier onlySender(Permission memory permission) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("Permissioned(bytes32 publicKey)"),
            permission.publicKey
        )));
        address signer = ECDSA.recover(digest, permission.signature);
        if (signer != msg.sender)
            revert SignerNotMessageSender();
        _;
    }

    /// @notice Modifier that requires the provided signature to be signed by a specific owner address
    /// @param permission Data structure containing the public key and the signature to be verified
    /// @param owner The expected owner of the public key to match against the recovered signer
    modifier onlyPermitted(Permission memory permission, address owner) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("Permissioned(bytes32 publicKey)"),
            permission.publicKey
        )));
        address signer = ECDSA.recover(digest, permission.signature);
        if (signer != owner)
            revert SignerNotOwner();
        _;
    }

    /// @notice Modifier that requires the provided signature to be signed by one of two specific addresses
    /// @param permission Data structure containing the public key and the signature to be verified
    /// @param owner The expected owner of the public key to match against the recovered signer
    /// @param permitted A second permitted owner of the public key to match against the recovered signer
    modifier onlyBetweenPermitted(Permission memory permission, address owner, address permitted) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("Permissioned(bytes32 publicKey)"),
            permission.publicKey
        )));
        address signer = ECDSA.recover(digest, permission.signature);
        if (signer != owner && signer != permitted)
            revert SignerNotOwner();
        _;
    }
}

/// @title Struct for holding signature information
/// @notice Used to pass both the public key and signature data within transactions
/// @dev Should be used with Signature-based modifiers for access control
struct Permission {
    bytes32 publicKey;
    bytes signature;
}
