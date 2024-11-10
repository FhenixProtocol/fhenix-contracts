# Solidity API

## PermissionV2

_Permission body that must be passed to a contract to allow access to sensitive data.

The minimum permission to access a user's own data requires the fields
< issuer, expiration, contracts, projects, sealingKey, issuerSignature >

`contracts` and `projects` are lists defining which contracts can be accessed with this permission.
`projects` is a list of strings, each of which defines and provides access to a group of contracts.

  ---

If not sharing the permission, `issuer` signs a signature using the fields:
    < issuer, expiration, contracts, projects, recipient, validatorId, validatorContract, sealingKey >
This signature can now be used by `issuer` to access their own encrypted data.

  ---

Sharing a permission is a two step process: `issuer` completes step 1, and `recipient` completes step 2.

1:
`issuer` creates a permission with `recipient` populated with the address of the user to give access to.
`issuer` does not include a `sealingKey` in the permission, it will be populated by the `recipient`.
`issuer` is still responsible for defining the permission's access through `contracts` and `projects`.
`issuer` signs a signature including the fields: (note: `sealingKey` is absent in this signature)
    < issuer, expiration, contracts, projects, recipient, validatorId, validatorContract >
`issuer` packages the permission data and `issuerSignature` and shares it with `recipient`
    ** None of this data is sensitive, and can be shared as cleartext **

2:
`recipient` adds their `sealingKey` to the data received from `issuer`
`recipient` signs a signature including the fields:
    < sealingKey, issuerSignature >
`recipient` can now use the completed Permission to access `issuer`s encrypted data.

  ---

`validatorId` and `validatorContract` are optional and can be used together to 
increase security and control by disabling a permission after it has been created.
Useful when sharing permits to provide external access to sensitive data (eg auditors)._

```solidity
struct PermissionV2 {
  address issuer;
  uint64 expiration;
  address[] contracts;
  string[] projects;
  address recipient;
  uint256 validatorId;
  address validatorContract;
  bytes32 sealingKey;
  bytes issuerSignature;
  bytes recipientSignature;
}
```

