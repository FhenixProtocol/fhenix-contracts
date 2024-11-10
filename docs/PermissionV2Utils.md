# Solidity API

## PermissionV2Utils

_Internal utility library to improve the readability of PermissionedV2
Primarily focused on signature type hashes_

### issuerHash

```solidity
function issuerHash(struct PermissionV2 permission) internal pure returns (bytes32)
```

### issuerSelfHash

```solidity
function issuerSelfHash(struct PermissionV2 permission) internal pure returns (bytes32)
```

### issuerSharedHash

```solidity
function issuerSharedHash(struct PermissionV2 permission) internal pure returns (bytes32)
```

### recipientHash

```solidity
function recipientHash(struct PermissionV2 permission) internal pure returns (bytes32)
```

### satisfies

```solidity
function satisfies(struct PermissionV2 permission, address addr, string proj) internal pure returns (bool)
```

### encodeArray

```solidity
function encodeArray(address[] items) internal pure returns (bytes32)
```

### encodeArray

```solidity
function encodeArray(string[] items) internal pure returns (bytes32)
```

