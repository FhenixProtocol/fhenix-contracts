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

### onlySignedPublicKey

```solidity
modifier onlySignedPublicKey(struct Permission permission)
```

Modifier that requires the provided signature to be signed by the message sender

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| permission | struct Permission | Data structure containing the public key and the signature to be verified |

### onlySignedPublicKeyOwner

```solidity
modifier onlySignedPublicKeyOwner(struct Permission permission, address owner)
```

Modifier that requires the provided signature to be signed by a specific owner address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| permission | struct Permission | Data structure containing the public key and the signature to be verified |
| owner | address | The expected owner of the public key to match against the recovered signer |

