# Solidity API

## SealedAddress

_Utility structure providing clients with type context of a sealed output string.
Return type of `FHE.sealoutputTyped` and `sealTyped` within the binding libraries.
`utype` representing Address is 12. See `FHE.sol` for more._

```solidity
struct SealedAddress {
  string data;
  uint8 utype;
}
```

