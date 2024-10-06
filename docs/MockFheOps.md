# Solidity API

## MockFheOps

### maxValue

```solidity
function maxValue(uint8 utype) public pure returns (uint256)
```

### utypeToOffset

```solidity
function utypeToOffset(uint8 utype) internal pure returns (uint256 offset)
```

### bytes32ToBytes

```solidity
function bytes32ToBytes(bytes32 input, uint8) internal pure returns (bytes)
```

### uint256ToBytes

```solidity
function uint256ToBytes(uint256 value) public pure returns (bytes)
```

### boolToBytes

```solidity
function boolToBytes(bool value) public pure returns (bytes)
```

### bytesToUint

```solidity
function bytesToUint(bytes b) internal pure virtual returns (uint256)
```

### bytesToBool

```solidity
function bytesToBool(bytes b) internal pure virtual returns (bool)
```

### trivialEncrypt

```solidity
function trivialEncrypt(bytes input, uint8 toType, int32) external pure returns (bytes)
```

### add

```solidity
function add(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### sealOutput

```solidity
function sealOutput(uint8, bytes ctHash, bytes) external pure returns (string)
```

### verify

```solidity
function verify(uint8, bytes input, int32) external pure returns (bytes)
```

### cast

```solidity
function cast(uint8, bytes input, uint8 toType) external pure returns (bytes)
```

### log

```solidity
function log(string s) external pure
```

### decrypt

```solidity
function decrypt(uint8, bytes input, uint256) external pure returns (uint256)
```

### lte

```solidity
function lte(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### sub

```solidity
function sub(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### mul

```solidity
function mul(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### lt

```solidity
function lt(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### select

```solidity
function select(uint8, bytes controlHash, bytes ifTrueHash, bytes ifFalseHash) external pure returns (bytes)
```

### req

```solidity
function req(uint8, bytes input) external pure returns (bytes)
```

### div

```solidity
function div(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### gt

```solidity
function gt(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### gte

```solidity
function gte(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### rem

```solidity
function rem(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### and

```solidity
function and(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### or

```solidity
function or(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### xor

```solidity
function xor(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### eq

```solidity
function eq(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### ne

```solidity
function ne(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### min

```solidity
function min(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### max

```solidity
function max(uint8 utype, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### shl

```solidity
function shl(uint8, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### shr

```solidity
function shr(uint8, bytes lhsHash, bytes rhsHash) external pure returns (bytes)
```

### not

```solidity
function not(uint8 utype, bytes value) external pure returns (bytes)
```

### getNetworkPublicKey

```solidity
function getNetworkPublicKey(int32) external pure returns (bytes)
```

### random

```solidity
function random(uint8 utype, uint64, int32) external view returns (bytes)
```

