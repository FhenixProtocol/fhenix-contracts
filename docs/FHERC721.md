# Solidity API

## FHERC721

### constructor

```solidity
constructor(string name, string symbol) public
```

### _baseURI

```solidity
function _baseURI() internal pure returns (string)
```

_Base URI for computing {tokenURI}. If set, the resulting URI for each
token will be the concatenation of the `baseURI` and the `tokenId`. Empty
by default, can be overridden in child contracts._

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

_See {IERC721Metadata-tokenURI}._

### _mint

```solidity
function _mint(address to, uint256 tokenId, struct inEuint256 privateData) internal
```

### tokenPrivateData

```solidity
function tokenPrivateData(uint256 tokenId, struct Permission auth) external view returns (string)
```

_Returns the private data associated with `tokenId` token, if the caller is allowed to view it._

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

