# Solidity API

## Signature

Used to pass both the public key and signature data within transactions

_Should be used with Signature-based modifiers for access control_

```solidity
struct Signature {
  bytes32 publicKey;
  bytes sig;
}
```

