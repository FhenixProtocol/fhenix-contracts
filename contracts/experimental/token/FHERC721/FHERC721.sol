// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import { FHE, euint256, inEuint256 } from "../../../FHE.sol";
import { Permissioned, Permission } from "../../../access/Permissioned.sol";
import { IFHERC721 } from "./IFHERC721.sol";

contract FHERC721 is IFHERC721, Permissioned, ERC721 {
    mapping(uint256 tokenId => euint256) private _privateData;

    function tokenPrivateData(
        uint256 tokenId,
        Permission memory auth
    ) external view onlyPermitted(auth, _owners[tokenId]) returns (string memory) {
        return FHE.sealoutput(_privateData[tokenId], auth.publicKey);
    }
}
