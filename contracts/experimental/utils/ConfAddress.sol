// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19 <0.8.25;

import { euint32, ebool, FHE } from "../../FHE.sol";
import "./BytesLib.sol";

/// @title Encrypted Address Library
/// @notice Provides methods for creating and managing addresses encrypted with FHE (Fully Homomorphic Encryption)
/// @dev Assumes the existence of an FHE library that implements fully homomorphic encryption functions
/// This is a VERY experimental and unfinished library - it is mainly entended to bridge the gap and provide an example of working with an encrypted address
/// Expect these interfaces to change, break, not work, or suck 

/// @dev A representation of an encrypted address using Fully Homomorphic Encryption.
/// It consists of 5 encrypted 32-bit unsigned integers (`euint32`).
struct Eaddress {
    euint32[5] values;
}

library ConfAddress {
    /// @notice Encrypts a plaintext Ethereum address into its encrypted representation (`eaddress`).
    /// @dev Iterates over 5 chunks of the address, applying a bitmask to each, then encrypting with `FHE`.
    /// @param addr The plain Ethereum address to encrypt
    /// @return eaddr The encrypted representation of the address
    function toEaddress(address addr) internal pure returns (Eaddress memory) {
        uint160 addrValue = uint160(address(addr));
        /// @dev A bitmask constant for selecting specific 32-bit chunks from a 160-bit Ethereum address.
        /// It has the first 32 bits set to 1, and the remaining bits set to 0.
        uint160 MASK = uint160(uint256(0x000000000000000000000000FFFFFFFF00000000000000000000000000000000));

        Eaddress memory eaddr;

        for (uint i = 0; i < 5; i++) {
            uint160 currentChunkOffset = uint160(i * 32);
            uint160 mask = MASK >> currentChunkOffset; // Mask the correct chunk based on i
            uint32 chunk = uint32((addrValue & mask) >> (128 - currentChunkOffset));
            eaddr.values[i] = FHE.asEuint32(chunk);
        }

        return eaddr;
    }

    /// @notice Decrypts an `eaddress` to retrieve the original plaintext Ethereum address.
    /// @dev This operation should be used with caution as it exposes the encrypted address.
    /// @param eaddr The encrypted address to decrypt
    /// @return The decrypted plaintext Ethereum address
    function unsafeToAddress(Eaddress memory eaddr) internal pure returns (address) {
        uint160 addrValue;
        for (uint i = 0; i < 5; i++) {
            uint32 currentChunkOffset = uint32((4 - i) * 32);
            uint32 val = FHE.decrypt(eaddr.values[i]);
            uint160 currentValue = uint160(val) << currentChunkOffset;
            addrValue += currentValue;
        }

        bytes memory addrBz = new bytes(32);
        assembly {
            mstore(add(addrBz, 32), addrValue)
        }

        return BytesLib.toAddress(addrBz, 12);
    }

    /// @notice Re-encrypts the encrypted values within an `eaddress`.
    /// @dev The re-encryption is done to change the encrypted representation without
    /// altering the underlying plaintext address, which can be useful for obfuscation purposes in storage.
    /// @param eaddr The encrypted address to re-encrypt
    /// @param ezero An encrypted zero value that triggers the re-encryption
    function resestEaddress(Eaddress memory eaddr, euint32 ezero) internal pure {
        for (uint i = 0; i < 5; i++) {
            // Adding zero will practiaclly reencrypt the value without it being changed
            eaddr.values[i] = eaddr.values[i] + ezero;
        }
    }

    /// @notice Determines if an encrypted address is equal to a given plaintext Ethereum address.
    /// @dev This operation encrypts the plaintext address and compares the encrypted representations.
    /// @param lhs The encrypted address to compare
    /// @param addr The plaintext Ethereum address to compare against
    /// @return res A boolean indicating if the encrypted and plaintext addresses are equal
    function equals(Eaddress storage lhs, address payable addr) internal view returns (ebool) {
        Eaddress memory rhs = toEaddress(addr);
        ebool res = FHE.eq(lhs.values[0], rhs.values[0]);
        for (uint i = 1; i < 5; i++) {
            res = res & FHE.eq(lhs.values[i], rhs.values[i]);
        }

        return res;
    }

    function conditionalUpdate(
        ebool condition,
        Eaddress memory eaddr,
        Eaddress memory newEaddr
    ) internal pure returns (Eaddress memory) {
        for (uint i = 0; i < 5; i++) {
            // Even if condition is false the ENCRYPTED value of eaddr.values[i] will be changed
            // because the encryption is not deterministic
            // so no one will know whether the highest bidder was changed or not
            eaddr.values[i] = FHE.select(condition, newEaddr.values[i], eaddr.values[i]);
        }

        return eaddr;
    }
}
