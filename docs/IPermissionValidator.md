# Solidity API

## IPermissionValidator

_Minimum required interface to create a custom permission validator.
Permission validators are optional, and provide extra security and control when sharing permits._

### disabled

```solidity
function disabled(address issuer, uint256 id) external view returns (bool)
```

_Checks whether a permission is valid, returning `false` disables the permission._

