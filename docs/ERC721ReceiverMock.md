# Solidity API

## ERC721ReceiverMock

### RevertType

```solidity
enum RevertType {
  None,
  RevertWithoutMessage,
  RevertWithMessage,
  RevertWithCustomError,
  Panic
}
```

### Received

```solidity
event Received(address operator, address from, uint256 tokenId, bytes data, uint256 gas)
```

### CustomError

```solidity
error CustomError(bytes4)
```

### constructor

```solidity
constructor(bytes4 retval, enum ERC721ReceiverMock.RevertType error) public
```

### onERC721Received

```solidity
function onERC721Received(address operator, address from, uint256 tokenId, bytes data) public returns (bytes4)
```

