# Solidity API

## IFHERC721

_Interface of the ERC-721 standard as defined in the ERC._

### tokenPrivateData

```solidity
function tokenPrivateData(uint256 tokenId, struct Permission auth) external view returns (string)
```

_Returns the private data associated with `tokenId` token, if the caller is allowed to view it._

