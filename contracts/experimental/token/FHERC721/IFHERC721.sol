pragma solidity >=0.8.19 <0.9.0;

// SPDX-License-Identifier: MIT
// Fhenix Protocol (last updated v0.1.0) (token/FHERC721/IFHERC721.sol)
// Inspired by OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts) (token/FHERC721/IFHERC721.sol)

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { Permission, Permissioned } from "../../../access/Permissioned.sol";

/**
 * @dev Interface of the ERC-721 standard as defined in the ERC.
 */
interface IFHERC721 is IERC721 {
    /**
     * @dev Returns the private data associated with `tokenId` token, if the caller is allowed to view it.
     */
    function tokenPrivateData(uint256 tokenId, Permission memory auth) external view returns (string memory);
}