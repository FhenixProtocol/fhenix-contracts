# Solidity API

## SealedUint

_Utility structure providing clients with type context of a sealed output string.
Returned from `FHE.sealoutputTyped` and `sealTyped` within the bindings.
`utype` representing Uints is 0-5. See `FHE.sol` for more.
`utype` map: {uint8: 0} {uint16: 1} {uint32: 2} {uint64: 3} {uint128: 4} {uint256: 5}._

```solidity
struct SealedUint {
  string data;
  uint8 utype;
}
```

