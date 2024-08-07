# Solidity API

## Permissioned

Abstract contract that provides EIP-712 based signature verification for access control

_This contract should be inherited by other contracts to provide EIP-712 signature validated access control_

### SignerNotMessageSender

```solidity
error SignerNotMessageSender()
```

Emitted when the signer is not the message sender

### SignerNotOwner

```solidity
error SignerNotOwner()
```

Emitted when the signer is not the specified owner

### constructor

```solidity
constructor() internal
```

_Constructor that initializes EIP712 domain separator with a name and version
solhint-disable-next-line func-visibility, no-empty-blocks_

### onlySender

```solidity
modifier onlySender(struct Permission permission)
```

Modifier that requires the provided signature to be signed by the message sender

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| permission | struct Permission | Data structure containing the public key and the signature to be verified |

### onlyPermitted

```solidity
modifier onlyPermitted(struct Permission permission, address owner)
```

Modifier that requires the provided signature to be signed by a specific owner address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| permission | struct Permission | Data structure containing the public key and the signature to be verified |
| owner | address | The expected owner of the public key to match against the recovered signer |

### onlyBetweenPermitted

```solidity
modifier onlyBetweenPermitted(struct Permission permission, address owner, address permitted)
```

Modifier that requires the provided signature to be signed by one of two specific addresses

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| permission | struct Permission | Data structure containing the public key and the signature to be verified |
| owner | address | The expected owner of the public key to match against the recovered signer |
| permitted | address | A second permitted owner of the public key to match against the recovered signer |

