pragma solidity >=0.8.19 <0.9.0;

// SPDX-License-Identifier: MIT
// Fhenix Protocol (last updated v0.1.0) (token/FHERC721/IFHERC721.sol)
// Inspired by OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts) (token/FHERC721/IFHERC721.sol)

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// todo (eshel) remove
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import { Permission, Permissioned } from "../../../access/Permissioned.sol";
import { euint256, inEuint256 } from "../../../FHE.sol";

/**
 * @dev Interface of the ERC-721 standard as defined in the ERC.
 */
interface IFHERC721 is IERC721 {
    /**
     * @dev Emitted when `owner` enables `approved` to view the private data of the `tokenId` token.
     */
    event ViewApproval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);

    /**
     * @dev Returns the private data associated with `tokenId` token, if the caller is allowed to view it.
     */
    function tokenPrivateData(uint256 tokenId, Permission memory auth) external view returns (string memory);

    /**
     * @dev Gives permission to `to` to view the private data associated with `tokenId` token.
     *
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits a {ViewApproval} event.
     */
    function approveViewing(address to, uint256 tokenId) external;
}