# Solidity API

## PermissionedV2RevokableValidator

### rid

```solidity
uint256 rid
```

### revoked

```solidity
mapping(uint256 => bool) revoked
```

### owner

```solidity
mapping(uint256 => address) owner
```

### createRevokableId

```solidity
function createRevokableId() public returns (uint256)
```

### revokeId

```solidity
function revokeId(uint256 id) public
```

### disabled

```solidity
function disabled(address, uint256 id) external view returns (bool)
```

