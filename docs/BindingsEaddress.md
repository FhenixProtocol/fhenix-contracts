# Solidity API

## BindingsEaddress

### eq

```solidity
function eq(eaddress lhs, eaddress rhs) internal pure returns (ebool)
```

Performs the eq operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | eaddress | input of type eaddress |
| rhs | eaddress | second input of type eaddress |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the eq |

### ne

```solidity
function ne(eaddress lhs, eaddress rhs) internal pure returns (ebool)
```

Performs the ne operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | eaddress | input of type eaddress |
| rhs | eaddress | second input of type eaddress |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the ne |

### toBool

```solidity
function toBool(eaddress value) internal pure returns (ebool)
```

### toU8

```solidity
function toU8(eaddress value) internal pure returns (euint8)
```

### toU16

```solidity
function toU16(eaddress value) internal pure returns (euint16)
```

### toU32

```solidity
function toU32(eaddress value) internal pure returns (euint32)
```

### toU64

```solidity
function toU64(eaddress value) internal pure returns (euint64)
```

### toU128

```solidity
function toU128(eaddress value) internal pure returns (euint128)
```

### toU256

```solidity
function toU256(eaddress value) internal pure returns (euint256)
```

### seal

```solidity
function seal(eaddress value, bytes32 publicKey) internal pure returns (string)
```

### decrypt

```solidity
function decrypt(eaddress value) internal pure returns (address)
```

### decrypt

```solidity
function decrypt(eaddress value, address defaultValue) internal pure returns (address)
```

