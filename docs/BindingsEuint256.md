# Solidity API

## BindingsEuint256

### eq

```solidity
function eq(euint256 lhs, euint256 rhs) internal pure returns (ebool)
```

Performs the eq operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint256 | input of type euint256 |
| rhs | euint256 | second input of type euint256 |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the eq |

### ne

```solidity
function ne(euint256 lhs, euint256 rhs) internal pure returns (ebool)
```

Performs the ne operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint256 | input of type euint256 |
| rhs | euint256 | second input of type euint256 |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the ne |

### toBool

```solidity
function toBool(euint256 value) internal pure returns (ebool)
```

### toU8

```solidity
function toU8(euint256 value) internal pure returns (euint8)
```

### toU16

```solidity
function toU16(euint256 value) internal pure returns (euint16)
```

### toU32

```solidity
function toU32(euint256 value) internal pure returns (euint32)
```

### toU64

```solidity
function toU64(euint256 value) internal pure returns (euint64)
```

### toU128

```solidity
function toU128(euint256 value) internal pure returns (euint128)
```

### toEaddress

```solidity
function toEaddress(euint256 value) internal pure returns (eaddress)
```

### seal

```solidity
function seal(euint256 value, bytes32 publicKey) internal pure returns (string)
```

### decrypt

```solidity
function decrypt(euint256 value) internal pure returns (uint256)
```

### decrypt

```solidity
function decrypt(euint256 value, uint256 defaultValue) internal pure returns (uint256)
```

