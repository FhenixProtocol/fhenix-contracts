# Solidity API

## PermissionedV2TimestampValidator

### userLastRevokedTimestamp

```solidity
mapping(address => uint256) userLastRevokedTimestamp
```

### revokeExisting

```solidity
function revokeExisting() public
```

### disabled

```solidity
function disabled(address issuer, uint256 id) external view returns (bool)
```

_Checks whether a permission is valid, returning `false` disables the permission._

