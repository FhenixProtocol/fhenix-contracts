# Solidity API

## FHE

### NIL8

```solidity
euint8 NIL8
```

### NIL16

```solidity
euint16 NIL16
```

### NIL32

```solidity
euint32 NIL32
```

### isInitialized

```solidity
function isInitialized(ebool v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(euint8 v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(euint16 v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(euint32 v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(euint64 v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(euint128 v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(euint256 v) internal pure returns (bool)
```

### isInitialized

```solidity
function isInitialized(eaddress v) internal pure returns (bool)
```

### mathHelper

```solidity
function mathHelper(uint8 utype, uint256 lhs, uint256 rhs, function (uint8,bytes,bytes) pure external returns (bytes) impl) internal pure returns (uint256 result)
```

### add

```solidity
function add(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the add operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### add

```solidity
function add(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the add operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### add

```solidity
function add(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the add operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### add

```solidity
function add(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the add operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### add

```solidity
function add(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the add operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### sealoutput

```solidity
function sealoutput(ebool value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a ebool ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | ebool | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(euint8 value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a euint8 ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | euint8 | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(euint16 value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a euint16 ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | euint16 | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(euint32 value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a euint32 ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | euint32 | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(euint64 value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a euint64 ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | euint64 | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(euint128 value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a euint128 ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | euint128 | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(euint256 value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a euint256 ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | euint256 | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### sealoutput

```solidity
function sealoutput(eaddress value, bytes32 publicKey) internal pure returns (string)
```

performs the sealoutput function on a eaddress ciphertext. This operation returns the plaintext value, sealed for the public key provided

_Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | eaddress | Ciphertext to decrypt and seal |
| publicKey | bytes32 | Public Key that will receive the sealed plaintext |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | Plaintext input, sealed for the owner of `publicKey` |

### decrypt

```solidity
function decrypt(ebool input1) internal pure returns (bool)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | ebool | the input ciphertext |

### decrypt

```solidity
function decrypt(ebool input1, bool defaultValue) internal pure returns (bool)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | ebool | the input ciphertext |
| defaultValue | bool | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(euint8 input1) internal pure returns (uint8)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint8 | the input ciphertext |

### decrypt

```solidity
function decrypt(euint8 input1, uint8 defaultValue) internal pure returns (uint8)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint8 | the input ciphertext |
| defaultValue | uint8 | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(euint16 input1) internal pure returns (uint16)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint16 | the input ciphertext |

### decrypt

```solidity
function decrypt(euint16 input1, uint16 defaultValue) internal pure returns (uint16)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint16 | the input ciphertext |
| defaultValue | uint16 | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(euint32 input1) internal pure returns (uint32)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint32 | the input ciphertext |

### decrypt

```solidity
function decrypt(euint32 input1, uint32 defaultValue) internal pure returns (uint32)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint32 | the input ciphertext |
| defaultValue | uint32 | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(euint64 input1) internal pure returns (uint64)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint64 | the input ciphertext |

### decrypt

```solidity
function decrypt(euint64 input1, uint64 defaultValue) internal pure returns (uint64)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint64 | the input ciphertext |
| defaultValue | uint64 | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(euint128 input1) internal pure returns (uint128)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint128 | the input ciphertext |

### decrypt

```solidity
function decrypt(euint128 input1, uint128 defaultValue) internal pure returns (uint128)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint128 | the input ciphertext |
| defaultValue | uint128 | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(euint256 input1) internal pure returns (uint256)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint256 | the input ciphertext |

### decrypt

```solidity
function decrypt(euint256 input1, uint256 defaultValue) internal pure returns (uint256)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint256 | the input ciphertext |
| defaultValue | uint256 | default value to be returned on gas estimation |

### decrypt

```solidity
function decrypt(eaddress input1) internal pure returns (address)
```

Performs the decrypt operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | eaddress | the input ciphertext |

### decrypt

```solidity
function decrypt(eaddress input1, address defaultValue) internal pure returns (address)
```

Performs the decrypt operation on a ciphertext with default value for gas estimation

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | eaddress | the input ciphertext |
| defaultValue | address | default value to be returned on gas estimation |

### lte

```solidity
function lte(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

This function performs the lte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lte

```solidity
function lte(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

This function performs the lte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lte

```solidity
function lte(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

This function performs the lte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lte

```solidity
function lte(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

This function performs the lte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lte

```solidity
function lte(euint128 lhs, euint128 rhs) internal pure returns (ebool)
```

This function performs the lte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### sub

```solidity
function sub(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the sub operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### sub

```solidity
function sub(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the sub operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### sub

```solidity
function sub(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the sub operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### sub

```solidity
function sub(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the sub operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### sub

```solidity
function sub(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the sub operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### mul

```solidity
function mul(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the mul operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### mul

```solidity
function mul(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the mul operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### mul

```solidity
function mul(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the mul operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### mul

```solidity
function mul(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the mul operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### lt

```solidity
function lt(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

This function performs the lt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lt

```solidity
function lt(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

This function performs the lt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lt

```solidity
function lt(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

This function performs the lt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lt

```solidity
function lt(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

This function performs the lt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### lt

```solidity
function lt(euint128 lhs, euint128 rhs) internal pure returns (ebool)
```

This function performs the lt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### select

```solidity
function select(ebool input1, ebool input2, ebool input3) internal pure returns (ebool)
```

### select

```solidity
function select(ebool input1, euint8 input2, euint8 input3) internal pure returns (euint8)
```

### select

```solidity
function select(ebool input1, euint16 input2, euint16 input3) internal pure returns (euint16)
```

### select

```solidity
function select(ebool input1, euint32 input2, euint32 input3) internal pure returns (euint32)
```

### select

```solidity
function select(ebool input1, euint64 input2, euint64 input3) internal pure returns (euint64)
```

### select

```solidity
function select(ebool input1, euint128 input2, euint128 input3) internal pure returns (euint128)
```

### select

```solidity
function select(ebool input1, euint256 input2, euint256 input3) internal pure returns (euint256)
```

### select

```solidity
function select(ebool input1, eaddress input2, eaddress input3) internal pure returns (eaddress)
```

### req

```solidity
function req(ebool input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | ebool | the input ciphertext |

### req

```solidity
function req(euint8 input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint8 | the input ciphertext |

### req

```solidity
function req(euint16 input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint16 | the input ciphertext |

### req

```solidity
function req(euint32 input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint32 | the input ciphertext |

### req

```solidity
function req(euint64 input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint64 | the input ciphertext |

### req

```solidity
function req(euint128 input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint128 | the input ciphertext |

### req

```solidity
function req(euint256 input1) internal pure
```

Performs the req operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint256 | the input ciphertext |

### div

```solidity
function div(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the div operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### div

```solidity
function div(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the div operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### div

```solidity
function div(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the div operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### gt

```solidity
function gt(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

This function performs the gt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gt

```solidity
function gt(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

This function performs the gt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gt

```solidity
function gt(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

This function performs the gt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gt

```solidity
function gt(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

This function performs the gt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gt

```solidity
function gt(euint128 lhs, euint128 rhs) internal pure returns (ebool)
```

This function performs the gt operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gte

```solidity
function gte(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

This function performs the gte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gte

```solidity
function gte(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

This function performs the gte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gte

```solidity
function gte(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

This function performs the gte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gte

```solidity
function gte(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

This function performs the gte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### gte

```solidity
function gte(euint128 lhs, euint128 rhs) internal pure returns (ebool)
```

This function performs the gte operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### rem

```solidity
function rem(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the rem operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### rem

```solidity
function rem(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the rem operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### rem

```solidity
function rem(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the rem operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### and

```solidity
function and(ebool lhs, ebool rhs) internal pure returns (ebool)
```

This function performs the and operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | The first input |
| rhs | ebool | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### and

```solidity
function and(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the and operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### and

```solidity
function and(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the and operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### and

```solidity
function and(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the and operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### and

```solidity
function and(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the and operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### and

```solidity
function and(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the and operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### or

```solidity
function or(ebool lhs, ebool rhs) internal pure returns (ebool)
```

This function performs the or operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | The first input |
| rhs | ebool | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### or

```solidity
function or(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the or operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### or

```solidity
function or(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the or operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### or

```solidity
function or(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the or operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### or

```solidity
function or(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the or operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### or

```solidity
function or(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the or operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### xor

```solidity
function xor(ebool lhs, ebool rhs) internal pure returns (ebool)
```

This function performs the xor operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | The first input |
| rhs | ebool | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### xor

```solidity
function xor(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the xor operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### xor

```solidity
function xor(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the xor operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### xor

```solidity
function xor(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the xor operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### xor

```solidity
function xor(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the xor operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### xor

```solidity
function xor(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the xor operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### eq

```solidity
function eq(ebool lhs, ebool rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | The first input |
| rhs | ebool | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(euint128 lhs, euint128 rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(euint256 lhs, euint256 rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint256 | The first input |
| rhs | euint256 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### eq

```solidity
function eq(eaddress lhs, eaddress rhs) internal pure returns (ebool)
```

This function performs the eq operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | eaddress | The first input |
| rhs | eaddress | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(ebool lhs, ebool rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | ebool | The first input |
| rhs | ebool | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(euint64 lhs, euint64 rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(euint128 lhs, euint128 rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(euint256 lhs, euint256 rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint256 | The first input |
| rhs | euint256 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### ne

```solidity
function ne(eaddress lhs, eaddress rhs) internal pure returns (ebool)
```

This function performs the ne operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | eaddress | The first input |
| rhs | eaddress | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | The result of the operation |

### min

```solidity
function min(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the min operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### min

```solidity
function min(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the min operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### min

```solidity
function min(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the min operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### min

```solidity
function min(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the min operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### min

```solidity
function min(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the min operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### max

```solidity
function max(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the max operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### max

```solidity
function max(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the max operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### max

```solidity
function max(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the max operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### max

```solidity
function max(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the max operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### max

```solidity
function max(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the max operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### shl

```solidity
function shl(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the shl operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### shl

```solidity
function shl(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the shl operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### shl

```solidity
function shl(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the shl operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### shl

```solidity
function shl(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the shl operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### shl

```solidity
function shl(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the shl operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### shr

```solidity
function shr(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

This function performs the shr operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint8 | The first input |
| rhs | euint8 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | The result of the operation |

### shr

```solidity
function shr(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

This function performs the shr operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint16 | The first input |
| rhs | euint16 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | The result of the operation |

### shr

```solidity
function shr(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

This function performs the shr operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint32 | The first input |
| rhs | euint32 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | The result of the operation |

### shr

```solidity
function shr(euint64 lhs, euint64 rhs) internal pure returns (euint64)
```

This function performs the shr operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint64 | The first input |
| rhs | euint64 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | The result of the operation |

### shr

```solidity
function shr(euint128 lhs, euint128 rhs) internal pure returns (euint128)
```

This function performs the shr operation

_If any of the inputs are expected to be a ciphertext, it verifies that the value matches a valid ciphertext
Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| lhs | euint128 | The first input |
| rhs | euint128 | The second input |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | The result of the operation |

### not

```solidity
function not(ebool input1) internal pure returns (ebool)
```

Performs the not operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | ebool | the input ciphertext |

### not

```solidity
function not(euint8 input1) internal pure returns (euint8)
```

Performs the not operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint8 | the input ciphertext |

### not

```solidity
function not(euint16 input1) internal pure returns (euint16)
```

Performs the not operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint16 | the input ciphertext |

### not

```solidity
function not(euint32 input1) internal pure returns (euint32)
```

Performs the not operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint32 | the input ciphertext |

### not

```solidity
function not(euint64 input1) internal pure returns (euint64)
```

Performs the not operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint64 | the input ciphertext |

### not

```solidity
function not(euint128 input1) internal pure returns (euint128)
```

Performs the not operation on a ciphertext

_Verifies that the input value matches a valid ciphertext. Pure in this function is marked as a hack/workaround - note that this function is NOT pure as fetches of ciphertexts require state access_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| input1 | euint128 | the input ciphertext |

### random

```solidity
function random(uint8 uintType, uint64 seed, int32 securityZone) internal pure returns (uint256)
```

Generates a random value of a given type for the provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| uintType | uint8 | the type of the random value to generate |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### random

```solidity
function random(uint8 uintType, uint64 seed) internal pure returns (uint256)
```

Generates a random value of a given type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| uintType | uint8 | the type of the random value to generate |
| seed | uint64 | the seed to use for the random value |

### randomEuint8

```solidity
function randomEuint8(uint64 seed, int32 securityZone) internal pure returns (euint8)
```

Generates a random value of a euint8 type for provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### randomEuint8

```solidity
function randomEuint8(uint64 seed) internal pure returns (euint8)
```

Generates a random value of a euint8 type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |

### randomEuint16

```solidity
function randomEuint16(uint64 seed, int32 securityZone) internal pure returns (euint16)
```

Generates a random value of a euint16 type for provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### randomEuint16

```solidity
function randomEuint16(uint64 seed) internal pure returns (euint16)
```

Generates a random value of a euint16 type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |

### randomEuint32

```solidity
function randomEuint32(uint64 seed, int32 securityZone) internal pure returns (euint32)
```

Generates a random value of a euint32 type for provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### randomEuint32

```solidity
function randomEuint32(uint64 seed) internal pure returns (euint32)
```

Generates a random value of a euint32 type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |

### randomEuint64

```solidity
function randomEuint64(uint64 seed, int32 securityZone) internal pure returns (euint64)
```

Generates a random value of a euint64 type for provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### randomEuint64

```solidity
function randomEuint64(uint64 seed) internal pure returns (euint64)
```

Generates a random value of a euint64 type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |

### randomEuint128

```solidity
function randomEuint128(uint64 seed, int32 securityZone) internal pure returns (euint128)
```

Generates a random value of a euint128 type for provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### randomEuint128

```solidity
function randomEuint128(uint64 seed) internal pure returns (euint128)
```

Generates a random value of a euint128 type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |

### randomEuint256

```solidity
function randomEuint256(uint64 seed, int32 securityZone) internal pure returns (euint256)
```

Generates a random value of a euint256 type for provided securityZone

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |
| securityZone | int32 | the security zone to use for the random value |

### randomEuint256

```solidity
function randomEuint256(uint64 seed) internal pure returns (euint256)
```

Generates a random value of a euint256 type

_Calls the desired precompile and returns the hash of the ciphertext_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| seed | uint64 | the seed to use for the random value |

### asEbool

```solidity
function asEbool(struct inEbool value) internal pure returns (ebool)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an ebool

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | a ciphertext representation of the input |

### asEuint8

```solidity
function asEuint8(ebool value) internal pure returns (euint8)
```

Converts a ebool to an euint8

### asEuint16

```solidity
function asEuint16(ebool value) internal pure returns (euint16)
```

Converts a ebool to an euint16

### asEuint32

```solidity
function asEuint32(ebool value) internal pure returns (euint32)
```

Converts a ebool to an euint32

### asEuint64

```solidity
function asEuint64(ebool value) internal pure returns (euint64)
```

Converts a ebool to an euint64

### asEuint128

```solidity
function asEuint128(ebool value) internal pure returns (euint128)
```

Converts a ebool to an euint128

### asEuint256

```solidity
function asEuint256(ebool value) internal pure returns (euint256)
```

Converts a ebool to an euint256

### asEbool

```solidity
function asEbool(euint8 value) internal pure returns (ebool)
```

Converts a euint8 to an ebool

### asEuint8

```solidity
function asEuint8(struct inEuint8 value) internal pure returns (euint8)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint8

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | a ciphertext representation of the input |

### asEuint16

```solidity
function asEuint16(euint8 value) internal pure returns (euint16)
```

Converts a euint8 to an euint16

### asEuint32

```solidity
function asEuint32(euint8 value) internal pure returns (euint32)
```

Converts a euint8 to an euint32

### asEuint64

```solidity
function asEuint64(euint8 value) internal pure returns (euint64)
```

Converts a euint8 to an euint64

### asEuint128

```solidity
function asEuint128(euint8 value) internal pure returns (euint128)
```

Converts a euint8 to an euint128

### asEuint256

```solidity
function asEuint256(euint8 value) internal pure returns (euint256)
```

Converts a euint8 to an euint256

### asEbool

```solidity
function asEbool(euint16 value) internal pure returns (ebool)
```

Converts a euint16 to an ebool

### asEuint8

```solidity
function asEuint8(euint16 value) internal pure returns (euint8)
```

Converts a euint16 to an euint8

### asEuint16

```solidity
function asEuint16(struct inEuint16 value) internal pure returns (euint16)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint16

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | a ciphertext representation of the input |

### asEuint32

```solidity
function asEuint32(euint16 value) internal pure returns (euint32)
```

Converts a euint16 to an euint32

### asEuint64

```solidity
function asEuint64(euint16 value) internal pure returns (euint64)
```

Converts a euint16 to an euint64

### asEuint128

```solidity
function asEuint128(euint16 value) internal pure returns (euint128)
```

Converts a euint16 to an euint128

### asEuint256

```solidity
function asEuint256(euint16 value) internal pure returns (euint256)
```

Converts a euint16 to an euint256

### asEbool

```solidity
function asEbool(euint32 value) internal pure returns (ebool)
```

Converts a euint32 to an ebool

### asEuint8

```solidity
function asEuint8(euint32 value) internal pure returns (euint8)
```

Converts a euint32 to an euint8

### asEuint16

```solidity
function asEuint16(euint32 value) internal pure returns (euint16)
```

Converts a euint32 to an euint16

### asEuint32

```solidity
function asEuint32(struct inEuint32 value) internal pure returns (euint32)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint32

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | a ciphertext representation of the input |

### asEuint64

```solidity
function asEuint64(euint32 value) internal pure returns (euint64)
```

Converts a euint32 to an euint64

### asEuint128

```solidity
function asEuint128(euint32 value) internal pure returns (euint128)
```

Converts a euint32 to an euint128

### asEuint256

```solidity
function asEuint256(euint32 value) internal pure returns (euint256)
```

Converts a euint32 to an euint256

### asEbool

```solidity
function asEbool(euint64 value) internal pure returns (ebool)
```

Converts a euint64 to an ebool

### asEuint8

```solidity
function asEuint8(euint64 value) internal pure returns (euint8)
```

Converts a euint64 to an euint8

### asEuint16

```solidity
function asEuint16(euint64 value) internal pure returns (euint16)
```

Converts a euint64 to an euint16

### asEuint32

```solidity
function asEuint32(euint64 value) internal pure returns (euint32)
```

Converts a euint64 to an euint32

### asEuint64

```solidity
function asEuint64(struct inEuint64 value) internal pure returns (euint64)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint64

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | a ciphertext representation of the input |

### asEuint128

```solidity
function asEuint128(euint64 value) internal pure returns (euint128)
```

Converts a euint64 to an euint128

### asEuint256

```solidity
function asEuint256(euint64 value) internal pure returns (euint256)
```

Converts a euint64 to an euint256

### asEbool

```solidity
function asEbool(euint128 value) internal pure returns (ebool)
```

Converts a euint128 to an ebool

### asEuint8

```solidity
function asEuint8(euint128 value) internal pure returns (euint8)
```

Converts a euint128 to an euint8

### asEuint16

```solidity
function asEuint16(euint128 value) internal pure returns (euint16)
```

Converts a euint128 to an euint16

### asEuint32

```solidity
function asEuint32(euint128 value) internal pure returns (euint32)
```

Converts a euint128 to an euint32

### asEuint64

```solidity
function asEuint64(euint128 value) internal pure returns (euint64)
```

Converts a euint128 to an euint64

### asEuint128

```solidity
function asEuint128(struct inEuint128 value) internal pure returns (euint128)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint128

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | a ciphertext representation of the input |

### asEuint256

```solidity
function asEuint256(euint128 value) internal pure returns (euint256)
```

Converts a euint128 to an euint256

### asEbool

```solidity
function asEbool(euint256 value) internal pure returns (ebool)
```

Converts a euint256 to an ebool

### asEuint8

```solidity
function asEuint8(euint256 value) internal pure returns (euint8)
```

Converts a euint256 to an euint8

### asEuint16

```solidity
function asEuint16(euint256 value) internal pure returns (euint16)
```

Converts a euint256 to an euint16

### asEuint32

```solidity
function asEuint32(euint256 value) internal pure returns (euint32)
```

Converts a euint256 to an euint32

### asEuint64

```solidity
function asEuint64(euint256 value) internal pure returns (euint64)
```

Converts a euint256 to an euint64

### asEuint128

```solidity
function asEuint128(euint256 value) internal pure returns (euint128)
```

Converts a euint256 to an euint128

### asEuint256

```solidity
function asEuint256(struct inEuint256 value) internal pure returns (euint256)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint256

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint256 | a ciphertext representation of the input |

### asEaddress

```solidity
function asEaddress(euint256 value) internal pure returns (eaddress)
```

Converts a euint256 to an eaddress

### asEbool

```solidity
function asEbool(eaddress value) internal pure returns (ebool)
```

Converts a eaddress to an ebool

### asEuint8

```solidity
function asEuint8(eaddress value) internal pure returns (euint8)
```

Converts a eaddress to an euint8

### asEuint16

```solidity
function asEuint16(eaddress value) internal pure returns (euint16)
```

Converts a eaddress to an euint16

### asEuint32

```solidity
function asEuint32(eaddress value) internal pure returns (euint32)
```

Converts a eaddress to an euint32

### asEuint64

```solidity
function asEuint64(eaddress value) internal pure returns (euint64)
```

Converts a eaddress to an euint64

### asEuint128

```solidity
function asEuint128(eaddress value) internal pure returns (euint128)
```

Converts a eaddress to an euint128

### asEuint256

```solidity
function asEuint256(eaddress value) internal pure returns (euint256)
```

Converts a eaddress to an euint256

### asEaddress

```solidity
function asEaddress(struct inEaddress value) internal pure returns (eaddress)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an eaddress

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | eaddress | a ciphertext representation of the input |

### asEbool

```solidity
function asEbool(uint256 value) internal pure returns (ebool)
```

Converts a uint256 to an ebool

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEbool

```solidity
function asEbool(uint256 value, int32 securityZone) internal pure returns (ebool)
```

Converts a uint256 to an ebool, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint8

```solidity
function asEuint8(uint256 value) internal pure returns (euint8)
```

Converts a uint256 to an euint8

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint8

```solidity
function asEuint8(uint256 value, int32 securityZone) internal pure returns (euint8)
```

Converts a uint256 to an euint8, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint16

```solidity
function asEuint16(uint256 value) internal pure returns (euint16)
```

Converts a uint256 to an euint16

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint16

```solidity
function asEuint16(uint256 value, int32 securityZone) internal pure returns (euint16)
```

Converts a uint256 to an euint16, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint32

```solidity
function asEuint32(uint256 value) internal pure returns (euint32)
```

Converts a uint256 to an euint32

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint32

```solidity
function asEuint32(uint256 value, int32 securityZone) internal pure returns (euint32)
```

Converts a uint256 to an euint32, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint64

```solidity
function asEuint64(uint256 value) internal pure returns (euint64)
```

Converts a uint256 to an euint64

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint64

```solidity
function asEuint64(uint256 value, int32 securityZone) internal pure returns (euint64)
```

Converts a uint256 to an euint64, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint128

```solidity
function asEuint128(uint256 value) internal pure returns (euint128)
```

Converts a uint256 to an euint128

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint128

```solidity
function asEuint128(uint256 value, int32 securityZone) internal pure returns (euint128)
```

Converts a uint256 to an euint128, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint256

```solidity
function asEuint256(uint256 value) internal pure returns (euint256)
```

Converts a uint256 to an euint256

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEuint256

```solidity
function asEuint256(uint256 value, int32 securityZone) internal pure returns (euint256)
```

Converts a uint256 to an euint256, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEaddress

```solidity
function asEaddress(uint256 value) internal pure returns (eaddress)
```

Converts a uint256 to an eaddress

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEaddress

```solidity
function asEaddress(uint256 value, int32 securityZone) internal pure returns (eaddress)
```

Converts a uint256 to an eaddress, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

### asEbool

```solidity
function asEbool(bytes value, int32 securityZone) internal pure returns (ebool)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an ebool

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | a ciphertext representation of the input |

### asEuint8

```solidity
function asEuint8(bytes value, int32 securityZone) internal pure returns (euint8)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint8

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint8 | a ciphertext representation of the input |

### asEuint16

```solidity
function asEuint16(bytes value, int32 securityZone) internal pure returns (euint16)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint16

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint16 | a ciphertext representation of the input |

### asEuint32

```solidity
function asEuint32(bytes value, int32 securityZone) internal pure returns (euint32)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint32

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint32 | a ciphertext representation of the input |

### asEuint64

```solidity
function asEuint64(bytes value, int32 securityZone) internal pure returns (euint64)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint64

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint64 | a ciphertext representation of the input |

### asEuint128

```solidity
function asEuint128(bytes value, int32 securityZone) internal pure returns (euint128)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint128

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint128 | a ciphertext representation of the input |

### asEuint256

```solidity
function asEuint256(bytes value, int32 securityZone) internal pure returns (euint256)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an euint256

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | euint256 | a ciphertext representation of the input |

### asEaddress

```solidity
function asEaddress(bytes value, int32 securityZone) internal pure returns (eaddress)
```

Parses input ciphertexts from the user. Converts from encrypted raw bytes to an eaddress

_Also performs validation that the ciphertext is valid and has been encrypted using the network encryption key_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | eaddress | a ciphertext representation of the input |

### asEaddress

```solidity
function asEaddress(address value) internal pure returns (eaddress)
```

Converts a address to an eaddress

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
Allows for a better user experience when working with eaddresses_

### asEaddress

```solidity
function asEaddress(address value, int32 securityZone) internal pure returns (eaddress)
```

Converts a address to an eaddress, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation
Allows for a better user experience when working with eaddresses_

### asEbool

```solidity
function asEbool(bool value) internal pure returns (ebool)
```

Converts a plaintext boolean value to a ciphertext ebool

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | A ciphertext representation of the input |

### asEbool

```solidity
function asEbool(bool value, int32 securityZone) internal pure returns (ebool)
```

Converts a plaintext boolean value to a ciphertext ebool, specifying security zone

_Privacy: The input value is public, therefore the resulting ciphertext should be considered public until involved in an fhe operation_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | ebool | A ciphertext representation of the input |

