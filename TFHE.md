# Solidity API

## TFHE

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

### getValue

```solidity
function getValue(bytes a) internal pure returns (uint256 value)
```

### mathHelper

```solidity
function mathHelper(uint256 lhs, uint256 rhs, function (bytes) pure external returns (bytes) impl) internal pure returns (uint256 result)
```

### add

```solidity
function add(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### add

```solidity
function add(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### add

```solidity
function add(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### reencrypt

```solidity
function reencrypt(ebool value, bytes32 publicKey) internal pure returns (bytes)
```

### reencrypt

```solidity
function reencrypt(euint8 value, bytes32 publicKey) internal pure returns (bytes)
```

### reencrypt

```solidity
function reencrypt(euint16 value, bytes32 publicKey) internal pure returns (bytes)
```

### reencrypt

```solidity
function reencrypt(euint32 value, bytes32 publicKey) internal pure returns (bytes)
```

### decrypt

```solidity
function decrypt(ebool input1) internal pure returns (bool)
```

### decrypt

```solidity
function decrypt(euint8 input1) internal pure returns (uint8)
```

### decrypt

```solidity
function decrypt(euint16 input1) internal pure returns (uint16)
```

### decrypt

```solidity
function decrypt(euint32 input1) internal pure returns (uint32)
```

### lte

```solidity
function lte(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

### lte

```solidity
function lte(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

### lte

```solidity
function lte(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

### sub

```solidity
function sub(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### sub

```solidity
function sub(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### sub

```solidity
function sub(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### mul

```solidity
function mul(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### mul

```solidity
function mul(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### mul

```solidity
function mul(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### lt

```solidity
function lt(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

### lt

```solidity
function lt(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

### lt

```solidity
function lt(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

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

### req

```solidity
function req(ebool input1) internal pure
```

### req

```solidity
function req(euint8 input1) internal pure
```

### req

```solidity
function req(euint16 input1) internal pure
```

### req

```solidity
function req(euint32 input1) internal pure
```

### div

```solidity
function div(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### div

```solidity
function div(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### div

```solidity
function div(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### gt

```solidity
function gt(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

### gt

```solidity
function gt(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

### gt

```solidity
function gt(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

### gte

```solidity
function gte(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

### gte

```solidity
function gte(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

### gte

```solidity
function gte(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

### rem

```solidity
function rem(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### rem

```solidity
function rem(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### rem

```solidity
function rem(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### and

```solidity
function and(ebool lhs, ebool rhs) internal pure returns (ebool)
```

### and

```solidity
function and(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### and

```solidity
function and(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### and

```solidity
function and(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### or

```solidity
function or(ebool lhs, ebool rhs) internal pure returns (ebool)
```

### or

```solidity
function or(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### or

```solidity
function or(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### or

```solidity
function or(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### xor

```solidity
function xor(ebool lhs, ebool rhs) internal pure returns (ebool)
```

### xor

```solidity
function xor(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### xor

```solidity
function xor(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### xor

```solidity
function xor(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### eq

```solidity
function eq(ebool lhs, ebool rhs) internal pure returns (ebool)
```

### eq

```solidity
function eq(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

### eq

```solidity
function eq(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

### eq

```solidity
function eq(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

### ne

```solidity
function ne(ebool lhs, ebool rhs) internal pure returns (ebool)
```

### ne

```solidity
function ne(euint8 lhs, euint8 rhs) internal pure returns (ebool)
```

### ne

```solidity
function ne(euint16 lhs, euint16 rhs) internal pure returns (ebool)
```

### ne

```solidity
function ne(euint32 lhs, euint32 rhs) internal pure returns (ebool)
```

### min

```solidity
function min(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### min

```solidity
function min(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### min

```solidity
function min(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### max

```solidity
function max(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### max

```solidity
function max(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### max

```solidity
function max(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### shl

```solidity
function shl(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### shl

```solidity
function shl(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### shl

```solidity
function shl(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### shr

```solidity
function shr(euint8 lhs, euint8 rhs) internal pure returns (euint8)
```

### shr

```solidity
function shr(euint16 lhs, euint16 rhs) internal pure returns (euint16)
```

### shr

```solidity
function shr(euint32 lhs, euint32 rhs) internal pure returns (euint32)
```

### not

```solidity
function not(ebool value) internal pure returns (ebool)
```

### not

```solidity
function not(euint8 input1) internal pure returns (euint8)
```

### not

```solidity
function not(euint16 input1) internal pure returns (euint16)
```

### not

```solidity
function not(euint32 input1) internal pure returns (euint32)
```

### asEuint8

```solidity
function asEuint8(ebool value) internal pure returns (euint8)
```

### asEuint16

```solidity
function asEuint16(ebool value) internal pure returns (euint16)
```

### asEuint32

```solidity
function asEuint32(ebool value) internal pure returns (euint32)
```

### asEbool

```solidity
function asEbool(euint8 value) internal pure returns (ebool)
```

### asEuint16

```solidity
function asEuint16(euint8 value) internal pure returns (euint16)
```

### asEuint32

```solidity
function asEuint32(euint8 value) internal pure returns (euint32)
```

### asEbool

```solidity
function asEbool(euint16 value) internal pure returns (ebool)
```

### asEuint8

```solidity
function asEuint8(euint16 value) internal pure returns (euint8)
```

### asEuint32

```solidity
function asEuint32(euint16 value) internal pure returns (euint32)
```

### asEbool

```solidity
function asEbool(euint32 value) internal pure returns (ebool)
```

### asEuint8

```solidity
function asEuint8(euint32 value) internal pure returns (euint8)
```

### asEuint16

```solidity
function asEuint16(euint32 value) internal pure returns (euint16)
```

### asEbool

```solidity
function asEbool(uint256 value) internal pure returns (ebool)
```

### asEuint8

```solidity
function asEuint8(uint256 value) internal pure returns (euint8)
```

### asEuint16

```solidity
function asEuint16(uint256 value) internal pure returns (euint16)
```

### asEuint32

```solidity
function asEuint32(uint256 value) internal pure returns (euint32)
```

### asEbool

```solidity
function asEbool(bytes value) internal pure returns (ebool)
```

### asEuint8

```solidity
function asEuint8(bytes value) internal pure returns (euint8)
```

### asEuint16

```solidity
function asEuint16(bytes value) internal pure returns (euint16)
```

### asEuint32

```solidity
function asEuint32(bytes value) internal pure returns (euint32)
```

### asEbool

```solidity
function asEbool(bool value) internal pure returns (ebool)
```

