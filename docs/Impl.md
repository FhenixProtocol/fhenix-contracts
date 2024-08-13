# Solidity API

## Impl

### sealoutput

```solidity
function sealoutput(uint8 utype, uint256 ciphertext, bytes32 publicKey) internal pure returns (string reencrypted)
```

### verify

```solidity
function verify(bytes _ciphertextBytes, uint8 _toType, int32 securityZone) internal pure returns (uint256 result)
```

### cast

```solidity
function cast(uint8 utype, uint256 ciphertext, uint8 toType) internal pure returns (uint256 result)
```

### getValue

```solidity
function getValue(bytes a) internal pure returns (uint256 value)
```

### trivialEncrypt

```solidity
function trivialEncrypt(uint256 value, uint8 toType, int32 securityZone) internal pure returns (uint256 result)
```

### select

```solidity
function select(uint8 utype, uint256 control, uint256 ifTrue, uint256 ifFalse) internal pure returns (uint256 result)
```
