# Solidity API

## Eaddress

_A representation of an encrypted address using Fully Homomorphic Encryption.
It consists of 5 encrypted 32-bit unsigned integers (`euint32`)._

```solidity
struct Eaddress {
  euint32[5] values;
}
```

