// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import { FHE, euint256, inEuint256 } from "../../../FHE.sol";
import { Permissioned, Permission } from "../../../access/Permissioned.sol";
import { IFHERC721 } from "./IFHERC721.sol";

contract FHERC721 is IFHERC721, Permissioned, ERC721 {
    using Strings for uint256;

    mapping(uint256 => euint256) private _privateData;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {}

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString()) : "";
    }

    function _mint(address to, uint256 tokenId, inEuint256 calldata privateData) internal {
        super._mint(to, tokenId);
        _privateData[tokenId] = FHE.asEuint256(privateData);
    }

    function tokenPrivateData(
        uint256 tokenId,
        Permission memory auth
    ) external view onlyPermitted(auth, _ownerOf(tokenId)) returns (string memory) {
        return FHE.sealoutput(_privateData[tokenId], auth.publicKey);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
        return
            interfaceId == type(IFHERC721).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
