// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import { ERC1271 } from "./LA_EIP1271.sol";

/// @title A simple ERC-4337 compatible smart contract account with a designated owner account.
/// @dev Like eth-infinitism's SimpleAccount, but with the following changes:
///
/// Removed all the Alchemy stuff, only for testing permit signatures
contract LightAccount is ERC1271 {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    error InvalidOwner(address owner);
    error InvalidSignatureType();

    enum SignatureType {
        EOA,
        CONTRACT,
        CONTRACT_WITH_ADDR
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current
    /// owner or from the entry point via a user operation signed by the current owner.
    /// @param newOwner The new owner.
    function transferOwnership(address newOwner) external {
        if (newOwner == address(0) || newOwner == address(this)) {
            revert InvalidOwner(newOwner);
        }
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner;
        if (newOwner == oldOwner) {
            revert InvalidOwner(newOwner);
        }
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /// @notice Check if the signature is a valid by the EOA owner for the given digest.
    /// @dev Only supports 65-byte signatures, and uses the digest directly. Reverts if the signature is malformed.
    /// @param digest The digest to be checked.
    /// @param signature The signature to be checked.
    /// @return True if the signature is valid and by the owner, false otherwise.
    function _isValidEOAOwnerSignature(bytes32 digest, bytes memory signature) internal view returns (bool) {
        address recovered = digest.recover(signature);
        return recovered == owner;
    }

    /// @notice Check if the signature is a valid ERC-1271 signature by a contract owner for the given digest.
    /// @param digest The digest to be checked.
    /// @param signature The signature to be checked.
    /// @return True if the signature is valid and by an owner, false otherwise.
    function _isValidContractOwnerSignatureNow(bytes32 digest, bytes memory signature) internal view returns (bool) {
        return SignatureChecker.isValidERC1271SignatureNow(owner, digest, signature);
    }


    /// @dev The signature is valid if it is signed by the owner's private key (if the owner is an EOA) or if it is a
    /// valid ERC-1271 signature from the owner (if the owner is a contract). Reverts if the signature is malformed.
    /// Note that unlike the signature validation used in `validateUserOp`, this does **not** wrap the hash in an
    /// "Ethereum Signed Message" envelope before checking the signature in the EOA-owner case.
    function _isValidSignature(bytes32 replaySafeHash, bytes calldata signature)
        internal
        view
        override
        returns (bool)
    {
        if (signature.length < 1) {
            revert InvalidSignatureType();
        }
        uint8 signatureType = uint8(signature[0]);
        if (signatureType == uint8(SignatureType.EOA)) {
            // EOA signature
            return _isValidEOAOwnerSignature(replaySafeHash, signature[1:]);
        } else if (signatureType == uint8(SignatureType.CONTRACT)) {
            // Contract signature without address
            return _isValidContractOwnerSignatureNow(replaySafeHash, signature[1:]);
        }
        revert InvalidSignatureType();
    }

    function _domainNameAndVersion()
        internal
        pure
        override
        returns (string memory name, string memory version)
    {
        name = "LightAccount";
        // Set to the major version of the GitHub release at which the contract was last updated.
        version = "2";
    }
}