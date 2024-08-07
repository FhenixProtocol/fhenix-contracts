# Solidity API

## BindingsEbool

### eq

```solidity
function eq(ebool lhs, ebool rhs) internal pure returns (ebool)
```

Performs the eq operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | input of type ebool |
| rhs | ebool |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the eq |

### ne

```solidity
function ne(ebool lhs, ebool rhs) internal pure returns (ebool)
```

Performs the ne operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | input of type ebool |
| rhs | ebool |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the ne |

### and

```solidity
function and(ebool lhs, ebool rhs) internal pure returns (ebool)
```

Performs the and operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | input of type ebool |
| rhs | ebool |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the and |

### or

```solidity
function or(ebool lhs, ebool rhs) internal pure returns (ebool)
```

Performs the or operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | input of type ebool |
| rhs | ebool |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the or |

### xor

```solidity
function xor(ebool lhs, ebool rhs) internal pure returns (ebool)
```

Performs the xor operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | input of type ebool |
| rhs | ebool |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the xor |

### toU8

```solidity
function toU8(ebool value) internal pure returns (euint8)
```

### toU16

```solidity
function toU16(ebool value) internal pure returns (euint16)
```

### toU32

```solidity
function toU32(ebool value) internal pure returns (euint32)
```

### toU64

```solidity
function toU64(ebool value) internal pure returns (euint64)
```

### toU128

```solidity
function toU128(ebool value) internal pure returns (euint128)
```

### toU256

```solidity
function toU256(ebool value) internal pure returns (euint256)
```

### seal

```solidity
function seal(ebool value, bytes32 publicKey) internal pure returns (string)
```

### decrypt

```solidity
function decrypt(ebool value) internal pure returns (bool)
```

