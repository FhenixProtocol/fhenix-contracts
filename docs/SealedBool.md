# Solidity API

## SealedBool

_Utility structure providing clients with type context of a sealed output string.
Returned from `FHE.sealoutputTyped` and `sealTyped` within the bindings.
`utype` representing Bool is 13. See `FHE.sol` for more._

```solidity
struct SealedBool {
  string data;
  uint8 utype;
}
```

