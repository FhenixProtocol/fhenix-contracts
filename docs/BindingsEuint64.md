# Solidity API

## BindingsEuint64

### add

```solidity
function add(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the add operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the add |

### mul

```solidity
function mul(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the mul operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the mul |

### div

```solidity
function div(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the div operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the div |

### sub

```solidity
function sub(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the sub operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the sub |

### eq

```solidity
function eq(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

Performs the eq operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the eq |

### ne

```solidity
function ne(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

Performs the ne operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the ne |

### and

```solidity
function and(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the and operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the and |

### or

```solidity
function or(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the or operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the or |

### xor

```solidity
function xor(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the xor operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the xor |

### gt

```solidity
function gt(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

Performs the gt operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the gt |

### gte

```solidity
function gte(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

Performs the gte operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the gte |

### lt

```solidity
function lt(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

Performs the lt operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the lt |

### lte

```solidity
function lte(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

Performs the lte operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | the result of the lte |

### rem

```solidity
function rem(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the rem operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the rem |

### max

```solidity
function max(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the max operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the max |

### min

```solidity
function min(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the min operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the min |

### shl

```solidity
function shl(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the shl operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the shl |

### shr

```solidity
function shr(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

Performs the shr operation

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | input of type euint64 |
| rhs | euint64 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | the result of the shr |

### toBool

```solidity
function toBool(euint64 value) internal pure returns (ebool)
```

### toU8

```solidity
function toU8(euint64 value) internal pure returns (euint8)
```

### toU16

```solidity
function toU16(euint64 value) internal pure returns (euint16)
```

### toU32

```solidity
function toU32(euint64 value) internal pure returns (euint32)
```

### toU128

```solidity
function toU128(euint64 value) internal pure returns (euint128)
```

### toU256

```solidity
function toU256(euint64 value) internal pure returns (euint256)
```

### seal

```solidity
function seal(euint64 value, bytes32 publicKey) internal pure returns (bytes)
```

### decrypt

```solidity
function decrypt(euint64 value) internal pure returns (uint64)
```

