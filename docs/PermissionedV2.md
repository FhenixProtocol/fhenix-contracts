# Solidity API

## PermissionedV2

_Uses a modified version of openzeppelin's EIP712 contract which disables the `verifyingContract`.
Instead, access is checked using the `contracts` and `projects` fields of the `PermissionV2` struct.
This allows a single signed permission to be used to access multiple contracts encrypted data._

### version

```solidity
string version
```

Version of the fhenix permission signature

### project

```solidity
string project
```

This contract's project identifier string. Used in permissions to grant access to all contracts with this identifier.

### constructor

```solidity
constructor(string proj) public
```

_Constructor that initializes the EIP712 domain. The EIP712 implementation used has `verifyingContract` disabled
by replacing it with `address(0)`. Ensure that `verifyingContract` is the ZeroAddress when creating a user's signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| proj | string | The project identifier string to be associated with this contract. Any Permission with this project identifier in `permission.projects` list will be granted access to this contract's data. Use an empty string for no project identifier. |

### PermissionInvalid_ContractUnauthorized

```solidity
error PermissionInvalid_ContractUnauthorized()
```

_Emitted when `project` is not in `permission.projects` nor `address(this)` in `permission.contracts`_

### PermissionInvalid_Expired

```solidity
error PermissionInvalid_Expired()
```

_Emitted when `permission.expiration` is in the past (< block.timestamp)_

### PermissionInvalid_IssuerSignature

```solidity
error PermissionInvalid_IssuerSignature()
```

_Emitted when `issuerSignature` is malformed or was not signed by `permission.issuer`_

### PermissionInvalid_RecipientSignature

```solidity
error PermissionInvalid_RecipientSignature()
```

_Emitted when `recipientSignature` is malformed or was not signed by `permission.recipient`_

### PermissionInvalid_Disabled

```solidity
error PermissionInvalid_Disabled()
```

_Emitted when `validatorContract` returned `false` indicating that this permission has been externally disabled_

### withPermission

```solidity
modifier withPermission(struct PermissionV2 permission)
```

_Validate's a `permissions` access of sensitive data.
`permission` may be invalid or unauthorized for the following reasons:
   - Contract unauthorized:    `project` is not in `permission.projects` nor address(this) in `permission.contracts`
   - Expired:                  `permission.expiration` is in the past (< block.timestamp)
   - Issuer signature:         `issuerSignature` is malformed or was not signed by `permission.issuer`
   - Recipient signature:      `recipientSignature` is malformed or was not signed by `permission.recipient`
   - Disabled:                 `validatorContract` returned `false` indicating that this permission has been externally disabled_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| permission | struct PermissionV2 | PermissionV2 struct containing data necessary to validate data access and seal for return. NOTE: Functions protected by `withPermission` should return ONLY the sensitive data of `permission.issuer`. !! Returning data of `msg.sender` will leak sensitive values - `msg.sender` cannot be trusted in view functions !! |

### checkPermissionSatisfies

```solidity
function checkPermissionSatisfies(struct PermissionV2 permission) external view returns (bool)
```

_Utility function used to check whether a permission provides access to this contract.
Intended to be used before real data is fetched to preempt a reversion, but is not necessary to use._

